# Production / Enterprise Go-Live Checklist

## Identity and access
- [ ] Replace seeded demo users before public deployment.
- [ ] Enforce verified email addresses and a tested password-reset flow.
- [ ] Complete TOTP enrollment/recovery UI; require MFA for platform admins and tenant owners.
- [ ] Add SSO/OIDC/SAML for enterprise plans if required.
- [ ] Review RBAC permissions and implement least-privilege team roles.
- [ ] Automatically expire/revoke sessions after password or MFA changes.

## Infrastructure
- [ ] HTTPS only, HSTS enabled, DNS and certificates monitored.
- [ ] Managed PostgreSQL with encryption at rest, HA/PITR where required.
- [ ] Redis authenticated/private-network only.
- [ ] Application and database deployed on private networks with restricted ingress.
- [ ] Secrets stored in a cloud secret manager/KMS, never `.env` in production images.
- [ ] Separate dev/staging/production accounts and credentials.
- [ ] WAF/API gateway plus distributed rate limiting.

## Reliability
- [ ] At least daily encrypted backups with defined retention.
- [ ] Restore drill completed and documented.
- [ ] Worker jobs have exponential retry/dead-letter handling.
- [ ] Provider idempotency keys used for outbound writes where supported.
- [ ] Database migrations run through a controlled release process.
- [ ] Health/readiness alerts and synthetic checks configured.

## Security
- [ ] Dependency/SBOM and container image scanning in CI.
- [ ] SAST and secret scanning enabled.
- [ ] Independent penetration test before material customer rollout.
- [ ] Provider webhook authenticity validated for every enabled provider.
- [ ] CSP tightened to remove `unsafe-inline` after frontend build pipeline is introduced.
- [ ] File upload malware scanning if attachments are enabled.
- [ ] Audit logs exported to append-only/centralized storage.
- [ ] Privileged admin actions require step-up authentication.

## Privacy / GDPR
- [ ] Document controller/processor roles for TradeFlow and each tenant.
- [ ] Signed DPA with subprocessors listed.
- [ ] Privacy notice and lawful-basis/consent wording reviewed by counsel.
- [ ] Retention schedule implemented as scheduled deletion/anonymization jobs.
- [ ] DSAR export, rectification and erasure procedures tested.
- [ ] EU/EEA hosting and international-transfer safeguards chosen as required.
- [ ] Data breach response workflow and notification responsibilities documented.

## Billing and support
- [ ] Stripe products/prices, tax treatment and invoices configured correctly.
- [ ] Trial/active/past-due/canceled entitlements enforced server-side.
- [ ] Failed-payment grace period and dunning policy defined.
- [ ] SLA/support channels and maintenance policy published for enterprise customers.

## Observability
- [ ] Structured logs with request/tenant correlation IDs.
- [ ] Error tracking and alerting configured.
- [ ] Metrics: request latency/error rate, queue depth, webhook failures, message delivery failures, DB saturation.
- [ ] PII redaction reviewed for logs and traces.
