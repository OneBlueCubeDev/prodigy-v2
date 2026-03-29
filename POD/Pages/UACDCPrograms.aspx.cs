using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using POD.Logic;
using System.Web.UI.HtmlControls;
using POD.Data.Entities;

namespace POD.Pages
{
    public partial class UACDCPrograms : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {  // Check Security
            if (Security.UserAuthenticated() == false)
            {
                Security.Logout();
                Response.Redirect("~/Default.aspx");
            }
            if (!IsPostBack)
            {
                IList<POD.Data.Entities.Program> programs = POD.Logic.ProgramCourseClassLogic.GetPrograms();
                int counter = 1;
                while (counter < 6)
                {
                    POD.Data.Entities.Program prog = new Data.Entities.Program();
                    prog.ProgramID = 0;
                    prog.Name = "Future Program";
                    prog.Description = "<p>Text about future programs to be added to Pod at later phases/projects.</p>";
                    programs.Add(prog);
                    counter++;
                }
                this.DataListPrograms.DataSource = programs;
                this.DataListPrograms.DataBind();

                
                // Is logged in user an Admin? show the admin option
                if (Security.UserInRole("Administrators"))
                {
                    HyperLink linkAdmin = (HyperLink)Loginview1.FindControl("HyperLinkAdministration");
                    HtmlGenericControl li = (HtmlGenericControl)Loginview1.FindControl("LiAdminLink");
                    if (linkAdmin != null)
                    {
                        linkAdmin.Visible = true;
                    }
                    if (li != null)
                    {
                        li.Visible = true;
                    }
                }
                Literal literalUserName = (Literal)Loginview1.FindControl("LiteralUserName");
                literalUserName.Text = Security.GetCurrentUserProfile().UserName;


            }
        }

        protected void DataListPrograms_ItemCommand(object source, DataListCommandEventArgs e)
        {
            if (e.CommandName == "ProgramSelect")
            {
                int progID = 0;
                int.TryParse(e.CommandArgument.ToString(), out progID);
                if (progID == 1) //right now only one will redirect 
                {
                    Session["ProgramID"] = progID;

                    Response.Redirect("~/Pages/ControlPanel.aspx");
                }

            }
        }

        protected void LoginStatus1_LoggedOut(object sender, EventArgs e)
        {
            Security.Logout();
        }

        protected void DataListPrograms_ItemDataBound(object sender, DataListItemEventArgs e)
        {
            if (e.Item.DataItem != null)
            { 
                Program prog = (Program)e.Item.DataItem;
                
                Image img = (Image)e.Item.FindControl("ProgramImage");
                Button btn =(Button)e.Item.FindControl("ButtonGo");
                Panel pnl = (Panel)e.Item.FindControl("PanelDisabledSetting");
                if(prog.Name != "Prodigy")
                {
                    img.Visible = false;
                    btn.Visible = false;
                    pnl.CssClass = "ProgramDisabledContainer ProgramDisabled";
                }
                else{
                    pnl.CssClass = "ProgramDisabledContainer";
                }
                
            }
        }
    }
}