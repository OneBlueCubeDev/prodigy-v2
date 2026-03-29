<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QuickAddPerson.aspx.cs"
    Inherits="POD.Pages.QuickAddPerson" %>

<%@ Register Src="../UserControls/AddPerson.ascx" TagName="AddPerson" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
      <link type="text/css" rel="stylesheet" href="~/Templates/Styles/MainStyles.css" />
    <link type="text/css" rel="stylesheet" href="~/Templates/Styles/EnrollmentFormStyles.css" />
    <link type="text/css" rel="stylesheet" href="~/Templates/Styles/RiskAssessmentStyles.css" />
    <link type="text/css" rel="stylesheet" href="~/Templates/Styles/AttendanceStyles.css" />
    <link type="text/css" rel="stylesheet" href="~/Templates/Styles/ClassesStyles.css" />
    <link type="text/css" rel="stylesheet" href="~/Templates/Styles/DashboardStyles.css" />
    <link type="text/css" rel="stylesheet" href="~/Templates/Styles/PopUpStyles.css" />
    <link href='//fonts.googleapis.com/css?family=Muli:400,300,300italic,400italic' rel='stylesheet' type='text/css' />
    <!--[if IE 9]>
	    <link rel="stylesheet" type="text/css" href="~/Templates/Styles/IE9Styles.css" />   
    <![endif]-->
    <!--[if IE 8]>
	        <link rel="stylesheet" type="text/css" href="~/Templates/Styles/IE8Styles.css" /> 
            
    <![endif]-->
    <telerik:RadStyleSheetManager ID="RadStyleSheetManager1" runat="server">
        <StyleSheets>
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Button.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Calendar.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/ColorPicker.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/ComboBox.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/DataPager.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Dock.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Editor.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/FileExplorer.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Filter.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/FormDecorator.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Grid.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/ImageEditor.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Input.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/ListBox.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/ListView.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Menu.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Notification.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/OrgChart.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/PanelBar.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Rating.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/RibbonBar.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Rotator.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Scheduler.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/SiteMap.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Slider.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/SocialShare.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Splitter.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/TagCloud.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/TabStrip.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/ToolBar.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/ToolTip.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/TreeList.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Upload.Prodigy.css" />
            <telerik:StyleSheetReference Path="~/App_Themes/Prodigy/Window.Prodigy.css" />
        </StyleSheets>
    </telerik:RadStyleSheetManager>
</head>
<body>
    <form id="form1" runat="server">
    <telerik:RadScriptManager ID="RadScriptManagerMain" runat="server">
        <Scripts>
            <%--Needed for JavaScript IntelliSense in VS2010--%>
            <%--For VS2008 replace RadScriptManager with ScriptManager--%>
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js" />
        </Scripts>
    </telerik:RadScriptManager>
    <uc1:AddPerson ID="AddPerson1" runat="server" />
    </form>
</body>
</html>
