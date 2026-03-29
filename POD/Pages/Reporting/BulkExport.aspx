<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master"
    AutoEventWireup="true" CodeBehind="BulkExport.aspx.cs" Inherits="POD.Pages.Reporting.BulkExport" %>

<%@ Register TagPrefix="uc" TagName="ReportViewport" Src="~/UserControls/ReportViewport.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <div class="tabcontainer widetabcontainer">
        <div class="tabcontent">
            <div class="RunReportContainer">
                <h2>
                    Bulk Data Export</h2>
                <asp:Label ID="LabelReports" AssociatedControlID="DropDownReports" runat="server">Report</asp:Label>
                <telerik:RadComboBox ID="DropDownReports" runat="server" EnableEmbeddedSkins="false"
                    SkinID="Prodigy" CssClass="mydropdown">
                    <Items>
                        <telerik:RadComboBoxItem Value="" Text="" />
                        <telerik:RadComboBoxItem Text="User Logins" Value="BulkUserRecordsReport" />
                        <telerik:RadComboBoxItem Text="Staff Records" Value="BulkStaffRecordsReport" />
                        <telerik:RadComboBoxItem Text="Youth Records" Value="BulkYouthRecordsReport" />
                        <telerik:RadComboBoxItem Text="Classes" Value="BulkClassRecordsReport" />
                        <telerik:RadComboBoxItem Text="Events" Value="BulkEventRecordsReport" />
                        <telerik:RadComboBoxItem Text="Locations" Value="BulkLocationRecordsReport" />
                        <telerik:RadComboBoxItem Text="Sites" Value="BulkSiteRecordsReport" />
                        <telerik:RadComboBoxItem Text="Risk Assessments" Value="BulkRiskAssessmentFormsReport" />
                        <telerik:RadComboBoxItem Text="Enrollments" Value="BulkEnrollmentFormsReport" />
                        <telerik:RadComboBoxItem Text="Inventory" Value="BulkInventoryRecordsReport" />
                        <telerik:RadComboBoxItem Text="Lesson Plan Sets" Value="BulkLessonPlanSetsRecordsReport" />
                    </Items>
                </telerik:RadComboBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="DropDownReports"
                    Display="None" ErrorMessage="You must select a report to export data." CssClass="ValidationClass"
                    ValidationGroup="ReportParameters">
                </asp:RequiredFieldValidator>
                <asp:Button ID="ButtonExecuteReport" runat="server" OnClick="ButtonExecuteReport_OnClick"
                    Text="Run Report" CssClass="mybutton myaddbutton" CausesValidation="True" ValidationGroup="ReportParameters" />
            </div>
            <asp:ValidationSummary ID="ValidationSummary" runat="server" ValidationGroup="ReportParameters"
                DisplayMode="List" />
            <div class="BulkEditWrapper BulkDataReport">
                <div class="BulkEditContentWrapper">
                    <uc:ReportViewport ID="ReportViewport" runat="server" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
