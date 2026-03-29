<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/Admin.Master"
    AutoEventWireup="true" CodeBehind="EventPage.aspx.cs" Inherits="POD.Pages.EventPage" %>

<%@ Register Src="../UserControls/EventsLinks.ascx" TagName="EventsLinks" TagPrefix="uc2" %>
<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceholderHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
    <uc2:EventsLinks ID="EventsLinks1" runat="server" />
    <telerik:RadAjaxManagerProxy ID="RadAjaxManager1" runat="server">
        <AjaxSettings>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="DashBoardContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="SidebarContentPlaceholder" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <telerik:RadAjaxManagerProxy ID="RadAjaxManagerProxy1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadComboBoxSite">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxSite" />
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxLocation" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadComboBoxTypes">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="TextBoxEventCategory" />
                    <telerik:AjaxUpdatedControl ControlID="rcbCategory1" />
                    <telerik:AjaxUpdatedControl ControlID="rlvFields1" />
                    <telerik:AjaxUpdatedControl ControlID="rcbCategory2" />
                    <telerik:AjaxUpdatedControl ControlID="rlvFields2" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="rcbCategory1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="TextBoxEventCategory" />
                    <telerik:AjaxUpdatedControl ControlID="rlvFields1" />
                    <telerik:AjaxUpdatedControl ControlID="rcbCategory2" />
                    <telerik:AjaxUpdatedControl ControlID="rlvFields2" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="rcbCategory2">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="TextBoxEventCategory" />
                    <telerik:AjaxUpdatedControl ControlID="rlvFields2" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>
    <div class="tabcontainer">
        <div class="tabcontent"> <auth:SecureContent ID="SecureContent1" ToggleVisible="false" ToggleEnabled="true"
        EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
            <div class="InventoryItemWrapper EventPageForm">
                <h2>
                    <asp:Literal ID="LiteralHeader" runat="Server"></asp:Literal></h2>
                <span class="ErrorMessage">
                    <asp:Literal ID="LiteralError" runat="server"></asp:Literal></span>
                <div class="row">
                    <asp:Label ID="LabelName" runat="server" Text="Name" CssClass="mylabel"></asp:Label>
                    <asp:TextBox ID="TextBoxName" runat="server" CssClass="myfield NameField"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="CustomValidator1" runat="server" ErrorMessage="Name is required"
                        CssClass="ErrorMessage" Display="Dynamic" ValidationGroup="Save" ControlToValidate="TextBoxName"></asp:RequiredFieldValidator>
                </div>
                <div class="row StartDateContainer">
                    <asp:Label ID="Label6" runat="server" Text="Start Date" CssClass="mylabel"></asp:Label>
                    <telerik:RadDateTimePicker ID="RadDatePickerStart" runat="server" DateInput-Width="150px"
                        Width="52%" DateInput-DisplayDateFormat="MM/dd/yy hh:mm tt" Calendar-ShowRowHeaders="False"
                        Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup myenrollmentdate">
                    </telerik:RadDateTimePicker>
                </div>
                <div class="row EndDateContainer">
                    <asp:Label ID="Label1" runat="server" Text="End Date" CssClass="mylabel"></asp:Label>
                    <telerik:RadDateTimePicker ID="RadDatePickerEnd" runat="server" DateInput-Width="150px"
                        Width="52%" DateInput-DisplayDateFormat="MM/dd/yy hh:mm tt" Calendar-ShowRowHeaders="False"
                        Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup myenrollmentdate">
                    </telerik:RadDateTimePicker>
                </div>
                <div class="row">
                    <asp:Label ID="Label13" runat="server" Text="Site" CssClass="mylabel SiteDropDownLabel"></asp:Label>
                    <telerik:RadComboBox ID="RadComboBoxSite" DataValueField="LocationID" DataTextField="Name"
                        EmptyMessage="Select Site" runat="server" EnableEmbeddedSkins="false" SkinID="Prodigy"
                        CssClass="mydropdown SiteDropDown" Width="209px" AutoPostBack="true" OnSelectedIndexChanged="RadComboBoxSite_SelectedIndexChanged">
                    </telerik:RadComboBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server" ControlToValidate="RadComboBoxSite"
                        InitialValue="" ErrorMessage="Site is required" Display="Dynamic" ValidationGroup="Save"></asp:RequiredFieldValidator>
                </div>
                <div class="row">
                    <asp:Label ID="LabelLocation" runat="server" Text="Source Location" CssClass="mylabel LocationDropDownLabel"></asp:Label>
                    <telerik:RadComboBox ID="RadComboBoxLocation" DataValueField="LocationID" DataTextField="Name"
                        EmptyMessage="Select Location" runat="server" EnableEmbeddedSkins="false" SkinID="Prodigy"
                        CssClass="mydropdown LocationDropDown" Width="209px">
                    </telerik:RadComboBox>
                     <asp:RequiredFieldValidator ID="RequiredFieldValidator22" runat="server" ControlToValidate="RadComboBoxLocation"
                        InitialValue="" ErrorMessage="Location is required" Display="Dynamic" ValidationGroup="Save"></asp:RequiredFieldValidator>
                </div>
                <div class="row">
                    <asp:Label ID="LabelEventLocation" runat="server" Text="Event Location" CssClass="mylabel"
                        AssociatedControlID="TextBoxEventLocation"></asp:Label>
                    <asp:TextBox ID="TextBoxEventLocation" runat="server" CssClass="myfield"></asp:TextBox>
                </div>
                <div class="row EventCategory">
                    <asp:Label ID="Label5" runat="server" Text="Category" CssClass="mylabel" AssociatedControlID="TextBoxEventCategory"></asp:Label>
                    <asp:TextBox ID="TextBoxEventCategory" runat="server" CssClass="myfield"></asp:TextBox>
                    <telerik:RadComboBox runat="server" ID="rcbCategory1" EnableEmbeddedSkins="false"
                        SkinID="Prodigy" CssClass="mydropdown" OnDataBound="rcbCategory1_OnDataBound"
                        AutoPostBack="True" OnSelectedIndexChanged="rcbCategory1_OnSelectedIndexChanged"
                        DataValueField="EventCategoryID" DataTextField="Name">
                    </telerik:RadComboBox>
                    <telerik:RadListView runat="server" ID="rlvFields1" DataKeyNames="EventCategoryFieldID,EventCategoryID,Name"
                        OnNeedDataSource="rlvFields1_OnNeedDataSource" OnDataBound="rlvFields1_OnDataBound">
                        <LayoutTemplate>
                            <div class="EventCategoryFieldsList">
                                <asp:PlaceHolder runat="server" ID="itemPlaceholder"></asp:PlaceHolder>
                            </div>
                        </LayoutTemplate>
                        <ItemTemplate>
                            <div class="EventCategoryFieldSet">
                                <asp:Label ID="lbField" runat="server" Text='<%# Eval("Name") %>' CssClass="mylabel"></asp:Label>
                                <asp:TextBox ID="tbField" runat="server" CssClass="myfield"></asp:TextBox>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="tbField" ValidationGroup="Save"
                                    ErrorMessage="Required field" Display="Dynamic" Enabled='<%# Eval("IsRequired") %>'
                                    CssClass="ErrorMessage"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator runat="server" ControlToValidate="tbField" ValidationGroup="Save"
                                    ErrorMessage="Characters ; and : are not allowed" Display="Dynamic" ValidationExpression="[^;]*"></asp:RegularExpressionValidator>
                            </div>
                        </ItemTemplate>
                    </telerik:RadListView>
                    <telerik:RadComboBox runat="server" ID="rcbCategory2" EnableEmbeddedSkins="false"
                        SkinID="Prodigy" CssClass="mydropdown" OnDataBound="rcbCategory2_OnDataBound"
                        AutoPostBack="True" OnSelectedIndexChanged="rcbCategory2_OnSelectedIndexChanged"
                        DataValueField="EventCategoryID" DataTextField="Name">
                    </telerik:RadComboBox>
                    <telerik:RadListView runat="server" ID="rlvFields2" DataKeyNames="EventCategoryFieldID,EventCategoryID,Name"
                        OnNeedDataSource="rlvFields2_OnNeedDataSource" OnDataBound="rlvFields2_OnDataBound">
                        <LayoutTemplate>
                            <ul>
                                <asp:PlaceHolder runat="server" ID="itemPlaceholder"></asp:PlaceHolder>
                            </ul>
                        </LayoutTemplate>
                        <ItemTemplate>
                            <asp:Label ID="lbField" runat="server" Text='<%# Eval("Name") %>'></asp:Label>
                            <asp:TextBox ID="tbField" runat="server"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="tbField"
                                ValidationGroup="Save" ErrorMessage="Required field" Display="Dynamic" Enabled='<%# Eval("IsRequired") %>'></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="tbField"
                                ValidationGroup="Save" ErrorMessage="; is not an allowed character" Display="Dynamic"
                                ValidationExpression="[^;]*"></asp:RegularExpressionValidator>
                        </ItemTemplate>
                    </telerik:RadListView>
                </div>
                <div class="row">
                    <asp:Label ID="Label4" runat="server" Text="Youth Attendance" CssClass="mylabel"
                        AssociatedControlID="TextBoxYouthAttendanceCount"></asp:Label>
                    <asp:TextBox ID="TextBoxYouthAttendanceCount" runat="server" CssClass="myfield myNumericField"></asp:TextBox>
                </div>
                <div class="row">
                    <asp:Label ID="Label7" runat="server" Text="Staff Attendance" CssClass="mylabel"
                        AssociatedControlID="TextBoxStaffAttendanceCount"></asp:Label>
                    <asp:TextBox ID="TextBoxStaffAttendanceCount" runat="server" CssClass="myfield myNumericField"></asp:TextBox>
                </div>
                <div class="row">
                    <asp:Label ID="Label2" runat="server" Text="Friends and Family Attendance" CssClass="mylabel"
                        AssociatedControlID="TextBoxFamilyAttendanceCount"></asp:Label>
                    <asp:TextBox ID="TextBoxFamilyAttendanceCount" runat="server" CssClass="myfield myNumericField"></asp:TextBox>
                </div><br />
                <div class="row">
                    <span class="mylabel DescriptionLabel">
                        <asp:Literal ID="Literal3" runat="server" Text="Event Description"></asp:Literal></span>
                    <telerik:RadEditor ID="RadEditoDesc" CssClass="TextEditor" Width="620" Height="225"
                        AutoResizeHeight="false" AllowScripts="false" SkinID="BasicSetOfTools" EnableEmbeddedSkins="false"
                        Skin="Prodigy" runat="server">
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
                        <Content>
                            <i>Enter a description of the event</i>
                        </Content>
                    </telerik:RadEditor>
                    <br style="clear: both;" />
                </div>
                <div class="row">
                    <asp:Label ID="Label12" runat="server" Text="Type" CssClass="mylabel"></asp:Label>
                    <telerik:RadComboBox ID="RadComboBoxTypes" DataSourceID="DataSourceEventTypes" DataValueField="EventTypeID"
                        DataTextField="Name" EmptyMessage="Select Type" runat="server" EnableEmbeddedSkins="false"
                        SkinID="Prodigy" CssClass="mydropdown" AutoPostBack="True" OnSelectedIndexChanged="RadComboBoxTypes_OnSelectedIndexChanged"
                        OnDataBound="RadComboBoxTypes_OnDataBound">
                    </telerik:RadComboBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="RadComboBoxTypes"
                        InitialValue="" ErrorMessage="Type is required" Display="Dynamic" ValidationGroup="Save"></asp:RequiredFieldValidator>
                </div>
                <div class="row">
                    <asp:Label ID="Label11" runat="server" Text="Notes" CssClass="mylabel NotesLabel"></asp:Label>
                    <asp:TextBox ID="TextBoxNotes" runat="server" CssClass="myfield" Height="160px" Width="620px"
                        Rows="300" Columns="500" TextMode="MultiLine"></asp:TextBox>
                </div>
            </div>
            </auth:SecureContent>
        </div>
    </div>
    <asp:EntityDataSource ID="DataSourceEventTypes" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" EnableFlattening="False" EntitySetName="EventTypes"
        OrderBy="it.[Name]">
    </asp:EntityDataSource>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="EditButtonsPlaceholder" runat="server">
    <div class="editButtons"><auth:SecureContent ID="SecureContent2" ToggleVisible="true" ToggleEnabled="false"
        EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
        <asp:Button ID="DeleteButton" runat="server" CausesValidation="false" OnClick="DeleteButton_Click"
            OnClientClick="return confirm('Are you sure you want to delete this event?');"
            Text="Delete" class="mybutton mydelete" />
        <asp:Button ID="SaveButton" runat="server" ValidationGroup="Save" OnClick="SaveButton_Click"
            Text="Save" class="mybutton mysave" /></auth:SecureContent>
    </div>
</asp:Content>
