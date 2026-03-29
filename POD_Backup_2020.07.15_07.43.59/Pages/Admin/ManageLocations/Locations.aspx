<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master"
    AutoEventWireup="true" CodeBehind="Locations.aspx.cs" Inherits="POD.Pages.Admin.ManageLocations.Locations" %>

<%@ Register Src="../../../UserControls/AddEditAddress.ascx" TagName="AddEditAddress"
    TagPrefix="uc1" %>
<%@ Register Src="~/UserControls/SiteLocationLinks.ascx" TagName="SiteLocationLinks"
    TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
    <uc2:SiteLocationLinks ID="SiteLocationLinks1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server" EnableAJAX="true">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGridLocations">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridLocations" LoadingPanelID="RadAjaxLoadingPanel1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>
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

            function OnClicking(sender, eventArgs) {
                var item = eventArgs.get_item();

                if (item.get_value() == "Delete") {
                    var proceed = confirm("Are you sure you want to delete this location/site ?NOTE: if this is a site you are deleting all the locations associated with it.");
                    if (!proceed) {
                        eventArgs.set_cancel(true);
                    }
                }
            }
        </script>
    </telerik:RadCodeBlock>
    <!--this is the loading image control, must specify an image -->
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" EnableSkinTransparency="true"
        runat="server">
    </telerik:RadAjaxLoadingPanel>
    <h2 class="AdminHeader">Manage Locations</h2>
    <p>If you wish to filter the locations in this list, please enter your keyword and then click on the <span class="FilterIcon"><em>filter icon</em></span> next to the input to see filter options. The list will then filter based on your selection the data for you. </p>
    <telerik:RadGrid ID="RadGridLocations" runat="server" OnNeedDataSource="RadGridLocations_NeedDataSource"
      OnInit="RadGridLocations_Init"
        AutoGenerateColumns="false" AllowPaging="true" AllowSorting="true" PageSize="15" Skin="Prodigy" EnableEmbeddedSkins="false"
        AllowFilteringByColumn="true" GroupingSettings-CaseSensitive="false" CssClass="widetabcontainer">
        <MasterTableView DataKeyNames="LocationID" ClientDataKeyNames="LocationID" CommandItemDisplay="Top"
            NoMasterRecordsText="No Locations/Sites were found" TableLayout="Fixed">
            <CommandItemTemplate>
                          </CommandItemTemplate>
            <ItemStyle />
            <AlternatingItemStyle />
            <Columns>
                <telerik:GridBoundColumn DataField="Name" SortExpression="Name" ItemStyle-Width="400px"
                    HeaderText="Name" HeaderStyle-Width="400px" FilterControlWidth="85%" AutoPostBackOnFilter="true" />
                <telerik:GridBoundColumn DataField="StatusType.Name" SortExpression="StatusType.Name" AutoPostBackOnFilter="true"
                    HeaderText="Status" ItemStyle-Width="100px" HeaderStyle-Width="100px" ItemStyle-HorizontalAlign="Center" FilterControlWidth="75%">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="Address.AddressLine1" SortExpression="Address.AddressLine1"
                    HeaderText="Address" ItemStyle-Width="180px" FilterControlWidth="85%" AutoPostBackOnFilter="true">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="Address.City" SortExpression="Address.City" HeaderText="City" FilterControlWidth="85%"
                 ItemStyle-Width="200px" HeaderStyle-Width="200px" AutoPostBackOnFilter="true">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="DateTimeStamp" SortExpression="DateTimeStamp"
                    HeaderText="Last Modified" DataFormatString="{0:d}" FilterControlWidth="85%" AllowFiltering="false" 
                    AutoPostBackOnFilter="true" ItemStyle-Width="100px" HeaderStyle-Width="100px" ItemStyle-HorizontalAlign="Center">
                </telerik:GridBoundColumn>
                <telerik:GridTemplateColumn SortExpression="IsSite" HeaderText="Is Site?" ItemStyle-Width="60px" HeaderStyle-Width="60px" 
                ItemStyle-HorizontalAlign="Center" FilterControlWidth="85%" AutoPostBackOnFilter="true" AllowFiltering="false">
                    <ItemTemplate>
                        <asp:Label ID="LabelIsSite" runat="server" Text='<%# Eval("IsSite").ToString()=="True" ? "Yes":"No" %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>
            </Columns>
        </MasterTableView>
        <ClientSettings>
            <ClientEvents OnRowClick="RowContextMenu"></ClientEvents>
            <Selecting AllowRowSelect="true" />
        </ClientSettings>
    </telerik:RadGrid>
    <input type="hidden" id="radGridClickedRowIndex" name="radGridClickedRowIndex" />
    <telerik:RadContextMenu ID="RadMenuOptions" OnClientItemClicking="OnClicking" runat="server"
        OnItemClick="RadMenu1_ItemClick" EnableRoundedCorners="true" EnableShadows="true">
        <Items>
            <telerik:RadMenuItem Text="Edit Location" Value="Edit" />
            <telerik:RadMenuItem Text="Delete Location" Value="Delete" />
        </Items>
    </telerik:RadContextMenu>
   
</asp:Content>
