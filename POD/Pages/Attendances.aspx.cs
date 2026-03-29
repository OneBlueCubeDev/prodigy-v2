using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using POD.Data.Entities;
using POD.Logic;

namespace POD.Pages
{
    public partial class Attendances : System.Web.UI.Page
    {
        Dictionary<string, string> searchParm;
        private int personid = 0;
        private int PersonID
        {
            get
            {
                if (ViewState["PersonID"] != null)
                {
                    int.TryParse(ViewState["PersonID"].ToString(), out personid);
                }
                return personid;
            }
            set
            {
                ViewState["PersonID"] = value;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                POD.MasterPages.Admin mtPage = (POD.MasterPages.Admin)this.Master;
                if (mtPage != null)
                {
                    mtPage.SetSearch("Attendance");
                    mtPage.SetNavigation("Attendance");
                }
                //personid 
                if (!string.IsNullOrEmpty(Request.QueryString["id"]))
                {
                    int.TryParse(Request.QueryString["id"].ToString(), out personid);
                    PersonID = personid;
                }
            }
        }

        /// <summary>
        /// returns data for grid filterd by parameters
        /// </summary>
        /// <param name="searchParm"></param>
        /// <returns></returns>
        private IEnumerable<sp_GetClassessAndEvents_Result> GetData()
        {  //search parameters
            if (!string.IsNullOrEmpty(Request.QueryString["sc"]))
            {
                searchParm = POD.Logic.Utilities.GetSearchFilters(Request.QueryString["sc"].ToString(), "Attendance");
            }
            else
            {
                searchParm = POD.Logic.Utilities.SetDefaultSearchFilters("Attendance");
            }
            IEnumerable<sp_GetClassessAndEvents_Result> list = new List<sp_GetClassessAndEvents_Result>();
            int? siteID = null;
            int? locID = null;
            int? classid = null;
            int? eventid = null;
            DateTime? startDate = null;
            DateTime? endDate = null;
            if (searchParm["Site"] != "-1")
            {
                siteID = int.Parse(searchParm["Site"].ToString());
            }
            else if (!Security.UserInRole("Administrators") && !Security.UserInRole("Administrators-NA") && !Security.UserInRole("CentralTeamUsers"))
            {
                siteID = int.Parse(Session["UsersSiteID"].ToString());
            }
            if (searchParm["Loc"] != "-1")
            {
                locID = int.Parse(searchParm["Loc"].ToString());
            }

            if (searchParm["Class"] != "-1")
            {
                classid = int.Parse(searchParm["Class"].ToString());
            }
            if (searchParm["Event"] != "-1")
            {
                eventid = int.Parse(searchParm["Event"].ToString());
            }
            if (searchParm["RegStartDate"] != "-1")
            {
                startDate = DateTime.Parse(searchParm["RegStartDate"].ToString());
            }
            //if(searchParm["RegEndDate"] != "11")
            //{
            //    if (searchParm["RegEndDate"] != "-1")
            //    {
            //        endDate = DateTime.Parse(searchParm["RegEndDate"].ToString());
            //    }
            //}
            
            int programid = 0;
            int.TryParse(Session["ProgramID"].ToString(), out programid);
            list = POD.Logic.ProgramCourseClassLogic.GetAttendancesAndEvents(programid, searchParm["Name"] != "-1" ? searchParm["Name"].ToString() : null,
                                                                                siteID, locID, classid, eventid, startDate, endDate);
            
            return list;

        }

        protected void RadGridAttendance_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            RadGrid attendance = (RadGrid)sender;
            attendance.DataSource = GetData();
        } 
    }
}