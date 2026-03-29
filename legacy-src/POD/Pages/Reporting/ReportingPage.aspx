<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master" AutoEventWireup="true" CodeBehind="ReportingPage.aspx.cs" Inherits="POD.Pages.Reporting.ReportingPage" %>

<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
<div class="">
    <div class="">
        <auth:SecureContent ToggleVisible="True" ToggleEnabled="False" EventHook="Load" runat="server" Roles="Administrators,Administrators-NA,CentralTeamUsers,SiteTeamUsers,SiteTeamUsers-NA">
        <div class="ReportWrapperCell">
            <div class="ReportWrapper">
                <div class="ProgramName">
                    <h2>Census Report</h2>
                </div>
                <div class="">
                    <p>DJJ required report which is based on attendance. It contains youth per category who attended class at least one time in a given month. It displays the youth name, start date, and stipulates  if the youth  is a  new enrollee or have simply continued attendance.  This report is submitted monthly to DJJ.</p>
                    <asp:Button ID="ButtonGo" runat="server" Text="GO >"  CssClass="mybutton mygobutton" PostBackUrl="~/Pages/Reporting/CensusReport.aspx" />
                </div>
            </div>
        </div>
        <div class="ReportWrapperCell">
            <div class="ReportWrapper">
                <div class="ProgramName">
                    <h2>Monthly Attendance Report</h2>
                </div>
                <div class="">
                    <p>Monthly attendance by site and class times is  displayed on this report which contains names and identification number for all youth in attendance.  It displays dates on calendar table format of all attendees for Prodigy Central and sites to review.</p>
                    <asp:Button ID="Button1" runat="server" Text="GO >" CssClass="mybutton mygobutton" PostBackUrl="~/Pages/Reporting/MonthlyAttendanceReport.aspx" />
                </div>
            </div>
        </div>
        <div class="ReportWrapperCell RightReportWrapperCell">
            <div class="ReportWrapper">
                <div class="ProgramName">
                    <h2>Monthly Enrollment Report</h2>
                </div>
                <div class="">
                    <p>The Monthly Enrollment Report is based on youth enrolled in Prodigy during the selected month.</p>
                    <asp:Button ID="Button2" runat="server" Text="GO >" CssClass="mybutton mygobutton" PostBackUrl="~/Pages/Reporting/MonthlyEnrollmentReport.aspx" />
                </div>
            </div>
        </div>
        <div class="ReportWrapperCell">
            <div class="ReportWrapper">
                <div class="ProgramName">
                    <h2>Master Class Schedule Report</h2>
                </div>
                <div class="">
                    <p>The purpose for the Master Class Report is to display a class schedule as it exists for any given Prodigy Site and Location. </p>
                    <asp:Button ID="Button6" runat="server" Text="GO >" CssClass="mybutton mygobutton" PostBackUrl="~/Pages/Reporting/MasterClassScheduleReport.aspx" />
                </div>
            </div>
        </div>
        </auth:SecureContent>
        <auth:SecureContent ToggleVisible="True" ToggleEnabled="False" EventHook="Load" runat="server" Roles="Administrators,Administrators-NA,CentralTeamUsers,SiteTeamUsers">
        <div class="ReportWrapperCell">
            <div class="ReportWrapper">
                <div class="ProgramName">
                    <h2>Released Youth Report</h2>
                </div>
                <div class="">
                    <p>The Released Youth Report contains release information of youth who were released by date range selected.  This process provides  Prodigy Central staff with information necessary to release prevention youth in DJJ’s system.</p>
                    <asp:Button ID="Button3" runat="server" Text="GO >" CssClass="mybutton mygobutton" PostBackUrl="~/Pages/Reporting/ReleasedYouthReport.aspx" />
                </div>
            </div>
        </div>

        <div class="ReportWrapperCell RightReportWrapperCell">
            <div class="ReportWrapper">
                <div class="ProgramName">
                    <h2>Monthly Non-Attendance Report</h2>
                </div>
                <div class="">
                    <p>The Monthly Non-Attendance Report contains a list of youth who have been absent for a minimum of 15 days.  It includes youth and family contact information useful for Prodigy Sites to follow up on.</p>
                    <asp:Button ID="Button15" runat="server" Text="GO >" CssClass="mybutton mygobutton" PostBackUrl="~/Pages/Reporting/MonthlyNonAttendanceReport.aspx" />
                </div>
            </div>
        </div>


        <div class="ReportWrapperCell">
            <div class="ReportWrapper">
                <div class="ProgramName">
                    <h2>Diversion Youth Report</h2>
                </div>
                <div class="">
                    <p>This report displays diversion youth pending completion as well as those who complete diversion program requirements. Access to this report allows important communication between Bay Area Youth Services (BAYS) and Prodigy site staff regarding diversion youth and their progress toward completion of the program.</p>
                    <asp:Button ID="Button7" runat="server" Text="GO >" CssClass="mybutton mygobutton" PostBackUrl="~/Pages/Reporting/DiversionYouthReport.aspx" />
                </div>
            </div>
        </div>
        <div class="ReportWrapperCell">
            <div class="ReportWrapper">
                <div class="ProgramName">
                    <h2>Staff Vacancy Report</h2>
                </div>
                <div class="">
                    <p>The Staff Vacancy Report displays vacancies as they occur in a given month.  It contains the circuit number where the staff was last employed, along with name, job title, and employment related dates for reported vacancies. This report is submitted monthly to DJJ.</p>
                    <asp:Button ID="Button8" runat="server" Text="GO >" CssClass="mybutton mygobutton" PostBackUrl="~/Pages/Reporting/StaffVacancyReport.aspx" />
                </div>
            </div>
        </div>
        <div class="ReportWrapperCell RightReportWrapperCell">
            <div class="ReportWrapper">
                <div class="ProgramName">
                    <h2>Staff Verification Report</h2>
                </div>
                <div class="">
                    <p>The Staff Verification Report contains staff information used by Prodigy Central and Sites to verify employment status.  Although the information contained in this report is used to verify active or inactive staff, it is not submitted as is to DJJ. This internal report is used by Prodigy Central staff to update DJJ’s Staff Verification Report System. </p>
                    <asp:Button ID="Button9" runat="server" Text="GO >" CssClass="mybutton mygobutton" PostBackUrl="~/Pages/Reporting/StaffVerificationReport.aspx" />
                </div>
            </div>
        </div>
<%--        <div class="ReportWrapperCell">
            <div class="ReportWrapper">
                <div class="ProgramName">
                    <h2>Returning Youth Report</h2>
                </div>
                <div class="">
                    <p>The Returning Youth Report serves as a tool for Prodigy Central to properly record youth who return to Prodigy after being absent for 90 days or more in DJJ’s system, without duplicating their count within a grant year. This report is for internal use by Prodigy Central and Site staff and it contains a list of youth names who return to Prodigy and the category in which they were enrolled previously.</p>
                    <asp:Button ID="Button10" runat="server" Text="GO >" CssClass="mybutton mygobutton" PostBackUrl="~/Pages/Reporting/ReturningYouthReport.aspx" />
                </div>
            </div>
        </div>--%>
        <div class="ReportWrapperCell">
            <div class="ReportWrapper">
                <div class="ProgramName">
                    <h2>Friends and Family Report</h2>
                </div>
                <div class="">
                    <p>This report contains activities and/or events in which the Prodigy youth are invited to attend or participate. At most of these events, the Prodigy youth demonstrate their talents or display their art. The Friends and Family Report reflects the number of youth, staff, friends and family in attendance at events.</p>
                    <asp:Button ID="Button11" runat="server" Text="GO >" CssClass="mybutton mygobutton" PostBackUrl="~/Pages/Reporting/FriendsAndFamilyReport.aspx" />
                </div>
            </div>
        </div>




        <div class="ReportWrapperCell">
            <div class="ReportWrapper">
                <div class="ProgramName">
                    <h2>Prodigy Staff Report</h2>
                </div>
                <div class="">
                    <p>The Prodigy Staff Report contains information about instructional staff at Prodigy Sites, and can be retrieved by Prodigy Central and Site Staff. This report displays a summary of classes, dates, hours, age groups by Prodigy Site, locations and date range. And, it can be utilized to determine class performance.</p>
                    <asp:Button ID="Button13" runat="server" Text="GO >" CssClass="mybutton mygobutton" PostBackUrl="~/Pages/Reporting/ProdigyStaffReport.aspx" />
                </div>
            </div>
        </div>
        </auth:SecureContent>


        <auth:SecureContent ID="SecureContent1" ToggleVisible="True" ToggleEnabled="False" EventHook="Load" runat="server" Roles="Administrators,Administrators-NA,CentralTeamUsers">
        <div class="ReportWrapperCell RightReportWrapperCell">
            <div class="ReportWrapper">
                <div class="ProgramName">
                    <h2>Prodigy Collective Staff Report</h2>
                </div>
                <div class="">
                    <p>The Prodigy Collective Staff Report serves as a tool for Prodigy Central staff to view attendance count for any given Prodigy Site at any given date. This report displays the Prodigy Site, location, age groups, and class types held during a selected date range. It can be used to compare site performance by class for any given date.</p>
                    <asp:Button ID="Button14" runat="server" Text="GO >" CssClass="mybutton mygobutton" PostBackUrl="~/Pages/Reporting/ProdigyCollectiveStaffReport.aspx" />
                </div>
            </div>
        </div>
        </auth:SecureContent>

        <auth:SecureContent ToggleVisible="True" ToggleEnabled="False" EventHook="Load" runat="server" Roles="Administrators,Administrators-NA,CentralTeamUsers,CentralTeamUsers-NA,SiteTeamUsers">
        <div class="ReportWrapperCell">
            <div class="ReportWrapper">
                <div class="ProgramName">
                    <h2>Inventory Report</h2>
                </div>
                <div class="">
                    <p>The Inventory Report is a running list of items provided  by Prodigy site staff, which in turn is  reported to DJJ monthly, quarterly and annually.  The list provides item description, tag numbers, physical location and more.</p>
                    <asp:Button ID="Button4" runat="server" Text="GO >" CssClass="mybutton mygobutton" PostBackUrl="~/Pages/Reporting/InventoryReport.aspx" />
                </div>
            </div>
        </div>
        </auth:SecureContent>
        <auth:SecureContent ToggleVisible="True" ToggleEnabled="False" EventHook="Load" runat="server" Roles="Administrators,Administrators-NA,CentralTeamUsers">
        <div class="ReportWrapperCell ">
            <div class="ReportWrapper">
                <div class="ProgramName">
                    <h2>Bulk Data Export</h2>
                </div>
                <div class="">
                    <p>This data export provides Prodigy Central administration with a selection of reports that can be exported for further analysis.  Available reports are: user logins, staff records, youth records, events, enrollments, and risk assessments among others, which can be retrieved by Prodigy Central administration at any time. These reports are standard and not usually submitted to DJJ in their existing format. However, they can be used as tools to respond to inquiries made by UACDC or DJJ staff.</p>
                    <asp:Button ID="Button12" runat="server" Text="GO >" CssClass="mybutton mygobutton" PostBackUrl="~/Pages/Reporting/BulkExport.aspx" />
                </div>
            </div>
        </div>
        </auth:SecureContent>

        <auth:SecureContent ID="SecureContent2" ToggleVisible="True" ToggleEnabled="False" EventHook="Load" runat="server" Roles="Administrators,Administrators-NA,CentralTeamUsers">
        <div class="ReportWrapperCell RightReportWrapperCell">
            <div class="ReportWrapper">
                <div class="ProgramName">
                    <h2>Enrollment Notes By Site Report</h2>
                </div>
                <div class="">
                    <p>The Prodigy Collective Staff Report serves as a tool for Prodigy Central staff to view attendance count for any given Prodigy Site at any given date. This report displays the Prodigy Site, location, age groups, and class types held during a selected date range. It can be used to compare site performance by class for any given date.</p>
                    <asp:Button ID="Button5" runat="server" Text="GO >" CssClass="mybutton mygobutton" PostBackUrl="~/Pages/Reporting/EnrollmentNotesReport.aspx" />
                </div>
            </div>
        </div>
        </auth:SecureContent>
        <auth:SecureContent ID="SecureContent3" ToggleVisible="True" ToggleEnabled="False" EventHook="Load" runat="server" Roles="Administrators,Administrators-NA,CentralTeamUsers">
        <div class="ReportWrapperCell">
            <div class="ReportWrapper">
                <div class="ProgramName">
                    <h2>Monthly Billing Report</h2>
                </div>
                <div class="">
                    <p>The Prodigy Billing Report serves as a tool for Prodigy Central staff ....</p>
                    <asp:Button ID="Button10" runat="server" Text="GO >" CssClass="mybutton mygobutton" PostBackUrl="~/Pages/Reporting/BillingReport.aspx" />
                </div>
            </div>
        </div>
        </auth:SecureContent>

        <auth:SecureContent ID="SecureContent4" ToggleVisible="True" ToggleEnabled="False" EventHook="Load" runat="server" Roles="Administrators,Administrators-NA,CentralTeamUsers">
        <div class="ReportWrapperCell ">
            <div class="ReportWrapper">
                <div class="ProgramName">
                    <h2>Bulk Enrollment Report</h2>
                </div>
                <div class="">
                    <p>This is the bulk enrollment.</p>
                    <asp:Button ID="Button16" runat="server" Text="GO >" CssClass="mybutton mygobutton" PostBackUrl="~/Pages/Reporting/BulkEnrollmentExport.aspx" />
                </div>
            </div>
        </div>
        </auth:SecureContent>

        <auth:SecureContent ID="SecureContent59" ToggleVisible="True" ToggleEnabled="False" EventHook="Load" runat="server" Roles="Administrators,Administrators-NA,CentralTeamUsers">
        <div class="ReportWrapperCell RightReportWrapperCell">
            <div class="ReportWrapper">
                <div class="ProgramName">
                    <h2>Deleted Enrollment Report</h2>
                </div>
                <div class="">
                    <p>This is the bulk deleted enrollment.</p>
                    <asp:Button ID="Button17" runat="server" Text="GO >" CssClass="mybutton mygobutton" PostBackUrl="~/Pages/Reporting/DeletedEnrollmentReport.aspx" />
                </div>
            </div>
        </div>
        </auth:SecureContent>

    </div>
</div>
</asp:Content>
