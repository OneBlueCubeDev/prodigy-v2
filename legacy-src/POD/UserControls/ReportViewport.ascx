<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ReportViewport.ascx.cs"
    Inherits="POD.UserControls.ReportViewport" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<rsweb:ReportViewer ID="MainReportViewer" runat="server" Font-Names="Arial, Verdana, sans-serif" Font-Size="8pt"
    InteractiveDeviceInfos="(Collection)" ProcessingMode="Remote" WaitMessageFont-Names="Arial, Verdana, sans-serif" Color="#58595B"
    WaitMessageFont-Size="14pt" ShowReportBody="False" SizeToReportContent="True" ShowParameterPrompts="False" CssClass="ReportContent" InternalBorderColor="White" Width="100%">
</rsweb:ReportViewer>
