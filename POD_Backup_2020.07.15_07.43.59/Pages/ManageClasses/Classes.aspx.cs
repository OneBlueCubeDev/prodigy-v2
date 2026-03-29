using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using POD.Data.Entities;
using POD.Logic;

namespace POD.Pages.ManageClasses
{
    public partial class Classes : System.Web.UI.Page
    {
        Dictionary<string, string> searchParm;
        protected void Page_Load(object sender, EventArgs e)
        {
            //LiteralErrorMessage.Text = string.Empty;
            if (!IsPostBack)
            {
                POD.MasterPages.Admin mtPage = (POD.MasterPages.Admin)this.Master;
                if (mtPage != null)
                {
                    mtPage.SetSearch("Class");
                    mtPage.SetNavigation("Class");
                }
                this.ClassesLinks1.SetVisibility(true, false);

                //only admin and central admins can delete
                //if (!Security.UserInRole("Administrators") && !Security.UserInRole("Administrators-NA") &&
                //    !Security.UserInRole("CentralTeamUsers"))
                //{
                //    RadMenuItem deleteItem = this.RadMenuOptions.Items.FindItemByValue("DeleteClass");
                //    if (deleteItem != null)
                //    {
                //        deleteItem.Visible = false;
                //    }
                //}
            }
        }


        /// <summary>
        /// returns data for grid filterd by parameters
        /// </summary>
        /// <param name="searchParm"></param>
        /// <returns></returns>
        private IEnumerable<CourseInstance> GetData()
        {
            //search parameters
            if (!string.IsNullOrEmpty(Request.QueryString["sc"]))
            {
                searchParm = POD.Logic.Utilities.GetSearchFilters(Request.QueryString["sc"].ToString(), "Class");
            }
            else
            {
                searchParm = POD.Logic.Utilities.SetDefaultSearchFilters("Class");
            }
            IEnumerable<CourseInstance> list = new List<CourseInstance>();
            // int? typeID = null;
            int? locID = null;

            string name = string.Empty;
            DateTime? startDate = null;
            DateTime? endDate = null;
            DateTime? startDate2 = null;
            DateTime? endDate2 = null;
            int? instructorID = null;
            int? assistantID = null;
            //if (searchParm["Type"] != "-1")
            //{
            //    typeID = int.Parse(searchParm["Type"].ToString());
            //}
            if (searchParm["Loc"] != "-1")
            {
                locID = int.Parse(searchParm["Loc"].ToString());
            }
            else if (!Security.UserInRole("Administrators") && !Security.UserInRole("CentralTeamUsers") && !Security.UserInRole("Administrators-NA"))
            {
                int siteid = 0;
                int.TryParse(Session["UsersSiteID"].ToString(), out siteid);
                locID = siteid;
            }
            if (searchParm["Name"] != "-1")
            {
                name = searchParm["Name"].ToString();
            }
            if (searchParm["Instructor"] != "-1")
            {
                instructorID = int.Parse(searchParm["Instructor"].ToString());
            }
            if (searchParm["Assistant"] != "-1")
            {
                assistantID = int.Parse(searchParm["Assistant"].ToString());
            }
            if (searchParm["RegStartDate"] != "-1")
            {
                startDate = DateTime.Parse(searchParm["RegStartDate"].ToString());
            }
            if (searchParm["RegEndDate"] != "-1")
            {
                endDate = DateTime.Parse(searchParm["RegEndDate"].ToString());
            }
            if (searchParm["RegStartDate2"] != "-1")
            {
                startDate2 = DateTime.Parse(searchParm["RegStartDate2"].ToString());
            }
            if (searchParm["RegEndDate2"] != "-1")
            {
                endDate2 = DateTime.Parse(searchParm["RegEndDate2"].ToString());
            }

            int programid = 0;
            int.TryParse(Session["ProgramID"].ToString(), out programid);

            list = POD.Logic.ProgramCourseClassLogic.GetCourseInstances(name, programid, locID, instructorID, assistantID, startDate, startDate2, endDate, endDate2);

            return list;

        }

        protected void RadMenu1_ItemClick(object sender, RadMenuEventArgs e)
        {
            int radGridClickedRowIndex;
            radGridClickedRowIndex = Convert.ToInt32(Request.Form["radGridClickedRowIndex"]);

            string url = string.Empty;
            switch (e.Item.Value)
            {
                case "CourseInstances":
                    string courseID = RadGridCourses.MasterTableView.DataKeyValues[radGridClickedRowIndex]["CourseID"].ToString();
                    url = string.Format("~/Pages/ManageClasses/ClassDetailPage.aspx?cid={0}", courseID);
                    break;
                case "DeleteClass":
                    int cID = 0;
                    string courseStringID = RadGridCourses.MasterTableView.DataKeyValues[radGridClickedRowIndex]["CourseInstanceID"].ToString();
                    int.TryParse(courseStringID, out cID);
                    POD.Logic.ProgramCourseClassLogic.DeleteCourseInstance(cID);
                    RadGridCourses.Rebind();
                    break;
                case "Registration":
                    string courseInstID = RadGridCourses.MasterTableView.DataKeyValues[radGridClickedRowIndex]["CourseInstanceID"].ToString();
                    string coursID = RadGridCourses.MasterTableView.DataKeyValues[radGridClickedRowIndex]["CourseID"].ToString();
                    url = string.Format("~/Pages/ManageClasses/ClassRegistration.aspx?cid={0}&clid={1}", coursID, courseInstID);
                    break;
            }
            if (!string.IsNullOrEmpty(url))
            {
                Response.Redirect(url);
            }

        }

        protected void RadGridCourses_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;

            grid.DataSource = GetData();
        }
    }
}