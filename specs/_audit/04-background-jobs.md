# Prodigy Legacy App -- Background Jobs & Scheduled Work Inventory

> Generated: 2026-03-29
> Source: Direct codebase scan of `legacy-src/` -- `config.xml` Repomix export was empty
> Searched: `Global.asax*`, `IHttpModule`, `Timer`, `Thread`, `Task.Run`, `BackgroundWorker`, `HostingEnvironment.QueueBackgroundWorkItem`, scheduled patterns, `web.config` modules/handlers

---

## Result: No Application-Level Background Jobs

The legacy Prodigy application has **no Global.asax file**, **no custom HttpModules**, and **no in-process background work**:

| Pattern Searched | Found |
|------------------|-------|
| `Global.asax` / `Global.asax.cs` | **None** -- file does not exist |
| `Application_Start` / `Application_End` | **None** |
| `Session_Start` / `Session_End` | **None** |
| Custom `IHttpModule` implementations | **None** (only Telerik vendor XML) |
| `System.Threading.Timer` | **None** |
| `System.Timers.Timer` | **None** |
| `Thread` / `ThreadPool` / `Task.Run` / `Task.Factory` | **None** |
| `BackgroundWorker` | **None** |
| `HostingEnvironment.QueueBackgroundWorkItem` | **None** |
| Hangfire / Quartz.NET / FluentScheduler | **None** |

---

## Registered HttpModules (web.config)

These are all **vendor/framework modules**, not custom application code:

| Module | Type | Purpose |
|--------|------|---------|
| `RadUploadModule` | `Telerik.Web.UI.RadUploadHttpModule` | Telerik async file upload progress tracking |
| `RadCompression` | `Telerik.Web.UI.RadCompression` | Telerik HTTP response compression |
| `ErrorLog` | `Elmah.ErrorLogModule` | ELMAH -- logs unhandled exceptions to SQL Server |
| `ErrorMail` | `Elmah.ErrorMailModule` | ELMAH -- emails error notifications to `support@uacdc.org` |
| `ErrorFilter` | `Elmah.ErrorFilterModule` | ELMAH -- filters out 404 errors from logging |

**None of these are custom application modules.** All are third-party libraries.

---

## Registered HttpHandlers (web.config)

All vendor/framework handlers:

| Handler | Path | Type | Purpose |
|---------|------|------|---------|
| Telerik ChartImage | `ChartImage.axd` | `Telerik.Web.UI.ChartHttpHandler` | Telerik chart image rendering |
| Telerik SpellCheck | `Telerik.Web.UI.SpellCheckHandler.axd` | `Telerik.Web.UI.SpellCheckHandler` | Telerik spell check |
| Telerik Dialog | `Telerik.Web.UI.DialogHandler.aspx` | `Telerik.Web.UI.DialogHandler` | Telerik dialog windows |
| Telerik Upload | `Telerik.RadUploadProgressHandler.ashx` | `Telerik.Web.UI.RadUploadProgressHandler` | Upload progress |
| Telerik WebResource | `Telerik.Web.UI.WebResource.axd` | `Telerik.Web.UI.WebResource` | Telerik embedded resources |
| ReportViewer | `Reserved.ReportViewerWebControl.axd` | `Microsoft.Reporting.WebForms.HttpHandler` | SSRS ReportViewer control |
| ELMAH | `elmah.axd` | `Elmah.ErrorLogPageFactory` | ELMAH error log viewer UI |

---

## Database-Level Scheduled Work

### SQL Server Audit Triggers (18 tables)

The database has **INSERT/UPDATE/DELETE triggers** on 18 core tables that write to companion `*_Audit` tables. These fire synchronously on every write -- not background jobs, but worth noting for migration:

| Table | Trigger Events | Audit Table |
|-------|---------------|-------------|
| Addresses | INSERT, UPDATE, DELETE | Addresses_Audit |
| ClassAttendances | INSERT, UPDATE, DELETE | ClassAttendances_Audit |
| Classes | INSERT, UPDATE, DELETE | Classes_Audit |
| CourseInstances | INSERT, UPDATE, DELETE | CourseInstances_Audit |
| Courses | INSERT, UPDATE, DELETE | Courses_Audit |
| Enrollments | INSERT, UPDATE, DELETE | Enrollments_Audit |
| EventAttendances | INSERT, UPDATE, DELETE | EventAttendances_Audit |
| Events | INSERT, UPDATE, DELETE | Events_Audit |
| InventoryItems | INSERT, UPDATE, DELETE | InventoryItems_Audit |
| LessonPlans | INSERT, UPDATE, DELETE | LessonPlans_Audit |
| Locations | INSERT, UPDATE, DELETE | Locations_Audit |
| Persons | INSERT, UPDATE, DELETE | Persons_Audit |
| PhoneNumbers | INSERT, UPDATE, DELETE | PhoneNumbers_Audit |
| Programs | INSERT, UPDATE, DELETE | Programs_Audit |
| RiskAssessments | INSERT, UPDATE, DELETE | RiskAssessments_Audit |
| Sites | INSERT, UPDATE, DELETE | Sites_Audit |
| StaffMembers | INSERT, UPDATE, DELETE | StaffMembers_Audit |
| Students | INSERT, UPDATE, DELETE | Students_Audit |

**Audit columns captured:** `AuditAction` (I/U/D), `AuditDateTime`, `AuditUser`, `AuditSQLUser`, plus all columns from the source row.

### Maintenance Stored Procedure

| SP | Purpose | Trigger |
|----|---------|---------|
| `spMaintenance_RegisterStudentsToClassesWithAttendance` | Back-fills missing `PersonsToCourseInstances` records by joining `ClassAttendances` → `Classes` → `CourseInstances` for students who have attendance but no explicit course registration | **Unknown** -- no application code calls this SP. Likely run manually or via SQL Server Agent job on the database server. |

**What it does:**
```sql
-- Finds students with class attendance records who are NOT registered
-- in the corresponding course instance, then inserts the missing registration
INSERT INTO PersonsToCourseInstances (PersonID, CourseInstanceID)
SELECT DISTINCT p.PersonID, c.CourseInstanceID
FROM Persons → Students → ClassAttendances → Classes → CourseInstances
LEFT JOIN PersonsToCourseInstances  -- where registration is missing
WHERE ptci.PersonID IS NULL
```

---

## Email Sending (Synchronous, Not Background)

Email is sent **synchronously** during request processing -- not queued or backgrounded:

| Trigger | Method | Transport | Template |
|---------|--------|-----------|----------|
| Password reset (ForgotPassword.aspx) | `Utilities.SendMail()` | `SmtpClient` (SMTP relay from web.config) | `Template_GeneralBranding.htm` |
| Technical support form (TechnicalSupport.aspx) | Direct `SmtpClient` | `SmtpClient` (localhost:25) | None (plain HTML) |
| ELMAH error notification | `Elmah.ErrorMailModule` | SMTP (configured in web.config) | ELMAH default |

**Note:** SendGrid SDK is referenced in TechnicalSupport.aspx.cs but the code is **commented out** -- the app uses raw `SmtpClient` instead.

---

## Grant Year Rollover

| Setting | Value | Purpose |
|---------|-------|---------|
| `appSettings["rolloverstartdate"]` | `10/01/2021` | Hardcoded grant year start date used by `EnrollmentPage.aspx.cs` to set default enrollment dates |

This is a **configuration value**, not a scheduled job. There is no automated rollover process -- the date appears to be manually updated in web.config when a new grant year begins.

---

## Migration Impact Summary

| Concern | Legacy Approach | Next.js Equivalent | Priority |
|---------|----------------|-------------------|----------|
| **Audit logging** | SQL Server triggers (18 tables) | Prisma middleware or PostgreSQL triggers | HIGH -- must preserve audit trail |
| **Error logging** | ELMAH → SQL Server + email | Sentry, LogRocket, or built-in Next.js error handling | MEDIUM |
| **Email sending** | Synchronous `SmtpClient` in request thread | Async email via SendGrid/Resend API (ADR-006 TBD) | MEDIUM |
| **Student-course registration backfill** | `spMaintenance_RegisterStudentsToClassesWithAttendance` (manual/SQL Agent) | Cron job or database function in PostgreSQL | LOW -- data integrity fix, not core feature |
| **Grant year rollover** | Manual web.config edit | Environment variable or admin settings page | LOW |
| **File upload progress** | Telerik `RadUploadHttpModule` | Native browser `fetch` with progress events | LOW -- comes free with modern stack |
| **HTTP compression** | Telerik `RadCompression` | Next.js/Vercel built-in compression | LOW -- comes free with modern stack |

### Key Takeaway

The legacy app is remarkably **stateless and synchronous** for its era. There are:
- Zero background threads or timers
- Zero message queues or event buses
- Zero scheduled application-level jobs
- Zero async processing patterns

All work happens in the HTTP request/response cycle. The only "background" work is:
1. **Database triggers** firing synchronously on writes (audit logging)
2. **One maintenance SP** likely run via SQL Server Agent
3. **ELMAH** modules intercepting errors passively

This significantly simplifies the migration -- there is no background job infrastructure to replicate. The main concerns are preserving the audit trail (triggers → Prisma middleware) and moving email to an async pattern.
