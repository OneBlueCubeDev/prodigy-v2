<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Login" %>

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
    <div class="outercontainer">
        <div class="innercontainer">
            <div class="login-container">
                <div class="login-logo">
                    <%--<img src="Templates/Images/prodigy_logo.png" alt="Prodigy Logo" />--%>
                    <img src="Templates/Images/UACDCHeaderLogo.png" alt="UACDC Logo" />
                </div>
                <div class="myloginpanel">
                    <asp:Login ID="Login1" runat="server" TitleText="" OnLoginError="Login1_Error" PasswordRecoveryUrl="~/ForgotPassword.aspx"
                        PasswordRecoveryText="Forgot Username or Password?" PasswordRequiredErrorMessage="Required"
                        UserNameRequiredErrorMessage="Required" UserNameLabelText="User Name" PasswordLabelText="Password"
                        LoginButtonStyle-CssClass="LoginButtonClass mybutton" LoginButtonText="Login"
                        ValidatorTextStyle-CssClass="ValidationClass"
                        DestinationPageUrl="~/Pages/UACDCPrograms.aspx" LabelStyle-CssClass="mylabel myloginlabel"
                        TextBoxStyle-CssClass="myfield" CheckBoxStyle-CssClass="mycheckbox" FailureTextStyle-CssClass="mymessage"
                        OnLoggedIn="Login1_LoggedIn">
                        <CheckBoxStyle CssClass="mycheckbox"></CheckBoxStyle>
                        <LabelStyle CssClass="mylabel myloginlabel"></LabelStyle>
                        <LayoutTemplate>
                            <table cellpadding="1" cellspacing="0" style="border-collapse: collapse;">
                                <tr>
                                    <td>
                                        <table cellpadding="0">
                                            <tr>
                                                <td align="right" class="mylabel myloginlabel">
                                                    <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName">User Name</asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="UserName" runat="server" CssClass="myfield"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName"
                                                        CssClass="ValidationClass" ErrorMessage="Required" ForeColor="Red" ToolTip="Required"
                                                        ValidationGroup="Login1">*</asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right" class="mylabel myloginlabel">
                                                    <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password">Password</asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="Password" runat="server" CssClass="myfield" TextMode="Password"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password"
                                                        CssClass="ValidationClass" ErrorMessage="Required" ForeColor="Red" ToolTip="Required"
                                                        ValidationGroup="Login1">*</asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="mycheckbox" colspan="2">
                                                    <asp:CheckBox ID="RememberMe" runat="server" Text="Remember me next time." />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="center" class="mymessage" colspan="2" style="color: Red;">
                                                    <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right" colspan="2">
                                                    <asp:Button ID="LoginButton" runat="server" CommandName="Login" CssClass="LoginButtonClass mybutton"
                                                        Text="Login" ValidationGroup="Login1" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <asp:HyperLink ID="PasswordRecoveryLink" runat="server" NavigateUrl="~/ForgotPassword.aspx">Forgot Username or Password?</asp:HyperLink>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </LayoutTemplate>
                        <FailureTextStyle CssClass="mymessage"></FailureTextStyle>
                        <LoginButtonStyle CssClass="LoginButtonClass mybutton"></LoginButtonStyle>
                        <TextBoxStyle CssClass="myfield"></TextBoxStyle>
                        <ValidatorTextStyle CssClass="ValidationClass"></ValidatorTextStyle>
                    </asp:Login>
                    <br />
                </div>
                <div class="MessageWrapper">
                    <asp:Label ID="LabelActionFeedback" CssClass="ValidationClass" runat="server"></asp:Label></div>
            </div>
        </div>
    </div>
    </form>
</body>
</html>
