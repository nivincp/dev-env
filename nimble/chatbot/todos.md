## Major missing features

- LINE Profile API client + display name handling.
- Refresh token handling + retry on 401.
- Token cache structure with refresh_token, expires_at, okya_auth_user_id, tenant scoping, and 24h TTL.
- Redis token encryption.
- Error handling requirements (retry 500/timeout, user-friendly error message, alert hooks).
- Race-condition handling with unique constraint + retry path.

## Current implementation mismatches

- No refresh flow or 401 retry.
- Signup uses hardcoded names, not LINE display name.

