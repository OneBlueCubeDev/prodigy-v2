<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/Admin.Master"
    AutoEventWireup="true" CodeBehind="LessonPlans.aspx.cs" Inherits="POD.Pages.LessonPlans.LessonPlans" %>
<%@ Register Src="~/UserControls/SearchSideBar.ascx" TagName="SearchSideBar" TagPrefix="uc1" %>
<%@ Register Src="../../UserControls/ClassesLinks.ascx" TagName="ClassesLinks" TagPrefix="uc2" %>
<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
<%--<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
    <uc2:ClassesLinks ID="ClassesLinks1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <telerik:RadScriptBlock runat="server">
        <script type="text/javascript">
            $(document).ready(function () {
               
                

            });

            

            </script>
    </telerik:RadScriptBlock>
    <telerik:RadAjaxManagerProxy ID="RadAjaxManager1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGridLessonPlanSet">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridLessonPlanSet" />
                    <telerik:AjaxUpdatedControl ControlID="LiteralMessage"/>
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
         <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadAjaxManager1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridLessonPlanSet" />
                      <telerik:AjaxUpdatedControl ControlID="LiteralMessage"/>
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>
 <p><asp:Literal runat="server" ID="LiteralMessage"></asp:Literal></p>
    <telerik:RadGrid ID="RadGridLessonPlanSet"  OnNeedDataSource="RadGridLessonPlanSet_NeedDataSource"
        OnItemDataBound="RadGridLessonPlanSet_ItemDataBound" runat="server" AutoGenerateColumns="False"
        AllowSorting="True" AllowMultiRowSelection="False" AllowPaging="True" PageSize="10"
        Skin="Prodigy" EnableEmbeddedSkins="false" OnPreRender="RadGridLessonPlanSet_OnPreRender" MasterTableView-TableLayout="Auto"
        OnDetailTableDataBind="RadGridLessonPlanSet_DetailTableBind" OnEditCommand="RadGridLessonPlanSet_EditCommand"
        OnInsertCommand="RadGridLessonPlanSet_InsertCommand" OnItemCommand="RadGridLessonPlanSet_ItemCommand" CssClass="widetabcontainer LessonPlanSetGrid">
        <PagerStyle Mode="NumericPages"></PagerStyle>
        <MasterTableView  ClientDataKeyNames="LessonPlanSetID"
            DataKeyNames="LessonPlanSetID, StatusTypeID,InstructorPersonID" AllowMultiColumnSorting="True"
            HierarchyLoadMode="ServerOnDemand" ExpandCollapseColumn-ItemStyle-CssClass="DetailTableExpandedCell" >
            <Columns>
                   
                <telerik:GridBoundColumn DataField="Name" SortExpression="Name" HeaderText="Lesson Set Name">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="Instructor.FirstName" SortExpression="Instructor.FirstName"
                    HeaderText="Instructor First Name">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="Instructor.LastName" SortExpression="Instructor.LastName"
                    HeaderText="Instructor Last Name">
                </telerik:GridBoundColumn>
                  <telerik:GridBoundColumn DataField="StatusType.Description" SortExpression="StatusType.Description"
                    HeaderText="Status">
                </telerik:GridBoundColumn>
             <telerik:GridTemplateColumn ItemStyle-HorizontalAlign="Center" >
                <ItemTemplate>
                <asp:Label ID="Label" runat="server" Text="" CssClass="InactiveEditButton" ToolTip="No Access"></asp:Label>
                <asp:ImageButton ID="Imagebutton" runat="server" ImageUrl="~/App_Themes/Prodigy/Grid/edit.gif" CommandName="Edit" CssClass="GridEditButton" />
                
                
                </ItemTemplate>
                </telerik:GridTemplateColumn>
                <telerik:GridTemplateColumn ItemStyle-Width="5%" HeaderStyle-HorizontalAlign="Center" 
                            UniqueName="DeleteLPColumn" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="5%"
                            ShowFilterIcon="False" HeaderTooltip="Delete Lesson Plan">
                            <ItemTemplate>
                                <asp:ImageButton ID="ImagebuttonDelete" runat="server" ImageUrl="~/App_Themes/Prodigy/Grid/Delete.png" CommandName="Delete" CssClass="GridDeleteButton" />
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>

                 <telerik:GridTemplateColumn ItemStyle-Width="5%" HeaderStyle-HorizontalAlign="Center" 
                            UniqueName="AssignPeopleColumn" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="5%"
                            ShowFilterIcon="False" HeaderTooltip="Assign Youth to Lesson Plan Set">
                            <ItemTemplate>
                                <asp:ImageButton ID="ManageButton" runat="server" CssClass="IconButton" CommandName="AssignPeople"
                                    CommandArgument="AssignPeople" ImageUrl="~/Templates/Images/youth_mini_icon.png"
                                    ToolTip="Assign Youth to Class" />
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
                 <telerik:GridTemplateColumn ItemStyle-Width="5%" HeaderStyle-HorizontalAlign="Center" 
                            UniqueName="AssignPeopleColumn" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="5%"
                            ShowFilterIcon="False" HeaderTooltip="Assign Youth to Lesson Plan Set">
                            <ItemTemplate>
                                <asp:ImageButton ID="CopyButton" runat="server" CssClass="IconButton" CommandName="CopyLesson"
                                    CommandArgument="CopyLesson" ImageUrl="~/Templates/Images/copy.png"
                                    ToolTip="Duplicate the Lesson Plan Set" />
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
             </Columns>
            <DetailTables>
                <telerik:GridTableView AllowSorting="true" HeaderStyle-Width="500" AllowPaging="false" ShowHeader="true"
                    Name="LessonPlanDetail" NoDetailRecordsText="No Lesson Plan Created yet" ClientDataKeyNames="LessonPlanID"
                    DataKeyNames="LessonPlanID,LessonPlanSetID" DataSourceID="DataSourceLessonPlan"
                    CommandItemDisplay="Top" CommandItemStyle-Width="500px" CommandItemStyle-BorderColor="Black" CommandItemStyle-BorderWidth="1" >
                    <CommandItemSettings AddNewRecordImageUrl="~/App_Themes/Prodigy/Grid/Add.gif" AddNewRecordText="Add New Lesson Plan"
                        RefreshText="" RefreshImageUrl="~/App_Themes/Prodigy/Grid/Refresh.png" />
                    <%--<CommandItemSettings AddNewRecordImageUrl="~/App_Themes/Prodigy/Grid/print.png" AddNewRecordText="Print All Lesson Plans"
                        RefreshText="" RefreshImageUrl="~/App_Themes/Prodigy/Grid/Refresh.png" />--%>
                    
<%--                    <CommandItemTemplate >
   <table >
        <tr>
            <td width="30%">
                <asp:LinkButton ID="LinkButton8" Text="Add new item" CommandName="InitInsert" runat="server"></asp:LinkButton>
            </td>
            <td width="40%">
            </td>
            <td width="30%">
                <asp:LinkButton ID="LinkButton9" Text="Refresh data" CommandName="Rebind" runat="server"></asp:LinkButton>
            </td>
        </tr>
    </table>
</CommandItemTemplate>--%>
                    <ParentTableRelation>
                        <telerik:GridRelationFields DetailKeyField="LessonPlanSetID" MasterKeyField="LessonPlanSetID" />
                    </ParentTableRelation>
                    <Columns>
                        
                        <telerik:GridBoundColumn DataField="Name" SortExpression="Name" ItemStyle-Width="150px"
                            HeaderText="Name" HeaderStyle-Width="150px" FilterControlWidth="85%">
                        </telerik:GridBoundColumn>
                        
                        <telerik:GridBoundColumn DataField="WeekNumber" SortExpression="WeekNumber" UniqueName="colWeek"
                            HeaderText="Lesson Plan #">
                        </telerik:GridBoundColumn> 
                        
                        <telerik:GridBoundColumn DataField="AgeGroup.Name" SortExpression="AgeGroup.Name"
                            UniqueName="colAgeGroup" HeaderText="Age Group" ItemStyle-Width="120px" HeaderStyle-Width="120px">
                        </telerik:GridBoundColumn>
                        
                        <telerik:GridBoundColumn DataField="Site.Name" SortExpression="Site.Name" UniqueName="colSite"
                            HeaderText="Site">
                        </telerik:GridBoundColumn>
                        
                        <telerik:GridBoundColumn DataField="StartDate" SortExpression="StartDate"
                            UniqueName="colStart" HeaderText="Start Date" ItemStyle-Width="70px" HeaderStyle-Width="150px">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="EndDate" SortExpression="EndDate"
                            UniqueName="colEnd" HeaderText="End Date" ItemStyle-Width="150px" HeaderStyle-Width="150px">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Topic" SortExpression="Topic" ItemStyle-Width="300px" HeaderStyle-Width="300px" AutoPostBackOnFilter="true"
                            HeaderText="Art Activity">
                        </telerik:GridBoundColumn>
                        
                         <telerik:GridButtonColumn ButtonType="ImageButton" ItemStyle-Width="7%" CommandArgument="Edit"
                            CommandName="Edit" ImageUrl="~/App_Themes/Prodigy/Grid/edit.gif" ItemStyle-HorizontalAlign="Center"
                            ShowFilterIcon="False" UniqueName="EditDetailColumn" ButtonCssClass="IconButton PencilButton"
                            HeaderStyle-HorizontalAlign="Center">
                        </telerik:GridButtonColumn>
                        
                        <telerik:GridButtonColumn ButtonType="ImageButton" ItemStyle-Width="7%" CommandArgument="View"
                            CommandName="View" ImageUrl="~/Templates/Images/view_mini_icon.png"  ItemStyle-HorizontalAlign="Center"
                            ShowFilterIcon="False" UniqueName="ViewDetailColumn" ButtonCssClass="IconButton PencilButton ViewIcon"
                            HeaderStyle-HorizontalAlign="Center">
                        </telerik:GridButtonColumn>
                        
                        <telerik:GridButtonColumn ButtonType="ImageButton" ItemStyle-Width="7%" CommandArgument="Delete"
                            CommandName="Delete" ImageUrl="~/App_Themes/Prodigy/Grid/Delete.png" ItemStyle-HorizontalAlign="Center"
                            ShowFilterIcon="False" UniqueName="DeleteDetailColumn" ButtonCssClass="IconButton PencilButton"
                            HeaderStyle-HorizontalAlign="Center">
                        </telerik:GridButtonColumn>
                        
                        <telerik:GridButtonColumn ButtonType="ImageButton" ItemStyle-Width="7%" CommandArgument="Class"
                            CommandName="Class" ImageUrl="~/App_Themes/Prodigy/Grid/book.png" ItemStyle-HorizontalAlign="Center"
                            ShowFilterIcon="False" UniqueName="AddClassColumn" ButtonCssClass="IconButton PencilButton"
                            HeaderStyle-HorizontalAlign="Center">
                        </telerik:GridButtonColumn>
                        
                    </Columns>
                </telerik:GridTableView>
            </DetailTables>
        </MasterTableView>
    </telerik:RadGrid>
  
    <asp:EntityDataSource ID="DataSourceLessonPlan" runat="server" ConnectionString="name=PODContext"
      DefaultContainerName="PODContext"  EnableFlattening="False" EntitySetName="LessonPlans"
        Include="DisciplineType,AgeGroup,Site" OrderBy="it.[Name]" Where="it.[LessonPlanSetID] == @LessonPlanSetID">
        <WhereParameters>
            <asp:SessionParameter Name="LessonPlanSetID" SessionField="LessonPlanSetID" Type="Int32" />
        </WhereParameters>
    </asp:EntityDataSource>
   
</asp:Content>
