using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using POD.Data.Entities;
using POD.Logic;
using System.Web.UI.HtmlControls;
using Telerik.Web.UI;
using POD.Pages;
namespace POD.MasterPages
{
    public partial class Admin : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CheckSession();
            //always set to false initially
            RadWindow transferwindow = this.RadWindowManager.Windows[0];
            transferwindow.VisibleOnPageLoad = false;
            RadWindow currentWindow = this.RadWindowManager.Windows[2];
            currentWindow.VisibleOnPageLoad = false;
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
        public void SetSearch(string type)
        {
            this.SearchSideBar1.SetSearch(type);
        }
        /// <summary>
        /// set up search event handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Init(object sender, EventArgs e)
        {
            this.SearchSideBar1.OnSearchButtonClicked += new EventHandler(this.GetResult);
        }

        /// <summary>
        /// handles search button click
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void GetResult(object sender, System.EventArgs e)
        {
            if (this.Page.Request.Url.ToString().ToLower().Contains("enrollment") || this.Page.Request.Url.ToString().ToLower().Contains("patform"))
            {
                Response.Redirect(string.Format("~/Pages/Enrollments.aspx?sc={0}", POD.Logic.Utilities.SetSearchFilter(this.SearchSideBar1.SearchParameters)));
            }
            if (this.Page.Request.Url.ToString().ToLower().Contains("attendance"))
            {
                Response.Redirect(string.Format("~/Pages/Attendances.aspx?sc={0}", POD.Logic.Utilities.SetSearchFilter(this.SearchSideBar1.SearchParameters)));
            }
            if (this.Page.Request.Url.ToString().ToLower().Contains("classes"))
            {
                Response.Redirect(string.Format("~/Pages/ManageClasses/Classes.aspx?sc={0}", POD.Logic.Utilities.SetSearchFilter(this.SearchSideBar1.SearchParameters)));
            }
            if (this.Page.Request.Url.ToString().ToLower().Contains("events"))
            {
                Response.Redirect(string.Format("~/Pages/Events.aspx?sc={0}", POD.Logic.Utilities.SetSearchFilter(this.SearchSideBar1.SearchParameters)));
            }
            if (this.Page.Request.Url.ToString().ToLower().Contains("inventory"))
            {
                Response.Redirect(string.Format("~/Pages/Inventory.aspx?sc={0}", POD.Logic.Utilities.SetSearchFilter(this.SearchSideBar1.SearchParameters)));
            }
            if (this.Page.Request.Url.ToString().ToLower().Contains("lessonplan"))
            {
                Response.Redirect(string.Format("~/Pages/LessonPlans/LessonPlans.aspx?sc={0}", POD.Logic.Utilities.SetSearchFilter(this.SearchSideBar1.SearchParameters)));
            }
        }

        public void ShowWindow(string info)
        {
            RadWindow currentWindow = this.RadWindowManager.Windows[2];
            currentWindow.NavigateUrl = string.Format("~/Pages/ShowDuplicateStudents.aspx?pinf={0}", info);
            currentWindow.VisibleOnPageLoad = true;
        }

        /// <summary>
        /// call the save method
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void RadAjaxManager_AjaxRequest(object sender, AjaxRequestEventArgs e)
        {

            int personid = 0;
            int.TryParse(e.Argument, out personid);
            //set selected person id then continue to save
            if (this.Page is EnrollmentPage)
            {
                EnrollmentPage pg = (EnrollmentPage)this.Page;
                pg.SavePersonMatch(personid);
            }
            if (this.Page is RiskAssessmentPage)
            {
                RiskAssessmentPage pg = (RiskAssessmentPage)this.Page;
                pg.SavePersonMatch(personid);
            }
        }

        //public void ShowTransfer(int key)
        //{           
        //   // RadWindow transferwindow = this.RadWindowManager.Windows[0];
        //     this.ViewTransfer.NavigateUrl = string.Format("~/Pages/TransferYouthPage.aspx?pid={0}", key);
        //     this.ViewTransfer.VisibleOnPageLoad = true;
        //     this.ViewTransfer.VisibleStatusbar = false;
        //}

        //public void ShowRelease(int key, int enrollID)
        //{
        //    RadWindow transferwindow = this.RadWindowManager.Windows[0];
        //    transferwindow.NavigateUrl = string.Format("~/Pages/ReleaseYouthPage.aspx?pid={0}&eid={1}", key, enrollID);
        //    transferwindow.VisibleOnPageLoad = true;
        //    transferwindow.VisibleStatusbar = false;
        //}
    }
}