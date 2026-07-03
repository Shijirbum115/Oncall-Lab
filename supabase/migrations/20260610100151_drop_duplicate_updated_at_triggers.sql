-- Reconstructed 2026-07-03 from supabase_migrations.schema_migrations
-- (original file was on the Windows machine and never committed).

-- These four tables each had two identical BEFORE UPDATE triggers calling
-- update_updated_at_column(); keep one per table.
drop trigger if exists update_profiles_updated_at on public.profiles;
drop trigger if exists update_services_updated_at on public.services;
drop trigger if exists update_laboratories_updated_at on public.laboratories;
drop trigger if exists update_doctor_profiles_updated_at on public.doctor_profiles;
