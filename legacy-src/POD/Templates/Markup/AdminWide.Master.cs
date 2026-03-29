using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using POD.Data.Entities;
using POD.Logic;

namespace POD.MasterPages
{
    public partial class AdminWide : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CheckSession();
        }
        public void CheckSession()
        {
            // Check Security
            if (Security.UserAuthenticated() == false)
            {
                Security.Logout();
                Response.Redirect("~/Default.aspx");
            }
            else if (Security.GetCurrentUserProfile() == null)
            {
                Security.Logout();
                Response.Redirect("~/Default.aspx");
            }

            if (Session["UsersSiteID"] == null)
            {
                //set users site id 
                StaffMember staff = POD.Logic.PeopleLogic.GetStaffByUserID(Security.GetCurrentUserGuid());
                if (staff != null)
                {
                    Session["UsersSiteID"] = POD.Logic.PeopleLogic.GetSiteIDForStaff(staff.PersonID);
                }
            }
        }
        public void SetNavigation(string page)
        {
            this.Header1.SetNavigationSelected(page);
        }
    }
}