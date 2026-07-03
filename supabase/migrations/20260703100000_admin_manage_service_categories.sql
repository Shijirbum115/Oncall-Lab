-- Allow admins to manage service categories from the admin CMS.
-- service_categories previously had only the public SELECT policy, so even
-- admins could not INSERT/UPDATE categories through the API (unlike services,
-- which already has "Admins can manage services" / is_admin()).

create policy "Admins can manage service categories"
  on public.service_categories
  for all
  using (public.is_admin())
  with check (public.is_admin());
