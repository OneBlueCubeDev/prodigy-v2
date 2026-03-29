<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/Admin.Master"
    AutoEventWireup="true" CodeBehind="Classes.aspx.cs" Inherits="POD.Pages.ManageClasses.Classes" %>

<%@ Register Src="../../UserControls/ClassesLinks.ascx" TagName="ClassesLinks" TagPrefix="uc2" %>
<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceholderHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
    <uc2:ClassesLinks ID="ClassesLinks1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="DashBoardContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="SidebarContentPlaceholder" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <telerik:RadAjaxManagerProxy ID="RadAjaxManager1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGridCourses">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridCourses" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>
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
                    var proceed = confirm("Are you sure you want to delete this class and all related schedules?");
                    if (!proceed) {
                        eventArgs.set_cancel(true);
                    }
                }
            }
        </script>
    </telerik:RadCodeBlock>
    <telerik:RadGrid ID="RadGridCourses" runat="server" OnNeedDataSource="RadGridCourses_NeedDataSource"
        AutoGenerateColumns="false" AllowPaging="true" PageSize="15" Skin="Prodigy" EnableEmbeddedSkins="false"
        allowsorting="True"
        AllowFilteringByColumn="false" GroupingSettings-CaseSensitive="false" MasterTableView-TableLayout="Fixed">
        <MasterTableView DataKeyNames="CourseInstanceID, CourseID" ClientDataKeyNames="CourseInstanceID, CourseID"
            CommandItemDisplay="Top" NoMasterRecordsText="No Classes were found">
            <CommandItemTemplate>
            </CommandItemTemplate>
            <ItemStyle />
            <AlternatingItemStyle />
            <Columns>
                <telerik:GridBoundColumn DataField="Course.Name" SortExpression="Course.Name" HeaderText="Name"
                    FilterControlWidth="85%" AutoPostBackOnFilter="true" ShowFilterIcon="false">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="StartDate" DataFormatString="{0:d}" UniqueName="colStartDate"
                    SortExpression="StartDate" FilterControlWidth="85%" AutoPostBackOnFilter="true"
                    ShowFilterIcon="false" HeaderText="Start Date" ItemStyle-Width="70px" HeaderStyle-Width="70px"
                    ItemStyle-HorizontalAlign="Center">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="EndDate" DataFormatString="{0:d}" FilterControlWidth="85%"
                    AutoPostBackOnFilter="true" ShowFilterIcon="false" SortExpression="EndDate" UniqueName="colEndDate"
                    HeaderText="End Date" ItemStyle-Width="70px" HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="Site.Name" UniqueName="colLocation" FilterControlWidth="85%"
                    AutoPostBackOnFilter="true" ShowFilterIcon="false" SortExpression="Site.Name"
                    HeaderText="Location">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="Instructor.FullName" UniqueName="colInstructor"
                    FilterControlWidth="85%" AutoPostBackOnFilter="true" ShowFilterIcon="false" SortExpression="Instructor.FullName"
                    HeaderText="Instructor" HeaderStyle-Width="150px">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="ClassCount" SortExpression="ClassCount" AllowFiltering="false"
                    HeaderText="# of Classes" ItemStyle-Width="80px" HeaderStyle-Width="80px" ItemStyle-HorizontalAlign="Center">
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
            <telerik:RadMenuItem Text="Manage Registration" Value="Registration">
            </telerik:RadMenuItem>
        </Items>
    </telerik:RadContextMenu>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="EditButtonsPlaceholder" runat="server">
</asp:Content>
