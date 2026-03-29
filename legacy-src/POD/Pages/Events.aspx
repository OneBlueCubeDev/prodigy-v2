<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/Admin.Master"
    AutoEventWireup="true" CodeBehind="Events.aspx.cs" Inherits="POD.Pages.Events" %>

<%@ Register Src="../UserControls/EventsLinks.ascx" TagName="EventsLinks" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceholderHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
    <uc2:EventsLinks ID="EventsLinks1" runat="server" />
    <telerik:RadAjaxManagerProxy ID="RadAjaxManager1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGridEvents">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridEvents" LoadingPanelID="RadAjaxLoadingPanel1" />
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

            function ShowDetail(type, id) {
                var oManager = GetRadWindowManager();
                oManager.closeActiveWindow();
                if (id.length > 0) {
                    var url = '/Pages/AttendancePage.aspx?type=' + type + '&cid=' + id;
                    //open new window
                    var owind = window.radopen(url, "ViewAddPerson");
                    owind.set_visibleStatusbar(false);
                }
            }

            function OnClicking(sender, eventArgs) {
                var item = eventArgs.get_item();

                if (item.get_value() == "Delete") {
                    var proceed = confirm("Are you sure you want to delete this event and all related attendance data?");
                    if (!proceed) {
                        eventArgs.set_cancel(true);
                    }
                }

                if (item.get_value() == "Attendances") {
                    var id = $("#radGridClickedRowIndex").val();
                    var row = $find('<%= RadGridEvents.ClientID %>').get_masterTableView().get_dataItems()[id];
                    item.blur();
                    ShowDetail("Event", row.getDataKeyValue("EventID"));
                   
                }
            }
        </script>
    </telerik:RadCodeBlock>
    <telerik:RadGrid ID="RadGridEvents" runat="server" AutoGenerateColumns="false" OnNeedDataSource="RadGridEvents_NeedDataSource"
        AllowPaging="True" AllowSorting="true" AllowFilteringByColumn="false" GroupingSettings-CaseSensitive="false"
        PageSize="25" Width="100%" EnableEmbeddedSkins="false" Skin="Prodigy" HorizontalAlign="Center">
        <MasterTableView TableLayout="Auto" ClientDataKeyNames="EventID" DataKeyNames="EventID">
            <Columns>
                <telerik:GridBoundColumn DataField="Name" SortExpression="Name" FilterControlWidth="85%"
                    AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderText="Name">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="EventType.Name" SortExpression="EventType.Name"
                    FilterControlWidth="85%" AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderText="Event Type">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="Location.Name" SortExpression="Location.Name"
                    FilterControlWidth="85%" AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderText="Location">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="DateStart" FilterControlWidth="85%" AutoPostBackOnFilter="true"
                    ShowFilterIcon="false" SortExpression="DateStart" DataFormatString="{0:d}" HeaderText="Start Date"
                    ItemStyle-Width="10%" HeaderStyle-Width="10%">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="DateEnd" DataFormatString="{0:d}" FilterControlWidth="85%"
                    AutoPostBackOnFilter="true" ShowFilterIcon="false" SortExpression="DateEnd" HeaderText="End Date"
                    ItemStyle-Width="10%" HeaderStyle-Width="10%">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="StatusType.Name" SortExpression="StatusType.Name"
                    FilterControlWidth="85%" AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderText="Status">
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
    <telerik:RadContextMenu ID="RadMenuOptions" runat="server" OnClientItemClicking="OnClicking"
        OnItemClick="RadMenu1_ItemClick" EnableRoundedCorners="true" EnableShadows="true">
        <Items>
            <telerik:RadMenuItem Text="Edit Event" Value="EditItem" />
            <telerik:RadMenuItem Text="View Attendances" Value="Attendances" PostBack="false"  />
            <telerik:RadMenuItem IsSeparator="true">
            </telerik:RadMenuItem>
            <telerik:RadMenuItem Text="Delete Event" Value="Delete" />
        </Items>
    </telerik:RadContextMenu>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="EditButtonsPlaceholder" runat="server">
</asp:Content>
