<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master" AutoEventWireup="true" CodeBehind="ProdigyStaffReport.aspx.cs" Inherits="POD.Pages.Reporting.ProdigyStaffReport" %>

<%@ Register TagPrefix="uc" TagName="ReportViewport" Src="~/UserControls/ReportViewport.ascx" %>
<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <telerik:RadAjaxManager ID="ajaxManager" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="DropDownSites">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="DropDownLocation"/>
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>
    <div class="tabcontainer widetabcontainer">
        <div class="tabcontent">
            <div class="RunReportContainer ProdigyEnrollmentReport">
                <h2>Prodigy Staff Report</h2>
                <div class="myreporttargetdatecontainer">
                    <asp:Label ID="LabelFromDate" AssociatedControlID="DatePickerFromDate" runat="server">Start Date</asp:Label>
                    <telerik:RadDatePicker ID="DatePickerFromDate" runat="server" DateInput-DisplayDateFormat="MM/dd/yyyy"
                        DateInput-Width="50px" Width="44%" Calendar-ShowRowHeaders="False" Calendar-CssClass="myDatePickerPopup"
                        CssClass="myDatePickerPopup" OnLoad="DatePicker_OnLoad">
                    </telerik:RadDatePicker>
                    <asp:RequiredFieldValidator ID="FromDateValidator" runat="server" ControlToValidate="DatePickerFromDate"
                        Display="None" ErrorMessage="You must pick a start date to run the report." CssClass="ValidationClass"
                        ValidationGroup="ReportParameters">
                    </asp:RequiredFieldValidator>
                </div>
                <div class="myreporttargetdatecontainer">
                    <asp:Label ID="LabelToDate" AssociatedControlID="DatePickerToDate" runat="server">End Date</asp:Label>
                    <telerik:RadDatePicker ID="DatePickerToDate" runat="server" DateInput-DisplayDateFormat="MM/dd/yyyy"
                        DateInput-Width="50px" Width="44%" Calendar-ShowRowHeaders="False" Calendar-CssClass="myDatePickerPopup"
                        CssClass="myDatePickerPopup" OnLoad="DatePicker_OnLoad">
                    </telerik:RadDatePicker>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="DatePickerToDate"
                        Display="None" ErrorMessage="You must pick an end date to run the report." CssClass="ValidationClass"
                        ValidationGroup="ReportParameters">
                    </asp:RequiredFieldValidator>
                </div>
                <asp:CompareValidator ID="DateRangeCompareValidator" runat="server" ControlToCompare="DatePickerFromDate"
                    ControlToValidate="DatePickerToDate" Type="Date" Operator="GreaterThanEqual"
                    ErrorMessage="The end date must be greater than the start date to run the report."
                    Display="None" ValidationGroup="ReportParameters">
                </asp:CompareValidator>
                <asp:Label ID="LabelDropDownSites" AssociatedControlID="DropDownSites" runat="server">Site</asp:Label>
                <auth:SecureContent ID="secureFilterSite" ToggleVisible="False" ToggleEnabled="True" EventHook="Load" runat="server" Roles="Administrators,Administrators-NA,CentralTeamUsers,CentralTeamUsers-NA"
                    OnAuthorizationFailed="secureFilterSite_OnAuthorizationFailed" OnAuthorizationPassed="secureFilterSite_OnAuthorizationPassed">
                <telerik:RadComboBox ID="DropDownSites" runat="server" AppendDataBoundItems="True"
                    EnableEmbeddedSkins="false" SkinID="Prodigy" DataTextField="SiteName" DataValueField="LocationID"
                    CssClass="mydropdown" AutoPostBack="True" OnSelectedIndexChanged="DropDownSites_OnSelectedIndexChanged">
                </telerik:RadComboBox>
                </auth:SecureContent>
                <div class="ReportingLocationFieldSet">
                    <asp:Label ID="LabelDropDownLocation" AssociatedControlID="DropDownLocation" runat="server">Location</asp:Label>
                    <telerik:RadComboBox ID="DropDownLocation" runat="server" AppendDataBoundItems="False"
                        EnableEmbeddedSkins="False" SkinID="Prodigy" DataTextField="Name" DataValueField="LocationID"
                        CssClass="mydropdown">
                    </telerik:RadComboBox>
                     <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="DropDownLocation"
                        Display="None" ErrorMessage="You must pick a location" CssClass="ValidationClass"
                        ValidationGroup="ReportParameters">
                    </asp:RequiredFieldValidator>
                </div>
                <asp:Button ID="ButtonExecuteReport" runat="server" OnClick="ButtonExecuteReport_OnClick"
                    Text="Run Report" CssClass="mybutton myaddbutton" CausesValidation="True" ValidationGroup="ReportParameters"/>
            </div>
            <asp:ValidationSummary ID="ValidationSummary" runat="server" ValidationGroup="ReportParameters"
                DisplayMode="List" />
            <uc:ReportViewport ID="ReportViewport" runat="server" ReportName="ProdigyStaffReport" />
        </div>
    </div>
</asp:Content>
