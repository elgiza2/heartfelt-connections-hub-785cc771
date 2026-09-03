# Roadmap

## Providers (settled)
- [x] Text model: abliteration.ai only (`_shared/abliteration.ts`, OpenAI-compatible)
- [x] Computer/browser: Browser Use Cloud only (`_shared/cloudAgents.ts`, `computer-agent`)
- [x] Key tables: `abliteration_keys` + `browser_use_keys` (admin-only RLS, rotation + cooldown)
- [x] Primary abliteration key stored as secret and as a table row

## Full-stack stabilization
- [ ] Audit chat UI, text, thinking, plans, computer, and task flows
- [ ] Fix infinite loading and disappearing transcript
- [ ] Fix backend agent/task lifecycle and provider failures
- [ ] Verify guest and authenticated flows on mobile and desktop
- [ ] Run targeted tests and security checks
