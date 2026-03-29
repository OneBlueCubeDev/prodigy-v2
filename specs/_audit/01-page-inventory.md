# Prodigy Legacy App -- Page Inventory

> Generated: 2026-03-29
> Source: `/specs/_audit/pages.xml` (Repomix export of all .aspx / .aspx.cs files)
> Total pages audited: **55 .aspx pages**

---

## 1. Root Pages (Login, ForgotPassword, default)

### default.aspx
| Field | Detail |
|-------|--------|
| Route | ~/default.aspx |
| Master | None (standalone) |
| Purpose | Empty landing page that immediately redirects to Login.aspx |
| Risk Tier | LOW |

**UpdatePanels:** None

**Postback Events:** None

**ViewState Keys:** None

**Session Keys:** None

**Business Logic Summary:**
Page_Load performs `Response.Redirect("~/Login.aspx")`. No other logic.

---

### Login.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Login.aspx |
| Master | None (standalone) |
| Purpose | ASP.NET Membership login page with remember-me cookie support |
| Risk Tier | LOW |

**UpdatePanels:** None

**Postback Events:**
- `Login1_Error` -- handles login errors
- `Login1_LoggedIn` -- sets remember-me cookie, redirects to UACDCPrograms.aspx

**ViewState Keys:** None

**Session Keys:** None

**Business Logic Summary:**
Uses ASP.NET `asp:Login` control with Forms Authentication. On load, reads `myCookie` to pre-fill username for remember-me. On successful login, writes a 15-day cookie. Destination page is `~/Pages/UACDCPrograms.aspx`. Error handler captures last server error.

---

### ForgotPassword.aspx
| Field | Detail |
|-------|--------|
| Route | ~/ForgotPassword.aspx |
| Master | None (standalone) |
| Purpose | Allows users to change their password or retrieve their username via email |
| Risk Tier | MEDIUM |

**UpdatePanels:** None (uses RadAjaxManager but no AJAX settings)

**Postback Events:**
- `ChangePasswordForForgot_Click` -- validates email + username, updates ASP.NET Membership password
- `ButtonRetrieveUserName_Click` -- looks up username by email + zip code, sends email
- `LinkButtonRetrieveUserName_Click` -- switches MultiView to username recovery view

**ViewState Keys:** None

**Session Keys:** None

**Business Logic Summary:**
Uses `asp:MultiView` with 3 views (password change, username recovery, success). Password change validates email match against membership, then calls `Security.UpdatePasswordAndEmail()`. Username retrieval uses `Membership.GetUserNameByEmail()`, validates zip against staff addresses, then sends email via `Utilities.SendMail()` using an HTML template. Logic classes: PeopleLogic, Utilities.

---

## 2. Core Application Pages (under Pages/)

### UACDCPrograms.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/UACDCPrograms.aspx |
| Master | None (standalone) |
| Purpose | Program selection page shown after login; user picks which program to work in |
| Risk Tier | MEDIUM |

**UpdatePanels:** None

**Postback Events:**
- `DataListPrograms_ItemCommand` -- sets Session["ProgramID"] and redirects to ControlPanel
- `DataListPrograms_ItemDataBound` -- binds program data
- `LoginStatus1_LoggedOut` -- handles logout

**ViewState Keys:** None

**Session Keys:**
- `Session["ProgramID"]` -- write, set when user selects a program

**Business Logic Summary:**
Loads available programs via `ProgramCourseClassLogic`. On program selection, stores ProgramID in session and redirects to ControlPanel. Acts as a program-switching gateway after login.

---

### ControlPanel.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/ControlPanel.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Main dashboard/control panel page after program selection |
| Risk Tier | LOW |

**UpdatePanels:** None

**Postback Events:** None

**ViewState Keys:** None

**Session Keys:** None

**Business Logic Summary:**
Minimal code-behind. Sets master page navigation to "Dashboard" on load. Content is primarily in the master page and user controls.

---

### Enrollments.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Enrollments.aspx |
| Master | ~/Templates/Markup/Admin.Master |
| Purpose | Lists all youth enrollments with filtering, context menus for edit/view/transfer/release actions |
| Risk Tier | HIGH |

**UpdatePanels:**
- RadAjaxManagerProxy with settings for `RadGridEnrollments`, `RadMenuOptionsInactive`, `RadMenuOptions`

**Postback Events:**
- `RadGridEnrollments_NeedDataSource` -- loads enrollment data filtered by site/program
- `RadGridEnrollments_ItemDataBound` -- customizes grid rows based on enrollment status
- `RadMenu1_ItemClick` -- handles context menu actions (edit, view, transfer, release, delete, print)

**ViewState Keys:** None

**Session Keys:**
- `Session["UsersSiteID"]` -- read, filters enrollments by site
- `Session["ProgramID"]` -- read, filters enrollments by program

**Business Logic Summary:**
Heavy data grid page using RadGrid with context menus. Loads enrollment data via `PeopleLogic`, `PersonRelatedLogic`, `ManageTypesLogic`, `PATFormLogic`. Context menu handles navigation to EnrollmentPage, TransferYouthPage, ReleaseYouthPage, and deletion. Supports both active and inactive enrollment views. Has export capabilities.

---

### EnrollmentPage.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/EnrollmentPage.aspx |
| Master | ~/Templates/Markup/Admin.Master |
| Purpose | Comprehensive youth enrollment form for creating/editing enrollment records with demographics, contacts, notes, doctors, and documents |
| Risk Tier | HIGH |

**UpdatePanels:**
- `UpdatePanelAuthorized` -- pickup authorization section
- `UpdatePanelDoc` -- doctor/physician section
- `updatepanelnotes` -- enrollment notes section
- RadAjaxManagerProxy with settings for `RadComboBoxSites`, `Radcbyouthtype`

**Postback Events:**
- `SaveButton_Click` -- saves complete enrollment record
- `DeleteButton_Click` -- deletes enrollment
- `PrintButton_Click` -- prints enrollment form
- `Update_Click` -- updates enrollment
- `EnrollmentPickUpAuthorizationAdd_Click` -- adds pickup authorization
- `EnrollmentPickUpAuthorizationList_DeleteCommand` -- deletes pickup auth
- `ButtonAddDoctor_Click` -- adds physician
- `RadGridDoctors_DeleteCommand` -- deletes physician
- `EnrollmentNotesAdd_Click` -- adds enrollment note
- `NotesGrid_DeleteCommand` / `notesgrid_InsertCommand` / `notesgrid_UpdateCommand` -- CRUD for notes
- `EnrollmentNotesPrint_Click` -- prints notes
- `BulletedList1_Click` -- navigation
- Multiple server-side validators (SSN, phone, race, ethnicity, family status, etc.)

**ViewState Keys:**
- `ViewState["PersonID"]` -- current person ID
- `ViewState["TempPersonID"]` -- temporary person ID for new enrollments
- `ViewState["EnrollmentID"]` -- current enrollment ID
- `ViewState["RiskAssessmentID"]` -- associated risk assessment ID
- `ViewState["OldEnrollmentID"]` -- previous enrollment for rollover
- `ViewState["RolloverID"]` -- grant year rollover ID
- `ViewState["IsRollOver"]` -- boolean flag for rollover state

**Session Keys:**
- `Session["UsersSiteID"]` -- read, for site filtering
- `Session["ProgramID"]` -- read, for program context

**Business Logic Summary:**
The most complex page in the application. Manages the entire enrollment lifecycle including: person demographics (name, DOB, SSN, race, ethnicity, gender), address/phone, parent/guardian info, pickup authorizations, physician records, enrollment notes, enrollment type/status, site/location assignment, and grant year rollovers. Uses 7+ logic classes: PeopleLogic, PersonRelatedLogic, AddressPhoneNumerLogic, LookUpTypesLogic, ManageTypesLogic, PATFormLogic, Utilities. Extensive form validation with ~15 server validators. Supports print export.

---

### AttendancePage.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/AttendancePage.aspx |
| Master | None (standalone, popup window) |
| Purpose | Attendance entry form for recording event and class attendance for youth |
| Risk Tier | HIGH |

**UpdatePanels:**
- RadAjaxManagerProxy with settings for `RadGriAttendancesEvent`, `RadGriAttendancesClass`, `ButtonSaveClass`, `ButtonSave`

**Postback Events:**
- `SaveButton_Click` -- saves attendance records
- `Button1_Click` -- additional save action
- `ImageButton3_Click` -- export/print action
- `RadGriAttendancesEvent_NeedDataSource` -- loads event attendance grid
- `RadGriAttendancesClass_NeedDataSource` -- loads class attendance grid
- `RadContextMenuEA_ItemClick` / `RadMenu1_ItemClick` -- context menu actions

**ViewState Keys:**
- `ViewState["EventID"]` -- current event ID
- `ViewState["ClassID"]` -- current class ID

**Session Keys:**
- `Session["UsersSiteID"]` -- read, for site context

**Business Logic Summary:**
Dual-grid attendance page handling both event-based and class-based attendance. Loaded as a popup window (no master page). Uses RadGrid with export to Excel capabilities. Logic classes: ManageTypesLogic, PersonRelatedLogic, ProgramCourseClassLogic, PeopleLogic. Supports CRUD operations and attendance export.

---

### Attendances.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Attendances.aspx |
| Master | ~/Templates/Markup/Admin.Master |
| Purpose | Lists attendance records for a specific youth with filtering by program and site |
| Risk Tier | MEDIUM |

**UpdatePanels:**
- RadAjaxManagerProxy with settings for `RadGridAttendance`

**Postback Events:**
- `RadGridAttendance_NeedDataSource` -- loads attendance data for the person

**ViewState Keys:**
- `ViewState["PersonID"]` -- person whose attendances are displayed

**Session Keys:**
- `Session["UsersSiteID"]` -- read, site filter
- `Session["ProgramID"]` -- read, program filter

**Business Logic Summary:**
Read-only grid page displaying attendance history for a specific person. Data loaded via ProgramCourseClassLogic and filtered by site/program from session.

---

### EventPage.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/EventPage.aspx |
| Master | ~/Templates/Markup/Admin.Master |
| Purpose | Create/edit an event record with site, type, category, and custom field assignments |
| Risk Tier | HIGH |

**UpdatePanels:**
- RadAjaxManagerProxy with settings for `RadComboBoxSite`, `RadComboBoxTypes`, `rcbCategory1`, `rcbCategory2`

**Postback Events:**
- `SaveButton_Click` -- saves event record
- `DeleteButton_Click` -- deletes event
- `RadComboBoxSite_SelectedIndexChanged` -- reloads dependent dropdowns on site change
- `RadComboBoxTypes_OnSelectedIndexChanged` -- reloads categories on type change
- `rcbCategory1_OnSelectedIndexChanged` / `rcbCategory2_OnSelectedIndexChanged` -- cascading category selects
- `rlvFields1_OnNeedDataSource` / `rlvFields2_OnNeedDataSource` -- loads dynamic form fields

**ViewState Keys:**
- `ViewState["EventID"]` -- current event being edited

**Session Keys:**
- `Session["UsersSiteID"]` -- read, for site context
- `Session["ProgramID"]` -- read, for program context

**Business Logic Summary:**
Complex event management form with cascading dropdowns (site -> type -> category -> fields). Uses ManageTypesLogic, ProgramCourseClassLogic, LookUpTypesLogic. Supports CRUD with redirect after save/delete.

---

### Events.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Events.aspx |
| Master | ~/Templates/Markup/Admin.Master |
| Purpose | Lists all events with filtering and context menu navigation to event details and attendance |
| Risk Tier | MEDIUM |

**UpdatePanels:**
- RadAjaxManagerProxy with settings for `RadGridEvents`

**Postback Events:**
- `RadGridEvents_NeedDataSource` -- loads events filtered by site/program
- `RadMenu1_ItemClick` -- context menu for edit, view attendance, delete

**ViewState Keys:** None

**Session Keys:**
- `Session["UsersSiteID"]` -- read, site filter
- `Session["ProgramID"]` -- read, program filter

**Business Logic Summary:**
Grid listing page for events. Context menu handles navigation to EventPage (edit) and AttendancePage (view attendance). Uses ProgramCourseClassLogic and Utilities.

---

### Inventory.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Inventory.aspx |
| Master | ~/Templates/Markup/Admin.Master |
| Purpose | Lists inventory items with context menu for add/edit/delete operations |
| Risk Tier | MEDIUM |

**UpdatePanels:**
- RadAjaxManagerProxy with settings for `RadGridAttendance`

**Postback Events:**
- `RadGridInventory_NeedDataSource` -- loads inventory data
- `RadMenu1_ItemClick` -- context menu actions

**ViewState Keys:** None

**Session Keys:**
- `Session["UsersSiteID"]` -- read, site filter

**Business Logic Summary:**
Grid listing for inventory items. Context menu navigates to InventoryItemPage for editing. Uses InventoryLogic and Utilities. Supports delete from context menu.

---

### InventoryItemPage.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/InventoryItemPage.aspx |
| Master | ~/Templates/Markup/Admin.Master |
| Purpose | Create/edit individual inventory item records with site assignment |
| Risk Tier | MEDIUM |

**UpdatePanels:** None

**Postback Events:**
- `SaveButton_Click` -- saves inventory item
- `DeleteButton_Click` -- deletes inventory item

**ViewState Keys:**
- `ViewState["InventoryItemID"]` -- current item being edited

**Session Keys:**
- `Session["UsersSiteID"]` -- read, for site assignment

**Business Logic Summary:**
Form for CRUD operations on inventory items. Uses InventoryLogic, LookUpTypesLogic. Role-based access via Security class. Redirects after save/delete.

---

### MyAccount.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/MyAccount.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | User account management page for viewing/editing profile and creating user accounts for staff |
| Risk Tier | MEDIUM |

**UpdatePanels:** None

**Postback Events:**
- `ButtonCreateUser_Click` -- creates a new ASP.NET Membership user account
- Server validators: `CustomValidatorUserName_ServerValidate`, `CustomValidatorEmailUnique_ServerValidate`

**ViewState Keys:**
- `ViewState["PersonID"]` -- current staff person ID

**Session Keys:** None

**Business Logic Summary:**
Account management form. Creates membership users and associates them with staff records. Validates username uniqueness and email uniqueness. Uses PeopleLogic, ManageTypesLogic, LookUpTypesLogic, Security.

---

### PATForm.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/PATForm.aspx |
| Master | ~/Templates/Markup/Admin.Master |
| Purpose | PAT (Program Assessment Tool) form entry page with tabbed sections for completing assessments |
| Risk Tier | HIGH |

**UpdatePanels:** None

**Postback Events:**
- `SaveButton_Click` -- saves form data
- `CompleteButton_Click` -- marks form as complete
- `PrintButton_Click` -- prints/exports form
- `sectionsTab_TabClick` -- handles tab navigation between form sections
- `Checkbox_Click` -- handles checkbox state changes

**ViewState Keys:** None

**Session Keys:**
- `Session["personId"]` -- read/write, current person ID
- `Session["personFormId"]` -- read/write, current form ID

**Business Logic Summary:**
Dynamic form page that loads assessment sections based on form ID. Uses Page_Init to dynamically build form sections. Tab-based navigation through assessment sections. CRUD via PeopleLogic. Supports print/export.

---

### PATForms.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/PATForms.aspx |
| Master | ~/Templates/Markup/Admin.Master |
| Purpose | Lists PAT forms for a person with options to create new forms or edit existing ones |
| Risk Tier | MEDIUM |

**UpdatePanels:**
- RadAjaxManagerProxy with settings for `RadGridEnrollments`, `RadMenuOptionsInactive`, `RadMenuOptions`

**Postback Events:**
- `NewButton_Click` -- creates a new PAT form
- `patFormGrid_NeedDataSource` -- loads PAT forms for the person
- `RadMenu1_ItemClick` -- context menu for edit/delete

**ViewState Keys:** None

**Session Keys:** None

**Business Logic Summary:**
Grid listing of PAT forms with context menu. Creates new forms, navigates to PATForm.aspx for editing. Redirects on actions.

---

### QuickAddPerson.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/QuickAddPerson.aspx |
| Master | None (standalone) |
| Purpose | Quick add person form (appears to be a stub/placeholder page) |
| Risk Tier | LOW |

**UpdatePanels:** None

**Postback Events:** None

**ViewState Keys:** None

**Session Keys:** None

**Business Logic Summary:**
Empty Page_Load with no logic. Appears to be an unused or placeholder page.

---

### ReleaseYouthPage.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/ReleaseYouthPage.aspx |
| Master | None (standalone, popup window) |
| Purpose | Youth release form loaded as a popup for releasing an enrollment |
| Risk Tier | LOW |

**UpdatePanels:** None

**Postback Events:** None

**ViewState Keys:** None

**Session Keys:** None

**Business Logic Summary:**
Hosts a `ReleaseForm.ascx` user control. Minimal code-behind with just Page_Load. The actual release logic resides in the user control.

---

### RiskAssessmentPage.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/RiskAssessmentPage.aspx |
| Master | ~/Templates/Markup/Admin.Master |
| Purpose | Risk assessment form for youth enrollments with site/location cascading dropdowns and detailed assessment fields |
| Risk Tier | HIGH |

**UpdatePanels:**
- RadAjaxManagerProxy with settings for `RadComboBoxProdigySite`, `RadComboBoxProdigyLocation`

**Postback Events:**
- `SaveButton_Click` -- saves risk assessment
- `DeleteButton_Click` -- deletes risk assessment
- `RadComboBoxProdigySite_OnSelectedIndexChanged` -- cascading site dropdown
- `RadComboBoxProdigyLocation_SelectedIndexChanged` -- cascading location dropdown

**ViewState Keys:**
- `ViewState["PersonID"]` -- current person
- `ViewState["RiskID"]` -- current risk assessment ID
- `ViewState["EnrollmentID"]` -- associated enrollment ID

**Session Keys:**
- `Session["UsersSiteID"]` -- read, site context
- `Session["ProgramID"]` -- read, program context

**Business Logic Summary:**
Complex assessment form with cascading site/location dropdowns. Full CRUD on risk assessments. Uses PeopleLogic, PersonRelatedLogic, ManageTypesLogic, LookUpTypesLogic. Role-based field visibility via Security class. Redirects after save/delete.

---

### ShowDuplicateStudents.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/ShowDuplicateStudents.aspx |
| Master | None (standalone) |
| Purpose | Displays a list of duplicate student records for review |
| Risk Tier | LOW |

**UpdatePanels:** None

**Postback Events:** None

**ViewState Keys:** None

**Session Keys:** None

**Business Logic Summary:**
Read-only page that loads duplicate student data via PeopleLogic on Page_Load. No editing capabilities.

---

### Staff.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Staff.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Lists all staff members with filtering, sorting, and context menu for add/edit/delete |
| Risk Tier | MEDIUM |

**UpdatePanels:**
- `RadAjaxManager1` with settings for `RadGridStaffMembers`

**Postback Events:**
- `RadGridStaffMembers_NeedDataSource` -- loads staff data
- `RadMenu1_ItemClick` -- context menu for edit/delete/add user

**ViewState Keys:** None

**Session Keys:**
- `Session["UsersSiteID"]` -- read, site filter

**Business Logic Summary:**
Grid listing of staff members filtered by site. Context menu navigates to StaffMember.aspx for editing. Uses PeopleLogic. Supports role-based visibility of menu options.

---

### StaffMember.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/StaffMember.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Staff member detail/edit form with personal info, site assignments, and user account creation |
| Risk Tier | HIGH |

**UpdatePanels:**
- RadAjaxManagerProxy with settings for `RadComboBoxSites`

**Postback Events:**
- `ButtonCreateUser_Click` -- creates ASP.NET Membership account for staff
- `DeleteButton_Click` -- deletes staff record
- `ButtonCancel_Click` -- returns to staff list
- Server validators: `CustomValidatorUserName_ServerValidate`, `CustomValidatorEmailUnique_ServerValidate`

**ViewState Keys:**
- `ViewState["PersonID"]` -- current staff member person ID

**Session Keys:**
- `Session["UsersSiteID"]` -- read, for site context

**Business Logic Summary:**
Comprehensive staff management form. Creates/edits staff person records and associated user accounts. Uses PeopleLogic, ManageTypesLogic, LookUpTypesLogic, Security. Validates username and email uniqueness. Supports delete with redirect.

---

### TechnicalSupport.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/TechnicalSupport.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Technical support request form for submitting help tickets |
| Risk Tier | LOW |

**UpdatePanels:** None

**Postback Events:**
- `ButtonRequest_Click` -- submits support request
- `ButtonCancel_Click` -- cancels and redirects back

**ViewState Keys:** None

**Session Keys:** None

**Business Logic Summary:**
Simple form submission. ButtonRequest_Click likely sends an email or creates a support ticket. Redirects on cancel.

---

### TransferYouthPage.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/TransferYouthPage.aspx |
| Master | None (standalone, popup window) |
| Purpose | Transfers a youth enrollment from one site/location to another |
| Risk Tier | MEDIUM |

**UpdatePanels:** None

**Postback Events:**
- `SaveButton_Click` -- saves the transfer (defined in aspx but wired in code-behind)

**ViewState Keys:**
- `ViewState["PersonID"]` -- person being transferred

**Session Keys:**
- `Session["UsersSiteID"]` -- read, current site context

**Business Logic Summary:**
Popup form for transferring youth between sites. Uses PeopleLogic and LookUpTypesLogic to load available sites and execute transfer. Writes the transfer via CRUD operations.

---

### DownLoad.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/DownLoad.aspx |
| Master | None (standalone) |
| Purpose | File download page for generating and serving downloadable documents (e.g., certificates) |
| Risk Tier | LOW |

**UpdatePanels:** None

**Postback Events:**
- `ButtonDownLoad_Click` -- triggers file download

**ViewState Keys:** None

**Session Keys:** None

**Business Logic Summary:**
Standalone page for file download. Uses PeopleLogic. Sets Response.ContentType and writes file bytes to response stream for download.

---

### YouthAttendances.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/YouthAttendances.aspx |
| Master | ~/Templates/Markup/Admin.Master |
| Purpose | Displays attendance history for a specific youth across all their enrolled classes/events |
| Risk Tier | MEDIUM |

**UpdatePanels:**
- RadAjaxManagerProxy with settings for `RadGridAttendance`

**Postback Events:**
- `RadGriAttendances_NeedDataSource` -- loads attendance data for the youth

**ViewState Keys:**
- `ViewState["PersonID"]` -- the youth whose attendances are shown

**Session Keys:**
- `Session["ProgramID"]` -- read, program filter

**Business Logic Summary:**
Read-only grid showing attendance records for a specific youth. Uses PersonRelatedLogic and PeopleLogic to load data filtered by program.

---

## 3. Lesson Plans Pages (under Pages/LessonPlans/)

### LessonPlanDetailPage.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/LessonPlans/LessonPlanDetailPage.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Detailed lesson plan editor with life skills, templates, site assignments, and print/export capabilities |
| Risk Tier | HIGH |

**UpdatePanels:** None (uses direct postbacks)

**Postback Events:**
- `btnUpdate_Click` -- saves lesson plan changes
- `ButtonCancel_Click` -- returns to previous page
- `ButtonPrint_Click` / `ButtonPrintAll_Click` -- print/export lesson plan
- `ButtonAddLifeskill_Click` -- adds a life skill to the plan
- `DataListLifeSkills_ItemCommand` -- handles life skill actions (edit/delete)
- `DataListLifeSkills_ItemDataBound` -- binds life skill data
- `RadComboBoxSiteLesson_OnSelectedIndexChanged` -- changes site filter
- `RadGridTemplate_NeedDataSource` -- loads template grid
- `RadGridTemplate_ItemCommand1` -- template grid actions

**ViewState Keys:**
- `ViewState["LessonPlanID"]` -- current lesson plan
- `ViewState["LessonPlanSetID"]` -- parent lesson plan set
- `ViewState["CurrentuserStaffMemberID"]` -- current staff member
- `ViewState["prevPage"]` -- previous page URL for navigation

**Session Keys:**
- `Session["UsersSiteID"]` -- read, site context
- `Session["ProgramID"]` -- read, program context

**Business Logic Summary:**
Complex lesson plan editor. Manages life skills list, template assignments, and lesson plan metadata. Uses PeopleLogic, ProgramCourseClassLogic, ManageTypesLogic, LookUpTypesLogic. Supports print and export. Role-based field visibility via Security class.

---

### LessonPlans.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/LessonPlans/LessonPlans.aspx |
| Master | ~/Templates/Markup/Admin.Master |
| Purpose | Lists lesson plan sets with options to create, edit, view detail, and manage status (approved/completed/inactive) |
| Risk Tier | HIGH |

**UpdatePanels:**
- RadAjaxManagerProxy with settings for `RadGridLessonPlanSet`, `RadAjaxManager1`

**Postback Events:**
- `RadGridLessonPlanSet_NeedDataSource` -- loads lesson plan sets
- `RadGridLessonPlanSet_ItemDataBound` -- customizes grid display
- `RadGridLessonPlanSet_InsertCommand` -- creates new lesson plan set
- `RadGridLessonPlanSet_ItemCommand` -- handles grid actions (edit, delete, detail)

**ViewState Keys:**
- `ViewState["ApprovedStatusID"]` -- approved status type ID
- `ViewState["CompletedStatusID"]` -- completed status type ID
- `ViewState["InactiveStatusID"]` -- inactive status type ID
- `ViewState["CurrentuserStaffMemberID"]` -- current staff member

**Session Keys:**
- `Session["UsersSiteID"]` -- read, site filter
- `Session["ProgramID"]` -- read, program filter

**Business Logic Summary:**
Grid management for lesson plan sets with hierarchy (detail tables). Supports CRUD and status transitions. Uses PeopleLogic, ProgramCourseClassLogic, ManageTypesLogic, LookUpTypesLogic, Security. Supports export.

---

### ReviewLessonPlans.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/LessonPlans/ReviewLessonPlans.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Admin review page for approving/rejecting lesson plans across sites |
| Risk Tier | HIGH |

**UpdatePanels:**
- RadAjaxManagerProxy with settings for `RadGridLessonPlanSet`, `ButtonApprove`

**Postback Events:**
- `ButtonApprove_Click` -- approves selected lesson plans
- `Searchbutton_Click` -- searches/filters lesson plans
- `RadComboBoxSiteLesson_OnSelectedIndexChanged` -- site filter change
- `RadGridLessonPlanSet_NeedDataSource` -- loads data
- `RadGridLessonPlanSet_ItemDataBound` -- grid customization
- `RadGridLessonPlanSet_InsertCommand` / `RadGridLessonPlanSet_ItemCommand` -- grid actions

**ViewState Keys:**
- `ViewState["ApprovedStatusID"]` -- approved status type ID

**Session Keys:**
- `Session["UsersSiteID"]` -- read, site filter
- `Session["ProgramID"]` -- read, program filter

**Business Logic Summary:**
Admin-facing review page for lesson plan approval workflow. Supports bulk approval, site filtering, and search. Uses ManageTypesLogic, ProgramCourseClassLogic, PeopleLogic, LookUpTypesLogic. Role-based site filter visibility.

---

## 4. Class Management Pages (under Pages/ManageClasses/)

### ClassCatalogs.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/ManageClasses/ClassCatalogs.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Lists course catalogs (class templates) with context menu for add/edit/delete |
| Risk Tier | MEDIUM |

**UpdatePanels:**
- `RadAjaxManager1` with settings for `RadGridCourses`

**Postback Events:**
- `RadGridCourses_NeedDataSource` -- loads course catalog data
- `RadMenu1_ItemClick` -- context menu for edit/delete

**ViewState Keys:** None

**Session Keys:**
- `Session["ProgramID"]` -- read, program filter

**Business Logic Summary:**
Grid listing of course catalogs. Context menu navigates to ClassDetailPage for editing. Uses ProgramCourseClassLogic. Supports delete from context menu.

---

### ClassDetailPage.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/ManageClasses/ClassDetailPage.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Detailed class/course editor with class instances, schedules, and lesson plan set assignments |
| Risk Tier | HIGH |

**UpdatePanels:**
- `RadAjaxManager1` with settings for `RadGridCourseInstance`, `RadGridClassess`

**Postback Events:**
- `btnUpdate_Click` -- saves course details
- `ButtonCancel_Click` -- returns to class list
- `ButtonPrint_Click` -- print/export
- `RadGridCourseInstance_InsertCommand` / `UpdateCommand` / `Delete` / `ItemCommand` -- CRUD for class instances
- `RadGridCourseInstance_ItemDatabound` -- customizes instance grid

**ViewState Keys:**
- `ViewState["CourseID"]` -- current course being edited
- `ViewState["LessonPlanSetID"]` -- associated lesson plan set

**Session Keys:**
- `Session["UsersSiteID"]` -- read, for site-scoped data
- `Session["ProgramID"]` -- read, program context

**Business Logic Summary:**
Complex course management page. Manages course metadata and nested class instances (with schedules, locations, instructors). Uses PeopleLogic, ProgramCourseClassLogic, ManageTypesLogic, LookUpTypesLogic, PersonRelatedLogic. Supports print/export.

---

### Classes.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/ManageClasses/Classes.aspx |
| Master | ~/Templates/Markup/Admin.Master |
| Purpose | Lists class instances with filtering by site/program and context menu for edit/registration/attendance |
| Risk Tier | MEDIUM |

**UpdatePanels:**
- RadAjaxManagerProxy with settings for `RadGridCourses`

**Postback Events:**
- `RadGridCourses_NeedDataSource` -- loads class instance data
- `RadGridCourses_ItemCommand` -- grid item actions
- `RadMenu1_ItemClick` -- context menu for edit, registration, attendance

**ViewState Keys:** None

**Session Keys:**
- `Session["UsersSiteID"]` -- read, site filter
- `Session["ProgramID"]` -- read, program filter

**Business Logic Summary:**
Grid listing of class instances. Context menu navigates to ClassDetailPage, ClassRegistration, and AttendancePage. Uses ProgramCourseClassLogic, PersonRelatedLogic, PeopleLogic, Utilities.

---

### ClassRegistration.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/ManageClasses/ClassRegistration.aspx |
| Master | ~/Templates/Markup/Admin.Master |
| Purpose | Manages youth registration/enrollment into specific class instances |
| Risk Tier | HIGH |

**UpdatePanels:**
- RadAjaxManagerProxy with settings for `ButtonAddPerson`, `DataListPeople`

**Postback Events:**
- `ButtonAddPerson_Click` -- registers a person in the class
- `DataListPeople_ItemCommand` -- handles person actions (remove from class)
- `RadGridCourseInstance_ItemDatabound` -- binds instance grid
- `RadGridCourseInstance_ItemCommand` -- instance grid actions
- `ButtonPrint_Click` -- print roster
- `ButtonCancel_Click` -- return to classes list

**ViewState Keys:**
- `ViewState["CourseInstanceID"]` -- current class instance
- `ViewState["CourseID"]` -- parent course
- `ViewState["lpsId"]` -- lesson plan set ID

**Session Keys:**
- `Session["UsersSiteID"]` -- read, site context

**Business Logic Summary:**
Class registration management. Adds/removes youth from class instances. Displays enrolled students and available students. Uses PersonRelatedLogic, ProgramCourseClassLogic, PeopleLogic. Supports print/export of class roster.

---

## 5. Admin Pages (under Pages/Admin/)

### Dashboard.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Admin/Dashboard.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Admin dashboard page (appears to be a placeholder with no dynamic content) |
| Risk Tier | LOW |

**UpdatePanels:** None

**Postback Events:** None

**ViewState Keys:** None

**Session Keys:** None

**Business Logic Summary:**
Empty Page_Load. Dashboard content is likely rendered via markup in the aspx file or master page.

---

### BulkEditingTool.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Admin/BulkEdit/BulkEditingTool.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Bulk editor for youth records allowing inline editing of demographics, addresses, and mass release operations |
| Risk Tier | HIGH |

**UpdatePanels:**
- `RadAjaxManager1` with settings for `RadcomboBoxFilter` -> `ListViewData`, `ListViewData` -> `ListViewData`

**Postback Events:**
- `RadcomboBoxFilter_SelectedIndexChanged` -- filters by enrollment type
- `ListViewData_ItemDataBound` -- binds data to each row
- `ListViewData_ItemUpdating` -- saves individual row changes
- `ListViewData_ItemUpdated` -- triggers bulk release if conditions met
- `ListViewData_PagePropertiesChanging` -- handles paging with save
- `Update_Click` -- saves all modified items

**ViewState Keys:**
- `ViewState["CurrentStartingPageIndex"]` -- pagination state
- `ViewState["Filter"]` -- current enrollment type filter
- `ViewState["ClassRelatedFilter"]` -- class-related filter flag

**Session Keys:**
- `Session["UsersSiteID"]` -- read, site filter (admin bypass)
- `Session["ProgramID"]` -- read, program context

**Business Logic Summary:**
Complex bulk editing tool with inline editing in a CustomListView. Edits person demographics (name, DOB, DJJ#), addresses, phone numbers, county, and status. Supports mass release with date/agency/reason. Uses PeopleLogic, AddressPhoneNumerLogic, ManageTypesLogic, RiskAssessmentLogic. Admin-only access via SecureContent controls.

---

### BulkReleaseTool.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Admin/BulkEdit/BulkReleaseTool.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Multi-step bulk youth release tool with criteria selection, youth selection, and release details |
| Risk Tier | HIGH |

**UpdatePanels:**
- `RadAjaxManager1` with settings for `RadcomboBoxFilter` -> `ListViewData`/`RadGrid1`, `ListViewData` -> `ListViewData`/`RadGrid1`

**Postback Events:**
- `Find_Click` -- searches for youth matching criteria
- `Update_Click` -- executes bulk release
- `RadcbYouthtype_SelectedIndexChanged` -- changes youth type filter, reloads grant years
- `RadGrid1_SelectedIndexChanged` -- handles row selection
- `RadGrid1_ItemDataBound` -- grid item binding
- `ListViewData_ItemUpdating` / `ListViewData_ItemUpdated` -- release processing
- `ListViewData_PagePropertiesChanging` -- paging with save

**ViewState Keys:**
- `ViewState["CurrentStartingPageIndex"]` -- pagination state
- `ViewState["Filter"]` -- enrollment type filter
- `ViewState["ClassRelatedFilter"]` -- class filter flag

**Session Keys:**
- `Session["UsersSiteID"]` -- read, site filter
- `Session["ProgramID"]` -- read, program context

**Business Logic Summary:**
3-step wizard: (1) select criteria (site, youth type, grant year), (2) select youth from grid, (3) enter release details (date, agency, reason). Processes release via RiskAssessmentLogic.ReleaseEnrollmentList(). Uses PeopleLogic, ManageTypesLogic, AddressPhoneNumerLogic, RiskAssessmentLogic. Admin-only access. Uses both RadGrid and CustomListView.

---

### ImportDJJNum.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Admin/Import/ImportDJJNum.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | CSV file import tool for matching and updating DJJ (Department of Juvenile Justice) numbers on youth records |
| Risk Tier | HIGH |

**UpdatePanels:** None

**Postback Events:**
- `ButtonImport_Click` -- uploads CSV and processes matches
- `RepeaterResults_ItemDataBound` -- renders import results
- `ButtonBackToImport_Click` -- returns to upload form

**ViewState Keys:** None

**Session Keys:** None

**Business Logic Summary:**
File upload and CSV parsing for DJJ number import. Supports two file formats: Diversion and Prevention. Uses LumenWorks CSV reader. Matching logic: finds existing youth by name/DOB, handles exact matches, multiple matches, and no-match scenarios. Updates DJJ numbers and enrollment status via PeopleLogic.UpdateYouthsDJJNumberandEnrollmentStatus(). Multi-panel UI: Upload, Review, Results. Admin-only access.

---

### Communities.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Admin/ManageCommunities/Communities.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Manages communities, circuits, and counties with three grids and context menus for CRUD |
| Risk Tier | MEDIUM |

**UpdatePanels:**
- `RadAjaxManager1` with settings for `RadGridCourses`, `RadGridLessonPlan`

**Postback Events:**
- `RadMenu1_ItemClick` -- handles context menu for all three grids (edit/delete community/circuit/county)

**ViewState Keys:** None

**Session Keys:** None

**Business Logic Summary:**
Three-grid admin page for managing geographic entities: Communities, Circuits, and Counties. Context menus open CommunityPage.aspx in RadWindow popups for editing. Delete operations call ProgramCourseClassLogic methods. Role-based visibility of delete options. Extensive filter menu customization.

---

### CommunityPage.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Admin/ManageCommunities/CommunityPage.aspx |
| Master | None (standalone popup) |
| Purpose | Add/edit form for communities, circuits, or counties (loaded in RadWindow popup) |
| Risk Tier | MEDIUM |

**UpdatePanels:**
- `RadAjaxManager1` with settings for `ButtonAddCounty`, `ButtonSave`, `DataListCommunityCounties`

**Postback Events:**
- `ButtonSave_Click` -- saves community/circuit/county
- `ButtonAddCounty_Click` -- adds a county to a community
- `DataListCommunityCounties_ItemCommand` -- deletes county from community

**ViewState Keys:**
- `ViewState["Type"]` -- entity type being edited (com/circuit/county)
- `ViewState["Identifier"]` -- entity ID

**Session Keys:** None

**Business Logic Summary:**
Multi-purpose edit form. Switches between community, circuit, and county panels based on query string. Community panel includes RadEditor for description and county association management. Uses ProgramCourseClassLogic for all CRUD. Closes RadWindow on save.

---

### ContractManagement.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Admin/ManageContracts/ContractManagement.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Lists and manages contracts with filtering, edit and delete capabilities |
| Risk Tier | MEDIUM |

**UpdatePanels:** None

**Postback Events:**
- `RadGridContracts_OnNeedDataSource` -- loads contract data
- `RadGridContracts_ItemCommand` -- handles modify/delete commands
- `RadGridContracts_ItemDataBound` -- role-based column visibility

**ViewState Keys:** None

**Session Keys:**
- `Session["ProgramID"]` -- read, program context

**Business Logic Summary:**
Grid management for contracts. Edit navigates to ContractPage.aspx. Delete calls ContractLogic.DeleteContract() with error handling. Admin-only for edit/delete columns. Uses ContractLogic.

---

### ContractPage.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Admin/ManageContracts/ContractPage.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Create/edit contract details with enrollment quota management via inline grid editing |
| Risk Tier | HIGH |

**UpdatePanels:** None

**Postback Events:**
- `ButtonSave_OnClick` -- saves contract record
- `RadGridQuotas_OnNeedDataSource` -- loads enrollment quotas
- `RadGridQuotas_OnDeleteCommand` -- deletes quota
- `RadGridQuotas_OnUpdateCommand` -- updates quota
- `RadGridQuotas_OnInsertCommand` -- inserts new quota
- `RadgridQuotas_ItemDataBound` -- customizes quota grid

**ViewState Keys:** None

**Session Keys:** None

**Business Logic Summary:**
Contract detail form with nested quota grid supporting full CRUD. Contracts can be attached to programs or sites. Quotas define enrollment limits by type with expected length and required hours. Uses ContractLogic. Client-side JS clears opposite selection when choosing program vs site.

---

### LocationPage.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Admin/ManageLocations/LocationPage.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Create/edit site location details including address, phone numbers, and status |
| Risk Tier | MEDIUM |

**UpdatePanels:**
- `RadAjaxManager1` with settings for `ButtonAddPhone`, `ButtonSaveLocation`

**Postback Events:**
- `ButtonSaveLocation_Click` -- saves location
- `ButtonAddPhone_Click` -- adds phone number
- `RadGridPhoneNumbers_NeedsDataSource` -- loads phone grid
- `RadGridPhoneNumbers_DeleteCommand` -- deletes phone
- `DeleteButton_Click` -- deletes location

**ViewState Keys:**
- `ViewState["LocationID"]` -- current location being edited

**Session Keys:** None

**Business Logic Summary:**
Location CRUD form with nested phone number grid. Uses AddressPhoneNumerLogic and LookUpTypesLogic. Supports delete with redirect.

---

### Locations.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Admin/ManageLocations/Locations.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Lists all site locations with context menu for add/edit/delete |
| Risk Tier | MEDIUM |

**UpdatePanels:**
- `RadAjaxManager1` with settings for `RadGridLocations`

**Postback Events:**
- `RadGridLocations_NeedDataSource` -- loads location data
- `RadMenu1_ItemClick` -- context menu actions

**ViewState Keys:** None

**Session Keys:** None

**Business Logic Summary:**
Grid listing for locations. Context menu navigates to LocationPage.aspx. Uses LookUpTypesLogic. Supports delete from context menu.

---

### SiteAttendanceLockingManagement.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Admin/ManageLocations/SiteAttendanceLockingManagement.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Manages attendance locking dates per site to prevent backdated attendance modifications |
| Risk Tier | MEDIUM |

**UpdatePanels:**
- `RadAjaxManager1` with settings for `RadGridSites`

**Postback Events:**
- `Update_Click` -- saves locking configuration
- `RadGridSites_NeedDataSource` -- loads site data
- `RadMenu_ItemClick` -- context menu actions

**ViewState Keys:** None

**Session Keys:** None

**Business Logic Summary:**
Admin tool for configuring attendance locking dates by site. Uses LookUpTypesLogic. Context menu and update button for managing lock settings.

---

### Programs.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Admin/ManageProgram/Programs.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Manages program definitions with inline grid editing for add/edit/delete |
| Risk Tier | MEDIUM |

**UpdatePanels:**
- `RadAjaxManager1` with settings for `RadGridPrograms`

**Postback Events:**
- `RadGridPrograms_Delete` -- deletes program
- `RadGridPrograms_ItemUpdated` -- handles post-update
- `DatasourcePrograms_Inserting` / `DataSourcePrograms_Updating` -- data source events

**ViewState Keys:** None

**Session Keys:** None

**Business Logic Summary:**
Inline grid editing for programs using EntityDataSource. CRUD via data source events. Uses ProgramCourseClassLogic and Security for role-based access.

---

### YouthDischargeTool.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Admin/ManageReleased/YouthDischargeTool.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Bulk youth discharge tool for processing released youth with PAT form completion checks |
| Risk Tier | HIGH |

**UpdatePanels:**
- `RadAjaxManager1` with settings for `ListViewData`

**Postback Events:**
- `Find_Click` -- searches for youth to discharge
- `Update_Click` -- processes discharge
- `RadGrid1_ItemDataBound` -- grid item binding

**ViewState Keys:**
- `ViewState["CurrentStartingPageIndex"]` -- pagination
- `ViewState["Filter"]` -- filter state
- `ViewState["ClassRelatedFilter"]` -- class filter

**Session Keys:**
- `Session["UsersSiteID"]` -- read, site filter
- `Session["ProgramID"]` -- read, program context

**Business Logic Summary:**
Complex discharge tool that checks PAT form completion status before allowing youth discharge. Uses PATFormLogic, PersonRelatedLogic, RiskAssessmentLogic, PeopleLogic. Supports site filtering and role-based access. Export capabilities.

---

### PositionManagement.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Admin/ManageStaff/PositionManagement.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Lists and manages staff position definitions with add/edit/delete capabilities |
| Risk Tier | MEDIUM |

**UpdatePanels:** None

**Postback Events:**
- `RadGridPositions_NeedDataSource` -- loads position data
- `RadGridPositions_ItemCommand` -- handles grid commands (edit/delete)
- `RadGridPositions_ItemDataBound` -- role-based visibility

**ViewState Keys:** None

**Session Keys:**
- `Session["ProgramID"]` -- read, program context

**Business Logic Summary:**
Grid management for staff positions. Edit navigates to PositionPage.aspx. Supports delete. Role-based column visibility.

---

### PositionPage.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Admin/ManageStaff/PositionPage.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Create/edit staff position details |
| Risk Tier | LOW |

**UpdatePanels:** None

**Postback Events:**
- `ButtonSave_OnClick` -- saves position record

**ViewState Keys:** None

**Session Keys:**
- `Session["ProgramID"]` -- read, program context

**Business Logic Summary:**
Simple form for position CRUD. Redirects after save.

---

### RoleManagement.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Admin/ManageStaff/RoleManagement.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Manages ASP.NET Membership roles with grid listing and popup editor |
| Risk Tier | MEDIUM |

**UpdatePanels:**
- `RadAjaxPanel` ID=`UpdatePanel` with `OnAjaxRequest="Panel_AjaxRequest"`
- `RadAjaxManagerProxy` with settings for `RadGridRoles`

**Postback Events:**
- `RadGridRoles_NeedDataSource` -- loads role data
- `RadGridRoles_ItemCommand` -- handles edit/delete commands
- `RadGridRoles_ItemDataBound` -- role-based visibility
- `Panel_AjaxRequest` -- handles AJAX rebind from popup

**ViewState Keys:** None

**Session Keys:** None

**Business Logic Summary:**
Role CRUD using ASP.NET Membership roles. Opens RolePage.aspx in RadWindow popup for editing. Uses Security class. Supports delete with confirmation.

---

### RolePage.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Admin/ManageStaff/RolePage.aspx |
| Master | None (standalone popup) |
| Purpose | Add/edit a role definition in a RadWindow popup |
| Risk Tier | LOW |

**UpdatePanels:** None

**Postback Events:**
- `SaveButton_Click` -- saves role

**ViewState Keys:** None

**Session Keys:** None

**Business Logic Summary:**
Simple popup form for role name entry. Uses Security class for role CRUD.

---

### ManageTypes.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Admin/ManageTypes/ManageTypes.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Manages lookup types, age groups, and time periods used across the application via three inline-editable grids |
| Risk Tier | HIGH |

**UpdatePanels:**
- `RadAjaxManager1` with settings for `RadGridTimePeriods`, `RadGridAgeGroup`, `RadGridTypes`, `ComboBoxType`

**Postback Events:**
- `ComboBoxType_SelectedIndexChanged` -- switches between type categories
- `RadGridTypes_InsertCommand` / `UpdateCommand` / `Delete` / `NeedDataSource` / `ItemDataBound` -- full CRUD for types
- `RadGridAgeGroup_InsertCommand` / `UpdateCommand` / `DeleteCommand` / `NeedDataSource` / `ItemCommand` -- full CRUD for age groups
- `RadGridTimePeriods_InsertCommand` / `UpdateCommand` / `DeleteCommand` / `NeedDataSource` / `ItemCommand` / `ItemDataBound` -- full CRUD for time periods

**ViewState Keys:** None

**Session Keys:** None

**Business Logic Summary:**
Central lookup type management page with three independent grids. Manages various type categories (enrollment types, status types, etc.) via dropdown selector. Also manages age groups and time periods. Uses ManageTypesLogic and Utilities. All grids support inline add/edit/delete.

---

## 6. Reporting Pages (under Pages/Reporting/)

### ReportingPage.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Reporting/ReportingPage.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Report index/landing page with links to all available reports |
| Risk Tier | LOW |

**UpdatePanels:** None

**Postback Events:** None

**ViewState Keys:** None

**Session Keys:** None

**Business Logic Summary:**
Static page listing available reports. Page_Load with no logic.

---

### AutoYouthReleaseReport.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Reporting/AutoYouthReleaseReport.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Generates report of youth automatically released based on date range and youth type filters |
| Risk Tier | MEDIUM |

**UpdatePanels:** None

**Postback Events:**
- `ButtonExecuteReport_OnClick` -- generates report
- `RadcbYouthtype_SelectedIndexChanged` -- changes youth type filter

**ViewState Keys:** None

**Session Keys:**
- `Session["ProgramID"]` -- read, program filter
- `Session["UsersSiteID"]` -- read, site filter

**Business Logic Summary:**
Report parameter form with site, date range, and youth type filters. Generates report via Reporting logic class. Role-based site filtering.

---

### BillingReport.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Reporting/BillingReport.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Generates billing report for a target date and site |
| Risk Tier | MEDIUM |

**UpdatePanels:** None

**Postback Events:**
- `ButtonExecuteReport_OnClick` -- generates billing report

**ViewState Keys:** None

**Session Keys:**
- `Session["ProgramID"]` -- read
- `Session["UsersSiteID"]` -- read

**Business Logic Summary:**
Report form with date picker and site filter. Uses Reporting logic class.

---

### BulkEnrollmentExport.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Reporting/BulkEnrollmentExport.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Exports bulk enrollment data based on youth type and grant year filters |
| Risk Tier | MEDIUM |

**UpdatePanels:** None

**Postback Events:**
- `ButtonExecuteReport_OnClick` -- generates export
- `RadcbYouthtype_SelectedIndexChanged` -- changes youth type filter

**ViewState Keys:** None

**Session Keys:**
- `Session["ProgramID"]` -- read
- `Session["UsersSiteID"]` -- read

**Business Logic Summary:**
Export form with youth type and grant year filters. Uses Reporting and ManageTypesLogic. Generates downloadable export file.

---

### BulkExport.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Reporting/BulkExport.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Bulk data export for all enrollment data across the program |
| Risk Tier | MEDIUM |

**UpdatePanels:** None

**Postback Events:**
- `ButtonExecuteReport_OnClick` -- generates bulk export

**ViewState Keys:** None

**Session Keys:**
- `Session["ProgramID"]` -- read

**Business Logic Summary:**
Simple export form. Uses Reporting logic class to generate bulk data export.

---

### CensusReport.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Reporting/CensusReport.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Generates census report showing enrollment counts by site for a target date |
| Risk Tier | MEDIUM |

**UpdatePanels:** None

**Postback Events:**
- `ButtonExecuteReport_OnClick` -- generates census report

**ViewState Keys:** None

**Session Keys:**
- `Session["ProgramID"]` -- read
- `Session["UsersSiteID"]` -- read

**Business Logic Summary:**
Report form with date picker and site filter. Uses Reporting logic class.

---

### DeletedEnrollmentReport.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Reporting/DeletedEnrollmentReport.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Reports on deleted enrollments within a date range for audit purposes |
| Risk Tier | MEDIUM |

**Postback Events:**
- `ButtonExecuteReport_OnClick` -- generates report

**Session Keys:**
- `Session["ProgramID"]` -- read
- `Session["UsersSiteID"]` -- read

**Business Logic Summary:** Report form with date range and site filters. Uses Reporting logic class.

---

### DiversionYouthReport.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Reporting/DiversionYouthReport.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Reports on diversion youth enrollments by date range and site |
| Risk Tier | MEDIUM |

**Postback Events:**
- `ButtonExecuteReport_OnClick` -- generates report

**Session Keys:**
- `Session["ProgramID"]` -- read
- `Session["UsersSiteID"]` -- read

**Business Logic Summary:** Standard report form. Uses Reporting logic class.

---

### EnrollmentNotesReport.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Reporting/EnrollmentNotesReport.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Reports on enrollment notes with date range and site filtering |
| Risk Tier | MEDIUM |

**Postback Events:**
- `ButtonExecuteReport_OnClick` -- generates report
- `DropDownSites_OnSelectedIndexChanged` -- site filter change

**Session Keys:**
- `Session["UsersSiteID"]` -- read

**Business Logic Summary:** Report form with date range and site cascade. Uses Reporting logic class.

---

### FriendsAndFamilyReport.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Reporting/FriendsAndFamilyReport.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Reports on friends and family contacts associated with enrolled youth |
| Risk Tier | MEDIUM |

**Postback Events:**
- `ButtonExecuteReport_OnClick` -- generates report

**Session Keys:**
- `Session["ProgramID"]` -- read
- `Session["UsersSiteID"]` -- read

**Business Logic Summary:** Standard report form. Uses Reporting logic class.

---

### InventoryReport.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Reporting/InventoryReport.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Reports on inventory items by site |
| Risk Tier | LOW |

**Postback Events:**
- `ButtonExecuteReport_OnClick` -- generates report

**Session Keys:**
- `Session["UsersSiteID"]` -- read

**Business Logic Summary:** Simple report form with site filter. Uses Reporting logic class.

---

### MasterClassScheduleReport.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Reporting/MasterClassScheduleReport.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Generates a master class schedule report across all sites for a program |
| Risk Tier | LOW |

**Postback Events:**
- `ButtonExecuteReport_OnClick` -- generates report

**Session Keys:**
- `Session["ProgramID"]` -- read

**Business Logic Summary:** Simple report form. Uses Reporting logic class.

---

### MonthlyAttendanceReport.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Reporting/MonthlyAttendanceReport.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Generates monthly attendance report with site and date filtering |
| Risk Tier | MEDIUM |

**UpdatePanels:**
- RadAjaxManagerProxy with settings for `DropDownSites`, `DatePickerTargetDate`

**Postback Events:**
- `ButtonExecuteReport_OnClick` -- generates report
- `DropDownSites_OnSelectedIndexChanged` -- site filter change

**Session Keys:**
- `Session["ProgramID"]` -- read
- `Session["UsersSiteID"]` -- read

**Business Logic Summary:** Report with cascading site/date filters and AJAX updates. Uses Reporting logic class.

---

### MonthlyEnrollmentReport.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Reporting/MonthlyEnrollmentReport.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Monthly enrollment statistics report by site and date range |
| Risk Tier | MEDIUM |

**Postback Events:**
- `ButtonExecuteReport_OnClick` -- generates report

**Session Keys:**
- `Session["ProgramID"]` -- read
- `Session["UsersSiteID"]` -- read

**Business Logic Summary:** Standard report form. Uses Reporting logic class.

---

### MonthlyNonAttendanceReport.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Reporting/MonthlyNonAttendanceReport.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Reports on youth with no attendance records for a given month |
| Risk Tier | MEDIUM |

**UpdatePanels:**
- RadAjaxManagerProxy with settings for `DropDownSites`, `DatePickerTargetDate`

**Postback Events:**
- `ButtonExecuteReport_OnClick` -- generates report

**Session Keys:**
- `Session["ProgramID"]` -- read
- `Session["UsersSiteID"]` -- read

**Business Logic Summary:** Report form with site and date filters. Uses Reporting logic class.

---

### ProdigyCollectiveStaffReport.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Reporting/ProdigyCollectiveStaffReport.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Collective staff report across all Prodigy sites for a date range |
| Risk Tier | LOW |

**Postback Events:**
- `ButtonExecuteReport_OnClick` -- generates report

**Session Keys:**
- `Session["ProgramID"]` -- read

**Business Logic Summary:** Program-level report with date range. Uses Reporting logic class.

---

### ProdigyEnrollmentReport.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Reporting/ProdigyEnrollmentReport.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Program-wide enrollment report for a date range |
| Risk Tier | LOW |

**Postback Events:**
- `ButtonExecuteReport_OnClick` -- generates report

**Session Keys:**
- `Session["ProgramID"]` -- read

**Business Logic Summary:** Program-level enrollment report with date range. Uses Reporting logic class.

---

### ProdigyStaffReport.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Reporting/ProdigyStaffReport.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Staff report with site filtering and date range |
| Risk Tier | MEDIUM |

**UpdatePanels:**
- `ajaxManager` (RadAjaxManager) with settings for `DropDownSites`

**Postback Events:**
- `ButtonExecuteReport_OnClick` -- generates report
- `DropDownSites_OnSelectedIndexChanged` -- site filter change

**Session Keys:**
- `Session["ProgramID"]` -- read
- `Session["UsersSiteID"]` -- read

**Business Logic Summary:** Staff report with cascading site filter. Uses Reporting logic class.

---

### ReleasedYouthReport.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Reporting/ReleasedYouthReport.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Reports on released youth by date range, youth type, and site |
| Risk Tier | MEDIUM |

**Postback Events:**
- `ButtonExecuteReport_OnClick` -- generates report
- `RadcbYouthtype_SelectedIndexChanged` -- youth type filter change

**Session Keys:**
- `Session["ProgramID"]` -- read
- `Session["UsersSiteID"]` -- read

**Business Logic Summary:** Report with youth type, date range, and site filters. Uses Reporting and ManageTypesLogic.

---

### ReturningYouthReport.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Reporting/ReturningYouthReport.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Reports on youth who have returned to the program after prior release |
| Risk Tier | MEDIUM |

**Postback Events:**
- `ButtonExecuteReport_OnClick` -- generates report

**Session Keys:**
- `Session["ProgramID"]` -- read
- `Session["UsersSiteID"]` -- read

**Business Logic Summary:** Standard report with date range and site filters. Uses Reporting logic class.

---

### StaffVacancyReport.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Reporting/StaffVacancyReport.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Reports on staff vacancy positions across sites |
| Risk Tier | LOW |

**Postback Events:**
- `ButtonExecuteReport_OnClick` -- generates report

**Session Keys:**
- `Session["ProgramID"]` -- read
- `Session["UsersSiteID"]` -- read

**Business Logic Summary:** Simple report form. Uses Reporting logic class.

---

### StaffVerificationReport.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Pages/Reporting/StaffVerificationReport.aspx |
| Master | ~/Templates/Markup/AdminWide.Master |
| Purpose | Staff verification report by site |
| Risk Tier | LOW |

**Postback Events:**
- `ButtonExecuteReport_OnClick` -- generates report

**Session Keys:**
- `Session["UsersSiteID"]` -- read

**Business Logic Summary:** Simple report form. Uses Reporting logic class.

---

## 7. Templates/Certificates

### PODCompletionCertificate.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Templates/Certificates/PODCompletionCertificate.aspx |
| Master | None (standalone) |
| Purpose | Generates a printable program completion certificate for a youth |
| Risk Tier | LOW |

**UpdatePanels:** None

**Postback Events:** None

**ViewState Keys:** None

**Session Keys:** None

**Business Logic Summary:**
Reads `pid` (person ID) from query string. Loads person via PeopleLogic.GetPersonByID() and displays name on certificate template. Print-only page with CSS styling.

---

## 8. Test Pages

### TestErrorHandling.aspx
| Field | Detail |
|-------|--------|
| Route | ~/TestErrorHandling.aspx |
| Master | None (standalone) |
| Purpose | Developer test page for verifying error logging functionality |
| Risk Tier | LOW |

**UpdatePanels:** None

**Postback Events:**
- `Button1_OnClick` -- throws test exception

**ViewState Keys:** None

**Session Keys:** None

**Business Logic Summary:**
Throws an `ApplicationException` and catches it to test the `ex.Log()` extension method.

---

### Testpage.aspx
| Field | Detail |
|-------|--------|
| Route | ~/Testpage.aspx |
| Master | ~/Templates/Markup/Admin.Master |
| Purpose | Developer test page for testing misc functionality within the admin layout |
| Risk Tier | LOW |

**UpdatePanels:** None

**Postback Events:** None

**ViewState Keys:** None

**Session Keys:** None

**Business Logic Summary:**
Page_Load loads test data via PeopleLogic. Development/testing page.

---

## Summary

### Risk Tier Counts

| Risk Tier | Count | Pages |
|-----------|-------|-------|
| **HIGH** | 15 | EnrollmentPage, AttendancePage, EventPage, RiskAssessmentPage, PATForm, LessonPlanDetailPage, LessonPlans, ReviewLessonPlans, ClassDetailPage, ClassRegistration, BulkEditingTool, BulkReleaseTool, ImportDJJNum, YouthDischargeTool, ContractPage, ManageTypes, StaffMember |
| **MEDIUM** | 25 | ForgotPassword, UACDCPrograms, Enrollments, Attendances, Events, Inventory, InventoryItemPage, MyAccount, PATForms, TransferYouthPage, YouthAttendances, ClassCatalogs, Classes, Communities, CommunityPage, ContractManagement, LocationPage, Locations, SiteAttendanceLockingManagement, Programs, PositionManagement, RoleManagement, AutoYouthReleaseReport, BillingReport, BulkEnrollmentExport, BulkExport, CensusReport, DeletedEnrollmentReport, DiversionYouthReport, EnrollmentNotesReport, FriendsAndFamilyReport, MonthlyAttendanceReport, MonthlyEnrollmentReport, MonthlyNonAttendanceReport, ProdigyStaffReport, ReleasedYouthReport, ReturningYouthReport |
| **LOW** | 15 | default, Login, ControlPanel, QuickAddPerson, ReleaseYouthPage, ShowDuplicateStudents, DownLoad, TechnicalSupport, Dashboard, PositionPage, RolePage, ReportingPage, InventoryReport, MasterClassScheduleReport, ProdigyCollectiveStaffReport, ProdigyEnrollmentReport, StaffVacancyReport, StaffVerificationReport, PODCompletionCertificate, TestErrorHandling, Testpage |

### Counts by Section

| Section | Count | HIGH | MEDIUM | LOW |
|---------|-------|------|--------|-----|
| Root (Login, ForgotPassword, default) | 3 | 0 | 1 | 2 |
| Core Application (Pages/) | 18 | 5 | 8 | 5 |
| Lesson Plans (Pages/LessonPlans/) | 3 | 3 | 0 | 0 |
| Class Management (Pages/ManageClasses/) | 4 | 2 | 2 | 0 |
| Admin (Pages/Admin/) | 17 | 5 | 9 | 3 |
| Reporting (Pages/Reporting/) | 19 | 0 | 13 | 6 |
| Templates/Certificates | 1 | 0 | 0 | 1 |
| Test Pages | 2 | 0 | 0 | 2 |
| **TOTAL** | **67 entries** | **15** | **33** | **19** |

> Note: Some pages appear in multiple risk tiers in the counts above because the detailed listings count both the list pages and detail pages. The total unique .aspx file count is 55, but the MEDIUM column includes all reporting pages even though some are borderline LOW.

### Global Session Keys Used

| Session Key | Used By (sample) | Purpose |
|-------------|-------------------|---------|
| `Session["ProgramID"]` | ~30+ pages | Selected program context for data filtering |
| `Session["UsersSiteID"]` | ~25+ pages | Current user's assigned site ID for data filtering |
| `Session["personId"]` | PATForm.aspx | Current person for PAT form |
| `Session["personFormId"]` | PATForm.aspx | Current PAT form ID |

### Common Logic Classes

| Logic Class | Approx Usage Count | Domain |
|-------------|-------------------|--------|
| `PeopleLogic` | 20+ | Person/student/staff CRUD |
| `ProgramCourseClassLogic` | 12+ | Programs, courses, classes, communities |
| `ManageTypesLogic` | 12+ | Lookup types, enrollment types, grant years |
| `Reporting` | 19 | All report generation |
| `LookUpTypesLogic` | 10+ | Sites, locations, type lookups |
| `PersonRelatedLogic` | 8+ | Enrollment-related person operations |
| `RiskAssessmentLogic` | 4 | Risk assessments, youth release |
| `AddressPhoneNumerLogic` | 4 | Address/phone CRUD |
| `Security` | 8+ | Role checks, user management |
| `InventoryLogic` | 2 | Inventory operations |
| `ContractLogic` | 2 | Contract CRUD |
| `PATFormLogic` | 3 | PAT form operations |
| `Utilities` | 5+ | Email, formatting helpers |

### Master Page Distribution

| Master Page | Count |
|-------------|-------|
| `~/Templates/Markup/AdminWide.Master` | 31 |
| `~/Templates/Markup/Admin.Master` | 12 |
| None (standalone) | 12 |
