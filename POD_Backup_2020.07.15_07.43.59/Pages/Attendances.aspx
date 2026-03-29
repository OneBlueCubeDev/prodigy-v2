<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/Admin.Master"
    AutoEventWireup="true" CodeBehind="Attendances.aspx.cs" Inherits="POD.Pages.Attendances" %>

<%@ Register Src="../UserControls/AttendanceLinks.ascx" TagName="AttendanceLinks"
    TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceholderHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
    <uc2:AttendanceLinks ID="AttendanceLinks2" runat="server" />
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

            function ShowDetail(type, id) {
                var oManager = GetRadWindowManager();
                oManager.closeActiveWindow();
                if (id.length > 0) {
                    var url = 'AttendancePage.aspx?type=' + type + '&cid=' + id;
                    //open new window
                    var owind = window.radopen(url, "ViewAddPerson");
                    owind.set_visibleStatusbar(false);
                }

            }

            function OnClicking(sender, eventArgs) {
                var item = eventArgs.get_item();
                var id = $("#radGridClickedRowIndex").val();
                if (item.get_value() == "EditItem") {
                    var row = $find('<%= RadGridAttendance.ClientID %>').get_masterTableView().get_dataItems()[id];
                    item.blur();
                    ShowDetail(row.getDataKeyValue("RecordType"), row.getDataKeyValue("RecordID"));
                } 
            }
        </script>
    </telerik:RadCodeBlock>
    <telerik:RadGrid ID="RadGridAttendance" runat="server" AutoGenerateColumns="false"
        OnNeedDataSource="RadGridAttendance_NeedDataSource" AllowPaging="True" AllowSorting="true"
        AllowFilteringByColumn="false" GroupingSettings-CaseSensitive="false" PageSize="15"
        Width="100.1%" EnableEmbeddedSkins="false" Skin="Prodigy" HorizontalAlign="Center"
        SelectedItemStyle-Wrap="true">
        <MasterTableView TableLayout="Auto" ClientDataKeyNames="RecordID, RecordType"
            DataKeyNames="RecordID, RecordType">
            <Columns>
                <telerik:GridBoundColumn DataField="DateStart" DataFormatString="{0:d}" ShowFilterIcon="false"
                    SortExpression="DateStart" HeaderText="Attendance Date" HeaderStyle-HorizontalAlign="Center"
                    ItemStyle-HorizontalAlign="Center" ItemStyle-Width="75px" HeaderStyle-Width="75px">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="ClassName" FilterControlWidth="85%" SortExpression="ClassName"
                    HeaderText="Class/Event">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="SiteLocationName" HeaderText="Site" SortExpression="SiteLocationName">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="LocationName" HeaderText="Location" SortExpression="LocationName">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="PeopleAssignedToClass" HeaderText="Youth Assigned"
                    FilterControlWidth="85%" SortExpression="PeopleAssignedToClass" ItemStyle-HorizontalAlign="Center">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="AttendanceCount" HeaderText="Attended"
                    SortExpression="AttendanceCount" ItemStyle-HorizontalAlign="Center">
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
      EnableRoundedCorners="true" EnableShadows="true">
        <Items>
            <telerik:RadMenuItem Text="View Attendances" Value="EditItem" />
         </Items>
    </telerik:RadContextMenu>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="EditButtonsPlaceholder" runat="server">
</asp:Content>
