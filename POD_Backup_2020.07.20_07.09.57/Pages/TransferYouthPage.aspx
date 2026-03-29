<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TransferYouthPage.aspx.cs"
    Inherits="POD.Pages.TransferYouthPage" %>

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
    <asp:Literal ID="LiteralErrorMsg" runat="server"></asp:Literal>
    <div class="TransferYouthWrapper myPopupWrapper">
    <div class="row">
        <h3 class="sectionHead"><asp:Literal ID="LiteralYouth" runat="server"></asp:Literal></h3>
    </div>
    <div class="row">
        <p>Select the location the youth is being transferred to below:</p>
    </div>
        <div class="row">
            <div class="">
                <telerik:RadComboBox ID="RadComboBoxProdigyLocation" runat="server" CssClass="mydropdown"
                    Height="100%" Width="330px" DataValueField="LocationID" DataTextField="Name" MaxHeight="120"
                    AppendDataBoundItems="true">
                    <Items>
                        <telerik:RadComboBoxItem Text="Select Location" Value="" />
                    </Items>
                </telerik:RadComboBox>
                <asp:RequiredFieldValidator ID="reqVal" runat="server" SetFocusOnError="true" InitialValue=""
                    Display="Dynamic" ControlToValidate="RadComboBoxProdigyLocation" ValidationGroup="Save"
                    CssClass="ErrorMessage" ErrorMessage="Location Selection is required" Text="* Required"></asp:RequiredFieldValidator>
            </div>
        </div>
        <asp:Panel ID="PanelMainContentEditButtons" runat="server">
            <div class="editButtons">
                <asp:Button ID="SaveButton" runat="server" ValidationGroup="Save" Text="Save" 
                    class="mybutton mysave" onclick="SaveButton_Click" OnClientClick="return confirm('Are you sure you want to transfer this Youth?);" />
            </div>
        </asp:Panel>
    </div>
    
    </form>
</body>
</html>
