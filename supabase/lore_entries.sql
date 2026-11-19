-- Opcional. La app funciona sin esto (usa el contenido integrado).
-- Si creas la tabla, cualquier fila con la misma "key" que una página de la app
-- reemplaza su title / body / note. Solo lectura pública: la app nunca escribe.
create table if not exists public.lore_entries (
  key        text primary key,   -- p. ej. 'personaje_falin', 'capitulo_05', 'region_laguna'
  title      text,
  body       text,
  note       text,               -- "Nota de Maya"
  updated_at timestamptz default now()
);

alter table public.lore_entries enable row level security;

create policy "lectura publica de lore"
  on public.lore_entries for select
  to anon, authenticated
  using (true);

-- Ejemplo:
-- insert into public.lore_entries (key, note)
-- values ('personaje_falin', 'Nota actualizada desde Supabase')
-- on conflict (key) do update set note = excluded.note;
