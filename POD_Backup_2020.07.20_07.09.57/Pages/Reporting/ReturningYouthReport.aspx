<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master" AutoEventWireup="true" CodeBehind="ReturningYouthReport.aspx.cs" Inherits="POD.Pages.Reporting.ReturningYouthReport" %>

<%@ Register TagPrefix="uc" TagName="ReportViewport" Src="~/UserControls/ReportViewport.ascx" %>
<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
        <div class="tabcontainer widetabcontainer">
        <div class="tabcontent">
            <div class="RunReportContainer ReturningYouthReport">
                <h2>
                    Returning Youth Report</h2>
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
                    CssClass="mydropdown SiteDropDownPadding">
                    <Items>
                        <telerik:RadComboBoxItem Text="All Sites" Value="" />
                    </Items>
                </telerik:RadComboBox>
                </auth:SecureContent>
                <asp:Label ID="LabelEnrollmentTypes" AssociatedControlID="DropDownEnrollmentTypes" runat="server">Service Category</asp:Label>
                <telerik:RadComboBox ID="DropDownEnrollmentTypes" runat="server" AppendDataBoundItems="True"
                    EnableEmbeddedSkins="false" SkinID="Prodigy" DataTextField="Name" DataValueField="EnrollmentTypeID"
                    CssClass="mydropdown">
                    <Items>
                        <telerik:RadComboBoxItem Text="All Categories" Value="" />
                    </Items>
                </telerik:RadComboBox>
                <asp:Button ID="ButtonExecuteReport" runat="server" OnClick="ButtonExecuteReport_OnClick"
                    Text="Run Report" CssClass="mybutton myaddbutton" CausesValidation="True" ValidationGroup="ReportParameters" />
            </div>
            <asp:ValidationSummary ID="ValidationSummary" runat="server" ValidationGroup="ReportParameters"
                DisplayMode="List" />
            <uc:ReportViewport ID="ReportViewport" runat="server" ReportName="ReturningYouthReport" />
        </div>
    </div>
</asp:Content>
