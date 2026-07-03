-- Block privilege escalation via profiles.role.
-- The "Users can update own profile" RLS policy permits any column update,
-- including role. This trigger rejects role changes unless the actor is
-- service_role or an existing admin.

CREATE OR REPLACE FUNCTION public.guard_profile_role_change()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF auth.role() = 'service_role' THEN
    RETURN NEW;
  END IF;

  IF public.is_admin() THEN
    RETURN NEW;
  END IF;

  RAISE EXCEPTION 'Only admins can change profile role'
    USING ERRCODE = '42501';
END;
$$;

REVOKE ALL ON FUNCTION public.guard_profile_role_change() FROM PUBLIC;

DROP TRIGGER IF EXISTS guard_profile_role_change ON public.profiles;

CREATE TRIGGER guard_profile_role_change
  BEFORE UPDATE OF role ON public.profiles
  FOR EACH ROW
  WHEN (OLD.role IS DISTINCT FROM NEW.role)
  EXECUTE FUNCTION public.guard_profile_role_change();
