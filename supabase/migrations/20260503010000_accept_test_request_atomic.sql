-- Atomic doctor-accept RPC. Closes the race where two doctors UPDATE the same
-- pending request simultaneously: the WHERE clause re-evaluates after the first
-- transaction commits, and the loser sees zero rows and gets a clear error.
-- Existing log_request_status_change BEFORE UPDATE trigger sets accepted_at,
-- and validate_status_transition allows pending->accepted.

CREATE OR REPLACE FUNCTION public.accept_test_request(p_request_id uuid)
RETURNS public.test_requests
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_caller uuid := auth.uid();
  v_role public.user_role;
  v_row public.test_requests;
BEGIN
  IF v_caller IS NULL THEN
    RAISE EXCEPTION 'Not authenticated' USING ERRCODE = '42501';
  END IF;

  SELECT role INTO v_role FROM public.profiles WHERE id = v_caller;
  IF v_role NOT IN ('doctor', 'admin') THEN
    RAISE EXCEPTION 'Only doctors can accept requests' USING ERRCODE = '42501';
  END IF;

  UPDATE public.test_requests
  SET doctor_id = v_caller,
      status = 'accepted'
  WHERE id = p_request_id
    AND status = 'pending'
    AND (doctor_id IS NULL OR doctor_id = v_caller)
  RETURNING * INTO v_row;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Request is no longer available'
      USING ERRCODE = 'P0002';
  END IF;

  RETURN v_row;
END;
$$;

REVOKE ALL ON FUNCTION public.accept_test_request(uuid) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.accept_test_request(uuid) TO authenticated;
