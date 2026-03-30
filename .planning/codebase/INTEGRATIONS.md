# External Integrations

**Analysis Date:** 2026-03-29

## APIs & External Services

**Authentication:**
- Clerk (`@clerk/nextjs`) — OAuth/OIDC provider, MFA management, user session management
  - SDK/Client: `@clerk/nextjs`
  - Configuration: `CLERK_PUBLISHABLE_KEY`, `CLERK_SECRET_KEY`
  - Usage: Middleware in `src/middleware.ts` protects all routes by default; public routes explicitly allowed via `clerkMiddleware({ publicRoutes: [...] })`
  - Role & Site Metadata: Hybrid approach — Clerk's `publicMetadata` contains role/site list (cached in JWT); source of truth is `user_sites` table in PostgreSQL

**Reporting & Analytics:**
- Metabase OSS — Self-hosted reporting engine on Port 3001 of UACDC-POD
  - SDK/Client: None (embedded iFrame with signed JWT token)
  - Configuration: `METABASE_URL`, `METABASE_SECRET_KEY`
  - Usage: Census, billing, and attendance reports embedded via signed JWT iFrame in `/src/app/reports/*` routes
  - Route Handler: `/src/app/api/metabase-embed/route.ts` — generates and returns signed JWT embed tokens
  - Connection: Direct PostgreSQL read-only connection to Prodigy database; SSN column excluded from connection

## Data Storage

**Databases:**

**Primary (New System):**
- PostgreSQL on Supabase (cloud) or on-premises
  - Connection: `DATABASE_URL` environment variable; Prisma connection pooling via Supabase pgBouncer
  - Client: Prisma ORM (`@prisma/client`)
  - Schema: `prisma/schema.prisma` (single file, all models)
  - Migrations: Managed by Prisma via `pnpm prisma migrate`
  - Features: Encryption at rest (Supabase managed), column-level SSN encryption at application level, audit logging via Prisma middleware to `audit_logs` table

**Legacy (Migration Source Only):**
- SQL Server (on-premises UACDC-POD)
  - Connection: One-time only during migration phase; no ongoing integration
  - Usage: Read-only access for `scripts/migrate-legacy.ts` migration script
  - Data transferred: Youth, enrollments, attendance, programs, courses, classes, lookup values; person records deduplicated during transfer

**File Storage:**
- Local filesystem only (no cloud file storage)
- No file uploads or document storage in current scope

**Caching:**
- None configured (MVP)
- Next.js built-in caching sufficient for < 50 concurrent users
- Future: Redis/similar only if performance metrics warrant

## Authentication & Identity

**Auth Provider:**
- Clerk (OAuth/OIDC)
  - Implementation: `@clerk/nextjs` SDK
  - MFA: Enforced for all users (no bypass)
  - Session Management: Clerk-managed with 30-minute inactivity timeout
  - User Provisioning: Via Clerk admin dashboard; roles assigned in Clerk and synced to `user_sites` table
  - Webhook: `/src/app/api/clerk-webhook/route.ts` handles user sync events
  - Protected Routes: Middleware in `src/middleware.ts` requires authentication by default; public routes explicitly whitelisted

**Roles (Authorization):**
- **Administrator** — Full system access; user management, lookup management, cross-site visibility
- **Central Team** — Cross-site data access; enrollment/program/course management; reporting; excludes user admin and SSN access
- **Site Team/Instructor** — Scoped to assigned site(s) and class(es); attendance entry, enrollment view for their site
- Enforcement: Middleware + Prisma extension automatic WHERE filtering; route handlers validate role before returning data

**Site Scoping:**
- All data filtered by `site_id` for Site Team and Instructor roles
- Implemented via Prisma client extension in `src/lib/db.ts` — automatic `WHERE site_id IN (user_sites)` injection
- Enforced at: Route handlers, Server Actions, and all Prisma queries
- Bypass impossible: Single source of site scope (Prisma extension)

## Monitoring & Observability

**Error Tracking:**
- None (deferred to post-MVP)
- Structured logs via Pino sufficient at current scale; add Sentry or similar only if metrics warrant

**Logs:**
- Pino logger (`src/lib/logger.ts`) — structured JSON to stdout
- Log levels: `info` for operations, `warn` for recoverable issues, `error` for failures
- Output: Stdout (can be redirected to file or Windows Event Log on production server)
- Audit Trail: Automatically logged to `audit_logs` table via Prisma middleware (user, timestamp, action, before/after diffs)

**Uptime Monitoring:**
- `/api/health` endpoint — returns `{ status: "ok", timestamp: <ISO> }` with 200 status
- Simple HTTP ping suitable for Windows Server monitoring tools or third-party uptime services

## CI/CD & Deployment

**Hosting:**
- **Cloud:** Vercel (recommended for Next.js; automatic preview deploys, edge functions optional)
- **On-premises:** Node.js standalone (`output: "standalone"`) behind IIS reverse proxy on Windows Server

**CI Pipeline:**
- GitHub Actions (`.github/workflows/ci.yml`)
  - Runs on every push to `main` branch
  - Steps: Install dependencies, run Vitest unit tests, build Next.js app, run Playwright E2E tests
  - No automated deployment (manual deploy to production for safety)

**Deploy Process:**
- **Cloud (Vercel):** Connect repo to Vercel; automatic deploys on main branch push (or manual trigger)
- **On-premises (Windows Server):** Manual deployment — build artifact (`pnpm build`) transferred to server; Node.js process restarted

**Environment Configuration:**
- Dev: `.env.local` (git-ignored)
- Production: `.env.production` (on server, git-ignored)
- Zod validation in `src/config/env.ts` fails fast at startup if required vars missing

## Environment Configuration

**Required environment variables:**
- `DATABASE_URL` — PostgreSQL connection string (Supabase or on-prem)
- `CLERK_PUBLISHABLE_KEY` — Clerk public key for client SDK
- `CLERK_SECRET_KEY` — Clerk secret for server-side operations and webhooks
- `METABASE_URL` — Metabase instance URL (e.g., `http://localhost:3001`)
- `METABASE_SECRET_KEY` — JWT signing key for Metabase embed tokens
- `NODE_ENV` — `development`, `production`, or `test`

**Optional (post-MVP):**
- `SENTRY_DSN` — Error tracking (when enabled)
- `LOG_LEVEL` — Pino log level override (default: `info`)

**Secrets location:**
- `.env.local` (development, never committed)
- `.env.production` (production, on server, never committed)
- `.env.example` (template, committed)

## Webhooks & Callbacks

**Incoming Webhooks:**
- `/src/app/api/clerk-webhook/route.ts` — Clerk sends user sync events (create, update, delete, MFA status changes)
  - Trigger: User provisioned/modified in Clerk admin dashboard or via Clerk API
  - Payload: Clerk user object with metadata
  - Action: Sync user roles/sites to `user_sites` table; can trigger SSO role/org changes

**Outgoing Webhooks:**
- None configured (Prodigy does not call external webhooks)
- Future: Metabase webhooks (optional, not required for embed pattern)

## Data Migration Integration

**One-Time Legacy Integration:**
- `scripts/migrate-legacy.ts` — Reads from SQL Server (legacy Prodigy), writes to PostgreSQL (new system)
  - Source: SQL Server connection string for legacy UACDC-POD database
  - Tables migrated: `Person`, `PersonEnrollment`, `Attendance`, `Program`, `Course`, `CourseSchedule`, `Lookup` (and dependencies)
  - Deduplication: Matches legacy person records by name + DOB or SSN; creates one youth record per unique person
  - Enrollment history: Preserved; historical enrollments linked to deduplicated youth
  - Attendance: Carried over as historical records (readonly after migration)
  - Run once: Post-schema setup, before production cutover
  - No ongoing sync: After migration completes, legacy database is read-only reference only

## Integration Summary

| System | Type | Status | Usage |
|--------|------|--------|-------|
| Clerk | Auth/Identity | Required | All user authentication, MFA, role management |
| Metabase OSS | Reporting | Required | Census, billing, attendance reports (embedded iFrames) |
| PostgreSQL (Supabase/On-Prem) | Database | Required | Primary data store for all app entities |
| SQL Server (Legacy) | Database | Migration-only | One-time read during migration script; then read-only reference |
| GitHub Actions | CI/CD | Required | Automated testing on every push |
| Vercel / IIS | Hosting | Required | App deployment and reverse proxy (IIS on-prem only) |
| Pino | Logging | Required | Structured logging to stdout |

---

*Integration audit: 2026-03-29*
