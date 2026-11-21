-- Cristomar Floor Board: database setup.
-- Run once in Supabase: SQL Editor > New query > paste all of this > Run.

-- One generic table. The board stores rugs, the team list and WIP limits as documents.
create table if not exists public.docs (
  path        text primary key,              -- e.g. 'rugs/abc123', 'config/team'
  collection  text not null,                 -- e.g. 'rugs', 'config'
  id          text not null,
  data        jsonb not null default '{}'::jsonb,
  updated_at  timestamptz not null default now()
);
create index if not exists docs_collection_idx on public.docs (collection);

-- Only signed-in shop users can touch anything.
alter table public.docs enable row level security;
drop policy if exists "signed-in users have full access" on public.docs;
create policy "signed-in users have full access"
  on public.docs for all to authenticated
  using (true) with check (true);

-- Partial updates: merges the given fields into a document (used for card edits).
create or replace function public.merge_doc(p_path text, p_patch jsonb)
returns void
language sql
security invoker
set search_path = public
as $$
  update public.docs
     set data = data || p_patch, updated_at = now()
   where path = p_path;
$$;
revoke all on function public.merge_doc(text, jsonb) from public, anon;
grant execute on function public.merge_doc(text, jsonb) to authenticated;

-- Live updates so every phone, tablet and TV refreshes instantly.
do $$
begin
  alter publication supabase_realtime add table public.docs;
exception when duplicate_object then null;
end $$;
