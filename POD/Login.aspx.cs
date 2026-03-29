using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Data;
using System.Configuration;
using System.Web.Security;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Telerik.Web.UI;
using POD.Logic;
using POD.Data.Entities;
using System.Collections.Generic;
using System.Linq;
public partial class Login : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {

            //remember me setting login
            if (Request.Cookies["myCookie"] != null)
            {
                HttpCookie cookie = Request.Cookies.Get("myCookie");
                Login1.UserName = cookie.Values["username"];

                Login1.RememberMeSet = (!String.IsNullOrEmpty(Login1.UserName));
            }
            TextBox txtUser = Login1.FindControl("UserName") as TextBox;
            if (txtUser != null)
                this.SetFocus(txtUser);


            if (Request["action"] != null)
            {
                if (Request["action"] == "passwordreset")
                {
                    LabelActionFeedback.Text = "Your password has been successfully reset. You may now log in with your new password.";
                }
            }
        }
    }

    /// <summary>
    /// error on login
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Login1_Error(object sender, EventArgs e)
    {
       Exception ex = Server.GetLastError();
     
        //TODO handle error
        //this.LabelActionFeedback.Text = "An error occurred, please contact the system administrator.";
    }

    /// <summary>
    /// setting remember me cookie
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Login1_LoggedIn(object sender, EventArgs e)
    {
        //add cookie to remember login
        CheckBox rm = (CheckBox)this.Login1.FindControl("RememberMe");
        if (rm.Checked)
        {
            HttpCookie myCookie = new HttpCookie("myCookie");
            Response.Cookies.Remove("myCookie");
            Response.Cookies.Add(myCookie);
            myCookie.Values.Add("username", this.Login1.UserName.ToString());
            DateTime dtExpiry = DateTime.Now.AddDays(15); //you can add years and months too here
            Response.Cookies["myCookie"].Expires = dtExpiry;
        }
        else
        {
            HttpCookie myCookie = new HttpCookie("myCookie");
            Response.Cookies.Remove("myCookie");
            Response.Cookies.Add(myCookie);
            myCookie.Values.Add("username", this.Login1.UserName.ToString());
            DateTime dtExpiry = DateTime.Now.AddSeconds(1); //you can add years and months too here
            Response.Cookies["myCookie"].Expires = dtExpiry;
        }
    }
  
}
