<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master" AutoEventWireup="true" CodeBehind="PositionManagement.aspx.cs" Inherits="POD.Pages.Admin.ManageStaff.PositionManagement" %>
<%@ Register Src="~/UserControls/StaffLinks.ascx" TagName="StaffLinks" TagPrefix="uc2" %>
<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
  <uc2:StaffLinks ID="StaffLinks1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
        <h2 class="AdminHeader">Manage Staff Positions</h2>
    <p>
    <asp:Literal ID="LiteralError" runat="server"></asp:Literal>
    </p><br /><br />
    <telerik:RadGrid ID="RadGridPositions" CssClass="widetabcontainer" runat="server" AutoGenerateColumns="false" OnNeedDataSource="RadGridPositions_NeedDataSource"
        AllowPaging="True" AllowSorting="true" PageSize="25" Width="100%" EnableEmbeddedSkins="false" OnItemDataBound="RadGridPositions_ItemDataBound"
        Skin="Prodigy" HorizontalAlign="Center" OnItemCommand="RadGridPositions_ItemCommand">
        <MasterTableView TableLayout="Fixed" CommandItemDisplay="Top" DataKeyNames="PositionID">
            <CommandItemTemplate>
                <table class="rgCommandTable">
                    <tbody>
                        <tr>
                            <td align="left">
                                 <auth:SecureContent ID="SecureContent3" ToggleVisible="true" ToggleEnabled="false"
            EventHook="Load" runat="server" Roles="Administrators;">
                                <asp:LinkButton runat="server" PostBackUrl="~/Pages/Admin/ManageStaff/PositionPage.aspx">
                                    <img src="../../../App_Themes/Prodigy/Grid/Add.gif" alt="Add New Position"/>
                                    Add New Position
                                </asp:LinkButton></auth:SecureContent>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </CommandItemTemplate>
            <Columns>
                <telerik:GridBoundColumn UniqueName="JobTitleColumn" DataField="JobTitle" SortExpression="JobTitle" HeaderText="Job Title">
                </telerik:GridBoundColumn>
                <telerik:GridTemplateColumn UniqueName="LocationColumn" SortExpression="LocationID" HeaderText="Location">
                    <ItemTemplate><%# Eval("Location") != null ? Eval("Location.Name") : string.Empty %></ItemTemplate>
                </telerik:GridTemplateColumn>
                <telerik:GridTemplateColumn UniqueName="PersonColumn" SortExpression="PersonID" HeaderText="Staff">
                    <ItemTemplate><%# Eval("StaffMember") != null ? string.Format("{0} {1}", Eval("StaffMember.FirstName"), Eval("StaffMember.LastName")) : string.Empty%></ItemTemplate>
                </telerik:GridTemplateColumn>
                <telerik:GridTemplateColumn UniqueName="IsOpenColumn" SortExpression="IsOpen" HeaderText="Open?" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate><%# Convert.ToBoolean(Eval("IsOpen")) ? "Yes" : "No" %></ItemTemplate>
                </telerik:GridTemplateColumn>
                <telerik:GridBoundColumn UniqueName="VacancyDateColumn" DataField="VacancyDate" SortExpression="VacancyDate" HeaderText="Vacancy Date" DataFormatString="{0:MMM d, yyyy}" ItemStyle-HorizontalAlign="Center">
                </telerik:GridBoundColumn>
                <telerik:GridButtonColumn ButtonType="ImageButton"  ItemStyle-Width="10%" HeaderStyle-HorizontalAlign="Right"
                   CommandName="Modify" ImageUrl="../../../App_Themes/Prodigy/Grid/edit.gif" ShowFilterIcon="False" UniqueName="ModifyColumn" 
                   ButtonCssClass="IconButton EditButton" ItemStyle-HorizontalAlign="Center">
                </telerik:GridButtonColumn>
                <telerik:GridButtonColumn ButtonType="ImageButton"  ItemStyle-Width="10%" HeaderStyle-HorizontalAlign="Right"
                   CommandName="Delete" ImageUrl="../../../App_Themes/Prodigy/Grid/Delete.png"
                    ShowFilterIcon="False" UniqueName="DeleteColumn" ConfirmText="Are you sure you want to delete this Position?"
                    ButtonCssClass="IconButton DeleteButton" ItemStyle-HorizontalAlign="Center">
                </telerik:GridButtonColumn>
            </Columns>
            <NoRecordsTemplate>
                <p>
                    No Positions Found
                </p>
            </NoRecordsTemplate>
        </MasterTableView>
    </telerik:RadGrid>
</asp:Content>
