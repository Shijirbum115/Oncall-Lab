"use server";

import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";
import { requireAdmin } from "@/lib/auth";
import type { Database } from "@/lib/database.types";

export type ServiceFormState = { error: string } | { success: true } | null;

type CategoryType = Database["public"]["Enums"]["service_category_type"];

const CATEGORY_TYPES: CategoryType[] = [
  "lab_test",
  "diagnostic_procedure",
  "nursing_care",
];

function readServiceFields(formData: FormData) {
  const str = (name: string) => String(formData.get(name) ?? "").trim();
  const duration = str("estimated_duration_minutes");
  return {
    categoryId: str("category_id"),
    name: str("name"),
    nameMn: str("name_mn") || null,
    description: str("description") || null,
    descriptionMn: str("description_mn") || null,
    sampleType: str("sample_type") || null,
    preparationInstructions: str("preparation_instructions") || null,
    estimatedDurationMinutes: duration ? Number(duration) : null,
    priceMnt: Number(str("price_mnt")),
  };
}

function validateService(fields: ReturnType<typeof readServiceFields>) {
  if (!fields.categoryId) return "Category is required.";
  if (!fields.name) return "Name is required.";
  if (!Number.isInteger(fields.priceMnt) || fields.priceMnt <= 0) {
    return "Price must be a positive whole number of MNT.";
  }
  if (
    fields.estimatedDurationMinutes != null &&
    (!Number.isInteger(fields.estimatedDurationMinutes) ||
      fields.estimatedDurationMinutes <= 0)
  ) {
    return "Duration must be a positive number of minutes.";
  }
  return null;
}

export async function createService(
  _prev: ServiceFormState,
  formData: FormData,
): Promise<ServiceFormState> {
  await requireAdmin();
  const supabase = await createClient();

  const fields = readServiceFields(formData);
  const invalid = validateService(fields);
  if (invalid) return { error: invalid };

  // The patient app reads prices from laboratory_services, so every service
  // needs a price row attached to the partner laboratory.
  const { data: lab, error: labError } = await supabase
    .from("laboratories")
    .select("id")
    .eq("is_active", true)
    .limit(1)
    .single();
  if (labError || !lab) {
    return { error: "No active laboratory found to attach the price to." };
  }

  const { data: service, error: serviceError } = await supabase
    .from("services")
    .insert({
      category_id: fields.categoryId,
      name: fields.name,
      name_mn: fields.nameMn,
      description: fields.description,
      description_mn: fields.descriptionMn,
      sample_type: fields.sampleType,
      preparation_instructions: fields.preparationInstructions,
      estimated_duration_minutes: fields.estimatedDurationMinutes,
      is_active: true,
    })
    .select("id")
    .single();
  if (serviceError || !service) {
    return { error: `Could not create service: ${serviceError?.message}` };
  }

  const { error: priceError } = await supabase
    .from("laboratory_services")
    .insert({
      laboratory_id: lab.id,
      service_id: service.id,
      price_mnt: fields.priceMnt,
      is_available: true,
    });
  if (priceError) {
    // Roll back the orphan service so the catalog stays consistent
    await supabase.from("services").delete().eq("id", service.id);
    return { error: `Could not set price: ${priceError.message}` };
  }

  revalidatePath("/services");
  return { success: true };
}

export async function updateService(
  serviceId: string,
  _prev: ServiceFormState,
  formData: FormData,
): Promise<ServiceFormState> {
  await requireAdmin();
  const supabase = await createClient();

  const fields = readServiceFields(formData);
  const invalid = validateService(fields);
  if (invalid) return { error: invalid };

  const { error: serviceError } = await supabase
    .from("services")
    .update({
      category_id: fields.categoryId,
      name: fields.name,
      name_mn: fields.nameMn,
      description: fields.description,
      description_mn: fields.descriptionMn,
      sample_type: fields.sampleType,
      preparation_instructions: fields.preparationInstructions,
      estimated_duration_minutes: fields.estimatedDurationMinutes,
      updated_at: new Date().toISOString(),
    })
    .eq("id", serviceId);
  if (serviceError) return { error: serviceError.message };

  const { data: priceRows, error: priceReadError } = await supabase
    .from("laboratory_services")
    .update({
      price_mnt: fields.priceMnt,
      updated_at: new Date().toISOString(),
    })
    .eq("service_id", serviceId)
    .select("id");
  if (priceReadError) return { error: priceReadError.message };

  if (!priceRows?.length) {
    // Service predates the price row or lost it — attach one now
    const { data: lab } = await supabase
      .from("laboratories")
      .select("id")
      .eq("is_active", true)
      .limit(1)
      .single();
    if (lab) {
      await supabase.from("laboratory_services").insert({
        laboratory_id: lab.id,
        service_id: serviceId,
        price_mnt: fields.priceMnt,
        is_available: true,
      });
    }
  }

  revalidatePath("/services");
  return { success: true };
}

export async function setServiceActive(serviceId: string, active: boolean) {
  await requireAdmin();
  const supabase = await createClient();

  const { error } = await supabase
    .from("services")
    .update({ is_active: active, updated_at: new Date().toISOString() })
    .eq("id", serviceId);
  if (error) return { error: error.message };

  revalidatePath("/services");
  return { error: null };
}

export async function deleteService(serviceId: string) {
  await requireAdmin();
  const supabase = await createClient();

  // Price/link rows first, then the service itself
  const { error: linkError } = await supabase
    .from("laboratory_services")
    .delete()
    .eq("service_id", serviceId);
  if (linkError) return { error: linkError.message };

  const { error } = await supabase.from("services").delete().eq("id", serviceId);
  if (error) {
    // Most likely referenced by existing requests
    return {
      error:
        "Could not delete — the service is referenced by existing requests. Deactivate it instead.",
    };
  }

  revalidatePath("/services");
  return { error: null };
}

export async function createCategory(
  _prev: ServiceFormState,
  formData: FormData,
): Promise<ServiceFormState> {
  await requireAdmin();
  const supabase = await createClient();

  const name = String(formData.get("name") ?? "").trim();
  const nameMn = String(formData.get("name_mn") ?? "").trim() || null;
  const type = String(formData.get("type") ?? "") as CategoryType;
  const iconName = String(formData.get("icon_name") ?? "").trim() || null;

  if (!name) return { error: "Name is required." };
  if (!CATEGORY_TYPES.includes(type)) return { error: "Invalid category type." };

  const { error } = await supabase.from("service_categories").insert({
    name,
    name_mn: nameMn,
    type,
    icon_name: iconName,
  });
  if (error) return { error: error.message };

  revalidatePath("/services");
  return { success: true };
}

export async function updateCategory(
  categoryId: string,
  _prev: ServiceFormState,
  formData: FormData,
): Promise<ServiceFormState> {
  await requireAdmin();
  const supabase = await createClient();

  const name = String(formData.get("name") ?? "").trim();
  const nameMn = String(formData.get("name_mn") ?? "").trim() || null;
  const type = String(formData.get("type") ?? "") as CategoryType;
  const iconName = String(formData.get("icon_name") ?? "").trim() || null;

  if (!name) return { error: "Name is required." };
  if (!CATEGORY_TYPES.includes(type)) return { error: "Invalid category type." };

  const { error } = await supabase
    .from("service_categories")
    .update({
      name,
      name_mn: nameMn,
      type,
      icon_name: iconName,
      updated_at: new Date().toISOString(),
    })
    .eq("id", categoryId);
  if (error) return { error: error.message };

  revalidatePath("/services");
  return { success: true };
}
