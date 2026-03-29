<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master" AutoEventWireup="true" CodeBehind="ContractManagement.aspx.cs" Inherits="POD.Pages.Admin.ManageContracts.ContractManagement" %>
<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
        <h2 class="AdminHeader">Manage Contracts</h2>
    <p>
    <asp:Literal ID="LiteralError" runat="server"></asp:Literal>
    </p>
     <p>If you wish to filter the contracts in this list, please enter your keyword and then click on the <span class="FilterIcon"><em>filter icon</em></span> next to the input to see filter options. The list will then filter based on your selection the data for you. </p>
  
    <br /><br />
    <telerik:RadGrid ID="RadGridContracts" CssClass="widetabcontainer" runat="server" AutoGenerateColumns="false" OnNeedDataSource="RadGridContracts_OnNeedDataSource"
        AllowPaging="True" AllowSorting="true" PageSize="25" Width="100%" EnableEmbeddedSkins="false"
         OnInit="RadGridContacts_Init" OnItemDataBound="RadGridContracts_ItemDataBound"
        Skin="Prodigy" HorizontalAlign="Center" OnItemCommand="RadGridContracts_ItemCommand" EnableLinqExpressions="False">
        <MasterTableView TableLayout="Auto" CommandItemDisplay="Top" DataKeyNames="ContractID" AllowFilteringByColumn="True">
            <CommandItemTemplate>
                <table class="rgCommandTable">
                    <tbody>
                        <tr>
                            <td align="left"><auth:SecureContent ID="SecureContent2" ToggleVisible="true" ToggleEnabled="false"
                    EventHook="Load" runat="server" Roles="Administrators;">
                                <asp:LinkButton ID="LinkButton1" runat="server" PostBackUrl="~/Pages/Admin/ManageContracts/ContractPage.aspx">
                                    <img src="../../../App_Themes/Prodigy/Grid/Add.gif" alt="Add New Contract"/>
                                    Add New Contract
                                </asp:LinkButton></auth:SecureContent>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </CommandItemTemplate>
            <Columns>
                <telerik:GridBoundColumn UniqueName="ContractNumberColumn" DataField="ContractNumber" SortExpression="ContractNumber" HeaderText="Contract Number"
                    FilterControlWidth="85%" AutoPostBackOnFilter="True">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn UniqueName="SiteNameColumn" DataField="SiteName" SortExpression="SiteName" HeaderText="Site"
                    FilterControlWidth="85%" AutoPostBackOnFilter="True">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn UniqueName="ProgramNameColumn" DataField="ProgramName" SortExpression="ProgramName" HeaderText="Program"
                    FilterControlWidth="85%" AutoPostBackOnFilter="True">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn UniqueName="DateStartColumn" DataField="DateStart" SortExpression="DateStart" HeaderText="Start Date" DataFormatString="{0:d}" ItemStyle-HorizontalAlign="Center"
                    FilterControlWidth="85%" AutoPostBackOnFilter="True">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn UniqueName="DateEndColumn" DataField="DateEnd" SortExpression="DateEnd" HeaderText="End Date" DataFormatString="{0:d}" ItemStyle-HorizontalAlign="Center"
                    FilterControlWidth="85%" AutoPostBackOnFilter="True">
                </telerik:GridBoundColumn>
                <telerik:GridButtonColumn ButtonType="ImageButton"  ItemStyle-Width="10%" HeaderStyle-HorizontalAlign="Right"
                   CommandName="Modify" ImageUrl="../../../App_Themes/Prodigy/Grid/edit.gif" ShowFilterIcon="False" UniqueName="ModifyColumn" 
                   ButtonCssClass="IconButton EditButton" ItemStyle-HorizontalAlign="Center">
                </telerik:GridButtonColumn>
                <telerik:GridButtonColumn ButtonType="ImageButton"  ItemStyle-Width="10%" HeaderStyle-HorizontalAlign="Right"
                   CommandName="Delete" ImageUrl="../../../App_Themes/Prodigy/Grid/Delete.png"
                    ShowFilterIcon="False" UniqueName="DeleteColumn" ConfirmText="Are you sure you want to delete this contract?"
                    ButtonCssClass="IconButton DeleteButton" ItemStyle-HorizontalAlign="Center">
                </telerik:GridButtonColumn>
            </Columns>
            <NoRecordsTemplate>
                <p>
                    No Contracts Found
                </p>
            </NoRecordsTemplate>
        </MasterTableView>
    </telerik:RadGrid>
</asp:Content>
