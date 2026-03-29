<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/Admin.Master"
    AutoEventWireup="True" CodeBehind="RiskAssessmentPage.aspx.cs" Inherits="POD.Pages.RiskAssessmentPage" %>

<%@ Register Src="../UserControls/EnrollmentLinks.ascx" TagName="EnrollmentLinks"
    TagPrefix="uc2" %>
<%@ Register Src="../UserControls/ReleaseForm.ascx" TagName="ReleaseForm" TagPrefix="uc1" %>
<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceholderHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
    <uc2:EnrollmentLinks ID="EnrollmentLinks1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="SidebarContentPlaceholder" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <telerik:RadScriptBlock ID="RadScriptBlock5" runat="server">
        <script type="text/javascript">
            function GetRadWindow() {
                var oWindow = null;
                if (window.radWindow)
                    oWindow = window.radWindow;
                else if (window.frameElement.radWindow)
                    oWindow = window.frameElement.radWindow;
                return oWindow;
            }

            function DownLoadCertificate(id) {
                var oManager = GetRadWindowManager();
                oManager.closeActiveWindow();
                if (id.length > 0) {
                    var url = '/Pages/DownLoad.aspx?pid=' + id;
                    //open new window
                    var owind = window.radopen(url, "ViewCertificate");
                    owind.set_visibleStatusbar(false);
                }

            }

            function ShowTransfer(id) {
                var oManager = GetRadWindowManager();
                oManager.closeActiveWindow();
                if (id.length > 0) {
                    var url = '/Pages/TransferYouthPage.aspx?pid=' + id;
                    //open new window
                    var owind = window.radopen(url, "ViewTransfer");
                    owind.set_visibleStatusbar(false);
                }
            }

            function ShowRelease(id, key, type) {
                var oManager = GetRadWindowManager();
                oManager.closeActiveWindow();
                if (id.length > 0) {
                    var url = '/Pages/ReleaseYouthPage.aspx?pid=' + id + '&eid=' + key + '&type=' + type;
                    //open new window
                    var owind = window.radopen(url, "ViewRelease");
                    owind.set_visibleStatusbar(false);
                }

            }
            $(document).ready(function () {
                $("div.mydropdown").each(function () {
                    //Find dropdown field
                    var VisibleField = $(this).find(".rcbInput");
                    //Get Value
                    var comboValue = $(VisibleField).val();
                    //Create span with value
                    $(this).after("<span class='PrintComboValue'>" + comboValue + "</span>");
                });
                $(".mytextbox").each(function () {
                    //Get Value
                    var textboxValue = $(this).val();
                    //Create span with value
                    $(this).after("<span class='PrintTextValue'>" + textboxValue + "</span>");
                });

                $(".mytextbox").blur(function () {
                    PrintTextFieldSwap();
                });

                //Checkbox/Radio button check marks
                $("input[type='radio'][checked]").each(function () {
                    $(this).before("<span class='PrintListChecked'>" + "X" + "</span>");
                });
                $("input[type='checkbox'][checked]").each(function () {
                    $(this).before("<span class='PrintListChecked'>" + "X" + "</span>");
                });
            });

            function PrintFieldSwap() {
                //Remove old print fields
                $(".PrintComboValue").remove();
                $("div.mydropdown").each(function () {
                    //Find dropdown field
                    var VisibleField = $(this).find(".rcbInput");
                    //Get Value
                    var comboValue = $(VisibleField).val();
                    //Create span with value
                    $(this).after("<span class='PrintComboValue'>" + comboValue + "</span>");
                });
            }

            function PrintTextFieldSwap() {
                //Remove old print fields
                $(".PrintTextValue").remove();
                $(".mytextbox").each(function () {
                    //Get Value
                    var textboxValue = $(this).val();
                    //Create span with value
                    $(this).after("<span class='PrintTextValue'>" + textboxValue + "</span>");
                });
            }
        </script>
    </telerik:RadScriptBlock>
    <telerik:RadAjaxManagerProxy ID="RadAjaxManagerProxy1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadComboBoxProdigySite">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxProdigyLocation" />
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxStaff"/>
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadComboBoxProdigyLocation">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxStaff"/>
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>
    <div class="tabcontainer">
        <div class="tabcontent">
            <div class="EnrollmentFormContainer RiskAssessmentFormContainer">
                <auth:SecureContent ID="SecureContent1" ToggleVisible="false" ToggleEnabled="true"
                    EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
                    <div class="LessonPlanPrintBlock">
                    <h1>
                        <img src="../../Templates/Images/prodigy_logo_print2.png" width="280px" height="133px"
                            alt="Prodigy" /></h1>
                    <h2>
                        RISK ASSESSMENT</h2>
                </div>
                    <div class="entryDetails">
                        Created:
                        <asp:Label ID="LabelCreated" runat="Server"></asp:Label><br />
                        Last Edited:
                        <asp:Label ID="LabelEdited" runat="Server"></asp:Label>
                        <asp:Panel ID="PanelActions" runat="server" CssClass="sidetoolbar">
                            <ul>
                                <li>
                                    <auth:SecureContent ID="SecureContent8" ToggleVisible="true" ToggleEnabled="false"
                                        EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
                                        <a href="#" id="TransferClient" runat="server" class="transferClient"><span>Transfer
                                            Youth</span></a>
                                    </auth:SecureContent>
                                </li>
                                <li id="LiRelease" runat="server">
                                    <auth:SecureContent ID="SecureContent9" ToggleVisible="true" ToggleEnabled="false"
                                        EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
                                        <asp:HyperLink ID="HyperLinkRelease" runat="server" CssClass="releaseYouth"><span>Release Youth</span></asp:HyperLink></auth:SecureContent>
                                </li>
                                <li>
                                    <auth:SecureContent ID="SecureContent10" ToggleVisible="true" ToggleEnabled="false"
                                        EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
                                        <a href="#" title="Create Certificate" id="CertificateLink" runat="server" class="createCertificate">
                                            <span>Create Certificate</span></a></auth:SecureContent>
                                </li>
                            </ul>
                        </asp:Panel>
                    </div>
                    <div class="row">
                        <h3 class="sectionHead PrintHide">
                            Risk Assessment:</h3>
                        <div class="myriskassessmentinitialscontainer">
                            <asp:Label ID="LabelMgrInitials" runat="server" Text="Site Manager's Initials" class="mylabel mysignaturelabel"></asp:Label>
                            <asp:RadioButtonList ID="RadioButtonListMgrInitials" runat="server" RepeatLayout="Flow"
                                RepeatDirection="Horizontal" CssClass="myRAchoices">
                                <asp:ListItem Value="True">Yes</asp:ListItem>
                                <asp:ListItem Value="False">No</asp:ListItem>
                            </asp:RadioButtonList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator42" runat="server" SetFocusOnError="True"
                                ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadioButtonListMgrInitials"
                                CssClass="ErrorMessage" ErrorMessage="Site Manager's Initials are required."
                                InitialValue="" Text="* Required"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="row myenrollmentshortcontainer">
                        <asp:Label ID="LabelCriteriaNotMet" Visible="False" runat="server" Text="" class="ErrorMessage CriteriaRAError"></asp:Label>
                    </div>
                    <div class="row myenrollmentshortcontainer myRANameContainer">
                        <div class="myriskassessmentyouthname">
                            <asp:Label ID="RiskAssessmentYouthName" runat="server" Text="Youth First Name" class="mylabel"></asp:Label>
                            <asp:TextBox ID="RiskAssessmentYouthFirstNameTextBox" runat="server" class="myfield"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="ReqValFirstName" runat="server" SetFocusOnError="True"
                                ValidationGroup="Save" Display="Dynamic" ControlToValidate="RiskAssessmentYouthFirstNameTextBox"
                                CssClass="ErrorMessage" ErrorMessage="Youth First Name is required." Text="* Required"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="row myRAIDcontainer">
                        <div class="myenrollmentIDcontainer">
                            <asp:Label ID="LabelEnrollmentID" runat="server" Text="DJJ ID#" CssClass="mylabel"></asp:Label>
                            <asp:TextBox ID="EnrollmentIDTextBox" runat="server" CssClass="myfield mytextbox"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row myenrollmentshortcontainer">
                        <div class="myriskassessmentyouthname">
                            <asp:Label ID="Label2" runat="server" Text="Youth Middle Name" class="mylabel"></asp:Label>
                            <asp:TextBox ID="RiskAssessmentYouthMiddleNameTextBox" runat="server" class="myfield"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row myenrollmentshortcontainer">
                        <div class="myriskassessmentyouthname">
                            <asp:Label ID="Label1" runat="server" Text="Youth Last Name" class="mylabel"></asp:Label>
                            <asp:TextBox ID="RiskAssessmentYouthLastNameTextBox" runat="server" class="myfield"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" SetFocusOnError="True"
                                ValidationGroup="Save" Display="Dynamic" ControlToValidate="RiskAssessmentYouthLastNameTextBox"
                                CssClass="ErrorMessage" ErrorMessage="Youth Last Name is required." Text="* Required"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="row">
                        <div class="myenrollmentdobcontainer myRADOB">
                            <asp:Label ID="RiskAssessmentDOB" runat="server" Text="DOB" class="mylabel"></asp:Label>
                            <telerik:RadDatePicker ID="RadDatePickerRiskAssessmentDOB" runat="server" DateInput-Width="50px"
                                Width="42%" DateInput-DisplayDateFormat="MM/dd/yy" Calendar-ShowRowHeaders="False"
                                Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup myenrollmentdob"
                                MinDate="1/1/1900">
                            </telerik:RadDatePicker>
                        </div>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" SetFocusOnError="True"
                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadDatePickerRiskAssessmentDOB"
                            CssClass="ErrorMessage myRADOBError" ErrorMessage="DOB is required." Text="* Required"></asp:RequiredFieldValidator>
                    </div>
                    <div class="row">
                        <div class="myriskassessmentdatecontainer myRADate">
                            <asp:Label ID="RiskAssessmentDate" runat="server" Text="Assessment Date" class="mylabel RiskAssessmentDateLabel"></asp:Label>
                            <telerik:RadDatePicker ID="RadDatePickerRiskAssessmentDate" runat="server" DateInput-Width="50px"
                                Width="42%" DateInput-DisplayDateFormat="MM/dd/yy" Calendar-ShowRowHeaders="False"
                                Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup myriskassessmentdate">
                            </telerik:RadDatePicker>
                        </div>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" SetFocusOnError="True"
                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadDatePickerRiskAssessmentDate"
                            CssClass="ErrorMessage myRADateError" ErrorMessage="Assessment Date is required."
                            Text="* Required"></asp:RequiredFieldValidator>
                    </div>
                    <div class="row">
                        <div class="myriskassessmentprodigylocation">
                            <asp:Label ID="Label3" runat="server" Text="Prodigy Site"
                                class="mylabel myLocationLabel"></asp:Label>
                            <telerik:RadComboBox ID="RadComboBoxProdigySite" runat="server" CssClass="myfield mydropdown"
                                AppendDataBoundItems="False" Height="100%" Width="142px" AutoPostBack="True" DataValueField="LocationID"
                                DataTextField="SiteName" OnSelectedIndexChanged="RadComboBoxProdigySite_OnSelectedIndexChanged"></telerik:RadComboBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator43" runat="server" SetFocusOnError="True"
                                ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadComboBoxProdigySite"
                                CssClass="ErrorMessage" InitialValue="" ErrorMessage="Site is required."
                                Text="* Required"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="row">
                        <div class="myriskassessmentprodigylocation">
                            <asp:Label ID="RiskAssessmentProdigyLocation" runat="server" Text="Prodigy Location"
                                class="mylabel myLocationLabel"></asp:Label>
                            <telerik:RadComboBox ID="RadComboBoxProdigyLocation" runat="server" CssClass="myfield mydropdown"
                                AppendDataBoundItems="False" Height="100%" Width="142px" AutoPostBack="True" DataValueField="LocationID"
                                DataTextField="Name" OnSelectedIndexChanged="RadComboBoxProdigyLocation_SelectedIndexChanged">
                            </telerik:RadComboBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" SetFocusOnError="True"
                                ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadComboBoxProdigyLocation"
                                CssClass="ErrorMessage" InitialValue="" ErrorMessage="Location is required."
                                Text="* Required"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="row">
                        <div class="myriskassessmentauthor">
                            <asp:Label ID="RiskAssessmentAuthor" runat="server" Text="This form was completed by:"
                                class="mylabel"></asp:Label>
                            <telerik:RadComboBox ID="RadComboBoxStaff" Enabled="False" runat="server" Width="142px"
                                DataTextField="Name" DataValueField="UserID" CssClass="myfield mydropdown">
                            </telerik:RadComboBox>
                        </div>
                    </div>
                    <div class="row">
                        <p class="checklabel">
                            <asp:Label ID="RiskAssessmentParentStatus" runat="server" Text="Parent Status (of the youth admitted to your program):"
                                class="mylabel"></asp:Label></p>
                        <telerik:RadFormDecorator ID="RadFormDecorator2" runat="server" />
                        <asp:CheckBoxList ID="CheckBoxListRiskAssessmentParentStatus" runat="server" DataTextField="Name"
                            CssClass="riskassessmentParentStatusFields" RepeatLayout="Table" RepeatDirection="Horizontal">
                            <asp:ListItem Value="None">None</asp:ListItem>
                            <asp:ListItem Value="Youth is Pregnant">Youth is Pregnant</asp:ListItem>
                            <asp:ListItem Value="Youth is a mother">Youth is a mother</asp:ListItem>
                            <asp:ListItem Value="Youth is a father">Youth is a father</asp:ListItem>
                            <asp:ListItem Value="Non Residential">Non-Residential</asp:ListItem>
                        </asp:CheckBoxList>
                    </div>
                    <div class="row">
                        <p class="checklabel">
                            <asp:Label ID="RiskAssessmentFamilyStucture" runat="server" Text="Family Structure:"
                                class="mylabel"></asp:Label></p>
                        <telerik:RadFormDecorator ID="RadFormDecorator1" runat="server" />
                        <asp:CheckBoxList ID="CheckBoxListRiskAssessmentFamilyStucture" runat="server" DataTextField="Name"
                            CssClass="riskassessmentFamilyStructureFields SingleChoiceCheckboxTable" RepeatLayout="Table" RepeatDirection="Horizontal"
                            RepeatColumns="4">
                            <asp:ListItem Value="Lives with two parents">Lives with two parents</asp:ListItem>
                            <asp:ListItem Value="Lives with single mother">Lives with single mother</asp:ListItem>
                            <asp:ListItem Value="Lives with single father">Lives with single father</asp:ListItem>
                            <asp:ListItem Value="Lives with relative(s)">Lives with relative(s)</asp:ListItem>
                            <asp:ListItem Value="Lives with non-relative(s)">Lives with non-relative(s)</asp:ListItem>
                            <asp:ListItem Value="Foster Care">Foster Care</asp:ListItem>
                        </asp:CheckBoxList>
                    </div>
                    <div class="row RAReferredByContainer">
                        <p class="checklabel">
                            <asp:Label ID="RiskAssessmentRefferal" runat="server" Text="Youth was referred by:"
                                class="mylabel"></asp:Label></p>
                        <telerik:RadFormDecorator ID="RadFormDecorator3" runat="server" />
                        <asp:CheckBoxList ID="CheckBoxListRiskAssessmentReferral" runat="server" DataTextField="Name"
                            CssClass="riskassessmentRefferalFields" RepeatLayout="Table" RepeatDirection="Horizontal"
                            RepeatColumns="5">
                            <asp:ListItem Value="Self or Family">Self or Family</asp:ListItem>
                            <asp:ListItem Value="School">School</asp:ListItem>
                            <asp:ListItem Value="DJJ">DJJ</asp:ListItem>
                            <asp:ListItem Value="DCF">DCF</asp:ListItem>
                            <asp:ListItem Value="Judiciary or State Attorney">Judiciary or State Attorney</asp:ListItem>
                            <asp:ListItem Value="Other Criminal Justice (not DJJ)">Other Criminal Justice (not DJJ)</asp:ListItem>
                            <asp:ListItem Value="Other Social Services (not DCF)">Other Social Services (not DCF)</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:CheckBoxList>
                        <asp:TextBox ID="RiskAssessmentReferralOtherTextBox" runat="server" class="myfield myOtherField"></asp:TextBox>
                    </div>
                </auth:SecureContent>
                <span class="sectionDivider PrintHide"></span>
                <div class="RiskAssessmentChartContainer">
                    <telerik:RadTabStrip ID="RiskAssessmentTabStrip" runat="server" SelectedIndex="0"
                        MultiPageID="MultiPageRiskAssessment" Orientation="VerticalLeft" CssClass="RiskAssessmentSections">
                        <Tabs>
                            <telerik:RadTab runat="server" Selected="True" Text="School">
                            </telerik:RadTab>
                            <telerik:RadTab runat="server" Text="Family">
                            </telerik:RadTab>
                            <telerik:RadTab runat="server" Text="Substance Abuse">
                            </telerik:RadTab>
                            <telerik:RadTab runat="server" Text="Individual">
                            </telerik:RadTab>
                        </Tabs>
                    </telerik:RadTabStrip>
                    <telerik:RadMultiPage ID="MultiPageRiskAssessment" runat="server" ViewStateMode="Inherit"
                        SelectedIndex="0" CssClass="RiskAssessmentSectionViews">
                        <telerik:RadPageView ID="RadPageView1" runat="server">
                            <auth:SecureContent ID="SecureContent4" ToggleVisible="false" ToggleEnabled="true"
                                EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
                                <div class="PrintSectionTitle">
                                    <h2>
                                        School</h2>
                                    <span class="sectionDivider"></span>
                                </div>
                                <div class="row">
                                    <h3 class="sectionHead">
                                        Attendance</h3>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRAAttendance1" runat="server" Text="Skipping classes 3 or more times in the last 60 days?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadioListRAAttendanceSkippingClass"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="RadioListRAAttendanceSkippingClass" runat="server" RepeatLayout="Flow"
                                            RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRAAttendance2" runat="server" Text="Skipping school 3 or more times in the last 60 days but not habitually truant?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadioListRAAttendanceSkippingSchool"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="RadioListRAAttendanceSkippingSchool" runat="server" RepeatLayout="Flow"
                                            RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRAAttendance3" runat="server" Text="Habitual/chronic truant (more than 15 absences in 90 days)?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadioListRAAttendanceHabitualTruant"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="RadioListRAAttendanceHabitualTruant" runat="server" RepeatLayout="Flow"
                                            RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRAAttendance4" runat="server" Text="Not enrolled?" CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadioListRAAttendanceNotEnrolled"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="RadioListRAAttendanceNotEnrolled" runat="server" RepeatLayout="Flow"
                                            RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <span class="sectionDivider"></span>
                                <div class="row FFPrinterBreak">
                                    <h3 class="sectionHead">
                                        Behavior</h3>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRABehavior1" runat="server" Text="Currently suspended?" CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadioListRABehaviorCurrentSuspension"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="RadioListRABehaviorCurrentSuspension" runat="server" RepeatLayout="Flow"
                                            RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRABehavior2" runat="server" Text="Currently expelled?" CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadioListRABehaviorCurrentExpelled"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="RadioListRABehaviorCurrentExpelled" runat="server" RepeatLayout="Flow"
                                            RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRABehavior3" runat="server" Text="Suspended within current or previous year?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadioListRABehaviorSuspended"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="RadioListRABehaviorSuspended" runat="server" RepeatLayout="Flow"
                                            RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRABehavior4" runat="server" Text="Expelled within current or previous year?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator12" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadioListRABehaviorExpelled"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="RadioListRABehaviorExpelled" runat="server" RepeatLayout="Flow"
                                            RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <span class="sectionDivider"></span>
                                <div class="row IEPrinterBreak">
                                    <h3 class="sectionHead">
                                        Academic</h3>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRAAcademic1" runat="server" Text="Failing one or more classes within past 6 months?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator13" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadioListRAAcademicFailingClasses"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="RadioListRAAcademicFailingClasses" runat="server" RepeatLayout="Flow"
                                            RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRAAcademic2" runat="server" Text="Held back/failed a grade level once?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator14" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadioListRAAcademicHeldBack"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="RadioListRAAcademicHeldBack" runat="server" RepeatLayout="Flow"
                                            RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRAAcademic3" runat="server" Text="Held back/failed a grade level more than once?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator15" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadioListRAAcademicHeldBackMoreThanOnce"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="RadioListRAAcademicHeldBackMoreThanOnce" runat="server"
                                            RepeatLayout="Flow" RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRAAcademic4" runat="server" Text="Learning disabilities or mental illness? (ADD, ADHD, Dyslexia, SED, EH, LD, etc.)?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator16" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadioListRAAcademicDisability"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="RadioListRAAcademicDisability" runat="server" RepeatLayout="Flow"
                                            RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="row">
                                </div>
                            </auth:SecureContent>
                        </telerik:RadPageView>
                        <telerik:RadPageView ID="RadPageView2" runat="server">
                            <auth:SecureContent ID="SecureContent5" ToggleVisible="false" ToggleEnabled="true"
                                EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
                                <div class="PrintSectionTitle">
                                    <h2>
                                        Family</h2>
                                    <span class="sectionDivider"></span>
                                </div>
                                <div class="row">
                                    <h3 class="sectionHead">
                                        Parents</h3>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRAParents1" runat="server" Text="Parents/youth make statements that parents cannot control the child's behavior?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator17" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadioListRAParentsNoControl"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="RadioListRAParentsNoControl" runat="server" RepeatLayout="Flow"
                                            RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRAParents2" runat="server" Text="Have unclear rules or no limits regarding the child's behavior?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator18" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadioListRAParentsNoRules"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="RadioListRAParentsNoRules" runat="server" RepeatLayout="Flow"
                                            RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRAParents3" runat="server" Text="Cannot state where the child spends free time?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator19" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadioListRAParentsHangoutUnknown"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="RadioListRAParentsHangoutUnknown" runat="server" RepeatLayout="Flow"
                                            RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRAParents4" runat="server" Text="Cannot state with whom the child spends free time with?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator20" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadioListRAParentsFriendsUnknown"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="RadioListRAParentsFriendsUnknown" runat="server" RepeatLayout="Flow"
                                            RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRAParents5" runat="server" Text="Not aware of problems in school?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator21" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadioListRAParentsNoSchoolProblems"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="RadioListRAParentsNoSchoolProblems" runat="server" RepeatLayout="Flow"
                                            RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <span class="sectionDivider"></span>
                                <div class="row">
                                    <h3 class="sectionHead">
                                        History</h3>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRAHistory1" runat="server" Text="Have documented instances of child abuse (physical, emotional, or sexual) or neglect?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator22" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadioListRAHistoryDocumentedAbuse"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="RadioListRAHistoryDocumentedAbuse" runat="server" RepeatLayout="Flow"
                                            RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRAHistory2" runat="server" Text="Physical evidence of abuse or neglect on youth (observed)?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator23" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadioListRAHistoryEvidenceAbuse"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="RadioListRAHistoryEvidenceAbuse" runat="server" RepeatLayout="Flow"
                                            RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRAHistory3" runat="server" Text="Had prior or current DCF involvement?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator24" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadioListRAHistoryDCFInvolvement"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="RadioListRAHistoryDCFInvolvement" runat="server" RepeatLayout="Flow"
                                            RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <span class="sectionDivider"></span>
                                <div class="row">
                                    <h3 class="sectionHead">
                                        Influence</h3>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRAInfluence1" runat="server" Text="Parent, guardian or sibling has prior criminal record?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator25" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadioListRAInfluenceFamilyCrimRecord"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="RadioListRAInfluenceFamilyCrimRecord" runat="server" RepeatLayout="Flow"
                                            RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRAInfluence2" runat="server" Text="Parent, guardian or sibling has prior jail or prison time?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator26" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadioListRAInfluenceFamilyPrison"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="RadioListRAInfluenceFamilyPrison" runat="server" RepeatLayout="Flow"
                                            RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRAInfluence3" runat="server" Text="Parent, guardian or sibling is on probation or parole?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator27" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadioListRAInfluenceFamilyParole"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="RadioListRAInfluenceFamilyParole" runat="server" RepeatLayout="Flow"
                                            RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="row">
                                </div>
                            </auth:SecureContent>
                        </telerik:RadPageView>
                        <telerik:RadPageView ID="RadPageView3" runat="server">
                            <auth:SecureContent ID="SecureContent6" ToggleVisible="false" ToggleEnabled="true"
                                EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
                                <div class="PrintSectionTitle FFPrinterBreak">
                                    <h2>
                                        Substance Abuse</h2>
                                    <span class="sectionDivider"></span>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRASubstanceAbuseTobacco" runat="server" Text="Used tobacco 3 or more times in the last 30 days?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator28" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadioListRAAbuseTobacco"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="RadioListRAAbuseTobacco" runat="server" RepeatLayout="Flow"
                                            RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRASubstanceAbuse3OrMore" runat="server" Text="Used drugs/alcohol 3 or more times in the last 30 days?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator29" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadioListRASubstanceAbuse3OrMore"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="RadioListRASubstanceAbuse3OrMore" runat="server" RepeatLayout="Flow"
                                            RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRASubstanceAbuseCharged" runat="server" Text="Been charged with drug-related offenses?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator30" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadioListRASubstanceAbuseCharged"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="RadioListRASubstanceAbuseCharged" runat="server" RepeatLayout="Flow"
                                            RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="row myRAclear">
                                </div>
                            </auth:SecureContent>
                        </telerik:RadPageView>
                        <telerik:RadPageView ID="RadPageView4" runat="server">
                            <auth:SecureContent ID="SecureContent7" ToggleVisible="false" ToggleEnabled="true"
                                EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
                                <div class="PrintSectionTitle">
                                    <h2>
                                        Individual</h2>
                                    <span class="sectionDivider"></span>
                                </div>
                                <div class="row">
                                    <h3 class="sectionHead">
                                        Stealing</h3>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRAStealing1" runat="server" Text="Repeatedly stolen from the family, house or neighbors?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator31" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="ListStealingRepeatedly"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="ListStealingRepeatedly" runat="server" RepeatLayout="Flow"
                                            RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRAStealing2" runat="server" Text="Been charged with burglary-related offenses?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator32" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="ListStealingBurglary"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="ListStealingBurglary" runat="server" RepeatLayout="Flow"
                                            RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <span class="sectionDivider"></span>
                                <div class="row">
                                    <h3 class="sectionHead">
                                        Running Away</h3>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRARunningAway1" runat="server" Text="Run away from home once for an extended period (one week or more)?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator33" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="ListRunAwayOnce"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="ListRunAwayOnce" runat="server" RepeatLayout="Flow" RepeatDirection="Horizontal"
                                            CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRARunningAway2" runat="server" Text="Run away from home 3 or more times in the pase 90 days?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator34" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="ListRunAway3Plus"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="ListRunAway3Plus" runat="server" RepeatLayout="Flow" RepeatDirection="Horizontal"
                                            CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRARunningAway3" runat="server" Text="Is currently a runaway?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator35" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="ListRunAwayCurrent"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="ListRunAwayCurrent" runat="server" RepeatLayout="Flow" RepeatDirection="Horizontal"
                                            CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <span class="sectionDivider"></span>
                                <div class="row IEPrinterBreak">
                                    <h3 class="sectionHead">
                                        Gangs</h3>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRAGangs1" runat="server" Text="Admitted to being a gang member?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator36" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="ListGangAdmitted"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="ListGangAdmitted" runat="server" RepeatLayout="Flow" RepeatDirection="Horizontal"
                                            CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRAGangs2" runat="server" Text="Reported by parents/guardian to be involved with gang activity?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator37" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="ListGangInvolvedWith"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="ListGangInvolvedWith" runat="server" RepeatLayout="Flow"
                                            RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRAGangs3" runat="server" Text="Identified by law enforcement as a gang member?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator38" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="ListGangIsMember"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="ListGangIsMember" runat="server" RepeatLayout="Flow" RepeatDirection="Horizontal"
                                            CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRAGangs4" runat="server" Text="Associated with youth involved with delinquent behavior?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator39" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="ListGangInvolvedWithDelinquencyYouth"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="ListGangInvolvedWithDelinquencyYouth" runat="server" RepeatLayout="Flow"
                                            RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRAGangs5" runat="server" Text="Associated with youth who have a delinquency record?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator40" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="ListGangAssociateWithDelinquencyRecordYouth"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="ListGangAssociateWithDelinquencyRecordYouth" runat="server"
                                            RepeatLayout="Flow" RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="row">
                                    <asp:Label ID="LabelRAGangs6" runat="server" Text="Youth has a delinquency record?"
                                        CssClass="myRALabel"></asp:Label>
                                    <div class="RAcheckboxes">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator41" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="ListGangDelinquencyRecord"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButtonList ID="ListGangDelinquencyRecord" runat="server" RepeatLayout="Flow"
                                            RepeatDirection="Horizontal" CssClass="myRAchoices">
                                            <asp:ListItem Value="True">Yes</asp:ListItem>
                                            <asp:ListItem Value="False">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                            </auth:SecureContent>
                        </telerik:RadPageView>
                    </telerik:RadMultiPage>
                    <div class="PrintSectionTitle">
                        <br />
                        <div class="row RARelease">
                            <uc1:ReleaseForm ID="ReleaseForm1" runat="server" AutoSelectReleased="False" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!--end tabcontent-->
    </div>
    <!--end tabcontainer-->
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="EditButtonsPlaceholder" runat="server">
    <asp:Panel ID="PanelMainContentEditButtons" runat="server">
        <div class="editButtons">
<%--            <auth:SecureContent ID="SecureContent2" ToggleVisible="true" ToggleEnabled="false"
                EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
                <asp:Button ID="DeleteButton" runat="server" Text="Delete" OnClientClick="return confirm('Are you sure you want to delete this Risk Assessment?')"
                    class="mybutton mydelete" OnClick="DeleteButton_Click" />
            </auth:SecureContent>--%>
            <asp:Button ID="PrintButton" runat="server" Text="Print" class="mybutton myprint"
                OnClientClick="window.print();return false;" />
<%--            <auth:SecureContent ID="SecureContent3" ToggleVisible="true" ToggleEnabled="false"
                EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
                <asp:Button ID="SaveButton" runat="server" Text="Save" ValidationGroup="Save" class="mybutton mysave"
                    OnClick="SaveButton_Click" />
            </auth:SecureContent>--%>
        </div>
    </asp:Panel>
</asp:Content>
