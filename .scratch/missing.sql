create table if not exists public.abliteration_keys (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  api_key text not null,
  status text not null default 'active',
  priority integer not null default 0,
  last_used_at timestamptz,
  last_error text,
  cooldown_until timestamptz,
  label text,
  notes text
);
alter table public.abliteration_keys enable row level security;
grant select, insert, update, delete on public.abliteration_keys to authenticated;
grant all on public.abliteration_keys to service_role;
create policy "abliteration_keys_admin_all" on public.abliteration_keys for all to authenticated using (public.has_role(auth.uid(),'admin')) with check (public.has_role(auth.uid(),'admin'));

create table if not exists public.agent_checkpoints (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  run_id uuid,
  user_id uuid,
  step_number integer not null default 0,
  fingerprint text,
  last_action text,
  state jsonb default '{}'::jsonb
);
alter table public.agent_checkpoints enable row level security;
grant select, insert, update, delete on public.agent_checkpoints to authenticated;
grant all on public.agent_checkpoints to service_role;
create policy "agent_checkpoints_owner_select" on public.agent_checkpoints for select to authenticated using (auth.uid() = user_id);
create policy "agent_checkpoints_owner_insert" on public.agent_checkpoints for insert to authenticated with check (auth.uid() = user_id);
create policy "agent_checkpoints_owner_update" on public.agent_checkpoints for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "agent_checkpoints_owner_delete" on public.agent_checkpoints for delete to authenticated using (auth.uid() = user_id);

create table if not exists public.agent_credentials (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  user_id uuid,
  site text not null,
  site_url text,
  login_email text,
  username text,
  password text,
  notes text,
  created_by text default 'user'
);
alter table public.agent_credentials enable row level security;
grant select, insert, update, delete on public.agent_credentials to authenticated;
grant all on public.agent_credentials to service_role;
create policy "agent_credentials_owner_select" on public.agent_credentials for select to authenticated using (auth.uid() = user_id);
create policy "agent_credentials_owner_insert" on public.agent_credentials for insert to authenticated with check (auth.uid() = user_id);
create policy "agent_credentials_owner_update" on public.agent_credentials for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "agent_credentials_owner_delete" on public.agent_credentials for delete to authenticated using (auth.uid() = user_id);

create table if not exists public.agent_memory (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  user_id uuid,
  domain text,
  kind text,
  key text,
  value text,
  content text,
  confidence numeric default 0.6,
  hits integer default 0,
  source_run_id uuid,
  last_used_at timestamptz
);
alter table public.agent_memory enable row level security;
grant select, insert, update, delete on public.agent_memory to authenticated;
grant all on public.agent_memory to service_role;
create policy "agent_memory_owner_select" on public.agent_memory for select to authenticated using (auth.uid() = user_id);
create policy "agent_memory_owner_insert" on public.agent_memory for insert to authenticated with check (auth.uid() = user_id);
create policy "agent_memory_owner_update" on public.agent_memory for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "agent_memory_owner_delete" on public.agent_memory for delete to authenticated using (auth.uid() = user_id);

create table if not exists public.agent_plans (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  run_id uuid,
  user_id uuid,
  goal text,
  steps jsonb default '{}'::jsonb,
  review jsonb default '{}'::jsonb
);
alter table public.agent_plans enable row level security;
grant select, insert, update, delete on public.agent_plans to authenticated;
grant all on public.agent_plans to service_role;
create policy "agent_plans_owner_select" on public.agent_plans for select to authenticated using (auth.uid() = user_id);
create policy "agent_plans_owner_insert" on public.agent_plans for insert to authenticated with check (auth.uid() = user_id);
create policy "agent_plans_owner_update" on public.agent_plans for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "agent_plans_owner_delete" on public.agent_plans for delete to authenticated using (auth.uid() = user_id);

create table if not exists public.agent_questions (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  run_id uuid,
  user_id uuid,
  question text not null,
  reason text,
  options jsonb default '[]'::jsonb,
  sensitive boolean default false,
  status text not null default 'open',
  answer text,
  asked_at timestamptz not null default now(),
  answered_at timestamptz
);
alter table public.agent_questions enable row level security;
grant select, insert, update, delete on public.agent_questions to authenticated;
grant all on public.agent_questions to service_role;
create policy "agent_questions_owner_select" on public.agent_questions for select to authenticated using (auth.uid() = user_id);
create policy "agent_questions_owner_insert" on public.agent_questions for insert to authenticated with check (auth.uid() = user_id);
create policy "agent_questions_owner_update" on public.agent_questions for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "agent_questions_owner_delete" on public.agent_questions for delete to authenticated using (auth.uid() = user_id);

create table if not exists public.agent_tick_config (
  id boolean primary key default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  secret text,
  constraint agent_tick_config_singleton check (id)
);
alter table public.agent_tick_config enable row level security;
grant select, insert, update, delete on public.agent_tick_config to authenticated;
grant all on public.agent_tick_config to service_role;
create policy "agent_tick_config_admin_all" on public.agent_tick_config for all to authenticated using (public.has_role(auth.uid(),'admin')) with check (public.has_role(auth.uid(),'admin'));

create table if not exists public.alibaba_video_models (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  slug text not null,
  provider text default 'alibaba',
  model_id_api text,
  is_active boolean default true,
  sort_order integer default 0,
  name text,
  metadata jsonb default '{}'::jsonb
);
alter table public.alibaba_video_models enable row level security;
grant select, insert, update, delete on public.alibaba_video_models to authenticated;
grant all on public.alibaba_video_models to service_role;
create policy "alibaba_video_models_admin_all" on public.alibaba_video_models for all to authenticated using (public.has_role(auth.uid(),'admin')) with check (public.has_role(auth.uid(),'admin'));

create table if not exists public.app_updates (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  title text not null,
  description text,
  media_url text,
  media_type text,
  published boolean default false,
  published_at timestamptz
);
alter table public.app_updates enable row level security;
grant select, insert, update, delete on public.app_updates to authenticated;
grant all on public.app_updates to service_role;
create policy "app_updates_admin_all" on public.app_updates for all to authenticated using (public.has_role(auth.uid(),'admin')) with check (public.has_role(auth.uid(),'admin'));
create policy "app_updates_read_published" on public.app_updates for select to authenticated using (published = true);

create table if not exists public.browser_use_keys (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  api_key text not null,
  status text not null default 'active',
  priority integer default 0,
  failure_count integer default 0,
  last_used_at timestamptz,
  last_error text,
  cooldown_until timestamptz,
  label text,
  notes text
);
alter table public.browser_use_keys enable row level security;
grant select, insert, update, delete on public.browser_use_keys to authenticated;
grant all on public.browser_use_keys to service_role;
create policy "browser_use_keys_admin_all" on public.browser_use_keys for all to authenticated using (public.has_role(auth.uid(),'admin')) with check (public.has_role(auth.uid(),'admin'));

create table if not exists public.clerk_links (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  user_id uuid,
  clerk_user_id text not null,
  email text
);
alter table public.clerk_links enable row level security;
grant select, insert, update, delete on public.clerk_links to authenticated;
grant all on public.clerk_links to service_role;
create policy "clerk_links_owner_select" on public.clerk_links for select to authenticated using (auth.uid() = user_id);
create policy "clerk_links_owner_insert" on public.clerk_links for insert to authenticated with check (auth.uid() = user_id);
create policy "clerk_links_owner_update" on public.clerk_links for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "clerk_links_owner_delete" on public.clerk_links for delete to authenticated using (auth.uid() = user_id);

create table if not exists public.cloud_browser_settings (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  user_id uuid,
  keep_signed_in boolean default false,
  allow_downloads boolean default true,
  constraint cloud_browser_settings_user_unique unique (user_id)
);
alter table public.cloud_browser_settings enable row level security;
grant select, insert, update, delete on public.cloud_browser_settings to authenticated;
grant all on public.cloud_browser_settings to service_role;
create policy "cloud_browser_settings_owner_select" on public.cloud_browser_settings for select to authenticated using (auth.uid() = user_id);
create policy "cloud_browser_settings_owner_insert" on public.cloud_browser_settings for insert to authenticated with check (auth.uid() = user_id);
create policy "cloud_browser_settings_owner_update" on public.cloud_browser_settings for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "cloud_browser_settings_owner_delete" on public.cloud_browser_settings for delete to authenticated using (auth.uid() = user_id);

create table if not exists public.computer_events (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  task_id uuid,
  user_id uuid,
  title text,
  detail text,
  url text
);
alter table public.computer_events enable row level security;
grant select, insert, update, delete on public.computer_events to authenticated;
grant all on public.computer_events to service_role;
create policy "computer_events_owner_select" on public.computer_events for select to authenticated using (auth.uid() = user_id);
create policy "computer_events_owner_insert" on public.computer_events for insert to authenticated with check (auth.uid() = user_id);
create policy "computer_events_owner_update" on public.computer_events for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "computer_events_owner_delete" on public.computer_events for delete to authenticated using (auth.uid() = user_id);

create table if not exists public.computer_memory (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  user_id uuid,
  conversation_id uuid,
  content text
);
alter table public.computer_memory enable row level security;
grant select, insert, update, delete on public.computer_memory to authenticated;
grant all on public.computer_memory to service_role;
create policy "computer_memory_owner_select" on public.computer_memory for select to authenticated using (auth.uid() = user_id);
create policy "computer_memory_owner_insert" on public.computer_memory for insert to authenticated with check (auth.uid() = user_id);
create policy "computer_memory_owner_update" on public.computer_memory for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "computer_memory_owner_delete" on public.computer_memory for delete to authenticated using (auth.uid() = user_id);

create table if not exists public.computer_tasks (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  user_id uuid,
  conversation_id uuid,
  message_id uuid,
  prompt text,
  status text not null default 'pending',
  provider_task_id text,
  key_id uuid,
  progress numeric,
  result_text text,
  files jsonb default '[]'::jsonb,
  error text
);
alter table public.computer_tasks enable row level security;
grant select, insert, update, delete on public.computer_tasks to authenticated;
grant all on public.computer_tasks to service_role;
create policy "computer_tasks_owner_select" on public.computer_tasks for select to authenticated using (auth.uid() = user_id);
create policy "computer_tasks_owner_insert" on public.computer_tasks for insert to authenticated with check (auth.uid() = user_id);
create policy "computer_tasks_owner_update" on public.computer_tasks for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "computer_tasks_owner_delete" on public.computer_tasks for delete to authenticated using (auth.uid() = user_id);

create table if not exists public.dev_projects (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  user_id uuid,
  conversation_id uuid,
  name text,
  template text default 'vite-react18-ts',
  status text not null default 'active',
  vm_id text,
  preview_url text,
  deploy_url text,
  screenshot_url text,
  repo_id text,
  github_repo text,
  head_commit text,
  deployed_commit text
);
alter table public.dev_projects enable row level security;
grant select, insert, update, delete on public.dev_projects to authenticated;
grant all on public.dev_projects to service_role;
create policy "dev_projects_owner_select" on public.dev_projects for select to authenticated using (auth.uid() = user_id);
create policy "dev_projects_owner_insert" on public.dev_projects for insert to authenticated with check (auth.uid() = user_id);
create policy "dev_projects_owner_update" on public.dev_projects for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "dev_projects_owner_delete" on public.dev_projects for delete to authenticated using (auth.uid() = user_id);

create table if not exists public.dev_runs (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  user_id uuid,
  project_id uuid,
  conversation_id uuid,
  message_id uuid,
  intent text,
  prompt text,
  status text not null default 'queued',
  allow_deploy boolean default false,
  vm_id text,
  error text,
  metadata jsonb default '{}'::jsonb,
  last_heartbeat_at timestamptz,
  finished_at timestamptz
);
alter table public.dev_runs enable row level security;
grant select, insert, update, delete on public.dev_runs to authenticated;
grant all on public.dev_runs to service_role;
create policy "dev_runs_owner_select" on public.dev_runs for select to authenticated using (auth.uid() = user_id);
create policy "dev_runs_owner_insert" on public.dev_runs for insert to authenticated with check (auth.uid() = user_id);
create policy "dev_runs_owner_update" on public.dev_runs for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "dev_runs_owner_delete" on public.dev_runs for delete to authenticated using (auth.uid() = user_id);

create table if not exists public.dev_tasks (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  run_id uuid,
  user_id uuid,
  position integer default 0,
  title text,
  status text not null default 'pending',
  result text
);
alter table public.dev_tasks enable row level security;
grant select, insert, update, delete on public.dev_tasks to authenticated;
grant all on public.dev_tasks to service_role;
create policy "dev_tasks_owner_select" on public.dev_tasks for select to authenticated using (auth.uid() = user_id);
create policy "dev_tasks_owner_insert" on public.dev_tasks for insert to authenticated with check (auth.uid() = user_id);
create policy "dev_tasks_owner_update" on public.dev_tasks for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "dev_tasks_owner_delete" on public.dev_tasks for delete to authenticated using (auth.uid() = user_id);

create table if not exists public.dev_events (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  run_id uuid,
  user_id uuid,
  type text not null,
  title text,
  payload jsonb
);
alter table public.dev_events enable row level security;
grant select, insert, update, delete on public.dev_events to authenticated;
grant all on public.dev_events to service_role;
create policy "dev_events_owner_select" on public.dev_events for select to authenticated using (auth.uid() = user_id);
create policy "dev_events_owner_insert" on public.dev_events for insert to authenticated with check (auth.uid() = user_id);
create policy "dev_events_owner_update" on public.dev_events for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "dev_events_owner_delete" on public.dev_events for delete to authenticated using (auth.uid() = user_id);

create table if not exists public.dev_deploys (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  user_id uuid,
  project_id uuid,
  run_id uuid,
  commit text,
  deploy_url text,
  screenshot_url text,
  status text default 'error',
  error text
);
alter table public.dev_deploys enable row level security;
grant select, insert, update, delete on public.dev_deploys to authenticated;
grant all on public.dev_deploys to service_role;
create policy "dev_deploys_owner_select" on public.dev_deploys for select to authenticated using (auth.uid() = user_id);
create policy "dev_deploys_owner_insert" on public.dev_deploys for insert to authenticated with check (auth.uid() = user_id);
create policy "dev_deploys_owner_update" on public.dev_deploys for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "dev_deploys_owner_delete" on public.dev_deploys for delete to authenticated using (auth.uid() = user_id);

create table if not exists public.freestyle_keys (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  api_key text not null,
  label text,
  status text not null default 'active',
  priority integer default 0,
  failure_count integer default 0,
  success_count integer default 0,
  last_used_at timestamptz,
  last_error text,
  cooldown_until timestamptz,
  notes text
);
alter table public.freestyle_keys enable row level security;
grant select, insert, update, delete on public.freestyle_keys to authenticated;
grant all on public.freestyle_keys to service_role;
create policy "freestyle_keys_admin_all" on public.freestyle_keys for all to authenticated using (public.has_role(auth.uid(),'admin')) with check (public.has_role(auth.uid(),'admin'));

create table if not exists public.local_devices (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  user_id uuid,
  name text not null default 'My PC',
  status text not null default 'unpaired',
  pair_code text,
  pair_expires_at timestamptz,
  token_hash text,
  hostname text,
  agent_version text,
  os text default 'windows',
  last_seen_at timestamptz,
  capabilities jsonb default '{}'::jsonb,
  permission_mode text default 'manual',
  allowlist jsonb default '[]'::jsonb,
  work_dir text
);
alter table public.local_devices enable row level security;
grant select, insert, update, delete on public.local_devices to authenticated;
grant all on public.local_devices to service_role;
create policy "local_devices_owner_select" on public.local_devices for select to authenticated using (auth.uid() = user_id);
create policy "local_devices_owner_insert" on public.local_devices for insert to authenticated with check (auth.uid() = user_id);
create policy "local_devices_owner_update" on public.local_devices for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "local_devices_owner_delete" on public.local_devices for delete to authenticated using (auth.uid() = user_id);

create table if not exists public.local_device_commands (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  device_id uuid,
  user_id uuid,
  kind text not null,
  payload jsonb default '{}'::jsonb,
  status text not null default 'pending',
  result jsonb,
  error text
);
alter table public.local_device_commands enable row level security;
grant select, insert, update, delete on public.local_device_commands to authenticated;
grant all on public.local_device_commands to service_role;
create policy "local_device_commands_owner_select" on public.local_device_commands for select to authenticated using (auth.uid() = user_id);
create policy "local_device_commands_owner_insert" on public.local_device_commands for insert to authenticated with check (auth.uid() = user_id);
create policy "local_device_commands_owner_update" on public.local_device_commands for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "local_device_commands_owner_delete" on public.local_device_commands for delete to authenticated using (auth.uid() = user_id);

create table if not exists public.long_runs (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  user_id uuid,
  conversation_id uuid,
  goal text not null,
  kind text default 'agentic',
  status text not null default 'queued',
  phase text,
  status_text text,
  provider text,
  plan_id uuid,
  risk_level text default 'low',
  auto_continue_allowed boolean default true,
  auto_continue_at timestamptz,
  awaiting_plan_ack boolean default false,
  external_run_id text,
  live_view_url text,
  budget_ms bigint default 86400000,
  step_count integer default 0,
  review_round integer default 0,
  needs_input boolean default false,
  loop_strikes integer default 0,
  decide_failures integer default 0,
  failure_class text,
  error text,
  notified_at timestamptz,
  last_heartbeat_at timestamptz,
  last_tool_at timestamptz,
  pending_guidance jsonb default '[]'::jsonb,
  pending_steering jsonb default '[]'::jsonb,
  expires_at timestamptz
);
alter table public.long_runs enable row level security;
grant select, insert, update, delete on public.long_runs to authenticated;
grant all on public.long_runs to service_role;
create policy "long_runs_owner_select" on public.long_runs for select to authenticated using (auth.uid() = user_id);
create policy "long_runs_owner_insert" on public.long_runs for insert to authenticated with check (auth.uid() = user_id);
create policy "long_runs_owner_update" on public.long_runs for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "long_runs_owner_delete" on public.long_runs for delete to authenticated using (auth.uid() = user_id);

create table if not exists public.long_run_events (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  run_id uuid,
  user_id uuid,
  type text not null default 'log',
  title text,
  detail text,
  event_type text,
  step_id text,
  tool text,
  action text,
  status text,
  summary text,
  progress numeric,
  screenshot_url text,
  metadata jsonb
);
alter table public.long_run_events enable row level security;
grant select, insert, update, delete on public.long_run_events to authenticated;
grant all on public.long_run_events to service_role;
create policy "long_run_events_owner_select" on public.long_run_events for select to authenticated using (auth.uid() = user_id);
create policy "long_run_events_owner_insert" on public.long_run_events for insert to authenticated with check (auth.uid() = user_id);
create policy "long_run_events_owner_update" on public.long_run_events for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "long_run_events_owner_delete" on public.long_run_events for delete to authenticated using (auth.uid() = user_id);

create table if not exists public.mailboxes (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  user_id uuid,
  address text not null,
  display_name text,
  external_enabled boolean default true,
  constraint mailboxes_address_unique unique (address)
);
alter table public.mailboxes enable row level security;
grant select, insert, update, delete on public.mailboxes to authenticated;
grant all on public.mailboxes to service_role;
create policy "mailboxes_owner_select" on public.mailboxes for select to authenticated using (auth.uid() = user_id);
create policy "mailboxes_owner_insert" on public.mailboxes for insert to authenticated with check (auth.uid() = user_id);
create policy "mailboxes_owner_update" on public.mailboxes for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "mailboxes_owner_delete" on public.mailboxes for delete to authenticated using (auth.uid() = user_id);

create table if not exists public.mail_messages (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  mailbox_id uuid,
  user_id uuid,
  folder text not null default 'inbox',
  direction text not null default 'in',
  from_address text,
  from_name text,
  to_address text,
  subject text,
  body_text text,
  body_html text,
  snippet text,
  spam_score integer default 0,
  origin text default 'external',
  external_message_id text,
  is_read boolean default false,
  delivery_status text
);
alter table public.mail_messages enable row level security;
grant select, insert, update, delete on public.mail_messages to authenticated;
grant all on public.mail_messages to service_role;
create policy "mail_messages_owner_select" on public.mail_messages for select to authenticated using (auth.uid() = user_id);
create policy "mail_messages_owner_insert" on public.mail_messages for insert to authenticated with check (auth.uid() = user_id);
create policy "mail_messages_owner_update" on public.mail_messages for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "mail_messages_owner_delete" on public.mail_messages for delete to authenticated using (auth.uid() = user_id);

create table if not exists public.mcp_call_log (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  user_id uuid,
  connection_id uuid,
  server_name text,
  tool_name text,
  arguments jsonb default '{}'::jsonb,
  status text not null default 'ok',
  duration_ms integer,
  error text
);
alter table public.mcp_call_log enable row level security;
grant select, insert, update, delete on public.mcp_call_log to authenticated;
grant all on public.mcp_call_log to service_role;
create policy "mcp_call_log_owner_select" on public.mcp_call_log for select to authenticated using (auth.uid() = user_id);
create policy "mcp_call_log_owner_insert" on public.mcp_call_log for insert to authenticated with check (auth.uid() = user_id);
create policy "mcp_call_log_owner_update" on public.mcp_call_log for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "mcp_call_log_owner_delete" on public.mcp_call_log for delete to authenticated using (auth.uid() = user_id);

create table if not exists public.mcp_oauth_states (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  state text not null,
  user_id uuid,
  connection_id uuid,
  code_verifier text,
  metadata jsonb default '{}'::jsonb
);
alter table public.mcp_oauth_states enable row level security;
grant select, insert, update, delete on public.mcp_oauth_states to authenticated;
grant all on public.mcp_oauth_states to service_role;
create policy "mcp_oauth_states_owner_select" on public.mcp_oauth_states for select to authenticated using (auth.uid() = user_id);
create policy "mcp_oauth_states_owner_insert" on public.mcp_oauth_states for insert to authenticated with check (auth.uid() = user_id);
create policy "mcp_oauth_states_owner_update" on public.mcp_oauth_states for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "mcp_oauth_states_owner_delete" on public.mcp_oauth_states for delete to authenticated using (auth.uid() = user_id);

create table if not exists public.mcp_tool_approvals (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  user_id uuid,
  connection_id uuid,
  tool_name text not null,
  scope text not null default 'always',
  constraint mcp_tool_approvals_conn_tool_unique unique (connection_id, tool_name)
);
alter table public.mcp_tool_approvals enable row level security;
grant select, insert, update, delete on public.mcp_tool_approvals to authenticated;
grant all on public.mcp_tool_approvals to service_role;
create policy "mcp_tool_approvals_owner_select" on public.mcp_tool_approvals for select to authenticated using (auth.uid() = user_id);
create policy "mcp_tool_approvals_owner_insert" on public.mcp_tool_approvals for insert to authenticated with check (auth.uid() = user_id);
create policy "mcp_tool_approvals_owner_update" on public.mcp_tool_approvals for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "mcp_tool_approvals_owner_delete" on public.mcp_tool_approvals for delete to authenticated using (auth.uid() = user_id);

create table if not exists public.provider_api_keys (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  provider text not null,
  api_key text not null,
  status text not null default 'active',
  failure_count integer default 0,
  last_used_at timestamptz,
  last_error text,
  cooldown_until timestamptz,
  label text,
  notes text
);
alter table public.provider_api_keys enable row level security;
grant select, insert, update, delete on public.provider_api_keys to authenticated;
grant all on public.provider_api_keys to service_role;
create policy "provider_api_keys_admin_all" on public.provider_api_keys for all to authenticated using (public.has_role(auth.uid(),'admin')) with check (public.has_role(auth.uid(),'admin'));

create table if not exists public.user_api_apps (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  user_id uuid,
  app_id text not null,
  key_value text,
  key_hint text,
  enabled boolean default true,
  display_name text,
  logo_url text,
  spec jsonb,
  constraint user_api_apps_user_app_unique unique (user_id, app_id)
);
alter table public.user_api_apps enable row level security;
grant select, insert, update, delete on public.user_api_apps to authenticated;
grant all on public.user_api_apps to service_role;
create policy "user_api_apps_owner_select" on public.user_api_apps for select to authenticated using (auth.uid() = user_id);
create policy "user_api_apps_owner_insert" on public.user_api_apps for insert to authenticated with check (auth.uid() = user_id);
create policy "user_api_apps_owner_update" on public.user_api_apps for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "user_api_apps_owner_delete" on public.user_api_apps for delete to authenticated using (auth.uid() = user_id);

create table if not exists public.user_knowledge (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  user_id uuid,
  name text,
  use_when text not null,
  content text not null,
  enabled boolean default true
);
alter table public.user_knowledge enable row level security;
grant select, insert, update, delete on public.user_knowledge to authenticated;
grant all on public.user_knowledge to service_role;
create policy "user_knowledge_owner_select" on public.user_knowledge for select to authenticated using (auth.uid() = user_id);
create policy "user_knowledge_owner_insert" on public.user_knowledge for insert to authenticated with check (auth.uid() = user_id);
create policy "user_knowledge_owner_update" on public.user_knowledge for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "user_knowledge_owner_delete" on public.user_knowledge for delete to authenticated using (auth.uid() = user_id);

create table if not exists public.telegram_media (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  user_id uuid,
  file_id text not null,
  file_unique_id text,
  kind text,
  mime_type text,
  size_bytes bigint,
  cached_url text,
  cached_until timestamptz,
  original_filename text,
  fallback_path text,
  metadata jsonb default '{}'::jsonb
);
alter table public.telegram_media enable row level security;
grant select, insert, update, delete on public.telegram_media to authenticated;
grant all on public.telegram_media to service_role;
create policy "telegram_media_owner_select" on public.telegram_media for select to authenticated using (auth.uid() = user_id);
create policy "telegram_media_owner_insert" on public.telegram_media for insert to authenticated with check (auth.uid() = user_id);
create policy "telegram_media_owner_update" on public.telegram_media for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "telegram_media_owner_delete" on public.telegram_media for delete to authenticated using (auth.uid() = user_id);
