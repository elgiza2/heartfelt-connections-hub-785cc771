# Roadmap

- [x] Point app to new Supabase project (elgiza)
- [x] Recreate 228 tables + grants + RLS (406 policies) + 122 functions + triggers
- [x] Deploy 14 edge functions; chat verified
- [x] Add missing tables used by code
- [x] Drop temporary helper function
- [ ] Regenerate src/integrations/supabase/types.ts and fix typecheck build errors
- [ ] Seed provider key tables; get BROWSER_USE_API_KEY from user
- [ ] Re-create useful cron jobs
- [ ] Consolidate edge functions into fewer unified endpoints (scale for millions)
- [ ] Move all file storage to Telegram (no Supabase Storage, no blobs in DB)
- [ ] Audit + verify every app function: auth/signup/password, settings pages, all features
