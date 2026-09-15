# Enterprise Feature Matrix

| Area | Included in code | Deployment/vendor setup still required |
|---|---|---|
| Tenant isolation | Yes | Security review + DB policy/RLS optional hardening |
| RBAC | Owner/agent/platform-admin primitives | Custom role editor / SSO groups |
| Sessions/CSRF | Yes | Central session store for very large scale |
| Password security | PBKDF2 | Password reset/email verification UX |
| MFA | TOTP verification primitive | Enrollment/recovery/step-up UX |
| Audit | Database audit records | Export to immutable SIEM/log store |
| Leads/CRM | Yes | Optional CRM connectors |
| AI replies | OpenAI adapter + safe fallback | Provider key, usage policy/monitoring |
| WhatsApp | Outbound + webhook endpoint | Meta app approval, signature validation, templates |
| Calendar | Outbox architecture/config | Tenant OAuth consent + refresh-token flow |
| Billing | Stripe webhook state handling | Checkout/customer portal/tax configuration |
| Database | SQLite local, PostgreSQL production | Managed HA/PITR configuration |
| Queue | Transactional DB outbox + worker | Redis/Celery/RQ/SQS migration at scale |
| Backup | PostgreSQL dump script | Encrypted remote storage + restore drills |
| GDPR | Soft erase/anonymization primitive | DSAR workflow, retention schedule, DPA/legal review |
| Monitoring | Health/readiness endpoints | Metrics/APM/error tracking alerts |
| Deployment | Docker Compose | Kubernetes/ECS/Cloud Run/etc. if required |
