using System;
using System.Web.UI;
using POD.Logic;

namespace POD.UserControls
{
    public partial class StaffLinks : UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Page.IsPostBack == false)
            {
                if (!Security.UserInRole("Administrators") && !Security.UserInRole("CentralTeamUsers"))
                {
                    ManagePositionsLink.Visible = false;
                }
            }
        }
    }
}