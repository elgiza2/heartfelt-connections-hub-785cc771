create table if not exists public.admin_error_log (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid,
  "user_email" text,
  "source" text not null,
  "route" text,
  "message" text not null,
  "raw_error" text,
  "context" jsonb default '{}'::jsonb,
  "user_agent" text,
  "notified" boolean default false not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.admin_error_log enable row level security;
grant select, insert, update, delete on public.admin_error_log to authenticated;
grant all on public.admin_error_log to service_role;
grant select on public.admin_error_log to anon;
create table if not exists public.admin_notifications (
  "id" uuid default gen_random_uuid() not null,
  "type" text not null,
  "payload" jsonb default '{}'::jsonb not null,
  "read" boolean default false not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.admin_notifications enable row level security;
grant select, insert, update, delete on public.admin_notifications to authenticated;
grant all on public.admin_notifications to service_role;
grant select on public.admin_notifications to anon;
create table if not exists public.agent_evals (
  "id" uuid default gen_random_uuid() not null,
  "trace_id" uuid not null,
  "user_id" uuid not null,
  "judge_model" text not null,
  "criterion" text not null,
  "score" numeric,
  "passed" boolean,
  "reasoning" text,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.agent_evals enable row level security;
grant select, insert, update, delete on public.agent_evals to authenticated;
grant all on public.agent_evals to service_role;
grant select on public.agent_evals to anon;
create table if not exists public.agent_golden_dataset (
  "id" uuid default gen_random_uuid() not null,
  "label" text not null,
  "input" text not null,
  "expected_criteria" jsonb default '[]'::jsonb not null,
  "tags" text[] default ARRAY[]::text[],
  "is_active" boolean default true,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.agent_golden_dataset enable row level security;
grant select, insert, update, delete on public.agent_golden_dataset to authenticated;
grant all on public.agent_golden_dataset to service_role;
grant select on public.agent_golden_dataset to anon;
create table if not exists public.agent_incidents (
  "id" uuid default gen_random_uuid() not null,
  "agent_id" uuid,
  "severity" text default 'warn'::text not null,
  "title" text not null,
  "description" text,
  "status" text default 'open'::text not null,
  "metadata" jsonb default '{}'::jsonb,
  "opened_at" timestamp with time zone default now() not null,
  "resolved_at" timestamp with time zone,
  primary key ("id")
);
alter table public.agent_incidents enable row level security;
grant select, insert, update, delete on public.agent_incidents to authenticated;
grant all on public.agent_incidents to service_role;
grant select on public.agent_incidents to anon;
create table if not exists public.agent_memory_files (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "conversation_id" uuid,
  "path" text not null,
  "content" text default ''::text not null,
  "tokens_estimate" integer default 0 not null,
  "updated_at" timestamp with time zone default now() not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.agent_memory_files enable row level security;
grant select, insert, update, delete on public.agent_memory_files to authenticated;
grant all on public.agent_memory_files to service_role;
grant select on public.agent_memory_files to anon;
create table if not exists public.agent_messages (
  "id" uuid default gen_random_uuid() not null,
  "session_id" uuid not null,
  "user_id" uuid not null,
  "role" text not null,
  "content" text,
  "tool_calls" jsonb,
  "tool_results" jsonb,
  "metadata" jsonb default '{}'::jsonb not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.agent_messages enable row level security;
grant select, insert, update, delete on public.agent_messages to authenticated;
grant all on public.agent_messages to service_role;
grant select on public.agent_messages to anon;
create table if not exists public.agent_observations (
  "id" uuid default gen_random_uuid() not null,
  "agent_id" uuid,
  "severity" text default 'info'::text not null,
  "metric" text not null,
  "value" numeric,
  "threshold" numeric,
  "message" text,
  "context" jsonb default '{}'::jsonb,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.agent_observations enable row level security;
grant select, insert, update, delete on public.agent_observations to authenticated;
grant all on public.agent_observations to service_role;
grant select on public.agent_observations to anon;
create table if not exists public.agent_proposals (
  "id" uuid default gen_random_uuid() not null,
  "agent_id" uuid,
  "run_id" uuid,
  "kind" text not null,
  "title" text not null,
  "rationale" text,
  "payload" jsonb default '{}'::jsonb not null,
  "status" text default 'pending'::text not null,
  "telegram_message_id" bigint,
  "telegram_chat_id" bigint,
  "created_at" timestamp with time zone default now() not null,
  "executed_at" timestamp with time zone,
  "decided_by" uuid,
  "result" jsonb,
  primary key ("id")
);
alter table public.agent_proposals enable row level security;
grant select, insert, update, delete on public.agent_proposals to authenticated;
grant all on public.agent_proposals to service_role;
grant select on public.agent_proposals to anon;
create table if not exists public.agent_runs (
  "id" uuid default gen_random_uuid() not null,
  "agent_id" uuid not null,
  "status" text default 'running'::text not null,
  "trigger" text default 'manual'::text not null,
  "started_at" timestamp with time zone default now() not null,
  "ended_at" timestamp with time zone,
  "tokens_used" integer default 0,
  "e2b_ms" integer default 0,
  "proposals_count" integer default 0,
  "output_summary" text,
  "error" text,
  primary key ("id")
);
alter table public.agent_runs enable row level security;
grant select, insert, update, delete on public.agent_runs to authenticated;
grant all on public.agent_runs to service_role;
grant select on public.agent_runs to anon;
create table if not exists public.agent_sessions (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "agent_slug" text not null,
  "title" text,
  "sandbox_id" text,
  "sandbox_status" text default 'idle'::text,
  "status" text default 'active'::text not null,
  "metadata" jsonb default '{}'::jsonb not null,
  "last_message_at" timestamp with time zone default now(),
  "started_at" timestamp with time zone default now() not null,
  "ended_at" timestamp with time zone,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "manus_task_id" text,
  "manus_cursor" text,
  "manus_task_url" text,
  "manus_api_key_id" uuid,
  primary key ("id")
);
alter table public.agent_sessions enable row level security;
grant select, insert, update, delete on public.agent_sessions to authenticated;
grant all on public.agent_sessions to service_role;
grant select on public.agent_sessions to anon;
create table if not exists public.agent_tool_bindings (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "agent_slug" text not null,
  "tool_id" uuid not null,
  "enabled" boolean default true not null,
  "config" jsonb default '{}'::jsonb not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.agent_tool_bindings enable row level security;
grant select, insert, update, delete on public.agent_tool_bindings to authenticated;
grant all on public.agent_tool_bindings to service_role;
grant select on public.agent_tool_bindings to anon;
create table if not exists public.agent_tool_invocations (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "session_id" uuid,
  "agent_slug" text,
  "tool_key" text not null,
  "input" jsonb default '{}'::jsonb not null,
  "output" jsonb,
  "status" text default 'pending'::text not null,
  "error" text,
  "credits_charged" numeric default 0 not null,
  "latency_ms" integer,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.agent_tool_invocations enable row level security;
grant select, insert, update, delete on public.agent_tool_invocations to authenticated;
grant all on public.agent_tool_invocations to service_role;
grant select on public.agent_tool_invocations to anon;
create table if not exists public.agent_tools_registry (
  "id" uuid default gen_random_uuid() not null,
  "tool_key" text not null,
  "name" text not null,
  "name_ar" text,
  "description" text,
  "description_ar" text,
  "category" text not null,
  "icon" text,
  "edge_function" text not null,
  "input_schema" jsonb default '{}'::jsonb not null,
  "output_kind" text default 'json'::text not null,
  "base_credits" numeric default 1 not null,
  "credit_formula" jsonb,
  "requires_premium" boolean default false not null,
  "is_active" boolean default true not null,
  "sort_order" integer default 0 not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.agent_tools_registry enable row level security;
grant select, insert, update, delete on public.agent_tools_registry to authenticated;
grant all on public.agent_tools_registry to service_role;
grant select on public.agent_tools_registry to anon;
create table if not exists public.agent_traces (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "conversation_id" uuid,
  "model" text,
  "path" text,
  "input" jsonb,
  "output" text,
  "tools_used" jsonb default '[]'::jsonb,
  "activity" jsonb default '[]'::jsonb,
  "latency_ms" integer,
  "prompt_tokens" integer,
  "completion_tokens" integer,
  "cached_tokens" integer,
  "iters" integer,
  "deferred" boolean default false,
  "status" text default 'ok'::text,
  "error" text,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.agent_traces enable row level security;
grant select, insert, update, delete on public.agent_traces to authenticated;
grant all on public.agent_traces to service_role;
grant select on public.agent_traces to anon;
create table if not exists public.ai_agents (
  "id" uuid default gen_random_uuid() not null,
  "slug" text not null,
  "name" text not null,
  "category" text not null,
  "description" text,
  "system_prompt" text not null,
  "cron_schedule" text,
  "approval_mode" text default 'approval'::text not null,
  "enabled" boolean default true not null,
  "config" jsonb default '{}'::jsonb not null,
  "last_run_at" timestamp with time zone,
  "success_count" integer default 0 not null,
  "fail_count" integer default 0 not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.ai_agents enable row level security;
grant select, insert, update, delete on public.ai_agents to authenticated;
grant all on public.ai_agents to service_role;
grant select on public.ai_agents to anon;
create table if not exists public.ai_personalization (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "call_name" text,
  "profession" text,
  "about" text,
  "ai_traits" text,
  "custom_instructions" text,
  "created_at" timestamp with time zone default now(),
  "updated_at" timestamp with time zone default now(),
  "tone_formality" integer default 50 not null,
  "tone_verbosity" integer default 50 not null,
  "tone_creativity" integer default 50 not null,
  "language_style" text default 'mixed'::text not null,
  "interests" text[] default '{}'::text[] not null,
  "preferred_tier" text default 'lite'::text not null,
  "active_persona_id" uuid,
  primary key ("id")
);
alter table public.ai_personalization enable row level security;
grant select, insert, update, delete on public.ai_personalization to authenticated;
grant all on public.ai_personalization to service_role;
grant select on public.ai_personalization to anon;
create table if not exists public.ai_project_files (
  "id" uuid default gen_random_uuid() not null,
  "project_id" uuid not null,
  "path" text not null,
  "content" text default ''::text not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.ai_project_files enable row level security;
grant select, insert, update, delete on public.ai_project_files to authenticated;
grant all on public.ai_project_files to service_role;
grant select on public.ai_project_files to anon;
create table if not exists public.ai_project_messages (
  "id" uuid default gen_random_uuid() not null,
  "project_id" uuid not null,
  "role" text not null,
  "content" text default ''::text not null,
  "metadata" jsonb default '{}'::jsonb not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.ai_project_messages enable row level security;
grant select, insert, update, delete on public.ai_project_messages to authenticated;
grant all on public.ai_project_messages to service_role;
grant select on public.ai_project_messages to anon;
create table if not exists public.ai_project_snapshots (
  "id" uuid default gen_random_uuid() not null,
  "project_id" uuid not null,
  "label" text,
  "files" jsonb default '[]'::jsonb not null,
  "created_by" uuid,
  "created_at" timestamp with time zone default now() not null,
  "file_count" integer default 0 not null,
  "total_bytes" bigint default 0 not null,
  "user_id" uuid,
  primary key ("id")
);
alter table public.ai_project_snapshots enable row level security;
grant select, insert, update, delete on public.ai_project_snapshots to authenticated;
grant all on public.ai_project_snapshots to service_role;
grant select on public.ai_project_snapshots to anon;
create table if not exists public.ai_project_usage (
  "id" uuid default gen_random_uuid() not null,
  "project_id" uuid not null,
  "user_id" uuid,
  "action" text default 'chat'::text not null,
  "model" text,
  "prompt_tokens" integer default 0 not null,
  "completion_tokens" integer default 0 not null,
  "mc_cost" numeric default 0 not null,
  "duration_ms" integer default 0 not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.ai_project_usage enable row level security;
grant select, insert, update, delete on public.ai_project_usage to authenticated;
grant all on public.ai_project_usage to service_role;
grant select on public.ai_project_usage to anon;
create table if not exists public.alibaba_keys (
  "id" uuid default gen_random_uuid() not null,
  "category" text not null,
  "api_key" text not null,
  "label" text,
  "status" text default 'active'::text not null,
  "failure_count" integer default 0 not null,
  "last_error" text,
  "last_used_at" timestamp with time zone,
  "notes" text,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.alibaba_keys enable row level security;
grant select, insert, update, delete on public.alibaba_keys to authenticated;
grant all on public.alibaba_keys to service_role;
grant select on public.alibaba_keys to anon;
create table if not exists public.anonymous_chat_usage (
  "id" uuid default gen_random_uuid() not null,
  "ip_hash" text not null,
  "fingerprint_hash" text not null,
  "user_agent" text,
  "used_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.anonymous_chat_usage enable row level security;
grant select, insert, update, delete on public.anonymous_chat_usage to authenticated;
grant all on public.anonymous_chat_usage to service_role;
grant select on public.anonymous_chat_usage to anon;
create table if not exists public.api_keys (
  "id" uuid default gen_random_uuid() not null,
  "service" text not null,
  "api_key" text not null,
  "label" text,
  "is_active" boolean default true,
  "is_blocked" boolean default false,
  "block_reason" text,
  "usage_count" integer default 0,
  "error_count" integer default 0,
  "last_used_at" timestamp with time zone,
  "last_error_at" timestamp with time zone,
  "created_at" timestamp with time zone default now(),
  "credit_used_usd" numeric default 0 not null,
  "credit_limit_usd" numeric default 5 not null,
  "provider_meta" jsonb default '{}'::jsonb not null,
  "cooldown_until" timestamp with time zone,
  primary key ("id")
);
alter table public.api_keys enable row level security;
grant select, insert, update, delete on public.api_keys to authenticated;
grant all on public.api_keys to service_role;
grant select on public.api_keys to anon;
create table if not exists public.apify_keys (
  "id" uuid default gen_random_uuid() not null,
  "api_key" text not null,
  "label" text,
  "status" text default 'active'::text not null,
  "balance_usd" numeric default 0,
  "spent_usd" numeric default 0,
  "failure_count" integer default 0 not null,
  "last_error" text,
  "last_used_at" timestamp with time zone,
  "notes" text,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.apify_keys enable row level security;
grant select, insert, update, delete on public.apify_keys to authenticated;
grant all on public.apify_keys to service_role;
grant select on public.apify_keys to anon;
create table if not exists public.app_kv (
  "id" uuid default gen_random_uuid() not null,
  "project_id" uuid not null,
  "user_id" uuid not null,
  "key" text not null,
  "value" jsonb default '{}'::jsonb not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.app_kv enable row level security;
grant select, insert, update, delete on public.app_kv to authenticated;
grant all on public.app_kv to service_role;
grant select on public.app_kv to anon;
create table if not exists public.appsumo_licenses (
  "id" uuid default gen_random_uuid() not null,
  "license_key" text not null,
  "license_id" text,
  "activation_email" text,
  "product_id" text,
  "plan_id" text,
  "tier" integer,
  "status" text default 'active'::text not null,
  "event" text,
  "user_id" uuid,
  "raw" jsonb,
  "activated_at" timestamp with time zone,
  "invoiced_at" timestamp with time zone,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.appsumo_licenses enable row level security;
grant select, insert, update, delete on public.appsumo_licenses to authenticated;
grant all on public.appsumo_licenses to service_role;
grant select on public.appsumo_licenses to anon;
create table if not exists public.appsumo_oauth_states (
  "state" text not null,
  "user_id" uuid not null,
  "redirect_to" text,
  "created_at" timestamp with time zone default now() not null
);
alter table public.appsumo_oauth_states enable row level security;
grant select, insert, update, delete on public.appsumo_oauth_states to authenticated;
grant all on public.appsumo_oauth_states to service_role;
grant select on public.appsumo_oauth_states to anon;
create table if not exists public.attachment_chunks (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "conversation_id" uuid,
  "file_name" text,
  "chunk_index" integer default 0 not null,
  "content" text not null,
  "embedding" vector(1536),
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.attachment_chunks enable row level security;
grant select, insert, update, delete on public.attachment_chunks to authenticated;
grant all on public.attachment_chunks to service_role;
grant select on public.attachment_chunks to anon;
create table if not exists public.background_jobs (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "conversation_id" uuid,
  "message_id" text,
  "kind" text not null,
  "status" text default 'queued'::text not null,
  "phase" text,
  "progress" integer default 0 not null,
  "status_text" text,
  "input" jsonb default '{}'::jsonb not null,
  "output" jsonb default '{}'::jsonb not null,
  "stream_text" text default ''::text not null,
  "meta" jsonb default '{}'::jsonb not null,
  "clarify" jsonb,
  "error" text,
  "tokens_used" integer default 0 not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "last_heartbeat_at" timestamp with time zone default now() not null,
  "finished_at" timestamp with time zone,
  "attempt" integer default 0 not null,
  "max_attempts" integer default 3 not null,
  "next_run_at" timestamp with time zone default now(),
  "checkpoint" jsonb default '{}'::jsonb not null,
  "provider_errors" jsonb default '[]'::jsonb not null,
  "resumable" boolean default true not null,
  "runner" text,
  primary key ("id")
);
alter table public.background_jobs enable row level security;
grant select, insert, update, delete on public.background_jobs to authenticated;
grant all on public.background_jobs to service_role;
grant select on public.background_jobs to anon;
create table if not exists public.billing_audit_log (
  "id" uuid default gen_random_uuid() not null,
  "occurred_at" timestamp with time zone default now() not null,
  "actor_role" text not null,
  "actor_user_id" uuid,
  "table_name" text not null,
  "entity_id" uuid not null,
  "column_name" text not null,
  "old_value" text,
  "new_value" text,
  "reason" text,
  primary key ("id")
);
alter table public.billing_audit_log enable row level security;
grant select, insert, update, delete on public.billing_audit_log to authenticated;
grant all on public.billing_audit_log to service_role;
grant select on public.billing_audit_log to anon;
create table if not exists public.billing_skus (
  "sku" text not null,
  "kind" text not null,
  "display_name" text not null,
  "amount_egp" numeric not null,
  "amount_usd" numeric,
  "credits" integer default 0 not null,
  "plan_key" text,
  "interval" text,
  "active" boolean default true not null,
  "sort_order" integer default 0 not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null
);
alter table public.billing_skus enable row level security;
grant select, insert, update, delete on public.billing_skus to authenticated;
grant all on public.billing_skus to service_role;
grant select on public.billing_skus to anon;
create table if not exists public.blog_categories (
  "id" uuid default gen_random_uuid() not null,
  "slug" text not null,
  "name" text not null,
  "description" text,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.blog_categories enable row level security;
grant select, insert, update, delete on public.blog_categories to authenticated;
grant all on public.blog_categories to service_role;
grant select on public.blog_categories to anon;
create table if not exists public.blog_posts (
  "id" uuid default gen_random_uuid() not null,
  "slug" text not null,
  "title" text not null,
  "meta_description" text,
  "excerpt" text,
  "content_md" text not null,
  "content_html" text,
  "hero_image_url" text,
  "keywords" text[] default '{}'::text[],
  "category" text,
  "tags" text[] default '{}'::text[],
  "author_name" text default 'AI Editorial Team'::text not null,
  "language" text default 'en'::text not null,
  "status" text default 'draft'::text not null,
  "published_at" timestamp with time zone,
  "views" integer default 0 not null,
  "reading_minutes" integer,
  "ai_agent_id" uuid,
  "jsonld" jsonb,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "translation_group_id" uuid,
  "is_original" boolean default true not null,
  "faq" jsonb,
  primary key ("id")
);
alter table public.blog_posts enable row level security;
grant select, insert, update, delete on public.blog_posts to authenticated;
grant all on public.blog_posts to service_role;
grant select on public.blog_posts to anon;
create table if not exists public.blog_topic_queue (
  "id" uuid default gen_random_uuid() not null,
  "topic" text not null,
  "angle" text,
  "language" text default 'en'::text not null,
  "source" text default 'auto'::text not null,
  "requested_by" text,
  "status" text default 'queued'::text not null,
  "priority" integer default 0 not null,
  "result_post_id" uuid,
  "error" text,
  "created_at" timestamp with time zone default now() not null,
  "picked_at" timestamp with time zone,
  "done_at" timestamp with time zone,
  primary key ("id")
);
alter table public.blog_topic_queue enable row level security;
grant select, insert, update, delete on public.blog_topic_queue to authenticated;
grant all on public.blog_topic_queue to service_role;
grant select on public.blog_topic_queue to anon;
create table if not exists public.books (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "title" text default 'Untitled Book'::text not null,
  "type" text default 'story'::text not null,
  "language" text default 'ar'::text not null,
  "pages_count" integer default 20 not null,
  "outline" jsonb default '[]'::jsonb,
  "content" jsonb default '[]'::jsonb,
  "cover_url" text,
  "pdf_url" text,
  "status" text default 'draft'::text not null,
  "credits_used" numeric default 0,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.books enable row level security;
grant select, insert, update, delete on public.books to authenticated;
grant all on public.books to service_role;
grant select on public.books to anon;
create table if not exists public.bot_pending_actions (
  "chat_id" bigint not null,
  "action" text not null,
  "payload" jsonb default '{}'::jsonb not null,
  "created_at" timestamp with time zone default now() not null
);
alter table public.bot_pending_actions enable row level security;
grant select, insert, update, delete on public.bot_pending_actions to authenticated;
grant all on public.bot_pending_actions to service_role;
grant select on public.bot_pending_actions to anon;
create table if not exists public.brave_keys (
  "id" uuid default gen_random_uuid() not null,
  "api_key" text not null,
  "label" text,
  "status" text default 'active'::text not null,
  "monthly_quota" integer default 2000,
  "used_this_month" integer default 0 not null,
  "failure_count" integer default 0 not null,
  "last_error" text,
  "last_used_at" timestamp with time zone,
  "notes" text,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.brave_keys enable row level security;
grant select, insert, update, delete on public.brave_keys to authenticated;
grant all on public.brave_keys to service_role;
grant select on public.brave_keys to anon;
create table if not exists public.calendar_connections (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "provider" text default 'google'::text not null,
  "access_token" text,
  "refresh_token" text,
  "token_expires_at" timestamp with time zone,
  "calendar_email" text,
  "status" text default 'active'::text not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.calendar_connections enable row level security;
grant select, insert, update, delete on public.calendar_connections to authenticated;
grant all on public.calendar_connections to service_role;
grant select on public.calendar_connections to anon;
create table if not exists public.chat_citations (
  "id" uuid default gen_random_uuid() not null,
  "message_id" uuid,
  "conversation_id" uuid,
  "user_id" uuid,
  "index_num" integer not null,
  "title" text,
  "url" text,
  "snippet" text,
  "source_type" text,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.chat_citations enable row level security;
grant select, insert, update, delete on public.chat_citations to authenticated;
grant all on public.chat_citations to service_role;
grant select on public.chat_citations to anon;
create table if not exists public.chat_followups (
  "id" uuid default gen_random_uuid() not null,
  "message_id" uuid,
  "conversation_id" uuid,
  "user_id" uuid,
  "questions" jsonb default '[]'::jsonb not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.chat_followups enable row level security;
grant select, insert, update, delete on public.chat_followups to authenticated;
grant all on public.chat_followups to service_role;
grant select on public.chat_followups to anon;
create table if not exists public.chat_interaction_events (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "conversation_id" uuid,
  "message_id" uuid,
  "event_type" text not null,
  "metadata" jsonb default '{}'::jsonb not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.chat_interaction_events enable row level security;
grant select, insert, update, delete on public.chat_interaction_events to authenticated;
grant all on public.chat_interaction_events to service_role;
grant select on public.chat_interaction_events to anon;
create table if not exists public.chat_models (
  "id" uuid default gen_random_uuid() not null,
  "provider" text default 'yep'::text not null,
  "model_id" text not null,
  "display_name" text not null,
  "context_window" integer not null,
  "max_output" integer,
  "price_in_per_1m" numeric,
  "price_out_per_1m" numeric,
  "tier" text default 'free'::text not null,
  "is_default" boolean default false not null,
  "is_active" boolean default true not null,
  "capabilities" jsonb default '{}'::jsonb not null,
  "display_order" integer default 0 not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.chat_models enable row level security;
grant select, insert, update, delete on public.chat_models to authenticated;
grant all on public.chat_models to service_role;
grant select on public.chat_models to anon;
create table if not exists public.chat_router_logs (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid,
  "conversation_id" uuid,
  "user_text" text,
  "routed" jsonb default '{}'::jsonb not null,
  "latency_ms" integer,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.chat_router_logs enable row level security;
grant select, insert, update, delete on public.chat_router_logs to authenticated;
grant all on public.chat_router_logs to service_role;
grant select on public.chat_router_logs to anon;
create table if not exists public.chat_semantic_cache (
  "id" uuid default gen_random_uuid() not null,
  "query_hash" text not null,
  "query_text" text not null,
  "query_embedding" jsonb,
  "response" text not null,
  "model" text,
  "hits" integer default 0 not null,
  "created_at" timestamp with time zone default now() not null,
  "expires_at" timestamp with time zone default (now() + '30 days'::interval) not null,
  primary key ("id")
);
alter table public.chat_semantic_cache enable row level security;
grant select, insert, update, delete on public.chat_semantic_cache to authenticated;
grant all on public.chat_semantic_cache to service_role;
grant select on public.chat_semantic_cache to anon;
create table if not exists public.chat_stream_buffers (
  "id" uuid not null,
  "user_id" uuid,
  "conversation_id" uuid,
  "content" text default ''::text not null,
  "done" boolean default false not null,
  "interrupted" boolean default false not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.chat_stream_buffers enable row level security;
grant select, insert, update, delete on public.chat_stream_buffers to authenticated;
grant all on public.chat_stream_buffers to service_role;
grant select on public.chat_stream_buffers to anon;
create table if not exists public.composio_auth_configs (
  "app_slug" text not null,
  "auth_config_id" text not null,
  "created_at" timestamp with time zone default now() not null
);
alter table public.composio_auth_configs enable row level security;
grant select, insert, update, delete on public.composio_auth_configs to authenticated;
grant all on public.composio_auth_configs to service_role;
grant select on public.composio_auth_configs to anon;
create table if not exists public.composio_connections (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "app_slug" text not null,
  "connected_account_id" text not null,
  "status" text default 'pending'::text not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.composio_connections enable row level security;
grant select, insert, update, delete on public.composio_connections to authenticated;
grant all on public.composio_connections to service_role;
grant select on public.composio_connections to anon;
create table if not exists public.contact_submissions (
  "id" uuid default gen_random_uuid() not null,
  "form_type" text default 'support'::text not null,
  "name" text not null,
  "email" text not null,
  "subject" text,
  "message" text not null,
  "ai_reply" text,
  "reply_sent" boolean default false not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.contact_submissions enable row level security;
grant select, insert, update, delete on public.contact_submissions to authenticated;
grant all on public.contact_submissions to service_role;
grant select on public.contact_submissions to anon;
create table if not exists public.conversation_invites (
  "id" uuid default gen_random_uuid() not null,
  "conversation_id" uuid not null,
  "invited_by" uuid not null,
  "invite_email" text,
  "invite_token" text default encode(extensions.gen_random_bytes(16), 'hex'::text) not null,
  "status" text default 'pending'::text not null,
  "created_at" timestamp with time zone default now() not null,
  "expires_at" timestamp with time zone default (now() + '7 days'::interval) not null,
  "accepted_by" uuid,
  primary key ("id")
);
alter table public.conversation_invites enable row level security;
grant select, insert, update, delete on public.conversation_invites to authenticated;
grant all on public.conversation_invites to service_role;
grant select on public.conversation_invites to anon;
create table if not exists public.conversation_members (
  "id" uuid default gen_random_uuid() not null,
  "conversation_id" uuid not null,
  "user_id" uuid not null,
  "role" text default 'member'::text not null,
  "joined_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.conversation_members enable row level security;
grant select, insert, update, delete on public.conversation_members to authenticated;
grant all on public.conversation_members to service_role;
grant select on public.conversation_members to anon;
create table if not exists public.conversation_summaries (
  "id" uuid default gen_random_uuid() not null,
  "conversation_id" uuid not null,
  "user_id" uuid not null,
  "summary" text not null,
  "key_points" jsonb default '[]'::jsonb not null,
  "metadata" jsonb default '{}'::jsonb not null,
  "last_message_at" timestamp with time zone,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.conversation_summaries enable row level security;
grant select, insert, update, delete on public.conversation_summaries to authenticated;
grant all on public.conversation_summaries to service_role;
grant select on public.conversation_summaries to anon;
create table if not exists public.conversations (
  "id" uuid default gen_random_uuid() not null,
  "title" text default 'New Chat'::text not null,
  "mode" text default 'chat'::text not null,
  "model" text,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "is_shared" boolean default false,
  "share_id" text,
  "user_id" uuid not null,
  "is_pinned" boolean default false not null,
  "pinned_at" timestamp with time zone,
  "ui_state" jsonb default '{}'::jsonb not null,
  "workspace_id" uuid,
  primary key ("id")
);
alter table public.conversations enable row level security;
grant select, insert, update, delete on public.conversations to authenticated;
grant all on public.conversations to service_role;
grant select on public.conversations to anon;
create table if not exists public.credit_transactions (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "amount" numeric not null,
  "action_type" text not null,
  "description" text,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.credit_transactions enable row level security;
grant select, insert, update, delete on public.credit_transactions to authenticated;
grant all on public.credit_transactions to service_role;
grant select on public.credit_transactions to anon;
create table if not exists public.daily_free_usage (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "usage_date" date default CURRENT_DATE not null,
  "usage_count" integer default 1 not null,
  "created_at" timestamp with time zone default now() not null,
  "feature" text default 'premium_slides'::text not null,
  primary key ("id")
);
alter table public.daily_free_usage enable row level security;
grant select, insert, update, delete on public.daily_free_usage to authenticated;
grant all on public.daily_free_usage to service_role;
grant select on public.daily_free_usage to anon;
create table if not exists public.daily_promo_slots (
  "date" date default CURRENT_DATE not null,
  "total_slots" integer default 50 not null,
  "claimed_count" integer default 0 not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null
);
alter table public.daily_promo_slots enable row level security;
grant select, insert, update, delete on public.daily_promo_slots to authenticated;
grant all on public.daily_promo_slots to service_role;
grant select on public.daily_promo_slots to anon;
create table if not exists public.dead_letter_jobs (
  "id" uuid default gen_random_uuid() not null,
  "original_id" uuid not null,
  "source_table" text not null,
  "user_id" uuid,
  "runner" text,
  "kind" text,
  "input" jsonb,
  "last_error" text,
  "attempts" integer default 0 not null,
  "provider_errors" jsonb,
  "enqueued_at" timestamp with time zone default now() not null,
  "notified_admin_at" timestamp with time zone,
  "resolved_at" timestamp with time zone,
  "resolution" text,
  primary key ("id")
);
alter table public.dead_letter_jobs enable row level security;
grant select, insert, update, delete on public.dead_letter_jobs to authenticated;
grant all on public.dead_letter_jobs to service_role;
grant select on public.dead_letter_jobs to anon;
create table if not exists public.document_premium_usage (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "template_id" text,
  "kind" text,
  "used_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.document_premium_usage enable row level security;
grant select, insert, update, delete on public.document_premium_usage to authenticated;
grant all on public.document_premium_usage to service_role;
grant select on public.document_premium_usage to anon;
create table if not exists public.document_template_images (
  "template_id" text not null,
  "image_url" text not null,
  "source" text default 'telegram'::text not null,
  "uploaded_by_chat_id" bigint,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null
);
alter table public.document_template_images enable row level security;
grant select, insert, update, delete on public.document_template_images to authenticated;
grant all on public.document_template_images to service_role;
grant select on public.document_template_images to anon;
create table if not exists public.document_templates (
  "id" text not null,
  "kind" text not null,
  "name" text not null,
  "description" text,
  "preview_url" text,
  "category" text default 'standard'::text not null,
  "structure" jsonb default '{}'::jsonb not null,
  "style" jsonb default '{}'::jsonb not null,
  "sort_order" integer default 0 not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.document_templates enable row level security;
grant select, insert, update, delete on public.document_templates to authenticated;
grant all on public.document_templates to service_role;
grant select on public.document_templates to anon;
create table if not exists public.dodo_products (
  "id" uuid default gen_random_uuid() not null,
  "tier" text not null,
  "interval" text not null,
  "product_id" text not null,
  "active" boolean default true not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.dodo_products enable row level security;
grant select, insert, update, delete on public.dodo_products to authenticated;
grant all on public.dodo_products to service_role;
grant select on public.dodo_products to anon;
create table if not exists public.e2b_executions (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "conversation_id" uuid,
  "kind" text not null,
  "language" text,
  "status" text default 'pending'::text not null,
  "input" jsonb default '{}'::jsonb not null,
  "stdout" text,
  "stderr" text,
  "result" jsonb,
  "files" jsonb default '[]'::jsonb,
  "error" text,
  "duration_ms" integer,
  "credits_used" numeric default 0,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.e2b_executions enable row level security;
grant select, insert, update, delete on public.e2b_executions to authenticated;
grant all on public.e2b_executions to service_role;
grant select on public.e2b_executions to anon;
create table if not exists public.e2b_keys (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid,
  "api_key" text not null,
  "label" text,
  "status" text default 'active'::text not null,
  "failure_count" integer default 0 not null,
  "notes" text,
  "last_error" text,
  "last_used_at" timestamp with time zone,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.e2b_keys enable row level security;
grant select, insert, update, delete on public.e2b_keys to authenticated;
grant all on public.e2b_keys to service_role;
grant select on public.e2b_keys to anon;
create table if not exists public.edge_audit_log (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid,
  "endpoint" text not null,
  "action" text not null,
  "status" integer,
  "metadata" jsonb default '{}'::jsonb,
  "ip_hash" text,
  "user_agent" text,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.edge_audit_log enable row level security;
grant select, insert, update, delete on public.edge_audit_log to authenticated;
grant all on public.edge_audit_log to service_role;
grant select on public.edge_audit_log to anon;
create table if not exists public.edge_rate_limits (
  "id" uuid default gen_random_uuid() not null,
  "identifier" text not null,
  "endpoint" text not null,
  "window_start" timestamp with time zone default now() not null,
  "count" integer default 0 not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.edge_rate_limits enable row level security;
grant select, insert, update, delete on public.edge_rate_limits to authenticated;
grant all on public.edge_rate_limits to service_role;
grant select on public.edge_rate_limits to anon;
create table if not exists public.email_logs (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid,
  "to_email" text not null,
  "subject" text not null,
  "type" text default 'general'::text not null,
  "status" text default 'sent'::text not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.email_logs enable row level security;
grant select, insert, update, delete on public.email_logs to authenticated;
grant all on public.email_logs to service_role;
grant select on public.email_logs to anon;
create table if not exists public.focus_sessions (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "task_name" text not null,
  "planned_minutes" integer default 25 not null,
  "actual_seconds" integer default 0 not null,
  "status" text default 'in_progress'::text not null,
  "completed" boolean default false not null,
  "created_at" timestamp with time zone default now() not null,
  "ended_at" timestamp with time zone,
  primary key ("id")
);
alter table public.focus_sessions enable row level security;
grant select, insert, update, delete on public.focus_sessions to authenticated;
grant all on public.focus_sessions to service_role;
grant select on public.focus_sessions to anon;
create table if not exists public.free_trial_usage (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "provider_pool" text not null,
  "model_slug" text not null,
  "used_count" integer default 0 not null,
  "last_used_at" timestamp with time zone default now() not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.free_trial_usage enable row level security;
grant select, insert, update, delete on public.free_trial_usage to authenticated;
grant all on public.free_trial_usage to service_role;
grant select on public.free_trial_usage to anon;
create table if not exists public.generated_sites (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "title" text default 'Untitled Site'::text not null,
  "prompt" text not null,
  "jsx_code" text,
  "html_compiled" text,
  "model_used" text,
  "tokens_used" integer default 0,
  "share_slug" text default encode(extensions.gen_random_bytes(8), 'hex'::text),
  "is_public" boolean default false not null,
  "status" text default 'generating'::text not null,
  "error_message" text,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "preview_url" text,
  "progress" integer default 0 not null,
  "tasks" jsonb default '[]'::jsonb not null,
  "files" jsonb,
  "published_url" text,
  primary key ("id")
);
alter table public.generated_sites enable row level security;
grant select, insert, update, delete on public.generated_sites to authenticated;
grant all on public.generated_sites to service_role;
grant select on public.generated_sites to anon;
create table if not exists public.generated_songs (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "prompt" text not null,
  "audio_url" text not null,
  "title" text default 'Untitled Track'::text,
  "duration_seconds" integer default 60,
  "status" text default 'completed'::text,
  "created_at" timestamp with time zone default now(),
  "updated_at" timestamp with time zone default now(),
  primary key ("id")
);
alter table public.generated_songs enable row level security;
grant select, insert, update, delete on public.generated_songs to authenticated;
grant all on public.generated_songs to service_role;
grant select on public.generated_songs to anon;
create table if not exists public.generation_jobs (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "job_type" text default 'chat'::text not null,
  "status" text default 'pending'::text not null,
  "input_data" jsonb default '{}'::jsonb not null,
  "result_data" jsonb,
  "error_message" text,
  "progress" integer default 0,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.generation_jobs enable row level security;
grant select, insert, update, delete on public.generation_jobs to authenticated;
grant all on public.generation_jobs to service_role;
grant select on public.generation_jobs to anon;
create table if not exists public.github_oauth_states (
  "state" text not null,
  "user_id" uuid not null,
  "redirect_to" text,
  "created_at" timestamp with time zone default now() not null
);
alter table public.github_oauth_states enable row level security;
grant select, insert, update, delete on public.github_oauth_states to authenticated;
grant all on public.github_oauth_states to service_role;
grant select on public.github_oauth_states to anon;
create table if not exists public.headshot_templates (
  "id" uuid default gen_random_uuid() not null,
  "name" text not null,
  "gender" text default 'both'::text,
  "prompt" text not null,
  "preview_url" text,
  "display_order" integer default 0,
  "is_active" boolean default true,
  "created_at" timestamp with time zone default now(),
  primary key ("id")
);
alter table public.headshot_templates enable row level security;
grant select, insert, update, delete on public.headshot_templates to authenticated;
grant all on public.headshot_templates to service_role;
grant select on public.headshot_templates to anon;
create table if not exists public.hitl_tool_approvals (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "tool_name" text not null,
  "decision" text not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.hitl_tool_approvals enable row level security;
grant select, insert, update, delete on public.hitl_tool_approvals to authenticated;
grant all on public.hitl_tool_approvals to service_role;
grant select on public.hitl_tool_approvals to anon;
create table if not exists public.i18n_sync_runs (
  "id" uuid default gen_random_uuid() not null,
  "namespace" text not null,
  "trigger" text default 'cron'::text not null,
  "entries_scanned" integer default 0 not null,
  "entries_translated" integer default 0 not null,
  "entries_skipped" integer default 0 not null,
  "errors" jsonb,
  "started_at" timestamp with time zone default now() not null,
  "finished_at" timestamp with time zone,
  primary key ("id")
);
alter table public.i18n_sync_runs enable row level security;
grant select, insert, update, delete on public.i18n_sync_runs to authenticated;
grant all on public.i18n_sync_runs to service_role;
grant select on public.i18n_sync_runs to anon;
create table if not exists public.i18n_translations (
  "entry_key" text not null,
  "language" text not null,
  "source_hash" text not null,
  "translated_value" jsonb not null,
  "source_value" jsonb,
  "namespace" text default 'docs'::text not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null
);
alter table public.i18n_translations enable row level security;
grant select, insert, update, delete on public.i18n_translations to authenticated;
grant all on public.i18n_translations to service_role;
grant select on public.i18n_translations to anon;
create table if not exists public.image_models (
  "id" uuid default gen_random_uuid() not null,
  "slug" text not null,
  "display_name" text not null,
  "provider" text not null,
  "description" text,
  "thumbnail_url" text,
  "endpoint_text_to_image" text,
  "endpoint_image_to_image" text,
  "endpoint_multi_reference" text,
  "unit" text default 'image'::text not null,
  "unit_cost_usd" numeric default 0 not null,
  "credits" integer default 1 not null,
  "supports_multi_image" boolean default false not null,
  "max_input_images" integer default 1 not null,
  "supported_aspects" jsonb default '["1:1", "3:2", "2:3", "16:9", "9:16"]'::jsonb not null,
  "supported_resolutions" jsonb default '["1K"]'::jsonb not null,
  "default_aspect" text default '1:1'::text not null,
  "default_resolution" text default '1K'::text not null,
  "is_premium" boolean default false not null,
  "is_new" boolean default false not null,
  "is_featured" boolean default false not null,
  "sort_order" integer default 100 not null,
  "is_active" boolean default true not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "api_version" text default 'v2'::text not null,
  "billing_mode" text default 'credit_based'::text not null,
  "free_trial_count" integer default 3 not null,
  "provider_pool" text,
  "model_id_api" text,
  "supports_image_editing" boolean default false not null,
  "supports_text_rendering" boolean default false not null,
  "supports_vector_output" boolean default false not null,
  "max_resolution" text,
  primary key ("id")
);
alter table public.image_models enable row level security;
grant select, insert, update, delete on public.image_models to authenticated;
grant all on public.image_models to service_role;
grant select on public.image_models to anon;
create table if not exists public.image_templates (
  "id" uuid default gen_random_uuid() not null,
  "name" text not null,
  "name_ar" text,
  "type" text default 'personal'::text not null,
  "prompt" text not null,
  "example_image_url" text,
  "display_order" integer default 0 not null,
  "is_active" boolean default true not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.image_templates enable row level security;
grant select, insert, update, delete on public.image_templates to authenticated;
grant all on public.image_templates to service_role;
grant select on public.image_templates to anon;
create table if not exists public.kashier_orders (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "order_id" text not null,
  "amount" numeric not null,
  "currency" text default 'EGP'::text not null,
  "method" text,
  "status" text default 'pending'::text not null,
  "credits" integer default 0 not null,
  "plan" text,
  "kashier_ref" text,
  "raw" jsonb,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.kashier_orders enable row level security;
grant select, insert, update, delete on public.kashier_orders to authenticated;
grant all on public.kashier_orders to service_role;
grant select on public.kashier_orders to anon;
create table if not exists public.key_usage_log (
  "id" uuid default gen_random_uuid() not null,
  "provider" text not null,
  "key_id" uuid,
  "model_id" text,
  "success" boolean not null,
  "cost_usd" numeric,
  "error_message" text,
  "user_id" uuid,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.key_usage_log enable row level security;
grant select, insert, update, delete on public.key_usage_log to authenticated;
grant all on public.key_usage_log to service_role;
grant select on public.key_usage_log to anon;
create table if not exists public.landing_page_prompts (
  "id" uuid default gen_random_uuid() not null,
  "name" text not null,
  "slug" text,
  "description" text,
  "category" text default 'landing-page'::text not null,
  "media_type" text default 'image'::text not null,
  "media_url" text not null,
  "thumbnail_url" text,
  "prompt" text not null,
  "is_pro" boolean default false not null,
  "display_order" integer default 0 not null,
  "is_published" boolean default true not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.landing_page_prompts enable row level security;
grant select, insert, update, delete on public.landing_page_prompts to authenticated;
grant all on public.landing_page_prompts to service_role;
grant select on public.landing_page_prompts to anon;
create table if not exists public.landing_page_prompts_public (
  "id" uuid,
  "name" text,
  "slug" text,
  "description" text,
  "category" text,
  "media_type" text,
  "media_url" text,
  "thumbnail_url" text,
  "is_pro" boolean,
  "display_order" integer,
  "is_published" boolean,
  "created_at" timestamp with time zone,
  "updated_at" timestamp with time zone,
  primary key ("id")
);
alter table public.landing_page_prompts_public enable row level security;
grant select, insert, update, delete on public.landing_page_prompts_public to authenticated;
grant all on public.landing_page_prompts_public to service_role;
grant select on public.landing_page_prompts_public to anon;
create table if not exists public.learn_profile (
  "user_id" uuid not null,
  "interests" text[] default '{}'::text[],
  "level" text,
  "analogy_style" text,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null
);
alter table public.learn_profile enable row level security;
grant select, insert, update, delete on public.learn_profile to authenticated;
grant all on public.learn_profile to service_role;
grant select on public.learn_profile to anon;
create table if not exists public.learn_sessions (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "conversation_id" uuid,
  "topic" text,
  "duration_min" integer default 0,
  "questions_total" integer default 0,
  "questions_correct" integer default 0,
  "weak_topics" jsonb default '[]'::jsonb,
  "mastered_topics" jsonb default '[]'::jsonb,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.learn_sessions enable row level security;
grant select, insert, update, delete on public.learn_sessions to authenticated;
grant all on public.learn_sessions to service_role;
grant select on public.learn_sessions to anon;
create table if not exists public.manus_keys (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid,
  "api_key" text not null,
  "label" text,
  "status" text default 'active'::text not null,
  "failure_count" integer default 0 not null,
  "last_error" text,
  "last_used_at" timestamp with time zone,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.manus_keys enable row level security;
grant select, insert, update, delete on public.manus_keys to authenticated;
grant all on public.manus_keys to service_role;
grant select on public.manus_keys to anon;
create table if not exists public.marketing_accounts (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "campaign_id" uuid,
  "platform" text not null,
  "handle" text,
  "display_name" text,
  "credentials" jsonb default '{}'::jsonb not null,
  "config" jsonb default '{}'::jsonb not null,
  "status" text default 'active'::text not null,
  "last_used_at" timestamp with time zone,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "enabled" boolean default true not null,
  "last_test_at" timestamp with time zone,
  "last_test_ok" boolean,
  "last_test_error" text,
  primary key ("id")
);
alter table public.marketing_accounts enable row level security;
grant select, insert, update, delete on public.marketing_accounts to authenticated;
grant all on public.marketing_accounts to service_role;
grant select on public.marketing_accounts to anon;
create table if not exists public.marketing_ads (
  "id" uuid default gen_random_uuid() not null,
  "campaign_id" uuid not null,
  "user_id" uuid not null,
  "headline" text not null,
  "subheadline" text,
  "cta" text,
  "body_copy" text,
  "visual_prompt" text not null,
  "color_mood" text,
  "image_url" text,
  "aspect_ratio" text default '1:1'::text,
  "platform" text,
  "status" text default 'pending'::text not null,
  "error" text,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.marketing_ads enable row level security;
grant select, insert, update, delete on public.marketing_ads to authenticated;
grant all on public.marketing_ads to service_role;
grant select on public.marketing_ads to anon;
create table if not exists public.marketing_analytics (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "post_id" uuid,
  "account_id" uuid,
  "platform" text not null,
  "external_id" text,
  "likes" integer,
  "reshares" integer,
  "comments" integer,
  "impressions" integer,
  "clicks" integer,
  "raw" jsonb default '{}'::jsonb not null,
  "fetched_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.marketing_analytics enable row level security;
grant select, insert, update, delete on public.marketing_analytics to authenticated;
grant all on public.marketing_analytics to service_role;
grant select on public.marketing_analytics to anon;
create table if not exists public.marketing_campaigns (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "workspace_id" uuid,
  "name" text not null,
  "product_name" text,
  "product_description" text,
  "target_audience" text,
  "tone" text default 'professional'::text,
  "brief" jsonb default '{}'::jsonb not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "goal" text,
  "languages" text[] default ARRAY['ar'::text, 'en'::text],
  "hashtags" text[] default ARRAY[]::text[],
  "schedule_cron" text default '0 9 * * *'::text,
  "ai_model" text default 'qwen-max'::text,
  "ai_prompt_template" text,
  "topics" text[] default ARRAY[]::text[],
  "active" boolean default true not null,
  primary key ("id")
);
alter table public.marketing_campaigns enable row level security;
grant select, insert, update, delete on public.marketing_campaigns to authenticated;
grant all on public.marketing_campaigns to service_role;
grant select on public.marketing_campaigns to anon;
create table if not exists public.marketing_platform_limits (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "account_id" uuid,
  "platform" text not null,
  "window_start" timestamp with time zone default now() not null,
  "count_minute" integer default 0 not null,
  "count_hour" integer default 0 not null,
  "count_day" integer default 0 not null,
  "last_published_at" timestamp with time zone,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.marketing_platform_limits enable row level security;
grant select, insert, update, delete on public.marketing_platform_limits to authenticated;
grant all on public.marketing_platform_limits to service_role;
grant select on public.marketing_platform_limits to anon;
create table if not exists public.marketing_posts (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "campaign_id" uuid,
  "title" text,
  "content" text not null,
  "media_urls" text[] default ARRAY[]::text[],
  "hashtags" text[] default ARRAY[]::text[],
  "language" text default 'ar'::text,
  "platform_variants" jsonb default '{}'::jsonb not null,
  "target_platforms" text[] default ARRAY[]::text[],
  "scheduled_at" timestamp with time zone,
  "published_at" timestamp with time zone,
  "status" text default 'draft'::text not null,
  "ai_generated" boolean default false,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "content_hash" text,
  primary key ("id")
);
alter table public.marketing_posts enable row level security;
grant select, insert, update, delete on public.marketing_posts to authenticated;
grant all on public.marketing_posts to service_role;
grant select on public.marketing_posts to anon;
create table if not exists public.marketing_publish_log (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "post_id" uuid,
  "account_id" uuid,
  "platform" text not null,
  "external_id" text,
  "external_url" text,
  "success" boolean default false not null,
  "error" text,
  "metrics" jsonb default '{}'::jsonb,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.marketing_publish_log enable row level security;
grant select, insert, update, delete on public.marketing_publish_log to authenticated;
grant all on public.marketing_publish_log to service_role;
grant select on public.marketing_publish_log to anon;
create table if not exists public.marketing_publish_queue (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "post_id" uuid not null,
  "account_id" uuid not null,
  "platform" text not null,
  "status" text default 'queued'::text not null,
  "scheduled_at" timestamp with time zone default now() not null,
  "attempts" integer default 0 not null,
  "max_attempts" integer default 5 not null,
  "next_attempt_at" timestamp with time zone default now() not null,
  "last_error" text,
  "last_error_code" text,
  "external_id" text,
  "external_url" text,
  "started_at" timestamp with time zone,
  "completed_at" timestamp with time zone,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.marketing_publish_queue enable row level security;
grant select, insert, update, delete on public.marketing_publish_queue to authenticated;
grant all on public.marketing_publish_queue to service_role;
grant select on public.marketing_publish_queue to anon;
create table if not exists public.mcp_connections (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "name" text not null,
  "url" text not null,
  "transport" text default 'http'::text not null,
  "auth_headers" jsonb default '{}'::jsonb not null,
  "state" text default 'pending'::text not null,
  "tool_names" text[] default ARRAY[]::text[] not null,
  "last_error" text,
  "enabled" boolean default true not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "tool_schemas" jsonb default '[]'::jsonb not null,
  primary key ("id")
);
alter table public.mcp_connections enable row level security;
grant select, insert, update, delete on public.mcp_connections to authenticated;
grant all on public.mcp_connections to service_role;
grant select on public.mcp_connections to anon;
create table if not exists public.media_assets (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "workspace_id" uuid,
  "kind" text not null,
  "provider" text not null,
  "model" text not null,
  "prompt" text,
  "storage_path" text not null,
  "public_url" text not null,
  "cost_credits" numeric default 0 not null,
  "duration_seconds" integer,
  "width" integer,
  "height" integer,
  "metadata" jsonb default '{}'::jsonb not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.media_assets enable row level security;
grant select, insert, update, delete on public.media_assets to authenticated;
grant all on public.media_assets to service_role;
grant select on public.media_assets to anon;
create table if not exists public.media_generation_log (
  "id" uuid default gen_random_uuid() not null,
  "key_id" uuid,
  "provider" text not null,
  "model_id" text not null,
  "user_id" uuid,
  "kind" text not null,
  "status" text not null,
  "error_message" text,
  "duration_ms" integer,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.media_generation_log enable row level security;
grant select, insert, update, delete on public.media_generation_log to authenticated;
grant all on public.media_generation_log to service_role;
grant select on public.media_generation_log to anon;
create table if not exists public.media_key_limits (
  "id" uuid default gen_random_uuid() not null,
  "key_id" uuid not null,
  "model_id" text not null,
  "max_uses" integer not null,
  "reset_period" text default 'none'::text not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.media_key_limits enable row level security;
grant select, insert, update, delete on public.media_key_limits to authenticated;
grant all on public.media_key_limits to service_role;
grant select on public.media_key_limits to anon;
create table if not exists public.media_key_usage (
  "id" uuid default gen_random_uuid() not null,
  "key_id" uuid not null,
  "model_id" text not null,
  "used_count" integer default 0 not null,
  "period_start" timestamp with time zone default now() not null,
  "last_used_at" timestamp with time zone,
  primary key ("id")
);
alter table public.media_key_usage enable row level security;
grant select, insert, update, delete on public.media_key_usage to authenticated;
grant all on public.media_key_usage to service_role;
grant select on public.media_key_usage to anon;
create table if not exists public.media_page_prompts (
  "id" uuid default gen_random_uuid() not null,
  "page_slug" text not null,
  "model_id" text,
  "title" text,
  "prompt_text" text not null,
  "example_image_url" text,
  "position" integer default 0 not null,
  "created_by" uuid,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.media_page_prompts enable row level security;
grant select, insert, update, delete on public.media_page_prompts to authenticated;
grant all on public.media_page_prompts to service_role;
grant select on public.media_page_prompts to anon;
create table if not exists public.media_provider_keys (
  "id" uuid default gen_random_uuid() not null,
  "provider" text not null,
  "api_key" text not null,
  "workspace_id" text,
  "label" text,
  "status" text default 'active'::text not null,
  "priority" integer default 100 not null,
  "notes" text,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "endpoint_host" text,
  primary key ("id")
);
alter table public.media_provider_keys enable row level security;
grant select, insert, update, delete on public.media_provider_keys to authenticated;
grant all on public.media_provider_keys to service_role;
grant select on public.media_provider_keys to anon;
create table if not exists public.meeting_recordings (
  "id" uuid default gen_random_uuid() not null,
  "meeting_id" uuid not null,
  "user_id" uuid not null,
  "audio_url" text,
  "transcript" jsonb default '[]'::jsonb,
  "summary" text,
  "action_items" jsonb default '[]'::jsonb,
  "key_points" jsonb default '[]'::jsonb,
  "decisions" jsonb default '[]'::jsonb,
  "duration_minutes" integer default 0,
  "credits_used" numeric default 0,
  "status" text default 'processing'::text not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.meeting_recordings enable row level security;
grant select, insert, update, delete on public.meeting_recordings to authenticated;
grant all on public.meeting_recordings to service_role;
grant select on public.meeting_recordings to anon;
create table if not exists public.meetings (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "calendar_event_id" text,
  "title" text default 'Untitled Meeting'::text not null,
  "start_time" timestamp with time zone not null,
  "end_time" timestamp with time zone not null,
  "platform" text default 'unknown'::text,
  "meeting_url" text,
  "bot_enabled" boolean default true not null,
  "bot_id" text,
  "status" text default 'upcoming'::text not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.meetings enable row level security;
grant select, insert, update, delete on public.meetings to authenticated;
grant all on public.meetings to service_role;
grant select on public.meetings to anon;
create table if not exists public.megsy_code_skills (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "title" text not null,
  "content" text not null,
  "enabled" boolean default true not null,
  "sort_order" integer default 0 not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "category" text default 'skills'::text not null,
  primary key ("id")
);
alter table public.megsy_code_skills enable row level security;
grant select, insert, update, delete on public.megsy_code_skills to authenticated;
grant all on public.megsy_code_skills to service_role;
grant select on public.megsy_code_skills to anon;
create table if not exists public.memories (
  "id" uuid default gen_random_uuid() not null,
  "key" text not null,
  "value" text not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.memories enable row level security;
grant select, insert, update, delete on public.memories to authenticated;
grant all on public.memories to service_role;
grant select on public.memories to anon;
create table if not exists public.message_feedback (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "project_id" text not null,
  "message_id" text not null,
  "value" text not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.message_feedback enable row level security;
grant select, insert, update, delete on public.message_feedback to authenticated;
grant all on public.message_feedback to service_role;
grant select on public.message_feedback to anon;
create table if not exists public.message_reactions (
  "id" uuid default gen_random_uuid() not null,
  "message_id" uuid not null,
  "user_id" uuid not null,
  "conversation_id" uuid not null,
  "emoji" text not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.message_reactions enable row level security;
grant select, insert, update, delete on public.message_reactions to authenticated;
grant all on public.message_reactions to service_role;
grant select on public.message_reactions to anon;
create table if not exists public.message_reads (
  "message_id" uuid not null,
  "user_id" uuid not null,
  "conversation_id" uuid not null,
  "read_at" timestamp with time zone default now() not null
);
alter table public.message_reads enable row level security;
grant select, insert, update, delete on public.message_reads to authenticated;
grant all on public.message_reads to service_role;
grant select on public.message_reads to anon;
create table if not exists public.messages (
  "id" uuid default gen_random_uuid() not null,
  "conversation_id" uuid not null,
  "role" text not null,
  "content" text not null,
  "images" text[],
  "liked" boolean,
  "created_at" timestamp with time zone default now() not null,
  "user_id" uuid,
  "metadata" jsonb,
  "embedding" vector(1536),
  primary key ("id")
);
alter table public.messages enable row level security;
grant select, insert, update, delete on public.messages to authenticated;
grant all on public.messages to service_role;
grant select on public.messages to anon;
create table if not exists public.model_media (
  "id" uuid default gen_random_uuid() not null,
  "model_id" text not null,
  "media_url" text not null,
  "media_type" text default 'image'::text not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.model_media enable row level security;
grant select, insert, update, delete on public.model_media to authenticated;
grant all on public.model_media to service_role;
grant select on public.model_media to anon;
create table if not exists public.model_pricing (
  "id" text not null,
  "provider" text not null,
  "kind" text not null,
  "label" text not null,
  "endpoint" text not null,
  "unit" text not null,
  "credits_per_unit" numeric,
  "in_price_per_m" numeric,
  "out_price_per_m" numeric,
  "icon" text,
  "badge" text,
  "enabled" boolean default true not null,
  "sort_order" integer default 100 not null,
  "metadata" jsonb default '{}'::jsonb not null,
  "created_at" timestamp with time zone default now() not null,
  "min_credits" numeric,
  "max_credits" numeric,
  primary key ("id")
);
alter table public.model_pricing enable row level security;
grant select, insert, update, delete on public.model_pricing to authenticated;
grant all on public.model_pricing to service_role;
grant select on public.model_pricing to anon;
create table if not exists public.notification_preferences (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "email_welcome" boolean default true not null,
  "email_low_balance" boolean default true not null,
  "email_transactions" boolean default true not null,
  "email_newsletter" boolean default true not null,
  "app_credits" boolean default true not null,
  "app_system" boolean default true not null,
  "app_generation" boolean default true not null,
  "app_referral" boolean default true not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "workspace_id" uuid,
  primary key ("id")
);
alter table public.notification_preferences enable row level security;
grant select, insert, update, delete on public.notification_preferences to authenticated;
grant all on public.notification_preferences to service_role;
grant select on public.notification_preferences to anon;
create table if not exists public.notifications (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "type" text default 'system'::text not null,
  "title" text not null,
  "message" text not null,
  "read" boolean default false not null,
  "metadata" jsonb default '{}'::jsonb,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.notifications enable row level security;
grant select, insert, update, delete on public.notifications to authenticated;
grant all on public.notifications to service_role;
grant select on public.notifications to anon;
create table if not exists public.oauth_clients (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "client_id" text not null,
  "client_secret_hash" text not null,
  "name" text not null,
  "logo_url" text,
  "redirect_uris" text[] default '{}'::text[] not null,
  "is_public" boolean default false,
  "created_at" timestamp with time zone default now(),
  primary key ("id")
);
alter table public.oauth_clients enable row level security;
grant select, insert, update, delete on public.oauth_clients to authenticated;
grant all on public.oauth_clients to service_role;
grant select on public.oauth_clients to anon;
create table if not exists public.oauth_codes (
  "id" uuid default gen_random_uuid() not null,
  "code" text not null,
  "client_id" text not null,
  "user_id" uuid not null,
  "redirect_uri" text not null,
  "scope" text default 'read'::text,
  "used" boolean default false,
  "expires_at" timestamp with time zone not null,
  "created_at" timestamp with time zone default now(),
  primary key ("id")
);
alter table public.oauth_codes enable row level security;
grant select, insert, update, delete on public.oauth_codes to authenticated;
grant all on public.oauth_codes to service_role;
grant select on public.oauth_codes to anon;
create table if not exists public.oauth_tokens (
  "id" uuid default gen_random_uuid() not null,
  "access_token" text not null,
  "client_id" text not null,
  "user_id" uuid not null,
  "scope" text default 'read'::text,
  "expires_at" timestamp with time zone not null,
  "created_at" timestamp with time zone default now(),
  primary key ("id")
);
alter table public.oauth_tokens enable row level security;
grant select, insert, update, delete on public.oauth_tokens to authenticated;
grant all on public.oauth_tokens to service_role;
grant select on public.oauth_tokens to anon;
create table if not exists public.operator_agent_messages (
  "id" uuid default gen_random_uuid() not null,
  "run_id" uuid not null,
  "agent" text not null,
  "role" text default 'assistant'::text not null,
  "content" text not null,
  "metadata" jsonb default '{}'::jsonb,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.operator_agent_messages enable row level security;
grant select, insert, update, delete on public.operator_agent_messages to authenticated;
grant all on public.operator_agent_messages to service_role;
grant select on public.operator_agent_messages to anon;
create table if not exists public.operator_artifacts (
  "id" uuid default gen_random_uuid() not null,
  "run_id" uuid not null,
  "step_id" uuid,
  "kind" text not null,
  "url" text,
  "content" text,
  "metadata" jsonb default '{}'::jsonb,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.operator_artifacts enable row level security;
grant select, insert, update, delete on public.operator_artifacts to authenticated;
grant all on public.operator_artifacts to service_role;
grant select on public.operator_artifacts to anon;
create table if not exists public.operator_audit_log (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "run_id" uuid,
  "agent" text not null,
  "action" text not null,
  "payload" jsonb default '{}'::jsonb not null,
  "result" jsonb,
  "error" text,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.operator_audit_log enable row level security;
grant select, insert, update, delete on public.operator_audit_log to authenticated;
grant all on public.operator_audit_log to service_role;
grant select on public.operator_audit_log to anon;
create table if not exists public.operator_dynamic_agents (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "key" text not null,
  "label" text not null,
  "color" text default '#ec4899'::text not null,
  "system_prompt" text not null,
  "description" text,
  "icon" text,
  "spawned_from_run_id" uuid,
  "usage_count" integer default 0 not null,
  "last_used_at" timestamp with time zone,
  "created_at" timestamp with time zone default now() not null,
  "image_url" text,
  primary key ("id")
);
alter table public.operator_dynamic_agents enable row level security;
grant select, insert, update, delete on public.operator_dynamic_agents to authenticated;
grant all on public.operator_dynamic_agents to service_role;
grant select on public.operator_dynamic_agents to anon;
create table if not exists public.operator_memory (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "fact" text not null,
  "category" text,
  "importance" integer default 5 not null,
  "source_run_id" uuid,
  "created_at" timestamp with time zone default now() not null,
  "last_accessed_at" timestamp with time zone,
  primary key ("id")
);
alter table public.operator_memory enable row level security;
grant select, insert, update, delete on public.operator_memory to authenticated;
grant all on public.operator_memory to service_role;
grant select on public.operator_memory to anon;
create table if not exists public.operator_runs (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "goal" text not null,
  "status" text default 'pending'::text not null,
  "current_phase" text,
  "project_id" uuid,
  "published_url" text,
  "result" jsonb default '{}'::jsonb,
  "metadata" jsonb default '{}'::jsonb,
  "error" text,
  "last_tick_at" timestamp with time zone,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "mode" text default 'task'::text not null,
  "chat_response" text,
  "browser_session_id" text,
  "live_view_url" text,
  "manus_task_id" text,
  "manus_cursor" text,
  primary key ("id")
);
alter table public.operator_runs enable row level security;
grant select, insert, update, delete on public.operator_runs to authenticated;
grant all on public.operator_runs to service_role;
grant select on public.operator_runs to anon;
create table if not exists public.operator_steps (
  "id" uuid default gen_random_uuid() not null,
  "run_id" uuid not null,
  "step_no" integer not null,
  "agent" text default 'executor'::text not null,
  "title" text not null,
  "description" text,
  "tool" text,
  "tool_input" jsonb default '{}'::jsonb,
  "tool_output" jsonb default '{}'::jsonb,
  "status" text default 'pending'::text not null,
  "retries" integer default 0 not null,
  "error" text,
  "started_at" timestamp with time zone,
  "finished_at" timestamp with time zone,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.operator_steps enable row level security;
grant select, insert, update, delete on public.operator_steps to authenticated;
grant all on public.operator_steps to service_role;
grant select on public.operator_steps to anon;
create table if not exists public.operator_user_settings (
  "user_id" uuid not null,
  "ask_before_sensitive" boolean default true not null,
  "ask_before_anything" boolean default false not null,
  "allow_free_shell" boolean default false not null,
  "allow_browser_automation" boolean default true not null,
  "allow_dynamic_agents" boolean default true not null,
  "max_parallel_agents" integer default 3 not null,
  "budget_cap_cents" integer default 500 not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null
);
alter table public.operator_user_settings enable row level security;
grant select, insert, update, delete on public.operator_user_settings to authenticated;
grant all on public.operator_user_settings to service_role;
grant select on public.operator_user_settings to anon;
create table if not exists public.otp_codes (
  "id" uuid default gen_random_uuid() not null,
  "email" text not null,
  "code" text not null,
  "expires_at" timestamp with time zone not null,
  "used" boolean default false not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.otp_codes enable row level security;
grant select, insert, update, delete on public.otp_codes to authenticated;
grant all on public.otp_codes to service_role;
grant select on public.otp_codes to anon;
create table if not exists public.parallel_monitor_events (
  "id" uuid default gen_random_uuid() not null,
  "monitor_id" uuid not null,
  "user_id" uuid not null,
  "event_type" text default 'update'::text not null,
  "summary" text,
  "payload" jsonb default '{}'::jsonb not null,
  "citations" jsonb,
  "seen" boolean default false not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.parallel_monitor_events enable row level security;
grant select, insert, update, delete on public.parallel_monitor_events to authenticated;
grant all on public.parallel_monitor_events to service_role;
grant select on public.parallel_monitor_events to anon;
create table if not exists public.parallel_monitors (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "title" text not null,
  "objective" text not null,
  "parallel_monitor_id" text,
  "status" text default 'active'::text not null,
  "frequency" text default 'daily'::text,
  "conversation_id" uuid,
  "config" jsonb default '{}'::jsonb,
  "last_event_at" timestamp with time zone,
  "event_count" integer default 0 not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.parallel_monitors enable row level security;
grant select, insert, update, delete on public.parallel_monitors to authenticated;
grant all on public.parallel_monitors to service_role;
grant select on public.parallel_monitors to anon;
create table if not exists public.parallel_tasks (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "task_type" text not null,
  "status" text default 'pending'::text not null,
  "parallel_task_id" text,
  "parallel_processor" text,
  "input" jsonb default '{}'::jsonb not null,
  "output" jsonb,
  "citations" jsonb,
  "error" text,
  "webhook_received_at" timestamp with time zone,
  "conversation_id" uuid,
  "message_id" uuid,
  "metadata" jsonb default '{}'::jsonb,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "completed_at" timestamp with time zone,
  primary key ("id")
);
alter table public.parallel_tasks enable row level security;
grant select, insert, update, delete on public.parallel_tasks to authenticated;
grant all on public.parallel_tasks to service_role;
grant select on public.parallel_tasks to anon;
create table if not exists public.payment_events (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid,
  "event_type" text not null,
  "polar_event_id" text,
  "payload" jsonb default '{}'::jsonb not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.payment_events enable row level security;
grant select, insert, update, delete on public.payment_events to authenticated;
grant all on public.payment_events to service_role;
grant select on public.payment_events to anon;
create table if not exists public.pending_video_jobs (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "workspace_id" uuid,
  "provider" text default 'leonardo'::text not null,
  "model_slug" text not null,
  "generation_id" text not null,
  "api_key_id" uuid,
  "credits_charged" integer default 0 not null,
  "prompt" text,
  "width" integer,
  "height" integer,
  "duration_seconds" integer,
  "aspect_ratio" text,
  "resolution" text,
  "start_frame_url" text,
  "end_frame_url" text,
  "status" text default 'pending'::text not null,
  "video_url" text,
  "error" text,
  "refunded" boolean default false not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.pending_video_jobs enable row level security;
grant select, insert, update, delete on public.pending_video_jobs to authenticated;
grant all on public.pending_video_jobs to service_role;
grant select on public.pending_video_jobs to anon;
create table if not exists public.pipedream_accounts (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "app_slug" text not null,
  "account_id" text not null,
  "external_user_id" text not null,
  "account_name" text,
  "healthy" boolean default true,
  "metadata" jsonb default '{}'::jsonb,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.pipedream_accounts enable row level security;
grant select, insert, update, delete on public.pipedream_accounts to authenticated;
grant all on public.pipedream_accounts to service_role;
grant select on public.pipedream_accounts to anon;
create table if not exists public.pipedream_tool_settings (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "app_slug" text not null,
  "enabled" boolean default true not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.pipedream_tool_settings enable row level security;
grant select, insert, update, delete on public.pipedream_tool_settings to authenticated;
grant all on public.pipedream_tool_settings to service_role;
grant select on public.pipedream_tool_settings to anon;
create table if not exists public.pptx_jobs (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid,
  "prompt" text not null,
  "doc_type" text default 'pptx'::text not null,
  "status" text default 'queued'::text not null,
  "file_url" text,
  "file_name" text,
  "error" text,
  "logs" jsonb,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.pptx_jobs enable row level security;
grant select, insert, update, delete on public.pptx_jobs to authenticated;
grant all on public.pptx_jobs to service_role;
grant select on public.pptx_jobs to anon;
create table if not exists public.premium_usage (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "template_id" text,
  "used_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.premium_usage enable row level security;
grant select, insert, update, delete on public.premium_usage to authenticated;
grant all on public.premium_usage to service_role;
grant select on public.premium_usage to anon;
create table if not exists public.processed_orders (
  "id" uuid default gen_random_uuid() not null,
  "polar_order_id" text not null,
  "user_id" uuid not null,
  "product_id" text,
  "plan" text,
  "credits" numeric not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.processed_orders enable row level security;
grant select, insert, update, delete on public.processed_orders to authenticated;
grant all on public.processed_orders to service_role;
grant select on public.processed_orders to anon;
create table if not exists public.profiles (
  "id" uuid not null,
  "credits" numeric default 0 not null,
  "plan" text default 'free'::text not null,
  "display_name" text,
  "avatar_url" text,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "two_factor_enabled" boolean default false not null,
  "active_workspace_id" uuid,
  "chat_greeted" boolean default false not null,
  "agents_onboarding_seen" boolean default false not null,
  "age_gate_acked_at" timestamp with time zone,
  "image_free_uses" integer default 0 not null,
  primary key ("id")
);
alter table public.profiles enable row level security;
grant select, insert, update, delete on public.profiles to authenticated;
grant all on public.profiles to service_role;
grant select on public.profiles to anon;
create table if not exists public.project_custom_domains (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "project_id" uuid not null,
  "domain" text not null,
  "verification_status" text default 'pending'::text not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.project_custom_domains enable row level security;
grant select, insert, update, delete on public.project_custom_domains to authenticated;
grant all on public.project_custom_domains to service_role;
grant select on public.project_custom_domains to anon;
create table if not exists public.project_drafts (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "project_id" uuid not null,
  "content" text default ''::text not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.project_drafts enable row level security;
grant select, insert, update, delete on public.project_drafts to authenticated;
grant all on public.project_drafts to service_role;
grant select on public.project_drafts to anon;
create table if not exists public.project_versions (
  "id" uuid default gen_random_uuid() not null,
  "project_id" uuid not null,
  "user_id" uuid,
  "message" text,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.project_versions enable row level security;
grant select, insert, update, delete on public.project_versions to authenticated;
grant all on public.project_versions to service_role;
grant select on public.project_versions to anon;
create table if not exists public.project_visits (
  "id" uuid default gen_random_uuid() not null,
  "project_id" uuid not null,
  "path" text default '/'::text not null,
  "referrer" text,
  "ua_hash" text,
  "country" text,
  "device" text,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.project_visits enable row level security;
grant select, insert, update, delete on public.project_visits to authenticated;
grant all on public.project_visits to service_role;
grant select on public.project_visits to anon;
create table if not exists public.projects (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "name" text default 'Untitled'::text not null,
  "description" text,
  "status" text default 'active'::text not null,
  "thumbnail_url" text,
  "preview_url" text,
  "published_url" text,
  "custom_domain" text,
  "workspace_id" uuid,
  "linked_supabase_project_ref" text,
  "linked_supabase_project_name" text,
  "github_repo" text,
  "visibility" text default 'private'::text not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "publish_settings" jsonb default '{}'::jsonb not null,
  "files_snapshot" jsonb,
  "linked_supabase_url" text,
  "v0_chat_id" text,
  "v0_project_id" text,
  "v0_latest_version_id" text,
  "model_tier" text,
  "instructions" text,
  primary key ("id")
);
alter table public.projects enable row level security;
grant select, insert, update, delete on public.projects to authenticated;
grant all on public.projects to service_role;
grant select on public.projects to anon;
create table if not exists public.promo_deadlines (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "promo_key" text default 'megsy_pro_50'::text not null,
  "deadline_at" timestamp with time zone not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.promo_deadlines enable row level security;
grant select, insert, update, delete on public.promo_deadlines to authenticated;
grant all on public.promo_deadlines to service_role;
grant select on public.promo_deadlines to anon;
create table if not exists public.provider_circuit_state (
  "id" uuid default gen_random_uuid() not null,
  "scope" text not null,
  "scope_id" text not null,
  "state" text default 'closed'::text not null,
  "failure_count" integer default 0 not null,
  "success_count" integer default 0 not null,
  "opened_at" timestamp with time zone,
  "reopens_at" timestamp with time zone,
  "last_error" text,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.provider_circuit_state enable row level security;
grant select, insert, update, delete on public.provider_circuit_state to authenticated;
grant all on public.provider_circuit_state to service_role;
grant select on public.provider_circuit_state to anon;
create table if not exists public.push_subscriptions (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "endpoint" text not null,
  "p256dh" text not null,
  "auth" text not null,
  "user_agent" text,
  "created_at" timestamp with time zone default now() not null,
  "last_used_at" timestamp with time zone,
  primary key ("id")
);
alter table public.push_subscriptions enable row level security;
grant select, insert, update, delete on public.push_subscriptions to authenticated;
grant all on public.push_subscriptions to service_role;
grant select on public.push_subscriptions to anon;
create table if not exists public.rate_limit_buckets (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid,
  "ip_hash" text,
  "bucket" text not null,
  "window_start" timestamp with time zone default date_trunc('minute'::text, now()) not null,
  "count" integer default 0 not null,
  "hour_count" integer default 0 not null,
  "hour_start" timestamp with time zone default date_trunc('hour'::text, now()) not null,
  "blocked_until" timestamp with time zone,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.rate_limit_buckets enable row level security;
grant select, insert, update, delete on public.rate_limit_buckets to authenticated;
grant all on public.rate_limit_buckets to service_role;
grant select on public.rate_limit_buckets to anon;
create table if not exists public.referral_clicks (
  "id" uuid default gen_random_uuid() not null,
  "code" text not null,
  "referrer_user_id" uuid,
  "ip_hash" text,
  "user_agent" text,
  "referer" text,
  "utm_source" text,
  "utm_medium" text,
  "utm_campaign" text,
  "country" text,
  "landing_path" text,
  "converted_user_id" uuid,
  "converted_at" timestamp with time zone,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.referral_clicks enable row level security;
grant select, insert, update, delete on public.referral_clicks to authenticated;
grant all on public.referral_clicks to service_role;
grant select on public.referral_clicks to anon;
create table if not exists public.referral_codes (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "code" text not null,
  "created_at" timestamp with time zone default now() not null,
  "referral_mode" text default 'cash'::text not null,
  primary key ("id")
);
alter table public.referral_codes enable row level security;
grant select, insert, update, delete on public.referral_codes to authenticated;
grant all on public.referral_codes to service_role;
grant select on public.referral_codes to anon;
create table if not exists public.referral_earnings (
  "id" uuid default gen_random_uuid() not null,
  "referrer_id" uuid not null,
  "referred_id" uuid not null,
  "amount" numeric default 0 not null,
  "source_action" text not null,
  "created_at" timestamp with time zone default now() not null,
  "available_at" timestamp with time zone default (now() + '7 days'::interval) not null,
  "commission_pct" numeric,
  "net_revenue_cents" integer,
  "subscription_id" uuid,
  "period_start" date,
  primary key ("id")
);
alter table public.referral_earnings enable row level security;
grant select, insert, update, delete on public.referral_earnings to authenticated;
grant all on public.referral_earnings to service_role;
grant select on public.referral_earnings to anon;
create table if not exists public.referral_tiers (
  "id" text not null,
  "name" text not null,
  "rate_pct" numeric not null,
  "min_active_refs" integer default 0 not null,
  "min_net_mrr_cents" integer default 0 not null,
  "sort_order" integer not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.referral_tiers enable row level security;
grant select, insert, update, delete on public.referral_tiers to authenticated;
grant all on public.referral_tiers to service_role;
grant select on public.referral_tiers to anon;
create table if not exists public.referrals (
  "id" uuid default gen_random_uuid() not null,
  "referrer_id" uuid not null,
  "referred_id" uuid not null,
  "referral_code" text not null,
  "status" text default 'pending'::text not null,
  "created_at" timestamp with time zone default now() not null,
  "ip_hash" text,
  "fingerprint_hash" text,
  primary key ("id")
);
alter table public.referrals enable row level security;
grant select, insert, update, delete on public.referrals to authenticated;
grant all on public.referrals to service_role;
grant select on public.referrals to anon;
create table if not exists public.research_jobs (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "conversation_id" uuid,
  "query" text not null,
  "language" text,
  "status" text default 'queued'::text not null,
  "progress" integer default 0 not null,
  "stage" text,
  "plan" jsonb default '[]'::jsonb not null,
  "steps" jsonb default '[]'::jsonb not null,
  "sources" jsonb default '[]'::jsonb not null,
  "images" jsonb default '[]'::jsonb not null,
  "report" text,
  "error" text,
  "started_at" timestamp with time zone,
  "finished_at" timestamp with time zone,
  "duration_ms" integer,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "approved_at" timestamp with time zone,
  "plan_goal" text,
  "plan_intro" text,
  "plan_ready" text,
  "awaiting_approval" boolean default false not null,
  "thinking" text,
  "unused_sources" jsonb default '[]'::jsonb not null,
  "needs_images" boolean default true not null,
  "outline" jsonb,
  "report_sections" jsonb default '[]'::jsonb,
  "context_excerpts" jsonb default '[]'::jsonb,
  "depth" text default 'medium'::text not null,
  "attempt" integer default 0 not null,
  "max_attempts" integer default 3 not null,
  "next_run_at" timestamp with time zone default now(),
  "checkpoint" jsonb default '{}'::jsonb not null,
  "provider_errors" jsonb default '[]'::jsonb not null,
  "resumable" boolean default true not null,
  "last_heartbeat_at" timestamp with time zone,
  primary key ("id")
);
alter table public.research_jobs enable row level security;
grant select, insert, update, delete on public.research_jobs to authenticated;
grant all on public.research_jobs to service_role;
grant select on public.research_jobs to anon;
create table if not exists public.research_messages (
  "id" uuid default gen_random_uuid() not null,
  "session_id" uuid not null,
  "role" text not null,
  "content" text not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.research_messages enable row level security;
grant select, insert, update, delete on public.research_messages to authenticated;
grant all on public.research_messages to service_role;
grant select on public.research_messages to anon;
create table if not exists public.research_reports (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "session_key" text not null,
  "query" text not null,
  "report" text default ''::text not null,
  "images" jsonb default '[]'::jsonb not null,
  "steps" jsonb default '[]'::jsonb not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "share_token" text,
  "used_sources" jsonb default '[]'::jsonb not null,
  "unused_sources" jsonb default '[]'::jsonb not null,
  "thinking" text,
  "plan" jsonb default '[]'::jsonb not null,
  primary key ("id")
);
alter table public.research_reports enable row level security;
grant select, insert, update, delete on public.research_reports to authenticated;
grant all on public.research_reports to service_role;
grant select on public.research_reports to anon;
create table if not exists public.research_sessions (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "title" text default 'بحث جديد'::text not null,
  "query" text not null,
  "depth" text default 'quick'::text not null,
  "status" text default 'planning'::text not null,
  "plan" jsonb default '[]'::jsonb,
  "report" text,
  "sources_count" integer default 0,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.research_sessions enable row level security;
grant select, insert, update, delete on public.research_sessions to authenticated;
grant all on public.research_sessions to service_role;
grant select on public.research_sessions to anon;
create table if not exists public.research_sources (
  "id" uuid default gen_random_uuid() not null,
  "session_id" uuid not null,
  "title" text not null,
  "url" text,
  "source_type" text default 'web'::text not null,
  "reliability" text default 'medium'::text,
  "snippet" text,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.research_sources enable row level security;
grant select, insert, update, delete on public.research_sources to authenticated;
grant all on public.research_sources to service_role;
grant select on public.research_sources to anon;
create table if not exists public.revenue_ledger (
  "id" uuid default gen_random_uuid() not null,
  "subscription_id" text,
  "user_id" uuid,
  "gross_amount" numeric not null,
  "tax_rate" numeric default 0.22 not null,
  "tax_amount" numeric not null,
  "net_amount" numeric not null,
  "currency" text default 'USD'::text not null,
  "source" text,
  "metadata" jsonb default '{}'::jsonb,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.revenue_ledger enable row level security;
grant select, insert, update, delete on public.revenue_ledger to authenticated;
grant all on public.revenue_ledger to service_role;
grant select on public.revenue_ledger to anon;
create table if not exists public.reward_tasks (
  "id" uuid default gen_random_uuid() not null,
  "task_key" text not null,
  "title" text not null,
  "description" text,
  "reward_credits" numeric default 0 not null,
  "action_type" text not null,
  "action_url" text,
  "target_count" integer default 1 not null,
  "icon" text,
  "active" boolean default true not null,
  "sort_order" integer default 0 not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.reward_tasks enable row level security;
grant select, insert, update, delete on public.reward_tasks to authenticated;
grant all on public.reward_tasks to service_role;
grant select on public.reward_tasks to anon;
create table if not exists public.rp_portal_settings (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "payment_method" text default 'paypal'::text,
  "payment_details" text default ''::text,
  "notify_on_signup" boolean default true,
  "notify_on_earning" boolean default true,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.rp_portal_settings enable row level security;
grant select, insert, update, delete on public.rp_portal_settings to authenticated;
grant all on public.rp_portal_settings to service_role;
grant select on public.rp_portal_settings to anon;
create table if not exists public.runbase_keys (
  "id" uuid default gen_random_uuid() not null,
  "api_key" text not null,
  "label" text,
  "status" text default 'active'::text not null,
  "balance_usd" numeric default 0 not null,
  "spent_usd" numeric default 0 not null,
  "failure_count" integer default 0 not null,
  "blocked_reason" text,
  "last_used_at" timestamp with time zone,
  "last_error" text,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.runbase_keys enable row level security;
grant select, insert, update, delete on public.runbase_keys to authenticated;
grant all on public.runbase_keys to service_role;
grant select on public.runbase_keys to anon;
create table if not exists public.scheduled_user_messages (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "prompt" text not null,
  "schedule_cron" text default '0 10 * * *'::text not null,
  "timezone" text default 'UTC'::text not null,
  "next_run_at" timestamp with time zone,
  "last_run_at" timestamp with time zone,
  "enabled" boolean default true not null,
  "title" text,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.scheduled_user_messages enable row level security;
grant select, insert, update, delete on public.scheduled_user_messages to authenticated;
grant all on public.scheduled_user_messages to service_role;
grant select on public.scheduled_user_messages to anon;
create table if not exists public.security_audit_log (
  "id" uuid default gen_random_uuid() not null,
  "event_type" text not null,
  "severity" text default 'info'::text not null,
  "actor_user_id" uuid,
  "target_id" text,
  "function_name" text,
  "provider" text,
  "details" jsonb default '{}'::jsonb not null,
  "ip_hash" text,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.security_audit_log enable row level security;
grant select, insert, update, delete on public.security_audit_log to authenticated;
grant all on public.security_audit_log to service_role;
grant select on public.security_audit_log to anon;
create table if not exists public.security_findings (
  "id" uuid default gen_random_uuid() not null,
  "scan_id" uuid not null,
  "project_id" uuid not null,
  "user_id" uuid not null,
  "level" text not null,
  "scanner_name" text not null,
  "internal_id" text not null,
  "title" text not null,
  "description" text default ''::text not null,
  "details" text default ''::text not null,
  "learn_more_url" text,
  "fix_prompt" text default ''::text not null,
  "status" text default 'open'::text not null,
  "ignored_reason" text,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.security_findings enable row level security;
grant select, insert, update, delete on public.security_findings to authenticated;
grant all on public.security_findings to service_role;
grant select on public.security_findings to anon;
create table if not exists public.security_memory (
  "project_id" uuid not null,
  "user_id" uuid not null,
  "content" text default ''::text not null,
  "updated_at" timestamp with time zone default now() not null
);
alter table public.security_memory enable row level security;
grant select, insert, update, delete on public.security_memory to authenticated;
grant all on public.security_memory to service_role;
grant select on public.security_memory to anon;
create table if not exists public.security_scans (
  "id" uuid default gen_random_uuid() not null,
  "project_id" uuid not null,
  "user_id" uuid not null,
  "status" text default 'pending'::text not null,
  "started_at" timestamp with time zone default now() not null,
  "completed_at" timestamp with time zone,
  "summary" jsonb default '{}'::jsonb not null,
  "error_count" integer default 0 not null,
  "warning_count" integer default 0 not null,
  "info_count" integer default 0 not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.security_scans enable row level security;
grant select, insert, update, delete on public.security_scans to authenticated;
grant all on public.security_scans to service_role;
grant select on public.security_scans to anon;
create table if not exists public.service_incidents (
  "id" uuid default gen_random_uuid() not null,
  "service_name" text not null,
  "status" text default 'investigating'::text not null,
  "title" text not null,
  "message" text,
  "started_at" timestamp with time zone default now() not null,
  "resolved_at" timestamp with time zone,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.service_incidents enable row level security;
grant select, insert, update, delete on public.service_incidents to authenticated;
grant all on public.service_incidents to service_role;
grant select on public.service_incidents to anon;
create table if not exists public.service_status (
  "id" uuid default gen_random_uuid() not null,
  "service_name" text not null,
  "service_url" text not null,
  "status" text default 'operational'::text not null,
  "response_time_ms" integer,
  "error_message" text,
  "checked_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.service_status enable row level security;
grant select, insert, update, delete on public.service_status to authenticated;
grant all on public.service_status to service_role;
grant select on public.service_status to anon;
create table if not exists public.service_status_public (
  "service_name" text,
  "status" text,
  "checked_at" timestamp with time zone,
  "response_time_ms" integer
);
alter table public.service_status_public enable row level security;
grant select, insert, update, delete on public.service_status_public to authenticated;
grant all on public.service_status_public to service_role;
grant select on public.service_status_public to anon;
create table if not exists public.shopping_product_reports (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "product_key" text not null,
  "product_data" jsonb default '{}'::jsonb not null,
  "ai_report" text default ''::text not null,
  "currency" text default 'USD'::text not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.shopping_product_reports enable row level security;
grant select, insert, update, delete on public.shopping_product_reports to authenticated;
grant all on public.shopping_product_reports to service_role;
grant select on public.shopping_product_reports to anon;
create table if not exists public.showcase_items (
  "id" uuid default gen_random_uuid() not null,
  "media_url" text not null,
  "media_type" text default 'image'::text not null,
  "prompt" text default ''::text not null,
  "model_id" text default ''::text not null,
  "model_name" text default ''::text not null,
  "aspect_ratio" text default '1:1'::text not null,
  "quality" text default '2K'::text not null,
  "duration" text,
  "style" text,
  "display_order" integer default 0 not null,
  "created_at" timestamp with time zone default now() not null,
  "is_trending" boolean default false not null,
  "trending_at" timestamp with time zone,
  "thumbnail_url" text,
  "category" text default 'All'::text,
  "source" text,
  "kind" text default 'media'::text not null,
  primary key ("id")
);
alter table public.showcase_items enable row level security;
grant select, insert, update, delete on public.showcase_items to authenticated;
grant all on public.showcase_items to service_role;
grant select on public.showcase_items to anon;
create table if not exists public.skill_files (
  "id" uuid default gen_random_uuid() not null,
  "skill_id" uuid not null,
  "user_id" uuid not null,
  "path" text not null,
  "storage_path" text not null,
  "size_bytes" integer default 0 not null,
  "mime_type" text default 'application/octet-stream'::text not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.skill_files enable row level security;
grant select, insert, update, delete on public.skill_files to authenticated;
grant all on public.skill_files to service_role;
grant select on public.skill_files to anon;
create table if not exists public.skills (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "name" text not null,
  "description" text default ''::text not null,
  "instructions" text default ''::text not null,
  "enabled_tools" text[] default '{}'::text[] not null,
  "preferred_model" text,
  "icon" text,
  "is_active" boolean default true not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "body" text default ''::text not null,
  "triggers" text[] default '{}'::text[] not null,
  "is_enabled" boolean default true not null,
  "workspace_id" uuid,
  "embedding" vector(1536),
  primary key ("id")
);
alter table public.skills enable row level security;
grant select, insert, update, delete on public.skills to authenticated;
grant all on public.skills to service_role;
grant select on public.skills to anon;
create table if not exists public.slide_projects (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "title" text default 'Untitled Presentation'::text not null,
  "topic" text not null,
  "style" text default 'formal'::text not null,
  "template_id" text,
  "slide_count" integer default 10 not null,
  "status" text default 'pending'::text not null,
  "pptx_url" text,
  "slides_data" jsonb default '[]'::jsonb,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.slide_projects enable row level security;
grant select, insert, update, delete on public.slide_projects to authenticated;
grant all on public.slide_projects to service_role;
grant select on public.slide_projects to anon;
create table if not exists public.slide_templates (
  "id" uuid default gen_random_uuid() not null,
  "template_id" text not null,
  "image_url" text,
  "display_order" integer default 0 not null,
  "is_active" boolean default true not null,
  "created_at" timestamp with time zone default now() not null,
  "template_engine" text default '2slides'::text not null,
  "component_name" text,
  "name" text,
  "description" text,
  primary key ("id")
);
alter table public.slide_templates enable row level security;
grant select, insert, update, delete on public.slide_templates to authenticated;
grant all on public.slide_templates to service_role;
grant select on public.slide_templates to anon;
create table if not exists public.spreadsheet_projects (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "title" text default 'Untitled Spreadsheet'::text not null,
  "description" text,
  "file_url" text,
  "sheet_data" jsonb default '[]'::jsonb,
  "status" text default 'completed'::text not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.spreadsheet_projects enable row level security;
grant select, insert, update, delete on public.spreadsheet_projects to authenticated;
grant all on public.spreadsheet_projects to service_role;
grant select on public.spreadsheet_projects to anon;
create table if not exists public.status_subscribers (
  "id" uuid default gen_random_uuid() not null,
  "channel" text default 'email'::text not null,
  "contact" text not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.status_subscribers enable row level security;
grant select, insert, update, delete on public.status_subscribers to authenticated;
grant all on public.status_subscribers to service_role;
grant select on public.status_subscribers to anon;
create table if not exists public.student_exams (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "subject" text not null,
  "topic" text,
  "difficulty" text default 'medium'::text not null,
  "questions" jsonb default '[]'::jsonb not null,
  "answers" jsonb default '[]'::jsonb not null,
  "score" numeric default 0 not null,
  "total_questions" integer default 0 not null,
  "duration_seconds" integer default 0 not null,
  "weak_areas" jsonb default '[]'::jsonb not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.student_exams enable row level security;
grant select, insert, update, delete on public.student_exams to authenticated;
grant all on public.student_exams to service_role;
grant select on public.student_exams to anon;
create table if not exists public.student_mistakes (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "topic" text not null,
  "concept" text not null,
  "mistake_count" integer default 1 not null,
  "mistake_type" text default 'concept'::text not null,
  "next_review_at" timestamp with time zone default (now() + '1 day'::interval) not null,
  "review_stage" integer default 0 not null,
  "resolved" boolean default false not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.student_mistakes enable row level security;
grant select, insert, update, delete on public.student_mistakes to authenticated;
grant all on public.student_mistakes to service_role;
grant select on public.student_mistakes to anon;
create table if not exists public.student_profiles (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "age" integer,
  "native_language" text,
  "country" text,
  "learning_style" text,
  "preferred_study_time" text,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.student_profiles enable row level security;
grant select, insert, update, delete on public.student_profiles to authenticated;
grant all on public.student_profiles to service_role;
grant select on public.student_profiles to anon;
create table if not exists public.student_topics (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "topic" text not null,
  "level" text default 'beginner'::text not null,
  "progress" integer default 0 not null,
  "last_position" text,
  "last_studied_at" timestamp with time zone,
  "curriculum_map" jsonb default '[]'::jsonb not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.student_topics enable row level security;
grant select, insert, update, delete on public.student_topics to authenticated;
grant all on public.student_topics to service_role;
grant select on public.student_topics to anon;
create table if not exists public.study_plans (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "subjects" text not null,
  "exam_date" date,
  "hours_per_day" integer default 3 not null,
  "level" text default 'intermediate'::text not null,
  "weak_areas" text,
  "plan_content" text default ''::text not null,
  "tasks" jsonb default '[]'::jsonb not null,
  "is_active" boolean default true not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.study_plans enable row level security;
grant select, insert, update, delete on public.study_plans to authenticated;
grant all on public.study_plans to service_role;
grant select on public.study_plans to anon;
create table if not exists public.subscriptions (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "polar_customer_id" text,
  "polar_subscription_id" text,
  "polar_product_id" text,
  "plan" text default 'starter'::text not null,
  "status" text default 'inactive'::text not null,
  "current_period_end" timestamp with time zone,
  "amount_cents" integer,
  "currency" text default 'usd'::text,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.subscriptions enable row level security;
grant select, insert, update, delete on public.subscriptions to authenticated;
grant all on public.subscriptions to service_role;
grant select on public.subscriptions to anon;
create table if not exists public.supabase_oauth_states (
  "state" text not null,
  "user_id" uuid not null,
  "redirect_to" text,
  "created_at" timestamp with time zone default now() not null,
  "code_verifier" text
);
alter table public.supabase_oauth_states enable row level security;
grant select, insert, update, delete on public.supabase_oauth_states to authenticated;
grant all on public.supabase_oauth_states to service_role;
grant select on public.supabase_oauth_states to anon;
create table if not exists public.system_skills (
  "id" uuid default gen_random_uuid() not null,
  "name" text not null,
  "description" text default ''::text not null,
  "instructions" text default ''::text not null,
  "enabled_tools" text[] default '{}'::text[] not null,
  "preferred_model" text,
  "icon" text,
  "display_order" integer default 0 not null,
  "is_active" boolean default true not null,
  "created_at" timestamp with time zone default now() not null,
  "body" text default ''::text not null,
  "triggers" text[] default '{}'::text[] not null,
  "embedding" vector(1536),
  primary key ("id")
);
alter table public.system_skills enable row level security;
grant select, insert, update, delete on public.system_skills to authenticated;
grant all on public.system_skills to service_role;
grant select on public.system_skills to anon;
create table if not exists public.template_images (
  "template_id" text not null,
  "image_url" text not null,
  "source" text default 'telegram'::text not null,
  "uploaded_by_chat_id" bigint,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null
);
alter table public.template_images enable row level security;
grant select, insert, update, delete on public.template_images to authenticated;
grant all on public.template_images to service_role;
grant select on public.template_images to anon;
create table if not exists public.tool_landing_images (
  "tool_id" text not null,
  "image_url" text,
  "description" text,
  "updated_at" timestamp with time zone default now()
);
alter table public.tool_landing_images enable row level security;
grant select, insert, update, delete on public.tool_landing_images to authenticated;
grant all on public.tool_landing_images to service_role;
grant select on public.tool_landing_images to anon;
create table if not exists public.tool_templates (
  "id" uuid default gen_random_uuid() not null,
  "tool_id" text not null,
  "name" text not null,
  "prompt" text,
  "preview_url" text,
  "gender" text default 'both'::text,
  "display_order" integer default 0,
  "is_active" boolean default true,
  "created_at" timestamp with time zone default now(),
  primary key ("id")
);
alter table public.tool_templates enable row level security;
grant select, insert, update, delete on public.tool_templates to authenticated;
grant all on public.tool_templates to service_role;
grant select on public.tool_templates to anon;
create table if not exists public.tts_voices (
  "id" uuid default gen_random_uuid() not null,
  "name" text not null,
  "preview_audio_url" text not null,
  "voice_id" text,
  "display_order" integer default 0,
  "is_active" boolean default true,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.tts_voices enable row level security;
grant select, insert, update, delete on public.tts_voices to authenticated;
grant all on public.tts_voices to service_role;
grant select on public.tts_voices to anon;
create table if not exists public.user_assets (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "kind" text default 'other'::text not null,
  "storage_key" text not null,
  "public_url" text not null,
  "mime_type" text,
  "size_bytes" bigint,
  "width" integer,
  "height" integer,
  "original_filename" text,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.user_assets enable row level security;
grant select, insert, update, delete on public.user_assets to authenticated;
grant all on public.user_assets to service_role;
grant select on public.user_assets to anon;
create table if not exists public.user_chat_settings (
  "user_id" uuid not null,
  "persona" text default 'default'::text not null,
  "preferred_dialect" text,
  "preferred_language" text,
  "enable_followups" boolean default true not null,
  "enable_pii_redaction" boolean default true not null,
  "enable_semantic_cache" boolean default true not null,
  "enable_citations" boolean default true not null,
  "learning_mode_default" boolean default false not null,
  "custom_instructions" text,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "workspace_id" uuid
);
alter table public.user_chat_settings enable row level security;
grant select, insert, update, delete on public.user_chat_settings to authenticated;
grant all on public.user_chat_settings to service_role;
grant select on public.user_chat_settings to anon;
create table if not exists public.user_connector_state (
  "user_id" uuid not null,
  "connector_id" text not null,
  "enabled" boolean default false not null,
  "updated_at" timestamp with time zone default now() not null
);
alter table public.user_connector_state enable row level security;
grant select, insert, update, delete on public.user_connector_state to authenticated;
grant all on public.user_connector_state to service_role;
grant select on public.user_connector_state to anon;
create table if not exists public.user_drafts (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "draft_key" text not null,
  "payload" jsonb default '{}'::jsonb not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.user_drafts enable row level security;
grant select, insert, update, delete on public.user_drafts to authenticated;
grant all on public.user_drafts to service_role;
grant select on public.user_drafts to anon;
create table if not exists public.user_gallery (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "image_url" text not null,
  "source_type" text default 'edit'::text not null,
  "template_id" uuid,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.user_gallery enable row level security;
grant select, insert, update, delete on public.user_gallery to authenticated;
grant all on public.user_gallery to service_role;
grant select on public.user_gallery to anon;
create table if not exists public.user_github_connections (
  "user_id" uuid not null,
  "access_token" text not null,
  "github_login" text,
  "github_id" bigint,
  "avatar_url" text,
  "scope" text,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null
);
alter table public.user_github_connections enable row level security;
grant select, insert, update, delete on public.user_github_connections to authenticated;
grant all on public.user_github_connections to service_role;
grant select on public.user_github_connections to anon;
create table if not exists public.user_integrations (
  "user_id" uuid not null,
  "email_enabled" boolean default false not null,
  "email_address" text,
  "telegram_chat_id" text,
  "telegram_username" text,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null
);
alter table public.user_integrations enable row level security;
grant select, insert, update, delete on public.user_integrations to authenticated;
grant all on public.user_integrations to service_role;
grant select on public.user_integrations to anon;
create table if not exists public.user_knowledge_graph (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "entity" text not null,
  "entity_type" text not null,
  "relation" text,
  "target_entity" text,
  "confidence" numeric default 0.700 not null,
  "source_message_id" uuid,
  "metadata" jsonb default '{}'::jsonb not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.user_knowledge_graph enable row level security;
grant select, insert, update, delete on public.user_knowledge_graph to authenticated;
grant all on public.user_knowledge_graph to service_role;
grant select on public.user_knowledge_graph to anon;
create table if not exists public.user_memory_entries (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "workspace_id" uuid,
  "title" text,
  "summary" text,
  "scope" text,
  "created_at" timestamp with time zone default now() not null,
  "embedding" vector(1536),
  "slot_type" text,
  "slot_key" text,
  "slot_value" jsonb,
  primary key ("id")
);
alter table public.user_memory_entries enable row level security;
grant select, insert, update, delete on public.user_memory_entries to authenticated;
grant all on public.user_memory_entries to service_role;
grant select on public.user_memory_entries to anon;
create table if not exists public.user_memory_profiles (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "account_summary" text,
  "profile_snapshot" jsonb default '{}'::jsonb not null,
  "preferences" jsonb default '{}'::jsonb not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "workspace_id" uuid,
  primary key ("id")
);
alter table public.user_memory_profiles enable row level security;
grant select, insert, update, delete on public.user_memory_profiles to authenticated;
grant all on public.user_memory_profiles to service_role;
grant select on public.user_memory_profiles to anon;
create table if not exists public.user_music_tracks (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "name" text not null,
  "storage_path" text not null,
  "size_bytes" bigint,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.user_music_tracks enable row level security;
grant select, insert, update, delete on public.user_music_tracks to authenticated;
grant all on public.user_music_tracks to service_role;
grant select on public.user_music_tracks to anon;
create table if not exists public.user_payment_methods (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "method_type" text default 'custom'::text not null,
  "label" text not null,
  "instructions" text not null,
  "status" text default 'pending'::text not null,
  "admin_note" text,
  "telegram_message_id" bigint,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.user_payment_methods enable row level security;
grant select, insert, update, delete on public.user_payment_methods to authenticated;
grant all on public.user_payment_methods to service_role;
grant select on public.user_payment_methods to anon;
create table if not exists public.user_personas (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "name" text not null,
  "description" text,
  "avatar_emoji" text default '✨'::text,
  "system_prompt" text not null,
  "temperature" numeric default 0.7,
  "tags" text[] default '{}'::text[],
  "is_favorite" boolean default false not null,
  "sort_order" integer default 0 not null,
  "usage_count" integer default 0 not null,
  "last_used_at" timestamp with time zone,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.user_personas enable row level security;
grant select, insert, update, delete on public.user_personas to authenticated;
grant all on public.user_personas to service_role;
grant select on public.user_personas to anon;
create table if not exists public.user_preferences (
  "user_id" uuid not null,
  "ai_personalization" jsonb default '{}'::jsonb not null,
  "notification_settings" jsonb default '{}'::jsonb not null,
  "memory" jsonb default '[]'::jsonb not null,
  "language" text,
  "customization" jsonb default '{}'::jsonb not null,
  "page_settings" jsonb default '{}'::jsonb not null,
  "active_workspace_id" uuid,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null
);
alter table public.user_preferences enable row level security;
grant select, insert, update, delete on public.user_preferences to authenticated;
grant all on public.user_preferences to service_role;
grant select on public.user_preferences to anon;
create table if not exists public.user_reward_tasks (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "task_id" uuid not null,
  "progress" integer default 0 not null,
  "completed_at" timestamp with time zone,
  "awarded_credits" numeric default 0 not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.user_reward_tasks enable row level security;
grant select, insert, update, delete on public.user_reward_tasks to authenticated;
grant all on public.user_reward_tasks to service_role;
grant select on public.user_reward_tasks to anon;
create table if not exists public.user_roles (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "role" app_role not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.user_roles enable row level security;
grant select, insert, update, delete on public.user_roles to authenticated;
grant all on public.user_roles to service_role;
grant select on public.user_roles to anon;
create table if not exists public.user_supabase_connections (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "account_email" text,
  "access_token" text not null,
  "refresh_token" text not null,
  "expires_at" timestamp with time zone not null,
  "scope" text,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.user_supabase_connections enable row level security;
grant select, insert, update, delete on public.user_supabase_connections to authenticated;
grant all on public.user_supabase_connections to service_role;
grant select on public.user_supabase_connections to anon;
create table if not exists public.v0_api_keys (
  "id" uuid default gen_random_uuid() not null,
  "name" text not null,
  "api_key" text not null,
  "messages_used" integer default 0 not null,
  "message_limit" integer default 7 not null,
  "window_started_at" timestamp with time zone default now() not null,
  "last_used_at" timestamp with time zone,
  "is_active" boolean default true not null,
  "is_blocked" boolean default false not null,
  "last_error" text,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.v0_api_keys enable row level security;
grant select, insert, update, delete on public.v0_api_keys to authenticated;
grant all on public.v0_api_keys to service_role;
grant select on public.v0_api_keys to anon;
create table if not exists public.v_referral_tier_progress (
  "user_id" uuid,
  "current_tier_id" text,
  "current_tier_name" text,
  "current_rate_pct" numeric,
  "active_refs" integer,
  "net_mrr_cents" integer,
  "next_tier_id" text,
  "next_tier_name" text,
  "next_rate_pct" numeric,
  "next_min_active_refs" integer,
  "next_min_net_mrr_cents" integer
);
alter table public.v_referral_tier_progress enable row level security;
grant select, insert, update, delete on public.v_referral_tier_progress to authenticated;
grant all on public.v_referral_tier_progress to service_role;
grant select on public.v_referral_tier_progress to anon;
create table if not exists public.video_models (
  "id" uuid default gen_random_uuid() not null,
  "slug" text not null,
  "display_name" text not null,
  "provider" text not null,
  "description" text,
  "thumbnail_url" text,
  "endpoint_text_to_video" text,
  "endpoint_image_to_video" text,
  "endpoint_reference_to_video" text,
  "endpoint_start_end_frame" text,
  "unit" text default 'second'::text not null,
  "cost_per_second_usd" numeric,
  "cost_per_video_usd" numeric,
  "credits_per_second" integer,
  "credits_per_video" integer,
  "supports_multi_image" boolean default false not null,
  "max_input_images" integer default 1 not null,
  "supports_start_end_frame" boolean default false not null,
  "supports_audio" boolean default false not null,
  "supported_aspects" jsonb default '["16:9", "9:16", "1:1"]'::jsonb not null,
  "supported_resolutions" jsonb default '["720p"]'::jsonb not null,
  "supported_durations" jsonb default '[5]'::jsonb not null,
  "default_aspect" text default '16:9'::text not null,
  "default_resolution" text default '720p'::text not null,
  "default_duration" integer default 5 not null,
  "is_premium" boolean default false not null,
  "is_new" boolean default false not null,
  "is_featured" boolean default false not null,
  "sort_order" integer default 100 not null,
  "is_active" boolean default true not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "api_version" text default 'v2'::text not null,
  "billing_mode" text default 'credit_based'::text not null,
  "free_trial_count" integer default 3 not null,
  "provider_pool" text,
  "model_id_api" text,
  "supports_first_frame" boolean default false not null,
  "supports_last_frame" boolean default false not null,
  "supports_voice_clone" boolean default false not null,
  "supports_camera_control" boolean default false not null,
  "supports_multi_shot" boolean default false not null,
  "supports_lipsync" boolean default false not null,
  "supports_video_editing" boolean default false not null,
  primary key ("id")
);
alter table public.video_models enable row level security;
grant select, insert, update, delete on public.video_models to authenticated;
grant all on public.video_models to service_role;
grant select on public.video_models to anon;
create table if not exists public.voice_templates (
  "id" uuid default gen_random_uuid() not null,
  "name" text not null,
  "preview_image_url" text,
  "audio_file_url" text not null,
  "display_order" integer default 0,
  "is_active" boolean default true,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.voice_templates enable row level security;
grant select, insert, update, delete on public.voice_templates to authenticated;
grant all on public.voice_templates to service_role;
grant select on public.voice_templates to anon;
create table if not exists public.wavespeed_keys (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid,
  "api_key" text not null,
  "label" text,
  "status" text default 'active'::text not null,
  "balance_usd" numeric default 0 not null,
  "spent_usd" numeric default 0 not null,
  "failure_count" integer default 0 not null,
  "last_error" text,
  "last_used_at" timestamp with time zone,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.wavespeed_keys enable row level security;
grant select, insert, update, delete on public.wavespeed_keys to authenticated;
grant all on public.wavespeed_keys to service_role;
grant select on public.wavespeed_keys to anon;
create table if not exists public.withdrawal_requests (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "amount" numeric not null,
  "method" text default 'paypal'::text not null,
  "payment_details" text default ''::text not null,
  "status" text default 'pending'::text not null,
  "created_at" timestamp with time zone default now() not null,
  "processed_at" timestamp with time zone,
  "payment_method_id" uuid,
  "payment_address" text,
  "admin_note" text,
  "telegram_message_id" bigint,
  primary key ("id")
);
alter table public.withdrawal_requests enable row level security;
grant select, insert, update, delete on public.withdrawal_requests to authenticated;
grant all on public.withdrawal_requests to service_role;
grant select on public.withdrawal_requests to anon;
create table if not exists public.workspace_audit_log (
  "id" uuid default gen_random_uuid() not null,
  "workspace_id" uuid not null,
  "actor_id" uuid,
  "action" text not null,
  "target_type" text,
  "target_id" text,
  "metadata" jsonb default '{}'::jsonb,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.workspace_audit_log enable row level security;
grant select, insert, update, delete on public.workspace_audit_log to authenticated;
grant all on public.workspace_audit_log to service_role;
grant select on public.workspace_audit_log to anon;
create table if not exists public.workspace_brand_kit (
  "workspace_id" uuid not null,
  "primary_color" text default '#3b82f6'::text,
  "secondary_color" text default '#8b5cf6'::text,
  "accent_color" text default '#f59e0b'::text,
  "heading_font" text default 'Inter'::text,
  "body_font" text default 'Inter'::text,
  "logo_url" text,
  "cover_url" text,
  "tone_of_voice" text,
  "brand_description" text,
  "updated_at" timestamp with time zone default now() not null
);
alter table public.workspace_brand_kit enable row level security;
grant select, insert, update, delete on public.workspace_brand_kit to authenticated;
grant all on public.workspace_brand_kit to service_role;
grant select on public.workspace_brand_kit to anon;
create table if not exists public.workspace_credit_topups (
  "id" uuid default gen_random_uuid() not null,
  "workspace_id" uuid not null,
  "initiated_by" uuid not null,
  "amount_credits" numeric not null,
  "amount_usd" numeric not null,
  "status" text default 'pending'::text not null,
  "invoice_number" text,
  "polar_order_id" text,
  "metadata" jsonb default '{}'::jsonb,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.workspace_credit_topups enable row level security;
grant select, insert, update, delete on public.workspace_credit_topups to authenticated;
grant all on public.workspace_credit_topups to service_role;
grant select on public.workspace_credit_topups to anon;
create table if not exists public.workspace_invites (
  "id" uuid default gen_random_uuid() not null,
  "workspace_id" uuid not null,
  "invited_by" uuid not null,
  "invite_email" text not null,
  "role" workspace_role default 'member'::workspace_role not null,
  "invite_token" text default encode(extensions.gen_random_bytes(24), 'hex'::text) not null,
  "status" workspace_invite_status default 'pending'::workspace_invite_status not null,
  "accepted_by" uuid,
  "expires_at" timestamp with time zone default (now() + '14 days'::interval) not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.workspace_invites enable row level security;
grant select, insert, update, delete on public.workspace_invites to authenticated;
grant all on public.workspace_invites to service_role;
grant select on public.workspace_invites to anon;
create table if not exists public.workspace_join_requests (
  "id" uuid default gen_random_uuid() not null,
  "workspace_id" uuid not null,
  "user_id" uuid not null,
  "message" text,
  "status" text default 'pending'::text not null,
  "reviewed_by" uuid,
  "reviewed_at" timestamp with time zone,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.workspace_join_requests enable row level security;
grant select, insert, update, delete on public.workspace_join_requests to authenticated;
grant all on public.workspace_join_requests to service_role;
grant select on public.workspace_join_requests to anon;
create table if not exists public.workspace_member_status (
  "id" uuid default gen_random_uuid() not null,
  "workspace_id" uuid not null,
  "user_id" uuid not null,
  "suspended" boolean default false not null,
  "suspended_reason" text,
  "suspended_by" uuid,
  "suspended_at" timestamp with time zone,
  primary key ("id")
);
alter table public.workspace_member_status enable row level security;
grant select, insert, update, delete on public.workspace_member_status to authenticated;
grant all on public.workspace_member_status to service_role;
grant select on public.workspace_member_status to anon;
create table if not exists public.workspace_members (
  "id" uuid default gen_random_uuid() not null,
  "workspace_id" uuid not null,
  "user_id" uuid not null,
  "role" workspace_role default 'member'::workspace_role not null,
  "monthly_limit" numeric,
  "monthly_used" numeric default 0 not null,
  "monthly_period_start" timestamp with time zone default date_trunc('month'::text, now()) not null,
  "joined_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.workspace_members enable row level security;
grant select, insert, update, delete on public.workspace_members to authenticated;
grant all on public.workspace_members to service_role;
grant select on public.workspace_members to anon;
create table if not exists public.workspace_notification_prefs (
  "id" uuid default gen_random_uuid() not null,
  "workspace_id" uuid not null,
  "user_id" uuid not null,
  "in_app" jsonb default '{"low_credits": true, "member_joined": true, "task_assigned": true, "comment_mention": true}'::jsonb not null,
  "email" jsonb default '{"low_credits": true, "member_joined": true, "task_assigned": false, "comment_mention": true}'::jsonb not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.workspace_notification_prefs enable row level security;
grant select, insert, update, delete on public.workspace_notification_prefs to authenticated;
grant all on public.workspace_notification_prefs to service_role;
grant select on public.workspace_notification_prefs to anon;
create table if not exists public.workspace_settings (
  "workspace_id" uuid not null,
  "default_language" text default 'ar'::text,
  "default_timezone" text default 'UTC'::text,
  "content_policy" text default 'standard'::text not null,
  "blocked_keywords" text[] default '{}'::text[],
  "require_join_approval" boolean default false not null,
  "sso_enabled" boolean default false not null,
  "sso_provider" text,
  "sso_metadata_url" text,
  "sso_entity_id" text,
  "updated_at" timestamp with time zone default now() not null
);
alter table public.workspace_settings enable row level security;
grant select, insert, update, delete on public.workspace_settings to authenticated;
grant all on public.workspace_settings to service_role;
grant select on public.workspace_settings to anon;
create table if not exists public.workspace_shared_resources (
  "id" uuid default gen_random_uuid() not null,
  "workspace_id" uuid not null,
  "resource_type" text not null,
  "resource_id" uuid not null,
  "shared_by" uuid not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.workspace_shared_resources enable row level security;
grant select, insert, update, delete on public.workspace_shared_resources to authenticated;
grant all on public.workspace_shared_resources to service_role;
grant select on public.workspace_shared_resources to anon;
create table if not exists public.workspace_task_attachments (
  "id" uuid default gen_random_uuid() not null,
  "task_id" uuid not null,
  "uploaded_by" uuid not null,
  "file_url" text not null,
  "file_name" text not null,
  "file_size" bigint,
  "mime_type" text,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.workspace_task_attachments enable row level security;
grant select, insert, update, delete on public.workspace_task_attachments to authenticated;
grant all on public.workspace_task_attachments to service_role;
grant select on public.workspace_task_attachments to anon;
create table if not exists public.workspace_task_comments (
  "id" uuid default gen_random_uuid() not null,
  "task_id" uuid not null,
  "user_id" uuid not null,
  "content" text not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.workspace_task_comments enable row level security;
grant select, insert, update, delete on public.workspace_task_comments to authenticated;
grant all on public.workspace_task_comments to service_role;
grant select on public.workspace_task_comments to anon;
create table if not exists public.workspace_tasks (
  "id" uuid default gen_random_uuid() not null,
  "workspace_id" uuid not null,
  "parent_task_id" uuid,
  "title" text not null,
  "description" text,
  "status" workspace_task_status default 'todo'::workspace_task_status not null,
  "priority" workspace_task_priority default 'medium'::workspace_task_priority not null,
  "assignee_id" uuid,
  "created_by" uuid not null,
  "due_date" timestamp with time zone,
  "project_id" uuid,
  "conversation_id" uuid,
  "tags" text[] default '{}'::text[] not null,
  "position" integer default 0 not null,
  "completed_at" timestamp with time zone,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.workspace_tasks enable row level security;
grant select, insert, update, delete on public.workspace_tasks to authenticated;
grant all on public.workspace_tasks to service_role;
grant select on public.workspace_tasks to anon;
create table if not exists public.workspace_usage (
  "id" uuid default gen_random_uuid() not null,
  "workspace_id" uuid not null,
  "user_id" uuid not null,
  "amount" numeric not null,
  "action_type" text not null,
  "description" text,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.workspace_usage enable row level security;
grant select, insert, update, delete on public.workspace_usage to authenticated;
grant all on public.workspace_usage to service_role;
grant select on public.workspace_usage to anon;
create table if not exists public.workspaces (
  "id" uuid default gen_random_uuid() not null,
  "name" text not null,
  "owner_id" uuid not null,
  "credits" numeric default 0 not null,
  "default_member_monthly_limit" numeric,
  "avatar_url" text,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "plan" text,
  "archived_at" timestamp with time zone,
  primary key ("id")
);
alter table public.workspaces enable row level security;
grant select, insert, update, delete on public.workspaces to authenticated;
grant all on public.workspaces to service_role;
grant select on public.workspaces to anon;
create table if not exists public.youtube_conversations (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid not null,
  "video_url" text not null,
  "video_id" text not null,
  "video_title" text,
  "channel_name" text,
  "duration" text,
  "thumbnail_url" text,
  "transcript" text,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.youtube_conversations enable row level security;
grant select, insert, update, delete on public.youtube_conversations to authenticated;
grant all on public.youtube_conversations to service_role;
grant select on public.youtube_conversations to anon;
create table if not exists public.youtube_messages (
  "id" uuid default gen_random_uuid() not null,
  "conversation_id" uuid not null,
  "role" text not null,
  "content" text not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.youtube_messages enable row level security;
grant select, insert, update, delete on public.youtube_messages to authenticated;
grant all on public.youtube_messages to service_role;
grant select on public.youtube_messages to anon;
create table if not exists public.yt_video_chat_messages (
  "id" uuid default gen_random_uuid() not null,
  "chat_id" uuid not null,
  "role" text not null,
  "content" text not null,
  "created_at" timestamp with time zone default now() not null,
  primary key ("id")
);
alter table public.yt_video_chat_messages enable row level security;
grant select, insert, update, delete on public.yt_video_chat_messages to authenticated;
grant all on public.yt_video_chat_messages to service_role;
grant select on public.yt_video_chat_messages to anon;
create table if not exists public.yt_video_chats (
  "id" uuid default gen_random_uuid() not null,
  "session_id" text not null,
  "video_url" text not null,
  "video_id" text default ''::text not null,
  "video_title" text default ''::text,
  "channel_name" text default ''::text,
  "thumbnail_url" text default ''::text,
  "transcript" text default ''::text,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "user_id" uuid,
  primary key ("id")
);
alter table public.yt_video_chats enable row level security;
grant select, insert, update, delete on public.yt_video_chats to authenticated;
grant all on public.yt_video_chats to service_role;
grant select on public.yt_video_chats to anon;
