# Prodigy Legacy App -- Report Inventory

> Generated: 2026-03-29
> Source: Code-behind analysis of reporting pages + ReportingData.cs + web.config
> SSRS Server: `http://DESKTOP-CTTIGCS/ReportServer`
> Reports Base Path: `/UACDC/PODReports`

---

## Report Configuration

### SSRS Server Details
| Setting | Value |
|---------|-------|
| ReportServerUrl | `http://DESKTOP-CTTIGCS/ReportServer` |
| ReportsBasePath | `/UACDC/PODReports` |
| ReportServerUserName | `DESKTOP-CTTIGCS\Spark` |
| ReportServerPassword | Stored in appSettings (plaintext) |

### ReportViewport Control Architecture
- **Control:** `~/UserControls/ReportViewport.ascx` (backed by `ReportViewport.ascx.cs`)
- **Pattern:** Each report page hosts a `<uc:ReportViewport>` with a `ReportName` property. On postback, the page calls `ReportViewport.Render(this)` passing itself as an `IReportParametersContainer`.
- **Flow:**
  1. `Initialize()` reads `ReportServerUrl`, `ReportServerUserName`, `ReportServerPassword`, `ReportsBasePath` from `web.config` appSettings.
  2. Constructs `ReportPath` as `{ReportsBasePath}/{ReportName}` (e.g., `/UACDC/PODReports/CensusReportV2`).
  3. Sets `ReportServerCredentials` using `NetworkCredential` (username + password, no domain impersonation).
  4. On `Render()`, calls `ServerReport.SetParameters()` with the page's `ReportParameters` collection, then shows the report body.
- **Viewer:** Microsoft `ReportViewer` web control in server report mode (remote SSRS).
- **Credentials:** `ReportServerCredentials.cs` implements `IReportServerCredentials` using `NetworkCredential` -- no Windows impersonation, no forms credentials.

### Authorization Pattern
- **web.config location rules:** Each report page has a `<location>` block with `<allow roles="..."/>` and `<deny users="*"/>`.
- **SecureContent control:** Many pages additionally use `<auth:SecureContent>` to toggle visibility/enable state of the Site dropdown filter. Roles like `Administrators`, `CentralTeamUsers` get full access to all sites; non-privileged roles (`SiteTeamUsers`) are locked to their own site via the `OnAuthorizationFailed` handler.

### Data Access
- **ReportingData.cs** contains only one method: `GetMasterClassScheduleParameterLookupData(int programId)` -- calls stored procedure `spGetMasterClassScheduleParameterLookupData` to populate the Master Class Schedule filter dropdowns.
- All other report data is fetched by SSRS itself -- the stored procedures are called by the `.rdl` report definitions on the SSRS server, not from C# code. The C# code only passes parameters to SSRS.

---

## Report Inventory

### 1. CensusReportV2

| Field | Detail |
|-------|--------|
| SSRS Report Name | `CensusReportV2` |
| SSRS Path | `/UACDC/PODReports/CensusReportV2` |
| Host Page | `~/Pages/Reporting/CensusReport.aspx` |
| Data Source (SP) | SSRS-server-side (likely `spGetCensusReport` or similar -- called from .rdl) |
| Output Format | SSRS (HTML, PDF, Excel, Word export) |
| Authorization | Administrators, Administrators-NA, CentralTeamUsers, SiteTeamUsers, SiteTeamUsers-NA |

**Parameters:**
| Parameter | Type | Source Control | SP Parameter (estimated) |
|-----------|------|---------------|--------------------------|
| targetDate | DateTime | RadMonthYearPicker (month/year) | @targetDate |
| programId | String (Int) | Session["ProgramID"] (hidden) | @programId |
| siteLocationId | String (Int, nullable) | RadComboBox (Sites dropdown, "All Sites" = null) | @siteLocationId |

**Stored Procedure Signature (estimated):**
```sql
EXEC spGetCensusReportV2 @targetDate, @programId, @siteLocationId
```

**Notes:**
- Site dropdown is restricted for non-admin roles via `SecureContent` (Roles: Administrators, Administrators-NA, CentralTeamUsers, CentralTeamUsers-NA). Non-privileged users are locked to their assigned site.
- RadMonthYearPicker defaults to current month. A commented-out MinDate restriction (2014-08-01) exists related to removed Risk Assessments.

**Metabase Migration Notes:**
- Complexity: **MEDIUM**
- Can be replaced by: SQL query with date/site parameters -> Metabase custom question
- Special considerations: Census logic (youth who attended at least once per month) may be complex. Requires understanding the SSRS .rdl dataset query.

---

### 2. BillingReport

| Field | Detail |
|-------|--------|
| SSRS Report Name | `BillingReport` |
| SSRS Path | `/UACDC/PODReports/BillingReport` |
| Host Page | `~/Pages/Reporting/BillingReport.aspx` |
| Data Source (SP) | SSRS-server-side (likely `spGetBillingReport`) |
| Output Format | SSRS (HTML, PDF, Excel, Word export) |
| Authorization | Administrators, Administrators-NA, CentralTeamUsers (from ReportingPage.aspx SecureContent) |

**Parameters:**
| Parameter | Type | Source Control | SP Parameter (estimated) |
|-----------|------|---------------|--------------------------|
| targetDate | DateTime | RadMonthYearPicker (month/year) | @targetDate |
| programId | String (Int) | Session["ProgramID"] (hidden) | @programId |
| siteLocationId | String (Int, nullable) | RadComboBox (Sites dropdown) | @siteLocationId |

**Stored Procedure Signature (estimated):**
```sql
EXEC spGetBillingReport @targetDate, @programId, @siteLocationId
```

**Notes:**
- Code-behind is structurally identical to CensusReport. The .aspx page Inherits `CensusReport` (appears to be a copy-paste artifact).
- No explicit web.config location rule -- access governed by general `Pages` deny-anonymous rule plus ReportingPage.aspx SecureContent visibility.

**Metabase Migration Notes:**
- Complexity: **MEDIUM**
- Can be replaced by: SQL query / custom question
- Special considerations: Billing logic likely involves monetary calculations; verify accuracy of Metabase replacement.

---

### 3. MonthlyAttendanceReport

| Field | Detail |
|-------|--------|
| SSRS Report Name | `MonthlyAttendanceReport` |
| SSRS Path | `/UACDC/PODReports/MonthlyAttendanceReport` |
| Host Page | `~/Pages/Reporting/MonthlyAttendanceReport.aspx` |
| Data Source (SP) | SSRS-server-side (likely `spGetMonthlyAttendanceReport`) |
| Output Format | SSRS (HTML, PDF, Excel, Word export) |
| Authorization | Administrators, Administrators-NA, CentralTeamUsers, SiteTeamUsers, SiteTeamUsers-NA |

**Parameters:**
| Parameter | Type | Source Control | SP Parameter (estimated) |
|-----------|------|---------------|--------------------------|
| targetDate | DateTime | RadMonthYearPicker (month/year, auto-postback) | @targetDate |
| courseInstanceId | String (Int, nullable) | RadComboBox (Classes dropdown, "All Classes" = null) | @courseInstanceId |
| programId | String (Int) | Session["ProgramID"] (hidden) | @programId |
| sitelocationId | String (Int) | RadComboBox (Sites dropdown, required) | @sitelocationId |

**Stored Procedure Signature (estimated):**
```sql
EXEC spGetMonthlyAttendanceReport @targetDate, @courseInstanceId, @programId, @sitelocationId
```

**Notes:**
- Cascading filters: Changing Site or TargetDate refreshes the Class (CourseInstance) dropdown via AJAX (RadAjaxManagerProxy).
- CourseInstance list is filtered by `CourseIsWithinTargetDateBounds()` -- only shows classes active during the selected month.
- Site is required; non-admin users are locked to their site.

**Metabase Migration Notes:**
- Complexity: **HIGH**
- Can be replaced by: Metabase dashboard with linked filters (site -> class cascade)
- Special considerations: Calendar-table attendance format may require custom SQL or pivoting. Cascading dropdown (site -> class filtered by date) needs Metabase filter linking.

---

### 4. MonthlyNonAttendanceReport

| Field | Detail |
|-------|--------|
| SSRS Report Name | `MonthlyNonAttendanceReport` |
| SSRS Path | `/UACDC/PODReports/MonthlyNonAttendanceReport` |
| Host Page | `~/Pages/Reporting/MonthlyNonAttendanceReport.aspx` |
| Data Source (SP) | SSRS-server-side (likely `spGetMonthlyNonAttendanceReport`) |
| Output Format | SSRS (HTML, PDF, Excel, Word export) |
| Authorization | Administrators, Administrators-NA, CentralTeamUsers, SiteTeamUsers (from ReportingPage.aspx SecureContent) |

**Parameters:**
| Parameter | Type | Source Control | SP Parameter (estimated) |
|-----------|------|---------------|--------------------------|
| minDate | DateTime | Auto-calculated (today - 1 year) | @minDate |
| maxDate | DateTime | Auto-calculated (today) | @maxDate |
| minDays | String (Int) | RadComboBox (Days dropdown: 15/30/45/60/75/90) | @minDays |
| siteLocationId | String (Int) | RadComboBox (Sites dropdown, "All Sites" = "%") | @siteLocationId |
| programId | String (Int) | Session["ProgramID"] (hidden) | @programId |

**Stored Procedure Signature (estimated):**
```sql
EXEC spGetMonthlyNonAttendanceReport @minDate, @maxDate, @minDays, @siteLocationId, @programId
```

**Notes:**
- Date range is auto-calculated (past year to today), not user-selectable.
- "Days since last attendance" dropdown offers 15+, 30+, 45+, 60+, 75+, 90+ thresholds.
- No explicit web.config location rule; governed by ReportingPage.aspx SecureContent visibility.

**Metabase Migration Notes:**
- Complexity: **LOW**
- Can be replaced by: SQL query with minDays parameter -> Metabase custom question
- Special considerations: The "days since last attendance" filter is a simple threshold; straightforward to implement.

---

### 5. MonthlyEnrollmentReport

| Field | Detail |
|-------|--------|
| SSRS Report Name | `MonthlyEnrollmentReport` |
| SSRS Path | `/UACDC/PODReports/MonthlyEnrollmentReport` |
| Host Page | `~/Pages/Reporting/MonthlyEnrollmentReport.aspx` |
| Data Source (SP) | SSRS-server-side (likely `spGetMonthlyEnrollmentReport`) |
| Output Format | SSRS (HTML, PDF, Excel, Word export) |
| Authorization | Administrators, Administrators-NA, CentralTeamUsers, SiteTeamUsers, SiteTeamUsers-NA |

**Parameters:**
| Parameter | Type | Source Control | SP Parameter (estimated) |
|-----------|------|---------------|--------------------------|
| targetDate | DateTime | RadMonthYearPicker (month/year) | @targetDate |
| programId | String (Int) | Session["ProgramID"] (hidden) | @programId |
| siteLocationId | String (Int, nullable) | RadComboBox (Sites dropdown, "All Sites" = null) | @siteLocationId |

**Stored Procedure Signature (estimated):**
```sql
EXEC spGetMonthlyEnrollmentReport @targetDate, @programId, @siteLocationId
```

**Notes:**
- Admins get "All" option in site dropdown; CentralTeamUsers do not (unless also Admin).
- Non-admin users locked to their site.

**Metabase Migration Notes:**
- Complexity: **LOW**
- Can be replaced by: SQL query / custom question
- Special considerations: Simple parameter set (month + site).

---

### 6. EnrollmentNotesReport

| Field | Detail |
|-------|--------|
| SSRS Report Name | `EnrollmentNotesReport` |
| SSRS Path | `/UACDC/PODReports/EnrollmentNotesReport` |
| Host Page | `~/Pages/Reporting/EnrollmentNotesReport.aspx` |
| Data Source (SP) | SSRS-server-side (likely `spGetEnrollmentNotesReport`) |
| Output Format | SSRS (HTML, PDF, Excel, Word export) |
| Authorization | Administrators, Administrators-NA, CentralTeamUsers (from ReportingPage.aspx SecureContent) |

**Parameters:**
| Parameter | Type | Source Control | SP Parameter (estimated) |
|-----------|------|---------------|--------------------------|
| startdate | DateTime | RadDatePicker (specific date) | @startdate |
| enddate | DateTime | RadDatePicker (specific date) | @enddate |
| siteid | Int | RadComboBox (Sites dropdown, required) | @siteid |

**Stored Procedure Signature (estimated):**
```sql
EXEC spGetEnrollmentNotesReport @startdate, @enddate, @siteid
```

**Notes:**
- Uses RadDatePicker (full dates) not RadMonthYearPicker.
- No explicit web.config location rule; admin-only access via ReportingPage.aspx SecureContent.
- No programId parameter sent to SSRS (unlike most other reports).

**Metabase Migration Notes:**
- Complexity: **MEDIUM**
- Can be replaced by: SQL query / custom question
- Special considerations: Enrollment notes are likely free-text fields; may need careful formatting in Metabase.

---

### 7. DeletedEnrollmentReport (BulkDeletedEnrollmentReport)

| Field | Detail |
|-------|--------|
| SSRS Report Name | `BulkDeletedEnrollmentReport` |
| SSRS Path | `/UACDC/PODReports/BulkDeletedEnrollmentReport` |
| Host Page | `~/Pages/Reporting/DeletedEnrollmentReport.aspx` |
| Data Source (SP) | SSRS-server-side (likely `spGetBulkDeletedEnrollmentReport`) |
| Output Format | SSRS (HTML, PDF, Excel, Word export) |
| Authorization | Administrators, Administrators-NA, CentralTeamUsers (from ReportingPage.aspx SecureContent) |

**Parameters:**
| Parameter | Type | Source Control | SP Parameter (estimated) |
|-----------|------|---------------|--------------------------|
| startdate | DateTime | RadDatePicker (Start Date) | @startdate |
| enddate | DateTime | RadDatePicker (End Date) | @enddate |
| programId | String (Int) | Session["ProgramID"] (hidden) | @programId |
| siteLocationId | String (Int, nullable) | RadComboBox (Sites dropdown, "All Sites" = null) | @siteLocationId |

**Stored Procedure Signature (estimated):**
```sql
EXEC spGetBulkDeletedEnrollmentReport @startdate, @enddate, @programId, @siteLocationId
```

**Notes:**
- No explicit web.config location rule; admin-only via ReportingPage.aspx SecureContent.

**Metabase Migration Notes:**
- Complexity: **LOW**
- Can be replaced by: SQL query / custom question
- Special considerations: Audit trail of deleted enrollments; may need soft-delete awareness.

---

### 8. ReleasedYouthReport

| Field | Detail |
|-------|--------|
| SSRS Report Name | `ReleasedYouthReport` |
| SSRS Path | `/UACDC/PODReports/ReleasedYouthReport` |
| Host Page | `~/Pages/Reporting/ReleasedYouthReport.aspx` |
| Data Source (SP) | SSRS-server-side (likely `spGetReleasedYouthReport`) |
| Output Format | SSRS (HTML, PDF, Excel, Word export) |
| Authorization | Administrators, Administrators-NA, CentralTeamUsers, SiteTeamUsers |

**Parameters:**
| Parameter | Type | Source Control | SP Parameter (estimated) |
|-----------|------|---------------|--------------------------|
| releaseDate | DateTime | RadMonthYearPicker (month/year) | @releaseDate |
| GrantYear | String | RadComboBox (Grant Year, data-bound from ManageTypesLogic.GetGrantYears) | @GrantYear |
| programId | String (Int) | Session["ProgramID"] (hidden) | @programId |
| siteLocationId | String (Int, nullable) | RadComboBox (Sites dropdown, "All Sites" = null) | @siteLocationId |

**Stored Procedure Signature (estimated):**
```sql
EXEC spGetReleasedYouthReport @releaseDate, @GrantYear, @programId, @siteLocationId
```

**Notes:**
- Youth Type dropdown drives Grant Year dropdown (cascading via `RadcbYouthtype_SelectedIndexChanged`).
- Youth Type dropdown populated from `ManageTypesLogic.GetYouthTypes()`.
- Grant Year defaults to current grant year via `ManageTypesLogic.GetCurrentGrantYear()`.
- Previously had date range pickers (Start/End) but these were commented out in favor of month picker + grant year.

**Metabase Migration Notes:**
- Complexity: **MEDIUM**
- Can be replaced by: SQL query with grant year filter -> custom question
- Special considerations: Grant year concept is domain-specific; must understand how grant years map to date ranges.

---

### 9. AutoYouthReleaseReport (uses ReleasedYouthReport SSRS name)

| Field | Detail |
|-------|--------|
| SSRS Report Name | `ReleasedYouthReport` (same as #8) |
| SSRS Path | `/UACDC/PODReports/ReleasedYouthReport` |
| Host Page | `~/Pages/Reporting/AutoYouthReleaseReport.aspx` |
| Data Source (SP) | Same as ReleasedYouthReport |
| Output Format | SSRS (HTML, PDF, Excel, Word export) |
| Authorization | No explicit web.config rule; falls under general Pages deny-anonymous |

**Parameters:**
| Parameter | Type | Source Control | SP Parameter (estimated) |
|-----------|------|---------------|--------------------------|
| selecteddate | DateTime (string) | RadDatePicker (specific date) | @selecteddate |
| programId | String (Int) | Session["ProgramID"] (hidden) | @programId |
| siteLocationId | String (Int, nullable) | RadComboBox (Sites dropdown, "All Sites" = null) | @siteLocationId |

**Stored Procedure Signature (estimated):**
```sql
EXEC spGetReleasedYouthReport @selecteddate, @programId, @siteLocationId
```

**Notes:**
- This page re-uses the `ReleasedYouthReport` SSRS report but passes **different parameters** (selecteddate vs. releaseDate/GrantYear). This suggests the SSRS .rdl may accept both parameter sets, or this is a variant view.
- Youth Type dropdown is loaded but the `SelectedIndexChanged` handler is fully commented out.
- Uses RadDatePicker (specific date) rather than month/year picker.
- The page title says "Released Youth Report" despite different file name.

**Metabase Migration Notes:**
- Complexity: **LOW** (likely consolidate with #8)
- Can be replaced by: Same query as ReleasedYouthReport with different parameter set
- Special considerations: Clarify whether this is a distinct report or a duplicate entry point.

---

### 10. ReturningYouthReport

| Field | Detail |
|-------|--------|
| SSRS Report Name | `ReturningYouthReport` |
| SSRS Path | `/UACDC/PODReports/ReturningYouthReport` |
| Host Page | `~/Pages/Reporting/ReturningYouthReport.aspx` |
| Data Source (SP) | SSRS-server-side (likely `spGetReturningYouthReport`) |
| Output Format | SSRS (HTML, PDF, Excel, Word export) |
| Authorization | Administrators, Administrators-NA, CentralTeamUsers, SiteTeamUsers |

**Parameters:**
| Parameter | Type | Source Control | SP Parameter (estimated) |
|-----------|------|---------------|--------------------------|
| startDate | DateTime | RadDatePicker (Start Date) | @startDate |
| endDate | DateTime | RadDatePicker (End Date) | @endDate |
| programId | String (Int) | Session["ProgramID"] (hidden) | @programId |
| siteLocationId | String (Int, nullable) | RadComboBox (Sites dropdown, "All Sites" = null) | @siteLocationId |
| enrollmentTypeId | String (Int, nullable) | RadComboBox (Service Category dropdown, "All Categories" = null) | @enrollmentTypeId |

**Stored Procedure Signature (estimated):**
```sql
EXEC spGetReturningYouthReport @startDate, @endDate, @programId, @siteLocationId, @enrollmentTypeId
```

**Notes:**
- Enrollment Types (Service Categories) populated from `ManageTypesLogic.GetTypesByType(TypesData.Types.EnrollmentType)`.
- Date range with comparison validator (end >= start).
- Commented out on ReportingPage.aspx (the GO button is inside a comment block), suggesting this report may be deprecated or hidden from the UI.

**Metabase Migration Notes:**
- Complexity: **MEDIUM**
- Can be replaced by: SQL query with date range + service category filter
- Special considerations: "Returning youth" = youth absent 90+ days who re-enrolled. Verify if still actively used (commented out on landing page).

---

### 11. DiversionYouthReport

| Field | Detail |
|-------|--------|
| SSRS Report Name | `DiversionYouthReport` |
| SSRS Path | `/UACDC/PODReports/DiversionYouthReport` |
| Host Page | `~/Pages/Reporting/DiversionYouthReport.aspx` |
| Data Source (SP) | SSRS-server-side (likely `spGetDiversionYouthReport`) |
| Output Format | SSRS (HTML, PDF, Excel, Word export) |
| Authorization | Administrators, Administrators-NA, CentralTeamUsers, SiteTeamUsers |

**Parameters:**
| Parameter | Type | Source Control | SP Parameter (estimated) |
|-----------|------|---------------|--------------------------|
| minDate | DateTime | RadDatePicker (Start Date) | @minDate |
| maxDate | DateTime | RadDatePicker (End Date) | @maxDate |
| programId | String (Int) | Session["ProgramID"] (hidden) | @programId |
| siteLocationId | String (Int, nullable) | RadComboBox (Sites dropdown, "All Sites" = null) | @siteLocationId |

**Stored Procedure Signature (estimated):**
```sql
EXEC spGetDiversionYouthReport @minDate, @maxDate, @programId, @siteLocationId
```

**Notes:**
- Standard date range + site filter pattern.
- Relates to Bay Area Youth Services (BAYS) diversion program.

**Metabase Migration Notes:**
- Complexity: **LOW**
- Can be replaced by: SQL query / custom question
- Special considerations: Diversion-specific business logic may be in the SP.

---

### 12. InventoryReport

| Field | Detail |
|-------|--------|
| SSRS Report Name | `InventoryReport` |
| SSRS Path | `/UACDC/PODReports/InventoryReport` |
| Host Page | `~/Pages/Reporting/InventoryReport.aspx` |
| Data Source (SP) | SSRS-server-side (likely `spGetInventoryReport`) |
| Output Format | SSRS (HTML, PDF, Excel, Word export) |
| Authorization | Administrators, Administrators-NA, CentralTeamUsers, CentralTeamUsers-NA, SiteTeamUsers |

**Parameters:**
| Parameter | Type | Source Control | SP Parameter (estimated) |
|-----------|------|---------------|--------------------------|
| locationId | String (Int, nullable) | RadComboBox (Location dropdown, "All" = null) | @locationId |
| siteid | Int | Session["UsersSiteID"] (hidden, auto-set) | @siteid |

**Stored Procedure Signature (estimated):**
```sql
EXEC spGetInventoryReport @locationId, @siteid
```

**Notes:**
- Uses Location (not Site) as the primary filter. Locations are sub-units of Sites.
- Admin/Central users see all locations; site users see locations within their site only (`GetLocationsBySite` vs `GetLocations`).
- No date parameters -- this is a current-state snapshot report.
- No programId parameter.

**Metabase Migration Notes:**
- Complexity: **LOW**
- Can be replaced by: SQL query / custom question
- Special considerations: Simple inventory list; straightforward migration.

---

### 13. StaffVacancyReport

| Field | Detail |
|-------|--------|
| SSRS Report Name | `StaffVacancyReport` |
| SSRS Path | `/UACDC/PODReports/StaffVacancyReport` |
| Host Page | `~/Pages/Reporting/StaffVacancyReport.aspx` |
| Data Source (SP) | SSRS-server-side (likely `spGetStaffVacancyReport`) |
| Output Format | SSRS (HTML, PDF, Excel, Word export) |
| Authorization | Administrators, Administrators-NA, CentralTeamUsers, SiteTeamUsers |

**Parameters:**
| Parameter | Type | Source Control | SP Parameter (estimated) |
|-----------|------|---------------|--------------------------|
| programId | String (Int) | Session["ProgramID"] (hidden) | @programId |
| siteLocationId | String (Int, nullable) | RadComboBox (Sites dropdown, "All Sites" = null) | @siteLocationId |

**Stored Procedure Signature (estimated):**
```sql
EXEC spGetStaffVacancyReport @programId, @siteLocationId
```

**Notes:**
- No date parameters -- appears to show current vacancies.
- Submitted monthly to DJJ.

**Metabase Migration Notes:**
- Complexity: **LOW**
- Can be replaced by: SQL query / custom question
- Special considerations: Simple site-filtered list.

---

### 14. StaffVerificationReport

| Field | Detail |
|-------|--------|
| SSRS Report Name | `StaffVerificationReport` |
| SSRS Path | `/UACDC/PODReports/StaffVerificationReport` |
| Host Page | `~/Pages/Reporting/StaffVerificationReport.aspx` |
| Data Source (SP) | SSRS-server-side (likely `spGetStaffVerificationReport`) |
| Output Format | SSRS (HTML, PDF, Excel, Word export) |
| Authorization | Administrators, Administrators-NA, CentralTeamUsers, SiteTeamUsers |

**Parameters:**
| Parameter | Type | Source Control | SP Parameter (estimated) |
|-----------|------|---------------|--------------------------|
| organization | String (Int, nullable) | RadComboBox (Sites/Org dropdown, "All Organizations" = null) | @organization |

**Stored Procedure Signature (estimated):**
```sql
EXEC spGetStaffVerificationReport @organization
```

**Notes:**
- Only parameter is organization (site). No dates, no programId.
- Used internally by Prodigy Central to update DJJ's Staff Verification Report System.
- Dropdown label says "All Organizations" (not "All Sites").

**Metabase Migration Notes:**
- Complexity: **LOW**
- Can be replaced by: SQL query / custom question
- Special considerations: Very simple single-filter report.

---

### 15. FriendsAndFamilyReport

| Field | Detail |
|-------|--------|
| SSRS Report Name | `FriendsAndFamilyReport` |
| SSRS Path | `/UACDC/PODReports/FriendsAndFamilyReport` |
| Host Page | `~/Pages/Reporting/FriendsAndFamilyReport.aspx` |
| Data Source (SP) | SSRS-server-side (likely `spGetFriendsAndFamilyReport`) |
| Output Format | SSRS (HTML, PDF, Excel, Word export) |
| Authorization | Administrators, Administrators-NA, CentralTeamUsers, SiteTeamUsers |

**Parameters:**
| Parameter | Type | Source Control | SP Parameter (estimated) |
|-----------|------|---------------|--------------------------|
| startDate | DateTime | RadDatePicker (Start Date) | @startDate |
| endDate | DateTime | RadDatePicker (End Date) | @endDate |
| programId | String (Int) | Session["ProgramID"] (hidden) | @programId |
| siteLocationId | String (Int, nullable) | RadComboBox (Sites dropdown, "All Sites" = null) | @siteLocationId |

**Stored Procedure Signature (estimated):**
```sql
EXEC spGetFriendsAndFamilyReport @startDate, @endDate, @programId, @siteLocationId
```

**Notes:**
- Standard date range + site pattern.
- Date comparison validator (end >= start).
- Tracks event attendance (youth, staff, friends, family counts).

**Metabase Migration Notes:**
- Complexity: **LOW**
- Can be replaced by: SQL query / custom question
- Special considerations: Event-based report; aggregate counts.

---

### 16. ProdigyStaffReport

| Field | Detail |
|-------|--------|
| SSRS Report Name | `ProdigyStaffReport` |
| SSRS Path | `/UACDC/PODReports/ProdigyStaffReport` |
| Host Page | `~/Pages/Reporting/ProdigyStaffReport.aspx` |
| Data Source (SP) | SSRS-server-side (likely `spGetProdigyStaffReport`) |
| Output Format | SSRS (HTML, PDF, Excel, Word export) |
| Authorization | Administrators, Administrators-NA, CentralTeamUsers, SiteTeamUsers |

**Parameters:**
| Parameter | Type | Source Control | SP Parameter (estimated) |
|-----------|------|---------------|--------------------------|
| siteLocationId | String (Int) | RadComboBox (Sites dropdown, required) | @siteLocationId |
| locationId | String (Int) | RadComboBox (Location dropdown, cascading from Site, required) | @locationId |
| instructorPersonId | null | Hardcoded null | @instructorPersonId |
| minDate | DateTime | RadDatePicker (Start Date) | @minDate |
| maxDate | DateTime | RadDatePicker (End Date) | @maxDate |
| programId | String (Int) | Session["ProgramID"] (hidden) | @programId |

**Stored Procedure Signature (estimated):**
```sql
EXEC spGetProdigyStaffReport @siteLocationId, @locationId, @instructorPersonId, @minDate, @maxDate, @programId
```

**Notes:**
- Cascading filter: Site selection drives Location dropdown via AJAX (`RadAjaxManager`).
- `instructorPersonId` is always passed as null (parameter exists for future filtering).
- Location is required (has validator).

**Metabase Migration Notes:**
- Complexity: **MEDIUM**
- Can be replaced by: SQL query / dashboard with linked filters
- Special considerations: Site -> Location cascading filter needs Metabase filter linking. Summary of classes, hours, age groups by location.

---

### 17. ProdigyCollectiveStaffReport

| Field | Detail |
|-------|--------|
| SSRS Report Name | `ProdigyCollectiveStaffReport` |
| SSRS Path | `/UACDC/PODReports/ProdigyCollectiveStaffReport` |
| Host Page | `~/Pages/Reporting/ProdigyCollectiveStaffReport.aspx` |
| Data Source (SP) | SSRS-server-side (likely `spGetProdigyCollectiveStaffReport`) |
| Output Format | SSRS (HTML, PDF, Excel, Word export) |
| Authorization | Administrators, Administrators-NA, CentralTeamUsers |

**Parameters:**
| Parameter | Type | Source Control | SP Parameter (estimated) |
|-----------|------|---------------|--------------------------|
| siteLocationId | String (Int, nullable) | RadComboBox (Sites dropdown, "All" for Admins) | @siteLocationId |
| locationId | null | Hardcoded null | @locationId |
| instructorPersonId | null | Hardcoded null | @instructorPersonId |
| minDate | DateTime | RadDatePicker (Start Date) | @minDate |
| maxDate | DateTime | RadDatePicker (End Date) | @maxDate |
| programId | String (Int) | Session["ProgramID"] (hidden) | @programId |

**Stored Procedure Signature (estimated):**
```sql
EXEC spGetProdigyCollectiveStaffReport @siteLocationId, @locationId, @instructorPersonId, @minDate, @maxDate, @programId
```

**Notes:**
- Admin-only report (Central Team + Administrators).
- No `SecureContent` wrapper on site dropdown -- uses direct `Initialize()` with role-based "All" option.
- `locationId` and `instructorPersonId` always null -- this is the aggregate/collective view (vs. per-location ProdigyStaffReport).
- No `auth:SecureContent` control on site dropdown (no `OnAuthorizationFailed`).

**Metabase Migration Notes:**
- Complexity: **MEDIUM**
- Can be replaced by: SQL query / dashboard (aggregate view across all sites)
- Special considerations: Likely shares same underlying SP as ProdigyStaffReport but with null location/instructor.

---

### 18. ProdigyEnrollmentReport

| Field | Detail |
|-------|--------|
| SSRS Report Name | `ProdigyEnrollmentReport` |
| SSRS Path | `/UACDC/PODReports/ProdigyEnrollmentReport` |
| Host Page | `~/Pages/Reporting/ProdigyEnrollmentReport.aspx` |
| Data Source (SP) | SSRS-server-side (likely `spGetProdigyEnrollmentReport`) |
| Output Format | SSRS (HTML, PDF, Excel, Word export) |
| Authorization | Administrators, Administrators-NA, CentralTeamUsers, SiteTeamUsers |

**Parameters:**
| Parameter | Type | Source Control | SP Parameter (estimated) |
|-----------|------|---------------|--------------------------|
| targetDate | DateTime | RadMonthYearPicker (month/year) | @targetDate |
| programId | String (Int) | Session["ProgramID"] (hidden) | @programId |

**Stored Procedure Signature (estimated):**
```sql
EXEC spGetProdigyEnrollmentReport @targetDate, @programId
```

**Notes:**
- Simplest report -- only month/year and programId parameters.
- No site filter at all. Page title is "Performance Enrollment Report".
- No SecureContent control.

**Metabase Migration Notes:**
- Complexity: **LOW**
- Can be replaced by: SQL query / custom question
- Special considerations: Organization-wide performance report; no site filtering needed.

---

### 19. MasterClassScheduleReport

| Field | Detail |
|-------|--------|
| SSRS Report Name | `MasterClassScheduleReport` |
| SSRS Path | `/UACDC/PODReports/MasterClassScheduleReport` |
| Host Page | `~/Pages/Reporting/MasterClassScheduleReport.aspx` |
| Data Source (SP) | `spGetMasterClassScheduleParameterLookupData` (for filter population via ReportingData.cs); SSRS-side SP for report data |
| Output Format | SSRS (HTML, PDF, Excel, Word export) |
| Authorization | Administrators, Administrators-NA, CentralTeamUsers, SiteTeamUsers, SiteTeamUsers-NA |

**Parameters:**
| Parameter | Type | Source Control | SP Parameter (estimated) |
|-----------|------|---------------|--------------------------|
| startDate | DateTime (nullable) | RadDatePicker (Start Date) | @startDate |
| endDate | DateTime (nullable) | RadDatePicker (End Date) | @endDate |
| siteLocationId | String (Int, nullable) | RadComboBox (Site, "All" = null) | @siteLocationId |
| classDays | String (comma-separated Ints, nullable) | RadComboBox with CheckBoxes (multi-select: Sun=1..Sat=7) | @classDays |
| classHour | String (Int, nullable) | RadComboBox (Time dropdown) | @classHour |
| courseTypeId | String (Int, nullable) | RadComboBox (Class Type dropdown) | @courseTypeId |
| courseId | String (Int, nullable) | RadComboBox (Class Name dropdown) | @courseId |
| ageGroupId | String (Int, nullable) | RadComboBox (Age dropdown) | @ageGroupId |
| instructorPersonId | String (Int, nullable) | RadComboBox (Instructor dropdown) | @instructorPersonId |

**Stored Procedure Signature (estimated):**
```sql
EXEC spGetMasterClassScheduleReport @startDate, @endDate, @siteLocationId, @classDays, @classHour, @courseTypeId, @courseId, @ageGroupId, @instructorPersonId
```

**Notes:**
- Most complex report with 9 parameters and multi-select checkboxes for class days.
- Filter dropdowns populated via `spGetMasterClassScheduleParameterLookupData` (the only SP called from C# ReportingData.cs) -> `MasterClassScheduleReportParameters` class extracts distinct Sites, ClassTypes, Classes, Ages, Times, Instructors.
- All filters are optional (nullable).
- Date comparison validator.
- A `ProgrammingLocation` dropdown is commented out in both .aspx and .cs.

**Metabase Migration Notes:**
- Complexity: **HIGH**
- Can be replaced by: SQL query with multiple optional filters -> Metabase dashboard
- Special considerations: Multi-select days (checkbox combo), 9 optional parameters, and the SP for populating lookup data. Most complex migration target.

---

### 20. BulkExport (Dynamic Report Selector)

| Field | Detail |
|-------|--------|
| SSRS Report Name | Dynamic -- selected from dropdown (see sub-reports below) |
| SSRS Path | `/UACDC/PODReports/{SelectedReportName}` |
| Host Page | `~/Pages/Reporting/BulkExport.aspx` |
| Data Source (SP) | SSRS-server-side (per sub-report) |
| Output Format | SSRS (HTML, PDF, Excel, Word export) |
| Authorization | Administrators, Administrators-NA, CentralTeamUsers |

**Sub-Reports Available:**
| Display Name | SSRS Report Name |
|-------------|-----------------|
| User Logins | `BulkUserRecordsReport` |
| Staff Records | `BulkStaffRecordsReport` |
| Youth Records | `BulkYouthRecordsReport` |
| Classes | `BulkClassRecordsReport` |
| Events | `BulkEventRecordsReport` |
| Locations | `BulkLocationRecordsReport` |
| Sites | `BulkSiteRecordsReport` |
| Risk Assessments | `BulkRiskAssessmentFormsReport` |
| Enrollments | `BulkEnrollmentFormsReport` |
| Inventory | `BulkInventoryRecordsReport` |
| Lesson Plan Sets | `BulkLessonPlanSetsRecordsReport` |

**Parameters:**
| Parameter | Type | Source Control | SP Parameter (estimated) |
|-----------|------|---------------|--------------------------|
| (none) | -- | -- | -- |

**Notes:**
- `ReportParameters` yields nothing (`yield break`) -- all bulk reports are parameterless data dumps.
- Report name is set dynamically from the dropdown: `ReportViewport.ReportName = DropDownReports.SelectedValue` then `Initialize()` is called to re-configure the SSRS path.
- Admin/Central-only access.

**Metabase Migration Notes:**
- Complexity: **LOW** (each sub-report is a simple data dump)
- Can be replaced by: 11 separate Metabase saved questions (SQL queries), or a single dashboard with tabs
- Special considerations: These are raw data exports, ideal for Metabase's native export-to-CSV/Excel capability.

---

### 21. BulkEnrollmentExport (BulkEnrollmentFormsReport)

| Field | Detail |
|-------|--------|
| SSRS Report Name | `BulkEnrollmentFormsReport` |
| SSRS Path | `/UACDC/PODReports/BulkEnrollmentFormsReport` |
| Host Page | `~/Pages/Reporting/BulkEnrollmentExport.aspx` |
| Data Source (SP) | SSRS-server-side (likely `spGetBulkEnrollmentFormsReport`) |
| Output Format | SSRS (HTML, PDF, Excel, Word export) |
| Authorization | Administrators, Administrators-NA, CentralTeamUsers (from ReportingPage.aspx SecureContent) |

**Parameters:**
| Parameter | Type | Source Control | SP Parameter (estimated) |
|-----------|------|---------------|--------------------------|
| GrantYear | String | RadComboBox (Grant Year, cascading from Youth Type) | @GrantYear |
| programId | String (Int) | Session["ProgramID"] (hidden) | @programId |
| siteLocationId | String (Int, nullable) | RadComboBox (Sites dropdown, "All Sites" = null) | @siteLocationId |

**Stored Procedure Signature (estimated):**
```sql
EXEC spGetBulkEnrollmentFormsReport @GrantYear, @programId, @siteLocationId
```

**Notes:**
- Dedicated enrollment export page (separate from BulkExport.aspx which also has an Enrollments option).
- Youth Type cascading to Grant Year (same pattern as ReleasedYouthReport).
- This is a parameterized version of the enrollment export (vs. the parameterless BulkEnrollmentFormsReport in BulkExport.aspx).

**Metabase Migration Notes:**
- Complexity: **LOW**
- Can be replaced by: SQL query with grant year + site parameters
- Special considerations: May overlap with BulkExport's "Enrollments" option; clarify which version to keep.

---

## Summary Table

| # | SSRS Report Name | Host Page | Params | Authorization | Complexity |
|---|-----------------|-----------|--------|---------------|------------|
| 1 | CensusReportV2 | CensusReport.aspx | targetDate, programId, siteLocationId | Admin, Central, Site, Site-NA | MEDIUM |
| 2 | BillingReport | BillingReport.aspx | targetDate, programId, siteLocationId | Admin, Central | MEDIUM |
| 3 | MonthlyAttendanceReport | MonthlyAttendanceReport.aspx | targetDate, courseInstanceId, programId, sitelocationId | Admin, Central, Site, Site-NA | HIGH |
| 4 | MonthlyNonAttendanceReport | MonthlyNonAttendanceReport.aspx | minDate, maxDate, minDays, siteLocationId, programId | Admin, Central, Site | LOW |
| 5 | MonthlyEnrollmentReport | MonthlyEnrollmentReport.aspx | targetDate, programId, siteLocationId | Admin, Central, Site, Site-NA | LOW |
| 6 | EnrollmentNotesReport | EnrollmentNotesReport.aspx | startdate, enddate, siteid | Admin, Central | MEDIUM |
| 7 | BulkDeletedEnrollmentReport | DeletedEnrollmentReport.aspx | startdate, enddate, programId, siteLocationId | Admin, Central | LOW |
| 8 | ReleasedYouthReport | ReleasedYouthReport.aspx | releaseDate, GrantYear, programId, siteLocationId | Admin, Central, Site | MEDIUM |
| 9 | ReleasedYouthReport (variant) | AutoYouthReleaseReport.aspx | selecteddate, programId, siteLocationId | Authenticated users | LOW |
| 10 | ReturningYouthReport | ReturningYouthReport.aspx | startDate, endDate, programId, siteLocationId, enrollmentTypeId | Admin, Central, Site | MEDIUM |
| 11 | DiversionYouthReport | DiversionYouthReport.aspx | minDate, maxDate, programId, siteLocationId | Admin, Central, Site | LOW |
| 12 | InventoryReport | InventoryReport.aspx | locationId, siteid | Admin, Central, Central-NA, Site | LOW |
| 13 | StaffVacancyReport | StaffVacancyReport.aspx | programId, siteLocationId | Admin, Central, Site | LOW |
| 14 | StaffVerificationReport | StaffVerificationReport.aspx | organization | Admin, Central, Site | LOW |
| 15 | FriendsAndFamilyReport | FriendsAndFamilyReport.aspx | startDate, endDate, programId, siteLocationId | Admin, Central, Site | LOW |
| 16 | ProdigyStaffReport | ProdigyStaffReport.aspx | siteLocationId, locationId, instructorPersonId, minDate, maxDate, programId | Admin, Central, Site | MEDIUM |
| 17 | ProdigyCollectiveStaffReport | ProdigyCollectiveStaffReport.aspx | siteLocationId, locationId, instructorPersonId, minDate, maxDate, programId | Admin, Central | MEDIUM |
| 18 | ProdigyEnrollmentReport | ProdigyEnrollmentReport.aspx | targetDate, programId | Admin, Central, Site | LOW |
| 19 | MasterClassScheduleReport | MasterClassScheduleReport.aspx | startDate, endDate, siteLocationId, classDays, classHour, courseTypeId, courseId, ageGroupId, instructorPersonId | Admin, Central, Site, Site-NA | HIGH |
| 20 | BulkExport (11 sub-reports) | BulkExport.aspx | (none -- parameterless) | Admin, Central | LOW |
| 21 | BulkEnrollmentFormsReport | BulkEnrollmentExport.aspx | GrantYear, programId, siteLocationId | Admin, Central | LOW |

**Totals:** 21 report pages hosting 30+ distinct SSRS report definitions (including 11 bulk export sub-reports).

**Complexity Distribution:**
- LOW: 13 reports
- MEDIUM: 7 reports
- HIGH: 2 reports (MonthlyAttendanceReport, MasterClassScheduleReport)

---

## Metabase Migration Strategy

### Phase 1: Quick Wins (LOW complexity -- 13 reports)
These reports have simple parameter sets (0-4 params) and straightforward data:
- StaffVacancyReport, StaffVerificationReport, InventoryReport -- current-state snapshots
- MonthlyEnrollmentReport, ProdigyEnrollmentReport -- single month + optional site
- MonthlyNonAttendanceReport, DiversionYouthReport, FriendsAndFamilyReport -- date range + site
- DeletedEnrollmentReport, AutoYouthReleaseReport -- date range + site
- All 11 BulkExport sub-reports -- parameterless data dumps
- BulkEnrollmentExport -- grant year + site

**Approach:** Create Metabase "Custom Questions" (native SQL queries) with filter widgets. Use Metabase's built-in export buttons for CSV/Excel/PDF.

### Phase 2: Medium Complexity (7 reports)
These require cascading filters or domain-specific logic:
- CensusReportV2, BillingReport -- census/billing calculation logic
- EnrollmentNotesReport -- free-text note formatting
- ReleasedYouthReport -- grant year cascading from youth type
- ReturningYouthReport -- service category filter + potential deprecation
- ProdigyStaffReport, ProdigyCollectiveStaffReport -- site->location cascading

**Approach:** Metabase dashboards with linked filter widgets. May need custom SQL models for complex calculations. Grant year / youth type cascading can use Metabase's "linked filters" feature.

### Phase 3: Complex Reports (2 reports)
- **MonthlyAttendanceReport:** Calendar-grid format with site->class cascading filtered by date
- **MasterClassScheduleReport:** 9 optional parameters including multi-select days

**Approach:** These may require Metabase dashboard with multiple filter widgets + custom SQL models. The multi-select days filter for MasterClassSchedule can use Metabase's multi-value filter widget. Calendar-grid attendance format may need a pivot query or custom visualization.

### Cross-Cutting Concerns

1. **SSRS .rdl files needed:** The stored procedure names and exact SQL are not in the C# code -- they are embedded in the .rdl report definitions on the SSRS server. Before migration, extract the dataset queries from each .rdl file.

2. **Authorization mapping:** Map the ASP.NET roles to NextAuth.js roles:
   - `Administrators` / `Administrators-NA` -> admin role
   - `CentralTeamUsers` / `CentralTeamUsers-NA` -> central_team role
   - `SiteTeamUsers` / `SiteTeamUsers-NA` -> site_team role
   - Site-level filtering (lock user to their site) must be enforced in Metabase via row-level permissions or query parameters.

3. **Session["ProgramID"]:** Nearly every report uses this hidden parameter. In Metabase, this becomes either a global filter or is embedded in the SQL based on user context.

4. **Session["UsersSiteID"]:** Used to lock non-admin users to their site. Implement via Metabase sandboxing or parameterized queries.

5. **Export formats:** SSRS provides HTML, PDF, Excel, Word. Metabase provides interactive HTML, PDF, CSV, Excel (XLSX). Word export will be lost -- determine if any reports actually use Word export.

6. **ReportingPage.aspx:** The reporting landing page with descriptions and role-gated GO buttons. Replace with a Next.js `/reports` page with role-based card visibility.
