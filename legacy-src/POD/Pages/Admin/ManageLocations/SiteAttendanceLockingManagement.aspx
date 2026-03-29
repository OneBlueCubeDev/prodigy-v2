<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master"
    AutoEventWireup="true" CodeBehind="SiteAttendanceLockingManagement.aspx.cs" Inherits="POD.Pages.Admin.ManageLocations.SiteAttendanceLockingManagement" %>

<%@ Register Src="~/UserControls/SiteLocationLinks.ascx" TagName="SiteLocationLinks"
    TagPrefix="uc2" %>
<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
    <uc2:SiteLocationLinks ID="SiteLocationLinks1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server" EnableAJAX="true">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGridSites">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridSites" LoadingPanelID="RadAjaxLoadingPanel1" />
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

        </script>
    </telerik:RadCodeBlock>
    <!--this is the loading image control, must specify an image -->
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" EnableSkinTransparency="true"
        runat="server">
    </telerik:RadAjaxLoadingPanel>
    <div class="tabcontainer widetabcontainer">
        <div class="tabcontent">
            <div class="AttendanceLockingWrapper">
                <h2 class="AdminHeader">Manage Attendance Locking Dates</h2>
                <p>
                    If you wish to set the date for all sites, use the date picker above the list. This
                    will update the lock date for all sites to the specified date. If you need to manage
                    a particular site only, click on the row and choose the "Edit Lock Date" option
                    for that site.
                </p>
                <auth:SecureContent ID="SecureContent1" ToggleVisible="false" ToggleEnabled="true"
                    EventHook="Load" runat="server" Roles="Administrators;">
                    <div class="TopEditToolbar row">
                        <div class="ReleaseInfoWrapper">
                            <%--<label class="mylabel myeditdatepickerlabel">
                                Attendance Locked Date:</label>
                            <div class="myeditdatepicker">
                                <telerik:RadDatePicker ID="LockDatePicker" runat="server" MinDate="1/1/1900" DateInput-Width="50px"
                                    Width="52%" DateInput-DisplayDateFormat="MM/dd/yy" Calendar-ShowRowHeaders="False" ValidationGroup="Locked"
                                    Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup myenrollmentdob">
                                </telerik:RadDatePicker>

                            </div>--%>
                            <div class="InputWrapper row">
                                <div class="FormLabel mylabel SiteLabel">
                                    All Sites Mandatory Attendance Lock
                                </div>
                                <asp:CheckBox ID="chkmandatoryattenancelock" CssClass="checkBox SpecialClass" runat="server" />
                            </div>
                            <div class="InputWrapper row">
                            <asp:Button ID="ButtonUpdate" runat="server" Text="Update" ValidationGroup="Locked" OnClick="Update_Click"
                                CssClass="mybutton" />
                            </div>
                            
                        </div>
                        <div class="">
                            <asp:Literal runat="server" ID="LiteralMessage"></asp:Literal>
                            <div class="clear">
                            </div>
                        </div>
                    </div>
                </auth:SecureContent>
                <telerik:RadGrid ID="RadGridSites" runat="server" OnNeedDataSource="RadGridSites_NeedDataSource"
                    OnInit="RadGridSites_Init" AutoGenerateColumns="false" AllowPaging="true"
                    AllowSorting="true" PageSize="15" Skin="Prodigy" EnableEmbeddedSkins="false"
                    AllowFilteringByColumn="true" GroupingSettings-CaseSensitive="false">
                    <MasterTableView DataKeyNames="LocationID" ClientDataKeyNames="LocationID" CommandItemDisplay="Top"
                        NoMasterRecordsText="No Sites were found" TableLayout="Fixed">
                        <CommandItemTemplate>
                        </CommandItemTemplate>
                        <ItemStyle />
                        <AlternatingItemStyle />
                        <Columns>
                            <telerik:GridBoundColumn DataField="Name" SortExpression="Name" ItemStyle-Width="400px"
                                HeaderText="Name" HeaderStyle-Width="400px" FilterControlWidth="85%" AutoPostBackOnFilter="true" />
                            <telerik:GridBoundColumn DataField="StatusType.Name" SortExpression="StatusType.Name"
                                AutoPostBackOnFilter="true" HeaderText="Status" ItemStyle-Width="100px" HeaderStyle-Width="100px"
                                ItemStyle-HorizontalAlign="Center" FilterControlWidth="75%">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Address.AddressLine1" SortExpression="Address.AddressLine1"
                                HeaderText="Address" ItemStyle-Width="180px" FilterControlWidth="85%" AutoPostBackOnFilter="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Address.City" SortExpression="Address.City" HeaderText="City"
                                FilterControlWidth="85%" ItemStyle-Width="200px" HeaderStyle-Width="200px" AutoPostBackOnFilter="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="AttendanceLockedDate" SortExpression="AttendanceLockedDate"
                                HeaderText="Attendance Lock Date" DataFormatString="{0:d}" FilterControlWidth="85%"
                                AllowFiltering="false" AutoPostBackOnFilter="true" ItemStyle-Width="100px" HeaderStyle-Width="100px"
                                ItemStyle-HorizontalAlign="Center">
                            </telerik:GridBoundColumn>

                        </Columns>
                    </MasterTableView>
                    <ClientSettings>
                        <ClientEvents OnRowClick="RowContextMenu"></ClientEvents>
                        <Selecting AllowRowSelect="true" />
                    </ClientSettings>
                </telerik:RadGrid>
                <input type="hidden" id="radGridClickedRowIndex" name="radGridClickedRowIndex" />
                <telerik:RadContextMenu ID="RadMenuOptions" runat="server"
                    OnItemClick="RadMenu_ItemClick" EnableRoundedCorners="true" EnableShadows="true">
                    <Items>
                        <telerik:RadMenuItem Text="Edit Attendance Lock Date" Value="Edit" />
                    </Items>
                </telerik:RadContextMenu>
            </div>
        </div>
    </div>
</asp:Content>
