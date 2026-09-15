# Security Notes

TradeFlow uses tenant scoping at the application/database-query layer, opaque server-side sessions, CSRF tokens for authenticated mutations, HttpOnly cookies, PBKDF2 password hashes, security headers, idempotent webhook storage and audit records.

For a real enterprise deployment, use managed KMS/secrets, private networking, a WAF/distributed limiter, immutable centralized audit storage, verified provider webhook signatures, mandatory MFA for privileged roles, vulnerability management and regular independent testing. Treat the demo credentials as disposable development-only credentials.

Never commit `.env`, database dumps, provider access tokens, OAuth refresh tokens or encryption keys to source control.
