<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/Admin.Master"
    AutoEventWireup="true" CodeBehind="Inventory.aspx.cs" Inherits="POD.Pages.Inventory" %>
    <%@ Register Src="../UserControls/InventoryLinks.ascx" TagName="InventoryLinks"
    TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceholderHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
    <uc2:InventoryLinks ID="InventoryLinks1" runat="server" />
    <telerik:RadAjaxManagerProxy ID="RadAjaxManager1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGridAttendance">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridAttendance" LoadingPanelID="RadAjaxLoadingPanel1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="DashBoardContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="SidebarContentPlaceholder" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <telerik:RadCodeBlock runat="server" ID="RadCodeBlock1">
        <script type="text/javascript">
            function RowContextMenu(sender, eventArgs) {
                var menu = $find("<%=RadMenuOptions.ClientID %>");
                var evt = eventArgs.get_domEvent();

                if (evt.target.tagName == "INPUT" || evt.target.tagName == "A") {
                    return;
                }

                var index = eventArgs.get_itemIndexHierarchical();
                document.getElementById("radGridClickedRowIndex").value = index;
                sender.get_masterTableView().selectItem(sender.get_masterTableView().get_dataItems()[index].get_element(), true);
              
                menu.show(evt);
                evt.cancelBubble = true;
                evt.returnValue = false;

                if (evt.stopPropagation) {
                    evt.stopPropagation();
                    evt.preventDefault();
                }
            }

           
        </script>
    </telerik:RadCodeBlock>
    <telerik:RadGrid ID="RadGridInventory" runat="server" AutoGenerateColumns="false" 
        AllowPaging="True" AllowSorting="true" AllowFilteringByColumn="false" GroupingSettings-CaseSensitive="false"
        PageSize="15" Width="100%" EnableEmbeddedSkins="false" Skin="Prodigy" 
        HorizontalAlign="Center" onneeddatasource="RadGridInventory_NeedDataSource">
        <MasterTableView TableLayout="Auto" ClientDataKeyNames="InventoryItemID" CommandItemDisplay="Top" DataKeyNames="InventoryItemID"
        NoMasterRecordsText="No Inventory was found">
          <CommandItemTemplate>
                
            </CommandItemTemplate>
            <Columns>
                <telerik:GridBoundColumn DataField="Name" SortExpression="Name" FilterControlWidth="85%"
                    AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderText="Name">
                </telerik:GridBoundColumn>
                <%--<telerik:GridBoundColumn DataField="InventoryItemType.Name" SortExpression="InventoryItemType.Name"
                    FilterControlWidth="85%" AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderText="Item Type">
                </telerik:GridBoundColumn>--%>
                <telerik:GridBoundColumn DataField="Location.Name" SortExpression="Location.Name"
                    FilterControlWidth="85%" AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderText="Location">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="Manufacturer" FilterControlWidth="85%" AutoPostBackOnFilter="true"
                    ShowFilterIcon="false" SortExpression="Manufacturer" HeaderText="Manufacturer" ItemStyle-HorizontalAlign="Center">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="Model" FilterControlWidth="85%" AutoPostBackOnFilter="true"
                    ShowFilterIcon="false" SortExpression="Model" HeaderText="Model" ItemStyle-HorizontalAlign="Center">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="SerialNum" HeaderText="Serial #" FilterControlWidth="85%"
                    AutoPostBackOnFilter="true" ShowFilterIcon="false" SortExpression="SerialNum" ItemStyle-HorizontalAlign="Center">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="Organization" HeaderText="Organization" FilterControlWidth="85%"
                    AutoPostBackOnFilter="true" ShowFilterIcon="false" SortExpression="Organization">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="UACDCTagNum" HeaderText="UACDC Tag" FilterControlWidth="85%"
                    AutoPostBackOnFilter="true" ShowFilterIcon="false" SortExpression="UACDCTagNum" ItemStyle-HorizontalAlign="Center">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="DJJTagNum" HeaderText="DJJ Tag" FilterControlWidth="85%"
                    AutoPostBackOnFilter="true" ShowFilterIcon="false" SortExpression="DJJTagNum" ItemStyle-HorizontalAlign="Center">
                </telerik:GridBoundColumn>
                           </Columns>
            <NoRecordsTemplate>
                <p>
                    If you filtered please widen your search.
                </p>
            </NoRecordsTemplate>
        </MasterTableView>
        <ClientSettings>
            <ClientEvents OnRowClick="RowContextMenu"></ClientEvents>
            <Selecting AllowRowSelect="true" />
        </ClientSettings>
    </telerik:RadGrid>
    <input type="hidden" id="radGridClickedRowIndex" name="radGridClickedRowIndex" />
    <telerik:RadContextMenu ID="RadMenuOptions" runat="server" OnItemClick="RadMenu1_ItemClick"
        EnableRoundedCorners="true" EnableShadows="true">
        <Items>
            <telerik:RadMenuItem Text="Edit Inventory Item" Value="EditItem" />
            <telerik:RadMenuItem Text="Delete Inventory Item" Value="Delete" />
        </Items>
    </telerik:RadContextMenu>
   
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="EditButtonsPlaceholder" runat="server">
</asp:Content>
