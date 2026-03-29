# Prodigy Legacy App -- Service Inventory

> Generated: 2026-03-29
> Source: `/specs/_audit/services.xml` (Repomix export) + direct codebase scan
> Pattern searched: `**/*.asmx`, `**/*.asmx.cs`, `**/*.ashx`, `**/*.ashx.cs`, `[WebMethod]`, `IHttpHandler`

---

## Result: No Services Found

The legacy Prodigy application contains **zero** web services or HTTP handlers:

| Type | Count | Files Found |
|------|-------|-------------|
| `.asmx` (SOAP Web Services) | 0 | None |
| `.ashx` (HTTP Handlers) | 0 | None |
| `[WebMethod]` attributes | 0 | None (only in Telerik vendor XML) |
| `IHttpHandler` implementations | 0 | None (only in Telerik vendor XML) |

---

## Architectural Implication

The legacy app is a **pure server-side WebForms postback monolith**. All user interactions flow through:

```
.aspx Page (postback) → code-behind (.aspx.cs) → POD.Logic (static methods) → POD.Data (static methods) → Entity Framework (ObjectContext) → SQL Server
```

There is no REST API, no SOAP service layer, and no AJAX endpoint layer exposed by the application itself. The only client-side async behavior comes from **Telerik RadAjaxManager**, which wraps standard postbacks as partial-page updates (similar to UpdatePanel but Telerik's proprietary implementation).

---

## Migration Impact

| Concern | Detail |
|---------|--------|
| **API Design** | The new Next.js app must design an API layer from scratch — there is no existing contract to migrate |
| **Data Access** | All 14 static `*Data.cs` classes in `POD.Data` become the source-of-truth for API route design |
| **Business Logic** | All 13 static `*Logic.cs` classes in `POD.Logic` define the operations that need Next.js API route equivalents |
| **No Client-Side Fetch** | The legacy app has zero `fetch()` / `XMLHttpRequest` / client-initiated API calls — all data flows through postbacks |

### Recommended Next.js API Route Mapping

Based on the `POD.Logic` classes, the new API surface should include:

| Logic Class | Suggested API Route Prefix | Operations |
|-------------|---------------------------|------------|
| `PeopleLogic` | `/api/people` | Person/student/staff CRUD, search, bulk edit |
| `PersonRelatedLogic` | `/api/enrollments`, `/api/attendance` | Enrollment mgmt, event/attendance orchestration |
| `ProgramCourseClassLogic` | `/api/programs`, `/api/courses`, `/api/classes` | Programs, courses, classes, lesson plans |
| `ContractLogic` | `/api/contracts` | Contract and quota management |
| `InventoryLogic` | `/api/inventory` | Inventory item CRUD |
| `RiskAssessmentLogic` | `/api/risk-assessments` | Risk assessment workflow |
| `AddressPhoneNumerLogic` | `/api/addresses`, `/api/phones` | Address/phone CRUD |
| `LookUpTypesLogic` | `/api/lookups` | Reference data (races, genders, statuses, etc.) |
| `ManageTypesLogic` | `/api/admin/types` | Generic type CRUD |
| `PATFormLogic` | `/api/pat-forms` | PAT form operations |
| `Security` | `/api/auth` | Auth, role mgmt (→ NextAuth.js) |
| `Reporting` | `/api/reports` | Report data (→ Metabase) |
| `Utilities` | N/A (inline) | Helpers absorbed into individual routes |
