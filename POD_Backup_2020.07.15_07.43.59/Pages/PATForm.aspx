<%@ Page Language="C#" MasterPageFile="~/Templates/Markup/Admin.Master" AutoEventWireup="true" CodeBehind="PATForm.aspx.cs" Inherits="POD.Pages.PATForm" %>

<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
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


    <div class="tabcontainer">
        <div class="tabcontent">
            <div style="float: left">
                <h3 class="sectionHead PrintHide">PAT Form:&nbsp;<asp:Label runat="server" ID="lblPersonName"></asp:Label>&nbsp;|&nbsp;DOB&nbsp;<asp:Label runat="server" ID="lblDOB"></asp:Label>
                    &nbsp;|&nbsp;Last Updated On:&nbsp;<asp:Label runat="server" ID="lblLastUpdated"></asp:Label><asp:Label runat="server" ID="lblisReportable" Text="&nbsp;|&nbsp;Reportable" Visible="false"></asp:Label>
                </h3>



                <p class="sectionHead PrintHide">
                    <span style="color: black;">ENROLLMENT ELIGIBILITY CRITERIA: Youth must have at least one (1) risk factor present in three (3) out of the ten (10) risk domains identified in this tool. 
                    <span style="margin-left: 5px; back-color: #43C6DB; background-color: #43C6DB; font-weight: bold; color: black;">Risk factors are identified below by an (*) asterisk.</span>
                </p>
            </div>

            <br />


            <%--            <div style="float:right">
                <asp:Panel ID="PanelActions" runat="server" CssClass="sidetoolbar">
                    <ul>
                        <li>
                            <auth:SecureContent ID="SecureContent10" ToggleVisible="true" ToggleEnabled="false"
                                EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
                                <a href="#" title="Create Certificate" id="CertificateLink" runat="server" class="createCertificate">
                                    <span>Print Form</span></a></auth:SecureContent>
                        </li>
                    </ul>
                </asp:Panel>
            </div>--%>
            <div style="clear: both"></div>
            <div class="row myenrollmentrace myenrollmentshortcontainer">
                <p class="checklabel">
                    <asp:Label ID="Label1" runat="server" Text="PAT Information:"
                        class="mylabel"></asp:Label>
                </p>
                <asp:RadioButtonList ID="rbisInitialPAT" runat="server" RepeatDirection="Horizontal">
                    <asp:ListItem Text="Initial PAT" Value="True"></asp:ListItem>
                    <asp:ListItem Text="Exit PAT" Value="False"></asp:ListItem>
                </asp:RadioButtonList>
                <asp:RequiredFieldValidator ID="rfvisInitialPAT" runat="server" SetFocusOnError="True"
                    ValidationGroup="Save" Display="Dynamic" ControlToValidate="rbisInitialPAT"
                    CssClass="ErrorMessage" ErrorMessage="Required." Enabled="True" Text="* Required" InitialValue=""></asp:RequiredFieldValidator>
            </div>



            <div class="EnrollmentFormContainer RiskAssessmentFormContainer">
                         
                <auth:SecureContent ID="SecureContent1" ToggleVisible="false" ToggleEnabled="true"
                    EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
                </auth:SecureContent>
                <asp:Label ID="PATCompletedDate" runat="server" Text="Date Completed&nbsp&nbsp&nbsp" Style="float: left"></asp:Label>
                <telerik:RadDatePicker ID="RadDatePickerPATCompletedDate" runat="server" DateInput-Width="50px"
                    Width="95px" DateInput-DisplayDateFormat="MM/dd/yy"
                    Calendar-ShowRowHeaders="False" Calendar-CssClass="myDatePickerPopup">
                    <%--CssClass="myDatePickerPopup myenrollmentdate">--%>
                </telerik:RadDatePicker>
                <asp:RequiredFieldValidator ID="reqValPATCompletedDate" runat="server" SetFocusOnError="true"
                    Display="Dynamic" ControlToValidate="RadDatePickerPATCompletedDate" ValidationGroup="Save"
                    CssClass="ErrorMessage" ErrorMessage="Completed Date is required" Text="* Required" Enabled="True" InitialValue=""></asp:RequiredFieldValidator>
                       <div>
                
                    <div style="width:50%; float:left">
                        <b>Created By: </b>&nbsp;<asp:Label runat="server" ID="lblcreatedby"></asp:Label>&nbsp;|&nbsp;
                        <b>Create Date:</b>&nbsp;<asp:Label runat="server" ID="lblcreateddate"></asp:Label>
                    </div>
                
                           
                
                    <div style="width:50%;float:right">
                    <b>Modified By:</b> &nbsp;<asp:Label runat="server" ID="lblmodifiedby"></asp:Label>&nbsp;|&nbsp;
                    <b>Modified Date:</b>&nbsp;<asp:Label runat="server" ID="lblmodifieddate"></asp:Label>
                        </div>
                <br />
                    </div>
                <asp:UpdatePanel runat="server">
                    <ContentTemplate>
                        <asp:TextBox runat="server" ID="txtComplete" Text="0" Visible="False"></asp:TextBox>

                        <div style="padding-bottom: 5px;">
                            <asp:Label runat="server" ID="lblErrors" Visible="False" ForeColor="Red" Font-Bold="True" Text="There are one or more questions not filled in. Tabs with missing answers are highlighted in red."></asp:Label><br />
                        </div>
                        <div style="float: left; width: 200px;">
                            <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server" HorizontalAlign="Center">
                                <img alt="" src="../App_Themes/Prodigy/Common/loading.gif" style="border: none; margin-top: 150px;" />
                            </telerik:RadAjaxLoadingPanel>
                            <telerik:RadTabStrip ID="sectionsTab" runat="server" SelectedIndex="0"
                                MultiPageID="MultiPageRiskAssessment" Orientation="VerticalLeft" CssClass="PATSections" OnTabClick="sectionsTab_TabClick">
                            </telerik:RadTabStrip>
                        </div>

                        <div style="float: left; width: 500px;">
                            <div style="padding-bottom: 5px;">
                                <asp:Label runat="server" ID="sectionHead" Font-Bold="True" Font-Size="12"></asp:Label>
                            </div>
                            <asp:PlaceHolder runat="server" ID="formPlaceHolder"></asp:PlaceHolder>
                        </div>

                        <div style="clear: both"></div>

                    </ContentTemplate>
                </asp:UpdatePanel>

            </div>
        </div>
    </div>
    </span>
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="EditButtonsPlaceholder" runat="server">
    <asp:Panel ID="PanelMainContentEditButtons" runat="server">
        <div class="editButtons">
            <asp:Button ID="PrintButton" runat="server" Text="Print" class="mybutton myprint"
                OnClick="PrintButton_Click" />
            <auth:SecureContent ID="SecureContent3" ToggleVisible="true" ToggleEnabled="false"
                EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
                <asp:Button ID="SaveButton" runat="server" Text="Save" ValidationGroup="Save" class="mybutton mysave"
                    OnClick="SaveButton_Click" />
                <asp:Button ID="CompleteButton" runat="server" Text="Complete" ValidationGroup="Save" class="mybutton mysave" Width="120"
                    OnClick="CompleteButton_Click" />
            </auth:SecureContent>
        </div>
    </asp:Panel>
</asp:Content>
