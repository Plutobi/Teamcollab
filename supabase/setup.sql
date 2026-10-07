-- Classboard database setup.
-- Run this once in Supabase: SQL Editor -> New query -> paste -> Run.

-- Every item on a board (sticky, shape, drawing, arrow, text) is one row.
create table if not exists public.items (
  board      text        not null check (char_length(board) between 1 and 40),
  id         text        not null check (char_length(id) between 1 and 40),
  data       jsonb       not null check (pg_column_size(data) < 200000),
  updated_at timestamptz not null default now(),
  primary key (board, id)
);

-- One row per board: its name and the shared class timer.
create table if not exists public.boards (
  id         text primary key check (char_length(id) between 1 and 40),
  title      text check (char_length(title) <= 60),
  timer      jsonb,
  updated_at timestamptz not null default now()
);

-- Anyone with the link can view and edit boards (students need no accounts).
alter table public.items  enable row level security;
alter table public.boards enable row level security;

drop policy if exists "items read"   on public.items;
drop policy if exists "items insert" on public.items;
drop policy if exists "items update" on public.items;
drop policy if exists "items delete" on public.items;
create policy "items read"   on public.items for select to anon, authenticated using (true);
create policy "items insert" on public.items for insert to anon, authenticated with check (true);
create policy "items update" on public.items for update to anon, authenticated using (true) with check (true);
create policy "items delete" on public.items for delete to anon, authenticated using (true);

drop policy if exists "boards read"   on public.boards;
drop policy if exists "boards insert" on public.boards;
drop policy if exists "boards update" on public.boards;
create policy "boards read"   on public.boards for select to anon, authenticated using (true);
create policy "boards insert" on public.boards for insert to anon, authenticated with check (true);
create policy "boards update" on public.boards for update to anon, authenticated using (true) with check (true);

-- Send changes to everyone who has the board open.
alter table public.items replica identity full;
do $$
begin
  if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and tablename = 'items') then
    alter publication supabase_realtime add table public.items;
  end if;
  if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and tablename = 'boards') then
    alter publication supabase_realtime add table public.boards;
  end if;
end $$;
