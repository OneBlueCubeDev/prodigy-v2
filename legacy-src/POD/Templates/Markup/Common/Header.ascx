<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Header.ascx.cs" Inherits="POD.Templates.Markup.Common.Header" %>
<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
<h1>
    <a runat="server" href="~/Pages/ControlPanel.aspx" class="logo" title="University Area Community Development Corporation">
        <span>University Area Community Development Corporation</span></a>
    
</h1>

<%--<div class="topnav">
    <auth:SecureContent ID="SecureContent8" ToggleVisible="false" ToggleEnabled="true"
        EventHook="Load" runat="server" Roles="Administrators;Administrators-NA;CentralTeamUsers;SiteTeamUsers;SiteTeamUsers-NA">
        <ul>
            <li>
                <asp:HyperLink ID="HyperLinkPrevYouth" runat="server" NavigateUrl="~/Pages/Enrollments.aspx?erid=Prevention Youth"
                    ToolTip="Prevention Youth" Target="_self" Text="Prevention Youth"></asp:HyperLink>
                <span class="seperator"></span></li>
            <li>
                <asp:HyperLink ID="HyperLinkInterYouth" runat="server" NavigateUrl="~/Pages/Enrollments.aspx?erid=Intervention Youth"
                    ToolTip="Intervention Youth" Target="_self" Text="Intervention Youth"></asp:HyperLink>
                <span class="seperator"></span></li>
            <li>
                <asp:HyperLink ID="HyperLinkDivYouth" runat="server" NavigateUrl="~/Pages/Enrollments.aspx?erid=Diversion Youth"
                    ToolTip="Diversion Youth" Target="_self" Text="Diversion Youth"></asp:HyperLink>
            </li>
        </ul>
    </auth:SecureContent>
</div>--%>
<!--end topnav-->
<div class="usernav">
    <asp:LoginView ID="Loginview1" runat="server">
        <LoggedInTemplate>
            <p>
                Logged in as <span class="userName">
                    <asp:Literal ID="LiteralUserName" runat="server"></asp:Literal></span></p>
            <ul>
                <li><a runat="server" href="~/Pages/MyAccount.aspx" title="My Account">My Account</a><span class="seperator"></span></li>
                <li runat="server" id="LiAdminLink" class="AdminLink" visible="false">
                    <asp:HyperLink ID="HyperLinkAdministration" runat="server" NavigateUrl="~/Pages/Admin/Dashboard.aspx"
                        Visible="false" Text="Administration"></asp:HyperLink>
                    <span class="seperator"></span></li>
                <li>
                    <asp:LoginStatus ID="LoginStatus1" runat="server" LogoutText="Logout" class="Logout"
                        OnLoggedOut="LoginStatus1_LoggedOut" LogoutAction="Redirect" LogoutPageUrl="~/Default.aspx" />
                </li>
            </ul>
        </LoggedInTemplate>
    </asp:LoginView>
</div>
<!--end usernav-->
<div class="mainnav">
    <div class="mainnavInner mycurvycorners">
        <ul>
            <li runat="server" id="LiDashboard"><a runat="server" href="~/Pages/ControlPanel.aspx" title="Dashboard"
                class="firstMain">Dashboard</a></li>
            <li runat="server" id="LiYouth">
                <auth:SecureContent ID="SecureContent7" ToggleVisible="false" ToggleEnabled="true"
                    EventHook="Load" runat="server" Roles="Administrators;Administrators-NA;CentralTeamUsers;SiteTeamUsers;SiteTeamUsers-NA">
                    <asp:HyperLink runat="server" NavigateUrl="~/Pages/Enrollments.aspx" ID="HyperLinkYouth"
                        ToolTip="Youth" Text="Youth" Target="_self"></asp:HyperLink>
                </auth:SecureContent>
                <span class="seperator"></span></li>
            <li runat="server" id="LiAttendance">
                <auth:SecureContent ID="SecureContent3" ToggleVisible="false" ToggleEnabled="true"
                    EventHook="Load" runat="server" Roles="Administrators;Administrators-NA;CentralTeamUsers;SiteTeamUsers;SiteTeamUsers-NA">
                    <asp:HyperLink runat="server" NavigateUrl="~/Pages/Attendances.aspx" ID="HyperLinkAttendance"
                        ToolTip="Attendance" Text="Attendance" Target="_self"></asp:HyperLink>
                </auth:SecureContent>
                <span class="seperator"></span></li>
            <li runat="server" id="LiClass">
                <auth:SecureContent ID="SecureContent1" ToggleVisible="false" ToggleEnabled="true"
                    EventHook="Load" runat="server" Roles="Administrators;Administrators-NA;CentralTeamUsers;SiteTeamUsers;SiteTeamUsers-NA">
                    <asp:HyperLink runat="server" NavigateUrl="~/Pages/ManageClasses/Classes.aspx" ID="LinkClasses"
                        ToolTip="Classes" Text="Classes" Target="_self"></asp:HyperLink>
                </auth:SecureContent>
                <span class="seperator"></span></li>
            <li runat="server" id="LiLessonPlans">
                <auth:SecureContent ID="SecureContent2" ToggleVisible="false" ToggleEnabled="true"
                    EventHook="Load" runat="server" Roles="Administrators;Administrators-NA;CentralTeamUsers;SiteTeamUsers;SiteTeamUsers-NA">
                    <asp:HyperLink runat="server" NavigateUrl="~/Pages/LessonPlans/LessonPlans.aspx?tp=1" ID="HyperLinkLessonPlans"
                        ToolTip="Lesson Plans" Text="Lesson Plans" Target="_self"></asp:HyperLink>
                </auth:SecureContent>
                <span class="seperator"></span></li>
            <li runat="server" id="LiEvents">
                <auth:SecureContent ID="SecureContent4" ToggleVisible="false" ToggleEnabled="true"
                    EventHook="Load" runat="server" Roles="Administrators;Administrators-NA;CentralTeamUsers;SiteTeamUsers;">
                    <asp:HyperLink runat="server" NavigateUrl="~/Pages/Events.aspx" ID="HyperLinkEvents"
                        ToolTip="Events" Text="Events" Target="_self"></asp:HyperLink>
                </auth:SecureContent>
                <span class="seperator"></span></li>
            <li runat="server" id="LiStaff">
                <auth:SecureContent ID="SecureContent5" ToggleVisible="false" ToggleEnabled="true"
                    EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
                    <asp:HyperLink runat="server" NavigateUrl="~/Pages/Staff.aspx" ID="HyperLinkStaff"
                        ToolTip="Staff" Text="Staff" Target="_self"></asp:HyperLink>
                </auth:SecureContent>
                <span class="seperator"></span></li>
            <li runat="server" id="LiInventory">
                <auth:SecureContent ID="SecureContent6" ToggleVisible="false" ToggleEnabled="true"
                    EventHook="Load" runat="server" Roles="Administrators;Administrators-NA;CentralTeamUsers;CentralTeamUsers-NA;SiteTeamUsers;">
                    <asp:HyperLink runat="server" NavigateUrl="~/Pages/Inventory.aspx" ID="HyperLinkInventory"
                        ToolTip="Inventory" Text="Inventory" Target="_self"></asp:HyperLink>
                </auth:SecureContent>
                <span class="seperator"></span></li>
            <li runat="server" id="LiReporting"><a runat="server" href="~/Pages/Reporting/ReportingPage.aspx"
                title="Reporting">Reporting</a><span class="seperator"></span></li>
        </ul>
    </div>
    <!--end mainnavInner-->
</div>
<!--end mainnav-->
