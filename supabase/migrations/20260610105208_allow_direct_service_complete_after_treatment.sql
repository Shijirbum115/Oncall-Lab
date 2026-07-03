-- Reconstructed 2026-07-03 from supabase_migrations.schema_migrations
-- (original file was on the Windows machine and never committed).

create or replace function public.validate_status_transition()
returns trigger
language plpgsql
set search_path to 'public', 'pg_temp'
as $function$
declare
  transition_key text;
  valid_transitions text[];
begin
  transition_key := old.status || '->' || new.status;

  valid_transitions := array[
    'pending->accepted',
    'pending->cancelled',
    'accepted->on_the_way',
    'accepted->cancelled',
    'on_the_way->sample_collected',
    'on_the_way->cancelled',
    'sample_collected->delivered_to_lab',
    'sample_collected->cancelled',
    'delivered_to_lab->completed',
    'delivered_to_lab->cancelled'
  ];

  -- Direct (home treatment) services have no lab leg: treatment done -> completed
  if new.request_type = 'direct_service' then
    valid_transitions := valid_transitions || 'sample_collected->completed';
  end if;

  if transition_key != all(valid_transitions) then
    raise exception 'Invalid status transition from % to %. Attempted transition: %',
      old.status, new.status, transition_key;
  end if;

  return new;
end;
$function$;
