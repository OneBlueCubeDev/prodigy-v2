<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master"
    AutoEventWireup="true" CodeBehind="Communities.aspx.cs" Inherits="POD.Pages.Admin.ManageCommunities.Communities" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server" EnableAJAX="true">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGridCourses">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridCourses" LoadingPanelID="RadAjaxLoadingPanel1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadGridLessonPlan">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridLessonPlan" LoadingPanelID="RadAjaxLoadingPanel1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>
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
            function RowContextMenuLP(sender, eventArgs) {
                var menu = $find("<%=RadContextMenuLP.ClientID %>");
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
            function RadContextMenuCT(sender, eventArgs) {
                var menu = $find("<%=RadContextMenuCT.ClientID %>");
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
                    var url = '/Pages/Admin/ManageCommunities/CommunityPage.aspx?type=' + type + '&cid=' + id;
                    //open new window
                    var owind = window.radopen(url, "EditCCC");
                    owind.set_visibleStatusbar(false);
                }

            }

            function OnClicking(sender, eventArgs) {
                var item = eventArgs.get_item();
                var id = $("#radGridClickedRowIndex").val();
                if (item.get_value() == "DeleteCommunity" || item.get_value() == "DeleteCircuit" || item.get_value() == "DeleteCounty") {
                    var proceed = confirm("Are you sure you want to delete this item?");
                    if (!proceed) {
                        eventArgs.set_cancel(true);
                    }
                }
                if (item.get_value() == "Community") {
                    var row = $find('<%= RadGridCommunities.ClientID %>').get_masterTableView().get_dataItems()[id];
                    item.blur();
                    ShowDetail("com", row.getDataKeyValue("CommunityID"));
                   
                }
                if (item.get_value() == "Circuit") {
                    var row = $find('<%= RadGridCircuits.ClientID %>').get_masterTableView().get_dataItems()[id];
                    item.blur();
                    ShowDetail("circuit", row.getDataKeyValue("CircuitID"));

                }
                if (item.get_value() == "County") {
                    var row = $find('<%= RadGridCounties.ClientID %>').get_masterTableView().get_dataItems()[id];
                    item.blur();
                    ShowDetail("county", row.getDataKeyValue("CountyID"));

                }
            }
        </script>
    </telerik:RadCodeBlock>
    <div class="CommunitiesOverview">
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" EnableSkinTransparency="true"
            runat="server">
        </telerik:RadAjaxLoadingPanel>
        <h2 class="AdminHeader">Manage Communities</h2>
          <p>If you wish to filter any of these list, please enter your keyword in the input of the appropriate column and then click on the <span class="FilterIcon"><em>filter icon</em></span> next to the input to see filter options. The list will then filter based on your selection the data for you. </p>
  
        <div class="CommunityListWrapper">
            <h3>
                Communities</h3>
            <telerik:RadGrid ID="RadGridCommunities" runat="server" DataSourceID="DataSourceCommunity"
             OnInit="RadGridCommunities_Init"
                AutoGenerateColumns="false" AllowPaging="true" PageSize="15" Skin="Prodigy" EnableEmbeddedSkins="false"
                AllowFilteringByColumn="true" GroupingSettings-CaseSensitive="false" MasterTableView-TableLayout="Fixed">
                <MasterTableView DataKeyNames="CommunityID" ClientDataKeyNames="CommunityID" CommandItemDisplay="Top"
                    NoMasterRecordsText="No Communities were found">
                    <CommandItemTemplate>
                    </CommandItemTemplate>
                    <ItemStyle />
                    <AlternatingItemStyle />
                    <Columns>
                        <telerik:GridBoundColumn DataField="Name" SortExpression="Name" ItemStyle-Width="70%"
                            HeaderText="Name" HeaderStyle-Width="260px" FilterControlWidth="85%" AutoPostBackOnFilter="true"
                            ShowFilterIcon="true">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Description" MaxLength="200" SortExpression="Description"
                            FilterControlWidth="85%" AutoPostBackOnFilter="true" ShowFilterIcon="true" HeaderText="Type">
                        </telerik:GridBoundColumn>
                    </Columns>
                </MasterTableView>
                <ClientSettings>
                    <ClientEvents OnRowClick="RowContextMenu"></ClientEvents>
                    <Selecting AllowRowSelect="true" />
                </ClientSettings>
            </telerik:RadGrid>
            <input type="hidden" id="radGridClickedRowIndex" name="radGridClickedRowIndex" />
            <telerik:RadContextMenu ID="RadMenuOptions" OnClientItemClicking="OnClicking"  runat="server"
                OnItemClick="RadMenu1_ItemClick" EnableRoundedCorners="true" EnableShadows="true">
                <Items>
                    <telerik:RadMenuItem Text="Edit Community" Value="Community"  PostBack="false" />
                    <telerik:RadMenuItem Text="Delete Community" Value="DeleteCommunity" />
                </Items>
            </telerik:RadContextMenu>
            <asp:EntityDataSource ID="DataSourceCommunity" runat="server" ConnectionString="name=PODContext"
              DefaultContainerName="PODContext"  EnableFlattening="False" EntitySetName="Communities"
                OrderBy="it.[Name]">
            </asp:EntityDataSource>
        </div>
        <div class="CommunityListWrapper">
        <div class="CircuitListWrapper">
            <h3>
                Circuits</h3>
            <telerik:RadGrid ID="RadGridCircuits" runat="server" AutoGenerateColumns="false"
             OnInit="RadGridCircuits_Init"
                DataSourceID="DataSourceCircuit" AllowPaging="true" PageSize="10" Skin="Prodigy"
                EnableEmbeddedSkins="false" AllowFilteringByColumn="true" GroupingSettings-CaseSensitive="false"
                MasterTableView-TableLayout="Fixed">
                <MasterTableView DataKeyNames="CircuitID" ClientDataKeyNames="CircuitID" CommandItemDisplay="Top"
                    NoMasterRecordsText="No Circuits were found">
                    <CommandItemTemplate>
                    </CommandItemTemplate>
                    <ItemStyle />
                    <AlternatingItemStyle />
                    <Columns>
                        <telerik:GridBoundColumn DataField="Name" SortExpression="Name" ItemStyle-Width="70%"
                            HeaderText="Name" HeaderStyle-Width="100px" FilterControlWidth="85%" AutoPostBackOnFilter="true"
                            ShowFilterIcon="true">
                        </telerik:GridBoundColumn>
                    </Columns>
                </MasterTableView>
                <ClientSettings>
                    <ClientEvents OnRowClick="RowContextMenuLP"></ClientEvents>
                    <Selecting AllowRowSelect="true" />
                </ClientSettings>
            </telerik:RadGrid>
            <telerik:RadContextMenu ID="RadContextMenuLP" runat="server" OnItemClick="RadMenu1_ItemClick"
                EnableRoundedCorners="true" EnableShadows="true" OnClientItemClicking="OnClicking">
                <Items>
                    <telerik:RadMenuItem Text="Edit Circuit" Value="Circuit" PostBack="false" />
                    <telerik:RadMenuItem Text="Delete Circuit" Value="DeleteCircuit" />
                </Items>
            </telerik:RadContextMenu>
            <asp:EntityDataSource ID="DataSourceCircuit" runat="server" ConnectionString="name=PODContext"
              DefaultContainerName="PODContext"  EnableFlattening="False" EntitySetName="Circuits"
                OrderBy="it.[Name]">
            </asp:EntityDataSource>
        </div>
        <br />
        <div class="CountiesListWrapper">
            <h3>
                Counties</h3>
            <telerik:RadGrid ID="RadGridCounties" runat="server" AutoGenerateColumns="false"
             OnInit="RadGridCounties_Init"
                DataSourceID="DataSourceCounty" AllowPaging="true" PageSize="10" Skin="Prodigy"
                EnableEmbeddedSkins="false" AllowFilteringByColumn="true" GroupingSettings-CaseSensitive="false"
                MasterTableView-TableLayout="Fixed">
                <MasterTableView DataKeyNames="CountyID" ClientDataKeyNames="CountyID" CommandItemDisplay="Top"
                    NoMasterRecordsText="No Counties were found">
                    <CommandItemTemplate>
                    </CommandItemTemplate>
                    <ItemStyle />
                    <AlternatingItemStyle />
                    <Columns>
                        <telerik:GridBoundColumn DataField="Name" SortExpression="Name" ItemStyle-Width="70%"
                            HeaderText="Name" HeaderStyle-Width="100px" FilterControlWidth="85%" AutoPostBackOnFilter="true"
                            ShowFilterIcon="true">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Circuit.Name" SortExpression="Circuit.Name" ItemStyle-Width="70%"
                            HeaderText="Circuit" HeaderStyle-Width="100px" FilterControlWidth="85%" AutoPostBackOnFilter="true"
                            ShowFilterIcon="true">
                        </telerik:GridBoundColumn>
                    </Columns>
                </MasterTableView>
                <ClientSettings>
                    <ClientEvents OnRowClick="RadContextMenuCT"></ClientEvents>
                    <Selecting AllowRowSelect="true" />
                </ClientSettings>
            </telerik:RadGrid>
            <telerik:RadContextMenu ID="RadContextMenuCT" runat="server" OnItemClick="RadMenu1_ItemClick"
                EnableRoundedCorners="true" EnableShadows="true" OnClientItemClicking="OnClicking">
                <Items>
                    <telerik:RadMenuItem Text="Edit County" Value="County" PostBack="false" />
                    <telerik:RadMenuItem Text="Delete County" Value="DeleteCounty" />
                </Items>
            </telerik:RadContextMenu>
            <asp:EntityDataSource ID="DataSourceCounty" runat="server" ConnectionString="name=PODContext"
              DefaultContainerName="PODContext"  EnableFlattening="False" Include="Circuit"
                EntitySetName="Counties" OrderBy="it.[Name]">
            </asp:EntityDataSource>
        </div>
        </div>
    </div>
</asp:Content>
