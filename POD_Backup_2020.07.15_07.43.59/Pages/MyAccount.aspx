<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master"
    AutoEventWireup="true" CodeBehind="MyAccount.aspx.cs" Inherits="POD.Pages.MyAccount" %>

<%@ Register Src="~/UserControls/AddEditAddress.ascx" TagName="AddEditAddress" TagPrefix="uc1" %>
<%@ Register Src="~/UserControls/AddEditPhoneNumber.ascx" TagName="AddEditPhoneNumber"
    TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <div class="tabcontainer widetabcontainer">
        <div class="tabcontent MyAccountContainer">
            <h2>
                My Account Information</h2>
            <div class="UserEntryFormWrapper AdminStaffMemberForm">
                <div class="row">
                    <h3 class="sectionHead">
                        Login Information:</h3>
                </div>
                <div class="row">
                    <asp:Label ID="Label1" runat="server" Text="Username" class="mylabel"></asp:Label>
                    <asp:TextBox ID="TextBoxUserName" runat="server" class="myfield"></asp:TextBox>
                    <asp:HiddenField ID="HiddenOriginal" runat="server" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" SetFocusOnError="true"
                        Display="Dynamic" ControlToValidate="TextBoxUserName" ValidationGroup="Save"
                        CssClass="ErrorMessage" ErrorMessage="UserName is required." Text="*"></asp:RequiredFieldValidator>
                    <asp:CustomValidator ID="CustomValidatorUserName" runat="server" SetFocusOnError="true"
                        Display="Dynamic" ControlToValidate="TextBoxUserName" ValidationGroup="Save"
                        OnServerValidate="CustomValidatorUserName_ServerValidate" CssClass="ErrorMessage"
                        ErrorMessage="UserName is already taken." Text="*"></asp:CustomValidator>
                </div>
                <div class="row">
                    <asp:Label ID="Label2" runat="server" Text="Password" class="mylabel"></asp:Label><asp:TextBox
                        ID="TextBoxPassword" runat="server" class="myfield"></asp:TextBox>
                    <asp:HiddenField ID="HiddenFieldPassword" runat="server" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" SetFocusOnError="true"
                        Display="Dynamic" ControlToValidate="TextBoxPassword" ValidationGroup="Save"
                        CssClass="ErrorMessage" ErrorMessage="Password is required." Text="*"></asp:RequiredFieldValidator>
                </div>
                <div class="row">
                    <asp:Label ID="Label3" runat="server" Text="Email" class="mylabel"></asp:Label><asp:TextBox
                        ID="TextBoxEmail" runat="server" class="myfield"></asp:TextBox>
                    <asp:HiddenField ID="HiddenFieldEmail" runat="server" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" SetFocusOnError="true"
                        Display="Dynamic" ControlToValidate="TextBoxEmail" ValidationGroup="Save" CssClass="ErrorMessage"
                        ErrorMessage="Email is required." Text="*"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidatorEmailTextBox" runat="server"
                        ControlToValidate="TextBoxEmail" Display="Dynamic" CssClass="ErrorMessage" ValidationGroup="Save"
                        ErrorMessage="Email address is not valid" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                    <asp:CustomValidator ID="CustomValidatorEmailUnique" runat="server" SetFocusOnError="true"
                        Display="Dynamic" ControlToValidate="TextBoxEmail" ValidationGroup="Save" OnServerValidate="CustomValidatorEmailUnique_ServerValidate"
                        CssClass="ErrorMessage" ErrorMessage="Email is already taken." Text="*"></asp:CustomValidator>
                    <br />
                </div>
                <span class="sectionDivider"></span>
                <div class="row">
                    <asp:Label ID="LabelTitle" runat="server" Text="Title" CssClass="mylabel"></asp:Label>
                    <asp:TextBox ID="TextboxTitle" runat="server" CssClass="myfield"></asp:TextBox>
                </div>
                <div class="row">
                    <asp:Label ID="LabelSalutation" runat="server" Text="Salutation" CssClass="mylabel"></asp:Label>
                    <asp:TextBox ID="TextboxSalutation" runat="server" CssClass="myfield"></asp:TextBox>
                </div>
                <div class="row">
                    <asp:Label ID="LabelCompany" runat="server" Text="Organization" CssClass="mylabel"></asp:Label>
                    <asp:TextBox ID="TextboxCompany" runat="server" CssClass="myfield"></asp:TextBox>
                </div>
                <div class="row myenrollmentlastname">
                    <asp:Label ID="LabelLastName" runat="server" Text="Last Name" CssClass="mylabel"></asp:Label>
                    <asp:TextBox ID="TextboxLastName" runat="server" CssClass="myfield"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="ReqValFirstNamePart" runat="server" SetFocusOnError="true"
                        Display="Dynamic" ControlToValidate="TextboxLastName" ValidationGroup="Save"
                        CssClass="ErrorMessage" ErrorMessage="Last Name is required." Text="*"></asp:RequiredFieldValidator>
                </div>
                <div class="row">
                    <div class="myenrollmentfirstname">
                        <asp:Label ID="LabelFirstName" runat="server" Text="First Name" CssClass="mylabel"></asp:Label>
                        <asp:TextBox ID="TextboxFirstName" runat="server" CssClass="myfield"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="ReqValLastNamePart" runat="server" SetFocusOnError="true"
                            ValidationGroup="Save" Display="Dynamic" ControlToValidate="TextboxFirstName"
                            CssClass="ErrorMessage" ErrorMessage="First Name is required." Text="*"></asp:RequiredFieldValidator></div>
                    <div class="myenrollmentMI">
                        <asp:Label ID="LabelMI" runat="server" Text="MI" CssClass="mylabel"></asp:Label>
                        <asp:TextBox ID="TextboxMiddle" runat="server" CssClass="myfield"></asp:TextBox>
                    </div>
                </div>
                <div class="row myenrollmentdobcontainer">
                    <asp:Label ID="LabelDOB" runat="server" Text="DOB" CssClass="mylabel"></asp:Label>
                    <telerik:RadDatePicker ID="RadDatePickerDOB" runat="server" DateInput-Width="50px"
                        Width="42%" DateInput-DisplayDateFormat="MM/dd/yy" MinDate="1/1/1900" Calendar-ShowRowHeaders="False"
                        Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup myenrollmentdob">
                    </telerik:RadDatePicker>
                    <asp:RequiredFieldValidator ID="ReqValDOBPart" runat="server" SetFocusOnError="true"
                        ValidationGroup="Save" Display="Dynamic" ControlToValidate="RadDatePickerDOB"
                        CssClass="ErrorMessage" ErrorMessage="Date of Birth is required." Text="*"></asp:RequiredFieldValidator>
                </div>
                <div class="row">
                    <asp:Label ID="EnrollmentGender" runat="server" Text="Gender:" CssClass="mylabel"></asp:Label>
                    <telerik:RadFormDecorator ID="RadFormDecorator3" runat="server" />
                    <asp:RadioButtonList ID="RadioListGender" runat="server" DataTextField="Name" DataValueField="GenderID"
                        CssClass="myUserActive" RepeatLayout="Table" RepeatDirection="Horizontal">
                    </asp:RadioButtonList>
                </div>
                <div class="row" style="display: none;">
                    <asp:Label ID="LabelLocation" runat="server" Text="Location" CssClass="mylabel"></asp:Label>
                    <telerik:RadComboBox ID="RadComboBoxLocation" DataSourceID="DataSourceLocations"
                        DataValueField="LocationID" DataTextField="Name" EmptyMessage="Select Location"
                        runat="server" EnableEmbeddedSkins="false" SkinID="Prodigy" CssClass="mydropdown">
                    </telerik:RadComboBox>
                </div>
                <span class="sectionDivider"></span>
                <uc1:AddEditAddress ID="ParticipantAddress" runat="server" />
                <span class="sectionDivider"></span>
                <div class="row">
                    <div class="myenrollmenthomephone">
                        <uc2:AddEditPhoneNumber ID="HomePhone" runat="server" />
                    </div>
                </div>
                <div class="row">
                    <div class="myenrollmenthomephone">
                        <uc2:AddEditPhoneNumber ID="WorkPhone" runat="server" />
                    </div>
                </div>
                <div class="row">
                    <div class="myenrollmenthomephone">
                        <uc2:AddEditPhoneNumber ID="CellPhone" runat="server" />
                    </div>
                </div>
            </div>
            <asp:EntityDataSource ID="DataSourceLocations" runat="server" ConnectionString="name=PODContext"
              DefaultContainerName="PODContext"  EnableFlattening="False" EntitySetName="Locations"
                OrderBy="it.[Name]">
            </asp:EntityDataSource>
        </div>
    </div>
    <asp:Panel ID="PanelMainContentEditButtons" runat="server">
        <div class="editButtons">
            <asp:Label ID="LabelFeedback" runat="server" Text="" ForeColor="#FF3300"></asp:Label>
            <asp:Button ID="ButtonCreateUser" runat="server" ValidationGroup="Save" Text="Save"
                OnClick="ButtonCreateUser_Click" CssClass="mybutton mysave" />
        </div>
    </asp:Panel>
</asp:Content>
