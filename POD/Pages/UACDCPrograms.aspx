<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UACDCPrograms.aspx.cs"
    Inherits="POD.Pages.UACDCPrograms" %>

<%@ Register Src="~/Templates/Markup/Common/Footer.ascx" TagPrefix="cms" TagName="Footer" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Programs - University Area Community Development Corporation, Inc.</title>
    <link type="text/css" rel="stylesheet" href="~/Templates/Styles/MainStyles.css" />
    <link type="text/css" rel="stylesheet" href="~/Templates/Styles/EnrollmentFormStyles.css" />
    <link type="text/css" rel="stylesheet" href="~/Templates/Styles/RiskAssessmentStyles.css" />
    <link type="text/css" rel="stylesheet" href="~/Templates/Styles/AttendanceStyles.css" />
    <link type="text/css" rel="stylesheet" href="~/Templates/Styles/ClassesStyles.css" />
    <link type="text/css" rel="stylesheet" href="~/Templates/Styles/UACDCProgramStyles.css" />
    <link type="text/css" rel="stylesheet" href="~/Templates/Styles/DashboardStyles.css" />
    <link rel="shortcut icon" type="image/x-icon" href="~/Templates/Images/favicon.ico">
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
    <div class="outercontainer">
        <div class="innercontainer">
            <div class="header">
                <h1>
                    <img src="../Templates/Images/UACDCHeaderLogo.png" alt="UACDC Logo" /></h1>
                <div class="usernav">
                    <asp:LoginView ID="Loginview1" runat="server">
                        <LoggedInTemplate>
                            <p>
                                Logged in as <span class="userName">
                                    <asp:Literal ID="LiteralUserName" runat="server"></asp:Literal></span></p>
                            <ul>
                                <li><a href="#" title="My Account">My Account</a><span class="seperator"></span></li>
                                <li runat="server" id="LiAdminLink" visible="false" class="temporaryHide">
                                    <asp:HyperLink ID="HyperLinkAdministration" runat="server" NavigateUrl="~/Pages/Admin/Dashboard.aspx"
                                        Visible="false" Text="Administration"></asp:HyperLink>
                                    <span class="seperator"></span></li>
                                <li>
                                    <asp:LoginStatus ID="LoginStatus1" runat="server" LogoutText="Logout" class="Logout"
                                        OnLoggedOut="LoginStatus1_LoggedOut" LogoutAction="Redirect" LogoutPageUrl="~/Default.aspx" />
                                </li>
                            </ul>
                        </LoggedInTemplate>
                    </asp:LoginView>
                </div>
                <!--end usernav-->
                <div class="toolbar">
                </div>
                <!--end toolbar-->
            </div>
            <!--end header-->
            <div class="contentcontainer">
                <div class="widecontent">
                    <asp:DataList ID="DataListPrograms" DataKeyField="ProgramID" OnItemCommand="DataListPrograms_ItemCommand"
                        RepeatColumns="3" runat="server" CssClass="UACDCPrograms" CellPadding="15" CellSpacing="5"
                        OnItemDataBound="DataListPrograms_ItemDataBound">
                        <ItemTemplate>
                            <asp:Panel ID="PanelWrapper" runat="server" CssClass="ProgramWrapper">
                                <div class="ProgramName">
                                    <h2>
                                        <%# Eval("Name") %></h2>
                                </div>
                                <div class="">
                                    <div class="ProgramImage">
                                        <asp:Image ID="ProgramImage" AlternateText='<%# Eval("Name") %>' runat="server" ImageUrl='<%# "~/Templates/Images/"+ Eval("Name").ToString().Replace(" " ,"").ToLower() +"_logo.png"%>' /></div>
                                    <p>
                                        <asp:Literal ID="LiteralDesc" runat="server" Text='<%# Bind("Description") %>'></asp:Literal></p>
                                    <asp:Button ID="ButtonGo" runat="server" Text="GO >" CommandArgument='<%# Bind("ProgramID") %>'
                                        CommandName="ProgramSelect" CssClass="mybutton mygobutton" />
                                </div>
                                <asp:Panel runat="server" ID="PanelDisabledSetting">
                                </asp:Panel>
                            </asp:Panel>
                        </ItemTemplate>
                    </asp:DataList>
                </div>
            </div>
            <!--end contentcontainer-->
            <div class="footer">
                <cms:Footer ID="Footer1" runat="server" />
            </div>
            <!--end footer-->
        </div>
        <!--end inner container-->
    </div>
    <!--end outercontainer-->
    </form>
</body>
</html>
