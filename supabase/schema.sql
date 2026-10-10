-- STR standalone backend schema. Apply to a NEW Supabase project for STR only.
create extension if not exists pgcrypto;

create table if not exists public.str_profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null default 'Новый герой' check (char_length(display_name) between 1 and 32),
  city text not null default 'Астана' check (char_length(city) between 2 and 80),
  gender text not null default 'male' check (gender in ('male','female')),
  loadout jsonb not null default '{"clothes":"haori","armor":"none","weapon":"katana","outfitColor":"#9d273b","rotation":0}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.str_inventory (
  user_id uuid not null references auth.users(id) on delete cascade,
  item_id text not null,
  quantity integer not null default 1 check (quantity > 0),
  acquired_at timestamptz not null default now(),
  primary key (user_id, item_id)
);

create table if not exists public.str_city_messages (
  id uuid primary key default gen_random_uuid(),
  city text not null check (char_length(city) between 2 and 80),
  user_id uuid not null references auth.users(id) on delete cascade,
  body text not null check (char_length(body) between 1 and 1000),
  created_at timestamptz not null default now()
);

create index if not exists str_city_messages_city_created_idx
  on public.str_city_messages (lower(city), created_at desc);
create index if not exists str_profiles_city_idx on public.str_profiles (lower(city));

alter table public.str_profiles enable row level security;
alter table public.str_inventory enable row level security;
alter table public.str_city_messages enable row level security;

drop policy if exists "STR profiles visible to signed-in users" on public.str_profiles;
create policy "STR profiles visible to signed-in users"
  on public.str_profiles for select to authenticated using (true);
drop policy if exists "STR users create own profile" on public.str_profiles;
create policy "STR users create own profile"
  on public.str_profiles for insert to authenticated with check (auth.uid() = id);
drop policy if exists "STR users update own profile" on public.str_profiles;
create policy "STR users update own profile"
  on public.str_profiles for update to authenticated using (auth.uid() = id) with check (auth.uid() = id);

drop policy if exists "STR inventory private to owner" on public.str_inventory;
create policy "STR inventory private to owner"
  on public.str_inventory for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "STR city members read city chat" on public.str_city_messages;
create policy "STR city members read city chat"
  on public.str_city_messages for select to authenticated
  using (exists (select 1 from public.str_profiles p where p.id = auth.uid() and lower(p.city) = lower(str_city_messages.city)));
drop policy if exists "STR city members send as themselves" on public.str_city_messages;
create policy "STR city members send as themselves"
  on public.str_city_messages for insert to authenticated
  with check (
    auth.uid() = user_id and
    exists (select 1 from public.str_profiles p where p.id = auth.uid() and lower(p.city) = lower(str_city_messages.city))
  );

create or replace function public.str_touch_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;
drop trigger if exists str_profiles_touch_updated_at on public.str_profiles;
create trigger str_profiles_touch_updated_at before update on public.str_profiles
for each row execute function public.str_touch_updated_at();

-- Enable Realtime for city messages. Safe to rerun if already added.
do $$
begin
  alter publication supabase_realtime add table public.str_city_messages;
exception when duplicate_object then null;
end $$;
