<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/Admin.Master"
    AutoEventWireup="true" CodeBehind="Enrollments.aspx.cs" Inherits="POD.Pages.Enrollments" %>

<%@ Register Src="~/UserControls/SearchSideBar.ascx" TagName="SearchSideBar" TagPrefix="uc1" %>
<%@ Register Src="../UserControls/EnrollmentLinks.ascx" TagName="EnrollmentLinks"
    TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceholderHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
    <telerik:RadAjaxManagerProxy ID="RadAjaxManagerProxy1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGridEnrollments">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridEnrollments" LoadingPanelID="RadAjaxLoadingPanel1" />
                    <telerik:AjaxUpdatedControl ControlID="RadMenuOptions" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadMenuOptionsInactive">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridEnrollments" LoadingPanelID="RadAjaxLoadingPanel1" />
                    <telerik:AjaxUpdatedControl ControlID="RadMenuOptionsInactive" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadMenuOptions">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridEnrollments" LoadingPanelID="RadAjaxLoadingPanel1" />
                    <telerik:AjaxUpdatedControl ControlID="RadMenuOptions" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server" HorizontalAlign="Center">
        <img alt="" src="../App_Themes/Prodigy/Common/loading.gif" style="border: none; margin-top: 150px;" />
    </telerik:RadAjaxLoadingPanel>
    <uc2:EnrollmentLinks ID="EnrollmentLinks1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="SidebarContentPlaceholder" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <telerik:RadCodeBlock runat="server" ID="RadCodeBlock1">
        <script type="text/javascript">

            function GetRadWindow() {
                var oWindow = null;
                if (window.radWindow)
                    oWindow = window.radWindow;
                else if (window.frameElement.radWindow)
                    oWindow = window.frameElement.radWindow;
                return oWindow;
            }

            function RowContextMenu(sender, eventArgs) {
                var menu = $find("<%=RadMenuOptions.ClientID %>");
                var inactiveMenu = $find("<%=RadMenuOptionsInactive.ClientID %>");
                var evt = eventArgs.get_domEvent();

                if (evt.target.tagName == "INPUT" || evt.target.tagName == "A") {
                    return;
                }

                var index = eventArgs.get_itemIndexHierarchical();
                document.getElementById("radGridClickedRowIndex").value = index;

                sender.get_masterTableView().selectItem(sender.get_masterTableView().get_dataItems()[index].get_element(), true);

                var text = sender.get_masterTableView().getCellByColumnUniqueName(sender.get_masterTableView().get_dataItems()[index], "colEnrollmentStatusName").innerHTML;

                if (text != null) {
                    if (text == "Inactive") {
                        inactiveMenu.show(evt);
                    }
                    else {
                        menu.show(evt);
                    }
                }

                evt.cancelBubble = true;
                evt.returnValue = false;

                if (evt.stopPropagation) {
                    evt.stopPropagation();
                    evt.preventDefault();
                }
            }

            function DownLoadCertificate(id, enrollID, type) {
                var oManager = GetRadWindowManager();
                oManager.closeActiveWindow();
                if (id.length > 0) {

                    var url = 'DownLoad.aspx?pid=' + id + "&eid=" + enrollID + "&tp=" + type;
                    //open new window
                    var owind = window.radopen(url, "ViewCertificate");
                    owind.set_visibleStatusbar(false);
                }

            }

            function ShowTransfer(id) {
                var oManager = GetRadWindowManager();
                oManager.closeActiveWindow();
                if (id.length > 0) {
                    var url = 'TransferYouthPage.aspx?pid=' + id;
                    //open new window
                    var owind = window.radopen(url, "ViewTransfer");
                    owind.set_visibleStatusbar(false);
                }

            }

            function ShowRelease(id, key, type) {
                var oManager = GetRadWindowManager();
                oManager.closeActiveWindow();
                if (id.length > 0) {
                    var url = 'ReleaseYouthPage.aspx?pid=' + id + '&eid=' + key + '&type=' + type;
                    //open new window
                    var owind = window.radopen(url, "ViewRelease");
                    owind.set_visibleStatusbar(false);
                }

            }

            function RadMenuShowing(sender, eventArgs) {
                var grid = $find('<%= RadGridEnrollments.ClientID %>');
                var MasterTable = grid.get_masterTableView();
                var id = $("#radGridClickedRowIndex").val();
                var row = MasterTable.get_dataItems()[id];
                var text = MasterTable.getCellByColumnUniqueName(row, "colEnrollmentTypeName").innerHTML;
                var item = sender.findItemByValue("PAT");
                if (item != null) {
                    if (text == "Diversion Youth") {
                        item.disable();
                    }
                    else {
                        item.enable();
                    }
                }
            }

            function RadMenuOptionsClientClicking(sender, eventArgs) {
                var item = eventArgs.get_item();

                var id = $("#radGridClickedRowIndex").val();
                var row = $find('<%= RadGridEnrollments.ClientID %>').get_masterTableView().get_dataItems()[id];
                if (item.get_value() == "Transfer") {
                    item.blur();
                    ShowTransfer(row.getDataKeyValue("EnrollmentID"));
                }
                if (item.get_value() == "Transfer") {
                    item.blur();
                    ShowTransfer(row.getDataKeyValue("PersonID"));

                }
                if (item.get_value() == "Release") {
                    item.blur();
                    var type = "EN";
                    if (row.getDataKeyValue("EnrollmentTypeName") == "Risk Assessment") {
                        type = "RA";
                    }
                    ShowRelease(row.getDataKeyValue("PersonID"), row.getDataKeyValue("EnrollmentID"), type);

                }
                if (item.get_value() == "CompletionCertificate") {
                    item.blur();
                    var type = "en";
                    if (row.getDataKeyValue("EnrollmentTypeName") == "Risk Assessment") {
                        type = "ra";
                    }
                    DownLoadCertificate(row.getDataKeyValue("PersonID"), row.getDataKeyValue("EnrollmentID"), type);
                }

                if (item.get_value() == "Delete") {
                    var proceed = confirm("Are you sure you want to delete this?");
                    if (!proceed) {
                        eventArgs.set_cancel(true);
                    }
                }
            }
        </script>
    </telerik:RadCodeBlock>
    <telerik:RadGrid ID="RadGridEnrollments" runat="server" AutoGenerateColumns="false"
        OnNeedDataSource="RadGridEnrollments_NeedDataSource" AllowPaging="True" AllowSorting="true"
        AllowFilteringByColumn="false" GroupingSettings-CaseSensitive="false" PageSize="15"
        Width="100%" EnableEmbeddedSkins="false" Skin="Prodigy" HorizontalAlign="Center">
        <MasterTableView TableLayout="Auto" DataKeyNames="PersonID, EnrollmentID, EnrollmentTypeName"
            ClientDataKeyNames="PersonID, EnrollmentID,EnrollmentTypeName">
            <Columns>
                <telerik:GridBoundColumn DataField="FirstName" SortExpression="FirstName" FilterControlWidth="85%"
                    AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderText="First Name">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="LastName" SortExpression="LastName" FilterControlWidth="85%"
                    AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderText="Last Name">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="DJJIDNum" SortExpression="DJJIDNum" FilterControlWidth="85%"
                    AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderText="DJJ ID">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="LocationName" SortExpression="LocationName" FilterControlWidth="85%"
                    AutoPostBackOnFilter="true" Visible="false" ShowFilterIcon="false" HeaderText="Location">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="SiteName" SortExpression="SiteName" FilterControlWidth="85%"
                    AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderText="Site">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="EnrollmentTypeName" FilterControlWidth="85%"
                    AutoPostBackOnFilter="true" ShowFilterIcon="false" SortExpression="EnrollmentTypeName"
                    HeaderText="Type" UniqueName="colEnrollmentTypeName">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="DateApplied" DataFormatString="{0:MM/dd/yyyy}"
                    FilterControlWidth="85%" AutoPostBackOnFilter="true" ShowFilterIcon="false" SortExpression="DateApplied"
                    HeaderText="Applied Date" ItemStyle-Width="70px">
                </telerik:GridBoundColumn>
                <%--<telerik:GridBoundColumn DataField="DateAdmitted" DataFormatString="{0:MM/dd/yyyy}"
                    FilterControlWidth="85%" AutoPostBackOnFilter="true" ShowFilterIcon="false" SortExpression="DateAdmitted"
                    HeaderText="Admitted Date" ItemStyle-Width="80px">
                </telerik:GridBoundColumn>--%>
                <telerik:GridBoundColumn DataField="Age" HeaderText="Age" FilterControlWidth="85%"
                    AutoPostBackOnFilter="true" ShowFilterIcon="false" SortExpression="Age" ItemStyle-Width="20px">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="EnrollmentStatusName" FilterControlWidth="85%"
                    AutoPostBackOnFilter="true" ShowFilterIcon="false" UniqueName="colEnrollmentStatusName"
                    SortExpression="EnrollmentStatusName" HeaderText="Status">
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
        OnClientShowing="RadMenuShowing" EnableRoundedCorners="true" EnableShadows="true"
        OnClientItemClicking="RadMenuOptionsClientClicking">
        <Items>
            
            
            <telerik:RadMenuItem Text="View/Edit Enrollment" Value="Enrollment" />
            <telerik:RadMenuItem Text="View Attendance" Value="Attendance" />
            <telerik:RadMenuItem Text="View/Edit PAT Forms" Value="PAT" />
            <telerik:RadMenuItem Text="View Historical Risk Assessment" Value="RiskAssessment" />

            <telerik:RadMenuItem IsSeparator="true">
            </telerik:RadMenuItem>
            <telerik:RadMenuItem Text="Transfer Youth" Value="Transfer" PostBack="false" />
            <telerik:RadMenuItem Text="Release Youth" Value="Release" PostBack="false" />
            
            <%--<telerik:RadMenuItem Text="Create Certificate of Completion" Value="CompletionCertificate"
                PostBack="false" />--%>
            <telerik:RadMenuItem IsSeparator="true">
            </telerik:RadMenuItem>
            <telerik:RadMenuItem Text="Delete Youth" Value="Delete" />
            <telerik:RadMenuItem IsSeparator="true" Value="TopSeperator" />
            <telerik:RadMenuItem Text="Rollover Youth" Value="Rollover" />
        </Items>
    </telerik:RadContextMenu>
    <telerik:RadContextMenu ID="RadMenuOptionsInactive" runat="server" OnItemClick="RadMenu1_ItemClick"
        OnClientShowing="RadMenuShowing" EnableRoundedCorners="True" EnableShadows="True"
        OnClientItemClicking="RadMenuOptionsClientClicking">
        <Items>
            <telerik:RadMenuItem Text="Re-Enroll Youth" Value="ReEnrollment" />
            <telerik:RadMenuItem IsSeparator="true" Value="TopSeperator">
            </telerik:RadMenuItem>
            <telerik:RadMenuItem Text="View/Edit Enrollment" Value="Enrollment" />
            <telerik:RadMenuItem runat="server" Text="View Attendance" Value="Attendance">
            </telerik:RadMenuItem>
            <telerik:RadMenuItem Text="View/Edit PAT Forms" Value="PAT" />
            <telerik:RadMenuItem Text="View Historical Risk Assessment" Value="RiskAssessment" />
            <telerik:RadMenuItem IsSeparator="true">
            </telerik:RadMenuItem>
            <telerik:RadMenuItem Text="Delete Youth" Value="Delete" />
            <telerik:RadMenuItem IsSeparator="true" Value="TopSeperator" />
            <telerik:RadMenuItem Text="Rollover Youth" Value="Rollover" />
        </Items>
    </telerik:RadContextMenu>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="EditButtonsPlaceholder" runat="server">
</asp:Content>
