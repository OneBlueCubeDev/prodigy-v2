<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/Admin.Master"
    AutoEventWireup="true" CodeBehind="EnrollmentPage.aspx.cs" Inherits="POD.Pages.EnrollmentPage" %>

<%@ Register Src="../UserControls/AddEditAddress.ascx" TagName="AddEditAddress" TagPrefix="uc1" %>
<%@ Register Src="../UserControls/EnrollmentLinks.ascx" TagName="EnrollmentLinks"
    TagPrefix="uc2" %>
<%@ Register Src="../UserControls/AddEditPhoneNumber.ascx" TagName="AddEditPhoneNumber"
    TagPrefix="uc2" %>
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
            //auto saves dob date selection
            function DateSelectedDOB(sender, eventArgs) {
                selDate = eventArgs.get_newValue();

                // alert(selDate);
                if (selDate != '') {
                    var compareDate;
                    var pickerdate = $find("<%= RadDatePickerEnrollmentDate.ClientID %>").get_selectedDate();
                    if (pickerdate != null) {
                        compareDate = pickerdate;
                    }
                    else {
                        compareDate = new Date();
                    }
                    var dob = selDate.split('/');
                    if (dob.length === 3) {
                        born = new Date(dob[2], dob[1] * 1, dob[0]);


                        CalculateAge(selDate, compareDate);
                    }
                }
            }

            function DateSelectedApply(sender, eventArgs) {
                selDate = eventArgs.get_newValue();
                if (selDate != '') {
                    var compareDate;
                    var pickerdate = $find("<%= RadDatePickerDOB.ClientID %>").get_selectedDate();
                    if (pickerdate != null) {
                        compareDate = pickerdate;
                    }
                    else {
                        compareDate = new Date();
                    }

                    var splittedDate = selDate.split('/');
                    if (splittedDate.length === 3) {
                        applyDate = new Date(splittedDate[2], splittedDate[1] * 1, splittedDate[0]);
                        CalculateAge(compareDate, applyDate);
                    }
                }
            }
            function CalculateAge(birthdate, applyDate) {


                //alert(applyDate);

                var birthdate = new Date(birthdate);
                //alert(birthdate);
                var cur = new Date();
                var diff = cur - birthdate;
                var age = Math.floor(diff / 31536000000);

                //alert(age);
                //age = applyDate.getTime() - (birthdate.getTime()) / (365.25 * 24 * 60 * 60 * 1000);
                //age = Math.floor((applyDate.getTime() - birthdate.getTime()) / (365.25 * 24 * 60 * 60 * 1000));


                if (isNaN(age) || age < 0) {
                    //alert('Invalid Date');
                }
                else {

                    //var result = monthDiff(birthdate, cur);
                    //alert(result);
                    if (age > 18) {
                        //alert('Warning you are entering a person that is older than 18!');



                    }
                    $('.AgeClass').val(age);
                }

                //var ec = document.getElementById("ctl00_MainContentPlaceholder_RadNumericTextBoxAge").value;
                //alert('Age of the individual : ' + ec);

                if (Page_ClientValidate('Save')) {
                    //Your valid
                }
            }

            function monthDiff(d1, d2) {
                //alert('test');
                var months;
                months = (d2.getFullYear() - d1.getFullYear()) * 12;
                months -= d1.getMonth();
                months += d2.getMonth();
                return months <= 0 ? 0 : months;
            }

            function GetRadWindow() {
                var oWindow = null;
                if (window.radWindow)
                    oWindow = window.radWindow;
                else if (window.frameElement.radWindow)
                    oWindow = window.frameElement.radWindow;
                return oWindow;
            }

            function DownLoadCertificate(id, enrollID, type) {
                var oManager = GetRadWindowManager();
                oManager.closeActiveWindow();
                if (id.length > 0) {
                    var url = 'DownLoad.aspx?pid=' + id + "&eid=" + enrollID + "&tp=" + type;
                    //open new window
                    var owind = window.radopen(url, "ViewCertificate");
                    owind.set_visibleStatusbar(false);
                }

            }

            function ShowTransfer(id) {
                
                var oManager = GetRadWindowManager();
                oManager.closeActiveWindow();
                if (id.length > 0) {
                    var url = 'TransferYouthPage.aspx?pid=' + id;
                    //open new window
                    var owind = window.radopen(url, "ViewTransfer");
                    owind.set_visibleStatusbar(false);
                }
            }

            function ShowRelease(id, key, type) {
                
                var oManager = GetRadWindowManager();
                oManager.closeActiveWindow();
                if (id.length > 0) {
                    var url = 'ReleaseYouthPage.aspx?pid=' + id + '&eid=' + key + '&type=' + type;
                    //open new window
                    var owind = window.radopen(url, "ViewRelease");
                    owind.set_visibleStatusbar(false);
                }

            }

            

            function AddName() {
                var name = '';
                if ($('.FirstName').val() != '' && $('.LastName').val() != '') {
                    if ($('.MiddleName').val() != '') {
                        name = $('.FirstName').val() + ' ' + $('.MiddleName').val() + ' ' + $('.LastName').val();
                    } else {
                        name = $('.FirstName').val() + ' ' + $('.LastName').val();
                    }
                }
                if (name != '') {
                    $('.MedReleaseName').val(name);
                }

            }

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



            function CheckInitPAT(sender, eventArgs) {
                var item = eventArgs.get_item();
                alert("You selected " + item.get_text());

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
                $(".mytextarea").each(function () {
                    //Get Value
                    var textareaValue = $(this).val();
                    //Create div with value
                    $(this).after("<div class='PrintTextValue PrintTextAreaValue'>" + textareaValue + "</div>");
                });
            }

            $(document).ready(function ComboBoxFields() {

                //ComboBox Print Fields
                $("div.mydropdown").each(function () {
                    //Find dropdown field
                    var VisibleField = $(this).find(".rcbInput");
                    //Get Value
                    var comboValue = $(VisibleField).val();
                    //Create span with value
                    $(this).after("<span class='PrintComboValue'>" + comboValue + "</span>");
                });
                //TextBox Print Fields
                $(".mytextbox").each(function () {
                    //Get Value
                    var textboxValue = $(this).val();
                    //Create span with value
                    $(this).after("<span class='PrintTextValue'>" + textboxValue + "</span>");
                });

                $(".mytextbox").blur(function () {
                    PrintTextFieldSwap();
                });

                //TextArea Print Fields
                $(".mytextarea").each(function () {
                    //Get Value
                    var textareaValue = $(this).val();
                    //Create span with value
                    $(this).after("<div class='PrintTextValue PrintTextAreaValue'>" + textareaValue + "</div>");
                });

                $(".mytextarea").blur(function () {
                    PrintTextFieldSwap();
                });

                //Checkbox/Radio button check marks
                $("input[type='radio'][checked]").each(function () {
                    $(this).before("<span class='PrintListChecked'>" + "X" + "</span>");
                });
                $("input[type='checkbox'][checked]").each(function () {
                    $(this).before("<span class='PrintListChecked'>" + "X" + "</span>");
                });

                document.getElementById("ctl00_MainContentPlaceholder_RadNumericTextBoxAge_SpinUpButton").tabIndex = -1;
                document.getElementById("ctl00_MainContentPlaceholder_RadNumericTextBoxAge_SpinDownButton").tabIndex = -1;
                //document.getElementById("link3").tabIndex = 6;


            });
        </script>
    </telerik:RadScriptBlock>
    <telerik:RadAjaxManagerProxy ID="RadAjaxManagerProxy12" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadComboBoxSites">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxLocations" UpdatePanelRenderMode="Inline" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="Radcbyouthtype">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxGrantYear" />
                    
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>
    <telerik:RadTabStrip ID="RadTabStrip1" CausesValidation="false" runat="server" SelectedIndex="0"
        MultiPageID="RadMultiPage1">
        <Tabs>
            <telerik:RadTab runat="server" Selected="True" Text="Youth Info">
            </telerik:RadTab>
            <telerik:RadTab runat="server" Text="Transportation Release & Emergency Contact Information">
            </telerik:RadTab>
            <telerik:RadTab runat="server" Text="Medical Release & Informed Consents">
            </telerik:RadTab>
            <telerik:RadTab runat="server" Text="Youth Enrollment Notes">
            </telerik:RadTab>
        </Tabs>
    </telerik:RadTabStrip>
    <auth:SecureContent ID="SecureContent1" ToggleVisible="false" ToggleEnabled="true"
        EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
        <asp:HiddenField ID="hfpersonId" runat="server" />
        <asp:HiddenField ID="hfenrollmentId" runat="server" />
        <div class="tabcontainer">
            <div class="tabcontent">
                <div class="EnrollmentFormContainer">
                    <div class="LessonPlanPrintBlock">
                        <h1>
                            <img src="../../Templates/Images/prodigy_logo_print2.png" width="280px" height="133px"
                                alt="Prodigy" /></h1>
                        <h2>PRODIGY APPLICATION</h2>
                    </div>
                    <div class="entryDetails">
                        Created:
                        <asp:Label ID="LabelCreated" runat="Server"></asp:Label><br />
                        Last Edited:
                        <asp:Label ID="LabelEdited" runat="Server"></asp:Label>
                        <div class="sidetoolbar">
                            <ul>
                                <li id="lidischarge">
                                    <asp:Button ID="btndischargeform" runat="server" Visible="false" Text="Discharge Forms" OnClick="Update_Click"
                                        CssClass="mybutton" Width="130px" />
                                   
                                    
                                </li>
                                <li>
                                    <auth:SecureContent ID="SecureContent4" ToggleVisible="true" ToggleEnabled="false"
                                        EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
                                        <a href="#" id="TransferClient" visible="true" runat="server" class="transferClient"><span>Transfer
                                            Youth</span></a>
                                    </auth:SecureContent>
                                </li>
                                <li>
                                    <auth:SecureContent ID="SecureContent5" ToggleVisible="true" ToggleEnabled="false"
                                        EventHook="Load" runat="server" Roles="Administrators;">
                                        <asp:HyperLink ID="HyperLinkRelease"  runat="server" CssClass="releaseYouth"><span>Release Youth</span></asp:HyperLink>
                                    </auth:SecureContent>
                                </li>
                                
                                <%--<li>
                                    <auth:SecureContent ID="SecureContent6" ToggleVisible="true" ToggleEnabled="false"
                                        EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
                                        <a href="#" title="Create Certificate" id="CertificateLink" runat="server" class="createCertificate">
                                            <span>Create Certificate</span></a>
                                    </auth:SecureContent>
                                </li>--%>
                                <%--                                <li>
                                    <asp:HyperLink ID="HyperLinkRiskAssessment" runat="server" ToolTip="Risk Assessment"
                                        CssClass="riskAssessment">
                            <span>Risk Assessment</span></asp:HyperLink></li>--%>
                            </ul>
                        </div>
                    </div>
                    <telerik:RadMultiPage ID="RadMultiPage1" runat="server" ViewStateMode="Inherit" SelectedIndex="0">
                        <telerik:RadPageView ID="RadPageView1" runat="server">
                            <div class="PrintSectionTitle">
                                <h2>Youth Information</h2>
                                <span class="sectionDivider"></span>
                            </div>
                            <div class="row myenrollmentrace myenrollmentshortcontainer">
                                <p class="checklabel">
                                    <asp:Label ID="Label1" runat="server" Text="Site Youth Information:"
                                        class="mylabel"></asp:Label>
                                </p>
                                <asp:RadioButtonList ID="rbisdjjyouth" runat="server" RepeatDirection="Horizontal" onChange="enableDateAppliedValidation()">
                                    <asp:ListItem Text="DJJ Site Youth" Value="True"></asp:ListItem>
                                    <asp:ListItem Text="HC Site Youth" Value="False"></asp:ListItem>
                                </asp:RadioButtonList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" SetFocusOnError="True"
                                    ValidationGroup="Save" Display="Dynamic" ControlToValidate="rbisdjjyouth"
                                    CssClass="ErrorMessage" ErrorMessage="Required." Enabled="True" Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                <script type="text/javascript">
                                    function enableDateAppliedValidation() {

                                        var id = $('#<%=rbisdjjyouth.ClientID %> input[type=radio]:checked').val();

                                        var id2 = '<%=rbisdjjyouth.ClientID %>';
                                        var rb_hcyouth = document.getElementById("ctl00_MainContentPlaceholder_rbisdjjyouth_1");



                                        var DatePicker = $find('<%= RadDatePickerEnrollmentDate.ClientID %>');


                                        if (rb_hcyouth.checked) {

                                            DatePicker.set_enabled(true);;

                                        }
                                        else {
                                            DatePicker.set_enabled(false);

                                        }




                                    }
                                </script>
                            </div>
                            
                            <div class="row">

                                <h3 class="sectionHead">Demographic Information:</h3>

                                <div class="myenrollmentdatecontainer">
                                    <asp:Label ID="EnrollmentDate" runat="server" Text="Date Applied" CssClass="mylabel"></asp:Label>
                                    <telerik:RadDatePicker ID="RadDatePickerEnrollmentDate" runat="server" DateInput-Width="50px"
                                        Width="95px" DateInput-DisplayDateFormat="MM/dd/yy" ClientEvents-OnDateSelected="DateSelectedApply"
                                        Calendar-ShowRowHeaders="False" Enabled="false" Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup myenrollmentdate">
                                    </telerik:RadDatePicker>
                                    <%--<asp:RequiredFieldValidator ID="reqValEnrollmentDate" runat="server" SetFocusOnError="true"
                                        Display="Dynamic" ControlToValidate="RadDatePickerEnrollmentDate" ValidationGroup="Save"
                                        CssClass="ErrorMessage" ErrorMessage="Date Applied is required" Text="* Required"></asp:RequiredFieldValidator>--%>
                                </div>
                            </div>

                            <asp:Panel ID="PanelYouthType" runat="server" CssClass="row myenrollmentshortcontainer">
                                <asp:Label ID="LabelEnrollType" runat="server" Text="Youth Type" CssClass="mylabel myyouthtype"></asp:Label>
                                <telerik:RadComboBox ID="RadComboBoxType" DataValueField="EnrollmentTypeID" DataTextField="Name"
                                    runat="server" CssClass="mydropdown" OnClientSelectedIndexChanged="PrintFieldSwap">
                                </telerik:RadComboBox>
                            </asp:Panel>

                            <auth:SecureContent ID="SecureContent1000" ToggleEnabled="true"
                                    EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;Administrators-NA;CentralTeamUsers-NA;">
                                <div class="row myenrollmentshortcontainer">
                                        <asp:Label ID="LabelStatusType" runat="server" Text="Status" CssClass="mylabel myyouthtype"></asp:Label>
                                        <telerik:RadComboBox ID="RadComboBoxStatus" DataValueField="StatusTypeID" DataTextField="Description"
                                            runat="server" CssClass="mydropdown" OnClientSelectedIndexChanged="CheckInitPAT" > 
                                        </telerik:RadComboBox><br />
                                         
                                </div>
                            </auth:SecureContent>
                            <auth:SecureContent ID="secureLocation" runat="server" OnAuthorize="secureLocation_OnAuthorize"
                                EventHook="PreRender" ToggleVisible="True" ToggleEnabled="True">
                                <asp:Panel ID="PanelSites" runat="server" CssClass="row myenrollmentshortcontainer">
                                    <asp:Label ID="LabelSite" runat="server" Text="Site" CssClass="mylabel myyouthtype"></asp:Label>
                                    <telerik:RadComboBox ID="RadComboBoxSites" DataValueField="LocationID" DataTextField="SiteName"
                                        runat="server" CssClass="mydropdown">
                                    </telerik:RadComboBox>
                                    <asp:RequiredFieldValidator ID="reqSiteValidator1" runat="server" SetFocusOnError="true"
                                        Display="Dynamic" ControlToValidate="RadComboBoxSites" InitialValue="All" ValidationGroup="Save"
                                        CssClass="ErrorMessage" ErrorMessage="Select a Site" Text="* Required"></asp:RequiredFieldValidator>
                                </asp:Panel>
                                <%--<asp:Panel ID="PanelLocations" runat="server" CssClass="row myenrollmentshortcontainer">
                                    <asp:Label ID="LabelLocation" runat="server" Text="Location" CssClass="mylabel myyouthtype"></asp:Label>
                                    <telerik:RadComboBox ID="RadComboBoxLocations" DataValueField="LocationID" DataTextField="Name" 
                                        runat="server" CssClass="mydropdown" OnClientSelectedIndexChanged="PrintFieldSwap"></telerik:RadComboBox>
                                </asp:Panel>--%>
                            </auth:SecureContent>
                            <div class="row myenrollmentrace myenrollmentshortcontainer">
                                <asp:Label ID="EnrollmentRace" runat="server" Text="Race:" CssClass="mylabel"></asp:Label>
                                <telerik:RadFormDecorator ID="RadFormDecorator1" runat="server" />
                                <asp:CheckBoxList ID="CheckBoxListRaces" runat="server" DataTextField="Name" DataValueField="RaceID"
                                    CssClass="enrollmentRaceFields SingleChoiceCheckboxTable" RepeatLayout="Table" RepeatColumns="4"
                                    RepeatDirection="Horizontal" CausesValidation="True" ValidationGroup="Save" AutoPostBack="True">
                                </asp:CheckBoxList>
                                <asp:CustomValidator ID="raceRequired" runat="server" SetFocusOnError="true"
                                    ValidationGroup="Save" Display="Dynamic" CssClass="ErrorMessage"
                                    ErrorMessage="Race is Required." Text="* Required" OnServerValidate="CustomValidatorRace_ServerValidate"
                                    ClientValidationFunction="CustomValidatorRace_ClientValidate"></asp:CustomValidator>
                                <script type="text/javascript">
                                    function CustomValidatorRace_ClientValidate(source, arguments) {
                                        var ec = document.getElementById("ctl00_MainContentPlaceholder_CheckBoxListRaces");
                                        var chkListModules = document.getElementById('<%= CheckBoxListRaces.ClientID %>');
                                        var chkListinputs = chkListModules.getElementsByTagName("input");
                                        for (var i = 0; i < chkListinputs.length; i++) {
                                            if (chkListinputs[i].checked) {
                                                arguments.IsValid = true;
                                                return;
                                            }
                                        }
                                        arguments.IsValid = false;
                                    }
                                </script>

                            </div>

                            <div class="row myenrollmentethnicity">
                                <asp:Label ID="EnrollmentEthnicity" runat="server" Text="Ethnicity:" CssClass="mylabel"></asp:Label>
                                <telerik:RadFormDecorator ID="RadFormDecorator2" runat="server" />
                                <asp:CheckBoxList ID="CheckBoxListEthnicity" runat="server" DataTextField="Name"
                                    DataValueField="EthnicityID" CssClass="enrollmentEthnicityFields SingleChoiceCheckboxTable" RepeatLayout="Table"
                                    RepeatColumns="4" RepeatDirection="Horizontal" CausesValidation="True"
                                    ValidationGroup="Save" AutoPostBack="True">
                                </asp:CheckBoxList>
                                <asp:CustomValidator ID="ethnicityRequired" runat="server" SetFocusOnError="true"
                                    ValidationGroup="Save" Display="Dynamic" CssClass="ErrorMessage"
                                    ErrorMessage="Ethnicity is Required." Text="* Required" OnServerValidate="CustomValidatorEthnicity_ServerValidate"
                                    ClientValidationFunction="CustomValidatorEthnicity_ClientValidate"></asp:CustomValidator>
                                <script type="text/javascript">
                                    function CustomValidatorEthnicity_ClientValidate(source, arguments) {
                                        var ec = document.getElementById("ctl00_MainContentPlaceholder_CheckBoxListEthnicity");
                                        var chkListModules = document.getElementById('<%= CheckBoxListEthnicity.ClientID %>');
                                        var chkListinputs = chkListModules.getElementsByTagName("input");
                                        for (var i = 0; i < chkListinputs.length; i++) {
                                            if (chkListinputs[i].checked) {
                                                arguments.IsValid = true;
                                                return;
                                            }
                                        }
                                        arguments.IsValid = false;
                                    }
                                </script>

                            </div>
                            <div class="row">
                                <asp:Label ID="EnrollmentGender" runat="server" Text="Gender:" CssClass="mylabel"></asp:Label>
                                <telerik:RadFormDecorator ID="RadFormDecorator3" runat="server" />
                                <asp:RadioButtonList ID="RadioListGender" runat="server" DataTextField="Name" DataValueField="GenderID"
                                    RepeatDirection="Horizontal" CssClass="enrollmentGenderFields">
                                </asp:RadioButtonList>
                                <asp:RequiredFieldValidator ID="genderRequired" runat="server" SetFocusOnError="true"
                                    ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadioListGender" CssClass="ErrorMessage"
                                    ErrorMessage="Required." Text="* Required"></asp:RequiredFieldValidator>
                            </div>
                            <%--<div class="row">
                                <asp:Label ID="LabelProgramEligibilityTool" runat="server" Text="Has Program Eligibility Tool been completed?" CssClass="mylabel"></asp:Label>
                                <asp:CheckBox ID="CheckboxProgramElibilityToolYes" runat="server" Text="Yes" />
                            </div>--%>
                            <div class="myenrollmentcurrentlyenrolled">
                                <auth:SecureContent ID="SecureContent9" ToggleVisible="false" ToggleEnabled="false"
                                    EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;Administrators-NA;CentralTeamUsers-NA;">
                                    <asp:Label ID="LabelWrapAroundServices" runat="server" Text="Enrolled in wrap around services?" CssClass="mylabel" Visible="false"></asp:Label>
                                    <asp:RadioButtonList ID="RadioButtonListWrapAroundServices" runat="server"
                                        RepeatDirection="Horizontal" Visible="false">
                                        <asp:ListItem Text="Yes" Value="True"></asp:ListItem>
                                        <asp:ListItem Text="No" Value="False"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </auth:SecureContent>
                            </div>

                            <span class="sectionDivider"></span>
                            <div class="row">
                             <h3 class="sectionHead">Prevention Web Information:</h3>
                            <div class="row">
                                 <auth:SecureContent ID="SecureContent6" ToggleEnabled="true"
                                    EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;Administrators-NA;CentralTeamUsers-NA;">
                                    <div class="myenrollmentlastname">
                                        <asp:Label ID="LabelEnrollmentID" runat="server" Text="DJJ ID#" CssClass="mylabel"></asp:Label>
                                        <asp:TextBox ID="EnrollmentIDTextBox" runat="server" CssClass="myfield"></asp:TextBox>
                                        
                                    </div>
                                     </auth:SecureContent>
                                </div>

                               
                            <div class="row">
                                 <auth:SecureContent ID="SecureContent8" ToggleEnabled="true"
                                    EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;Administrators-NA;CentralTeamUsers-NA;">
                                    <asp:Label ID="prewebdateadmitted" runat="server" Text="Prevention Web Date Admitted:" class="mylabel"></asp:Label>
                                    <telerik:RadDatePicker ID="rdpprewebdateadmitted" runat="server" DateInput-Width="50px"
                                            Width="95px" DateInput-DisplayDateFormat="MM/dd/yy" 
                                            Calendar-ShowRowHeaders="False" Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup myenrollmentdate">
                                        </telerik:RadDatePicker>
                               </auth:SecureContent>
                            </div>
                                    
                                </div>
                            <div class="ParticipantInfoSection">
                                <div class="row">
                                    <h3 class="sectionHead">Participant Information:</h3>
                                    
                                </div>

                                <div class="row">
                                    <div class="myenrollmentlastname">
                                        <asp:Label ID="EnrollmentLastName" runat="server" Text="Last Name" CssClass="mylabel"></asp:Label>
                                        <asp:TextBox ID="EnrollmentLastNameTextBox" onblur="AddName();" runat="server" CssClass="LastName myfield capitalize"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="ReqValFirstNamePart" runat="server" SetFocusOnError="true"
                                            Display="Dynamic" ControlToValidate="EnrollmentLastNameTextBox" ValidationGroup="Save"
                                            CssClass="ErrorMessage" ErrorMessage="Participant's Last Name is required." Text="* Required"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="myenrollmentfirstname">
                                        <asp:Label ID="EnrollmentFirstName" runat="server" Text="First Name" CssClass="mylabel"></asp:Label>
                                        <asp:TextBox ID="EnrollmentFirstNameTextBox" runat="server" onblur="AddName();" CssClass="FirstName myfield capitalize"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="ReqValLastNamePart" runat="server" SetFocusOnError="true"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="EnrollmentFirstNameTextBox"
                                            CssClass="ErrorMessage" ErrorMessage="Participant's First Name is required."
                                            Text="* Required"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="myenrollmentMI">
                                        <asp:Label ID="EnrollmentMI" runat="server" Text="MI" CssClass="mylabel"></asp:Label>
                                        <asp:TextBox ID="EnrollmentMITextBox" runat="server" onblur="AddName();" CssClass="MiddleName myfield capitalize"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="myenrollmentssn">
                                        <asp:Label ID="EnrollmentSSN" runat="server" Text="Last 4 of SSN" CssClass="mylabel"></asp:Label>
                                        <asp:TextBox ID="EnrollmentSSNTextBox" runat="server" CssClass="MiddleName myfield capitalize"></asp:TextBox>

                                    </div>
                                </div>

                                <div class="row">

                                    <div class="myenrollmentstudentid">

                                        <asp:Label ID="EnrollmentStudentID" runat="server" Text="Student ID" CssClass="mylabel"></asp:Label>
                                        <asp:TextBox ID="EnrollmentStudentIDTextBox" runat="server" CssClass="MiddleName myfield capitalize"></asp:TextBox>
                                        <%--<asp:CustomValidator ID="CV2" CssClass="ErrorMessage" 
                                            ControlToValidate="EnrollmentStudentIDTextBox" runat="server" SetFocusOnError="true" Display="Dynamic" 
                                            OnServerValidate="SSN_StudentID_ServerValidate" ValidateEmptyText="true" ErrorMessage="Please enter either Student Last 4 SSN or Student ID" 
                                            ValidationGroup="Save" Text="* Required - Please enter either Student Last 4 SSN or Student ID" />--%>
                                        <%--<script type="text/javascript">
                                    function CustomValidatorRace_ClientValidate(source, arguments) {
                                        
                                    }
                                </script>--%>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="myenrollmentdobcontainer">
                                        <asp:Label ID="EnrollmentDOB" runat="server" Text="DOB" CssClass="mylabel"></asp:Label>
                                        <telerik:RadDatePicker ID="RadDatePickerDOB" runat="server" MinDate="1/1/1900" DateInput-Width="50px"
                                            Width="42%" DateInput-DisplayDateFormat="MM/dd/yy" Calendar-ShowRowHeaders="False"
                                            ClientEvents-OnDateSelected="DateSelectedDOB" Calendar-CssClass="myDatePickerPopup"
                                            CssClass="myDatePickerPopup myenrollmentdob">
                                        </telerik:RadDatePicker>
                                        <asp:RequiredFieldValidator ID="ReqValDOBPart" runat="server" SetFocusOnError="true"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadDatePickerDOB"
                                            CssClass="ErrorMessage" ErrorMessage="Participant's Date of Birth is required."
                                            Text="* Required"></asp:RequiredFieldValidator>

                                    </div>
                                </div>
                                <div class="row">
                                    <div class="myenrollmentage">
                                        <asp:Label ID="EnrollmentAge" runat="server" Text="Age" CssClass="mylabel"></asp:Label>
                                        <telerik:RadNumericTextBox ID="RadNumericTextBoxAge" TabIndex="-1" Enabled="false" runat="server" CssClass="myfield AgeClass"
                                            ShowSpinButtons="true" MaxLength="2" ReadOnly="true" NumberFormat-DecimalDigits="0" WrapperCssClass="myenrollmentagebox"
                                            Width="50px">
                                        </telerik:RadNumericTextBox>

                                        <asp:CustomValidator ID="cvAge" runat="server" SetFocusOnError="true"
                                            ValidationGroup="Save" Display="Dynamic" CssClass="ErrorMessage"
                                            ErrorMessage="Age range must be between 5 and 17" Text="Age range must be between 5 and 17"
                                            ClientValidationFunction="Age_ClientValidate"></asp:CustomValidator>
                                        <script type="text/javascript">

                                            function Age_ClientValidate(source, arguments) {
                                                var ec = document.getElementById("ctl00_MainContentPlaceholder_RadNumericTextBoxAge").value;
                                                //alert(ec);
                                                var cur = convertDate(new Date());
                                                //alert("today: " + cur);
                                                var birthday = document.getElementById("ctl00_MainContentPlaceholder_RadDatePickerDOB").value;
                                                //alert("birthday: " + birthday);


                                                var result2 = getMonthDifference(new Date(birthday), new Date(cur));
                                                //var result = monthDiff("2000-01-01", cur);

                                                //alert("result: " + result2);

                                                if (result2 >= 60 && result2 <= 222) {
                                                    arguments.IsValid = true;
                                                    //alert('valid');
                                                } else {
                                                    arguments.IsValid = false;
                                                    // alert('invalid');
                                                }

                                            }

                                            function getMonthDifference(startDate, endDate) {
                                                return (
                                                    endDate.getMonth() -
                                                    startDate.getMonth() +
                                                    12 * (endDate.getFullYear() - startDate.getFullYear())
                                                );
                                            }

                                            function convertDate(date) {
                                                var yyyy = date.getFullYear().toString();
                                                var mm = (date.getMonth() + 1).toString();
                                                var dd = date.getDate().toString();

                                                var mmChars = mm.split('');
                                                var ddChars = dd.split('');

                                                return yyyy + '-' + (mmChars[1] ? mm : "0" + mmChars[0]) + '-' + (ddChars[1] ? dd : "0" + ddChars[0]);
                                            }

                                        </script>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="myenrollmentlanguage">
                                        <asp:Label ID="EnrollmentLanguage" runat="server" Text="Primary Language Spoken"
                                            class="mylabel"></asp:Label>
                                        <asp:TextBox ID="EnrollmentLanguageTextBox" runat="server" CssClass="myfield"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="ParticipantAddress">
                                    <uc1:AddEditAddress ID="ParticipantAddress" runat="server" />
                                </div>
                            </div>
                            <div class="row">
                                <p class="checklabel">
                                    <asp:Label ID="RiskAssessmentParentStatus" runat="server" Text="Youth Parental Status (of the youth admitted to your program):"
                                        class="mylabel"></asp:Label>
                                </p>
                                <telerik:RadFormDecorator ID="RadFormDecorator8" runat="server" />
                                <asp:RadioButtonList ID="RadioButtonListRiskAssessmentYouthParentalStatus" runat="server" DataTextField="Name"
                                    CssClass="riskassessmentParentStatusFields" RepeatLayout="Table" RepeatDirection="Horizontal">
                                    <asp:ListItem Value="None">None</asp:ListItem>
                                    <asp:ListItem Value="Youth is Pregnant">Youth is Pregnant</asp:ListItem>
                                    <asp:ListItem Value="Youth is a mother">Youth is a mother</asp:ListItem>
                                    <asp:ListItem Value="Youth is a father">Youth is a father</asp:ListItem>
                                </asp:RadioButtonList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorRiskAssessmentParentStatus" runat="server" Display="Dynamic"
                                    Text="* Required" CssClass="ErrorMessage" ControlToValidate="RadioButtonListRiskAssessmentYouthParentalStatus"
                                    ErrorMessage="* Required" ValidationGroup="Save" Enabled="true" InitialValue=""></asp:RequiredFieldValidator>

                            </div>
                            <div class="row">
                                <p class="checklabel">
                                    <asp:Label ID="RiskAssessmentFamilyStatus" runat="server" Text="Family Status:"
                                        class="mylabel"></asp:Label>
                                </p>
                                <telerik:RadFormDecorator ID="RadFormDecorator9" runat="server" />
                                <asp:RadioButtonList ID="RadioButtonListRiskAssessmentFamilyStatus" runat="server" DataTextField="Name"
                                    CssClass="riskassessmentRefferalFields" RepeatLayout="Table" RepeatDirection="Horizontal"
                                    RepeatColumns="4" onChange="enableFamilyStatusOtherValidation()">
                                    <asp:ListItem Value="Lives with two parents">Lives with two parents</asp:ListItem>
                                    <asp:ListItem Value="Lives with single mother">Lives with single mother</asp:ListItem>
                                    <asp:ListItem Value="Lives with single father">Lives with single father</asp:ListItem>
                                    <asp:ListItem Value="Lives with relative(s)">Lives with relative(s)</asp:ListItem>
                                    <asp:ListItem Value="Lives with non-relative(s)">Lives with non-relative(s)</asp:ListItem>
                                    <asp:ListItem Value="Foster Care">Foster Care</asp:ListItem>
                                    <asp:ListItem Value="Other">Other</asp:ListItem>
                                </asp:RadioButtonList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorFamilyStatus" runat="server" Display="Dynamic"
                                    Text="* Required" CssClass="ErrorMessage" ControlToValidate="RadioButtonListRiskAssessmentFamilyStatus"
                                    ErrorMessage="* Required" ValidationGroup="Save" Enabled="true" InitialValue=""></asp:RequiredFieldValidator>

                                <asp:CustomValidator ID="CustomValidatorFamilyStatus" runat="server" SetFocusOnError="true"
                                    ValidationGroup="Save" Display="Dynamic" CssClass="ErrorMessage"
                                    ErrorMessage="Family Status is Required." Text="* Required" OnServerValidate="CustomValidatorFamilyStatusValidator_ServerValidate"
                                    EnableClientScript="true"></asp:CustomValidator>
                                <script type="text/javascript">
                                    function enableFamilyStatusOtherValidation() {
                                        var id = '<%=RadioButtonListRiskAssessmentFamilyStatus.ClientID %>';
                                        var radioButtonlist = document.getElementById(id);
                                        var buttonValue = '';

                                        var listItems = radioButtonlist.getElementsByTagName("input");
                                        for (var i = 0; i < listItems.length; i++) {
                                            if (listItems[i].checked) {
                                                buttonValue = listItems[i].value;
                                            }
                                        }

                                        var clientId = '<%=TextBoxFamilyStatusOtherValidator.ClientID %>';
                                        var el = document.getElementById(clientId);
                                        if (buttonValue == 'Other') {
                                            ValidatorEnable(el, true);
                                        }
                                        else {
                                            ValidatorEnable(el, false);
                                        }
                                    }
                                </script>
                                <div class="row">
                                    <asp:Label ID="Label2" runat="server" class="mylabel">OR Other:</asp:Label>
                                    <asp:TextBox ID="TextBoxFamilyStatusOther" runat="server" MaxLength="44" CssClass=""></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="TextBoxFamilyStatusOtherValidator" runat="server" Display="Dynamic"
                                        Text="* Required" CssClass="ErrorMessage" ControlToValidate="TextBoxFamilyStatusOther"
                                        ErrorMessage="" ValidationGroup="Save" Enabled="false"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="row">
                                <p class="checklabel">
                                    <asp:Label ID="RiskAssessmentRefferal" runat="server" Text="Youth was referred by:"
                                        class="mylabel"></asp:Label>
                                </p>
                                <telerik:RadFormDecorator ID="RadFormDecorator10" runat="server" />
                                <asp:RadioButtonList ID="RadioButtonListRiskAssessmentReferral" runat="server" DataTextField="Name"
                                    CssClass="riskassessmentRefferalFields" RepeatLayout="Table" RepeatDirection="Horizontal"
                                    RepeatColumns="5" onChange="enableReferralOtherValidation()">
                                    <asp:ListItem Value="Self or Family">Self or Family</asp:ListItem>
                                    <asp:ListItem Value="School">School</asp:ListItem>
                                    <asp:ListItem Value="DCF">DCF</asp:ListItem>

                                    <asp:ListItem Value="Other">Other</asp:ListItem>
                                </asp:RadioButtonList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorRadioButtonListRiskAssessmentReferral" runat="server" Display="Dynamic"
                                    Text="* Required" CssClass="ErrorMessage" ControlToValidate="RadioButtonListRiskAssessmentReferral"
                                    ErrorMessage="* Required" ValidationGroup="Save" Enabled="true" InitialValue=""></asp:RequiredFieldValidator>

                                <script type="text/javascript">
                                    function enableReferralOtherValidation() {
                                        var id = '<%=RadioButtonListRiskAssessmentReferral.ClientID %>';
                                        var radioButtonlist = document.getElementById(id);
                                        var buttonIndex = -1;

                                        var listItems = radioButtonlist.getElementsByTagName("input");
                                        for (var i = 0; i < listItems.length; i++) {
                                            if (listItems[i].checked) {
                                                buttonIndex = i;
                                            }
                                        }

                                        var clientId = '<%=RiskAssessmentReferralOtherTextBoxRequiredFieldValidator.ClientID %>';
                                        var el = document.getElementById(clientId);
                                        if (buttonIndex >= 5) {
                                            ValidatorEnable(el, true);
                                        }
                                        else {
                                            ValidatorEnable(el, false);
                                        }
                                    }
                                </script>
                                <div class="row">
                                    <asp:TextBox ID="RiskAssessmentReferralOtherTextBox" runat="server" class="" MaxLength="44"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RiskAssessmentReferralOtherTextBoxRequiredFieldValidator" runat="server" Display="Dynamic"
                                        Text="* Required" CssClass="ErrorMessage" ControlToValidate="RiskAssessmentReferralOtherTextBox"
                                        ErrorMessage="" ValidationGroup="Save" Enabled="false"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="row">
                                <p class="checklabel">
                                    <asp:Label ID="Label5" runat="server" Text="Does youth receive free/reduced lunch:"
                                        class="mylabel"></asp:Label>
                                </p>
                                <asp:RadioButtonList ID="rbllunch" runat="server" RepeatDirection="Horizontal">
                                    <asp:ListItem Text="Yes" Value="True"></asp:ListItem>
                                    <asp:ListItem Text="No" Value="False"></asp:ListItem>
                                </asp:RadioButtonList>
                                <asp:RequiredFieldValidator ID="rfvlunch" runat="server" SetFocusOnError="True"
                                    ValidationGroup="Save" Display="Dynamic" ControlToValidate="rbllunch"
                                    CssClass="ErrorMessage" ErrorMessage="Required." Enabled="True" Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                            </div>
                            <div class="row">
                                <p class="checklabel">
                                    <asp:Label ID="Label6" runat="server" Text="Is youth currently in foster care:"
                                        class="mylabel"></asp:Label>
                                </p>
                                <asp:RadioButtonList ID="rblfoster" runat="server" RepeatDirection="Horizontal">
                                    <asp:ListItem Text="Yes" Value="True"></asp:ListItem>
                                    <asp:ListItem Text="No" Value="False"></asp:ListItem>
                                </asp:RadioButtonList>
                                <asp:RequiredFieldValidator ID="rfvfoster" runat="server" SetFocusOnError="True"
                                    ValidationGroup="Save" Display="Dynamic" ControlToValidate="rblfoster"
                                    CssClass="ErrorMessage" ErrorMessage="Required." Enabled="True" Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                            </div>
                            <div class="row">
                                <p class="checklabel">
                                    <asp:Label ID="Label7" runat="server" Text="Do you receive food stamps and/or Medicaid assistance:"
                                        class="mylabel"></asp:Label>
                                </p>
                                <asp:RadioButtonList ID="rblmedicaid" runat="server" RepeatDirection="Horizontal">
                                    <asp:ListItem Text="Yes" Value="True"></asp:ListItem>
                                    <asp:ListItem Text="No" Value="False"></asp:ListItem>
                                </asp:RadioButtonList>
                                <asp:RequiredFieldValidator ID="rfvmedicaid" runat="server" SetFocusOnError="True"
                                    ValidationGroup="Save" Display="Dynamic" ControlToValidate="rblmedicaid"
                                    CssClass="ErrorMessage" ErrorMessage="Required." Enabled="True" Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                            </div>
                            <span class="sectionDivider"></span>
                            <div class="ParentGuardianInfoSection">
                                <div class="row CCPrinterBreak">
                                    <h3 class="sectionHead">Parent/Legal Guardian Information:</h3>
                                    <p style="font-weight: bold">&nbsp;&nbsp; Please note that individual(s) listed below is (are) designated as emergency contact(s) for this participant.</p>
                                </div>

                                <div class="row">
                                    <div class="subtitle">
                                        Parent/Legal Guardian #1
                                    </div>
                                    <div class="myenrollmentlastname">
                                        <asp:Label ID="EnrollmentParentLastName" runat="server" Text="Last Name" CssClass="mylabel"></asp:Label>
                                        <asp:TextBox ID="EnrollmentParentLastNameTextBox" runat="server" CssClass="myfield capitalize"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="ReqValParentLastName" runat="server" SetFocusOnError="true"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="EnrollmentParentLastNameTextBox"
                                            CssClass="ErrorMessage" ErrorMessage="Parent/Guardian's Last Name is required."
                                            Text="* Required"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="myenrollmentfirstname">
                                        <asp:Label ID="EnrollmentParent1FirstName" runat="server" Text="First Name" CssClass="mylabel"></asp:Label>
                                        <asp:TextBox ID="EnrollmentParent1FirstNameTextBox" runat="server" CssClass="myfield capitalize"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="ReqValParentFirstName" runat="server" SetFocusOnError="true"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="EnrollmentParent1FirstNameTextBox"
                                            CssClass="ErrorMessage" ErrorMessage="Parent/Guardian's First Name is required."
                                            Text="* Required"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="myenrollmentMI">
                                        <asp:Label ID="EnrollmentParent1MI" runat="server" Text="MI" CssClass="mylabel"></asp:Label>
                                        <asp:TextBox ID="EnrollmentParent1MITextBox" runat="server" CssClass="myfield capitalize"></asp:TextBox>
                                    </div>
                                </div>
                                <div>
                                    <div class="myenrollmenthomephone ParentHomePhone">
                                        <uc2:AddEditPhoneNumber ID="GuardianHomePhone" runat="server" />
                                    </div>
                                </div>
                                <div>
                                    <div class="myenrollmenthomephone ParentWorkPhone">
                                        <uc2:AddEditPhoneNumber ID="GuardianWorkPhone" runat="server" />
                                    </div>
                                </div>
                                <div>
                                    <div class="myenrollmenthomephone ParentCellPhone">
                                        <uc2:AddEditPhoneNumber ID="GuardianCellPhone" runat="server" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="myenrollmentparentemail">
                                        <asp:Label ID="EnrollmentParent1Email" runat="server" Text="Email Address" CssClass="mylabel"></asp:Label>
                                        <asp:TextBox ID="EnrollmentParentEmail1TextBox" Width="180" runat="server" CssClass="myfield"></asp:TextBox>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidatorEmailTextBox" runat="server"
                                            ControlToValidate="EnrollmentParentEmail1TextBox" Display="Dynamic" CssClass="ErrorMessage"
                                            ValidationGroup="Save" ErrorMessage="Email address is not valid" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                                        <br />
                                        <%--<asp:Label runat="server" Text="Emergency Contact" CssClass="myLabel"></asp:Label>--%>
                                        <%-- <asp:CheckBox ID="EnrollmentParent1EmergencyContactCheckBox" runat="server" 
                                             Text=" (By selecting this box you are authorizing this individual to drop off/pick up youth.)" 
                                             CssClass="IsEmergencyContact" />--%>
                                    </div>
                                </div>

                                <div class="row">
                                    <asp:Label ID="EnrollmentParent1Relationship" runat="server" Text="Relationship to Youth:"
                                        CssClass="mylabel myRelationshipLabel"></asp:Label>
                                    <telerik:RadFormDecorator ID="RadFormDecorator4" runat="server" />
                                    <div class="enrollmentRelationshipFields">
                                        <asp:RadioButtonList ID="RadiobuttonListRelation1" runat="server" DataTextField="Name"
                                            DataValueField="PersonRelationshipTypeID" RepeatDirection="Horizontal" onChange="enableParent1Validation()" CssClass="" RepeatLayout="Table" RepeatColumns="4">
                                        </asp:RadioButtonList>
                                        <script type="text/javascript">
                                            function enableParent1Validation() {

                                                var buttonIndex = $('#<%=RadiobuttonListRelation1.ClientID %> input[type=radio]:checked').val();
                                                var clientId1 = '<%=ReqFieldValParent1Other.ClientID %>';

                                                var el1 = document.getElementById(clientId1);

                                                if (buttonIndex === '16') {

                                                    ValidatorEnable(el1, true);
                                                } else {
                                                    ValidatorEnable(el1, false);
                                                }


                                            }
                                        </script>
                                        <asp:TextBox ID="EnrollmentParent1RelationshipOther" runat="server" class="" MaxLength="44"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="ReqFieldValParent1Other" runat="server" SetFocusOnError="true"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="EnrollmentParent1RelationshipOther"
                                            CssClass="ErrorMessage" Enabled="False" ErrorMessage="Parent/Guardian's other relationship is required."
                                            Text="* Required"></asp:RequiredFieldValidator>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" SetFocusOnError="true"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadiobuttonListRelation1"
                                            CssClass="ErrorMessage" ErrorMessage="Parent/Guardian's relationship is required."
                                            Text="* Required"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="row">
                                    <a id="g1clear" onclick="clearguardianfields("1")" ></a>
                                    <a href='javascript:;' onclick='clearguardianfields(1);'>Clear Guardian</a>
                                    
                                </div>


                                <br />
                                <div class="row">
                                    <div class="subtitle">
                                        Parent/Legal Guardian #2
                                    </div>
                                    <div class="myenrollmentlastname">
                                        <asp:Label ID="EnrollmentParent2LastName" runat="server" Text="Last Name" CssClass="mylabel"></asp:Label>
                                        <asp:TextBox ID="EnrollmentParent2LastNameTextBox" runat="server" CssClass="myfield capitalize"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="myenrollmentfirstname">
                                        <asp:Label ID="EnrollmentParent2FirstName" runat="server" Text="First Name" CssClass="mylabel"></asp:Label>
                                        <asp:TextBox ID="EnrollmentParent2FirstNameTextBox" runat="server" CssClass="myfield capitalize"></asp:TextBox>
                                    </div>
                                    <div class="myenrollmentMI">
                                        <asp:Label ID="EnrollmentParent2MI" runat="server" Text="MI" CssClass="mylabel"></asp:Label>
                                        <asp:TextBox ID="EnrollmentParent2MITextBox" runat="server" CssClass="myfield capitalize"></asp:TextBox>
                                    </div>
                                </div>
                                <div>
                                    <div class="myenrollmenthomephone ParentHomePhone">
                                        <uc2:AddEditPhoneNumber ID="Guardian2HomePhone" runat="server" />
                                    </div>
                                </div>
                                <div>
                                    <div class="myenrollmenthomephone ParentWorkPhone">
                                        <uc2:AddEditPhoneNumber ID="Guardian2WorkPhone" runat="server" />
                                    </div>
                                </div>
                                <div>
                                    <div class="myenrollmenthomephone ParentCellPhone">
                                        <uc2:AddEditPhoneNumber ID="Guardian2CellPhone" runat="server" />
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="myenrollmentparentemail">
                                        <asp:Label ID="EnrollmentParent2Email" runat="server" Text="Email Address" CssClass="mylabel"></asp:Label>
                                        <asp:TextBox ID="EnrollmentParent2EmailTextBox" Width="180" runat="server" CssClass="myfield"></asp:TextBox>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="EnrollmentParent2EmailTextBox"
                                            Display="Dynamic" CssClass="ErrorMessage" ValidationGroup="Save" ErrorMessage="Email address is not valid"
                                            ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                                        <br />
                                        <%--<asp:Label ID="Label1" runat="server" Text="Emergency Contact" CssClass="myLabel"></asp:Label>
                                         <asp:CheckBox ID="EnrollmentParent2EmergencyContactCheckBox" runat="server" 
                                             Text=" (By selecting this box you are authorizing this individual to drop off/pick up youth.)" 
                                             CssClass="IsEmergencyContact" />--%>
                                    </div>
                                </div>

                                <div class="row">
                                    <asp:Label ID="LabelRelationShip" runat="server" Text="Relationship to Youth:" CssClass="mylabel myRelationshipLabel"></asp:Label>
                                    <telerik:RadFormDecorator ID="RadFormDecorator5" runat="server" />
                                    <div class="enrollmentRelationshipFields">
                                        <asp:RadioButtonList ID="RadiobuttonListRelation2" runat="server" DataTextField="Name"
                                            DataValueField="PersonRelationshipTypeID" RepeatDirection="Horizontal" CssClass="" onChange="enableParent2Validation()" RepeatLayout="Table" RepeatColumns="4">
                                        </asp:RadioButtonList>
                                        <script type="text/javascript">
                                            function enableParent2Validation() {

                                                var buttonIndex = $('#<%=RadiobuttonListRelation2.ClientID %> input[type=radio]:checked').val();
                                                var clientId1 = '<%=ReqFieldValParent2Other.ClientID %>';

                                                var el1 = document.getElementById(clientId1);

                                                if (buttonIndex === '16') {

                                                    ValidatorEnable(el1, true);
                                                } else {
                                                    ValidatorEnable(el1, false);
                                                }


                                            }
                                        </script>
                                        <asp:TextBox ID="EnrollmentParent2RelationshipOther" runat="server" CssClass="myfield"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="ReqFieldValParent2Other" runat="server" SetFocusOnError="true"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="EnrollmentParent2RelationshipOther"
                                            CssClass="ErrorMessage" Enabled="False" ErrorMessage="Parent/Guardian's other relationship is required."
                                            Text="* Required"></asp:RequiredFieldValidator>
                                        <asp:CustomValidator ID="CustomValidatorParent2Relationship" runat="server" SetFocusOnError="true"
                                            OnServerValidate="CustomValidatorParent2Relationship_ServerValidate" Display="Dynamic"
                                            CssClass="ErrorMessage" ErrorMessage="Parent/Guardian's relationship is required."
                                            Text="* Required"></asp:CustomValidator>

                                    </div>

                                </div>

                                <div class="row">
                                    <a id="g2clear" onclick="clearguardianfields("2")" ></a>
                                    <a href='javascript:;' onclick='clearguardianfields(2);'>Clear Guardian</a>
                                    
                                </div>

                                <script type="text/javascript">
                                    function clearguardianfields(fieldid) {

                                        switch (fieldid) {
                                            case 1:
                                                // code block

                                                var ln1_id = '<%=EnrollmentParentLastNameTextBox.ClientID %>';
                                                var fn1_id = '<%=EnrollmentParent1FirstNameTextBox.ClientID %>';
                                                var mi1_id = '<%=EnrollmentParent1MITextBox.ClientID %>';
                                                var email1_id = '<%=EnrollmentParentEmail1TextBox.ClientID %>';
                                                var hph1_id = '<%=GuardianHomePhone.ClientID %>'
                                                var cph1_id = '<%=GuardianCellPhone.ClientID %>'
                                                var wph1_id = '<%=GuardianWorkPhone.ClientID %>'
                                                var ralrelation = '<%=RadiobuttonListRelation1.ClientID %>'

                                                var enrollParent1LastName = document.getElementById(ln1_id);
                                                var enrollParent1FirstName = document.getElementById(fn1_id);
                                                var enrollParent1MI = document.getElementById(mi1_id);
                                                var enrollParent1Email = document.getElementById(email1_id);
                                                var enrollrelation1 = document.getElementById(ralrelation);

                                                var enrollParent1HP = document.getElementById('<%=GuardianHomePhone.FindControl("TextBoxPhone").ClientID %>');
                                                var enrollParent1CP = document.getElementById('<%=GuardianCellPhone.FindControl("TextBoxPhone").ClientID %>');
                                                var enrollParent1WP = document.getElementById('<%=GuardianWorkPhone.FindControl("TextBoxPhone").ClientID %>');

                                                var inputElementArray = enrollrelation1.getElementsByTagName('input');

                                                for (var i = 0; i < inputElementArray.length; i++) {


                                                    var inputElement = inputElementArray[i];

                                                    inputElement.checked = false;
                                                }

                                                enrollParent1LastName.value = '';
                                                enrollParent1FirstName.value = '';
                                                enrollParent1MI.value = '';
                                                enrollParent1HP.value = '';
                                                enrollParent1CP.value = '';
                                                enrollParent1WP.value = '';
                                                enrollParent1Email.value = '';


                                                break;
                                            case 2:
                                                var ln2_id = '<%=EnrollmentParent2LastNameTextBox.ClientID %>';
                                                var fn2_id = '<%=EnrollmentParent2FirstNameTextBox.ClientID %>';
                                                var mi2_id = '<%=EnrollmentParent2MITextBox.ClientID %>';
                                                var email2_id = '<%=EnrollmentParent2EmailTextBox.ClientID %>';
                                                var hph2_id = '<%=Guardian2HomePhone.ClientID %>'
                                                var cph2_id = '<%=Guardian2CellPhone.ClientID %>'
                                                var wph2_id = '<%=Guardian2WorkPhone.ClientID %>'
                                                var ralrelation = '<%=RadiobuttonListRelation2.ClientID %>'

                                                var enrollParent2LastName = document.getElementById(ln2_id);
                                                var enrollParent2FirstName = document.getElementById(fn2_id);
                                                var enrollParent2MI = document.getElementById(mi2_id);
                                                var enrollParent2Email = document.getElementById(email2_id);
                                                var enrollrelation2 = document.getElementById(ralrelation);

                                                var enrollParent2HP = document.getElementById('<%=Guardian2HomePhone.FindControl("TextBoxPhone").ClientID %>');
                                                var enrollParent2CP = document.getElementById('<%=Guardian2CellPhone.FindControl("TextBoxPhone").ClientID %>');
                                                var enrollParent2WP = document.getElementById('<%=Guardian2WorkPhone.FindControl("TextBoxPhone").ClientID %>');

                                                var inputElementArray = enrollrelation2.getElementsByTagName('input');

                                                for (var i = 0; i < inputElementArray.length; i++) {


                                                    var inputElement = inputElementArray[i];

                                                    inputElement.checked = false;
                                                }

                                                enrollParent2LastName.value = '';
                                                enrollParent2FirstName.value = '';
                                                enrollParent2MI.value = '';
                                                enrollParent2HP.value = '';
                                                enrollParent2CP.value = '';
                                                enrollParent2WP.value = '';
                                                enrollParent2Email.value = '';


                                                break;
                                            default:
                                            // code block
                                        }

                                    }
                                </script>

                            </div>
                            <span class="sectionDivider"></span>
                            <div class="row">
                                <h3 class="sectionHead">School Information:</h3>
                            </div>
                            <div class="row">
                                <div class="myenrollmentcurrentlyenrolled">
                                    <asp:Label ID="EnrollmentOtherPrograms" runat="server" Text="Currently Enrolled in school?"
                                        CssClass="mylabel"></asp:Label>
                                    <telerik:RadFormDecorator ID="RadFormDecorator6" runat="server" />

                                    <asp:RadioButtonList ID="RadiobuttonListProgramParticipation" runat="server" OnClick="BulletedList1_Click" RepeatDirection="Horizontal"
                                        onChange="enableGradeValidation()">
                                        <asp:ListItem Text="Yes" Value="True"></asp:ListItem>
                                        <asp:ListItem Text="No" Value="False"></asp:ListItem>
                                    </asp:RadioButtonList>
                                    <asp:Label ID="Label4" runat="server" Text="" />
                                    <script type="text/javascript">
                                        function enableGradeValidation() {

                                            var buttonIndex = $('#<%=RadiobuttonListProgramParticipation.ClientID %> input[type=radio]:checked').val();



                                            var clientId1 = '<%=EnrollmentCurrentSchoolValidator.ClientID %>';
                                            var clientId2 = '<%=EnrollmentGradeLevelValidator.ClientID %>';
                                            var clientId3 = '<%=EnrollmentCurrentSchoolValidator.ClientID %>';
                                            var clientId4 = '<%=EnrollmentCurrentSchoolTextBox.ClientID %>';

                                            var el1 = document.getElementById(clientId1);

                                            var el2 = document.getElementById(clientId2);



                                            var el3 = document.getElementById(
                                                'ctl00_MainContentPlaceholder_AddEditAddressSchool_reqValStreet');
                                            var el4 = document.getElementById(
                                                'ctl00_MainContentPlaceholder_AddEditAddressSchool_reqValCity');
                                            var el5 = document.getElementById(
                                                'ctl00_MainContentPlaceholder_AddEditAddressSchool_reqValZip');


                                            var el6 = document.getElementById(clientId3);



                                            if (buttonIndex == "True") {
                                                ValidatorEnable(el6, true);
                                                ValidatorEnable(el3, true);
                                                ValidatorEnable(el4, true);
                                                ValidatorEnable(el5, true);
                                                ValidatorEnable(el1, true);
                                                ValidatorEnable(el2, true);

                                            }
                                            else {

                                                ValidatorEnable(el6, false);
                                                ValidatorEnable(el1, false);
                                                ValidatorEnable(el2, false);
                                                ValidatorEnable(el3, false);
                                                ValidatorEnable(el4, false);
                                                ValidatorEnable(el5, false);
                                            }


                                            document.getElementById(clientId4).focus();


                                        }
                                    </script>
                                </div>
                            </div>
                            <div class="row">
                                <div class="myenrollmentschool">
                                    <asp:Label ID="EnrollmentCurrentSchool" runat="server" Text="Name of School" CssClass="mylabel"></asp:Label>
                                    <asp:TextBox ID="EnrollmentCurrentSchoolTextBox" runat="server" CssClass="myfield mytextbox"></asp:TextBox>

                                    <asp:RequiredFieldValidator ID="EnrollmentCurrentSchoolValidator" runat="server" Display="Dynamic"
                                        Text="* Required" CssClass="ErrorMessage" ControlToValidate="EnrollmentCurrentSchoolTextBox"
                                        ErrorMessage="Name of School is required if child is enrolled." ValidationGroup="Save" Enabled="False">
                                    </asp:RequiredFieldValidator>
                                </div>
                                <div class="myenrollmentgrade">
                                    <asp:Label ID="EnrollmentGradeLevel" runat="server" Text="Grade Level" CssClass="mylabel"></asp:Label>
                                    <asp:TextBox ID="EnrollmentGradeLevelTextBox" MaxLength="2" runat="server" CssClass="myfield mytextbox"
                                        CausesValidation="false"></asp:TextBox>

                                    <asp:RequiredFieldValidator ID="EnrollmentGradeLevelValidator" runat="server" Display="Dynamic"
                                        Text="* Required" CssClass="ErrorMessage" ControlToValidate="EnrollmentGradeLevelTextBox"
                                        ErrorMessage="Grade level is required if child is enrolled." ValidationGroup="Save" Enabled="False">
                                    </asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="row myenrollmentschooladdress">
                                <uc1:AddEditAddress ID="AddEditAddressSchool" runat="server" />
                                <uc2:AddEditPhoneNumber ID="AddEditPhoneNumberSchool" runat="server" />
                            </div>
                        </telerik:RadPageView>
                        <telerik:RadPageView ID="RadPageView2" runat="server" Width="100%">
                            <div class="PrintSectionTitle PrinterBreak">
                                <h2>Transportation Release & Emergency Contact Information</h2>
                                <span class="sectionDivider"></span>
                            </div>
                            <div class="row">
                                <h3 class="sectionHead">Transportation Pick Up/Drop Off List</h3>
                            </div>
                            <div class="myenrollmentpickup">
                                <div class="row myenrollmentpickupparagraph">
                                    <p class="subtitle">
                                        Only the individuals listed below are authorized to drop off/pick up youth. Please
                                        check appropriate box for the emergency contact (EC) person you want to designate.
                                    </p>
                                </div>
                                <asp:UpdatePanel ID="UpdatePanelAuthorized" runat="server">
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="EnrollmentPickUpAuthorizationAdd" EventName="Click" />
                                    </Triggers>
                                    <ContentTemplate>
                                        <asp:CustomValidator ID="CustomValidatorERPeopleAssigned" runat="server" OnServerValidate="CustomValidatorERPeopleAssigned_ServerValidate"
                                            Text="* 1 Emergency Contact Required" CssClass="ErrorMessage RegAddFormError"
                                            ValidationGroup="Save">
                                        </asp:CustomValidator>
                                        <asp:Panel ID="PanelAddEnrollmentPickUp" runat="server" DefaultButton="EnrollmentPickUpAuthorizationAdd"
                                            class="myenrollmentpickupAdd">
                                            <div class="row">
                                                <asp:Label ID="EnrollmentPickupAuthorizationLastName" runat="server" Text="Last Name"
                                                    CssClass="mylabel addlastname"></asp:Label>
                                                <asp:TextBox ID="EnrollmentPickUpAuthorizationLastNameTextBox" runat="server" CssClass="myfield capitalize"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" Display="Dynamic"
                                                    Text="* Required" CssClass="ErrorMessage RegAddFormError" ControlToValidate="EnrollmentPickUpAuthorizationLastNameTextBox"
                                                    ErrorMessage="Authorized Person's Last Name is required" ValidationGroup="AddAuthorized">
                                                </asp:RequiredFieldValidator>
                                                <asp:Label ID="EnrollmentPickupAuthorizationFirstName" runat="server" Text="First Name"
                                                    CssClass="mylabel"></asp:Label>
                                                <asp:TextBox ID="EnrollmentPickUpAuthorizationFirstNameTextBox" runat="server" CssClass="myfield addfirstname capitalize"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="reqValAuthPerson" runat="server" Display="Dynamic"
                                                    Text="* Required" CssClass="ErrorMessage RegAddFormError" ControlToValidate="EnrollmentPickUpAuthorizationFirstNameTextBox"
                                                    ErrorMessage="Authorized Person's First Name is required" ValidationGroup="AddAuthorized">
                                                </asp:RequiredFieldValidator>

                                                <asp:CheckBox ID="CheckBoxER" runat="server" Text="Is Emergency Contact" CssClass="IsEmergencyContact" />
                                            </div>
                                            <div class="row myenrollmentpickupAddRelationship">
                                                <asp:Label ID="EnrollmentPickupAuthorizationRelationship" runat="server" Text="Relationship"
                                                    CssClass="mylabel myradiolistlabel"></asp:Label>
                                                <asp:RadioButtonList ID="RadiobuttonListAuthorizedPersonRelationship" runat="server"
                                                    DataTextField="Name" DataValueField="PersonRelationshipTypeID" RepeatDirection="Horizontal"
                                                    CssClass="RegAddFormRadioList">
                                                </asp:RadioButtonList>
                                                <div class="OtherRelationship">
                                                    <span class="mylabel">OR Other:</span>
                                                    <asp:TextBox ID="TextBoxOtherRelationship" runat="server" CssClass="myfield"></asp:TextBox>
                                                </div>
                                                <asp:CustomValidator ID="customvalidatorRelationship" OnServerValidate="customvalidatorRelationship_ServerValidate"
                                                    runat="server" Text="* Relationship Required" CssClass="ErrorMessage RegAddFormError"
                                                    ValidationGroup="AddAuthorized" Display="Dynamic"></asp:CustomValidator>
                                            </div>
                                            <div class="row">
                                                <div class="addphonecontainer">
                                                    <uc2:AddEditPhoneNumber ID="AuthorizedHomePhone" runat="server" />
                                                    <uc2:AddEditPhoneNumber ID="AuthorizedWorkPhone" runat="server" />
                                                    <uc2:AddEditPhoneNumber ID="AuthorizedCellPhone" runat="server" />
                                                    <asp:CustomValidator ID="customPhoneAuthVal" runat="server" ErrorMessage="At least 1 phone number for Authorized Person's is required"
                                                        OnServerValidate="customPhoneAuthVal_ServerValidate" Text="* Required" Display="Dynamic"
                                                        ValidationGroup="AddAuthorized" CssClass="ErrorMessage"></asp:CustomValidator>
                                                    <auth:SecureContent ID="SecureContent7" ToggleVisible="true" ToggleEnabled="false"
                                                        EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
                                                        <asp:Button ID="EnrollmentPickUpAuthorizationAdd" runat="server" ValidationGroup="AddAuthorized"
                                                            OnClick="EnrollmentPickUpAuthorizationAdd_Click" Text="Add" CssClass="mybutton myaddbutton" />
                                                    </auth:SecureContent>
                                                </div>
                                                <div class="row">
                                                </div>
                                            </div>
                                        </asp:Panel>
                                        <!--end pickupAdd-->
                                        <telerik:RadGrid ID="EnrollmentPickUpAuthorizationList" runat="server" AutoGenerateColumns="false"
                                            CssClass="PickUpGrid" Width="100%" OnNeedDataSource="EnrollmentPickUpAuthorizationList_NeedsDataSource"
                                            EnableEmbeddedSkins="false" Skin="Prodigy" HorizontalAlign="Center"
                                            OnItemDataBound="PickupGrid_ItemDataBound"
                                            OnDeleteCommand="EnrollmentPickUpAuthorizationList_DeleteCommand">
                                            <MasterTableView TableLayout="Auto" DataKeyNames="PersonID">
                                                <Columns>
                                                    <telerik:GridBoundColumn DataField="LastName" HeaderText="Last Name">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="FirstName" HeaderText="First Name">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="RelationshipTypeName" HeaderText="Relationship">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField=" IsER" HeaderText=" Is Emergency Contact">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="WorkPhone.Phone" HeaderText="Work Phone">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="CellPhone.Phone" HeaderText="Cell Phone">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="HomePhone.Phone" HeaderText="Home Phone">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridButtonColumn ButtonType="ImageButton" CommandArgument="Delete" CommandName="Delete"
                                                        ShowFilterIcon="False" UniqueName="DeleteColumn" Text="Delete" ImageUrl="../App_Themes/Prodigy/Grid/Delete.png"
                                                        HeaderStyle-Width="10%" ButtonCssClass="Button" ItemStyle-Width="10%" ItemStyle-HorizontalAlign="center"
                                                        ConfirmText="Are you sure you want to delete this person from the list?">
                                                    </telerik:GridButtonColumn>
                                                </Columns>
                                                <NoRecordsTemplate>
                                                    <p>
                                                        There are no authorized people/emergency contacts specified at this time!
                                                    </p>
                                                </NoRecordsTemplate>
                                            </MasterTableView>
                                        </telerik:RadGrid>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                            <div class="row">
                                <p class="importantnote">
                                    <span class="importantnoteunderline">Important Note:</span> Prodigy will only release
                                    a youth to the authorized contacts listed above!
                                </p>
                            </div>
                            <div class="row">
                                <div>

                                    <p>
                                        In addition to the people listed above, my child has permission to sign him/herself in and out of the Prodigy program.
                                    </p>
                                    <div class="enrollmentpermissionsfields">
                                        <telerik:RadFormDecorator ID="RadFormDecorator7" runat="server" />
                                        <asp:CheckBoxList ID="CheckBoxTransportationList" runat="server" RepeatColumns="3"
                                            RepeatDirection="Horizontal" RepeatLayout="Table"
                                            CausesValidation="true" ValidationGroup="Save" AutoPostBack="true">
                                            <asp:ListItem Value="SignInOut">Yes</asp:ListItem>
                                            <asp:ListItem Value="SignedInOutGuardOnly">No</asp:ListItem>

                                        </asp:CheckBoxList>
                                        <asp:CustomValidator ID="CustomValidatorCheckBoxTransportationList" runat="server" SetFocusOnError="true"
                                            ValidationGroup="Save" Display="Dynamic" CssClass="ErrorMessage"
                                            ErrorMessage="* Required." Text="* Required" Enabled="true"
                                            ClientValidationFunction="CustomValidatorCheckBoxTransportationList_ClientValidate" EnableClientScript="true"
                                            OnServerValidate="CustomValidatorCheckBoxTransportationList_ServerValidate"></asp:CustomValidator>

                                        <script type="text/javascript">
                                            function CustomValidatorCheckBoxTransportationList_ClientValidate(source, arguments) {
                                                var ec = document.getElementById("ctl00_MainContentPlaceholder_CheckBoxTransportationList");
                                                var chkListModules = document.getElementById('<%= CheckBoxTransportationList.ClientID %>');
                                                var chkListinputs = chkListModules.getElementsByTagName("input");
                                                for (var i = 0; i < chkListinputs.length; i++) {
                                                    if (chkListinputs[i].checked) {
                                                        arguments.IsValid = true;
                                                        return;
                                                    }
                                                }
                                                arguments.IsValid = false;
                                            }


                                        </script>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="myenrollmentpermissions">

                                        <p>
                                            Program Staff where class is held is allowed to sign my child in and out of the Prodigy program.
                                        </p>
                                        <div>
                                            <asp:RadioButtonList ID="rbauthorizedstaffok" runat="server" OnClick="" RepeatDirection="Horizontal"
                                                onChange="">
                                                <asp:ListItem Text="Yes" Value="True"></asp:ListItem>
                                                <asp:ListItem Text="No" Value="False"></asp:ListItem>
                                            </asp:RadioButtonList>
                                            <asp:RequiredFieldValidator ID="rfvauthorizedok" runat="server" SetFocusOnError="True"
                                                ValidationGroup="Save" Display="Dynamic" ControlToValidate="rbauthorizedstaffok"
                                                CssClass="ErrorMessage" ErrorMessage="Required." Enabled="True" Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <br />
                                </div>
                                <%--                                </div>
                                     <div class="row">--%>
                                <%-- <p>--%>
                                <%-- <asp:Label ID="Label3" runat="server" class="mylabel">Describe Other:</asp:Label>
                                        <asp:TextBox ID="TextBoxOtherRelease" runat="server" CssClass=""></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorTextBoxOtherRelease" runat="server" Display="Dynamic"
                                            Text="* Required" CssClass="ErrorMessage" ControlToValidate="TextBoxOtherRelease"
                                            ErrorMessage="" ValidationGroup="Save" Enabled="false"></asp:RequiredFieldValidator>--%>
                                <%-- </p>--%>
                            </div>

                            <span class="sectionDivider" style="display: none;"></span>
                            <div class="row" style="display: none;">
                                <p>
                                    By signing this release I, the parent/guardian, am acknowledging that I understand
                                    the following: In the event that a parent/guardian or anyone from the transporation
                                    list above is not available to pick up my child(ren) within 1 hour of program closing,
                                    the local law enforcement office will be contacted to pick up my child. Consistent
                                    tardiness in picking up my child will result in verbal and writtern notification.
                                    Frequent transportation issues may mean that my child will not be able to continue
                                    in the program.
                                </p>
                            </div>
                            <div class="row" style="display: none;">
                                <div class="myenrollmentparentsignature">
                                    <asp:Label ID="EnrollmentParentSignature1" runat="server" Text="Signatures were provided:"
                                        class="mylabel mysignaturelabel"></asp:Label>
                                    <asp:RadioButtonList ID="EnrollmentParentSignatureVerification1" runat="server" DataTextField="Name"
                                        RepeatDirection="Horizontal" CssClass="">
                                        <asp:ListItem Value="true">Yes</asp:ListItem>
                                        <asp:ListItem Value="false">No</asp:ListItem>
                                    </asp:RadioButtonList>
                                    <div class="myenrollmentparentsignaturedate">
                                        <asp:Label ID="EnrollmentParentSigntureDate1" runat="server" Text="Date" class="mylabel"></asp:Label>
                                        <telerik:RadDatePicker ID="EnrollmentParentSignatureDate1Picker" runat="server" DateInput-Width="50px"
                                            Width="73%" DateInput-DisplayDateFormat="MM/dd/yy" Calendar-ShowRowHeaders="False"
                                            Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup myenrollmentdate">
                                        </telerik:RadDatePicker>

                                    </div>
                                </div>
                            </div>
                        </telerik:RadPageView>
                        <telerik:RadPageView ID="RadPageView4" runat="server" Width="100%">
                            <div class="PrintSectionTitle PrinterBreak">
                                <h2>Medical Release</h2>
                                <span class="sectionDivider"></span>
                            </div>
                            <div class="row">
                                <h3 class="sectionHead">Medical Information:</h3>
                            </div>
                            <div class="row myenrollmentmedicalinformation">
                                <p>
                                    My child has the following medical condition(s) and/or is taking the 
                                    following medication(s) listed below.  The medical information provided 
                                    herein is covered by the Health Insurance Portability and Accountability Act (HIPAA). 
                                    <span class="importantnoteunderline">Please indicate N/A for sections that do not apply:</span>
                                </p>
                            </div>
                            <div class="row myenrollmentmedicalinformation">
                                <div class="myenrollmentmedicalconditions">
                                    <asp:Label ID="EnrollmentMedicalConditions" runat="server" Text="Medical Conditions:"
                                        CssClass="mylabel"></asp:Label>
                                    <asp:TextBox ID="EnrollmentMedicalConditionsTextBox" runat="server" CssClass="myfield mytextarea"
                                        TextMode="SingleLine" MaxLength="50" Columns="80" Wrap="false" Rows="1"></asp:TextBox>

                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" SetFocusOnError="True"
                                        ValidationGroup="Save" Display="Dynamic" ControlToValidate="EnrollmentMedicalConditionsTextBox"
                                        CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="row">
                                <div class="myenrollmentmedications">
                                    <asp:Label ID="EnrollmentMedications" runat="server" Text="Medications:" CssClass="mylabel"></asp:Label>
                                    <asp:TextBox ID="EnrollmentMedicationsTextBox" runat="server" CssClass="myfield mytextarea"
                                        TextMode="SingleLine" MaxLength="50" Columns="80" Wrap="false" Rows="1"></asp:TextBox>

                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" SetFocusOnError="True"
                                        ValidationGroup="Save" Display="Dynamic" ControlToValidate="EnrollmentMedicationsTextBox"
                                        CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="row">
                                <div class="myenrollmentspecialneeds">
                                    <p class="note">
                                        Other special needs:
                                    </p>
                                    <asp:TextBox ID="EnrollmentSpecialNeedsTextBox" runat="server" CssClass="myfield mytextarea"
                                        TextMode="SingleLine" MaxLength="50" Columns="80" Wrap="false" Rows="1"></asp:TextBox>

                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" SetFocusOnError="True"
                                        ValidationGroup="Save" Display="Dynamic" ControlToValidate="EnrollmentSpecialNeedsTextBox"
                                        CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <span class="sectionDivider"></span>
                            <div class="row">
                                <h3 class="sectionHead">In Case of Emergency:</h3>
                            </div>
                            <div class="row">
                                <div class="myenrollmentcaseemergency">
                                    <p>
                                        <span>If my child should become ill or injured while at Prodigy, I understand that I 
                                        will be immediately contacted first and then my emergency contacts, if I cannot 
                                        be reached. In the event that I and/or my emergency contacts do not respond, I 
                                        authorize the program staff to call “911” for immediate assistance. I fully understand 
                                        the Prodigy Cultural Arts Program is not liable for expenses resulting from the incident, 
                                        neither is responsible for costs associated with medical treatment and/or ambulance transport. </span>
                                    </p>
                                </div>
                                <div>
                                    <asp:CheckBox CausesValidation="True" ID="chkemergencyconsent" runat="server"
                                        Text="I Consent"
                                        CssClass="IsEmergencyContact" />

                                    <asp:CustomValidator ID="cvemergencyconsent" runat="server" SetFocusOnError="true"
                                        ValidationGroup="Save" Display="Dynamic" CssClass="ErrorMessage"
                                        ErrorMessage="Consent is Required." Text="* Required" OnServerValidate="cvemergencyconsent_ServerValidate"
                                        ClientValidationFunction="cvemergency_ClientValidate"></asp:CustomValidator>
                                    <script type="text/javascript">
                                        function cvemergency_ClientValidate(source, arguments) {

                                            arguments.IsValid = false;

                                            var ec = document.getElementById("ctl00_MainContentPlaceholder_chkemergencyconsent");

                                            if (ec.checked == true) {
                                                arguments.IsValid = true;
                                                return;
                                            } else {
                                                arguments.IsValid = false;
                                                return;
                                            }


                                        }
                                    </script>
                                    <%--<asp:CustomValidator ID="cvemergencyconsent" runat="server" ControlToValidate="chkemergencyconsent" SetFocusOnError="true" Display="Dynamic"
                                                CssClass="ErrorMessage" Enabled="true" ErrorMessage="* Consent required" Text="*" ValidationGroup="Save"
                                                OnServerValidate="cvemergencyconsent_ServerValidate"></asp:CustomValidator>--%>
                                    <%-- <asp:RequiredFieldValidator ID="rfvemergencyconsent" runat="server" SetFocusOnError="True"
                                                    ValidationGroup="Save" Display="Dynamic" ControlToValidate="chkemergencyconsent"
                                                    CssClass="ErrorMessage" ErrorMessage="Required." Enabled="True" Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                    --%>
                                </div>

                            </div>

                            <br />
                            <br />
                            <!-- -->
                            <div class="row">
                                <h3 class="sectionHead">Informed Program Consents & Grievance Process</h3>
                            </div>
                            <div class="row">
                                <div class="myenrollmentcaseemergency">
                                    <p>
                                        <span>The program is funded by the Department of Juvenile 
                                            Justice (DJJ) and/or the Hillsborough County (HC). Every 
                                            child must be assessed by the Prodigy program staff to 
                                            identify needs for enrollment. All information collected 
                                            is used for enrollment purposes only.
                                        </span>
                                    </p>
                                </div>
                            </div>
                            <div class="row">
                                <div>
                                    <p class="checklabel">
                                        <asp:Label ID="Label8" runat="server" Text="I grant permission for the Prodigy Staff to conduct assessments with my child for enrollment and allow for the information provided on this application to be used to complete the program enrollment."
                                            CssClass="mylabel"></asp:Label>
                                    </p>
                                    <telerik:RadFormDecorator ID="RadFormDecorator11" runat="server" />

                                    <asp:RadioButtonList ID="rbassessmentok" runat="server" OnClick="" RepeatDirection="Horizontal"
                                        onChange="enableGradeValidation()">
                                        <asp:ListItem Text="Yes" Value="True"></asp:ListItem>
                                        <asp:ListItem Text="No" Value="False"></asp:ListItem>
                                    </asp:RadioButtonList>
                                    <asp:RequiredFieldValidator ID="rfvassessmentok" runat="server" SetFocusOnError="True"
                                        ValidationGroup="Save" Display="Dynamic" ControlToValidate="rbassessmentok"
                                        CssClass="ErrorMessage" ErrorMessage="Required." Enabled="True" Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <br />
                            <br />

                            <div class="row">
                                <div>
                                    <p class="checklabel">
                                        <strong>I hereby release the University Area CDC, Inc. (UACDC),
                                             DJJ, HC, and the Organization completing this application, their 
                                             employees and agents from any and all liability, loss claim, 
                                             damage, charge or expense that may arise from injury or harm to 
                                             my child, or from damage to my property in connection with my child’s 
                                             enrollment and participation in the Prodigy Program.</strong>
                                    </p>
                                </div>
                                <div>
                                    <asp:CheckBox CausesValidation="True" ID="chkliability" runat="server"
                                        Text="I Consent"
                                        CssClass="IsEmergencyContact" />
                                    <asp:CustomValidator ID="cvliability" runat="server" SetFocusOnError="true"
                                        ValidationGroup="Save" Display="Dynamic" CssClass="ErrorMessage"
                                        ErrorMessage="Consent is Required." Text="* Required" OnServerValidate="cvliability_ServerValidate"
                                        ClientValidationFunction="cvliability_ClientValidate"></asp:CustomValidator>
                                    <script type="text/javascript">
                                        function cvliability_ClientValidate(source, arguments) {

                                            arguments.IsValid = false;

                                            var ec = document.getElementById("ctl00_MainContentPlaceholder_chkliability");

                                            if (ec.checked == true) {
                                                arguments.IsValid = true;
                                                return;
                                            } else {
                                                arguments.IsValid = false;
                                                return;
                                            }


                                        }
                                    </script>
                                    <%-- <asp:RequiredFieldValidator ID="rfvliability" runat="server" SetFocusOnError="True"
                                                    ValidationGroup="Save" Display="Dynamic" ControlToValidate="chkliability"
                                                    CssClass="ErrorMessage" ErrorMessage="Required." Enabled="True" Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                    --%>
                                </div>
                            </div>


                            <div class="row">
                                <div class="myenrollmentparentemail">
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <div>
                                    <p class="checklabel">
                                        <strong>I received and understand the youth grievance process; 
                                             and I am aware that this program consent is effective for the 
                                             entirety of my child being enrolled in the Prodigy Program at 
                                             this Organization and can be revoked in writing by me at any time. </strong>
                                    </p>

                                </div>
                                <div style="margin: 10px,0px,0px,0px">

                                    <asp:CheckBox CausesValidation="True" ID="chkgrievanceconsent" runat="server"
                                        Text="I Consent"
                                        CssClass="IsEmergencyContact" />
                                    <asp:CustomValidator ID="cvgrievance" runat="server" SetFocusOnError="true"
                                        ValidationGroup="Save" Display="Dynamic" CssClass="ErrorMessage"
                                        ErrorMessage="Consent is Required." Text="* Required" OnServerValidate="cvgrievanceconsent_ServerValidate"
                                        ClientValidationFunction="cvgrievance_ClientValidate"></asp:CustomValidator>
                                    <script type="text/javascript">
                                        function cvgrievance_ClientValidate(source, arguments) {

                                            arguments.IsValid = false;

                                            var ec = document.getElementById("ctl00_MainContentPlaceholder_chkgrievanceconsent");

                                            if (ec.checked == true) {
                                                arguments.IsValid = true;
                                                return;
                                            } else {
                                                arguments.IsValid = false;
                                                return;
                                            }


                                        }
                                    </script>
                                    <%--<asp:RequiredFieldValidator ID="rfvgrievanceconsent" runat="server" SetFocusOnError="True"
                                                    ValidationGroup="Save" Display="Dynamic" ControlToValidate="chkgrievanceconsent"
                                                    CssClass="ErrorMessage" ErrorMessage="Required." Enabled="True" Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                    --%>
                                </div>
                            </div>
                            <br />
                            <br />
                            <!-- -->
                            <br />
                            <div class="row">
                                <h3 class="sectionHead">Media Release Parent/Guardian Consent</h3>
                            </div>
                            <div class="row">
                                <div class="myenrollmentcaseemergency">
                                    <p>
                                        <span>I hereby voluntarily and without expecting reimbursement 
                                            grant to the Prodigy Program of the University Area CDC, Inc. 
                                            and the Organization completing this application permission 
                                            to use photographs and videos made of my Youth during his/her 
                                            participation in the program. The use of photographs and videos 
                                            will not be used for profit; they will include but not be 
                                            limited to publications, website, display, advertising, 
                                            editorial illustration, etc.                            
                                        </span>
                                    </p>
                                </div>
                            </div>
                            <div class="row">
                                <div>
                                    <p class="checklabel">
                                        <asp:Label ID="Label9" runat="server" Text="I give the University Area CDC, Inc. and the Organization completing this application permission to photograph, videotape my child and publish his/her name with print photograph as a participant in the Prodigy Program."
                                            CssClass="mylabel"></asp:Label>
                                    </p>
                                    <telerik:RadFormDecorator ID="RadFormDecorator12" runat="server" />

                                    <asp:RadioButtonList ID="rbmediacapture" runat="server" OnClick="" RepeatDirection="Horizontal"
                                        onChange="enableGradeValidation()">
                                        <asp:ListItem Text="Yes" Value="True"></asp:ListItem>
                                        <asp:ListItem Text="No" Value="False"></asp:ListItem>
                                    </asp:RadioButtonList>
                                    <asp:RequiredFieldValidator ID="rfvmedia" runat="server" SetFocusOnError="True"
                                        ValidationGroup="Save" Display="Dynamic" ControlToValidate="rbmediacapture"
                                        CssClass="ErrorMessage" ErrorMessage="Required." Enabled="True" Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <!-- -->
                            <br />
                            <%-- <div class="myenrollmentphysicianAdd">
                                <div class="row">
                                    <p class="subtitle">
                                        Add a Physician's Contact Information
                                    </p>
                                    <asp:CustomValidator ID="CustomValidator1" runat="server" OnServerValidate="CustomValidatorPhysicianAssigned_ServerValidate"
                                        Text="* 1 Physician Required" CssClass="ErrorMessage RegAddFormError"
                                        ValidationGroup="Save">
                                    </asp:CustomValidator>
                                    <asp:Label ID="EnrollmentDocFirstName" runat="server" Text="First Name" CssClass="mylabel addfirstname"></asp:Label>
                                    <asp:TextBox ID="DocFirstNameTextBox" runat="server" CssClass="myfield"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" SetFocusOnError="true" runat="server"
                                        ControlToValidate="DocFirstNameTextBox" ErrorMessage="Physician's First Name is required"
                                        ValidationGroup="AddDoctor" Text="* Required" Display="Dynamic" CssClass="ErrorMessage">
                                    </asp:RequiredFieldValidator>
                                    <asp:Label ID="EnrollmentDocLastName" runat="server" Text="Last Name" CssClass="mylabel addlastname"></asp:Label>
                                    <asp:TextBox ID="DocLastNameTextBox" runat="server" CssClass="myfield"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" SetFocusOnError="true"
                                        ControlToValidate="DocLastNameTextBox" ErrorMessage="Physician's Last Name is required"
                                        ValidationGroup="AddDoctor" Text="* Required" Display="Dynamic" CssClass="ErrorMessage">
                                    </asp:RequiredFieldValidator>
                                </div>
                                <div class="row myenrollmentphemergencyysicianaddress">
                                    <uc1:AddEditAddress ID="DocAddress" runat="server" />
                                    <uc2:AddEditPhoneNumber ID="DocPhone" runat="server" />
                                </div>
                                <div class="row">

                                    <auth:SecureContent ID="SecureContent8" ToggleVisible="true" ToggleEnabled="false"
                                        EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">

                                        <asp:Button ID="ButtonAddDoctor" runat="server" ValidationGroup="AddDoctor" OnClick="ButtonAddDoctor_Click"
                                            Text="Add" CssClass="mybutton myaddbutton" />
                                    </auth:SecureContent>
                                </div>
                            </div>
                            <div class="myenrollmentphysicianGrid">
                                <asp:UpdatePanel ID="UpdatePanelDoc" runat="server">
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="ButtonAddDoctor" EventName="Click" />
                                    </Triggers>
                                    <ContentTemplate>
                                        <telerik:RadGrid ID="RadGridDoctors" runat="server" AutoGenerateColumns="false" Width="100%"
                                            OnNeedDataSource="RadGridDoctors_NeedsDataSource" OnItemDataBound="RadGridDoctors_ItemDataBound"
                                            EnableEmbeddedSkins="false" Skin="Prodigy" HorizontalAlign="Center" OnDeleteCommand="RadGridDoctors_DeleteCommand">
                                            <MasterTableView TableLayout="Auto" DataKeyNames="PersonID">
                                                <Columns>
                                                    <telerik:GridBoundColumn DataField="FirstName" HeaderText="First Name">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="LastName" HeaderText="LastName">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="WorkPhone.Phone" HeaderText="Phone">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridTemplateColumn HeaderText="Address" UniqueName="AddressCol">
                                                        <ItemTemplate>
                                                            <asp:Literal ID="LiteralAddress" runat="server"></asp:Literal>
                                                        </ItemTemplate>
                                                    </telerik:GridTemplateColumn>
                                                    <telerik:GridButtonColumn ButtonType="ImageButton" ItemStyle-Width="10%" HeaderStyle-HorizontalAlign="Right"
                                                        CommandArgument="Delete" CommandName="Delete" ImageUrl="../App_Themes/Prodigy/Grid/Delete.png"
                                                        ShowFilterIcon="False" UniqueName="DeleteColumn" ConfirmText="Are you sure you want to delete this person from the list?"
                                                        ButtonCssClass="IconButton DeleteButton">
                                                    </telerik:GridButtonColumn>
                                                </Columns>
                                                <NoRecordsTemplate>
                                                    <p>
                                                        There are no physicians specified at this time!
                                                    </p>
                                                </NoRecordsTemplate>
                                            </MasterTableView>
                                        </telerik:RadGrid>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>--%>
                            <%--<div class="row">
                                <div class="myenrollmentinsurancecompany">
                                    <asp:Label ID="EnrollmentInsuranceCompany" runat="server" Text="Insurance Company"
                                        CssClass="mylabel"></asp:Label>
                                    <asp:TextBox ID="EnrollmentInsuranceCompanyTextBox" runat="server" CssClass="myfield"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" SetFocusOnError="True"
                                        ValidationGroup="Save" Display="Dynamic" ControlToValidate="EnrollmentInsuranceCompanyTextBox"
                                        CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="row">
                                <div class="myenrollmentpolicynumber">
                                    <asp:Label ID="EnrollmentPolicyNumber" runat="server" Text="Policy #" CssClass="mylabel"></asp:Label>
                                    <asp:TextBox ID="EnrollmentPolicyNumberTextBox" runat="server" CssClass="myfield"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" SetFocusOnError="True"
                                        ValidationGroup="Save" Display="Dynamic" ControlToValidate="EnrollmentPolicyNumberTextBox"
                                        CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="row">
                                <div class="myenrollmentgroupnumber">
                                    <asp:Label ID="EnrollmentGroupNumber" runat="server" Text="Group #" CssClass="mylabel"></asp:Label>
                                    <asp:TextBox ID="EnrollmentGroupNumberTextBox" runat="server" CssClass="myfield"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" SetFocusOnError="True"
                                        ValidationGroup="Save" Display="Dynamic" ControlToValidate="EnrollmentGroupNumberTextBox"
                                        CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required"></asp:RequiredFieldValidator>
                                </div>
                            </div>--%>
                            <div class="row">
                                <div class="myenrollmentparentsignature">
                                    <asp:Label ID="EnrollmentParentSignature2" runat="server" Text="Signatures were provided:"
                                        CssClass="mylabel mysignaturelabel"></asp:Label>
                                    <asp:RadioButtonList ID="EnrollmentParentSignatureVerification2" runat="server" DataTextField="Name"
                                        RepeatDirection="Horizontal" CssClass="">
                                        <asp:ListItem Value="true">Yes</asp:ListItem>
                                        <asp:ListItem Value="false">No</asp:ListItem>
                                    </asp:RadioButtonList>
                                    <asp:RequiredFieldValidator ID="reqValMedReleaseSignautre" runat="server" SetFocusOnError="True"
                                        ValidationGroup="Save" Display="Dynamic" ControlToValidate="EnrollmentParentSignatureVerification2"
                                        CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                    <div class="myenrollmentparentsignaturedate">
                                        <asp:Label ID="EnrollmentParentSigntureDate2" runat="server" Text="Date" class="mylabel"></asp:Label>
                                        <telerik:RadDatePicker ID="EnrollmentParentSigntureDate2Picker" runat="server" DateInput-Width="50px"
                                            Width="73%" DateInput-DisplayDateFormat="MM/dd/yy" Calendar-ShowRowHeaders="False"
                                            Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup myenrollmentdate">
                                        </telerik:RadDatePicker>
                                        <asp:RequiredFieldValidator ID="reqvalMedReleaseSignature" runat="server" SetFocusOnError="True"
                                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="EnrollmentParentSigntureDate2Picker"
                                            CssClass="ErrorMessage" ErrorMessage="Required." Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                            </div>
                        </telerik:RadPageView>
                        <%--///EnrollmentNotes--%>
                        <telerik:RadPageView ID="RadPageView5" runat="server" Width="100%">
                            <div class="PrintSectionTitle PrinterBreak">
                                <h2>Enrollment Notes</h2>
                                <span class="sectionDivider"></span>
                            </div>
                            <div class="row">
                                <h3 class="sectionHead">Enrollment Notes</h3>
                            </div>
                            <div class="myenrollmentpickup">
                                <asp:UpdatePanel ID="updatepanelnotes" runat="server">
                                    
                                    <ContentTemplate>
                                        <div class="row myenrollmentpickupparagraph">
                                            <p class="subtitle">
                                                Please enter a note each time that you make contact with a youth.
                                            </p>
                                        </div>
                                        <br /><br /><br /><br />
                                    <%--    <asp:Panel ID="paneladdenrollmentNote" runat="server" DefaultButton="enrollmentNoteAdd" class="myenrollmentpickupAdd">

                                            <div class="row">
                                                <div class="myenrollmentschool">
                                                    <asp:Label ID="lblnotecontacttype" runat="server" Text="Contact Type" CssClass="mylabel myyouthtype"></asp:Label>
                                                    <telerik:RadComboBox ID="rcbnotecontacttype" DataValueField="NoteContactTypeID" DataTextField="Name"
                                                        runat="server" CssClass="mydropdown" OnClientSelectedIndexChanged="PrintFieldSwap">
                                                    </telerik:RadComboBox>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="myenrollmentschool">
                                                    <asp:Label ID="Label3" runat="server" Text="Contact Person" CssClass="mylabel myyouthtype"></asp:Label>
                                                    <asp:TextBox ID="txtnotecontactperson" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="rfvnotecontactperson" runat="server" Display="Dynamic"
                                                        Text="* Required" CssClass="ErrorMessage RegAddFormError" ControlToValidate="txtnotecontactperson"
                                                        ErrorMessage="Please enter the person you made contact with" ValidationGroup="AddNotes">
                                                    </asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="myenrollmentschool">
                                                    <asp:Label ID="lblenrollmentnote" runat="server" Text="Enrollment Note" CssClass="mylabel myradiolistlabel"></asp:Label>
                                                    <asp:TextBox Height="40px" Style="resize: none;" TextMode="MultiLine"
                                                        Width="400px" ID="txtenrollmentnote" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="rfvnoteenrollnote" runat="server" Display="Dynamic"
                                                        Text="* Required" CssClass="ErrorMessage RegAddFormError" ControlToValidate="txtenrollmentnote"
                                                        ErrorMessage="Enrollment Note is required" ValidationGroup="AddNotes">
                                                    </asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                            <div class="row" style="padding-top: 10px">
                                                <div class="myenrollmentschool">
                                                    <asp:Label ID="lblenrollfollowup" runat="server" Text="Follow-Up Note" CssClass="mylabel myradiolistlabel"></asp:Label>

                                                    <asp:TextBox Height="30px" Style="resize: none;" TextMode="MultiLine" Width="400px"
                                                        ID="txtenrollmentfollowup" runat="server"></asp:TextBox>


                                                    <asp:RequiredFieldValidator ID="rfvnotefollowup" runat="server" Display="Dynamic"
                                                        Text="* Required" CssClass="ErrorMessage RegAddFormError" ControlToValidate="txtenrollmentfollowup"
                                                        ErrorMessage="Follow up note is required" ValidationGroup="AddNotes">
                                                    </asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                            <div class="row">

                                                <auth:SecureContent ID="SecureContent17" ToggleVisible="true" ToggleEnabled="false"
                                                    EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
                                                    <asp:Button ID="enrollmentNoteAdd" runat="server" ValidationGroup="AddNotes"
                                                        OnClick="EnrollmentNotesAdd_Click" Text="Add" CssClass="mybutton myaddbutton" />
                                                </auth:SecureContent>

                                            </div>
                                            <br /><br />
                                        </asp:Panel>--%>
                                        <!--end enrollmentNoteAdd-->
                                        <telerik:RadGrid ID="notesgrid" OnHTMLExporting="notesgrid_HTMLExporting" runat="server" AutoGenerateColumns="false"
                                            CssClass="PickUpGrid" Width="100%" OnNeedDataSource="Enrollmentnotes_NeedsDataSource"
                                            EnableEmbeddedSkins="false" Skin="Prodigy" HorizontalAlign="Center"
                                            OnItemDataBound="NotesGrid_ItemDataBound" OnInsertCommand="notesgrid_InsertCommand" 
                                            OnUpdateCommand="notesgrid_UpdateCommand" OnItemCreated="notesgrid_ItemCreated" 
                                            OnGridExporting="notesgrid_GridExporting" OnExportCellFormatting="notesgrid_ExportCellFormatting"
                                            OnDeleteCommand="NotesGrid_DeleteCommand">
                                            <ExportSettings ExportOnlyData="true" HideStructureColumns="true"> </ExportSettings>
                                            <MasterTableView TableLayout="Auto" DataKeyNames="EnrollmentNoteId" CommandItemDisplay="Top">
                                                <CommandItemSettings ShowAddNewRecordButton="true" AddNewRecordImageUrl="../App_Themes/Prodigy/Grid/Add.gif"
                                                    AddNewRecordText="Add Note"  
                                                    RefreshText="" />
                                                <ItemStyle />
                                                <EditFormSettings EditColumn-ButtonType="LinkButton">
                                                    <FormTableButtonRowStyle CssClass="EditButtonRow" />
                                                </EditFormSettings>
                                                <AlternatingItemStyle />
                                                
                                                <Columns>
                                                    <%--<telerik:GridEditCommandColumn />--%>
                                                    <telerik:GridBoundColumn DataField="Note" UniqueName="note" HeaderStyle-Width="200px" HeaderText="Note">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn Display="false"  UniqueName="notefull"   DataField="Note" HeaderStyle-Width="200px" HeaderText="Note">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn  DataField="followup" UniqueName="followup" HeaderText="Resources/Needed">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn  Display="false" UniqueName="followupfull"   DataField="followup" HeaderText="Resources/Needed">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="NoteContactType.Name" HeaderStyle-HorizontalAlign="Left" HeaderText="Contact Format">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="DateCreated" DataFormatString="{0:MM/dd/yyyy}" HeaderStyle-HorizontalAlign="Left" HeaderText="Contact Date">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="ContactPerson" HeaderText="Contact Person">
                                                    </telerik:GridBoundColumn>

                                                    <telerik:GridBoundColumn DataField="CreateUserName" HeaderText="Username"></telerik:GridBoundColumn>
                                                    <telerik:GridButtonColumn ButtonType="ImageButton" ItemStyle-Width="7%" CommandArgument="Edit"
                                    CommandName="Edit" ImageUrl="../App_Themes/Prodigy/Grid/edit.gif" ItemStyle-HorizontalAlign="Center"
                                    ShowFilterIcon="False" UniqueName="EditColumn" ButtonCssClass="IconButton PencilButton"
                                    HeaderStyle-HorizontalAlign="Center">
                                </telerik:GridButtonColumn>
                                                    <telerik:GridButtonColumn ColumnGroupName="deletecol" ButtonType="ImageButton" CommandArgument="Delete" CommandName="Delete"
                                                        ShowFilterIcon="False" UniqueName="DeleteColumn" Text="Delete" ImageUrl="../App_Themes/Prodigy/Grid/Delete.png"
                                                        HeaderStyle-Width="30px" ButtonCssClass="Button" ItemStyle-Width="30px" ItemStyle-HorizontalAlign="center"
                                                        ConfirmText="Are you sure you want to delete this note from the list?">
                                                    </telerik:GridButtonColumn>
                                                </Columns>
                                                <EditFormSettings EditFormType="Template" EditColumn-ButtonType="LinkButton">
                                                    <FormTemplate>
                                                        <asp:Panel ID="PanelContent" class="FormWrapper" runat="server">
                                                            <div class="InputWrapper row">
                                                                <div class=" InputWrapper myenrollmentschool">
                                                                    <asp:Label ID="lblnotecontacttype" runat="server" Text="Contact Type" CssClass="mylabel myyouthtype"></asp:Label>
                                                                    <telerik:RadComboBox ID="rcbnotecontacttype" DataValueField="NoteContactTypeID" DataTextField="Name"
                                                                        runat="server" CssClass="mydropdown" OnClientSelectedIndexChanged="PrintFieldSwap">
                                                                    </telerik:RadComboBox>
                                                                </div>
                                                                <div class=" InputWrapper row">
                                                                    <div class="myenrollmentschool">
                                                                        <asp:Label ID="Label3" runat="server" Text="Contact Person" CssClass="mylabel myyouthtype"></asp:Label>
                                                                        <asp:TextBox ID="txtnotecontactperson" runat="server"></asp:TextBox>
                                                                        <asp:RequiredFieldValidator ID="rfvnotecontactperson" runat="server" Display="Dynamic"
                                                                            Text="* Required" CssClass="ErrorMessage RegAddFormError" ControlToValidate="txtnotecontactperson"
                                                                            ErrorMessage="Please enter the person you made contact with" ValidationGroup="AddNotes">
                                                                        </asp:RequiredFieldValidator>
                                                                    </div>
                                                                </div>
                                                                <br />
                                                                <div class="InputWrapper row" >
                                                                    <div class="myenrollmentschool">
                                                                        <asp:Label ID="lblenrollmentnote" runat="server" Text="Enrollment Note" CssClass="mylabel myradiolistlabel"></asp:Label>
                                                                        
                                                                    </div>
                                                                    <div class="myenrollmentschool">
                                                                       <%-- <asp:TextBox MaxLength="250" Height="40px" Style="resize: none;" TextMode="MultiLine"
                                                                            Width="400px" ID="txtenrollmentnote" runat="server"></asp:TextBox>--%>
                                                                        <telerik:RadEditor ID="reenrollmentnote" CssClass="TextEditor" MaxTextLength="950" Width="520" Height="200"
                                                                                AutoResizeHeight="True" AllowScripts="false" StripFormattingOnPaste="All" EnableEmbeddedSkins="false"
                                                                                Skin="Prodigy" runat="server" EnableResize="False">
                                                                                <Tools>
                                                                                    
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
                                                                        <asp:RequiredFieldValidator ID="rfvnoteenrollnote" runat="server" Display="Dynamic"
                                                                            Text="* Required" CssClass="ErrorMessage RegAddFormError" ControlToValidate="reenrollmentnote"
                                                                            ErrorMessage="Enrollment Note is required" ValidationGroup="AddNotes">
                                                                        </asp:RequiredFieldValidator>
                                                                    </div>
                                                                </div>
                                                                <div class="InputWrapper row" style="padding-top: 50px">
                                                                    <div class="myenrollmentschool">
                                                                        <asp:Label ID="lblenrollfollowup" runat="server" Text="Follow-Up Note" CssClass="mylabel myradiolistlabel"></asp:Label>
                                                                       </div>
                                                                    <div class="myenrollmentschool">
                                                                       <%-- <asp:TextBox Height="30px" Style="resize: none;" TextMode="MultiLine" Width="400px"
                                                                            ID="txtenrollmentfollowup" runat="server"></asp:TextBox>--%>
                                                                        <telerik:RadEditor ID="reenrollmentfollowup" CssClass="TextEditor" MaxTextLength="3000" Width="520" Height="200"
                                                                                AutoResizeHeight="True" AllowScripts="false" EnableEmbeddedSkins="false"
                                                                                Skin="Prodigy" runat="server" EnableResize="False">
                                                                                <Tools>
                                                                                   
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

                                                                        <%--<asp:RequiredFieldValidator ID="rfvnotefollowup" runat="server" Display="Dynamic"
                                                                            Text="* Required" CssClass="ErrorMessage RegAddFormError" ControlToValidate="txtenrollmentfollowup"
                                                                            ErrorMessage="Follow up note is required" ValidationGroup="AddNotes">
                                                                        </asp:RequiredFieldValidator>--%>
                                                                    </div>
                                                                </div>
                                                                <div class="InputWrapper row" style="padding-top: 50px">
                                                                    <div class="FormLabel">
                                                                        &nbsp;
                                                                    </div>
                                                                    <asp:Button ID="btnUpdate" Text="Update" runat="server" ValidationGroup="AddNotes" CssClass="mybutton"
                                                                        CommandName="Update" Visible='<%# !(Container.DataItem is Telerik.Web.UI.GridInsertionObject) %>'></asp:Button>
                                                                    <asp:Button ID="btnInsert" Text="Insert" ValidationGroup="AddNotes" runat="server" CommandName="PerformInsert"
                                                                        CssClass="mybutton " Visible='<%# Container.DataItem is Telerik.Web.UI.GridInsertionObject %>'></asp:Button>
                                                                    &nbsp; &nbsp;
                                            <asp:Button runat="server" ID="ButtonCacnel" Text="Cancel" CssClass="mybutton mycancel"
                                                CommandName="Cancel" CausesValidation="false"></asp:Button>
                                                                </div>
                                                            </div>
                                                        </asp:Panel>
                                                    </FormTemplate>
                                                </EditFormSettings>
                                                <NoRecordsTemplate>
                                                    <p>
                                                        There are no notes specified at this time!
                                                    </p>
                                                </NoRecordsTemplate>
                                            </MasterTableView>
                                        </telerik:RadGrid>


                                    </ContentTemplate>
                                </asp:UpdatePanel>

                            </div>
                            <asp:Button ID="Button1" runat="server" ValidationGroup="Save" OnClick="EnrollmentNotesPrint_Click" Text="Print Notes" class="mybutton" />
                        </telerik:RadPageView>

                    </telerik:RadMultiPage>
                </div>
            </div>
            <!--end tabcontent-->
        </div>
        <!--end tabcontainer-->
    </auth:SecureContent>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="EditButtonsPlaceholder" runat="server">
    <asp:Panel ID="PanelMainContentEditButtons" runat="server">
        <div class="editButtons">
            <auth:SecureContent ID="SecureContent2" ToggleVisible="true" ToggleEnabled="false"
                EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
                <asp:Button ID="DeleteButton" runat="server" CausesValidation="false" OnClick="DeleteButton_Click"
                    OnClientClick="return confirm('Are you sure you want to delete this Youth and all the related information');"
                    Text="Delete" class="mybutton mydelete" />

            </auth:SecureContent>
            <asp:Button ID="secondPrint" runat="server" CausesValidation="false" OnClick="PrintButton_Click"
                Text="Print" class="mybutton myprint" />

            <auth:SecureContent ID="SecureContent3"
                ToggleVisible="true" ToggleEnabled="false" EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
                <asp:Button ID="SaveButton" runat="server" ValidationGroup="Save" OnClick="SaveButton_Click"
                    Text="Save" class="mybutton mysave" />
            </auth:SecureContent>
        </div>
    </asp:Panel>
</asp:Content>
