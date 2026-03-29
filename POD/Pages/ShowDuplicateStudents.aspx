<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShowDuplicateStudents.aspx.cs"
    Inherits="POD.Pages.ShowDuplicateStudents" %>

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

            function returnToParent(id) {
                //get parent window
                var oWnd = GetRadWindow();
                //Close the RadWindow and send the argument to the parent page
                oWnd.BrowserWindow.UpdateReturnToSave(id);
                oWnd.close();

            }

        </script>
    </telerik:RadCodeBlock>
    <div class="PossibleMatchesWrapper">
        <div class="row">
        <h3>
            Possible Matches of Students in the System</h3>
        <p>
            Please review the following matches of youth in the system. If you are updating
            data for any of the below, please select that youth. Or Select "none of the above"
            to create a new record.
        </p>
        <asp:Literal ID="literalCloseWindow" runat="server"></asp:Literal>
        <asp:DataList ID="DataListPersonMatches" DataKeyField="PersonID" runat="server" CssClass="PossibleMatchesTable">

            <ItemTemplate>
                <a href="#" class="mybutton mySelectButton" onclick='<%# "returnToParent(" + Eval("PersonID") + ");" %>'>Select</a></td>
                <td><span>Name:</span></td><td class="Name"><%# Eval("FullName") %>&nbsp;&nbsp;</td></tr><tr class="LastRow"><td></td>
                <td class="DOBLabel"><span>Date of Birth:</span></td><td class="DOB"><%# (Eval("DateOfBirth") != null && Eval("DateOfBirth") is DateTime) ? DateTime.Parse(Eval("DateOfBirth").ToString()).ToString("MM/dd/yyyy"): "N/A" %>&nbsp;&nbsp;</td><td class="DJJNumLabel"><span>DJJ#:</span></td><td class="DJJNum"><%# Eval("DJJIDNum") != "" ? Eval("DJJIDNum") : "N/A"%></td><td class="GenderLabel"><span>Gender:</span></td><td class="Gender"><%# Eval("Gender.Name") !=""? Eval("Gender.Name"): "N/A" %></td>
                <td class="AgeLabel"><span>Age (at enrollment time):</span></td><td class="Age"><%# Eval("Age") != "" ? Eval("Age") : "N/A"%> </td><td>
                
                 
            </ItemTemplate>
            <FooterTemplate>
                <a href="#" onclick="returnToParent(0);" class="mySelectButton mybutton">Select</a></td><td>
                    <span class="SelectNone">None of the above</span>

            </FooterTemplate>
        </asp:DataList>
    </div>
    </div>
    </form>
</body>
</html>
