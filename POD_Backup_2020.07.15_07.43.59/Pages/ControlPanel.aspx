<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ControlPanel.aspx.cs" MasterPageFile="~/Templates/Markup/AdminWide.Master" Inherits="POD.Pages.ControlPanel" %>

<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
<asp:Panel ID="PanelDashboard" runat="server" >
        <ul>
            <li></li>
            <li></li>
            <li></li>
        </ul>
    </asp:Panel>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <div class="myControlPanelConstraint">
    <div class="enrollmentpanel panel">
        <div class="enrollmentpanelhead panelhead">
            <h2>Youth</h2>
        </div>
        <div class="panelcontent">
            <div class="panelicon"><img src="../Templates/Images/enrollmentIcon.png" alt="youth Icon" /></div>
            <p>Prodigy serves at risk youth ages 7-17 in the categories of prevention, intervention and diversion.  Confidential information for each youth participating in Prodigy is maintained via a database in POD. This information is used to track youth assessments, admission into and/or release from the program. Access this section to:</p>
            <ul>
                <li>Enroll youth</li>
                <li>View youth by category</li>
                <li>Create, edit and view risk assessments</li>
                <li>Search for pre-enrolled and enrolled youth</li>
                <li>View youth records</li>
                <li>Make youth inactive</li>
            </ul>
            <auth:SecureContent ID="SecureContent1" ToggleVisible="true" ToggleEnabled="false"
        EventHook="Load" runat="server" Roles="Administrators;Administrators-NA;CentralTeamUsers;SiteTeamUsers;SiteTeamUsers-NA;">
            <asp:Button ID="GoEnrollment" runat="server" Text="GO >" CssClass="mybutton mygobutton" PostBackUrl="~/Pages/Enrollments.aspx" />
            </auth:SecureContent>
        </div>
    </div>
            
    <div class="attendancepanel panel">
        <div class="attendancepanelhead panelhead">
            <h2>Attendance</h2>
        </div>
        <div class="panelcontent">
            <div class="panelicon"><img src="../Templates/Images/attendanceIcon.png" alt="Attendance Icon" /></div>
            <p>Attendance at Prodigy classes is essential for the success of the youth in the program. From one class to another, Prodigy youth learn various art techniques via lesson plans that are infused with life skills to  help them  cope with their day-to-day life experiences.  Each class is prepared with an outcome in mind. </p>
            <p>Attendance to Prodigy is primarily recorded to provide a tracked record of youth who attend the program in order to successfully complete a set of hours mandated by the juvenile system. Attendance  is also recorded to enable  Prodigy Central to evaluate class performance and improve classroom quality. Access this section for the following:</p>
            <ul>
                <li>Enter attendance</li>
                <li>Search for classes by site, location, and dates</li>
                <li>View attendance by class</li>
            </ul>
              <auth:SecureContent ID="SecureContent2" ToggleVisible="true" ToggleEnabled="false"
        EventHook="Load" runat="server" Roles="Administrators;Administrators-NA;CentralTeamUsers;SiteTeamUsers;SiteTeamUsers-NA;">
            <asp:Button ID="GoAttendance" runat="server" Text="GO >" CssClass="mybutton mygobutton" PostBackUrl="~/Pages/Attendances.aspx" />
           </auth:SecureContent>
        </div>
    </div>
            
    <div class="reportingpanel sidepanel">
        <div class="reportingpanelhead sidepanelhead">
        <h2>Reporting</h2>
        </div>
        <div class="panelcontent">
        <div class="panelicon"><img src="../Templates/Images/reportingIcon.png" alt="Reporting Icon" /></div>
        <p>As a Provider of the Prodigy Program for the Department of Juvenile Justice (DJJ), the University Area Community Development Corporation, Inc. (UACDC) must report all youth enrollment, attendance, staff and inventory information. There are monthly, quarterly and annually reporting requirements  which have  set guidelines and procedures for compliance  in order to prepare programmatic information for  reporting  to DJJ in a timely manner. For that reason, this section provides you with access to reports related to youth enrollment, class attendance, youth released from the program for each  category of youth, as well as  inventory/property reports and more.. </p>
        <ul>
            <auth:SecureContent ToggleVisible="True" ToggleEnabled="False" EventHook="Load" runat="server" Roles="Administrators,Administrators-NA,CentralTeamUsers,SiteTeamUsers,SiteTeamUsers-NA">
                <li><a href="Reporting/CensusReport.aspx" title="Census Report"><span>Census Report</span></a></li>
                <li><a href="Reporting/MonthlyAttendanceReport.aspx" title="Monthly Attendance Report"><span>Monthly Attendance Report</span></a></li>
                <li><a href="Reporting/MonthlyEnrollmentReport.aspx" title="Monthly Enrollment Report"><span>Monthly Enrollment Report</span></a></li>
                <li><a href="Reporting/MasterClassScheduleReport.aspx" title="Master Class Schedule Report"><span>Master Class Schedule Report</span></a></li>
            </auth:SecureContent>
            <auth:SecureContent ToggleVisible="True" ToggleEnabled="False" EventHook="Load" runat="server" Roles="Administrators,Administrators-NA,CentralTeamUsers,SiteTeamUsers">
                <li><a href="Reporting/ReleasedYouthReport.aspx" title="Released Youth Report"><span>Released Youth Report</span></a></li>
<%--                <li><a href="Reporting/ProdigyEnrollmentReport.aspx" title="Prodigy Enrollment Report"><span>Performance Enrollment Report</span></a></li>--%>
                <li><a href="Reporting/DiversionYouthReport.aspx" title="Diversion Youth Report"><span>Diversion Youth Report</span></a></li>
                <li><a href="Reporting/StaffVacancyReport.aspx" title="Staff Vacancy Report"><span>Staff Vacancy Report</span></a></li>
                <li><a href="Reporting/StaffVerificationReport.aspx" title="Staff Verification Report"><span>Staff Verification Report</span></a></li>
<%--                <li><a href="Reporting/ReturningYouthReport.aspx" title="Returning Youth Report"><span>Returning Youth Report</span></a></li>--%>
                <li><a href="Reporting/FriendsAndFamilyReport.aspx" title="Friends and Family Report"><span>Friends and Family Report</span></a></li>
                <li><a href="Reporting/MonthlyNonAttendanceReport.aspx" title="Monthly Non-Attendance Report"><span>Monthly Non-Attendance Report</span></a></li>
                <li><a href="Reporting/ProdigyStaffReport.aspx" title="Prodigy Staff Report"><span>Prodigy Staff Report</span></a></li>
            </auth:SecureContent>
            <auth:SecureContent ToggleVisible="True" ToggleEnabled="False" EventHook="Load" runat="server" Roles="Administrators,Administrators-NA,CentralTeamUsers,CentralTeamUsers-NA,SiteTeamUsers">
                <li><a href="Reporting/InventoryReport.aspx" title="Inventory Report"><span>Inventory Report</span></a></li>
            </auth:SecureContent>
            <auth:SecureContent ToggleVisible="True" ToggleEnabled="False" EventHook="Load" runat="server" Roles="Administrators,Administrators-NA,CentralTeamUsers">
                <li><a href="Reporting/BulkExport.aspx" title="Bulk Data Export"><span>Bulk Data Export</span></a></li>
                <li><a href="Reporting/ProdigyCollectiveStaffReport.aspx" title="Prodigy Collective Staff Report"><span>Prodigy Collective Staff Report</span></a></li>
            </auth:SecureContent>
        </ul>
    </div>
    </div>
            
    <div class="coursespanel panel">
        <div class="coursespanelhead panelhead">
            <h2>Classes</h2>
        </div>
        <div class="panelcontent">
            <div class="panelicon"><img src="../Templates/Images/coursesIcon.png" alt="Classes Icon" /></div>
            <p>The many different types of Prodigy classes  vary by site and respective locations.  Access this section to create a class, search for existing classes by date and instructor, update class schedules, view class catalog, and more…</p>
             <auth:SecureContent ID="SecureContent3" ToggleVisible="true" ToggleEnabled="false"
        EventHook="Load" runat="server" Roles="Administrators;Administrators-NA;CentralTeamUsers;SiteTeamUsers;SiteTeamUsers-NA;">
            <asp:Button ID="GoCourses" runat="server" Text="GO >" CssClass="mybutton mygobutton" PostBackUrl="~/Pages/ManageClasses/Classes.aspx" />
            </auth:SecureContent>
        </div>
    </div>
            
    <div class="eventspanel panel">
        <div class="eventspanelhead panelhead">
            <h2>Events</h2>
        </div>
        <div class="panelcontent">
            <div class="panelicon"><img src="../Templates/Images/eventsIcon.png" alt="Events Icon" /></div>
            <p>One of the successful components of  Prodigy is to hold  program events to attract potential youth that can benefit from the diverse art disciplines the program has to offer. Youth and their families often participate by attending events and receiving information about other resources from which they can benefit. Often times, Prodigy youth along with their artistic instructors conduct performances at these events and gain exposure to, or display their talent through their  performance or the showcasing of their art .  By accessing this section you can do the following:</p>
            <ul>
                <li>Record or delete events</li>
                <li>Search for events</li>
                <li>View events by location or type</li>
                <li>View event attendance</li>
            </ul>
              <auth:SecureContent ID="SecureContent4" ToggleVisible="true" ToggleEnabled="false"
        EventHook="Load" runat="server" Roles="Administrators;Administrators-NA;CentralTeamUsers;SiteTeamUsers;">
            <asp:Button ID="GoEvents" runat="server" Text="GO >" CssClass="mybutton mygobutton" PostBackUrl="~/Pages/Events.aspx"/>
            </auth:SecureContent>
        </div>
        </div>
        </div>
</asp:Content>