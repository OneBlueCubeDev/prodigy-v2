<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master"
    AutoEventWireup="true" CodeBehind="ClassCatalogs.aspx.cs" Inherits="POD.Pages.ManageClasses.ClassCatalogs" %>

<%@ Register Src="../../UserControls/ClassesLinks.ascx" TagName="ClassesLinks" TagPrefix="uc2" %>
<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
    <uc2:ClassesLinks ID="ClassesLinks1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server" EnableAJAX="true">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGridCourses">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridCourses" LoadingPanelID="RadAjaxLoadingPanel1" />
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

                if (item.get_value() == "DeleteClass") {
                    var proceed = confirm("Are you sure you want to delete this class?");
                    if (!proceed) {
                        eventArgs.set_cancel(true);
                    }
                }
            }
        </script>
    </telerik:RadCodeBlock>
    <div class="CourseOverview">
        <div class="ClassListWrapper">
            <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" EnableSkinTransparency="true"
                runat="server">
            </telerik:RadAjaxLoadingPanel>
            <h2 class="AdminHeader">Class Catalog</h2>
            <p>If you wish to filter the classes in this list, please enter your keyword and then click on the <span class="FilterIcon"><em>filter icon</em></span> next to the input
            to see filter options. The list will then filter based on your selection the data for you.
            </p>
            <telerik:RadGrid ID="RadGridCourses" runat="server" OnNeedDataSource="RadGridCourses_NeedDataSource"
                AutoGenerateColumns="false" AllowPaging="true" PageSize="15" Skin="Prodigy" EnableEmbeddedSkins="false"
                AllowFilteringByColumn="true" GroupingSettings-CaseSensitive="false" MasterTableView-TableLayout="Fixed"
                CssClass="widetabcontainer" OnInit="RadGridCourses_Init">
                <MasterTableView DataKeyNames="CourseID" ClientDataKeyNames="CourseID" CommandItemDisplay="Top"
                    NoMasterRecordsText="No Clases were found">
                    <CommandItemTemplate>
                    </CommandItemTemplate>
                    <ItemStyle />
                    <AlternatingItemStyle />
                    <Columns>
                        <telerik:GridBoundColumn DataField="Name" SortExpression="Name" ItemStyle-Width="40%"
                            HeaderText="Name" HeaderStyle-Width="250px" FilterControlWidth="85%" AutoPostBackOnFilter="true"
                            ShowFilterIcon="true">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="CourseType.Name" SortExpression="CourseType.Name"
                            FilterControlWidth="85%" AutoPostBackOnFilter="true" UniqueName="colType" ShowFilterIcon="true"
                            HeaderText="Type" HeaderStyle-Width="160px">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="StatusType.Name" UniqueName="colStatus" SortExpression="StatusType.Name"
                            FilterControlWidth="85%" AutoPostBackOnFilter="true" ShowFilterIcon="true" HeaderText="Status"
                            HeaderStyle-Width="160px">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Description" SortExpression="Description" MaxLength="250"
                            FilterControlWidth="85%" AutoPostBackOnFilter="true" ShowFilterIcon="true" HeaderText="Description">
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
                    <telerik:RadMenuItem Text="Edit Schedule" Value="CourseInstances" />
                   <telerik:RadMenuItem Text="Delete Class" Value="DeleteClass" />
                   
                </Items>
            </telerik:RadContextMenu>
            <asp:EntityDataSource ID="DataSourcePrograms" runat="server" ConnectionString="name=PODContext"
              DefaultContainerName="PODContext"  EnableFlattening="False" EntitySetName="Programs"
                OrderBy="it.[Name]">
            </asp:EntityDataSource>
            <asp:EntityDataSource ID="DataSourceCourseTypes" runat="server" ConnectionString="name=PODContext"
              DefaultContainerName="PODContext"  EnableFlattening="False" EntitySetName="CourseTypes"
                OrderBy="it.[Name]">
            </asp:EntityDataSource>
            <asp:EntityDataSource ID="DataSourceStatusTypes" runat="server" ConnectionString="name=PODContext"
              DefaultContainerName="PODContext"  EnableFlattening="False" EntitySetName="StatusTypes"
                OrderBy="it.[Name]">
            </asp:EntityDataSource>
        </div>
    </div>
</asp:Content>
