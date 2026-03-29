<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="InventoryLinks.ascx.cs"
    Inherits="POD.UserControls.InventoryLinks" %>
<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
<asp:Panel ID="PanelInventory" runat="server">
    <ul>
        <li>
            <auth:SecureContent ID="SecureContent3" ToggleVisible="true" ToggleEnabled="false"
                EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
                <a runat="server" href="~/Pages/InventoryItemPage.aspx" title="New Inventory Item" class="newInventoryItem">
                    <span>New Inventory Item</span></a></auth:SecureContent>
        </li>
    </ul>
</asp:Panel>
