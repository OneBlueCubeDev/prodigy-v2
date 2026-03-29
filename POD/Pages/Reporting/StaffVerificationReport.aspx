<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master" AutoEventWireup="true" CodeBehind="StaffVerificationReport.aspx.cs" Inherits="POD.Pages.Reporting.StaffVerificationReport" %>

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
                <h2>Staff Verification Report</h2>
                <asp:Label ID="LabelDropDownSites" AssociatedControlID="DropDownSites" runat="server">Site</asp:Label>
                <auth:SecureContent ID="secureFilterSite" ToggleVisible="False" ToggleEnabled="True" EventHook="Load" runat="server" Roles="Administrators,Administrators-NA,CentralTeamUsers,CentralTeamUsers-NA"
                    OnAuthorizationFailed="secureFilterSite_OnAuthorizationFailed" OnAuthorizationPassed="secureFilterSite_OnAuthorizationPassed">
                <telerik:RadComboBox ID="DropDownSites" runat="server" AppendDataBoundItems="True" DataTextField="SiteName" DataValueField="LocationID"
                    EnableEmbeddedSkins="false" SkinID="Prodigy" CssClass="mydropdown">
                    <Items>
                        <telerik:RadComboBoxItem Text="All Organizations" Value="" />
                    </Items>
                </telerik:RadComboBox>
                </auth:SecureContent>
                <asp:Button ID="ButtonExecuteReport" runat="server" OnClick="ButtonExecuteReport_OnClick"
                    Text="Run Report" CssClass="mybutton myaddbutton" CausesValidation="True" ValidationGroup="ReportParameters" />
            </div>
            <asp:ValidationSummary ID="ValidationSummary" runat="server" ValidationGroup="ReportParameters"
                DisplayMode="List" />
            <uc:ReportViewport ID="ReportViewport" runat="server" ReportName="StaffVerificationReport" />
        </div>
    </div>        
</asp:Content>
