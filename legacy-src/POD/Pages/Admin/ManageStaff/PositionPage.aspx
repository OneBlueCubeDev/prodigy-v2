<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master"
    AutoEventWireup="true" CodeBehind="PositionPage.aspx.cs" Inherits="POD.Pages.Admin.ManageStaff.PositionPage" %>

<%@ Register Src="~/UserControls/StaffLinks.ascx" TagName="StaffLinks" TagPrefix="uc2" %>
<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
    <uc2:StaffLinks ID="StaffLinks1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <div class="tabcontainer widetabcontainer">
         <auth:SecureContent ID="SecureContent3" ToggleVisible="false" ToggleEnabled="true"
            EventHook="Load" runat="server" Roles="Administrators;">
        <div class="tabcontent">
            <h2 class="AdminHeader">
                Position Info</h2>
            <p>
                <asp:Literal ID="LiteralError" runat="server" Visible="False"></asp:Literal>
            </p>
            <div class="UserEntryFormWrapper AdminPositionForm">
                <div class="InputWrapper row">
                    <div class="FormLabel mylabel">
                        Job Title</div>
                    <asp:TextBox ID="TextBoxJobTitle" runat="server" Width="350px" class="myfield"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="TextBoxJobTitle"
                        InitialValue="" ErrorMessage="&nbsp;* Required" Display="Dynamic" ValidationGroup="Save"></asp:RequiredFieldValidator>
                </div>
                <div class="InputWrapper row">
                    <div class="FormLabel mylabel">
                        Location</div>
                    <telerik:RadComboBox ID="RadComboLocation" runat="server" EnableEmbeddedSkins="false"
                        SkinID="Prodigy" CssClass="mydropdown" AppendDataBoundItems="True" DataTextField="Name"
                        DataValueField="LocationID" DataSourceID="EntityLocationsDataSource">
                        <Items>
                            <telerik:RadComboBoxItem runat="server" Value="" Text="" />
                        </Items>
                    </telerik:RadComboBox>
                </div>
                <div class="InputWrapper row">
                    <div class="FormLabel mylabel">
                        Staff Member <i>(in position)</i></div>
                    <telerik:RadComboBox ID="RadComboPerson" runat="server" EnableEmbeddedSkins="false"
                        SkinID="Prodigy" CssClass="mydropdown" AppendDataBoundItems="True" DataTextField="FullName"
                        DataValueField="PersonID" DataSourceID="EntityPersonsDataSource">
                        <Items>
                            <telerik:RadComboBoxItem runat="server" Value="" Text="" />
                        </Items>
                    </telerik:RadComboBox>
                </div>
                <div class="InputWrapper row">
                    <div class="FormLabel mylabel">
                        Is Open?</div>
                    <asp:CheckBox ID="CheckBoxIsOpen" CssClass="checkBox" runat="server" /><br />
                </div>
                <div class="InputWrapper row">
                    <div class="FormLabel mylabel">
                        Vacancy Date</div>
                    <telerik:RadDatePicker ID="RadDatePickerVacancy" runat="server" DateInput-Width="50px"
                        Width="105px" DateInput-DisplayDateFormat="MM/dd/yyyy" Calendar-ShowRowHeaders="False"
                        Calendar-CssClass="myDatePickerPopup myenrollmentdate" CssClass="myDatePickerPopup">
                    </telerik:RadDatePicker>
                </div>
            </div>
        </div>
        </auth:SecureContent>
    </div>
    <asp:Panel ID="PanelMainContentEditButtons" runat="server">
        <div class="editButtons">
            <asp:Button ID="ButtonCancel" runat="server" CausesValidation="false" PostBackUrl="PositionManagement.aspx"
                Text="Done" class="mybutton mycancel" /> <auth:SecureContent ID="SecureContent1" ToggleVisible="true" ToggleEnabled="false"
            EventHook="Load" runat="server" Roles="Administrators;">
            <asp:Button ID="ButtonSave" runat="server" ValidationGroup="Save" Text="Save" OnClick="ButtonSave_OnClick"
                CssClass="mybutton mysave" /></auth:SecureContent>
        </div>
    </asp:Panel>
    <asp:Label ID="LabelFeedback" runat="server" Text="" ForeColor="#FF3300"></asp:Label>
    <asp:EntityDataSource ID="EntityLocationsDataSource" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" EnableFlattening="False" EntitySetName="Locations"
        Where="it.StatusType.Name == &quot;Active&quot;">
    </asp:EntityDataSource>
    <asp:EntityDataSource ID="EntityPersonsDataSource" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" EnableFlattening="False" EntitySetName="Persons"
        EntityTypeFilter="StaffMember">
    </asp:EntityDataSource>
</asp:Content>
