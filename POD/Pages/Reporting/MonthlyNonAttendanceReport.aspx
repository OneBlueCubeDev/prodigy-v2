<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master" AutoEventWireup="true" CodeBehind="MonthlyNonAttendanceReport.aspx.cs" Inherits="POD.Pages.Reporting.MonthlyNonAttendanceReport" %>
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
                <h2>Monthly Non-Attendance Report</h2>
                <auth:SecureContent ID="secureFilterSite" ToggleVisible="False" ToggleEnabled="True" EventHook="Load" runat="server" Roles="Administrators,Administrators-NA,CentralTeamUsers,CentralTeamUsers-NA"
                    OnAuthorizationFailed="secureFilterSite_OnAuthorizationFailed" OnAuthorizationPassed="secureFilterSite_OnAuthorizationPassed">
                <asp:Label ID="LabelDropDownSites" AssociatedControlID="DropDownSites" runat="server">Site</asp:Label>
                <telerik:RadComboBox ID="DropDownSites" runat="server" AppendDataBoundItems="True"
                    EnableEmbeddedSkins="false" SkinID="Prodigy" DataTextField="SiteName" DataValueField="LocationID"
                    CssClass="mydropdown">
                    <Items>
                        <telerik:RadComboBoxItem Text="All Sites" Value="%" />       
                    </Items>
                </telerik:RadComboBox>
                </auth:SecureContent>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Label ID="LabelDropDownDays" AssociatedControlID="DropDownDays" runat="server">Days since last attendance</asp:Label>
                <telerik:RadComboBox ID="DropDownDays" runat="server" AppendDataBoundItems="True"
                    EnableEmbeddedSkins="False" SkinID="Prodigy" CssClass="mydropdown">
                    <Items>
                        <telerik:RadComboBoxItem Text="15+" Value="15" />
                        <telerik:RadComboBoxItem Text="30+" Value="30" />
                        <telerik:RadComboBoxItem Text="45+" Value="45" />
                        <telerik:RadComboBoxItem Text="60+" Value="60" />
                        <telerik:RadComboBoxItem Text="75+" Value="75" />
                        <telerik:RadComboBoxItem Text="90+" Value="90" />
                    </Items>
                </telerik:RadComboBox>
                <asp:RequiredFieldValidator ID="SiteValidator" runat="server" ControlToValidate="DropDownSites"
                    Display="None" ErrorMessage="You must pick a site to run the report." CssClass="ValidationClass"
                    ValidationGroup="ReportParameters">
                </asp:RequiredFieldValidator>
                <asp:Button ID="ButtonExecuteReport" runat="server" OnClick="ButtonExecuteReport_OnClick"
                    Text="Run Report" CssClass="mybutton myaddbutton" CausesValidation="True" ValidationGroup="ReportParameters" />
            </div>
            <asp:ValidationSummary ID="ValidationSummary" runat="server" ValidationGroup="ReportParameters"
                DisplayMode="List" />
            <uc:ReportViewport ID="ReportViewport" runat="server" ReportName="MonthlyNonAttendanceReport" />
        </div>
        <telerik:RadAjaxManagerProxy ID="RadAjaxManagerProxy1" runat="server">
            <AjaxSettings>
                <telerik:AjaxSetting AjaxControlID="DropDownSites">
                    <UpdatedControls>
                        <telerik:AjaxUpdatedControl ControlID="DropDownCourseInstances" />
                    </UpdatedControls>
                </telerik:AjaxSetting>
                <telerik:AjaxSetting AjaxControlID="DatePickerTargetDate">
                    <UpdatedControls>
                        <telerik:AjaxUpdatedControl ControlID="DropDownCourseInstances" />
                    </UpdatedControls>
                </telerik:AjaxSetting>
            </AjaxSettings>
        </telerik:RadAjaxManagerProxy>
    </div>
</asp:Content>
