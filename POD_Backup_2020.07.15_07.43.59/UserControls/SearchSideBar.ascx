<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SearchSideBar.ascx.cs"
    Inherits="POD.UserControls.SearchSideBar" %>
<div class="searchhead">
    <h2>
        <asp:Literal ID="LiteralHeader" runat="server"></asp:Literal></h2>
</div>
<!--end searchhead-->
<div class="sidecontent">
    <%-- Lesson Plan Panel --%>
    <asp:Panel ID="PanelLessonPlan" runat="server" CssClass="LessonPlanSearchPanel">
        
        <div>
            <asp:Label ID="lbLessonName" runat="server" Text="Name" class="sidelabel mylabel"
                AssociatedControlID="NameBox"></asp:Label>
            <asp:TextBox ID="LessonNameBox" runat="server" class="mysidefield myfield"></asp:TextBox>
        </div>
        <div>
            <asp:Label ID="lbLocatoion" runat="server" Text="Location" class="sidelabel mylabel"
                AssociatedControlID="RadComboBoxClassLocationLesson"></asp:Label>
            <telerik:RadComboBox ID="RadComboBoxClassLocationLesson" AppendDataBoundItems="true" DataValueField="LocationID"
                DataTextField="Name" runat="server" CssClass="mysidefield mydropdown" Height="100%"
                Width="142px" AutoPostBack="True" 
                onselectedindexchanged="RadComboBoxClassLocation_SelectedIndexChanged">
                <Items>
                    <telerik:RadComboBoxItem Text="All" Value="" /> 
                </Items>
            </telerik:RadComboBox>
        </div>
        <div class="">
            <asp:Label ID="lbInstructor" runat="server" Text="Instructor" class="sidelabel mylabel"
                AssociatedControlID="RadComboBoxClassInstructorLesson"></asp:Label>
            <telerik:RadComboBox ID="RadComboBoxClassInstructorLesson" DataValueField="PersonID"
                DataTextField="FullName" runat="server" CssClass="mysidefield mydropdown"
                Height="100%" Width="142px">
               
            </telerik:RadComboBox>
        </div>
       
        <div class="">
            <asp:Label ID="Label11" runat="server" Text="Age Group" class="sidelabel mylabel"
                AssociatedControlID="RadComboBoxClassAgeGroup"></asp:Label>
            <telerik:RadComboBox ID="RadComboBoxClassAgeGroup" DataValueField="AgeGroupID"
                DataTextField="Name" runat="server" CssClass="mysidefield mydropdown"
                Height="100%" Width="142px">
                
            </telerik:RadComboBox>
        </div>
        <asp:Panel ID="LessonPlanStatus" runat="server">
            <asp:Label ID="lbLessonPlanStatus" runat="server" Text="Status" class="sidelabel mylabel"
                AssociatedControlID="RadComboBoxStatusLesson"></asp:Label>
            <telerik:RadComboBox ID="RadComboBoxStatusLesson" DataValueField="StatusTypeID" DataTextField="Description"
                AppendDataBoundItems="true" runat="server" CssClass="mysidefield mydropdown"
                Height="100%" Width="142px">
                <Items>
                    <telerik:RadComboBoxItem Text="All" Value="" />
                </Items>
            </telerik:RadComboBox>
        </asp:Panel>
         <div class="" style="padding-bottom:15px;" >
            <asp:Label ID="lbInstructorAssistant" runat="server" Text="Assistant"
                class="sidelabel mylabel InstructorAssistantLabel" AssociatedControlID="RadComboBoxClassAssistantLesson"></asp:Label>
            <telerik:RadComboBox ID="RadComboBoxClassAssistantLesson" DataValueField="PersonID"
                DataTextField="FullName" runat="server" CssClass="mysidefield mydropdown"
               Height="100%" Width="142px">
                
            </telerik:RadComboBox>
        </div>
        
   <div class="EventStartDate" style="padding-top:15px;">
            <label id="lbEventEndDate" class="sidelabel mylabel">
                Lesson Plan Date</label><br />
            <telerik:RadDatePicker ID="rdpstartdatestart" runat="server" DateInput-Width="50px"
                Width="44%" DateInput-DisplayDateFormat="MM/dd/yy" Calendar-ShowRowHeaders="False"
                Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup">
            </telerik:RadDatePicker>
            <span class="dateseperator">-</span>
            <telerik:RadDatePicker ID="rdpstartdateend" runat="server" DateInput-Width="50px"
                Width="44%" DateInput-DisplayDateFormat="MM/dd/yy" Calendar-CssClass="myDatePickerPopup"
                Calendar-ShowRowHeaders="False">
            </telerik:RadDatePicker>
        </div>
        
    </asp:Panel>
    <asp:Panel ID="PanelEnrollment" runat="server">
        <%--<form class="mysidesearch" name="searchEnrollments">--%>
        <asp:Panel ID="NameSearch" runat="server">
            <asp:Label ID="NameLabel" runat="server" Text="Name" class="sidelabel mylabel" AssociatedControlID="NameBox"></asp:Label>
            <asp:TextBox ID="NameBox" runat="server" class="mysidefield myfield"></asp:TextBox>
        </asp:Panel>
        <!--end NameSearch-->
        <asp:Panel ID="GuardianSearch" runat="server">
            <asp:Label ID="GuardianLabel" runat="server" Text="Guardian" class="sidelabel mylabel"
                AssociatedControlID="GuardianBox"></asp:Label>
            <asp:TextBox ID="GuardianBox" runat="server" class="mysidefield myfield"></asp:TextBox>
        </asp:Panel>
        <!--end GuardianSearch-->
         <asp:Panel ID="PanelDJJ" runat="server">
            <asp:Label ID="Label10" runat="server" Text="DJJ Num" class="sidelabel mylabel"
                AssociatedControlID="TextBoxDJJNum"></asp:Label>
            <asp:TextBox ID="TextBoxDJJNum" runat="server" class="mysidefield myfield"></asp:TextBox>
        </asp:Panel>
        <!--end DJJ Search --> 
        <asp:Panel ID="ZipCodeSearch" runat="server">
            <asp:Label ID="ZipLabel" runat="server" Text="Zip" class="sidelabel mylabel" AssociatedControlID="ZipBox"></asp:Label>
            <asp:TextBox ID="ZipBox" runat="server" class="mysidefield myfield"></asp:TextBox>
        </asp:Panel>
        <!--end ZipCodeSearch-->
        <asp:Panel ID="SchoolSearch" runat="server">
            <asp:Label ID="SchoolLabel" runat="server" Text="School" class="sidelabel mylabel"
                AssociatedControlID="SchoolBox"></asp:Label>
            <asp:TextBox ID="SchoolBox" runat="server" class="mysidefield myfield"></asp:TextBox>
        </asp:Panel>
        <!--end SchoolSearch-->
        <asp:Panel ID="TypeSearch" runat="server">
            <asp:Label ID="TypeLabel" runat="server" Text="Type" class="sidelabel mylabel" AssociatedControlID="RadComboBoxType"></asp:Label>
            <telerik:RadComboBox ID="RadComboBoxType" AppendDataBoundItems="true" DataValueField="EnrollmentTypeID"
                DataTextField="Name" runat="server" CssClass="mysidefield mydropdown" Height="100%"
                Width="142px">
                <Items>
                    <telerik:RadComboBoxItem Text="All" Value="" />
                </Items>
            </telerik:RadComboBox>
        </asp:Panel>
        <!--end TypeSearch-->
        <asp:Panel ID="StatusSearch" runat="server">
            <asp:Label ID="StatusLabel" runat="server" Text="Status" class="sidelabel mylabel"
                AssociatedControlID="RadComboBoxStatus"></asp:Label>
            <telerik:RadComboBox ID="RadComboBoxStatus" DataValueField="StatusTypeID" DataTextField="Description"
                AppendDataBoundItems="true" runat="server" CssClass="mysidefield mydropdown"
                Height="100%" Width="142px">
                <Items>
                    <telerik:RadComboBoxItem Text="All" Value="" />
                </Items>
            </telerik:RadComboBox>
        </asp:Panel>
         <asp:Panel ID="Panel1" runat="server">
            <asp:Label ID="Label1" runat="server" Text="Grant Year" class="sidelabel mylabel"
                AssociatedControlID="RadComboBoxGrantYear"></asp:Label>
            <telerik:RadComboBox ID="RadComboBoxGrantYear"
             DataValueField="Key" DataTextField="Value"
                 runat="server" CssClass="mysidefield mydropdown"
                Height="100%" Width="142px">
               
            </telerik:RadComboBox>
        </asp:Panel>
        <!--end StatusSearch-->
        <asp:Panel ID="RegDateSearch" runat="server">
            <label id="RegistrationDate" class="sidelabel mylabel">
                Applied Date</label><br />
            <telerik:RadDatePicker ID="RadDatePickerStartDate" runat="server" DateInput-Width="50px"
                Width="44%" DateInput-DisplayDateFormat="MM/dd/yy" Calendar-ShowRowHeaders="False"
                Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup">
            </telerik:RadDatePicker>
            <span class="dateseperator">-</span>
            <telerik:RadDatePicker ID="RadDatePickerEndDate" runat="server" DateInput-Width="50px"
                Width="44%" DateInput-DisplayDateFormat="MM/dd/yy" Calendar-CssClass="myDatePickerPopup"
                Calendar-ShowRowHeaders="False">
            </telerik:RadDatePicker>
        </asp:Panel>
        <!--end RegDateSearch-->
        <asp:Panel ID="RaceSearch" runat="server">
            <div class="myRadForm">
                <fieldset class="myfieldset">
                    <legend>Race</legend>
                    <telerik:RadFormDecorator ID="RadFormDecorator1" runat="server" Font-Names="Arial, Verdana, sans-serif" />
                    <asp:CheckBoxList ID="CheckBoxListRaces" runat="server" DataTextField="Name" DataValueField="RaceID">
                    </asp:CheckBoxList>
                </fieldset>
            </div>
            <!--end myRadForm-->
        </asp:Panel>
        <!--end RaceSearch-->
        <%--</form>--%>
    </asp:Panel>
    <asp:Panel ID="PanelAttendance" runat="server" CssClass="AttendanceSearchPanel">
        <div class="NameSearch">
            <asp:Label ID="LabelAttName" runat="server" Text="Name" class="sidelabel mylabel"
                AssociatedControlID="TextBoxAttName"></asp:Label>
            <asp:TextBox ID="TextBoxAttName" runat="server" class="mysidefield myfield"></asp:TextBox>
        </div>
        <asp:panel ID="PanelSite" runat="server">
            <asp:Label ID="LabelAttSite" runat="server" Text="Site" class="sidelabel mylabel"
                AssociatedControlID="RadComboBoxAttendanceSite"></asp:Label>
            <telerik:RadComboBox ID="RadComboBoxAttendanceSite" AppendDataBoundItems="true" DataValueField="LocationID"
                DataTextField="Name" runat="server" CssClass="mysidefield mydropdown" Height="100%"
              Width="142px" AutoPostBack="True" 
               onselectedindexchanged="RadComboBoxAttendanceSite_SelectedIndexChanged">
                <Items>
                    <telerik:RadComboBoxItem Text="All" Value="" />
                </Items>
            </telerik:RadComboBox>
        </asp:panel>
        <div>
            <asp:Label ID="LabelAttLocation" runat="server" Text="Location" class="sidelabel mylabel"
                AssociatedControlID="RadComboBoxAttendanceLocation"></asp:Label>
            <telerik:RadComboBox ID="RadComboBoxAttendanceLocation" AutoPostBack="true" OnSelectedIndexChanged="RadComboBoxAttendanceLocation_SelectedIndexChanged"
                DataValueField="LocationID" DataTextField="Name" runat="server" CssClass="mysidefield mydropdown"
                Height="100%" Width="142px">
              
            </telerik:RadComboBox>
        </div>
        <div>
            <asp:Label ID="LabelAttClass" runat="server" Text="Class" class="sidelabel mylabel"
                AssociatedControlID="RadComboBoxAttClass"></asp:Label>
            <telerik:RadComboBox ID="RadComboBoxAttClass"  DataValueField="ClassID"
                DataTextField="Name" runat="server" CssClass="mysidefield mydropdown" Height="100%"
                Width="142px">
              
            </telerik:RadComboBox>
        </div>
     <%--   <div class="EventStatusSearch">
            <asp:Label ID="LabelAttEvent" runat="server" Text="Event" class="sidelabel mylabel"
                AssociatedControlID="RadComboBoxAttEvent"></asp:Label>
            <telerik:RadComboBox ID="RadComboBoxAttEvent" DataValueField="EventID" DataTextField="Name"
                AppendDataBoundItems="true" runat="server" CssClass="mysidefield mydropdown"
                Height="100%" Width="142px">
                <Items>
                    <telerik:RadComboBoxItem Text="All" Value="" />
                </Items>
            </telerik:RadComboBox>
        </div>--%>
        <div class="EventStartDate">
            <label id="Label4" class="sidelabel mylabel">
                Attendance Date</label><br />
            <telerik:RadDatePicker ID="RadDatePickerAttStart" runat="server" DateInput-Width="50px"
                Width="44%" DateInput-DisplayDateFormat="MM/dd/yy" Calendar-ShowRowHeaders="False"
                Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup">
            </telerik:RadDatePicker>
            <span class="dateseperator">-</span>
            <telerik:RadDatePicker ID="RadDatePickerAttEnd" runat="server" DateInput-Width="50px"
                Width="44%" DateInput-DisplayDateFormat="MM/dd/yy" Calendar-CssClass="myDatePickerPopup"
                Calendar-ShowRowHeaders="False">
            </telerik:RadDatePicker>
        </div>
    </asp:Panel>
    <asp:Panel ID="PanelClass" runat="server" CssClass="ClassSearchPanel">
        <div>
            <asp:Label ID="LabelCourseName" runat="server" Text="Name" class="sidelabel mylabel"
                AssociatedControlID="NameBox"></asp:Label>
            <asp:TextBox ID="TextBoxCourseName" runat="server" class="mysidefield myfield"></asp:TextBox>
        </div>
        <div>
            <asp:Label ID="LabelClassLoc" runat="server" Text="Site" class="sidelabel mylabel"
                AssociatedControlID="RadComboBoxClassLocation"></asp:Label>
            <telerik:RadComboBox ID="RadComboBoxClassLocation" AppendDataBoundItems="true" DataValueField="LocationID"
                DataTextField="Name" runat="server" CssClass="mysidefield mydropdown" Height="100%"
                Width="142px" AutoPostBack="True" 
                onselectedindexchanged="RadComboBoxClassLocation_SelectedIndexChanged">
                <Items>
                    <telerik:RadComboBoxItem Text="All" Value="" />
                </Items>
            </telerik:RadComboBox>
        </div>
        <div class="">
            <asp:Label ID="LabelClassInstructor" runat="server" Text="Instructor" class="sidelabel mylabel"
                AssociatedControlID="RadComboBoxClassInstructor"></asp:Label>
            <telerik:RadComboBox ID="RadComboBoxClassInstructor" DataValueField="PersonID"
                DataTextField="FullName" runat="server" CssClass="mysidefield mydropdown"
                Height="100%" Width="142px">
               
            </telerik:RadComboBox>
        </div>
        <div class="">
            <asp:Label ID="LabelClassAssistant" runat="server" Text="Instructor's Assistant"
                class="sidelabel mylabel InstructorAssistantLabel" AssociatedControlID="RadComboBoxClassAssistant"></asp:Label>
            <telerik:RadComboBox ID="RadComboBoxClassAssistant" DataValueField="PersonID"
                DataTextField="FullName" runat="server" CssClass="mysidefield mydropdown InstructorAssistantField"
                Height="100%" Width="206px">
                
            </telerik:RadComboBox>
        </div>
        <div class="EventStartDate">
            <label id="Label5" class="sidelabel mylabel">
                Start Date</label><br />
            <telerik:RadDatePicker ID="RadDatePickerClassStart" runat="server" DateInput-Width="50px"
                Width="44%" DateInput-DisplayDateFormat="MM/dd/yy" Calendar-ShowRowHeaders="False"
                Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup">
            </telerik:RadDatePicker>
            <span class="dateseperator">-</span>
            <telerik:RadDatePicker ID="RadDatePickerClassStart2" runat="server" DateInput-Width="50px"
                Width="44%" DateInput-DisplayDateFormat="MM/dd/yy" Calendar-CssClass="myDatePickerPopup"
                Calendar-ShowRowHeaders="False">
            </telerik:RadDatePicker>
        </div>
        <div class="EventStartDate">
            <label id="Label6" class="sidelabel mylabel">
                End Date</label><br />
            <telerik:RadDatePicker ID="RadDatePickerClassEnd" runat="server" DateInput-Width="50px"
                Width="44%" DateInput-DisplayDateFormat="MM/dd/yy" Calendar-ShowRowHeaders="False"
                Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup">
            </telerik:RadDatePicker>
            <span class="dateseperator">-</span>
            <telerik:RadDatePicker ID="RadDatePickerClassEnd2" runat="server" DateInput-Width="50px"
                Width="44%" DateInput-DisplayDateFormat="MM/dd/yy" Calendar-CssClass="myDatePickerPopup"
                Calendar-ShowRowHeaders="False">
            </telerik:RadDatePicker>
        </div>
    </asp:Panel>
    <asp:Panel ID="PanelEvent" runat="server" CssClass="EventSearchPanel">
        <div class="NameSearch">
            <asp:Label ID="LabelEventName" runat="server" Text="Name" class="sidelabel mylabel"
                AssociatedControlID="NameBox"></asp:Label>
            <asp:TextBox ID="TextBoxEventName" runat="server" class="mysidefield myfield"></asp:TextBox>
        </div>
        <div>
            <asp:Label ID="LabeEventType" runat="server" Text="Type" class="sidelabel mylabel"
                AssociatedControlID="RadComboBoxEventType"></asp:Label>
            <telerik:RadComboBox ID="RadComboBoxEventType" AppendDataBoundItems="true" DataValueField="EventTypeID"
                DataTextField="Name" runat="server" CssClass="mysidefield mydropdown" Height="100%"
                Width="142px">
                <Items>
                    <telerik:RadComboBoxItem Text="All" Value="" />
                </Items>
            </telerik:RadComboBox>
        </div>
        <div>
            <asp:Label ID="LabelEventLocation" runat="server" Text="Location" class="sidelabel mylabel"
                AssociatedControlID="RadComboBoxEventLocation"></asp:Label>
            <telerik:RadComboBox ID="RadComboBoxEventLocation" AppendDataBoundItems="true" DataValueField="LocationID"
                DataTextField="Name" runat="server" CssClass="mysidefield mydropdown" Height="100%"
                Width="142px">
                <Items>
                    <telerik:RadComboBoxItem Text="All" Value="" />
                </Items>
            </telerik:RadComboBox>
        </div>
        <div class="EventStatusSearch">
            <asp:Label ID="LabelEventStatus" runat="server" Text="Status" class="sidelabel mylabel"
                AssociatedControlID="RadComboBoxEventStatus"></asp:Label>
            <telerik:RadComboBox ID="RadComboBoxEventStatus" DataValueField="StatusTypeID" DataTextField="Name"
                AppendDataBoundItems="true" runat="server" CssClass="mysidefield mydropdown"
                Height="100%" Width="142px">
                <Items>
                    <telerik:RadComboBoxItem Text="All" Value="" />
                </Items>
            </telerik:RadComboBox>
        </div>
        <div class="EventStartDate">
            <label id="LabelStartDate" class="sidelabel mylabel">
                Start Date</label><br />
            <telerik:RadDatePicker ID="RadDatePickerEventStart" runat="server" DateInput-Width="50px"
                Width="44%" DateInput-DisplayDateFormat="MM/dd/yy" Calendar-ShowRowHeaders="False"
                Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup">
            </telerik:RadDatePicker>
            <span class="dateseperator">-</span>
            <telerik:RadDatePicker ID="RadDatePickerEventStart2" runat="server" DateInput-Width="50px"
                Width="44%" DateInput-DisplayDateFormat="MM/dd/yy" Calendar-CssClass="myDatePickerPopup"
                Calendar-ShowRowHeaders="False">
            </telerik:RadDatePicker>
        </div>
        <div class="EventStartDate">
            <label id="LabelEventEndDate" class="sidelabel mylabel">
                End Date</label><br />
            <telerik:RadDatePicker ID="RadDatePickerEventEnd" runat="server" DateInput-Width="50px"
                Width="44%" DateInput-DisplayDateFormat="MM/dd/yy" Calendar-ShowRowHeaders="False"
                Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup">
            </telerik:RadDatePicker>
            <span class="dateseperator">-</span>
            <telerik:RadDatePicker ID="RadDatePickerEventEnd2" runat="server" DateInput-Width="50px"
                Width="44%" DateInput-DisplayDateFormat="MM/dd/yy" Calendar-CssClass="myDatePickerPopup"
                Calendar-ShowRowHeaders="False">
            </telerik:RadDatePicker>
        </div>
    </asp:Panel>
    <asp:Panel ID="PanelInventory" runat="server" CssClass="InventorySearchPanel">
    <div>
        <asp:Label ID="LabelInvName" runat="server" Text="Name" class="sidelabel mylabel"
            AssociatedControlID="NameBox"></asp:Label>
        <asp:TextBox ID="TextBoxInvName" runat="server" class="mysidefield myfield"></asp:TextBox>
        </div>
 <div>
            <asp:Label ID="LabelInvType" runat="server" Text="Item Type" class="sidelabel mylabel"
                AssociatedControlID="RadComboBoxInvType"></asp:Label>
            <telerik:RadComboBox ID="RadComboBoxInvType" AppendDataBoundItems="true" DataValueField="InventoryItemTypeID"
                DataTextField="Name" runat="server" CssClass="mysidefield mydropdown" Height="100%"
                Width="142px">
                <Items>
                    <telerik:RadComboBoxItem Text="All" Value="" />
                </Items>
            </telerik:RadComboBox>
        </div>
        <div>
            <asp:Label ID="Label1InvLocation" runat="server" Text="Location" class="sidelabel mylabel"
                AssociatedControlID="RadComboBoxInvLocation"></asp:Label>
            <telerik:RadComboBox ID="RadComboBoxInvLocation" AppendDataBoundItems="true" DataValueField="LocationID"
                DataTextField="Name" runat="server" CssClass="mysidefield mydropdown" Height="100%"
                Width="142px">
                <Items>
                    <telerik:RadComboBoxItem Text="All" Value="" />
                </Items>
            </telerik:RadComboBox>
        </div>

         <div>
        <asp:Label ID="LabelInvManufacturer" runat="server" Text="Mfr" class="sidelabel mylabel ManufacturerLabel"
            AssociatedControlID="TextBoxInvManufacturer"></asp:Label>
        <asp:TextBox ID="TextBoxInvManufacturer" runat="server" class="mysidefield myfield ManufacturerField"></asp:TextBox>
        </div>
         <div>
        <asp:Label ID="Label2" runat="server" Text="Model" class="sidelabel mylabel"
            AssociatedControlID="TextBoxInvModel"></asp:Label>
        <asp:TextBox ID="TextBoxInvModel" runat="server" class="mysidefield myfield"></asp:TextBox>
        </div>
         <div>
        <asp:Label ID="Label3" runat="server" Text="Serial #" class="sidelabel mylabel"
            AssociatedControlID="TextBoxInvSerial"></asp:Label>
        <asp:TextBox ID="TextBoxInvSerial" runat="server" class="mysidefield myfield"></asp:TextBox>
        </div>
         <div>
        <asp:Label ID="Label7" runat="server" Text="Org" class="sidelabel mylabel OrganizationLabel"
            AssociatedControlID="TextBoxInvOrganization"></asp:Label>
        <asp:TextBox ID="TextBoxInvOrganization" runat="server" class="mysidefield myfield OrganizationField"></asp:TextBox>
        </div>
         <div>
        <asp:Label ID="Label8" runat="server" Text="UACDC Tag" class="sidelabel mylabel UACDCTagLabel"
            AssociatedControlID="TextBoxInvUACDCTag"></asp:Label>
        <asp:TextBox ID="TextBoxInvUACDCTag" runat="server" class="mysidefield myfield UACDCTagField"></asp:TextBox>
        </div>
         <div>
        <asp:Label ID="Label9" runat="server" Text="DJJ Tag" class="sidelabel mylabel"
            AssociatedControlID="TextBoxInvDJJTag"></asp:Label>
        <asp:TextBox ID="TextBoxInvDJJTag" runat="server" class="mysidefield myfield"></asp:TextBox>
        </div>
    </asp:Panel>
   <asp:Button ID="SearchButton" runat="server" Text="Search" OnClick="Searchbutton_Click"
        class="mybutton mysidebutton" />
    <div class="sidebarclear">
    </div>
</div>
<!--end sidecontent-->
<!--end searchcontent-->
