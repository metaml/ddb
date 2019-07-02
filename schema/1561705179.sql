create table if not exists log (
  id serial not null primary key,
  guid uuid not null default uuid_generate_v4(),
  source text not null,
  input jsonb not null,
  output jsonb not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger set_timestamp
  before update on log
  for each row
  execute procedure trigger_set_timestamp();
