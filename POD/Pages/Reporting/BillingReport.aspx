<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master"
    AutoEventWireup="true" CodeBehind="BillingReport.aspx.cs" Inherits="POD.Pages.Reporting.CensusReport" %>

<%@ Register TagPrefix="uc" TagName="ReportViewport" Src="../../UserControls/ReportViewport.ascx" %>
<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <div class="tabcontainer  widetabcontainer ReportingCensusContainer" > 
        <div class="tabcontent">
            <div class="RunReportContainer">
                <h2>
                    Census Report</h2>
                <div class="myreporttargetdatecontainer">
                    <asp:Label ID="LabelTargetDate" AssociatedControlID="DatePickerTargetDate" runat="server">Month</asp:Label>
                    <telerik:RadMonthYearPicker ID="DatePickerTargetDate" runat="server" Width="52%"
                        Calendar-ShowRowHeaders="False" Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup"
                        OnLoad="DatePickerTargetDate_OnLoad">
                    </telerik:RadMonthYearPicker>
<%--                    <script language ="text/javascript">
                        $("DatePickerTargetDate").set_mindate
                    </script>--%>
                    <asp:RequiredFieldValidator ID="TargetDateValidator" runat="server" ControlToValidate="DatePickerTargetDate"
                        Display="None" ErrorMessage="You must pick a month and year to run the report."
                        CssClass="ValidationClass" ValidationGroup="ReportParameters">
                    </asp:RequiredFieldValidator>
                </div>
                <asp:Label ID="LabelDropDownSites" AssociatedControlID="DropDownSites" runat="server">Site</asp:Label>
                <auth:SecureContent ID="secureFilterSite" ToggleVisible="False" ToggleEnabled="True" EventHook="PreRender" runat="server" Roles="Administrators,Administrators-NA,CentralTeamUsers,CentralTeamUsers-NA"
                    OnAuthorizationFailed="secureFilterSite_OnAuthorizationFailed">
                    <telerik:RadComboBox ID="DropDownSites" runat="server" AppendDataBoundItems="True"
                        EnableEmbeddedSkins="false" SkinID="Prodigy" DataTextField="SiteName" DataValueField="LocationID"
                        CssClass="mydropdown">
                        <Items>
                            <telerik:RadComboBoxItem Text="All Sites" Value="" />
                        </Items>
                    </telerik:RadComboBox>
                </auth:SecureContent>
                <asp:Button ID="ButtonExecuteReport" runat="server" OnClick="ButtonExecuteReport_OnClick"
                    Text="Run Report" CssClass="mybutton myaddbutton" CausesValidation="True" ValidationGroup="ReportParameters"/>
            </div>
            <asp:ValidationSummary ID="ValidationSummary" runat="server" ValidationGroup="ReportParameters"
                DisplayMode="List" />
            <uc:ReportViewport ID="ReportViewport" runat="server" ReportName="BillingReport" />
        </div>
    </div>
</asp:Content>
