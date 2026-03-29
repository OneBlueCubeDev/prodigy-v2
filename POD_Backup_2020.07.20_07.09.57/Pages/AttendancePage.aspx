<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeBehind="AttendancePage.aspx.cs"
    Inherits="POD.Pages.AttendancePage" %>
<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link type="text/css" rel="stylesheet" href="~/Templates/Styles/MainStyles.css" />
    <link type="text/css" rel="stylesheet" href="~/Templates/Styles/EnrollmentFormStyles.css" />
    <link type="text/css" rel="stylesheet" href="~/Templates/Styles/RiskAssessmentStyles.css" />
    <link type="text/css" rel="stylesheet" href="~/Templates/Styles/AttendanceStyles.css" />
    <link type="text/css" rel="stylesheet" href="~/Templates/Styles/ClassesStyles.css" />
    <link type="text/css" rel="stylesheet" href="~/Templates/Styles/DashboardStyles.css" />
    <link type="text/css" rel="stylesheet" href="~/Templates/Styles/PopUpStyles.css" />
    <link href='//fonts.googleapis.com/css?family=Muli:400,300,300italic,400italic' rel='stylesheet'
        type='text/css' />
    <!--[if IE 9]>
	    <link rel="stylesheet" type="text/css" href="~/Templates/Styles/IE9Styles.css" />   
    <![endif]-->
    <!--[if IE 8]>
	        <link rel="stylesheet" type="text/css" href="~/Templates/Styles/IE8Styles.css" /> 
    <![endif]-->
    <telerik:RadStyleSheetManager ID="RadStyleSheetManager1" runat="server">
        <StyleSheets>
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Button.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Calendar.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/ColorPicker.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/ComboBox.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/DataPager.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Dock.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Editor.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/FileExplorer.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Filter.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/FormDecorator.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Grid.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/ImageEditor.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Input.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/ListBox.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/ListView.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Menu.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Notification.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/OrgChart.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/PanelBar.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Rating.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/RibbonBar.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Rotator.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Scheduler.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/SiteMap.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Slider.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/SocialShare.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Splitter.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/TagCloud.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/TabStrip.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/ToolBar.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/ToolTip.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/TreeList.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Upload.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Window.Prodigy.css" />
        </StyleSheets>
    </telerik:RadStyleSheetManager>
</head>
<body>
    <form id="form1" runat="server">
    <telerik:RadScriptManager ID="RadScriptManagerMain" runat="server">
        <Scripts>
            <%--Needed for JavaScript IntelliSense in VS2010--%>
            <%--For VS2008 replace RadScriptManager with ScriptManager--%>
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js" />
            <asp:ScriptReference Path="~/Templates/Scripts/jquery.easing.1.3.min.js" />
        </Scripts>
    </telerik:RadScriptManager>
    <telerik:RadAjaxManager ID="RadAjaxManagerProxy1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGriAttendancesEvent">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGriAttendancesEvent" LoadingPanelID="RadAjaxLoadingPanel1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadGriAttendancesClass">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGriAttendancesClass" LoadingPanelID="RadAjaxLoadingPanel1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="ButtonSaveClass">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGriAttendancesClass" LoadingPanelID="RadAjaxLoadingPanel1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="ButtonSave">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGriAttendancesEvent" LoadingPanelID="RadAjaxLoadingPanel1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server" HorizontalAlign="Center">
        <img src="../../../App_Themes/Prodigy/Common/loading.gif" alt="Loading" style="border: none;
            margin-top: 150px;" />
    </telerik:RadAjaxLoadingPanel>
    <telerik:RadCodeBlock runat="server" ID="RadCodeBlock2">
        <script type="text/javascript">
            $(document).ready(function () {
                AddNewPerson();
                $('.AssociateWithPerson').hide();
            });
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

            function RowContextMenuEA(sender, eventArgs) {
                var menu = $find("<%=RadContextMenuEA.ClientID %>");
                var evt = eventArgs.get_domEvent();
                if (evt.target.tagName == "INPUT" || evt.target.tagName == "A") {
                    return;
                }

                var index = eventArgs.get_itemIndexHierarchical();
                document.getElementById("radGridClickedRowIndexEA").value = index;

                sender.get_masterTableView().selectItem(sender.get_masterTableView().get_dataItems()[index].get_element(), true);
                if (menu != null) {
                    menu.show(evt);
                }
                evt.cancelBubble = true;
                evt.returnValue = false;

                if (evt.stopPropagation) {
                    evt.stopPropagation();
                    evt.preventDefault();
                }
            }

            function ShowAssociation() {
                $('.AssociateWithPerson').show();
            }
            function ComboBoxNonStudentChanged(sender, args) {
                var combo = $find("<%= RadComboBoxStudent.ClientID %>");
                if (combo != null) {
                    combo.clearSelection();
                }
                $('.AssociateWithPerson').show();
            }
            function ClientSelectedIndexChangedStudent(sender, args) {
                var combo = $find("<%= RadComboBoxNonStudent.ClientID %>");
                var textfields = $('.NewPerson');
                var dob = $find("<%= RadDatePickerDOB.ClientID %>");

                if (dob != null) {
                    dob.clear();
                }
                if (combo != null) {
                    combo.clearSelection();
                }
                textfields.each(function () { $(this).val(''); });
                $(".addNewPersonContainer").hide();
                $('.AssociateWithPerson').hide();
            }
            function GetRadWindow() {
                var oWindow = null;
                if (window.radWindow)
                    oWindow = window.radWindow;
                else if (window.frameElement.radWindow)
                    oWindow = window.frameElement.radWindow;
                return oWindow;
            }

            function OnClicking(sender, eventArgs) {
                var item = eventArgs.get_item();

                if (item.get_value() == "Delete") {
                    var proceed = confirm("Are you sure you want to delete this attendance data?");
                    if (!proceed) {
                        eventArgs.set_cancel(true);
                    }
                }
            }

            function CloseWindow() {
                //get parent window
                var oWnd = GetRadWindow();
                oWnd.close();
            }
            function AddNewPerson() {
                $(".addNewPersonContainer").hide();
                $('.addAttendeebutton').click(function () {
                    // slide fields down in manage attendances window when button is clicked
                    $(".addNewPersonContainer").slideDown(500);
                });
            }
            

        </script>
    </telerik:RadCodeBlock>
    <div>
        <div class="AttendancePopUpContainer myPopupWrapper">
            <div class="CourseOverview">
                <asp:Panel ID="PanelEventRecord" runat="server" CssClass="AttendanceInfo">
                    <h2 class="AdminHeader">
                        <asp:Literal ID="EventAttendanceHeader" runat="Server"></asp:Literal>
                        Attendances
                    </h2>
                    <h3 class="sectionHead">
                        New Attendance</h3>
                    <asp:Panel runat="server" ID="PanelNewEventAttendance">
                          <auth:SecureContent ID="SecureContent1" ToggleVisible="false" ToggleEnabled="true"
                    EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
                        <div class="row">
                            <div class="YouthContainer">
                                <asp:Label ID="LabelYouth1" runat="server" Text="Youth:" CssClass="mylabel"></asp:Label>
                                <telerik:RadComboBox ID="RadComboBoxStudent" runat="server" AppendDataBoundItems="true"
                                    EnableLoadOnDemand="true" DataTextField="FullName" OnClientSelectedIndexChanged="ClientSelectedIndexChangedStudent"
                                    DataValueField="PersonID" EnableEmbeddedSkins="false" SkinID="Prodigy" CssClass="mydropdown myAttendancePerson">
                                    <Items>
                                        <telerik:RadComboBoxItem Text="Select" Value="" />
                                    </Items>
                                </telerik:RadComboBox>
                            </div>
                            <h3 class="OR">
                                OR</h3>
                            <div class="PersonContainer">
                                <asp:Label ID="LabelPerson" runat="server" Text="Enter Person Name:" CssClass="mylabel"></asp:Label>
                                 
                                <telerik:RadComboBox ID="RadComboBoxNonStudent" runat="server" DataSourceID="DataSourceNonStudents"
                                    DataTextField="FullName" AppendDataBoundItems="true" DataValueField="PersonID"
                                    EnableEmbeddedSkins="false" SkinID="Prodigy" CssClass="mydropdown myAttendancePerson"
                                    OnClientSelectedIndexChanged="ComboBoxNonStudentChanged">
                                    <Items>
                                        <telerik:RadComboBoxItem Text="Select" Value="" />
                                    </Items>
                                </telerik:RadComboBox>
                                <div>
                                    <input type="button" href="javascript:void(0);" class="addAttendeebutton mybutton"
                                        value="Add New Person" />
                                    <div class="addNewPersonContainer row">
                                        <div class="row">
                                            <asp:Label ID="LabelNewPerson" runat="server" Text="First Name" CssClass="mylabel"></asp:Label>
                                            <asp:TextBox ID="TextBoxFirstName" onblur="ShowAssociation();" runat="server" CssClass="myfield NewPerson"></asp:TextBox>
                                        </div>
                                        <div class="row">
                                            <asp:Label ID="LabelNewPersonLast" runat="server" Text="Last Name" CssClass="mylabel"></asp:Label>
                                            <asp:TextBox ID="TextBoxLastName" onblur="ShowAssociation();" runat="server" CssClass="myfield NewPerson"></asp:TextBox>
                                        </div>
                                        <div class="row">
                                            <asp:Label ID="LabelNewPersonDOB" runat="server" Text="DOB" CssClass="mylabel"></asp:Label>
                                            <telerik:RadDatePicker ID="RadDatePickerDOB" runat="server" DateInput-Width="50px"
                                                Width="42%" DateInput-DisplayDateFormat="MM/dd/yy" Calendar-ShowRowHeaders="False"
                                                Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup myenrollmentdob">
                                            </telerik:RadDatePicker>
                                        </div>
                                        <div class="row">
                                            <asp:CustomValidator ID="customVal" runat="server" SetFocusOnError="true" Display="Dynamic"
                                                CssClass="ErrorMessage" ErrorMessage="First and Last Name are required" Text="*"
                                                OnServerValidate="customVal_ServerValidate"></asp:CustomValidator>
                                        </div>
                                    </div>
                                </div>
                                <asp:Panel ID="PanelRelation" runat="server" class="row AssociateWithPerson">
                                    <asp:Label ID="Label1" runat="server" Text="Relationship:" CssClass="mylabel"></asp:Label>
                                    <telerik:RadComboBox ID="ComboBoxYouth" runat="server" MarkFirstMatch="true" AllowCustomText="false"
                                        DataTextField="FullName" DataValueField="PersonID" EmptyMessage="Select Youth"
                                        CssClass="AttendeeYouth mydropdown" EnableEmbeddedSkins="false" SkinID="Prodigy">
                                    </telerik:RadComboBox>
                                    <telerik:RadComboBox ID="ComboBoxRelationShip" runat="server" DataSourceID="DataSourcePersonRelationshipTypes"
                                        EmptyMessage="Select Relationship" DataTextField="Name" DataValueField="PersonRelationshipTypeID"
                                        EnableEmbeddedSkins="false" SkinID="Prodigy" CssClass="mydropdown">
                                    </telerik:RadComboBox>
                                    <asp:CustomValidator ID="CustomValYouthRelation" runat="server" ErrorMessage="You must specify the relationship to the youth"
                                        CssClass="ErrorMessage" Display="Dynamic" ValidationGroup="Save" OnServerValidate="CustomValYouthRelation_ServerValidate"></asp:CustomValidator>
                                </asp:Panel>
                            </div>
                        </div>
                        </auth:SecureContent>
                          <auth:SecureContent ID="SecureContent2" ToggleVisible="true" ToggleEnabled="false"
                    EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
                        <div class="row">
                            <asp:Button ID="SaveButton" runat="server" ValidationGroup="Save" OnClick="SaveButton_Click"
                                Text="Save" class="mybutton mysave" />
                        </div></auth:SecureContent>
                    </asp:Panel>
                    <asp:Panel runat="server" ID="PanelEventAttendanceLocked" Visible="False">
                        <asp:Literal runat="server" ID="LiteralEventAttendanceMessage"><p class="AttendanceLock"><span class="AttendanceLockUnderline">Attendance is locked:</span> You can't currently add any new attendance for this event. Please direct all questions to Prodigy.<br /></p></asp:Literal>
                    </asp:Panel>
                    <div class="sectionDivider">
                    </div>
                    <h3 class="sectionHead GridHead">
                        Event Attendees</h3>
                    
             
                    

                    <telerik:RadGrid ID="RadGriAttendancesEvent" ExportSettings-ExportOnlyData="true" runat="server" AutoGenerateColumns="false"
                        OnNeedDataSource="RadGriAttendancesEvent_NeedDataSource" AllowPaging="True" AllowSorting="true"
                        AllowFilteringByColumn="false" OnItemCreated="RadGriAttendancesEvent_ItemCreated" 
                        OnGridExporting="RadGriAttendancesEvent_GridExporting"  
                        OnExportCellFormatting="RadGriAttendancesEvent_ExportCellFormatting" 
                        GroupingSettings-CaseSensitive="false" PageSize="10" OnHTMLExporting="RadGriAttendancesEvent_HTMLExporting"
                        Width="100%" EnableEmbeddedSkins="false" Skin="Prodigy"  HorizontalAlign="Center">
                        
                        <ExportSettings ExportOnlyData="true" OpenInNewWindow="true" ></ExportSettings>
                        
                        <MasterTableView TableLayout="Auto" CommandItemSettings-ShowExportToWordButton="true"  ClientDataKeyNames="EventID, PersonID, EventAttendanceID"
                            DataKeyNames="EventID, PersonID, EventAttendanceID">
                            <CommandItemSettings ShowExportToWordButton="true" ExportToWordText="" />
                            <Columns>
                                <telerik:GridBoundColumn DataField="Event.Name" SortExpression="Event.Name" FilterControlWidth="85%"
                                    AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderText="Name">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Person.FullName" SortExpression="Person.FullName"
                                    FilterControlWidth="85%" AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderText="Attendee">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Event.DateStart" FilterControlWidth="85%" AutoPostBackOnFilter="true"
                                    ShowFilterIcon="false" SortExpression="Event.DateStart" HeaderText="Start Date"
                                    DataFormatString="{0:d}">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Event.DateEnd" DataFormatString="{0:d}" FilterControlWidth="85%"
                                    AutoPostBackOnFilter="true" ShowFilterIcon="false" SortExpression="Event.DateEnd"
                                    HeaderText="End Date">
                                </telerik:GridBoundColumn>
                            </Columns>
                            <NoRecordsTemplate>
                                <p>
                                    If you filtered please widen your search.
                                </p>
                            </NoRecordsTemplate>
                        </MasterTableView>
                        <ClientSettings>
                            <ClientEvents OnRowClick="RowContextMenuEA"></ClientEvents>
                            <Selecting AllowRowSelect="true" />
                        </ClientSettings>
                    </telerik:RadGrid>
                    <asp:Button ID="Button1" runat="server" ValidationGroup="Save" 
                                Text="Print" class="mybutton mysave" OnClick="Button1_Click" />
                  <%-- <asp:ImageButton ID="ImageButton3" CausesValidation="false" AlternateText="Print"   OnClick="ImageButton3_Click"  runat="server"  />--%>

                    <input type="hidden" id="radGridClickedRowIndexEA" name="radGridClickedRowIndexEA" />
                    <telerik:RadContextMenu ID="RadContextMenuEA" runat="server" OnClientItemClicking="OnClicking"
                        OnItemClick="RadContextMenuEA_ItemClick" EnableRoundedCorners="true" EnableShadows="true">
                        <Items>
                            <telerik:RadMenuItem Text="Delete Attendance" Value="Delete" />
                        </Items>
                    </telerik:RadContextMenu>
                </asp:Panel>
                <asp:Panel ID="PanelClassRecord" runat="server" CssClass="AttendanceInfo">
                    <h2 class="AdminHeader">
                        <asp:Literal ID="LiteralClassAttendanceHeader" runat="Server"></asp:Literal>
                        Attendance
                    </h2>
                    <h3 class="sectionHead">
                        New Attendance</h3>
                    <asp:Panel runat="server" ID="PanelClassNewAttendance">
                          <auth:SecureContent ID="SecureContent3" ToggleVisible="false" ToggleEnabled="true"
                    EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
                        <div class="row">
                            <asp:Label ID="LabelYouth2" runat="server" Text="Youth:" CssClass="mylabel"></asp:Label>
                            <telerik:RadComboBox ID="RadComboBoxStudentClass" runat="server" EnableLoadOnDemand="true"
                                AppendDataBoundItems="true" DataTextField="FullName" DataValueField="PersonID"
                                EnableEmbeddedSkins="false" SkinID="Prodigy" CssClass="mydropdown myAttendancePerson">
                                <Items>
                                    <telerik:RadComboBoxItem Text="Select Youth" Value="" />
                                </Items>
                            </telerik:RadComboBox>
                            <asp:RequiredFieldValidator ID="reqVal" runat="server" ControlToValidate="RadComboBoxStudentClass"
                                InitialValue="" SetFocusOnError="true" Display="Dynamic" CssClass="ErrorMessage"
                                ErrorMessage="Required" Text="*"></asp:RequiredFieldValidator>
                        </div>
                        <div class="row">
                            <asp:Label ID="LabelLeftEarly" runat="server" Text="Left Early?" CssClass="mylabel"></asp:Label>
                            <telerik:RadFormDecorator ID="RadFormDecoratorAttendance1" runat="server" />
                            <asp:RadioButtonList ID="RadiobuttonListEarly" runat="server" CssClass="LeftEarlyFields"
                                RepeatDirection="Horizontal">
                                <asp:ListItem Text="Yes" Value="True"></asp:ListItem>
                                <asp:ListItem Text="No" Value="False"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="row">
                            <asp:Label ID="LabelTardy" runat="server" Text="Tardy?" CssClass="mylabel"></asp:Label>
                            <asp:RadioButtonList ID="RadiobuttonListTardy" runat="server" CssClass="TardyFields"
                                RepeatDirection="Horizontal">
                                <asp:ListItem Text="Yes" Value="True"></asp:ListItem>
                                <asp:ListItem Text="No" Value="False"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="row">
                            <asp:Label ID="LabelNotes" runat="server" Text="Class Notes" CssClass="mylabel ClassNotes"></asp:Label>
                            <asp:TextBox ID="TextBoxNotes" runat="server" CssClass="myfield" TextMode="MultiLine"
                                Columns="30" Rows="30" Height="100px" Width="300px"></asp:TextBox>
                        </div>
                        </auth:SecureContent>
                          <auth:SecureContent ID="SecureContent4" ToggleVisible="true" ToggleEnabled="false"
                    EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
                        <div class="row">
                            <asp:Button ID="ButtonSaveClass" runat="server" ValidationGroup="Save" OnClick="SaveButton_Click"
                                Text="Save" class="mybutton mysave" />
                        </div></auth:SecureContent>
                    </asp:Panel>
                    <asp:Panel runat="server" ID="PanelClassAttendanceLocked" Visible="False">
                        <asp:Literal runat="server" ID="Literal1"><p class="AttendanceLock"><span class="AttendanceLockUnderline">Attendance is locked:</span> You can't currently add any new attendance for this event. Please direct all questions to Prodigy.<br /></p></asp:Literal>
                    </asp:Panel>
                    <div class="sectionDivider">
                    </div>
                    <h3 class="sectionHead GridHead">
                        Class Attendees</h3>
                    <telerik:RadGrid ID="RadGriAttendancesClass" runat="server" AutoGenerateColumns="false"
                        OnNeedDataSource="RadGriAttendancesClass_NeedDataSource" AllowPaging="True" AllowSorting="true"
                        AllowFilteringByColumn="false" GroupingSettings-CaseSensitive="false" PageSize="10"
                        Width="100%" EnableEmbeddedSkins="false" Skin="Prodigy" HorizontalAlign="Center">
                        <MasterTableView TableLayout="Auto" ClientDataKeyNames="Student_PersonID, ClassAttendanceID, ClassID"
                            DataKeyNames="Student_PersonID, ClassAttendanceID, ClassID">
                            <Columns>
                                <telerik:GridBoundColumn DataField="Person.FullName" SortExpression="Person.FullName"
                                    FilterControlWidth="85%" AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderText="Attendee">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Class.DateStart" FilterControlWidth="85%" AutoPostBackOnFilter="true"
                                    ShowFilterIcon="false" SortExpression="Class.DateStart" HeaderText="Start Date"
                                    ItemStyle-HorizontalAlign="Center" DataFormatString="{0:d}">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Class.DateStart" FilterControlWidth="85%" AutoPostBackOnFilter="true"
                                    ShowFilterIcon="false" SortExpression="Class.DateStart" HeaderText="Start Time"
                                    ItemStyle-HorizontalAlign="Center" DataFormatString="{0:t}">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Class.DateEnd" DataFormatString="{0:t}"
                                    FilterControlWidth="85%" AutoPostBackOnFilter="true" ShowFilterIcon="false" SortExpression="Class.DateEnd"
                                    ItemStyle-HorizontalAlign="Center" HeaderText="End Time">
                                </telerik:GridBoundColumn>
                                <telerik:GridTemplateColumn SortExpression="LeftEarly" HeaderText="Left Early?" HeaderStyle-HorizontalAlign="Center"
                                    ItemStyle-HorizontalAlign="Center" ItemStyle-Width="45px" HeaderStyle-Width="45px">
                                    <ItemTemplate>
                                        <asp:Label ID="LabelLeftearly" runat="server" Text='<%# Eval("LeftEarly")!=null && Eval("LeftEarly").ToString() == "True"? "Yes":"No" %>'></asp:Label>
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                                <telerik:GridTemplateColumn SortExpression="Tardy" HeaderText="Tardy?" HeaderStyle-HorizontalAlign="Center"
                                    ItemStyle-HorizontalAlign="Center" ItemStyle-Width="45px" HeaderStyle-Width="45px">
                                    <ItemTemplate>
                                        <asp:Label ID="LabelTardy" runat="server" Text='<%#  Eval("Tardy")!=null && Eval("Tardy").ToString() == "True"? "Yes":"No" %>'></asp:Label>
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
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
                    <telerik:RadContextMenu ID="RadMenuOptions" runat="server" OnClientItemClicking="OnClicking"
                        OnItemClick="RadMenu1_ItemClick" EnableRoundedCorners="true" EnableShadows="true">
                        <Items>
                            <telerik:RadMenuItem Text="Delete Attendance" Value="Delete" />
                        </Items>
                    </telerik:RadContextMenu>
                </asp:Panel>
            </div>
        </div>
    </div>
    <asp:EntityDataSource ID="DataSourcePersonRelationshipTypes" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" Where="it.IsActive == true" EnableFlattening="False"
        EntitySetName="PersonRelationshipTypes" OrderBy="it.[Name]">
    </asp:EntityDataSource>
    <asp:EntityDataSource ID="DataSourceNonStudents" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" EnableFlattening="False" EntitySetName="Persons"
        Where="it.PersonType.Name !='Staff' && it.PersonType.Name !='Student'" Select="it.PersonID, (it.FirstName + ' ' +it.LastName) AS FullName,it.[FirstName], it.[LastName]"
        OrderBy="it.[FirstName], it.[LastName]">
    </asp:EntityDataSource>
    </form>
</body>
</html>
