<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs"
    Inherits="POD.ForgotPassword" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>University Area Community Development Corporation, Inc.</title>
    <telerik:RadStyleSheetManager ID="RadStyleSheetManager1" runat="server" />
    <link type="text/css" rel="stylesheet" href="~/Templates/Styles/MainStyles.css" />
    <link type="text/css" rel="stylesheet" href="~/Templates/Styles/LoginStyles.css" />
    <link rel="shortcut icon" type="image/x-icon" href="~/Templates/Images/favicon.ico">
     <!--[if IE 9]>
	    <link rel="stylesheet" type="text/css" href="~/Templates/Styles/IE9Styles.css" />   
    <![endif]-->
    <!--[if IE 8]>
	        <link rel="stylesheet" type="text/css" href="~/Templates/Styles/IE8Styles.css" /> 
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
    <script type="text/javascript">
        //Put your JavaScript code here.
    </script>
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server">
    </telerik:RadAjaxManager>
    <div class="outercontainer">
        <div class="innercontainer">
            
            <div class="login-container">
                <div class="login-logo">
                    <a href="Default.aspx" title="UACDC Login">
                        <img src="Templates/Images/UACDCHeaderLogo.png" alt="UACDC Logo" /></a>
                </div>
                        <div class="myloginpanel">
                        <asp:MultiView ID="MultiViewMain" runat="server" ActiveViewIndex="0">
                            <asp:View ID="PasswordRecoveryView" runat="server">
                            <table class="forgotpassword" cellpadding="0">
                                <tr>
                                    <td colspan="2">
                                        <p>
                                            Change Your Password
                                            <br />
                                        </p>
                                    </td>
                                </tr>
                                <tr id="TRUserName" runat="server">
                                    <td align="right" class="mylabel myloginlabel">
                                        <asp:Label ID="Label1" runat="server" AssociatedControlID="UserName" CssClass="LoginLabel">
                                            User Name <span class="myrequiredfield">*</span>
                                        </asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="UserName" runat="server" TextMode="Password" CssClass="TextField myfield"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="UserName"
                                            ErrorMessage="User Name is required." ToolTip="User Name is required." ValidationGroup="ChangePasswordForgot" CssClass="ValidationClass">*</asp:RequiredFieldValidator>
                                        <br />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" class="mylabel myloginlabel">
                                        <asp:Label ID="Label4" runat="server" AssociatedControlID="TextBoxEmailForPassword" CssClass="LoginLabel">
                                            Email <span class="myrequiredfield">*</span>
                                        </asp:Label>
                                    </td>
                                    <td>
                                       <asp:TextBox ID="TextBoxEmailForPassword" runat="server" CssClass="TextField"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="TextBoxEmailForPassword"
                                                    ErrorMessage="Email is required." ToolTip="Email Name is required."
                                                    Font-Size="11px" Font-Bold="True" ValidationGroup="ChangePasswordForgot" Display="Dynamic" CssClass="ValidationClass">*</asp:RequiredFieldValidator>
                                 
                                        
                                    </td>
                                </tr>
                                
                                <tr>
                                    <td align="right" class="mylabel myloginlabel">
                                        <asp:Label ID="NewPasswordLabel" runat="server" AssociatedControlID="NewPassword"
                                            CssClass="LoginLabel">
                                            New Password <span class="myrequiredfield">*</span>
                                        </asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="NewPassword" runat="server" TextMode="Password" CssClass="TextField myfield"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="NewPasswordRequired" runat="server" ControlToValidate="NewPassword"
                                            ErrorMessage="New Password is required." ToolTip="New Password is required."
                                            ValidationGroup="ChangePasswordForgot" CssClass="ValidationClass">*</asp:RequiredFieldValidator>
                                        <br />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" class="mylabel myloginlabel">
                                        <asp:Label ID="ConfirmNewPasswordLabel" runat="server" AssociatedControlID="ConfirmNewPassword"
                                            CssClass="LoginLabel">
                                            Confirm New Password <span class="myrequiredfield">*</span>
                                        </asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="ConfirmNewPassword" runat="server" TextMode="Password" CssClass="TextField myfield"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="ConfirmNewPasswordRequired" runat="server" ControlToValidate="ConfirmNewPassword"
                                            ErrorMessage="Confirm New Password is required." ToolTip="Confirm New Password is required."
                                            ValidationGroup="ChangePasswordForgot" CssClass="ValidationClass">*</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="center" colspan="2">
                                        <asp:CompareValidator ID="NewPasswordCompare" runat="server" ControlToCompare="NewPassword"
                                            ControlToValidate="ConfirmNewPassword" Display="Dynamic" ErrorMessage="The Confirm New Password must match the New Password entry."
                                            ValidationGroup="ChangePasswordForgot"></asp:CompareValidator>
                                    </td>
                                </tr>
                                
                                <tr>
                                    <td align="right" colspan="2">
                                        <asp:Button ID="ChangePasswordForForgot" runat="server" CssClass="Buttons mybutton"
                                            Text="Change" ValidationGroup="ChangePasswordForgot" OnClick="ChangePasswordForForgot_Click" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="center" colspan="2" class="ValidationClass ErrorMessageClass">
                                        <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                                    </td>
                                </tr>
                            </table>
                            </asp:View>
                    
                    <asp:View ID="UserNameRecoveryView" runat="server">
                          <table  class="forgotpassword forgotusername" cellpadding="0">
                            <tr>
                                <td colspan="2">
                                <p>Send User name</p>
                                </td>
                                  </tr>
                                 <tr>
                                    <td align="right" class="mylabel myloginlabel">
                                        <asp:Label ID="Label2" runat="server" AssociatedControlID="TextBoxEmailForUserName" CssClass="LoginLabel">
                                            Email <span class="myrequiredfield">*</span>
                                        </asp:Label>
                                    </td>
                                    <td>
                                       <asp:TextBox ID="TextBoxEmailForUserName" runat="server" CssClass="TextField"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="TextBoxEmailForUserName"
                                                    ErrorMessage="Email is required." ToolTip="Email is required."
                                                    Font-Size="11px" Font-Bold="True" ValidationGroup="UserNameRecovery1" Display="Dynamic" CssClass="ValidationClass">*</asp:RequiredFieldValidator>
                                 
                                        
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" class="mylabel myloginlabel">
                                        <asp:Label ID="Label3" runat="server" AssociatedControlID="TextBoxZipCode" CssClass="LoginLabel">
                                            Zip Code <span class="myrequiredfield">*</span>
                                        </asp:Label>
                                    </td>
                                    <td>
                                                                                       <asp:TextBox ID="TextBoxZipCode" runat="server" CssClass="TextField"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="TextBoxZipCode"
                                                    ErrorMessage="Zip Code is required." ToolTip="Zip code is required."
                                                    Font-Size="11px" Font-Bold="True" ValidationGroup="UserNameRecovery1" Display="Dynamic" CssClass="ValidationClass">
                                                     *
                                                </asp:RequiredFieldValidator>
                                 
                                        
                                    </td>
                                </tr>
                                   
                                        <tr>
                                             <td align="right" colspan="2">
                                                <asp:Button ID="ButtonRetrieveUserName" runat="server" CommandName="Submit" Text="Retrieve" CssClass="Buttons mybutton myuserretrieve"
                                                    ValidationGroup="UserNameRecovery1"  OnClick="ButtonRetrieveUserName_Click" />
                                            </td>
                                        </tr>
                                        <tr>
                                    <td align="center" colspan="2" class="ValidationClass ErrorMessageClass">
                                        <asp:Literal ID="LiteralFailureUserNameRetrieval" runat="server" EnableViewState="False"></asp:Literal>
                                       
                                    </td>
                                </tr>
                                  
                        </table>
                    </asp:View>
                    <asp:View ID="ViewUserNameSuccessNotification" runat="server">
                        <p class="myusernamesuccess">
                            Your username has been successfully mailed.<br />
                            <asp:Button ID="ButtonBackToLogin" runat="server" Text="Back" CssClass="Buttons mybutton mybackbutton" PostBackUrl="/Default.aspx" />
                        </p>
                    </asp:View>
                </asp:MultiView>
                <asp:Panel ID="ForgotPasswordInstructionsPanel" runat="server">
                            <h3>
                                Forgot Password
                            </h3>
                            <p>
                                Provide your username and new password and the system will update your record for you.
                            </p>
                            <h3>
                                Forgot Username
                            </h3>
                            <p>
                                If you would like your username sent to you by e-mail,<br />
                                <asp:LinkButton ID="LinkButtonRetrieveUserName" runat="server" OnClick="LinkButtonRetrieveUserName_Click">
                            click here
                                </asp:LinkButton>
                                &nbsp;to retrieve your username. You will need your email address and zip code that
                                is registered to the account.
                            </p>
                            </asp:Panel>
                </div>
            </div>
        </div>
    </div>
    </form>
</body>
</html>
