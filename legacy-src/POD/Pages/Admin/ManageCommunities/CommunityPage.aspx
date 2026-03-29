<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeBehind="CommunityPage.aspx.cs"
    Inherits="POD.Pages.Admin.ManageCommunities.CommunityPage" %>

<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link type="text/css" rel="stylesheet" href="~/Templates/Styles/MainStyles.css" />
    <link type="text/css" rel="stylesheet" href="~/Templates/Styles/EnrollmentFormStyles.css" />
    <link type="text/css" rel="stylesheet" href="~/Templates/Styles/RiskAssessmentStyles.css" />
    <link type="text/css" rel="stylesheet" href="~/Templates/Styles/AttendanceStyles.css" />
    <link type="text/css" rel="stylesheet" href="~/Templates/Styles/ClassesStyles.css" />
    <link type="text/css" rel="stylesheet" href="~/Templates/Styles/DashboardStyles.css" />
    <link type="text/css" rel="stylesheet" href="~/Templates/Styles/PopUpStyles.css" />
    <link href='//fonts.googleapis.com/css?family=Muli:400,300,300italic,400italic' rel='stylesheet'
        type='text/css' />
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
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server" EnableAJAX="true">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="ButtonAddCounty">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxCounty" />
                    <telerik:AjaxUpdatedControl ControlID="DataListCommunityCounties" />
                    <telerik:AjaxUpdatedControl ControlID="LabelFeedback" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="ButtonSave">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="LabelFeedback" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="DataListCommunityCounties">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="LabelFeedback" />
                    <telerik:AjaxUpdatedControl ControlID="DataListCommunityCounties" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>
    <div class="PersonWrapper myPopupWrapper">
        <h2 class="PopUpHeader">
            <asp:Literal runat="server" ID="LiteralHeader"></asp:Literal></h2>
        <auth:SecureContent ID="SecureContent1" ToggleVisible="false" ToggleEnabled="true"
            EventHook="Load" runat="server" Roles="Administrators;">
            <asp:Panel ID="PanelCommunity" runat="server" CssClass="CommunitiesPopUpWrapper">
                <div class="row">
                    <asp:Label ID="LabelName" runat="server" Text="Name" CssClass="mylabel"></asp:Label>
                    <asp:TextBox ID="TextboxName" runat="server" CssClass="myfield"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="TextboxName"
                        ErrorMessage="Name is required" Display="Dynamic" ValidationGroup="SaveCommunity"></asp:RequiredFieldValidator>
                </div>
                <div class="row">
                    <asp:Label ID="LabelDesc" runat="server" Text="Description" CssClass="mylabel"></asp:Label>
                    <telerik:RadEditor ID="RadEditorDesc" CssClass="TextEditor" Width="620" Height="225"
                        AutoResizeHeight="false" AllowScripts="false" SkinID="BasicSetOfTools" EnableEmbeddedSkins="false"
                        Skin="Prodigy" runat="server" EnableResize="False">
                        <Tools>
                            <telerik:EditorToolGroup Tag="MainToolbar">
                                <telerik:EditorTool Name="AjaxSpellCheck" />
                                <telerik:EditorTool Name="FindAndReplace" />
                                <telerik:EditorSeparator Visible="true" />
                                <telerik:EditorTool Name="Undo" />
                                <telerik:EditorTool Name="Redo" />
                                <telerik:EditorSeparator Visible="true" />
                                <telerik:EditorTool Name="Cut" />
                                <telerik:EditorTool Name="Copy" />
                                <telerik:EditorTool Name="Paste" ShortCut="CTRL+!" />
                            </telerik:EditorToolGroup>
                            <telerik:EditorToolGroup Tag="Formatting">
                                <telerik:EditorTool Name="Bold" />
                                <telerik:EditorTool Name="Italic" />
                                <telerik:EditorTool Name="Underline" />
                                <telerik:EditorSeparator Visible="true" />
                                <telerik:EditorTool Name="ForeColor" />
                                <telerik:EditorTool Name="BackColor" />
                                <telerik:EditorSeparator Visible="true" />
                                <telerik:EditorTool Name="FontName" />
                                <telerik:EditorTool Name="RealFontSize" />
                                <telerik:EditorSeparator Visible="true" />
                                <telerik:EditorTool Name="InsertOrderedList" />
                                <telerik:EditorTool Name="InsertUnorderedList" />
                                <telerik:EditorTool Name="Outdent" />
                                <telerik:EditorTool Name="Indent" />
                            </telerik:EditorToolGroup>
                        </Tools>
                    </telerik:RadEditor>
                    <br style="clear: both;" />
                </div>
                <div class="InputWrapper">
                    <asp:Label ID="LabelCounties" runat="server" Text="Counties" CssClass="mylabel"></asp:Label>
                    <div class="CountryComboBoxContainer">
                        <telerik:RadComboBox DataTextField="Name" DataValueField="CountyID" DataSourceID="DataSourceCounties"
                            ID="RadComboBoxCounty" runat="server" AppendDataBoundItems="true" EnableEmbeddedSkins="false"
                            SkinID="Prodigy" CssClass="mydropdown">
                            <Items>
                                <telerik:RadComboBoxItem Text="Select County" Value="" />
                            </Items>
                        </telerik:RadComboBox>
                    </div>
                    &nbsp;
                    <auth:SecureContent ID="SecureContent3" ToggleVisible="true" ToggleEnabled="false"
                        EventHook="Load" runat="server" Roles="Administrators;">
                        <asp:Button CssClass="mybutton addCountybutton" runat="server" ID="ButtonAddCounty"
                            Text="Add County" ValidationGroup="SaveCommunity" OnClick="ButtonAddCounty_Click" />
                    </auth:SecureContent>
                    <asp:DataList DataKeyField="CountyID" ID="DataListCommunityCounties" runat="server"
                        OnItemCommand="DataListCommunityCounties_ItemCommand" CssClass="CommunityCountyTable">
                        <ItemTemplate>
                            <asp:Label ID="LabelName" Text='<%# Bind("Name") %>' runat="Server"></asp:Label></td><td
                                class="DeleteCell">
                                <auth:SecureContent ID="SecureContent1" ToggleVisible="true" ToggleEnabled="false"
                                    EventHook="Load" runat="server" Roles="Administrators;">
                                    <asp:LinkButton ID="ButtonDelete" runat="server" CommandArgument='<%# Bind("CountyID") %>'
                                        CommandName="Delete" Text="Delete" OnClientClick="return confirm('Are you sure you want to remove this county from this community?');"><img src="../../../App_Themes/Prodigy/Grid/Delete.png" alt="Delete" /></asp:LinkButton>
                                </auth:SecureContent>
                            </li>
                        </ItemTemplate>
                    </asp:DataList>
                </div>
            </asp:Panel>
            <asp:Panel ID="PanelCircuit" runat="server" CssClass="CircuitsPopupWrapper">
                <div class="row">
                    <asp:Label ID="LabelCirc" runat="server" Text="Name" CssClass="mylabel"></asp:Label>
                    <asp:TextBox ID="TextboxCircuit" runat="server" CssClass="myfield"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="TextboxCircuit"
                        ErrorMessage="Name is required" Display="Dynamic" ValidationGroup="SaveCircuit"></asp:RequiredFieldValidator>
                </div>
            </asp:Panel>
            <asp:Panel ID="PanelCounty" runat="server" CssClass="CountiesPopupWrapper">
                <div class="row">
                    <asp:Label ID="LabelCounty" runat="server" Text="Name" CssClass="mylabel"></asp:Label>
                    <asp:TextBox ID="TextboxCounty" runat="server" CssClass="myfield"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="TextboxCounty"
                        ErrorMessage="Name is required" Display="Dynamic" ValidationGroup="SaveCounty"></asp:RequiredFieldValidator>
                </div>
                <div class="row">
                    <asp:Label ID="LabelCircuit" runat="server" Text="Circuit" CssClass="mylabel"></asp:Label>
                    <telerik:RadComboBox DataTextField="Name" DataValueField="CircuitID" DataSourceID="DataSourceCircuits"
                        ID="RadComboBoxCircuits" runat="server" AppendDataBoundItems="true" EnableEmbeddedSkins="false"
                        SkinID="Prodigy" CssClass="mydropdown">
                        <Items>
                            <telerik:RadComboBoxItem Text="Select Circuit" Value="" />
                        </Items>
                    </telerik:RadComboBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="RadComboBoxCircuits"
                        ErrorMessage="Circuit is required" InitialValue="" Display="Dynamic" ValidationGroup="SaveCounty"></asp:RequiredFieldValidator>
                </div>
            </asp:Panel>
        </auth:SecureContent>
        <asp:Panel ID="PanelMainContentEditButtons" runat="server">
            <div class="editButtons myCommunityEditButtons">
                <asp:Label ID="LabelFeedback" runat="server" Text="" ForeColor="#FF3300"></asp:Label>
                <auth:SecureContent ID="SecureContent2" ToggleVisible="true" ToggleEnabled="false"
                    EventHook="Load" runat="server" Roles="Administrators;">
                    <asp:Button ID="ButtonSave" runat="server" Text="Save" OnClick="ButtonSave_Click"
                        CssClass="mybutton" /></auth:SecureContent>
                <asp:Button ID="ButtonCancel" OnClientClick="returnToParent();return false;" runat="server"
                    Text="Cancel" CausesValidation="false" CssClass="mybutton" />
            </div>
        </asp:Panel>
    </div>
    <asp:EntityDataSource ID="DataSourceCircuits" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" EnableFlattening="False" EntitySetName="Circuits"
        OrderBy="it.[Name]">
    </asp:EntityDataSource>
    <asp:EntityDataSource ID="DataSourceCounties" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" EnableFlattening="False" EntitySetName="Counties"
        OrderBy="it.[Name]">
    </asp:EntityDataSource>
    </form>
</body>
</html>
