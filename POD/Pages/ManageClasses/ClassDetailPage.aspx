<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master"
    AutoEventWireup="true" CodeBehind="ClassDetailPage.aspx.cs" Inherits="POD.Pages.Admin.ManageProgramsAndCourses.ClassDetailPage" %>

<%@ Register Src="../../UserControls/ClassesLinks.ascx" TagName="ClassesLinks" TagPrefix="uc2" %>
<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
    <uc2:ClassesLinks ID="ClassesLinks1" runat="server" />
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">

    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server" EnableAJAX="false" >
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGridCourseInstance">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridCourseInstance" LoadingPanelID="RadAjaxLoadingPanel1" />
                    <telerik:AjaxUpdatedControl ControlID="RadGridClassess" />
                    <telerik:AjaxUpdatedControl ControlID="LiteralErrorMessage" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadGridClassess">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridClassess" LoadingPanelID="RadAjaxLoadingPanel1" />
                    <telerik:AjaxUpdatedControl ControlID="RadGridCourseInstance" />
                    <telerik:AjaxUpdatedControl ControlID="LiteralErrorMessage" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>

    <div class="tabcontainer widetabcontainer">
        <div class="tabcontent">
            <div class="CourseInfoWrapper">
                <h2>
                    Class Info</h2>
                     <auth:SecureContent ID="SecureContent2" ToggleVisible="false" ToggleEnabled="true" EventHook="Load" runat="server"
                      Roles="Administrators;Administrators-NA;CentralTeamUsers;SiteTeamUsers;">
                <asp:Panel ID="PanelContent" class="FormWrapper DetailPageFormWrapper" runat="server">
                    <div class="InputWrapper row">
                        <asp:Label ID="ClassInfoName" runat="server" Text="Class Name" CssClass="mylabel-right"></asp:Label>
                        <asp:TextBox ID="TextBoxName" runat="server" Width="900" Enabled="False" CssClass="myfield-plain"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="reqValLoc" runat="server" ControlToValidate="TextBoxName"
                            ErrorMessage="Name is required" Display="Dynamic" ValidationGroup="SaveCourse"></asp:RequiredFieldValidator>
                    </div>
                    <div class="InputWrapper row">
                        <asp:Label ID="ClassInfoType" runat="server" Text="Class Type" CssClass="mylabel-right"></asp:Label>
                        <telerik:RadComboBox DataTextField="Name" DataValueField="LessonPlanTypeID" DataSourceID="DataSourceLessonPlanType"
                            ID="RadComboProgramType" runat="server" CssClass="mydropdown">
                        </telerik:RadComboBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="RadComboProgramType"
                            InitialValue="" ErrorMessage="Type is required" Display="Dynamic" ValidationGroup="SaveCourse"></asp:RequiredFieldValidator>
                    </div>
                    <div class="InputWrapper row">
                        <asp:Label ID="ClassInfoStatus" runat="server" Text="Class Status" CssClass="mylabel-right"></asp:Label>
                        <telerik:RadComboBox DataTextField="Name" DataValueField="StatusTypeID" DataSourceID="DataSourceStatusTypes"
                            ID="RadComboStatusType" runat="server" CssClass="mydropdown">
                        </telerik:RadComboBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="RadComboStatusType"
                            InitialValue="" ErrorMessage="Status is required" Display="Dynamic" ValidationGroup="SaveCourse"></asp:RequiredFieldValidator>
                    </div>
                    <div class="InputWrapper row">
                        <asp:Label ID="ClassInfoDescription" runat="server" Text="Class Description" CssClass="mylabel-right"></asp:Label>
                        <telerik:RadEditor ID="RadEditoDesc" CssClass="myfield TextEditor" Width="620" Height="225"
                            AutoResizeHeight="false" AllowScripts="false" SkinID="BasicSetOfTools" EnableEmbeddedSkins="false"
                            Skin="Prodigy" runat="server" EnableResize="False">
                            <Tools>
                                <telerik:EditorToolGroup Tag="MainToolbar">
                                    <telerik:EditorTool Name="AjaxSpellCheck" />
                                    <telerik:EditorTool Name="FindAndReplace" />
                                    <telerik:EditorSeparator Visible="true" />
                                    <telerik:EditorTool Name="Undo" />
                                    <telerik:EditorTool Name="Redo" />
                                    <telerik:EditorSeparator Visible="true" />
                                    <telerik:EditorTool Name="Cut" />
                                    <telerik:EditorTool Name="Copy" />
                                    <telerik:EditorTool Name="Paste" ShortCut="CTRL+!" />
                                </telerik:EditorToolGroup>
                                <telerik:EditorToolGroup Tag="Formatting">
                                    <telerik:EditorTool Name="Bold" />
                                    <telerik:EditorTool Name="Italic" />
                                    <telerik:EditorTool Name="Underline" />
                                    <telerik:EditorSeparator Visible="true" />
                                    <telerik:EditorTool Name="ForeColor" />
                                    <telerik:EditorTool Name="BackColor" />
                                    <telerik:EditorSeparator Visible="true" />
                                    <telerik:EditorTool Name="FontName" />
                                    <telerik:EditorTool Name="RealFontSize" />
                                    <telerik:EditorSeparator Visible="true" />
                                    <telerik:EditorTool Name="InsertOrderedList" />
                                    <telerik:EditorTool Name="InsertUnorderedList" />
                                    <telerik:EditorTool Name="Outdent" />
                                    <telerik:EditorTool Name="Indent" />
                                </telerik:EditorToolGroup>
                            </Tools>
                        </telerik:RadEditor>
                        <br style="clear: both;" />
                    </div>
                 
                </asp:Panel>
                </auth:SecureContent>
            </div>
            <asp:HiddenField ID="HiddenFieldCourseID" runat="server" />
            <asp:Literal ID="LiteralErrorMessage" runat="server"></asp:Literal>
            <div class="sectionDivider">
            </div>
            <h3 class="sectionHead ClassSchedulesHeader">
                Class Schedules</h3>
            <br />
            <p class="ClassSchedulesInstructions">
                You must create the overall class information before creating any details.<br />
                If you want to see the detailed schedule of any of the classes listed in this list
                please click the <span class="CalendarIcon"><em>calendar icon</em></span>. This
                will expand the details so you can add/edit or view them. The <span class="EditIcon">
                    <em>pencil icon</em></span> can be used to edit any record.  
            </p>
            <div class="row">
            </div>
            <telerik:RadGrid ID="RadGridCourseInstance" CssClass="CourseInstanceGrid CommandItemGrid" 
                runat="server" AutoGenerateColumns="false" OnItemDataBound="RadGridCourseInstance_ItemDatabound"
                OnDeleteCommand="RadGridCourseInstance_Delete" OnItemInserted="RadGridCourseInstance_ItemInserted"
                OnItemUpdated="RadGridCourseInstance_ItemUpdated" AllowPaging="True" AllowSorting="true"
                DataSourceID="DataSourceCourseInstance" AllowAutomaticDeletes="false" AllowFilteringByColumn="false"
                GroupingSettings-CaseSensitive="false" PageSize="5" Width="100%" EnableEmbeddedSkins="false"
                Skin="Prodigy" HorizontalAlign="Center" OnItemCommand="RadGridCourseInstance_ItemCommand"
                 OnDetailTableDataBind="RadGridCourseInstance_DetailTableBind"
                OnInsertCommand="RadGridCourseInstance_InsertCommand" OnUpdateCommand="RadGridCourseInstance_UpdateCommand">
                <ClientSettings>
                    <ClientEvents OnCommand="RadGridCourseInstance_Command" />
                </ClientSettings>
                <MasterTableView TableLayout="Auto" EnableNoRecordsTemplate="true"
                    NoMasterRecordsText="No Schedules were found" ClientDataKeyNames="CourseInstanceID,CourseID"
                    DataKeyNames="CourseInstanceID, CourseID, LessonPlanSetID" NoDetailRecordsText="No Schedules were found"
                    HierarchyLoadMode="ServerOnDemand" ExpandCollapseColumn-ItemStyle-CssClass="DetailTableExpandedCell">
                    <%--<CommandItemSettings ShowAddNewRecordButton="true" AddNewRecordImageUrl="../../App_Themes/Prodigy/Grid/Add.gif"
                        AddNewRecordText="Add Class Detail" ShowRefreshButton="true" RefreshImageUrl="../../App_Themes/Prodigy/Grid/Refresh.png"
                        RefreshText="" />--%>
                    <ItemStyle />
                    <AlternatingItemStyle />
                    <Columns>
                        <telerik:GridButtonColumn ButtonType="ImageButton" CommandArgument="Edit" CommandName="Edit"
                            ImageUrl="../../App_Themes/Prodigy/Grid/edit.gif" ShowFilterIcon="False" UniqueName="EditColumn"
                            ButtonCssClass="IconButton PencilButton" ItemStyle-Width="5%" HeaderStyle-HorizontalAlign="Center"
                            ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="5%">
                        </telerik:GridButtonColumn>
                        <telerik:GridBoundColumn DataField="StartDate" DataFormatString="{0:d}" UniqueName="colStartDate"
                            SortExpression="StartDate" FilterControlWidth="85%" AutoPostBackOnFilter="true"
                            ShowFilterIcon="false" HeaderText="Start Date" ItemStyle-Width="10%" HeaderStyle-Width="10%">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="EndDate" DataFormatString="{0:d}" FilterControlWidth="85%"
                            AutoPostBackOnFilter="true" ShowFilterIcon="false" SortExpression="EndDate" UniqueName="colEndDate"
                            HeaderText="End Date" ItemStyle-Width="10%" HeaderStyle-Width="10%">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Site.Name" UniqueName="colLocation" FilterControlWidth="85%"
                            AutoPostBackOnFilter="true" ShowFilterIcon="false" SortExpression="Site.Name"
                            HeaderText="Site">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Instructor.FullName" UniqueName="colInstructor"
                            FilterControlWidth="85%" AutoPostBackOnFilter="true" ShowFilterIcon="false" SortExpression="Instructor.FullName"
                            HeaderText="Instructor">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Assistant.FullName" UniqueName="colAssistant"
                            FilterControlWidth="85%" AutoPostBackOnFilter="true" ShowFilterIcon="false" SortExpression="Assistant.FullName"
                            HeaderText="Assistant">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Notes" FilterControlWidth="85%" AutoPostBackOnFilter="true"
                            ShowFilterIcon="false" SortExpression="Notes" HeaderText="Notes">
                        </telerik:GridBoundColumn>
                       
<%--                        <telerik:GridTemplateColumn ItemStyle-Width="5%" HeaderStyle-HorizontalAlign="Center"
                            UniqueName="AssignPeopleColumn" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="5%"
                            ShowFilterIcon="False" HeaderText="Assign" HeaderTooltip="Assign Youth to Class">
                            <ItemTemplate>
                                <asp:ImageButton ID="ImgButton" runat="server" CssClass="IconButton" CommandName="AssignPeople"
                                    CommandArgument="AssignPeople" ImageUrl="~/Templates/Images/youth_mini_icon.png"
                                    ToolTip="Assign Youth to Class" />
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>--%>
                        <%--<telerik:GridButtonColumn ButtonType="ImageButton" ItemStyle-Width="5%" HeaderStyle-HorizontalAlign="Center"
                            ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="5%" CommandArgument="Delete"
                            CommandName="Delete" ImageUrl="../../App_Themes/Prodigy/Grid/Delete.png" ShowFilterIcon="False"
                            UniqueName="DeleteColumn" ConfirmText="Are you sure you want to delete this Class Detail and all its related data?"
                            ButtonCssClass="IconButton DeleteButton">
                        </telerik:GridButtonColumn>--%>
                    </Columns>
                    <DetailTables>
                        <telerik:GridTableView AllowSorting="true" AllowPaging="true" ShowHeader="true" PageSize="15" 
                            Name="RadGridClassess" ClientDataKeyNames="ClassID, CourseInstanceID" DataKeyNames="ClassID, CourseInstanceID"
                            DataSourceID="DataSourceClassess" Width="100.25%">
                            <%--<CommandItemSettings ShowAddNewRecordButton="true" AddNewRecordImageUrl="../../App_Themes/Prodigy/Grid/Add.gif"
                                AddNewRecordText="Add Schedule" ShowRefreshButton="true" RefreshImageUrl="../../App_Themes/Prodigy/Grid/Refresh.png"
                                RefreshText="" />--%>
                            <ParentTableRelation>
                                <telerik:GridRelationFields DetailKeyField="CourseInstanceID" MasterKeyField="CourseInstanceID" />
                            </ParentTableRelation>
                            <Columns>
                                <telerik:GridButtonColumn ButtonType="ImageButton" ItemStyle-Width="5%" HeaderStyle-HorizontalAlign="Center"
                                    ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="5%" CommandArgument="Edit"
                                    CommandName="Edit" ImageUrl="../../App_Themes/Prodigy/Grid/edit.gif" ShowFilterIcon="False"
                                    UniqueName="EditColumn" ButtonCssClass="IconButton PencilButton">
                                </telerik:GridButtonColumn>
                                <telerik:GridBoundColumn DataField="Name" SortExpression="Name" FilterControlWidth="85%"
                                    AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderText="Name" ItemStyle-Width="16%"
                                    HeaderStyle-Width="16%">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="DateStart" SortExpression="DateStart" FilterControlWidth="85%"
                                    AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderText="Start Date" ItemStyle-Width="10%"
                                    HeaderStyle-Width="10%" DataFormatString="{0:MM/dd/yyyy}">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="DateStart" SortExpression="DateStart" FilterControlWidth="85%"
                                    AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderText="Start Time" ItemStyle-Width="10%"
                                    HeaderStyle-Width="10%" DataFormatString="{0:t}">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="DateEnd" FilterControlWidth="85%" AutoPostBackOnFilter="true"
                                    ShowFilterIcon="false" SortExpression="DateEnd" DataFormatString="{0:t}" HeaderText="End Time"
                                    ItemStyle-Width="10%" HeaderStyle-Width="10%">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Location.Name" FilterControlWidth="85%" AutoPostBackOnFilter="true"
                                    ShowFilterIcon="false" SortExpression="Location.Name" HeaderText="Location">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Site.Name" FilterControlWidth="85%" AutoPostBackOnFilter="true"
                                    ShowFilterIcon="false" SortExpression="Site.Name" HeaderText="Site">
                                </telerik:GridBoundColumn>
                                <%--<telerik:GridBoundColumn DataField="StatusType.Name" FilterControlWidth="85%" AutoPostBackOnFilter="true"
                                    ShowFilterIcon="false" SortExpression="StatusType.Name" HeaderText="Status">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="ClassType.Name" FilterControlWidth="85%" AutoPostBackOnFilter="true"
                                    ShowFilterIcon="false" SortExpression="ClassType.Name" HeaderText="Type">
                                </telerik:GridBoundColumn>--%>
                                <telerik:GridBoundColumn DataField="Instructor.FullName" FilterControlWidth="85%"
                                    AutoPostBackOnFilter="true" ShowFilterIcon="false" UniqueName="colInstructor"
                                    SortExpression="Instructor.FullName" HeaderText="Instructor">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Assistant.FullName" FilterControlWidth="85%"
                                    UniqueName="colAssistant" AutoPostBackOnFilter="true" ShowFilterIcon="false"
                                    SortExpression="Assistant.FullName" HeaderText="Assistant">
                                </telerik:GridBoundColumn>
                               <%-- <telerik:GridButtonColumn ButtonType="ImageButton" ItemStyle-Width="5%" HeaderStyle-HorizontalAlign="Center"
                                    ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="5%" CommandArgument="Delete"
                                    CommandName="Delete" ImageUrl="../../App_Themes/Prodigy/Grid/Delete.png" ShowFilterIcon="False"
                                    UniqueName="DeleteColumn" ConfirmText="Are you sure you want to delete this Schedule and all its related data?"
                                    ButtonCssClass="IconButton DeleteButton">
                                </telerik:GridButtonColumn>--%>
                                 <%--<telerik:GridButtonColumn ButtonType="ImageButton" CommandArgument="print" CommandName="print"
                            ImageUrl="../../App_Themes/Prodigy/Grid/print.png" ShowFilterIcon="False" UniqueName="PrintColumn"
                            ButtonCssClass="IconButton PencilButton" ItemStyle-Width="5%" HeaderText="Sign Up Sheet" HeaderStyle-HorizontalAlign="Center"
                            ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="5%">
                        </telerik:GridButtonColumn>--%>
                            </Columns>
                            <EditFormSettings EditColumn-ButtonType="LinkButton" EditFormType="Template">
                                <FormTemplate>

                                    <asp:HiddenField ID="hfSetIdSch" runat="server" />
                    <asp:HiddenField ID="hfSetNameSch" runat="server" />
                    <asp:HiddenField ID="hfClassNameSch" runat="server" />
                    <asp:HiddenField ID="hfSiteSch" runat="server" />
                    <asp:HiddenField ID="hfLocationSch" runat="server" />
                    <asp:HiddenField ID="hftypeSch" runat="server" />
                    <asp:HiddenField ID="hfAgegroupSch" runat="server" />
                    <asp:HiddenField ID="hfAssistantSch" runat="server" />
                                 <asp:HiddenField ID="hfInstructorSch" runat="server" />

                                    <div class="row">
                                        <asp:Label ID="LabelName" runat="server" Text="Name" CssClass="mylabel-right"></asp:Label>
                                        <asp:Label ID="lblNameSchedule" runat="server" CssClass="myfield-plain"></asp:Label>
                                        <asp:TextBox ID="TextBoxName" Text='<%# Bind("Name") %>' Width="500" Enabled="False" runat="server" CssClass="myfield-plain" ></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="TextBoxName"
                                            InitialValue="" ErrorMessage="Name is required" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>
                                    <%--<div class="row">
                                        <asp:Label ID="Label2" runat="server" Text="Status" CssClass="mylabel-right"></asp:Label>
                                        <telerik:RadComboBox ID="RadComboBoxStatusType" DataSourceID="DataSourceStatusTypes"
                                            DataValueField="StatusTypeID" DataTextField="Name" EmptyMessage="Select Status"
                                            runat="server" EnableEmbeddedSkins="false" SkinID="Prodigy" CssClass="mydropdown">
                                        </telerik:RadComboBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="RadComboBoxStatusType"
                                            InitialValue="" ErrorMessage="Status is required" Display="Dynamic" ValidationGroup="Save"></asp:RequiredFieldValidator>
                                    </div>--%>
                                    <%--<div class="row">
                                        <asp:Label ID="Label3" runat="server" Text="Type" CssClass="mylabel-right"></asp:Label>
                                         <asp:Label ID="lblClassType" runat="server" CssClass="myfield-plain"></asp:Label>
                                        <telerik:RadComboBox ID="RadComboBoxClassTypes" DataSourceID="DataSourceClassTypes"
                                            DataValueField="ClassTypeID" DataTextField="Name" Visible="false" EmptyMessage="Select Type"
                                            runat="server" EnableEmbeddedSkins="false" SkinID="Prodigy" CssClass="mydropdown">
                                        </telerik:RadComboBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="RadComboBoxClassTypes"
                                            InitialValue="" ErrorMessage="Type is required" Display="Dynamic" ValidationGroup="Save"></asp:RequiredFieldValidator>
                                    </div>--%>
                                    <%--<div class="row">
                                        <asp:Label ID="Label1" runat="server" Text="Site" CssClass="mylabel-right"></asp:Label>
                                        <asp:Label ID="lblClassSite" runat="server" CssClass="myfield-plain"></asp:Label>
                                        <telerik:RadComboBox ID="RadComboBoxSite"  Visible="false" DataSourceID="DataSourceSites" DataValueField="LocationID"
                                            DataTextField="Name" EmptyMessage="Select Site" runat="server" EnableEmbeddedSkins="false"
                                            SkinID="Prodigy" CssClass="mydropdown">
                                        </telerik:RadComboBox>
                                        
                                    </div>--%>
                                    <div class="row">
                                        <asp:Label ID="LabelLocation" runat="server" Text="Location" CssClass="mylabel-right"></asp:Label>
                                        <asp:Label ID="lblClassLocation" runat="server" CssClass="myfield-plain"></asp:Label>
                                        <telerik:RadComboBox ID="RadComboBoxLocation" Visible="false" DataSourceID="DataSourceLocations"
                                            DataValueField="LocationID" DataTextField="Name" EmptyMessage="Select Location"
                                            runat="server" EnableEmbeddedSkins="false" SkinID="Prodigy" CssClass="mydropdown">
                                        </telerik:RadComboBox>
                                        
                                    </div>
                                    <div class="row">
                                        <asp:Label ID="Label5" runat="server" Text="Start Date" CssClass="mylabel-right myeditdatepickerlabel"></asp:Label>
                                        <div class="myeditdatepicker">
                                            <telerik:RadDatePicker ID="DatePicker" Enabled="False" runat="server" DateInput-Width="150px" Width="52%"
                                                DateInput-DisplayDateFormat="MM/dd/yy" Calendar-ShowRowHeaders="False" Calendar-CssClass="myDatePickerPopup"
                                                CssClass="myDatePickerPopup myenrollmentdate">
                                            </telerik:RadDatePicker>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <asp:Label ID="LabelStart" runat="server" Text="Start Time" CssClass="mylabel-right myeditdatepickerlabel"></asp:Label>
                                        <div class="myeditdatepicker">
                                            <telerik:RadTimePicker ID="StartTimePicker" Enabled="False" runat="server" TimeView-StartTime="6:00"
                                                TimeView-EndTime="20:00" TimeView-RenderDirection="Horizontal" TimeView-Columns="3"
                                                TimeView-CssClass="myTimePickerPopup" CssClass="myDatePickerPopup myenrollmentdate"
                                                DateInput-Width="150px" Width="52%">
                                            </telerik:RadTimePicker>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <asp:Label ID="LabelEnd" runat="server" Text="End Time" CssClass="mylabel-right myeditdatepickerlabel"></asp:Label>
                                        <div class="myeditdatepicker">
                                            <telerik:RadTimePicker ID="EndTimePicker" Enabled="False" runat="server" TimeView-StartTime="6:00"
                                                TimeView-EndTime="20:00" TimeView-TimeFormat="h:mm" TimeView-RenderDirection="Horizontal" TimeView-Columns="3"
                                                TimeView-CssClass="myTimePickerPopup" CssClass="myDatePickerPopup myenrollmentdate"
                                                DateInput-Width="150px" Width="52%">
                                            </telerik:RadTimePicker>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <asp:Label ID="LabelInstructor" runat="server" Text="Instructor" CssClass="mylabel-right"></asp:Label>
                                        <asp:Label ID="lblClassInstructor" runat="server" CssClass="myfield-plain"></asp:Label>
                                        <telerik:RadComboBox ID="RadComboBoxInstructors"  Visible="false" DataValueField="PersonID" DataTextField="FullName"
                                            runat="server" EnableEmbeddedSkins="false" SkinID="Prodigy" CssClass="mydropdown">
                                        </telerik:RadComboBox>
                                    </div>
                                    <div class="row">
                                        <asp:Label ID="LabelAssistant" runat="server" Text="Assistant" CssClass="mylabel-right"></asp:Label>
                                        <asp:Label ID="lblClassAssistant" runat="server" CssClass="myfield-plain"></asp:Label>
                                        <telerik:RadComboBox ID="RadComboBoxAssistant"  Visible="false" DataValueField="PersonID" DataTextField="FullName"
                                            runat="server" EnableEmbeddedSkins="false" SkinID="Prodigy" CssClass="mydropdown">
                                        </telerik:RadComboBox>
                                    </div>
                                    <div class="row">
                                        <asp:Label ID="Label4" runat="server" Text="Lesson Plan" CssClass="mylabel-right"></asp:Label>
                                        <asp:Label ID="lblClassLessonPlanName" runat="server" CssClass="myfield-plain"></asp:Label>
                                        <telerik:RadComboBox ID="RadComboBoxLessonPlan"  Visible="false" DataValueField="LessonPlanID" DataTextField="Name"
                                            runat="server" EnableEmbeddedSkins="false" SkinID="Prodigy" CssClass="mydropdown">
                                        </telerik:RadComboBox>
                                    </div>
                                    
                                </FormTemplate>
                            </EditFormSettings>
                        </telerik:GridTableView>
                    </DetailTables>
                    <EditFormSettings EditFormType="Template" EditColumn-ButtonType="LinkButton">
                        <FormTemplate>

                             <auth:SecureContent ID="SecureContent3" ToggleVisible="false" ToggleEnabled="true" EventHook="Load" runat="server" Roles="Administrators;Administrators-NA;CentralTeamUsers;SiteTeamUsers;">
                             <!-- hidden fields for processing -->
                    <asp:HiddenField ID="hfLessonPlanSetId" runat="server" />
                    <asp:HiddenField ID="hfLessonPlanSetName" runat="server" />
                    <asp:HiddenField ID="hfClassName" runat="server" />
                    <asp:HiddenField ID="hfSite" runat="server" />
                    <asp:HiddenField ID="hfLocation" runat="server" />
                    <asp:HiddenField ID="hfClassType" runat="server" />
                    <asp:HiddenField ID="hfAgegroup" runat="server" />
                    <asp:HiddenField ID="hfAssistant" runat="server" />
                                 <asp:HiddenField ID="hfInstructor" runat="server" />
                                 <div class="row">
                                <asp:Label ID="LabelLocation" runat="server" Text="Site" CssClass="mylabel-right"></asp:Label>
                                <asp:Label ID="lblLessonPlanLocation" runat="server" CssClass="myfield-plain"></asp:Label>
                                     <telerik:RadComboBox ID="RadComboBoxLocation" DataSourceID="DataSourceSites" Visible="false" DataValueField="LocationID"
                                    DataTextField="Name" SelectedValue='<%# Bind("SiteLocationID") %>' EmptyMessage="Select Site"
                                    runat="server" CssClass="mydropdown">
                                </telerik:RadComboBox>
                                <%--<asp:RequiredFieldValidator ID="reqValLoc" runat="server" ControlToValidate="RadComboBoxLocation"
                                    InitialValue="" ErrorMessage="Location is required" Display="Dynamic" ValidationGroup="Save"></asp:RequiredFieldValidator>--%>
                            </div>
                           
                            <div class="row">
                                <asp:Label ID="LabelInstructor" runat="server" Text="Instructor" CssClass="mylabel-right"></asp:Label>
                                <asp:Label ID="lblLessonPlanInstructor" runat="server" CssClass="myfield-plain"></asp:Label>
                               <%-- <telerik:RadComboBox ID="RadComboBoxInstructors" DataValueField="PersonID" DataTextField="FullName"
                                    runat="server" CssClass="mydropdown" AppendDataBoundItems="true">
                                    <Items>
                                        <telerik:RadComboBoxItem Text="Select Instructor" Value="" />
                                    </Items>
                                </telerik:RadComboBox>--%>
                            </div>
                            <div class="row">
                                <asp:Label ID="LabelAssistant" runat="server" Text="Assistant" CssClass="mylabel-right"></asp:Label>
                                <asp:Label ID="lblLessonPlanAssistant" runat="server" CssClass="myfield-plain"></asp:Label>
                                <%--<telerik:RadComboBox ID="RadComboBoxAssistant" AppendDataBoundItems="true" DataValueField="PersonID"
                                    DataTextField="FullName" runat="server" CssClass="mydropdown">
                                    <Items>
                                        <telerik:RadComboBoxItem Text="Select Assistant" Value="" />
                                    </Items>
                                </telerik:RadComboBox>--%>
                            </div>
                            <div class="row">
                                <asp:Label ID="Label4" runat="server" Text="Lesson Plan" CssClass="mylabel-right"></asp:Label>
                                 <asp:Label ID="lblLessonPlanSetName" runat="server" CssClass="myfield-plain"></asp:Label>
                               <%-- <telerik:RadComboBox ID="RadComboBoxLessonPlanSet" SelectedValue='<%# Bind("LessonPlanSetID") %>'
                                    DataSourceID="DataSourceLessonPlanSet" DataValueField="LessonPlanSetID" DataTextField="Name"
                                    runat="server" EnableEmbeddedSkins="false" SkinID="Prodigy" CssClass="mydropdown">
                                </telerik:RadComboBox>--%>
                            </div>
                            <div class="row">
                                <asp:Label ID="LabelStart" runat="server" Text="Start Date" CssClass="mylabel-right myeditdatepickerlabel"></asp:Label>
                                <%--<asp:Label ID="lblstartdateCD" runat="server" CssClass="myfield-plain"></asp:Label>--%>
                                <div class="myeditdatepicker">
                                    <telerik:RadDateTimePicker ID="RadDatePickerStart" runat="server" Enabled="false"
                                       DateInput-DisplayDateFormat="MM/dd/yy" DateInput-Width="259px" Width="250px"  DbSelectedDate='<%# Bind("StartDate") %>' Calendar-ShowRowHeaders="False"
                                        Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup myenrollmentdate">
                                    </telerik:RadDateTimePicker>
                                    
                                </div>
                            </div>
                            <div class="row">
                                <asp:Label ID="LabelEnd" runat="server" Text="End Date" CssClass="mylabel-right myeditdatepickerlabel"></asp:Label>
                                <%--<asp:Label ID="lblenddateCD" runat="server" CssClass="myfield-plain"></asp:Label>--%>
                                <div class="myeditdatepicker">
                                    <telerik:RadDateTimePicker ID="RadDatePickerEndDate" runat="server" Enabled="False"
                                        DateInput-DisplayDateFormat="MM/dd/yy" DateInput-Width="259px"  Width="250px" DbSelectedDate='<%# Bind("EndDate") %>' Calendar-ShowRowHeaders="False"
                                        Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup myenrollmentdate">
                                    </telerik:RadDateTimePicker>
                                   
                                </div>
                            </div>
                            <div class="row">
                                <asp:Label ID="LabelNotes" runat="server" Text="Notes" CssClass="mytextarealabel mylabel-right"></asp:Label>
                                <asp:TextBox ID="TextBoxNotes" runat="server" Text='<%# Bind("Notes") %>' CssClass="myfield"
                                    Height="200px" Width="630px" Rows="300" Columns="500" TextMode="MultiLine"></asp:TextBox>
                            </div>
                            <div class="InputWrapper">
                                <div class="FormLabel">
                                    &nbsp;
                                </div>
                                <asp:Button ID="btnUpdate" Text="Update" runat="server" CssClass="mybutton" CommandName="Update"
                                    Visible='<%# !(Container.DataItem is Telerik.Web.UI.GridInsertionObject) %>'>
                                </asp:Button>
                                <asp:Button ID="btnInsert" Text="Insert" runat="server" CommandName="PerformInsert"
                                    CssClass="mybutton" Visible='<%# Container.DataItem is Telerik.Web.UI.GridInsertionObject %>'>
                                </asp:Button>
                                &nbsp; &nbsp;
                                <asp:Button runat="server" ID="ButtonCancel" Text="Cancel" CssClass="mybutton" CommandName="Cancel"
                                    CausesValidation="false"></asp:Button>
                            </div>
                            </auth:SecureContent>
                        </FormTemplate>
                    </EditFormSettings>
                    <NoRecordsTemplate>
                        <p>
                            If you filtered please widen your search.
                        </p>
                    </NoRecordsTemplate>
                </MasterTableView>
            </telerik:RadGrid>
               <div class="ButtonWrapper">
                         <auth:securecontent id="SecureContent1" togglevisible="true" toggleenabled="false"
            eventhook="Load" runat="server" roles="Administrators;Administrators-NA;CentralTeamUsers;SiteTeamUsers;">
                        <asp:Button ID="btnUpdate" Text="Insert" runat="server" CssClass="mybutton" CommandName="Insert"
                            OnClick="btnUpdate_Click" ValidationGroup="SaveCourse" />
                        &nbsp; &nbsp;
                        <asp:Button runat="server" ID="ButtonCancel" OnClick="ButtonCancel_Click" Text="Cancel"
                            CssClass="mybutton" CommandName="Cancel" CausesValidation="false"></asp:Button>

                    &nbsp; &nbsp;
<%--                <%-- Print  --%>
                <%--<asp:Button runat="server" ID="ButtonPrint" Text="Sign-In Sheet" Width="190px" CssClass="mybutton mycancel"
                    CommandName="Print" CausesValidation="false" OnClick="ButtonPrint_Click"></asp:Button>--%>
                            </auth:SecureContent>
                    </div>
        </div>
    </div>
    <asp:EntityDataSource ID="DataSourceCourseInstance" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" 
        EnableFlattening="False" EntitySetName="CourseInstances" Include="Instructor, Assistant, Site, Course"
        OrderBy="it.[StartDate]" Where="it.[CourseID] == @CourseID && it.[ProgramID] == @ProgramID">
        <WhereParameters>
            <asp:SessionParameter Name="ProgramID" SessionField="ProgramID" Type="Int32" />
            <asp:ControlParameter ControlID="HiddenFieldCourseID" Name="CourseID" Type="Int32"
                PropertyName="Value" />
        </WhereParameters>
    </asp:EntityDataSource>
    <asp:EntityDataSource ID="DataSourceClassess" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" 
        EnableFlattening="False" EntitySetName="Classes" Include="Instructor, Assistant, StatusType, ClassType, Location, Site, CourseInstance"
        OrderBy="it.[DateStart]" Where="it.[CourseInstanceID] == @CourseInstanceID">
        <WhereParameters>
            <asp:SessionParameter Name="CourseInstanceID" SessionField="CourseInstanceID" Type="Int32" />
        </WhereParameters>
    </asp:EntityDataSource>
    <asp:EntityDataSource ID="DataSourceLocations" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" 
        EnableFlattening="False" EntitySetName="Locations" OrderBy="it.[Name]">
    </asp:EntityDataSource>
    <asp:EntityDataSource ID="DataSourceSites" runat="server" ConnectionString="name=PODContext"
        EntityTypeFilter="Site" DefaultContainerName="PODContext" 
        EnableFlattening="False" EntitySetName="Locations">
    </asp:EntityDataSource>
    <asp:EntityDataSource ID="DataSourceLessonPlanSet" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" 
        EnableFlattening="False" Include="StatusType" Where="it.StatusType.Category =='LessonPlanSet' && it.StatusType.Name =='Approved'"
        EntitySetName="LessonPlanSets">
    </asp:EntityDataSource>
    <asp:EntityDataSource ID="DataSourceStatusTypes" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" 
        EnableFlattening="False" EntitySetName="StatusTypes" Where='it.[Category]=="Common"'
        OrderBy="it.[Name]">
    </asp:EntityDataSource>
    <asp:EntityDataSource ID="DataSourceCourseTypes" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" 
        EnableFlattening="False" EntitySetName="CourseTypes" OrderBy="it.[Name]">
    </asp:EntityDataSource>
    <asp:EntityDataSource ID="DataSourceClassTypes" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" 
        EnableFlattening="False" EntitySetName="ClassTypes" OrderBy="it.[Name]">
    </asp:EntityDataSource>
    <asp:EntityDataSource ID="DataSourceLessonPlanType" runat="server" ConnectionString="name=PODContext"
                        DefaultContainerName="PODContext" EnableFlattening="False" EntitySetName="LessonPlanTypes" Where="it.IsActive == true "
                        OrderBy="it.[Name]">
                    </asp:EntityDataSource>

    <%--<telerik:RadScriptBlock runat="server">
       <script type="text/javascript"> 
           function RadGridCourseInstance_Command(sender, args) {
               var commandName = args.get_commandName();
               if (commandName == "print") {
                   
                   $find('<%= RadAjaxManager1.ClientID %>').set_enableAJAX(false);
               }
           }
       </script> 
    </telerik:RadScriptBlock>--%>
</asp:Content>
