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

## Blocked
- [ ] Redeploy edge functions (Supabase deploy API returns internal error for every function, including untouched ones) — retry, then re-test chat/computer end to end.

## Second deployment path (Supabase deploy blocked)
- `src/lib/chat/proxyCore.ts` + `api/chat.ts` + Vite dev plugin serve chat from our own serverless runtime via abliteration.ai.
- `streamChat.ts` and `fastChat.ts` fall back to `/api/chat` on 5xx/404/network failure from the Supabase edge functions.
- Production needs `ABLITERATION_API_KEY` set in the hosting env (already in local `.env`).
- Still pending: redeploy Supabase edge functions when the platform recovers; computer (Browser Use) path still runs through `/api/computer-agent`.
