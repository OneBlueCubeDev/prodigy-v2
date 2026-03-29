<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master"
    AutoEventWireup="true" CodeBehind="ReviewLessonPlans.aspx.cs" Inherits="POD.Pages.LessonPlans.ReviewLessonPlans" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <telerik:RadAjaxManagerProxy ID="RadAjaxManager1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGridLessonPlanSet">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridLessonPlanSet" />
                      <telerik:AjaxUpdatedControl ControlID="LiteralMessage"/>
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="ButtonApprove">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridLessonPlanSet" />
                  
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>
   <div class="tabcontainer widetabcontainer">
        <div class="tabcontent">
            <h2 class="AdminHeader">
                Review Lesson Plans</h2>
            <p>
                On this screen you may select all the Lesson Plan Sets you want to approve and then
                click the "Approve all Selected" to update multiple records. At any point you can
                select the pencil to edit any of the lesson plan sets to set them to completed to
                denied or any other available status.</p>
            <asp:Panel ID="PanelLessonPlan" runat="server" CssClass="ClassSearchPanel ReviewLessonPlanSearch">
                <div class="LessonPlanInfoFields">
                    <div class="LessonPlanInfoFieldsLeft">
                        <div class="InputWrapper row">
                            <asp:Label ID="Label10" runat="server" Text="Class Name" class="mylabel" AssociatedControlID="TextBoxClassName"></asp:Label>
                            <asp:TextBox ID="TextBoxClassName" runat="server" class="myfield" Width="199px"></asp:TextBox>
                        </div>
                        <div class="InputWrapper row">
                            <asp:Label ID="Label12" runat="server" Text="Instructor" class="mylabel" AssociatedControlID="RadComboBoxClassInstructor"></asp:Label>
                            <telerik:RadComboBox ID="RadComboBoxClassInstructor" DataValueField="PersonID" DataTextField="FullName"
                                AppendDataBoundItems="true" runat="server" CssClass="mydropdown" Height="100%" 
                                Width="206px">
                                <Items>
                                    <telerik:RadComboBoxItem Text="All" Value="" />
                                </Items>
                            </telerik:RadComboBox>
                        </div>
                        <div class="InputWrapper row">
                            <asp:Label ID="Label13" runat="server" Text="Type" class="sidelabel mylabel InstructorAssistantLabel"
                                AssociatedControlID="RadComboBoxLessonPlanType"></asp:Label>
                            <telerik:RadComboBox ID="RadComboBoxLessonPlanType" DataValueField="LessonPlanTypeID"
                                DataTextField="Name" AppendDataBoundItems="true" runat="server" CssClass="mydropdown InstructorAssistantField"
                                Height="100%" Width="206px">
                                <Items>
                                    <telerik:RadComboBoxItem Text="All" Value="" />
                                </Items>
                            </telerik:RadComboBox>
                        </div>
                    </div>
                    <div class="LessonPlanInfoFieldsRight">
                        <div class="InputWrapper row">
                            <asp:Label ID="Label11" runat="server" Text="Site" class="mylabel" AssociatedControlID="RadComboBoxSite"></asp:Label>
                            <telerik:RadComboBox ID="RadComboBoxSite" AppendDataBoundItems="true" DataValueField="LocationID"
                                DataTextField="SiteName" runat="server" AutoPostBack="true" CssClass="mydropdown" Height="100%" Width="206px" OnSelectedIndexChanged="RadComboBoxSiteLesson_OnSelectedIndexChanged">
                                <Items>
                                    <telerik:RadComboBoxItem Text="All" Value="" />
                                </Items>
                            </telerik:RadComboBox>
                        </div>
                        <div class="InputWrapper row">
                            <asp:Label ID="Label1" runat="server" Text="Location" class="mylabel" AssociatedControlID="RadComboBoxLocation"></asp:Label>
                            <telerik:RadComboBox ID="RadComboBoxLocation" AppendDataBoundItems="true" DataValueField="LocationID"
                                DataTextField="Name" runat="server" CssClass="mydropdown" Height="100%" Width="206px">
                                <Items>
                                    <telerik:RadComboBoxItem Text="All" Value="" />
                                </Items>
                            </telerik:RadComboBox>
                        </div>
                        <div class="InputWrapper row">
                            <asp:Label ID="LabelStatus" runat="server" Text="Status" class="mylabel" AssociatedControlID="RadComboBoxStatusLPS"></asp:Label>
                            <telerik:RadComboBox DataTextField="Description" DataValueField="StatusTypeID" DataSourceID="DataSourceLPSStatus"
                                ID="RadComboBoxStatusLPS" runat="server" AppendDataBoundItems="true" EnableEmbeddedSkins="false"
                                SkinID="Prodigy" CssClass="mydropdown" Width="206px" Height="100%">
                                <Items>
                                    <telerik:RadComboBoxItem Text="Select Status" Value="" />
                                </Items>
                            </telerik:RadComboBox>
                        </div>
                    </div>
                </div>
            </asp:Panel>
            <asp:Button ID="SearchButton" runat="server" Text="Search" OnClick="Searchbutton_Click"
                class="mybutton mysidebutton" />
            <div class="sidebarclear">
            </div>
            <div class="sectionDivider">
            </div>
            <div class="sidebarclear">
            </div>
            <div class="ApproveAll">
                <asp:Button CssClass="mybutton" runat="server" ID="ButtonApprove" Text="Approve all Selected"
                    OnClick="ButtonApprove_Click" />
            </div>
            <p>
                <asp:Literal runat="server" ID="LiteralMessage"></asp:Literal>
            </p>
            <telerik:RadGrid ID="RadGridLessonPlanSet" OnItemDataBound="RadGridLessonPlanSet_ItemDataBound"  
                runat="server" AutoGenerateColumns="False" AllowSorting="True" AllowMultiRowSelection="False"
                AllowPaging="True" PageSize="10" Skin="Prodigy" EnableEmbeddedSkins="false" MasterTableView-TableLayout="Fixed"
                OnDetailTableDataBind="RadGridLessonPlanSet_DetailTableBind" OnEditCommand="RadGridLessonPlanSet_EditCommand"
                OnInsertCommand="RadGridLessonPlanSet_InsertCommand" OnItemCommand="RadGridLessonPlanSet_ItemCommand"
                OnNeedDataSource="RadGridLessonPlanSet_NeedDataSource" CssClass="ReviewLessonPlansGrid">
                <PagerStyle Mode="NumericPages"></PagerStyle>
                <MasterTableView ClientDataKeyNames="LessonPlanSetID" DataKeyNames="LessonPlanSetID, StatusTypeID,InstructorPersonID"
                    AllowMultiColumnSorting="True" HierarchyLoadMode="ServerOnDemand" NoMasterRecordsText="No Lesson Plans are found." TableLayout="Auto">
                    <Columns>
                        <telerik:GridTemplateColumn ItemStyle-Width="30px" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:CheckBox ID="CheckBoxApproval" runat="server" />
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
                        <telerik:GridBoundColumn DataField="Name" SortExpression="Name" HeaderText=" Lesson Plan Set Name">
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
                        <telerik:GridButtonColumn ButtonType="ImageButton" ItemStyle-Width="7%" CommandArgument="Edit"
                            CommandName="Edit" ImageUrl="~/App_Themes/Prodigy/Grid/edit.gif" ItemStyle-HorizontalAlign="Center"
                            ShowFilterIcon="False" UniqueName="EditColumn" ButtonCssClass="IconButton PencilButton"
                            HeaderStyle-HorizontalAlign="Center">
                        </telerik:GridButtonColumn>
                        <telerik:GridButtonColumn ButtonType="ImageButton" ItemStyle-Width="7%" CommandArgument="Delete"
                            CommandName="Delete" ImageUrl="~/App_Themes/Prodigy/Grid/Delete.png" ItemStyle-HorizontalAlign="Center"
                            ShowFilterIcon="False" UniqueName="DeleteDetailColumn" ButtonCssClass="IconButton PencilButton"
                            HeaderStyle-HorizontalAlign="Center">
                        </telerik:GridButtonColumn>
                    </Columns>
                    <DetailTables>
                        <telerik:GridTableView AllowSorting="true" AllowPaging="false" ShowHeader="true"
                            Name="LessonPlanDetail" NoDetailRecordsText="No Lesson Plan Created yet" ClientDataKeyNames="LessonPlanID"
                            DataKeyNames="LessonPlanID,LessonPlanSetID" DataSourceID="DataSourceLessonPlan"
                            CommandItemDisplay="Top" Width="100.25%">
                            <CommandItemSettings AddNewRecordImageUrl="~/App_Themes/Prodigy/Grid/Add.gif" AddNewRecordText="Add New Lesson Plan"
                                RefreshText=" " RefreshImageUrl="~/App_Themes/Prodigy/Grid/Refresh.png" />
                            <ParentTableRelation>
                                <telerik:GridRelationFields DetailKeyField="LessonPlanSetID" MasterKeyField="LessonPlanSetID" />
                            </ParentTableRelation>
                            <Columns>
                                <telerik:GridBoundColumn DataField="Name" SortExpression="Name" ItemStyle-Width="150px"
                                    HeaderText="Name" HeaderStyle-Width="150px" FilterControlWidth="85%">
                                </telerik:GridBoundColumn>
                              <telerik:GridBoundColumn DataField="WeekNumber" SortExpression="WeekNumber"
                                    UniqueName="colweek" HeaderText="Lesson Pan #">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="AgeGroup.Name" SortExpression="AgeGroup.Name"
                                    UniqueName="colAgeGroup" HeaderText="Age Group" ItemStyle-Width="50px" HeaderStyle-Width="50px">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Site.Name" SortExpression="Site.Name" UniqueName="colSite"
                                    HeaderText="Site">
                                </telerik:GridBoundColumn>
                                  <%--<telerik:GridBoundColumn DataField="CommunityTheme" SortExpression="CommunityTheme"
                            UniqueName="colTheme" HeaderText="Community Theme" ItemStyle-Width="150px" HeaderStyle-Width="150px">
                        </telerik:GridBoundColumn>--%>
                                <telerik:GridBoundColumn DataField="Topic" SortExpression="Topic" AutoPostBackOnFilter="true"
                                    HeaderText="Art Activity">
                                </telerik:GridBoundColumn>
                                <telerik:GridButtonColumn ButtonType="ImageButton" ItemStyle-Width="7%" CommandArgument="Edit"
                                    CommandName="Edit" ImageUrl="~/App_Themes/Prodigy/Grid/edit.gif" ItemStyle-HorizontalAlign="Center"
                                    ShowFilterIcon="False" UniqueName="EditDetailColumn" ButtonCssClass="IconButton PencilButton"
                                    HeaderStyle-HorizontalAlign="Center">
                                </telerik:GridButtonColumn>
                                <telerik:GridButtonColumn ButtonType="ImageButton" ItemStyle-Width="7%" CommandArgument="Delete"
                                    CommandName="Delete" ImageUrl="~/App_Themes/Prodigy/Grid/Delete.png" ItemStyle-HorizontalAlign="Center"
                                    ShowFilterIcon="False" UniqueName="DeleteDetailColumn" ButtonCssClass="IconButton PencilButton"
                                    HeaderStyle-HorizontalAlign="Center">
                                </telerik:GridButtonColumn>
                            </Columns>
                        </telerik:GridTableView>
                    </DetailTables>
                </MasterTableView>
            </telerik:RadGrid>
        </div>
    </div>
    <asp:EntityDataSource ID="DataSourceLessonPlan" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" EnableFlattening="False" EntitySetName="LessonPlans"
        Include="DisciplineType,AgeGroup,Site"  Where="it.[LessonPlanSetID] == @LessonPlanSetID">
        <WhereParameters>
            <asp:SessionParameter Name="LessonPlanSetID" SessionField="LessonPlanSetID" Type="Int32" />
        </WhereParameters>
    </asp:EntityDataSource>
    <asp:EntityDataSource ID="DataSourceLPSStatus" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" EnableFlattening="False" EntitySetName="StatusTypes"
        OrderBy="it.[Name]" Where='it.[Category]=="LessonPlanSet"'>
    </asp:EntityDataSource>
</asp:Content>
