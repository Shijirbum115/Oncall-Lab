"use server";

import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/auth";
import { phoneToEmail } from "@/lib/format";

export type DoctorFormState = { error: string } | { success: true } | null;

function readDoctorFields(formData: FormData) {
  const str = (name: string) => String(formData.get(name) ?? "").trim();
  const firstName = str("first_name");
  const lastName = str("last_name");
  const years = str("work_experience_years");
  return {
    firstName,
    lastName,
    fullName: `${firstName} ${lastName}`.trim(),
    email: str("email") || null,
    profession: str("profession"),
    licenseNumber: str("license_number"),
    academicDegree: str("academic_degree") || null,
    workExperienceYears: years ? Number(years) : null,
    professionalDevelopment: str("professional_development") || null,
  };
}

export async function createDoctor(
  _prev: DoctorFormState,
  formData: FormData,
): Promise<DoctorFormState> {
  await requireAdmin();

  const fields = readDoctorFields(formData);
  const phone = String(formData.get("phone") ?? "").trim().replaceAll(" ", "");
  const password = String(formData.get("password") ?? "");

  if (!/^\d{8}$/.test(phone)) {
    return { error: "Phone number must be 8 digits (e.g. 99123456)." };
  }
  if (password.length < 6) {
    return { error: "Password must be at least 6 characters." };
  }
  if (!fields.firstName || !fields.lastName) {
    return { error: "First and last name are required." };
  }
  if (!fields.profession || !fields.licenseNumber) {
    return { error: "Profession and license number are required." };
  }

  let admin;
  try {
    admin = createAdminClient();
  } catch (e) {
    return { error: e instanceof Error ? e.message : "Admin key missing." };
  }

  const { data: created, error: authError } =
    await admin.auth.admin.createUser({
      email: phoneToEmail(phone),
      password,
      email_confirm: true,
    });

  if (authError || !created.user) {
    return {
      error: `Could not create login: ${authError?.message ?? "unknown error"}`,
    };
  }

  const userId = created.user.id;

  const { error: profileError } = await admin.from("profiles").insert({
    id: userId,
    role: "doctor",
    phone_number: phone,
    first_name: fields.firstName,
    last_name: fields.lastName,
    full_name: fields.fullName,
    email: fields.email,
    is_active: true,
    is_verified: true, // admin-created doctors are pre-verified
  });

  const { error: doctorError } = profileError
    ? { error: profileError }
    : await admin.from("doctor_profiles").insert({
        id: userId,
        profession: fields.profession,
        license_number: fields.licenseNumber,
        academic_degree: fields.academicDegree,
        work_experience_years: fields.workExperienceYears,
        professional_development: fields.professionalDevelopment,
        rating: 0,
        total_reviews: 0,
        total_completed_requests: 0,
        is_available: false,
      });

  if (profileError || doctorError) {
    // Roll back the half-created account so the phone number isn't burned
    await admin.auth.admin.deleteUser(userId);
    return {
      error: `Could not create doctor profile: ${(profileError ?? doctorError)?.message}`,
    };
  }

  revalidatePath("/doctors");
  revalidatePath("/");
  return { success: true };
}

export async function updateDoctor(
  doctorId: string,
  _prev: DoctorFormState,
  formData: FormData,
): Promise<DoctorFormState> {
  await requireAdmin();
  const supabase = await createClient();

  const fields = readDoctorFields(formData);
  if (!fields.firstName || !fields.lastName) {
    return { error: "First and last name are required." };
  }
  if (!fields.profession || !fields.licenseNumber) {
    return { error: "Profession and license number are required." };
  }

  const { error: profileError } = await supabase
    .from("profiles")
    .update({
      first_name: fields.firstName,
      last_name: fields.lastName,
      full_name: fields.fullName,
      email: fields.email,
    })
    .eq("id", doctorId)
    .eq("role", "doctor");

  if (profileError) return { error: profileError.message };

  const { error: doctorError } = await supabase
    .from("doctor_profiles")
    .update({
      profession: fields.profession,
      license_number: fields.licenseNumber,
      academic_degree: fields.academicDegree,
      work_experience_years: fields.workExperienceYears,
      professional_development: fields.professionalDevelopment,
    })
    .eq("id", doctorId);

  if (doctorError) return { error: doctorError.message };

  revalidatePath("/doctors");
  return { success: true };
}

export async function deleteDoctor(doctorId: string) {
  await requireAdmin();

  let admin;
  try {
    admin = createAdminClient();
  } catch (e) {
    return { error: e instanceof Error ? e.message : "Admin key missing." };
  }

  // Deleting the auth user cascades to profiles and doctor_profiles
  const { error } = await admin.auth.admin.deleteUser(doctorId);
  if (error) return { error: error.message };

  revalidatePath("/doctors");
  revalidatePath("/");
  return { error: null };
}

export async function setDoctorVerified(doctorId: string, verified: boolean) {
  await requireAdmin();
  const supabase = await createClient();

  const { error } = await supabase
    .from("profiles")
    .update({ is_verified: verified })
    .eq("id", doctorId)
    .eq("role", "doctor");

  if (error) return { error: error.message };

  // A freshly rejected/unverified doctor should not stay bookable
  if (!verified) {
    await supabase
      .from("doctor_profiles")
      .update({ is_available: false })
      .eq("id", doctorId);
  }

  revalidatePath("/doctors");
  revalidatePath("/");
  return { error: null };
}

export async function setDoctorActive(doctorId: string, active: boolean) {
  await requireAdmin();
  const supabase = await createClient();

  const { error } = await supabase
    .from("profiles")
    .update({ is_active: active })
    .eq("id", doctorId)
    .eq("role", "doctor");

  if (error) return { error: error.message };

  revalidatePath("/doctors");
  revalidatePath("/");
  return { error: null };
}
