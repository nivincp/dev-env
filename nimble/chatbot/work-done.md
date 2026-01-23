## 2026-01-22

- Added multi-tenant config in DB: Tenant model + migrations, encrypted per-tenant Okya/LINE secrets, seeds for jones-salad and you-and-i.
- Introduced Customer model + migration, per-tenant LINE user mapping, cached token concern, and email generation for LINE guests.
- Refactored LINE auth orchestration: Line::SyncCustomer now creates/updates customers, uses tenant DB config, caches tokens, and syncs profiles via Okya services.
- Split Okya HTTP calls into Okya::AuthSignup, Okya::TokenFetcher, Okya::TenantCustomerSync, and shared Okya::Http.
- Updated webhook validation to use tenant DB instead of ALLOWED_BRANDS, added JSON error responses.
- Moved LINE signature validation and messaging client to read channel secrets/tokens from tenant records.
- Added Active Record encryption setup and deploy wiring; removed LINE secrets from env sample.
- Fixed rubocop issues and updated specs to use tenant data instead of ENV.
