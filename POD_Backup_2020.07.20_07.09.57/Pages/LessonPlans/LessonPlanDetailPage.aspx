<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master"
    AutoEventWireup="true" CodeBehind="LessonPlanDetailPage.aspx.cs" Inherits="POD.Pages.LessonPlans.LessonPlanDetailPage" %>

<%@ Register Src="../../UserControls/ClassesLinks.ascx" TagName="ClassesLinks" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
 

 
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
    <uc2:ClassesLinks ID="ClassesLinks1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <telerik:RadScriptBlock runat="server">
        <script type="text/javascript">
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

                //$(document).tooltip({
                //    content: function () {
                //        return $(this).prop('title');
                //    }
                //});

            });



            //used for the Lesson Plan template selection
            function populateTemplate(ageGroupId, assistantId, instrctorId, typeId, locationId, programId) {

                
                var rdpagegroup = $find("<%= RadComboBoxClassAgeGroupLPS.ClientID %>");
                var rdplocation = $find("<%= RadComboBoxSiteLesson.ClientID %>");
                var rdpplantype = $find("<%= RadComboBoxLessonPlanType.ClientID %>");
                var rdpassistant = $find("<%= RadComboBoxClassAssistantLesson.ClientID %>");
                var rdpinstructor = $find("<%= RadComboBoxInstructorLPS.ClientID %>");
                var className = $find("<%= TextBoxNameLPS.ClientID %>");
                var rdpLocation2 = $find("<%= RadComboBoxLocationNew.ClientID %>");

                //alert('ageGroupId= ' + ageGroupId);
                //alert('assistantId= ' + assistantId);
                //alert('instrctorId= ' + instrctorId);
                //alert('typeId= ' + typeId);
                //alert('locationId= ' + locationId);

                var item = rdpLocation2.findItemByValue(programId);
                if (item) { item.select(); }

                ////location
                var itm_location = rdplocation.findItemByValue(locationId);
                if (itm_location) { itm_location.select(); }

                ////instructor
                var itm_instruct = rdpinstructor.findItemByValue(instrctorId);
                if (itm_instruct) { itm_instruct.select(); }

                //age group
                var itm_age = rdpagegroup.findItemByValue(ageGroupId);
                if (itm_age) { itm_age.select(); }

                //assistant
                var itm_assistant = rdpassistant.findItemByValue(assistantId);
                if (itm_assistant) { itm_assistant.select(); }

                ////type
                var itm_type = rdpplantype.findItemByValue(typeId);
                if (itm_type) { itm_type.select(); }
                
                
                document.getElementById("<% =TextBoxNameLPS.ClientID %>").focus();
               


            };

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
            };

            String.prototype.format = String.prototype.f = function () {
                var s = this,
                    i = arguments.length;

                while (i--) {
                    s = s.replace(new RegExp('\\{' + i + '\\}', 'gm'), arguments[i]);
                }
                return s;
            };

            ///
            function checkValuePassed(passedValue) {                
                if (passedValue != null || passedValue != undefined )
                {   return passedValue;    }
                else
                { return ''; }
            };

            ///
            function getFormattedDate(date) {
                if (date.getFullYear() != '1969') {

                    var year = date.getFullYear();
                    var month = (1 + date.getMonth()).toString();
                    month = month.length > 1 ? month : '0' + month;
                    var day = date.getDate().toString();
                    day = day.length > 1 ? day : '0' + day;
                    return month + '/' + day + '/' + year;
                } else {

                    return '';
                }

            };

           function enabledisableNickName() {
                var txtNickName = document.getElementById('<%= txtNickName.ClientID %>');
                var cbSaveTemplate = document.getElementById('<%= cbSaveTemplate.ClientID %>');
                               
                if (cbSaveTemplate.checked == true)
                {
                    
                    txtNickName.disabled = '';
                }
                else
                {
                    txtNickName.value = '';
                    txtNickName.disabled = true;
                }
               
            };

            //function to calculate the 
            function populateCalcName() {

                var lblCalculatedName = $find("<%= lblCalcName.ClientID %>");
                var rdpinstructor = $find("<%= RadComboBoxInstructorLPS.ClientID %>");
                var lpsName = document.getElementById('<%= hflpsName.ClientID %>');
                var rdpagegroup = $find("<%= RadComboBoxClassAgeGroupLPS.ClientID %>");
                var rdplocation = $find("<%= RadComboBoxLocationNew.ClientID %>");                     
                var rdpstartdate = $find("<%= rdpstartdatestart.ClientID %>").get_selectedDate();
                var rdpenddate = $find("<%= rdpenddate.ClientID %>").get_selectedDate();              

                //location
                if (rdplocation.get_selectedItem().get_value() != "") {
                    var selectedLocation = rdplocation.get_selectedItem().get_text();
                }
                else {
                    var selectedLocation = '';
                }

                //Instructor
                if (rdpinstructor.get_selectedItem().get_value() != "") {
                    var selectedInstructor = rdpinstructor.get_selectedItem().get_text();
                    
                }
                else {
                    var selectedInstructor = '';
                }

                //Age Group
                if (rdpagegroup.get_selectedItem().get_value() != "") {
                    var selectedAgeGroup = rdpagegroup.get_selectedItem().get_text();
                }
                else {
                    var selectedAgeGroup = '';
                }

                //class name
                var enteredClassName = document.getElementById("<% =TextBoxNameLPS.ClientID %>").value;

                
                var instructorFullNames = selectedInstructor.split(' ');
                var firstInitial = instructorFullNames[0].charAt(0);
                var lastName = instructorFullNames[1];

                var startdt = new Date(rdpstartdate)
                var enddt = new Date(rdpenddate)

                //enteredClassName = checkValuePassed(enteredClassName);
                startdt = getFormattedDate(startdt);
                enddt = getFormattedDate(enddt);
                

                var finalName = "{0} {1} [{2}] {3}-{4} {5} {6}".f(firstInitial, lastName, enteredClassName, startdt, enddt, selectedAgeGroup, selectedLocation);

                
                
                //alert(finalName);
                $('#<%=lblCalcName.ClientID%>').empty();

                

                //end experiement
               
                $('#<%=lblCalcName.ClientID%>').html(finalName); 

                var hiddenName = $find("<%= hflpsName.ClientID %>");
                hiddenName = finalName;
                
                $('#<%=hflpsName.ClientID%>').attr('value', '');
                $('#<%=hflpsName.ClientID%>').attr('value', finalName);

                <%--alert($('#<%=hflpsName.ClientID%>').val());
                alert(hiddenName);--%>

                

                

                
            };

            function OnClientSelectedIndexChanged(sender, eventArgs) {
                
                
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
    <div class="tabcontainer widetabcontainer">
        <div class="tabcontent LessonPlanPrintContainer">

            <asp:Panel ID="PanelLessonPlanSet" runat="server" CssClass="FormWrapper CourseInfoWrapper LessonPlanSet">
                <h2 class="AdminHeader">Lesson Plan Set Name:
                     <img src="../../Templates/Images/infoicon2.gif"  style="width:16px;height:16px;" title='Lesson Plan Name will be generated automatically based on your selections.'" 
                                alt="Information Icon" />
                </h2>
                <h2 class="AdminHeader">
                            <asp:label id="lblCalcName" ForeColor="Black" runat="server" CssClass="mylabel"></asp:label>
                            <%--<asp:TextBox ID="lblCalcName"  runat="server" Width="150" Enabled="false" CssClass="myfield"></asp:TextBox>--%>
                            <asp:HiddenField ID="hflpsName" ClientIDMode="Static" runat="server" />
                        </h2>
                <div class="LessonPlanInfoFields LessonPlanSet">
                    <div class="LessonPlanInfoFieldsLeft LessonPlanSet" style="width: 45%">
                        <h2 class="AdminHeader">Lesson Plan Set Information</h2>
                        
                        <%-- Site --%>
                        <div class="InputWrapper row">
                            <asp:Label ID="LessonPlanInfoSiteLesson" runat="server" Text="Site" CssClass="mylabel"></asp:Label>
                            <telerik:RadComboBox ID="RadComboBoxSiteLesson" DataValueField="LocationID" DataTextField="Name"
                                EmptyMessage="Select Site" runat="server" EnableEmbeddedSkins="false" AutoPostBack="True" 
                                SkinID="Prodigy" CssClass="mydropdown" AppendDataBoundItems="true" OnSelectedIndexChanged="RadComboBoxSiteLesson_OnSelectedIndexChanged" >
                                <Items>
                                    <telerik:RadComboBoxItem Text="Select Site" Value="" />
                                </Items>
                            </telerik:RadComboBox>
                            <asp:RequiredFieldValidator ID="rfv1" runat="server" ControlToValidate="RadComboBoxSiteLesson"
                                InitialValue="" ErrorMessage="&nbsp;* Site is Required" Display="Dynamic" ValidationGroup="saveLessonPlan"></asp:RequiredFieldValidator>
                            
                        </div>

                        <!-- Program Location -->
                        <div class="InputWrapper row">
                            <asp:Label ID="Label3" runat="server" ClientIDMode="Static"  Text="Program Location" CssClass="mylabel"></asp:Label>
                            <telerik:RadComboBox ID="RadComboBoxLocationNew" AppendDataBoundItems="true" 
                                DataValueField="LocationID" DataTextField="Name" runat="server" EmptyMessage="Select Location"  OnClientSelectedIndexChanged="populateCalcName"  EnableEmbeddedSkins="false" SkinID="Prodigy"
                                CssClass="mydropdown">
                                <Items>
                                    <telerik:RadComboBoxItem Text="Select Location" Value="" />
                                </Items>
                            </telerik:RadComboBox>

                            <asp:RequiredFieldValidator ID="RequiredFieldValidator708" runat="server" ControlToValidate="RadComboBoxLocationNew"
                                InitialValue="" ErrorMessage="&nbsp;* Location is Required" Display="Dynamic" ValidationGroup="saveLessonPlan"></asp:RequiredFieldValidator>
                        </div>

                         <%-- Instructors --%>
                        <div class="InputWrapper row">
                            <asp:Label ID="LabelInstructorLPS" runat="server" Text="Instructor" ClientIDMode="Static"  CssClass="mylabel"></asp:Label>
                            <telerik:RadComboBox ID="RadComboBoxInstructorLPS" DataValueField="PersonID" DataTextField="FullName"
                                runat="server" AppendDataBoundItems="true" EnableEmbeddedSkins="false" SkinID="Prodigy"
                                EmptyMessage="Select Instructor" OnClientSelectedIndexChanged="populateCalcName" CssClass="mydropdown">
                                <Items>
                                    <telerik:RadComboBoxItem Text="Select Instructor" Value="" />
                                </Items>
                            </telerik:RadComboBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator713" runat="server" ControlToValidate="RadComboBoxInstructorLPS"
                                InitialValue="" ErrorMessage="&nbsp;* Instructor is Required" Display="Dynamic" ValidationGroup="saveLessonPlan"></asp:RequiredFieldValidator>
                        </div>
                        <!-- Instructor Assistant -->
                        <div class="InputWrapper row">
                            <asp:Label ID="Label5" runat="server" Text="Instructor Assistant" CssClass="mylabel"></asp:Label>
                            <telerik:RadComboBox ID="RadComboBoxClassAssistantLesson" AppendDataBoundItems="true" DataValueField="PersonID"
                                DataTextField="FullName" runat="server" EnableEmbeddedSkins="false" SkinID="Prodigy"
                                CssClass="mydropdown" EmptyMessage="Select Assistant">
                                <Items>
                                    <telerik:RadComboBoxItem Text="Select Assistant" Value="" />
                                </Items>
                            </telerik:RadComboBox>
                             <asp:RequiredFieldValidator ID="RequiredFieldValidator714" runat="server" ControlToValidate="RadComboBoxClassAssistantLesson"
                                InitialValue="" ErrorMessage="&nbsp;* Assistant is Required" Display="Dynamic" ValidationGroup="saveLessonPlan"></asp:RequiredFieldValidator>
                        </div>

                        <%-- Name --%>

                        <div class="InputWrapper row">
                            
                            <asp:Label ID="LabelNameLPS" runat="server" Text="Class Name" CssClass="mylabel"></asp:Label>
                            <asp:TextBox ID="TextBoxNameLPS"  runat="server" Width="150" CssClass="myfield"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator709" runat="server" ControlToValidate="TextBoxNameLPS"
                                InitialValue="" ErrorMessage="&nbsp;* Class Name is Required" Display="Dynamic" ValidationGroup="saveLessonPlan"></asp:RequiredFieldValidator>
                        </div>

                        <!-- Lesson Plan Type -->
                        <div class="InputWrapper row">
                            <asp:Label ID="Label7" runat="server" Text="Type" CssClass="mylabel"></asp:Label>
                            <telerik:RadComboBox ID="RadComboBoxLessonPlanType" ClientIDMode="Static" AppendDataBoundItems="true" DataValueField="LessonPlanTypeID"
                                DataTextField="Name" runat="server" EnableEmbeddedSkins="false" SkinID="Prodigy" CausesValidation="True" OnClientSelectedIndexChanged="OnClientSelectedIndexChanged"  EmptyMessage="Select Type"
                                CssClass="mydropdown">
                               <%-- <Items>
                                    <telerik:RadComboBoxItem Text="Select Type" Value="" />
                                </Items>--%>
                            </telerik:RadComboBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator904" runat="server" ControlToValidate="RadComboBoxLessonPlanType"
                                InitialValue="" ErrorMessage="&nbsp;* Type is Required" Display="Dynamic" SetFocusOnError="True" ValidationGroup="saveLessonPlan"></asp:RequiredFieldValidator>
                           
                        </div>
                        <%-- Status --%>
                        <asp:Panel ID="PanelAdminStatus" runat="server" Visible="false" CssClass="InputWrapper row">
                            <asp:Label ID="Label4" runat="server" Text="Status" CssClass="mylabel"></asp:Label>
                            <telerik:RadComboBox DataTextField="Description" DataValueField="StatusTypeID" 
                                ID="RadComboBoxStatusLPS" runat="server" AppendDataBoundItems="true" EnableEmbeddedSkins="false"
                                SkinID="Prodigy" CssClass="mydropdown"  EmptyMessage="Select Status">
                                <Items>
                                    <telerik:RadComboBoxItem Text="Select Status" Value="" />
                                </Items>
                            </telerik:RadComboBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator707" runat="server" ControlToValidate="RadComboBoxStatusLPS"
                                InitialValue="" ErrorMessage="&nbsp;* Status is Required" Display="Dynamic" ValidationGroup="saveLessonPlan"></asp:RequiredFieldValidator>
                        </asp:Panel>

                        <!-- Age Group -->
                        <div class="InputWrapper row">
                            <asp:Label ID="lbRadComboBoxClassAgeGroup" runat="server" ClientIDMode="Static" Text="Age Group" CssClass="mylabel"></asp:Label>
                            <telerik:RadComboBox ID="RadComboBoxClassAgeGroupLPS" AppendDataBoundItems="true" DataValueField="AgeGroupID"
                                DataTextField="Name" runat="server" EmptyMessage="Select Age Group"   OnClientSelectedIndexChanged="populateCalcName"  EnableEmbeddedSkins="false" SkinID="Prodigy"
                                CssClass="mydropdown">
                                <%--<Items>
                                    <telerik:RadComboBoxItem Text="Select Age Group" Value="" />
                                </Items>--%>
                            </telerik:RadComboBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator300" runat="server" ControlToValidate="RadComboBoxClassAgeGroupLPS"
                                InitialValue="" ErrorMessage="&nbsp;* Age Group is Required" Display="Dynamic" ValidationGroup="saveLessonPlan"></asp:RequiredFieldValidator>
                        </div>
                        
                        <!-- Lesson Plan Set Start Date -->
                        <div class="InputWrapper row">
                            <asp:Label ID="lbstartDate" runat="server" Text="Start Date" CssClass="mylabel"></asp:Label>

                            <telerik:RadDatePicker ID="rdpstartdatestart" runat="server" DateInput-Width="60px"
                                Width="25%" DateInput-DisplayDateFormat="MM/dd/yy" DateInput-DateFormat="MM/dd/yyyy"  DateInput-OnClientDateChanged="populateCalcName"   Calendar-ShowRowHeaders="False"
                                Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup">
                            </telerik:RadDatePicker>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator711" runat="server" ControlToValidate="rdpstartdatestart"
                                InitialValue="" ErrorMessage="&nbsp;* Startdate is Required" Display="Dynamic" ValidationGroup="saveLessonPlan"></asp:RequiredFieldValidator>
                        </div>



                        <!-- Lesson Plan Set End Date -->
                        <div class="InputWrapper row">
                            <asp:Label ID="Label8" runat="server" Text="End Date" CssClass="mylabel"></asp:Label>

                            <telerik:RadDatePicker ID="rdpenddate" runat="server" DateInput-Width="60px"
                                Width="25%" DateInput-DisplayDateFormat="MM/dd/yy"  DateInput-DateFormat="MM/dd/yyyy" DateInput-OnClientDateChanged="populateCalcName"   Calendar-ShowRowHeaders="False"
                                Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup">
                            </telerik:RadDatePicker>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator712" runat="server" ControlToValidate="rdpenddate"
                                InitialValue="" ErrorMessage="&nbsp;* Enddate is Required" Display="Dynamic" ValidationGroup="saveLessonPlan"></asp:RequiredFieldValidator>
                        </div>

                       

                        

                        

                        
                        
                        <!-- Option to save the item off as a template -->
                        <div class="InputWrapper row">
                            <asp:Label runat="server" ID="Label6" Text="Save as template?" CssClass="mylabel"></asp:Label>
                            <asp:CheckBox runat="server" ID="cbSaveTemplate"  OnClick="javascript:enabledisableNickName();"  />
                            <asp:TextBox ID="txtNickName" ClientIDMode="Static"  runat="server" Enabled="false" Width="150" CssClass="myfield"></asp:TextBox>
                        </div>

                        <div class="InputWrapper row">
                            <asp:Label runat="server" ID="Label9" Text="Add Lesson plan after save?" CssClass="mylabel"></asp:Label>
                            <asp:CheckBox runat="server" ID="cblessonplanadd" />
                        </div>
                        
                        

                        <asp:Panel runat="server" ID="PanelMarkCompleted" Visible="False">
                            <div class="InputWrapper row">
                                <asp:Label runat="server" ID="LabelComplete" Text="Completed Pending Approval" CssClass="mylabel"></asp:Label>
                                <asp:CheckBox runat="server" ID="CheckboxMarkCompleted" />
                            </div>
                        </asp:Panel>

                    </div>
                    <%--End Lesson Plan Left Section--%>
                    <%--Start Lesson Plan Right Section--%>
                    <div class="LessonPlanInfoFieldsRight">
                        <h2 class="AdminHeader">
                            Your Lesson Plan Set Templates
                            <img src="../../Templates/Images/infoicon2.gif" style="width:16px;height:16px;"  title='Hover over your Template nickname to see additional information. '" 
                                alt="Information Icon" />
                        </h2>
                        
                            
                        
                        <telerik:RadGrid ID="RadGridTemplate" runat="server" AutoGenerateColumns="false"
                            OnNeedDataSource="RadGridTemplate_NeedDataSource" AllowPaging="True" AllowSorting="true"
                            AllowFilteringByColumn="false" GroupingSettings-CaseSensitive="false" PageSize="5"
                            Width="100.1%" EnableEmbeddedSkins="false" OnItemCommand="RadGridTemplate_ItemCommand1" Skin="Prodigy" HorizontalAlign="Center"
                            SelectedItemStyle-Wrap="true">
                            <MasterTableView TableLayout="Auto" ClientDataKeyNames="LessonPlanSetTemplateId" DataKeyNames="LessonPlanSetTemplateId">
                                <Columns>

                                    <telerik:GridTemplateColumn UniqueName="AmountColumn" DataField="InstructorId" HeaderText="Type" ItemStyle-Width="20px">
                                        <ItemTemplate>
                                            <span>     
                                                                                       
                                                <asp:Image ID="InstructorImage" AlternateText='' Visible='<%# Convert.ToString(Eval("LPSTemplateType")) == "2" ? true : false %>' runat="server" CssClass="smIcon masterTooltip" ImageUrl='<%# "~/Templates/Images/user2.png"%>' /></div>
                                            </span>
                                           
                                        </ItemTemplate>

                                    </telerik:GridTemplateColumn>
                                    <telerik:GridTemplateColumn UniqueName="AmountColumn" DataField="InstructorId" HeaderText="Lesson Plan Set Template Information">
                                        <ItemTemplate>
                                           
                                            <div>
                                            <asp:Label ID="Label1" runat="server" Font-Bold="true"
                                                Text='<%# Bind("TemplateName") %>'></asp:Label>
                                            <br />
                                            </div>
                                                                                      
                                        </ItemTemplate>

                                    </telerik:GridTemplateColumn>
                                    <telerik:GridTemplateColumn ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="100px" ItemStyle-Width="100px">
                                        <ItemTemplate>
                                            <a onclick="javascript:populateTemplate(<%# Eval("LessonPlanSetDetails.AgeGroupId") %>,<%# Eval("LessonPlanSetDetails.AssistantPersonID") %>,<%# Eval("LessonPlanSetDetails.InstructorPersonID") %>,<%# Eval("LessonPlanSetDetails.DisciplineTypeID") %>,<%# Eval("LessonPlanSetDetails.SiteLocationID") %>,<%# Eval("LessonPlanSetDetails.SpecificLocationID") %>)">Use this Template</a>
                                            
                                        </ItemTemplate>
                                    </telerik:GridTemplateColumn>
                                    <%--<telerik:GridTemplateColumn ItemStyle-HorizontalAlign="Center" >
                <ItemTemplate>
                
                <asp:ImageButton ID="Imagebutton" runat="server" ImageUrl="~/App_Themes/Prodigy/Grid/edit.gif" CommandName="Edit" CssClass="GridEditButton" />
                 
                
                </ItemTemplate>
                </telerik:GridTemplateColumn>--%>
                                     <telerik:GridTemplateColumn ItemStyle-HorizontalAlign="Center" >
                <ItemTemplate>
                
                
                 <asp:ImageButton ID="ImagebuttonDelete" runat="server" ImageUrl="~/App_Themes/Prodigy/Grid/Delete.png" CommandName="Delete" CssClass="GridDeleteButton" />
                
                </ItemTemplate>
                </telerik:GridTemplateColumn>
                                </Columns>
                                <NoRecordsTemplate>
                                    <p>
                                        You have no saved lesson plan set templates.
                                    </p>
                                </NoRecordsTemplate>
                            </MasterTableView>
                            
                        </telerik:RadGrid>
                    </div>
                </div>
            </asp:Panel>




            <asp:Panel ID="PanelLessonPlan" runat="server" class="CourseInfoWrapper">
                <div class="LessonPlanPrintBlock">
                    <h1>
                        <img src="../../Templates/Images/prodigy_logo_print2.png" width="280px" height="133px"
                            alt="Prodigy" /></h1>
                    <h2>PRODIGY LESSON PLAN</h2>
                </div>
                <h2>Lesson Plan Set Information</h2>
                <asp:Panel ID="PanelContent" class="FormWrapper" runat="server">
                    <!-- hidden fields for processing -->
                    <asp:HiddenField ID="hfLessonPlanSetId" runat="server" />
                    <asp:HiddenField ID="hfLessonPlanSetName" runat="server" />
                    <asp:HiddenField ID="hfClassName" runat="server" />
                    <asp:HiddenField ID="hfSite" runat="server" />
                    <asp:HiddenField ID="hfLocation" runat="server" />
                    <asp:HiddenField ID="hfClassType" runat="server" />
                    <asp:HiddenField ID="hfAgegroup" runat="server" />
                    <asp:HiddenField ID="hfAssistant" runat="server" />

                    
                    <div class="LessonPlanInfoFields"  style="min-height:150px;">
                        <div class="LessonPlanInfoFieldsLeft" style="width:60%;">
                            <%-- Lesson Plan Name --%>
                            <div class="InputWrapper row">
                                <asp:Label ID="Label1" runat="server" Text="Lesson Plan Set Name" CssClass="mylabel-right"></asp:Label>
                                <asp:Label ID="lblLessonPlanSetName" runat="server" CssClass="myfield-plain"></asp:Label>
                            </div>
                            <%-- Class Name --%>
                            <div class="InputWrapper row">
                                <asp:Label ID="LessonPlanInfoName" runat="server" Text="Class Name" CssClass="mylabel-right"></asp:Label>
                                <asp:Label ID="lbclassName" runat="server" CssClass="myfield-plain"></asp:Label>
                                                                
                            </div>
                            <div class="InputWrapper row">
                                <%-- Site --%>
                                <asp:Label ID="LessonPlanInfoSite" runat="server" Text="Site" CssClass="mylabel-right"></asp:Label>
                                <asp:Label ID="lblLessonPlanSite" runat="server" CssClass="myfield-plain"></asp:Label>
                                
                            </div>
                            
                            <div class="InputWrapper row">
                                <%-- Program Type --%>
                                <asp:Label ID="LessonPlanInfoType" runat="server" Text="Class Type" CssClass="mylabel-right"></asp:Label>
                                <asp:Label ID="lblLessonPlanType" runat="server" CssClass="myfield-plain"></asp:Label>
                                <telerik:RadComboBox DataTextField="Name"  Visible="false"  DataValueField="LessonPlanTypeID" DataSourceID="DataSourceLessonPlanType"
                                    ID="RadComboProgramType" runat="server" AppendDataBoundItems="true" CssClass="mydropdown"
                                    EmptyMessage="Select Type" OnClientSelectedIndexChanged="PrintFieldSwap">
                                    <Items>
                                        <telerik:RadComboBoxItem Text="Select Type" Value="" />
                                    </Items>
                                </telerik:RadComboBox>
                               
                            </div>
                           
                            <div class="InputWrapper row">
                                <%-- Age Group --%>
                                <asp:Label ID="LessonPlanInfoAge" runat="server" Text="Age Group" CssClass="mylabel-right"></asp:Label>
                                <asp:Label ID="lblLessonPlanAgeGroup" runat="server" CssClass="myfield-plain"></asp:Label>
                                <telerik:RadComboBox DataTextField="Name" Visible="false" DataValueField="AgeGroupID" DataSourceID="DataSourceAgeGroup"
                                    ID="RadComboBoxAgeGroup" runat="server" AppendDataBoundItems="true" EnableEmbeddedSkins="false"
                                    EmptyMessage="Select Age Group" SkinID="Prodigy" CssClass="mydropdown" OnClientSelectedIndexChanged="PrintFieldSwap">
                                    <Items>
                                        <telerik:RadComboBoxItem Text="Select Age Group" Value="" />
                                    </Items>
                                </telerik:RadComboBox>
                                
                            </div>
                        </div>
                        <!-- end LessonPlanInfoFieldsLeft -->
                        <div class="LessonPlanInfoFieldsRight"  style="width:40%;">

                           
                            <div class="InputWrapper row">
                                <asp:Label ID="Label2" runat="server" Text="Instructor" CssClass="mylabel-right"></asp:Label>
                                <asp:Label ID="lblLessonPlanInfoInstructor" runat="server" CssClass="myfield-plain"></asp:Label>
                            </div>
                            <div class="InputWrapper row">
                                <%-- Assistant --%>
                                <asp:Label ID="LessonPlanInfoAssistant" runat="server" Text="Assistant" CssClass="mylabel-right"></asp:Label>
                                <asp:Label ID="lblLessonPlanAssistant" runat="server" CssClass="myfield-plain"></asp:Label>
                                <telerik:RadComboBox ID="RadComboBoxAssistant" Visible="false" AppendDataBoundItems="true" DataValueField="PersonID"
                                    DataTextField="FullName" runat="server" EnableEmbeddedSkins="false" SkinID="Prodigy"
                                    CssClass="mydropdown" OnClientSelectedIndexChanged="PrintFieldSwap">
                                    <Items>
                                        <telerik:RadComboBoxItem Text="Select Assistant" Value="" />
                                    </Items>
                                </telerik:RadComboBox>
                            </div>
                            <div class="InputWrapper row">
                                <%-- Location --%>
                                <asp:Label ID="LessonPlanInfoLocation" runat="server" Text="Location" CssClass="mylabel-right"></asp:Label>
                                <asp:Label ID="lblLessonPlanLocation" runat="server" CssClass="myfield-plain"></asp:Label>
                                
                                <telerik:RadComboBox ID="RadComboBoxLocation" Visible="false" DataValueField="LocationID" DataTextField="Name"
                                    EmptyMessage="Select Location" runat="server" CssClass="mydropdown" AppendDataBoundItems="true" OnClientSelectedIndexChanged="PrintFieldSwap">
                                    <Items>
                                        <telerik:RadComboBoxItem Text="Select Location" Value="" />
                                    </Items>
                                </telerik:RadComboBox>
                               
                            </div>

                        </div>
                        <!-- end LessonPlanInfoFieldsRight -->
                    </div>
                        
                    <h2>Lesson Plan Information</h2>
                    <div class="LessonPlanInfoFields" style="min-height: 100px;">
                        <div class="LessonPlanInfoFieldsLeft">
                            <div class="InputWrapper row">
                                <asp:Label ID="LabelWeek" runat="server" Text="Lesson #" CssClass="mylabel-right"></asp:Label>
                                <telerik:RadNumericTextBox ID="TextBoxWeek" runat="server" Enabled="false" MinValue="1" CssClass="myfield mytextbox"
                                    ShowSpinButtons="false" Type="Number" Width="100px">
                                    <NumberFormat GroupSeparator="" DecimalDigits="0" />
                                </telerik:RadNumericTextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="TextBoxWeek"
                                    ErrorMessage="&nbsp;* Required" Display="Dynamic" ValidationGroup="saveLessonPlan"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="InputWrapper row StartDateContainer">
                    <asp:Label ID="Label10" runat="server" Text="Lesson Plan Date" CssClass="mylabel-right"></asp:Label>
                    <telerik:RadDatePicker ID="RadDatePickerStart" runat="server" DateInput-Width="150px" Width="150px" 
                         DateInput-DisplayDateFormat="MM/dd/yy" Calendar-ShowRowHeaders="False"
                        Calendar-CssClass="myfield myDatePickerPopup" CssClass="myDatePickerPopup myenrollmentdate-new">
                    </telerik:RadDatePicker>
                            <asp:RequiredFieldValidator runat="server" ID="RequiredFieldValidator1" ControlToValidate="RadDatePickerStart" Display="Dynamic" ErrorMessage="Start Date is Required" Enabled="true" ValidationGroup="saveLessonPlan">
</asp:RequiredFieldValidator>
                            </div>
                        <div class="InputWrapper row StartDateContainer">
                    <asp:Label ID="Label11" runat="server" Text="Start Time" CssClass="mylabel-right"></asp:Label>
                             <telerik:RadTimePicker RenderMode="Lightweight" ID="RadDatePickerStartTime" Width="150px" runat="server" Calendar-CssClass="myfield myDatePickerPopup" CssClass="myDatePickerPopup myenrollmentdate-new "></telerik:RadTimePicker>
                            <%--<telerik:RadDateTimePicker ID="RadDatePickerStartTime" runat="server" DateInput-Width="259px" Width="20%"
                         DateInput-DisplayDateFormat="hh:mm tt" Calendar-ShowRowHeaders="False"
                        Calendar-CssClass="myfield myDatePickerPopup" CssClass="myDatePickerPopup myenrollmentdate-new ">
                    </telerik:RadDateTimePicker>--%>
                            <asp:RequiredFieldValidator runat="server" ID="RequiredFieldValidator2" ControlToValidate="RadDatePickerStartTime" Display="Dynamic" ErrorMessage="End Date is Required" Enabled="true" ValidationGroup="saveLessonPlan">
</asp:RequiredFieldValidator>
                </div>
                        <div class="InputWrapper row StartDateContainer">
                            <asp:Label ID="Label1211" runat="server" Text="End Time" CssClass="mylabel-right"></asp:Label>
                            <telerik:RadTimePicker RenderMode="Lightweight" ID="RadDatePickerEndTime" Width="150px" runat="server" Calendar-CssClass="myfield myDatePickerPopup" CssClass="myDatePickerPopup myenrollmentdate-new "></telerik:RadTimePicker>
                            <%--<telerik:RadDateTimePicker ID="RadDatePickerEndTime" runat="server" DateInput-Width="259px" Width="20%"
                         DateInput-DisplayDateFormat="hh:mm tt" Calendar-ShowRowHeaders="False"
                        Calendar-CssClass="myfield myDatePickerPopup" CssClass="myDatePickerPopup myenrollmentdate-new ">
                    </telerik:RadDateTimePicker>--%>
                            <asp:RequiredFieldValidator runat="server" ID="RequiredFieldValidator55" ControlToValidate="RadDatePickerEndTime" Display="Dynamic" ErrorMessage="End Date is Required" Enabled="true" ValidationGroup="saveLessonPlan">
</asp:RequiredFieldValidator>
                </div>
                <%--<div class="InputWrapper row StartDateContainer">
                    <asp:Label ID="Label11" runat="server" Text="End Date" CssClass="mylabel"></asp:Label>
                    <telerik:RadDateTimePicker ID="RadDatePickerEnd" runat="server" DateInput-Width="150px"
                        Width="52%" DateInput-DisplayDateFormat="MM/dd/yy hh:mm tt" Calendar-ShowRowHeaders="False"
                        Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup myenrollmentdate">
                    </telerik:RadDateTimePicker>
                </div>--%>
                        <div class="InputWrapper row LifeSkills">
                            <asp:Label ID="LessonPlanInfoLifeSkills" runat="server" Text="Life Skills" CssClass="mylabel-right"></asp:Label>
                            <telerik:RadComboBox DataTextField="Name" DataValueField="LifeSkillTypeID" DataSourceID="DataSourceLifeSkillType"
                                ID="RadComboBoxLifeSkill" runat="server" AppendDataBoundItems="true" EnableEmbeddedSkins="false"
                                SkinID="Prodigy" CssClass="mydropdown" OnClientSelectedIndexChanged="PrintFieldSwap">
                                <Items>
                                    <telerik:RadComboBoxItem Text="Select Life Skill" Value="" />
                                </Items> 
                            </telerik:RadComboBox>
                            &nbsp;
                                <asp:Button CssClass="mybutton addLifeSkillbutton" runat="server" ID="ButtonAddLifeskill"
                                    Text="Add Life Skill"  OnClick="ButtonAddLifeskill_Click" />
                            <asp:DataList DataKeyField="LifeSkillTypeID" ID="DataListLifeSkills" runat="server"
                                OnItemDataBound="DataListLifeSkills_ItemDataBound" OnItemCommand="DataListLifeSkills_ItemCommand"
                                CssClass="LifeSkillsTable">
                                <ItemTemplate>
                                    <asp:Label ID="LabelName" Text='<%# Bind("Name") %>' runat="Server"></asp:Label></td><td
                                        class="DeleteCell">
                                        <asp:LinkButton ID="ButtonDelete" runat="server" CommandArgument='<%# Bind("LifeSkillTypeID") %>'
                                            CommandName="Delete" Text="Delete" OnClientClick="return confirm('Are you sure you want to remove this life skill from this lesson plan');"><img src="../../App_Themes/Prodigy/Grid/Delete.png" alt="Delete" /></asp:LinkButton>
                                
                                    </ItemTemplate>
                            </asp:DataList>
                            <asp:TextBox runat="server" CssClass="myfield"  ID="lifeskilltext" ></asp:TextBox>
<asp:RequiredFieldValidator runat="server" ID="rfv2" ControlToValidate="lifeskilltext" Display="Dynamic" ErrorMessage="Life Skill Is Required" Enabled="true" ValidationGroup="saveLessonPlan">
</asp:RequiredFieldValidator>
                        </div>
                    </div>

                    <div class="sectionDivider">
                    </div>
                    <div class="InputWrapper LessonPlanInfoBlocks">
                        <telerik:RadTabStrip ID="LessonPlanTabStrip" runat="server" SelectedIndex="0" MultiPageID="MultiPageLessonPlan"
                            Orientation="VerticalLeft" CssClass="RiskAssessmentSections">
                            <Tabs>
                                <telerik:RadTab runat="server" Text="Life Skill 'Warm-up' Activity">
                                </telerik:RadTab>
                                <telerik:RadTab runat="server" Text="Art Objective">
                                </telerik:RadTab>
                                <telerik:RadTab runat="server" Selected="True" Text="Art Activity">
                                </telerik:RadTab>
                                <telerik:RadTab runat="server" Text="Materials Needed">
                                </telerik:RadTab>
                                <telerik:RadTab runat="server" Text="Procedures">
                                </telerik:RadTab>
                                <telerik:RadTab runat="server" Text="Alternate 'On-going' Activity">
                                </telerik:RadTab>
                                <telerik:RadTab runat="server" Text="Life Skill 'Closing' Activity">
                                </telerik:RadTab>
                            </Tabs>
                        </telerik:RadTabStrip>
                        <telerik:RadMultiPage ID="MultiPageLessonPlan" runat="server" ViewStateMode="Inherit"
                            SelectedIndex="0" CssClass="LessonPlanInfoBlockViews">
                            <telerik:RadPageView ID="RadPageView2" runat="server">
                                <h2 class="PrintSectionTitle">Life Skill 'Warm-up' Activity</h2>
                                <telerik:RadEditor ID="RadEditorIntro" CssClass="TextEditor" Width="96%" Height="242"
                                    AutoResizeHeight="true" AllowScripts="false" SkinID="BasicSetOfTools" EnableEmbeddedSkins="false"
                                    Skin="Prodigy" runat="server" EnableResize="False" ContentAreaMode="Div" ContentAreaCssFile="~/Templates/Styles/RadTextEditor_PrintStyles.css">
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
                                    <CssFiles>
                                        <telerik:EditorCssFile Value="~/Templates/Styles/RadTextEditor_PrintStyles.css" />
                                    </CssFiles>
                                </telerik:RadEditor>
                                <br style="clear: both;" class="PrintBR" />
                            </telerik:RadPageView>
                            <telerik:RadPageView ID="RadPageView3" runat="server">
                                <h2 class="PrintSectionTitle">Art Objective</h2>
                                <telerik:RadEditor ID="RadEditorObject" CssClass="TextEditor" Width="96%" Height="242"
                                    AutoResizeHeight="true" AllowScripts="false" SkinID="BasicSetOfTools" EnableEmbeddedSkins="false"
                                    Skin="Prodigy" runat="server" EnableResize="False" ContentAreaMode="Div" ContentAreaCssFile="~/Templates/Styles/RadTextEditor_PrintStyles.css">
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
                                    <CssFiles>
                                        <telerik:EditorCssFile Value="~/Templates/Styles/RadTextEditor_PrintStyles.css" />
                                    </CssFiles>
                                </telerik:RadEditor>
                                <br style="clear: both;" class="PrintBR" />
                            </telerik:RadPageView>
                            <telerik:RadPageView ID="RadPageView1" runat="server">
                                <h2 class="PrintSectionTitle">Art Activity</h2>
                                <telerik:RadEditor ID="RadEditorTopic" CssClass="TextEditor" Width="96%" Height="242"
                                    AutoResizeHeight="true" AllowScripts="false" SkinID="BasicSetOfTools" EnableEmbeddedSkins="false"
                                    Skin="Prodigy" runat="server" EnableResize="False" ContentAreaMode="Div" ContentAreaCssFile="~/Templates/Styles/RadTextEditor_PrintStyles.css">
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
                                    <CssFiles>
                                        <telerik:EditorCssFile Value="~/Templates/Styles/RadTextEditor_PrintStyles.css" />
                                    </CssFiles>
                                </telerik:RadEditor>
                                <br style="clear: both;" class="PrintBR" />
                            </telerik:RadPageView>
                            <telerik:RadPageView ID="RadPageView6" runat="server">
                                <h2 class="PrintSectionTitle">Materials Needed</h2>
                                <telerik:RadEditor ID="RadEditorMatNeeded" CssClass="TextEditor" Width="96%" Height="242"
                                    AutoResizeHeight="true" AllowScripts="false" SkinID="BasicSetOfTools" EnableEmbeddedSkins="false"
                                    Skin="Prodigy" runat="server" EnableResize="False" ContentAreaMode="Div" ContentAreaCssFile="~/Templates/Styles/RadTextEditor_PrintStyles.css">
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
                                    <CssFiles>
                                        <telerik:EditorCssFile Value="~/Templates/Styles/RadTextEditor_PrintStyles.css" />
                                    </CssFiles>
                                </telerik:RadEditor>
                                <br style="clear: both;" class="PrintBR" />
                            </telerik:RadPageView>
                            <telerik:RadPageView ID="RadPageView5" runat="server">
                                <h2 class="PrintSectionTitle">Procedures</h2>
                                <telerik:RadEditor ID="RadEditorActProc" CssClass="TextEditor" Width="96%" Height="242"
                                    AutoResizeHeight="true" AllowScripts="false" SkinID="BasicSetOfTools" EnableEmbeddedSkins="false"
                                    Skin="Prodigy" runat="server" EnableResize="False" ContentAreaMode="Div" ContentAreaCssFile="~/Templates/Styles/RadTextEditor_PrintStyles.css">
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
                                    <CssFiles>
                                        <telerik:EditorCssFile Value="~/Templates/Styles/RadTextEditor_PrintStyles.css" />
                                    </CssFiles>
                                </telerik:RadEditor>
                                <br style="clear: both;" class="PrintBR" />
                            </telerik:RadPageView>
                            <telerik:RadPageView ID="RadPageView4" runat="server">
                                <h2 class="PrintSectionTitle">Alternate 'On-going' Activity</h2>
                                <telerik:RadEditor ID="RadEditorDiscus" CssClass="TextEditor" Width="96%" Height="242"
                                    AutoResizeHeight="true" AllowScripts="false" SkinID="BasicSetOfTools" EnableEmbeddedSkins="false"
                                    Skin="Prodigy" runat="server" EnableResize="False" ContentAreaMode="Div" ContentAreaCssFile="~/Templates/Styles/RadTextEditor_PrintStyles.css">
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
                                    <CssFiles>
                                        <telerik:EditorCssFile Value="~/Templates/Styles/RadTextEditor_PrintStyles.css" />
                                    </CssFiles>
                                </telerik:RadEditor>
                                <br style="clear: both;" class="PrintBR" />
                            </telerik:RadPageView>
                            <telerik:RadPageView ID="RadPageView7" runat="server">
                                <h2 class="PrintSectionTitle">Life Skill 'Closing' Activity</h2>
                                <telerik:RadEditor ID="RadEditrWrapUp" CssClass="TextEditor" Width="96%" Height="242"
                                    AutoResizeHeight="true" AllowScripts="false" SkinID="BasicSetOfTools" EnableEmbeddedSkins="false"
                                    Skin="Prodigy" runat="server" EnableResize="False" ContentAreaMode="Div" ContentAreaCssFile="~/Templates/Styles/RadTextEditor_PrintStyles.css">
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
                                    <CssFiles>
                                        <telerik:EditorCssFile Value="~/Templates/Styles/RadTextEditor_PrintStyles.css" />
                                    </CssFiles>
                                </telerik:RadEditor>
                                <br style="clear: both;" class="PrintBR" />
                            </telerik:RadPageView>
                        </telerik:RadMultiPage>
                    </div>
                    <asp:EntityDataSource ID="DataSourceDiscipline" runat="server" ConnectionString="name=PODContext"
                        DefaultContainerName="PODContext" EnableFlattening="False" EntitySetName="DisciplineTypes">
                    </asp:EntityDataSource>
                    <asp:EntityDataSource ID="DataSourceLifeSkillType" runat="server" ConnectionString="name=PODContext"
                        DefaultContainerName="PODContext" EnableFlattening="False" EntitySetName="LifeSkillTypes">
                    </asp:EntityDataSource>
                    <asp:EntityDataSource ID="DataSourceStatusTypes" runat="server" ConnectionString="name=PODContext"
                        DefaultContainerName="PODContext" EnableFlattening="False" EntitySetName="StatusTypes"
                        OrderBy="it.[Name]" Where='it.[Category]=="Common"'>
                    </asp:EntityDataSource>
                    <asp:EntityDataSource ID="DataSourceLPSStatus" runat="server" ConnectionString="name=PODContext"
                        DefaultContainerName="PODContext" EnableFlattening="False" EntitySetName="StatusTypes"
                        OrderBy="it.[Name]" Where='it.[Category]=="LessonPlanSet"'>
                    </asp:EntityDataSource>
                    <asp:EntityDataSource ID="DataSourceLessonPlanType" runat="server" ConnectionString="name=PODContext"
                        DefaultContainerName="PODContext" EnableFlattening="False" EntitySetName="LessonPlanTypes"
                        OrderBy="it.[Name]">
                    </asp:EntityDataSource>
                    <asp:EntityDataSource ID="DataSourceAgeGroup" runat="server" ConnectionString="name=PODContext"
                        DefaultContainerName="PODContext" EnableFlattening="False" EntitySetName="AgeGroups"
                        OrderBy="it.[Name]">
                    </asp:EntityDataSource>
                </asp:Panel>
            </asp:Panel>

            <div class="InputWrapper row">



                <%-- Save and Close --%>
                <span class="midsize">
                    <asp:Button ID="btnUpdate" Text="Save" runat="server" CssClass="mybutton" CommandName="Insert"
                        OnClick="btnUpdate_Click" CausesValidation="True" ValidationGroup="saveLessonPlan" /></span>
                
              
                &nbsp; &nbsp;
                <%-- Save and Next  --%>
                <span class="largesize">
                <asp:Button runat="server" ID="btnSaveAndNext" Visible="false" Text="Save and Insert Another" CssClass="mybutton"
                    CommandName="SaveAdd" ValidationGroup="saveLessonPlan" OnClick="btnUpdate_Click"></asp:Button></span>

                &nbsp; &nbsp;
                <%-- Cancel  --%>
                <asp:Button runat="server" ID="ButtonCancel" Text="Cancel" CssClass="mybutton mycancel"
                    CommandName="Cancel" CausesValidation="false" OnClick="ButtonCancel_Click"></asp:Button>

                 
            </div>
        </div>
    </div>

</asp:Content>
