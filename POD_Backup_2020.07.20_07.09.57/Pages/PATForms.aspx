<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PATForms.aspx.cs" Inherits="POD.Pages.PATForms" MasterPageFile="~/Templates/Markup/Admin.Master" %>

<%@ Register Src="~/UserControls/SearchSideBar.ascx" TagName="SearchSideBar" TagPrefix="uc1" %>
<%@ Register Src="../UserControls/EnrollmentLinks.ascx" TagName="EnrollmentLinks" TagPrefix="uc2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceholderHead" runat="server">
    <telerik:RadCodeBlock runat="server" ID="SpecialJavascript">
    <script type="text/javascript">
        function disablebox1() {
            alert('shane1');
        }
                                </script>
        </telerik:RadCodeBlock>

    <telerik:RadScriptBlock ID="RadScriptBlock1" runat="server">
   <script type="text/javascript">
       $(document).ready(function () {
           function disablebox2() {
               alert('shane2');
           }
       });

    </script>
        
    
</telerik:RadScriptBlock>
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

            function DisableCheckBoxes() {
                alert('shane');
            }

            function RowContextMenu(sender, eventArgs) {
                var menu = $find("<%=RadMenuOptions.ClientID %>");
                var evt = eventArgs.get_domEvent();

                if (evt.target.tagName == "INPUT" || evt.target.tagName == "A") {
                    return;
                }

                var index = eventArgs.get_itemIndexHierarchical();
                document.getElementById("radGridClickedRowIndex").value = index;

                sender.get_masterTableView().selectItem(sender.get_masterTableView().get_dataItems()[index].get_element(), true);

                var text = sender.get_masterTableView().getCellByColumnUniqueName(sender.get_masterTableView().get_dataItems()[index], "colPersonFormId").innerHTML;

                if (text != null) {
                    menu.show(evt);
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

                    var url = '/Pages/DownLoad.aspx?pid=' + id + "&eid=" + enrollID + "&tp=" + type;
                    //open new window
                    var owind = window.radopen(url, "ViewCertificate");
                    owind.set_visibleStatusbar(false);
                }

            }

            function ShowTransfer(id) {
                var oManager = GetRadWindowManager();
                oManager.closeActiveWindow();
                if (id.length > 0) {
                    var url = '/Pages/TransferYouthPage.aspx?pid=' + id;
                    //open new window
                    var owind = window.radopen(url, "ViewTransfer");
                    owind.set_visibleStatusbar(false);
                }

            }

            function ShowRelease(id, key, type) {
                var oManager = GetRadWindowManager();
                oManager.closeActiveWindow();
                if (id.length > 0) {
                    var url = '/Pages/ReleaseYouthPage.aspx?pid=' + id + '&eid=' + key + '&type=' + type;
                    //open new window
                    var owind = window.radopen(url, "ViewRelease");
                    owind.set_visibleStatusbar(false);
                }

            }

            function RadMenuShowing(sender, eventArgs) {
                var grid = $find('<%= patFormGrid.ClientID %>');
                var MasterTable = grid.get_masterTableView();
                var id = $("#radGridClickedRowIndex").val();
                var row = MasterTable.get_dataItems()[id];
                var text = MasterTable.getCellByColumnUniqueName(row, "colPersonFormId").innerHTML;
                var item = sender.findItemByValue("RiskAssessment");
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
                var row = $find('<%= patFormGrid.ClientID %>').get_masterTableView().get_dataItems()[id];
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
    
    <asp:TextBox runat="server" ID="txtPersonId" Visible="False"></asp:TextBox>
    
    <div style="padding-bottom:5px;">
        <h3>PAT Forms:&nbsp;<asp:Label runat="server" ID="lblPersonName"></asp:Label></h3>
    </div>
    <div style="padding-bottom:5px;">
        <asp:Button ID="NewButton" runat="server" Text="New" class="mybutton" OnClick="NewButton_Click" />
    </div>

    <telerik:RadGrid ID="patFormGrid" runat="server" AutoGenerateColumns="false"
        OnNeedDataSource="patFormGrid_NeedDataSource" AllowPaging="True" AllowSorting="true"
        AllowFilteringByColumn="false" GroupingSettings-CaseSensitive="false" PageSize="15"
        Width="100%" EnableEmbeddedSkins="false" Skin="Prodigy" HorizontalAlign="Center">
        <MasterTableView TableLayout="Auto" DataKeyNames="PersonFormId"
            ClientDataKeyNames="PersonFormId">
            <Columns>
                <telerik:GridBoundColumn DataField="PersonFormId" SortExpression="PersonFormId" FilterControlWidth="85%"
                    AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderText="ID" UniqueName="colPersonFormId">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="IsComplete" SortExpression="IsComplete" FilterControlWidth="85%"
                    AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderText="Complete">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="IsReportable" SortExpression="IsReportable" FilterControlWidth="85%"
                    AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderText="Reportable">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="DateCreated" SortExpression="DateCreated" FilterControlWidth="85%"
                    AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderText="Date Created">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="CreateUserName" SortExpression="CreateUserName" FilterControlWidth="85%"
                    AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderText="Created By">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="DateUpdated" FilterControlWidth="85%"
                    AutoPostBackOnFilter="true" ShowFilterIcon="false" SortExpression="DateUpdated" HeaderText="Date Updated" >
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="UpdateUserName" HeaderText="Updated By" FilterControlWidth="85%"
                    AutoPostBackOnFilter="true" ShowFilterIcon="false" SortExpression="UpdateUserName">
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
            <telerik:RadMenuItem Text="View/Edit Form" Value="Edit" />
            <telerik:RadMenuItem Text="View Report" Value="Report" />
            <telerik:RadMenuItem IsSeparator="true"></telerik:RadMenuItem>
            <telerik:RadMenuItem Text="Delete Form" Value="Delete" Enabled="false" />
        </Items>
    </telerik:RadContextMenu>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="EditButtonsPlaceholder" runat="server">
</asp:Content>

