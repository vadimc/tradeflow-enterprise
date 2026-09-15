# TradeFlow Enterprise SaaS

TradeFlow Enterprise is the production-oriented successor to the V4 trades automation demo. It is a multi-tenant SaaS foundation for lead intake, automated customer responses, messaging, bookings, quotes, billing integration, auditability and platform administration.

## What is included

- Multi-tenant data model with tenant-scoped leads, messages, appointments and quotes
- Owner/agent/platform-admin roles and role checks
- Server-side opaque sessions, HttpOnly cookies and CSRF protection
- PBKDF2 password hashing and TOTP MFA verification support
- Encrypted secret helper for integration credentials
- Public lead capture with honeypot field and automatic urgency scoring
- AI reply adapter using the OpenAI Responses API with deterministic fallback
- WhatsApp Cloud API outbound adapter and inbound webhook endpoint
- Stripe signed webhook verification and subscription-state handling
- Google OAuth configuration placeholders plus outbox-based calendar job path
- Audit log model, idempotent webhook storage and transactional outbox
- GDPR-style erasure endpoint that removes direct contact content while preserving operational/audit integrity
- PostgreSQL production configuration, Redis service, separate worker process and Docker Compose
- Health/readiness endpoints and restrictive browser security headers
- Backup script and smoke test
- Operator dashboard plus tenant-specific public enquiry page

## Test locally

The easiest local path uses SQLite.

```bash
cp .env.example .env
mkdir -p data
python -m pip install -r requirements.txt
uvicorn app.main:app --host 0.0.0.0 --port 8080
```

Open `http://localhost:8080`.

Demo owner:

- `owner@demo.ie`
- `demo12345`

Platform admin:

- `admin@tradeflow.ie`
- `admin12345`

The seeded public form is at `http://localhost:8080/public/murphy-plumbing`.

Run the smoke test in a second terminal:

```bash
python scripts/smoke_test.py
```

## Production with Docker

1. Copy `.env.example` to `.env`.
2. Set a strong `POSTGRES_PASSWORD` in your shell or deployment secret manager.
3. Set `ENV=production`, `COOKIE_SECURE=true`, a HTTPS `BASE_URL`, exact `ALLOWED_ORIGINS`, and a long random `MASTER_ENCRYPTION_KEY`.
4. Add provider credentials only through environment/secrets management.
5. Start:

```bash
docker compose up --build -d
```

Production Docker uses PostgreSQL. Do not use SQLite for a horizontally scaled deployment.

## External integrations

### OpenAI
Set `OPENAI_API_KEY` and `OPENAI_MODEL`. AI generation is bounded by a safe customer-service prompt and falls back to rules if the API is unavailable.

### WhatsApp Cloud API
Set `WHATSAPP_TOKEN`, `WHATSAPP_PHONE_NUMBER_ID`, and `WHATSAPP_VERIFY_TOKEN`. Configure the callback URL as `/api/webhooks/whatsapp`. Production should additionally validate Meta request signatures at the edge/application layer before processing inbound payloads.

### Stripe
Set `STRIPE_SECRET_KEY`, `STRIPE_PRICE_ID`, and `STRIPE_WEBHOOK_SECRET`. Configure `/api/webhooks/stripe`. The handler verifies Stripe's timestamped HMAC signature and stores event IDs so retries are idempotent.

### Google Calendar
The package includes Google OAuth client configuration and an outbox job type for calendar creation. For a public SaaS, complete the tenant OAuth authorization UI and refresh-token storage before enabling live calendar writes. Request the narrowest Calendar scope required for your use case.

## Enterprise deployment gates

Before processing real customer data, complete all items in `PRODUCTION_CHECKLIST.md`. In particular: TLS/domain setup, managed database and backups, key management, rate limiting/WAF, email verification/password recovery, operational MFA enrollment, provider webhook signature validation, monitoring/alerting, log retention, vulnerability scanning, DPA/privacy/retention policies, incident response, restore drills and independent security review.

## Architecture

Browser / public form → FastAPI application → PostgreSQL

Application → outbox → worker → OpenAI / WhatsApp / Calendar / email / CRM

Stripe/WhatsApp → signed/idempotent webhooks → application → PostgreSQL

Redis is provisioned for distributed rate limits, queues/caching and can replace the simple DB outbox polling as throughput grows.

## API docs

In non-production environments, interactive API docs are available at `/api/docs`.

## Important scope note

No downloadable codebase can by itself make a business "enterprise compliant." Compliance and production readiness also depend on your hosting, access controls, vendor contracts, policies, monitoring, incident response, backups and legal obligations. This build is structured to support those controls and includes an explicit go-live checklist rather than pretending deployment credentials or compliance evidence already exist.
