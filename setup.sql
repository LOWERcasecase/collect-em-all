-- =====================================================================
--  My Collectapedia: Supabase setup
--  1. Replace YOUR-EMAIL@example.com below (one place) with the email
--     address you will sign in with. Only that email can make changes.
--  2. Paste this whole file into Supabase > SQL Editor > New query > Run.
--  It is safe to run again later.
-- =====================================================================

-- Who is the owner?
create or replace function public.is_owner() returns boolean
language sql stable as $$
  select lower(coalesce(auth.jwt() ->> 'email', '')) = lower('clevercaseyy@gmail.com')
$$;

-- Your collection data (cards, binders, settings, picture list)
create table if not exists public.kv (
  path       text primary key,
  data       jsonb not null,
  updated_at timestamptz not null default now()
);
alter table public.kv enable row level security;

drop policy if exists "Anyone can view"  on public.kv;
drop policy if exists "Owner can add"    on public.kv;
drop policy if exists "Owner can change" on public.kv;
drop policy if exists "Owner can delete" on public.kv;
create policy "Anyone can view"  on public.kv for select using (true);
create policy "Owner can add"    on public.kv for insert with check (public.is_owner());
create policy "Owner can change" on public.kv for update using (public.is_owner()) with check (public.is_owner());
create policy "Owner can delete" on public.kv for delete using (public.is_owner());

-- Live updates for visitors
do $$ begin
  alter publication supabase_realtime add table public.kv;
exception when duplicate_object then null;
end $$;

-- Picture storage (public to view, only the owner can upload/delete)
insert into storage.buckets (id, name, public)
values ('pictures', 'pictures', true)
on conflict (id) do update set public = true;

drop policy if exists "Owner uploads pictures" on storage.objects;
drop policy if exists "Owner reads pictures"   on storage.objects;
drop policy if exists "Owner deletes pictures" on storage.objects;
create policy "Owner uploads pictures" on storage.objects for insert to authenticated
  with check (bucket_id = 'pictures' and public.is_owner());
create policy "Owner reads pictures" on storage.objects for select to authenticated
  using (bucket_id = 'pictures' and public.is_owner());
create policy "Owner deletes pictures" on storage.objects for delete to authenticated
  using (bucket_id = 'pictures' and public.is_owner());
