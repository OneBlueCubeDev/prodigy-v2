<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DownLoad.aspx.cs" Inherits="POD.Pages.DownLoad" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Certificate</title>
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
            <script type="text/JavaScript" src="~/Templates/Scripts/curvycorners.js"></script> 
        <script type="text/JavaScript">
          window.onload = function() {
            var settings = {
              tl: { radius: 10 },
              tr: { radius: 10 },
              bl: { radius: 10 },
              br: { radius: 10 },
              antiAlias: true
            }

              curvyCorners(settings, '.mycurvycorners');
          }

        </script> 
    <![endif]-->
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
    <telerik:RadCodeBlock ID="RadCodeBlock" runat="server">
        <script type="text/javascript" language="javascript">
            function GetRadWindow() {
                var oWindow = null;
                if (window.radWindow)
                    oWindow = window.radWindow;
                else if (window.frameElement.radWindow)
                    oWindow = window.frameElement.radWindow;
                return oWindow;
            }

            function returnToParent() {
                //get parent window
                var oWnd = GetRadWindow();
                //Close the RadWindow and send the argument to the parent page
                oWnd.close();

            }
                     
        </script>
    </telerik:RadCodeBlock>
    <asp:Panel ID="PanelCertificate" runat="server" CssClass="DownloadWrapper myPopupWrapper">
        <h3>
            Certificate creation is now complete</h3>
        <p>
            Please use the button below to go directly to the file. Once you've opened your
            certificate, you may close this window.</p>
        <asp:HyperLink ID="HyperLink" runat="server" Target="_blank" Text="Open Certificate"
            CssClass="mybutton"></asp:HyperLink>
    </asp:Panel>
    <asp:Panel ID="PanelNotEligible" runat="server" Visible="false">
        <p>
            <asp:Literal ID="LiteralMsg" runat="server"><strong>This youth has not fullfilled the requirements to receive a certificate. He/She must complete 24 hours of classes!</strong></asp:Literal>
        </p>
    </asp:Panel>
    </form>
</body>
</html>
