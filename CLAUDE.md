# Prodigy — WebForms → Next.js Migration

## Project
Migrating an ASP.NET WebForms application to Next.js 14 App Router.

## New Stack
Next.js 14 App Router · TypeScript · Tailwind · shadcn/ui
NextAuth.js · Prisma · PostgreSQL · Metabase OSS

## Agent Rules (IMMUTABLE)
- NEVER modify any file in /legacy-src
- ALWAYS check /specs/_audit/ before creating components
- New pages go in /src/app/[route]/page.tsx
- New API routes go in /src/app/api/[name]/route.ts

## Architecture Decisions
- ADR-001: Reporting — SSRS → Metabase OSS
- ADR-002: Auth — Forms Auth → NextAuth.js

## Migration Status
### Complete
(none yet)

### In Progress
Phase 0 — Bootstrap