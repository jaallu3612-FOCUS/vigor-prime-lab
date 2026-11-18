-- Vigor Prime Lab · Supabase schema
-- Run this file in Supabase SQL Editor. Row Level Security keeps each user's data private.

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  goal text,
  experience_level text,
  height_cm numeric(5,2),
  current_weight_kg numeric(5,2),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.workouts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  workout_date date not null default current_date,
  duration_minutes integer,
  notes text,
  created_at timestamptz not null default now()
);

create table if not exists public.workout_exercises (
  id uuid primary key default gen_random_uuid(),
  workout_id uuid not null references public.workouts(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  exercise_name text not null,
  sets integer,
  reps text,
  weight_kg numeric(7,2),
  rest_seconds integer,
  notes text,
  sort_order integer not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.body_metrics (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  measured_at date not null default current_date,
  weight_kg numeric(6,2),
  body_fat_pct numeric(5,2),
  waist_cm numeric(6,2),
  notes text,
  created_at timestamptz not null default now()
);

create table if not exists public.meals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  eaten_at timestamptz not null default now(),
  meal_type text,
  description text not null,
  calories integer,
  protein_g numeric(7,2),
  carbs_g numeric(7,2),
  fat_g numeric(7,2),
  created_at timestamptz not null default now()
);

create table if not exists public.sleep_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  sleep_date date not null default current_date,
  hours numeric(4,2) not null,
  quality integer check (quality between 1 and 5),
  notes text,
  created_at timestamptz not null default now()
);

create table if not exists public.user_goals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  goal_type text not null,
  target_value numeric(10,2),
  unit text,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.workouts enable row level security;
alter table public.workout_exercises enable row level security;
alter table public.body_metrics enable row level security;
alter table public.meals enable row level security;
alter table public.sleep_logs enable row level security;
alter table public.user_goals enable row level security;

drop policy if exists "profile owner access" on public.profiles;
create policy "profile owner access" on public.profiles
for all to authenticated using (id = auth.uid()) with check (id = auth.uid());

drop policy if exists "workouts owner access" on public.workouts;
create policy "workouts owner access" on public.workouts
for all to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists "workout exercises owner access" on public.workout_exercises;
create policy "workout exercises owner access" on public.workout_exercises
for all to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists "body metrics owner access" on public.body_metrics;
create policy "body metrics owner access" on public.body_metrics
for all to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists "meals owner access" on public.meals;
create policy "meals owner access" on public.meals
for all to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists "sleep logs owner access" on public.sleep_logs;
create policy "sleep logs owner access" on public.sleep_logs
for all to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists "goals owner access" on public.user_goals;
create policy "goals owner access" on public.user_goals
for all to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());

create index if not exists workouts_user_date_idx on public.workouts(user_id, workout_date desc);
create index if not exists body_metrics_user_date_idx on public.body_metrics(user_id, measured_at desc);
create index if not exists meals_user_date_idx on public.meals(user_id, eaten_at desc);
create index if not exists sleep_logs_user_date_idx on public.sleep_logs(user_id, sleep_date desc);
