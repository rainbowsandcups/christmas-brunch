-- Christmas Brunch: eine Zeile pro Gast. Sonntage, Anzahl Personen und was mitgebracht wird.
-- Läuft im selben Supabase-Projekt wie Tassen-Dienstag. Einmal im SQL Editor ausführen.

create table if not exists public.brunch_people (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(name) between 1 and 40),
  days date[] not null default '{}' check (cardinality(days) <= 10),
  party smallint not null default 1 check (party between 1 and 10),
  brings text not null default '' check (char_length(brings) <= 80),
  category text check (category in ('suess', 'salzig', 'trinken', 'anderes')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.brunch_people enable row level security;

-- Die Seite nutzt nur den öffentlichen Schlüssel.
-- Erlaubt: lesen, Namen hinzufügen, Sonntage/Personen/Mitbringsel ändern. Nicht erlaubt: löschen, Namen ändern.
revoke all on public.brunch_people from anon;
grant select, insert on public.brunch_people to anon;
grant update (days, party, brings, category, updated_at) on public.brunch_people to anon;

drop policy if exists "alle lesen" on public.brunch_people;
drop policy if exists "alle eintragen" on public.brunch_people;
drop policy if exists "alle bearbeiten" on public.brunch_people;
create policy "alle lesen" on public.brunch_people for select to anon using (true);
create policy "alle eintragen" on public.brunch_people for insert to anon with check (true);
create policy "alle bearbeiten" on public.brunch_people for update to anon using (true) with check (true);

do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'brunch_people'
  ) then
    alter publication supabase_realtime add table public.brunch_people;
  end if;
end $$;

insert into public.brunch_people (name, created_at)
select v.name, now() + (v.pos * interval '1 second')
from (values (1, 'Eileen'), (2, 'Lissy'), (3, 'Iris'), (4, 'Sisi')) as v(pos, name)
where not exists (select 1 from public.brunch_people p where p.name = v.name);
