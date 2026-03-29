<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master"
    AutoEventWireup="true" CodeBehind="Staff.aspx.cs" Inherits="POD.Pages.Admin.ManageStaff.Staff" %>

<%@ Register Src="~/UserControls/StaffLinks.ascx" TagName="StaffLinks" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
    <uc2:StaffLinks ID="StaffLinks1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server" EnableAJAX="true">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGridStaffMembers">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridStaffMembers" LoadingPanelID="RadAjaxLoadingPanel1" />
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
                    var proceed = confirm("Are you sure you want to delete this person?");
                    if (!proceed) {
                        eventArgs.set_cancel(true);
                    }
                }
            }
        </script>
    </telerik:RadCodeBlock>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" EnableSkinTransparency="true"
        runat="server">
    </telerik:RadAjaxLoadingPanel>
    <h2 class="AdminHeader">
        Manage Your Staff</h2>
    <p>
        If you wish to filter the staff members in this list, please enter your keyword and then
        click on the <span class="FilterIcon"><em>filter icon</em></span> next to the input to see filter options. The list will
        then filter based on your selection the data for you.
    </p>
    <telerik:RadGrid ID="RadGridStaffMembers" runat="server" OnNeedDataSource="RadGridStaffMembers_NeedDataSource"
        AutoGenerateColumns="false" AllowPaging="true" PageSize="15" Skin="Prodigy" EnableEmbeddedSkins="false"
        OnInit="RadGridStaffMembers_Init" AllowFilteringByColumn="true" GroupingSettings-CaseSensitive="false"
        CssClass="widetabcontainer">
        <MasterTableView DataKeyNames="PersonID" ClientDataKeyNames="PersonID" CommandItemDisplay="Top"
            NoMasterRecordsText="No Staff Members were found" TableLayout="Fixed">
            <CommandItemTemplate>
            </CommandItemTemplate>
            <ItemStyle />
            <AlternatingItemStyle />
            <Columns>
                <telerik:GridBoundColumn DataField="Title" SortExpression="Title" ItemStyle-Width="7%" UniqueName="colTitle"
                    HeaderText="Employment Title" HeaderStyle-Width="7%" FilterControlWidth="70%" AutoPostBackOnFilter="true"
                    ShowFilterIcon="true">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="FirstName" SortExpression="FirstName" HeaderText="First Name" UniqueName="colFirst"
                    FilterControlWidth="85%" AutoPostBackOnFilter="true" ShowFilterIcon="true">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="LastName" SortExpression="LastName" HeaderText="Last Name" UniqueName="colLAst"
                    FilterControlWidth="85%" AutoPostBackOnFilter="true" ShowFilterIcon="true">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="Email" SortExpression="Email" ItemStyle-Width="25%" UniqueName="colEmail"
                    HeaderText="Email" HeaderStyle-Width="25%" FilterControlWidth="85%" AutoPostBackOnFilter="true" 
                    ShowFilterIcon="true">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="CompanyName" SortExpression="CompanyName" ItemStyle-Width="15%" UniqueName="colCompany"
                    HeaderText="Company" HeaderStyle-Width="15%" FilterControlWidth="85%" AutoPostBackOnFilter="true"
                    ShowFilterIcon="true">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="DateOfBirth" SortExpression="DateOfBirth" ItemStyle-Width="110px" UniqueName="colDOB"
                    HeaderText="Date Of Birth" DataFormatString="{0:MM/dd/yyyy}" HeaderStyle-Width="110px"
                    FilterControlWidth="75%" AutoPostBackOnFilter="true" ShowFilterIcon="true">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="StatusType.Name" SortExpression="StatusType.Name" UniqueName="colStatus"
                    ItemStyle-Width="7%" HeaderText="Status" HeaderStyle-Width="7%" FilterControlWidth="70%"
                    AutoPostBackOnFilter="true" ShowFilterIcon="true">
                </telerik:GridBoundColumn>
                  <telerik:GridBoundColumn DataField="HireDate" SortExpression="HireDate" ItemStyle-Width="110px" UniqueName="colHire"
                    HeaderText="Hire Date" DataFormatString="{0:MM/dd/yyyy}" HeaderStyle-Width="110px"
                    FilterControlWidth="75%" AutoPostBackOnFilter="true" ShowFilterIcon="true">
                </telerik:GridBoundColumn>
                  <telerik:GridBoundColumn DataField="EndDate" SortExpression="EndDate" ItemStyle-Width="110px" UniqueName="colEndDate"
                    HeaderText="End Date" DataFormatString="{0:MM/dd/yyyy}" HeaderStyle-Width="110px"
                    FilterControlWidth="75%" AutoPostBackOnFilter="true" ShowFilterIcon="true">
                </telerik:GridBoundColumn>
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
            <telerik:RadMenuItem Text="Edit Staff Member" Value="Edit" />
            <telerik:RadMenuItem Text="Delete Staff Member" Value="Delete" />
        </Items>
    </telerik:RadContextMenu>
</asp:Content>
