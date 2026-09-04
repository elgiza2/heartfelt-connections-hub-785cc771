# Roadmap

## Email (in progress)
- [x] Store SMTP settings (Hostinger, port 465) as secrets
- [x] Build + deploy `send-email` (invites, welcome, codes) — tested, delivered
- [x] Store IMAP settings + inbound secret; `mail-poll` works (x-cron-key)
- [ ] Cron: run `mail-poll` every minute
- [ ] Supabase Auth: custom SMTP + Send Email hook (`auth-email-hook`)
- [ ] Tell user the DNS records needed (SPF / DKIM / DMARC)

## Missing backend functions / features (requested)
- [ ] Integrations gateway: Pipedream (`pipedream-connect`, `oauth-authorize`, `oauth-github-connect`)
- [ ] MCP: connections + oauth states + tool approvals end-to-end
- [ ] All settings pages verified
- [ ] In-chat features verified (tools, thinking, streaming)
- [ ] Slides via Plus AI (`slides-api`, `chat-slides-stream`)
- [ ] Deep research (`research_jobs` pipeline)
- [ ] Coding / dev projects (`code-v0-poll`, `github-push`, `docs-generate`)
- [ ] Images and videos (`media-video`, `media-video-poll`)
- [ ] Other missing: `memory-extract`, `kashier-checkout`, `health-check`, `operator-orchestrator`, `report-error`
- [ ] Secrets still needed: `BROWSER_USE_API_KEY` + provider keys
