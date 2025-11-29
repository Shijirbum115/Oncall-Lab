begin;

-- remove dependent view so we can rebuild without test_types
 drop view if exists public.admin_dashboard_stats;

-- legacy column no longer used; requests reference services/laboratory_services instead
 alter table if exists public.test_requests
   drop column if exists test_type_id;

-- remove duplicated catalog
 drop table if exists public.test_types;

-- recreate dashboard view relying only on canonical services data
 create view public.admin_dashboard_stats as
 select
   (select count(*) from public.profiles where role = 'patient'::user_role) as total_patients,
   (select count(*) from public.profiles where role = 'doctor'::user_role) as total_doctors,
   (select count(*) from public.services where coalesce(is_active, true) = true) as total_services,
   (
     select count(*)
     from public.services s
     join public.service_categories c on c.id = s.category_id
     where coalesce(s.is_active, true) = true
       and c.type = 'lab_test'
   ) as total_tests,
   (select count(*) from public.laboratories where coalesce(is_active, true) = true) as total_laboratories,
   (
     select count(*)
     from public.doctor_profiles
     where doctor_type = 'nurse'::doctor_type
   ) as total_nurses,
   (select count(*) from public.test_requests) as total_requests,
   (select count(*) from public.test_requests where status = 'pending'::request_status) as pending_requests,
   (select count(*) from public.test_requests where status = 'accepted'::request_status) as accepted_requests,
   (select count(*) from public.test_requests where status = 'completed'::request_status) as completed_requests,
   (select count(*) from public.test_requests where status = 'cancelled'::request_status) as cancelled_requests;

commit;
