<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master"
    AutoEventWireup="true" CodeBehind="EnrollmentNotesReport.aspx.cs" Inherits="POD.Pages.Reporting.EnrollmentNotesReport" %>

<%@ Register TagPrefix="uc" TagName="ReportViewport" Src="~/UserControls/ReportViewport.ascx" %>
<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <div class="tabcontainer widetabcontainer">
        <div class="tabcontent">
            <div class="RunReportContainer">
                <h2>
                    Enrollment Notes Report</h2>
                <div class="myreporttargetdatecontainer">
                    <asp:Label ID="LabelTargetDate" AssociatedControlID="DatePickerStartDate" runat="server">Start Date</asp:Label>
                    <telerik:RadDatePicker ID="DatePickerStartDate" runat="server" Width="52%"
                        Calendar-ShowRowHeaders="False" Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup"
                        OnSelectedDateChanged="DatePickerStartDate_OnSelectedDateChanged" AutoPostBack="True"
                        OnLoad="DatePickerStartDate_OnLoad">
                    </telerik:RadDatePicker>
                </div>

                <div class="myreporttargetdatecontainer">
                    <asp:Label ID="Label1" AssociatedControlID="DatePickerEndDate" runat="server">End Date</asp:Label>
                    <telerik:RadDatePicker ID="DatePickerEndDate" runat="server" Width="52%"
                        Calendar-ShowRowHeaders="False" Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup"
                        OnSelectedDateChanged="DatePickerEndDate_OnSelectedDateChanged" AutoPostBack="True"
                       >
                    </telerik:RadDatePicker>
                </div>
                
                <auth:SecureContent ID="secureFilterSite" ToggleVisible="False" ToggleEnabled="True" EventHook="Load" runat="server" Roles="Administrators,Administrators-NA,CentralTeamUsers,CentralTeamUsers-NA"
                    OnAuthorizationFailed="secureFilterSite_OnAuthorizationFailed" OnAuthorizationPassed="secureFilterSite_OnAuthorizationPassed">
                <asp:Label ID="LabelDropDownSites" AssociatedControlID="DropDownSites" runat="server">Site</asp:Label>
                <telerik:RadComboBox ID="DropDownSites" runat="server" AppendDataBoundItems="True"
                    EnableEmbeddedSkins="false" SkinID="Prodigy" DataTextField="SiteName" DataValueField="LocationID"
                    CssClass="mydropdown" OnSelectedIndexChanged="DropDownSites_OnSelectedIndexChanged" AutoPostBack="True">
                    <Items>
                        <telerik:RadComboBoxItem Text="" Value="" />                        
                    </Items>
                </telerik:RadComboBox>
                </auth:SecureContent>

                <asp:RequiredFieldValidator ID="SiteValidator" runat="server" ControlToValidate="DropDownSites"
                    Display="None" ErrorMessage="You must pick a site to run the report." CssClass="ValidationClass"
                    ValidationGroup="ReportParameters">
                </asp:RequiredFieldValidator>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Button ID="ButtonExecuteReport" runat="server" OnClick="ButtonExecuteReport_OnClick"
                    Text="Run Report" CssClass="mybutton myaddbutton" CausesValidation="True" ValidationGroup="ReportParameters" />
            </div>
            <asp:ValidationSummary ID="ValidationSummary" runat="server" ValidationGroup="ReportParameters"
                DisplayMode="List" />
            <div class="BulkEditWrapper BulkDataReport">
                <div class="BulkEditContentWrapper">
                    <uc:ReportViewport ID="ReportViewport" runat="server" ReportName="EnrollmentNotesReport" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
