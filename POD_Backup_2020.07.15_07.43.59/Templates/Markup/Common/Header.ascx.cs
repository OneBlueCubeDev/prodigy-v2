using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using POD.Logic;
using POD.Data.Entities;

namespace POD.Templates.Markup.Common
{
    public partial class Header : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
           
            if (!CheckSelectedProgram())
            {
                //TODO sent back to select program

            }
            if (!Page.IsPostBack)
            {
                // Is logged in user an Admin? show the admin option
                if (Security.UserInRole("Administrators") || Security.UserInRole("CentralTeamUsers"))
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
              
                if (Session["UsersSiteID"] == null)
                {
                    //set users site id 
                    StaffMember staff = POD.Logic.PeopleLogic.GetStaffByUserID((Guid)Security.GetCurrentUserProfile().ProviderUserKey);
                    if (staff != null)
                    {
                        Session["UsersSiteID"] = POD.Logic.PeopleLogic.GetSiteIDForStaff(staff.PersonID);
                    }
                }
            }


        }

        public void SetNavigationSelected(string page)
        {
            LiAttendance.Attributes.Remove("class");
            LiDashboard.Attributes.Remove("class");
            LiEvents.Attributes.Remove("class");
            LiInventory.Attributes.Remove("class");
            LiClass.Attributes.Remove("class");
            LiYouth.Attributes.Remove("class");
            LiReporting.Attributes.Remove("class");
            LiLessonPlans.Attributes.Remove("class");
            LiStaff.Attributes.Remove("class");
            switch (page)
            {
                case "Dashboard":
                    LiDashboard.Attributes.Add("class", "currentPage");
                    break;
                case "Youth":
                    LiYouth.Attributes.Add("class", "currentPage");
                    break;
                case "Attendance":
                    LiAttendance.Attributes.Add("class", "currentPage");
                    break;
                case "Class":
                    LiClass.Attributes.Add("class", "currentPage");
                    break;
                case "Event":
                    LiEvents.Attributes.Add("class", "currentPage");
                    break;
                case "Inventory":
                    LiInventory.Attributes.Add("class", "currentPage");
                    break;
                case "Reporting":
                    LiReporting.Attributes.Add("class", "currentPage");
                    break;
                case "Staff":
                        LiStaff.Attributes.Add("class", "currentPage");
                    break;
                case "LessonPlan":
                    LiLessonPlans.Attributes.Add("class", "currentPage");
                    break;
            }

        }

        private bool CheckSelectedProgram()
        {
            bool isSelected = false;

            if (Session["ProgramID"] == null)
            {
                // Response.Redirect("~/Pages/UACDCPrograms.aspx");
                Session["ProgramID"] = POD.Logic.ProgramCourseClassLogic.GetProgramID();
            }

            isSelected = true;
            return isSelected;

        }

        protected void LoginStatus1_LoggedOut(object sender, EventArgs e)
        {
            Session["UsersSiteID"] = null;
            Security.Logout();
        }
    }
}