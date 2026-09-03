# Roadmap

## Done
- [x] Computer card in chat: bare rounded screen (no header, icons or buttons), and it now appears as soon as the computer runs (shimmer placeholder before the live view exists)
- [x] Internal thinking streams by default (`enable_thinking` on unless explicitly disabled, client toggle defaults to on)
- [x] Speed: greetings/one-liners skip thinking and use a small output budget (instant replies)
- [x] Plan cards: each step shows a real task name plus its detail instead of a raw numbered line
- [x] Signed-out users: verified guests are allowed (fingerprint identity, quota-limited, no auth wall)
- [x] Global memory: recall + write for signed-in users AND guests (deterministic identity from the anonymous fingerprint), injected into every turn
- [x] Hyperbrowser data tools added and exposed to the agent: `scrape_page`, `crawl_site`, `extract_data`
- [x] Capability brief updated so the model knows the new tools
- [x] Smaller, cleaner AI text size in chat
- [x] Chips: smaller rounded pills, cleaner icons/labels
- [x] Tool icons: one shared `ToolIcon` (brand mark or quiet lucide glyph) used by `ThinkingTrace` and `ParallelAgentsPanel`

## Open
- [ ] Move server logic off Supabase Edge Functions into app server routes (`api/`) — large migration, needs its own pass (chat-alibaba, chat-fast, computer-agent, long-run, deep-research)
- [ ] Browser Use Cloud extra endpoints (profiles, files, structured task output) + provider MCP endpoints

