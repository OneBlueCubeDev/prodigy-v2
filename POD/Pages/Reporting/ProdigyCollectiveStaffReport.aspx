<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master" AutoEventWireup="true" CodeBehind="ProdigyCollectiveStaffReport.aspx.cs" Inherits="POD.Pages.Reporting.ProdigyCollectiveStaffReport" %>

<%@ Register TagPrefix="uc" TagName="ReportViewport" Src="~/UserControls/ReportViewport.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <div class="tabcontainer widetabcontainer">
        <div class="tabcontent">
            <div class="RunReportContainer ProdigyEnrollmentReport">
                <h2>Prodigy Collective Staff Report</h2>
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
                <telerik:RadComboBox ID="DropDownSites" runat="server" AppendDataBoundItems="True"
                    EnableEmbeddedSkins="false" SkinID="Prodigy" DataTextField="SiteName" DataValueField="LocationID"
                    CssClass="mydropdown">
                     
                </telerik:RadComboBox>
                <asp:Button ID="ButtonExecuteReport" runat="server" OnClick="ButtonExecuteReport_OnClick"
                    Text="Run Report" CssClass="mybutton myaddbutton" CausesValidation="True" ValidationGroup="ReportParameters"/>
            </div>
            <asp:ValidationSummary ID="ValidationSummary" runat="server" ValidationGroup="ReportParameters"
                DisplayMode="List" />
            <uc:ReportViewport ID="ReportViewport" runat="server" ReportName="ProdigyCollectiveStaffReport" />
        </div>
    </div>
</asp:Content>
