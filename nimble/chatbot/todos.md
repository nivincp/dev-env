## Major missing features

- User mapping table + logic (the PRD expects user_mappings / customers mapping with (line_user_id, tenant_id) and Okya auth user ID).
- LINE Profile API client + display name handling.
- Refresh token handling + retry on 401.
- Token cache structure with refresh_token, expires_at, okya_auth_user_id, tenant scoping, and 24h TTL.
- Redis token encryption.
- Error handling requirements (retry 500/timeout, user-friendly error message, alert hooks).
- Race-condition handling with unique constraint + retry path.
- Tenant isolation for Okya Auth credentials is partially done, but user mapping / tokens aren’t tenant‑scoped yet.

## Current implementation mismatches

- Still no user mapping persistence; we only use cache.
- Token cache key is line_access_token:#{user_id} (not tenant‑scoped, no refresh token).
- No refresh flow or 401 retry.
- Signup uses hardcoded names, not LINE display name.

