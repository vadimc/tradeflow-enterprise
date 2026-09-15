# Railway production deployment

## Services
Create one Railway project with four services:
1. `tradeflow-api` from this source directory.
2. Railway PostgreSQL.
3. Railway Redis.
4. `tradeflow-worker` from the same source directory, using `railway-worker.toml` or start command `python -m app.worker`.

## API service
Railway will detect the root `Dockerfile`. The included `railway.toml` makes the API listen on Railway's injected `$PORT` and uses `/readyz` as the deployment healthcheck.

Set production variables using `.env.production.example` as the checklist. Use Railway reference variables for the PostgreSQL and Redis connection URLs rather than copying credentials between services where possible.

Required before first production login:
- `ENV=production`
- `DEMO_MODE=false`
- `SEED_DEMO=false`
- `COOKIE_SECURE=true`
- `BASE_URL=https://<your-domain>`
- `ALLOWED_ORIGINS=https://<your-domain>`
- `DATABASE_URL=<Railway Postgres URL converted to postgresql+psycopg://...>`
- `REDIS_URL=<Railway Redis URL>`
- `MASTER_ENCRYPTION_KEY=<generated secret>`
- `BOOTSTRAP_ADMIN_EMAIL=<your admin email>`
- `BOOTSTRAP_ADMIN_PASSWORD=<strong temporary password>`

Generate strong starter values with:

```bash
python scripts/generate_secrets.py
```

After the first admin account has been created successfully, remove `BOOTSTRAP_ADMIN_PASSWORD` from the service variables and redeploy.

## Worker service
Deploy the same source as a second service. Configure its start command to:

```bash
python -m app.worker
```

Give it the same `DATABASE_URL`, `REDIS_URL`, encryption key, and external integration credentials. It does not need a public domain.

## Domain and TLS
Attach your chosen custom domain to `tradeflow-api`. Railway terminates TLS for the service. Update `BASE_URL`, `ALLOWED_ORIGINS`, Google redirect URLs, Stripe webhook destination, and Meta webhook destination to the final HTTPS hostname.

## External webhooks
- Stripe webhook: `https://<domain>/api/webhooks/stripe`
- WhatsApp webhook: use the Meta webhook route implemented in `app/routers/webhooks.py`; use the same verify token configured in Railway.

## Release checks
Before exposing the application to customers:
1. `/healthz` returns HTTP 200.
2. `/readyz` returns HTTP 200 and `database=ready`.
3. Demo seed is disabled.
4. Admin login works, and bootstrap password variable has been removed.
5. A new tenant cannot retrieve another tenant's lead IDs.
6. Stripe test webhook is accepted once and duplicate delivery is idempotent.
7. WhatsApp test message is received and audited.
8. Database backup and restore are tested.
9. Logs/alerts are connected to your monitoring provider.
10. Complete `PRODUCTION_CHECKLIST.md` before processing real customer data.
