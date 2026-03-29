<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master" AutoEventWireup="true" CodeBehind="ProdigyEnrollmentReport.aspx.cs" Inherits="POD.Pages.Reporting.ProdigyEnrollmentReport" %>

<%@ Register TagPrefix="uc" TagName="ReportViewport" Src="../../UserControls/ReportViewport.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <div class="tabcontainer widetabcontainer">
        <div class="tabcontent">
            <div class="RunReportContainer ProdigyEnrollmentReport">
                <h2>Performance Enrollment Report</h2>
                <div class="myreporttargetdatecontainer">
                    <asp:Label ID="LabelTargetDate" AssociatedControlID="DatePickerTargetDate" runat="server">Month</asp:Label>
                    <telerik:RadMonthYearPicker ID="DatePickerTargetDate" runat="server" Width="52%"
                        Calendar-ShowRowHeaders="False" Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup"
                        OnLoad="DatePicker_OnLoad">
                    </telerik:RadMonthYearPicker>
                </div>
                <asp:Button ID="ButtonExecuteReport" runat="server" OnClick="ButtonExecuteReport_OnClick"
                    Text="Run Report" CssClass="mybutton myaddbutton" CausesValidation="True" ValidationGroup="ReportParameters"/>
            </div>
            <asp:ValidationSummary ID="ValidationSummary" runat="server" ValidationGroup="ReportParameters"
                DisplayMode="List" />
            <uc:ReportViewport ID="ReportViewport" runat="server" ReportName="ProdigyEnrollmentReport" />
        </div>
    </div>    
</asp:Content>
