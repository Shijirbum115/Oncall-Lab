-- Migration: Update get_available_doctors() to respect doctor_availability schedule
-- Date: 2026-01-12
-- Description: Enhances the get_available_doctors() function to check time-based availability
--              from the doctor_availability table. Now supports filtering by scheduled date/time.

-- Drop the existing function
DROP FUNCTION IF EXISTS public.get_available_doctors(date);

-- Recreate with enhanced logic that respects doctor_availability table
CREATE OR REPLACE FUNCTION public.get_available_doctors(
  p_scheduled_date date DEFAULT CURRENT_DATE,
  p_scheduled_time time DEFAULT NULL
)
RETURNS TABLE(
  id uuid,
  full_name character varying,
  phone_number character varying,
  profession character varying,
  rating numeric,
  total_reviews integer,
  total_completed_requests integer,
  is_available boolean,
  doctor_type doctor_type,
  avatar_url text,
  gender character varying
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $function$
DECLARE
  v_day_of_week availability_day;
BEGIN
  -- Determine day of week from scheduled date
  v_day_of_week := (
    CASE EXTRACT(DOW FROM p_scheduled_date)
      WHEN 0 THEN 'sunday'
      WHEN 1 THEN 'monday'
      WHEN 2 THEN 'tuesday'
      WHEN 3 THEN 'wednesday'
      WHEN 4 THEN 'thursday'
      WHEN 5 THEN 'friday'
      WHEN 6 THEN 'saturday'
    END
  )::availability_day;

  RETURN QUERY
  SELECT
    p.id,
    p.full_name,
    p.phone_number,
    dp.profession,
    dp.rating,
    dp.total_reviews,
    dp.total_completed_requests,
    dp.is_available,
    dp.doctor_type,
    p.avatar_url,
    p.gender
  FROM doctor_profiles dp
  INNER JOIN profiles p ON p.id = dp.id
  WHERE
    -- Basic filters
    dp.is_available = true
    AND p.is_verified = true
    AND p.is_active = true
    AND p.role = 'doctor'
    -- Time-based availability check (if scheduled_time provided)
    AND (
      p_scheduled_time IS NULL -- If no time specified, skip availability check
      OR EXISTS (
        SELECT 1
        FROM doctor_availability da
        WHERE da.doctor_id = dp.id
          AND da.day_of_week = v_day_of_week
          AND da.is_active = true
          AND p_scheduled_time >= da.start_time
          AND p_scheduled_time <= da.end_time
      )
    )
  ORDER BY dp.rating DESC, dp.total_completed_requests DESC;
END;
$function$;

-- Add comment explaining the function
COMMENT ON FUNCTION public.get_available_doctors(date, time) IS
'Returns available doctors filtered by basic availability flags and optionally by scheduled time.
If p_scheduled_time is provided, only returns doctors with matching doctor_availability schedule.
If p_scheduled_time is NULL, returns all doctors who have is_available=true (24/7 availability).';

-- Grant execute permissions
GRANT EXECUTE ON FUNCTION public.get_available_doctors(date, time) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_available_doctors(date, time) TO anon;
