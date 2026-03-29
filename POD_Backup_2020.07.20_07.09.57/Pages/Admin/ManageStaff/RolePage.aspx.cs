using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using POD.Data.Entities;
using Telerik.Web.UI;

namespace POD.Pages.Admin.ManageStaff
{
    public partial class RolePage : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {

        }
        /// <summary>
        /// saves release data and update enrollment status
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                if (!string.IsNullOrEmpty(this.TextBoxRole.Text))
                {
                    POD.Logic.Security.AddNewRole(this.TextBoxRole.Text.Trim());
                }
                ClientScript.RegisterStartupScript(Page.GetType(), "mykey", "CloseAndRebind('Success');", true);
            }
        }
    }
}