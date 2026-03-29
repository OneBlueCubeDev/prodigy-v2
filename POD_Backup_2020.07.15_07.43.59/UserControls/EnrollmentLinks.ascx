<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EnrollmentLinks.ascx.cs"
    Inherits="POD.UserControls.EnrollmentLinks" %>
<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
<asp:Panel ID="PanelEnrollment" runat="server">
    <ul>
        <li runat="server" id="LiDiversonEnrollment">
            <auth:SecureContent ID="SecureContent1" ToggleVisible="True" ToggleEnabled="False"
                EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
                <a runat="server" href="~/Pages/EnrollmentPage.aspx?d=1" title="New Diversion Enrollment" class="diversionEnrollment">
                    <span>New Diversion Enrollment</span></a></auth:SecureContent>
        </li>
        <li runat="server" id="Li1">
            <auth:SecureContent ID="SecureContent2" ToggleVisible="True" ToggleEnabled="True"
                EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
                <a runat="server" href="~/Pages/EnrollmentPage.aspx?d=0" title="New Prevention Enrollment" class="preventionEnrollment">
                    <span>New Prevention Enrollment</span></a></auth:SecureContent>
        </li>
        <li runat="server" id="LiInactive"><a runat="server" href="~/Pages/Enrollments.aspx?status=0" title="Inactive Youth"
            class="inactiveYouth"><span>Inactive Youth</span></a></li>
        <li runat="server" id="LiActive"><a runat="server" href="~/Pages/Enrollments.aspx?status=1" title="Active Youth"
            class="activeYouth"><span>Active Youth</span></a></li>
        <li runat="server" id="LiPreEnrolled"><a runat="server" href="~/Pages/Enrollments.aspx?status=5"
            title="Rollover Youth" class="rollover"><span>Rollover Youth</span></a></li>
        
    </ul>
</asp:Panel>
