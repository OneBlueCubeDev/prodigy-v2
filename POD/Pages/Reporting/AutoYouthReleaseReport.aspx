<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master"
    AutoEventWireup="true" CodeBehind="AutoYouthReleaseReport.aspx.cs" Inherits="POD.Pages.Reporting.AutoYouthReleaseReport" %>

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
                    Released Youth Report</h2>
<div class="myreporttargetdatecontainer">
                    <asp:Label ID="LabelTargetDate" AssociatedControlID="DatePickerTargetDate" runat="server">Month</asp:Label>
                    <telerik:RadDatePicker ID="DatePickerTargetDate" runat="server" Width="52%"
                        Calendar-ShowRowHeaders="False" Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup"
                        >
                    </telerik:RadDatePicker>
                </div>
                <asp:Label ID="Label12" runat="server" Text="Youth Type" class="sidelabel mylabel"
                AssociatedControlID="RadcbYouthtype"></asp:Label>
            <telerik:RadComboBox ID="RadcbYouthtype" AutoPostBack="true" OnSelectedIndexChanged="RadcbYouthtype_SelectedIndexChanged"
             DataValueField="Key" DataTextField="Value"
                 runat="server" CssClass="mydropdown"
                Height="100%" Width="142px">
               
            </telerik:RadComboBox>

                <asp:Label ID="LabelDropDownSites" AssociatedControlID="DropDownSites" runat="server">Site</asp:Label>
                <auth:SecureContent ID="secureFilterSite" ToggleVisible="False" ToggleEnabled="True" EventHook="Load" runat="server" Roles="Administrators,Administrators-NA,CentralTeamUsers,CentralTeamUsers-NA"
                    OnAuthorizationFailed="secureFilterSite_OnAuthorizationFailed" OnAuthorizationPassed="secureFilterSite_OnAuthorizationPassed">
                <telerik:RadComboBox ID="DropDownSites" runat="server" AppendDataBoundItems="True"
                    EnableEmbeddedSkins="false" SkinID="Prodigy" DataTextField="SiteName" DataValueField="LocationID"
                    CssClass="mydropdown">
                    <Items>
                        <telerik:RadComboBoxItem Text="All Sites" Value="" />
                    </Items>
                </telerik:RadComboBox>
                </auth:SecureContent>
                <asp:Button ID="ButtonExecuteReport" runat="server" OnClick="ButtonExecuteReport_OnClick"
                    Text="Run Report" CssClass="mybutton myaddbutton" CausesValidation="True" ValidationGroup="ReportParameters" />
            </div>
            <asp:ValidationSummary ID="ValidationSummary" runat="server" ValidationGroup="ReportParameters"
                DisplayMode="List" />
            <uc:ReportViewport ID="ReportViewport" runat="server" ReportName="ReleasedYouthReport" />
        </div>
    </div>
</asp:Content>
