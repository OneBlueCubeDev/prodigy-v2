<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="StaffLinks.ascx.cs" Inherits="POD.UserControls.StaffLinks" %>
<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
<asp:Panel ID="PanelStaff" runat="server">
        <ul>
           <li> <auth:SecureContent ID="SecureContent3" ToggleVisible="false" ToggleEnabled="true"
            EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
               <a runat="server" href="~/Pages/StaffMember.aspx" title="Add Staff Member" class="addStaffMember"><span>Add Staff Member</span></a></auth:SecureContent>
           </li>
           <li ID="ManagePositionsLink" runat="server">
               
               <a runat="server" href="~/Pages/Admin/ManageStaff/PositionManagement.aspx" title="Manage Positions" class="managePositions"><span>Manage Positions</span></a>
           </li>
        </ul>
    </asp:Panel>
