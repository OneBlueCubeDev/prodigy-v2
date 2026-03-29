<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master"
    AutoEventWireup="true" CodeBehind="BulkEnrollmentExport.aspx.cs" Inherits="POD.Pages.Reporting.BulkEnrollmentExport" %>

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
                    Bulk Enrollment Export</h2>
                <%--<asp:Label ID="LabelReports" AssociatedControlID="DropDownReports" runat="server">Report</asp:Label>
                <telerik:RadComboBox ID="DropDownReports" runat="server" EnableEmbeddedSkins="false"
                    SkinID="Prodigy" CssClass="mydropdown">
                    <Items>
                        <telerik:RadComboBoxItem Value="" Text="" />
                        <telerik:RadComboBoxItem Text="Enrollments" Value="BulkEnrollmentFormsReport" />
                    </Items>
                </telerik:RadComboBox>--%>
                <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="DropDownReports"
                    Display="None" ErrorMessage="You must select a report to export data." CssClass="ValidationClass"
                    ValidationGroup="ReportParameters">
                </asp:RequiredFieldValidator>--%>
                                <asp:Label ID="Label12" runat="server" Text="Youth Type" class="sidelabel mylabel"
                AssociatedControlID="RadcbYouthtype"></asp:Label>
            <telerik:RadComboBox ID="RadcbYouthtype" AutoPostBack="true" OnSelectedIndexChanged="RadcbYouthtype_SelectedIndexChanged"
             DataValueField="Key" DataTextField="Value"
                 runat="server" CssClass="mydropdown"
                Height="100%" Width="142px">
               
            </telerik:RadComboBox>
                 <asp:Label ID="Label2" runat="server" Text="Grant Year" 
                    AssociatedControlID="RadComboBoxGrantYear"></asp:Label>
                <telerik:RadComboBox ID="RadComboBoxGrantYear"
                    DataValueField="Key" DataTextField="Value"
                    runat="server" CssClass="mydropdown"
                    Height="100%" Width="142px">
               
            </telerik:RadComboBox>
                <asp:Label ID="LabelDropDownSites" AssociatedControlID="DropDownSites" runat="server">Site</asp:Label>
                
                    <telerik:RadComboBox ID="DropDownSites" runat="server" AppendDataBoundItems="True"
                        EnableEmbeddedSkins="false" SkinID="Prodigy" DataTextField="SiteName" DataValueField="LocationID"
                        CssClass="mydropdown">
                        <Items>
                            <telerik:RadComboBoxItem Text="All Sites" Value="" />
                        </Items>
                    </telerik:RadComboBox>
            
                <asp:Button ID="ButtonExecuteReport" runat="server" OnClick="ButtonExecuteReport_OnClick"
                    Text="Run Report" CssClass="mybutton myaddbutton" CausesValidation="True" ValidationGroup="ReportParameters" />
            </div>
            <asp:ValidationSummary ID="ValidationSummary" runat="server" ValidationGroup="ReportParameters"
                DisplayMode="List" />
            <div class="BulkEditWrapper BulkDataReport">
                <div class="BulkEditContentWrapper">
                    <uc:ReportViewport ID="ReportViewport" runat="server"  ReportName="BulkEnrollmentFormsReport"  />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
