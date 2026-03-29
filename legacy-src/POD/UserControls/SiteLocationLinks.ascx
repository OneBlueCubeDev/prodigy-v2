<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SiteLocationLinks.ascx.cs"
    Inherits="POD.UserControls.SiteLocationLinks" %>
<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
<asp:Panel ID="PanelSiteLocation" runat="server">
    <ul>
        <li>  <auth:SecureContent ID="SecureContent2" ToggleVisible="true" ToggleEnabled="false"
            EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;">
            <a runat="server" href="~/Pages/Admin/ManageLocations/LocationPage.aspx" title="New Site/Location"
            class="newSiteLocation"><span>Add Site/Location</span></a></auth:SecureContent>
        </li>
        <li>  <auth:SecureContent ID="SecureContent1" ToggleVisible="true" ToggleEnabled="false"
            EventHook="Load" runat="server" Roles="Administrators;">
            <a runat="server" href="~/Pages/Admin/ManageContracts/ContractManagement.aspx" title="Manage Contracts"
            class="manageContracts"><span>Manage Contracts</span></a></auth:SecureContent>
        </li>
        <li>
            <auth:SecureContent ID="SecureContent3" ToggleVisible="true" ToggleEnabled="false"
            EventHook="Load" runat="server" Roles="Administrators;">
            <a runat="server" href="~/Pages/Admin/ManageLocations/SiteAttendanceLockingManagement.aspx" title="Manage Attendance Lock Dates"
            class="managelocking"><span>Manage Attendance Lock Dates </span></a></auth:SecureContent>
        </li>
    </ul>
</asp:Panel>
