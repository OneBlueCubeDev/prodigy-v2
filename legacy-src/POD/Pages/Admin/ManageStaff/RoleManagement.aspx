<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master"
    AutoEventWireup="true" CodeBehind="RoleManagement.aspx.cs" Inherits="POD.Pages.Admin.ManageStaff.RoleManagement" %>
<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <telerik:RadAjaxManagerProxy ID="RadAjaxManagerProxy1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGridRoles">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridRoles" LoadingPanelID="RadAjaxLoadingPanel1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server" />
    <telerik:RadCodeBlock runat="server" ID="RadCodeBlock1">
        <script type="text/javascript">

            function ShowEditForm() {

                var url = '/Pages/Admin/ManageStaff/RolePage.aspx'

                //open new window
                var owind = window.radopen(url, "ManageRoleDialog");
                owind.set_visibleStatusbar(false);

            }
            function refreshGrid(arg) {
                $find("<%= UpdatePanel.ClientID %>").ajaxRequest("Rebind");

            }
        </script>
    </telerik:RadCodeBlock>
    <h2 class="AdminHeader">Manage Staff Roles</h2>
    <p>
    <asp:Literal ID="LiteralError" runat="server"></asp:Literal>
    </p><br /><br />
    <telerik:RadAjaxPanel ID="UpdatePanel" runat="server" OnAjaxRequest="Panel_AjaxRequest">
    <telerik:RadGrid ID="RadGridRoles" CssClass="widetabcontainer" runat="server" AutoGenerateColumns="false" OnNeedDataSource="RadGridRoles_NeedDataSource"
        AllowPaging="True" AllowSorting="true" PageSize="25" Width="100%" EnableEmbeddedSkins="false" OnItemDataBound="RadGridRoles_ItemDataBound"
        Skin="Prodigy" HorizontalAlign="Center" OnItemCommand="RadGridRoles_ItemCommand" >
        <MasterTableView TableLayout="Auto" CommandItemDisplay="Top">
            <CommandItemTemplate>
                <table class="rgCommandTable">
                    <tbody>
                        <tr>
                            <td align="left">
                                 <auth:SecureContent ID="SecureContent3" ToggleVisible="true" ToggleEnabled="false"
            EventHook="Load" runat="server" Roles="Administrators;">
                                <a href="#" onclick="return ShowEditForm('');">
                                    <img src="../../../App_Themes/Prodigy/Grid/Add.gif" alt="" style="border: 0px none;">
                                    Add New Role</a></auth:SecureContent>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </CommandItemTemplate>
            <Columns>
                <telerik:GridBoundColumn UniqueName="NameColumn" DataField="Name" SortExpression="Name" HeaderText="Name">
                </telerik:GridBoundColumn>
                <telerik:GridButtonColumn ButtonType="ImageButton"  ItemStyle-Width="10%" HeaderStyle-HorizontalAlign="Right"
                   CommandName="Delete" ImageUrl="../../../App_Themes/Prodigy/Grid/Delete.png"
                    ShowFilterIcon="False" UniqueName="DeleteColumn" ConfirmText="Are you sure you want to delete this Role and all its related data?"
                    ButtonCssClass="IconButton DeleteButton" ItemStyle-HorizontalAlign="Center">
                </telerik:GridButtonColumn>
            </Columns>
            <NoRecordsTemplate>
                <p>
                    No Roles Implemented
                </p>
            </NoRecordsTemplate>
        </MasterTableView>
    </telerik:RadGrid>
    </telerik:RadAjaxPanel>
    <telerik:RadWindowManager ID="RadWindowManager1" runat="server" EnableEmbeddedSkins="false" Skin="Prodigy" Behaviors="Reload, Close">
        <Windows>
            <telerik:RadWindow ID="ManageRoleDialog" runat="server" Title="Manage Roles"
                ShowContentDuringLoad="false" Modal="true" Height="180px" Width="330px" EnableEmbeddedSkins="false" Skin="Prodigy" ReloadOnShow="true" CssClass="AddNewPersonAttendance" />
        </Windows>
    </telerik:RadWindowManager>
</asp:Content>
