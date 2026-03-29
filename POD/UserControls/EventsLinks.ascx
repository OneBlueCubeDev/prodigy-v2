<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EventsLinks.ascx.cs" Inherits="POD.UserControls.EventsLinks" %>
<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
<asp:Panel ID="PanelEvents" runat="server">
        <ul>
           <li>
                  <auth:SecureContent ID="SecureContent5" ToggleVisible="true" ToggleEnabled="false"
                    EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
               <a runat="server" href="~/Pages/EventPage.aspx" title="New Event" class="newEvent"><span>New Event</span></a></auth:SecureContent>
           </li>
           <%--<li ><a href="~/Pages/AttendancePage.aspx" title="Add Attendance" class="addAttendance"><span>Add Attendance</span></a></li>--%>
        </ul>
    </asp:Panel>