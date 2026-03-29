using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using POD.Data.Entities;
using Telerik.Web.UI;
using POD.Logic;

namespace POD.Pages
{
    public partial class Events : System.Web.UI.Page
    {
        Dictionary<string, string> searchParm;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                POD.MasterPages.Admin mtPage = (POD.MasterPages.Admin)this.Master;
                if (mtPage != null)
                {
                    mtPage.SetSearch("Event");
                    mtPage.SetNavigation("Event");
                }

                //only admin and central admins can delete
                if (!Security.UserInRole("Administrators") && 
                    !Security.UserInRole("CentralTeamUsers") && !Security.UserInRole("SiteTeamUsers"))
                {
                    RadMenuItem item = this.RadMenuOptions.Items.FindItemByValue("Delete");
                    if (item != null)
                    {
                        item.Visible = false;
                    }


                }
            }
        }
        /// <summary>
        /// returns data for grid filterd by parameters
        /// </summary>
        /// <param name="searchParm"></param>
        /// <returns></returns>
        private IEnumerable<Event> GetData()
        { //search parameters
            if (!string.IsNullOrEmpty(Request.QueryString["sc"]))
            {
                searchParm = POD.Logic.Utilities.GetSearchFilters(Request.QueryString["sc"].ToString(), "Event");
            }
            else
            {
                searchParm = POD.Logic.Utilities.SetDefaultSearchFilters("Event");
            }
            IEnumerable<Event> list = new List<Event>();
            int? typeID = null;
            int? locID = null;
            int? statusID = null;
            string name = string.Empty;
            DateTime? startDate = null;
            DateTime? endDate = null;
            DateTime? startDate2 = null;
            DateTime? endDate2 = null;
            if (searchParm["Type"] != "-1")
            {
                typeID = int.Parse(searchParm["Type"].ToString());
            }
            if (searchParm["Loc"] != "-1")
            {
                locID = int.Parse(searchParm["Loc"].ToString());
            }
            if (searchParm["Status"] != "-1")
            {
                statusID = int.Parse(searchParm["Status"].ToString());
            }
            if (searchParm["Name"] != "-1")
            {
                name = searchParm["Name"].ToString();
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
            int? siteid = null;
            if (!Security.UserInRole("Administrators") && !Security.UserInRole("Administrators-NA") && !Security.UserInRole("CentralTeamUsers"))
            {
                siteid = int.Parse(Session["UsersSiteID"].ToString());
            }
            list = POD.Logic.ProgramCourseClassLogic.GetEvents(name, programid, siteid, locID, typeID, statusID, startDate, startDate2, endDate, endDate2);

            return list;

        }
        protected void RadGridEvents_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            RadGrid evGrid = (RadGrid)sender;
            evGrid.DataSource = GetData();
        }

        protected void RadMenu1_ItemClick(object sender, Telerik.Web.UI.RadMenuEventArgs e)
        {
            int radGridClickedRowIndex;
            radGridClickedRowIndex = Convert.ToInt32(Request.Form["radGridClickedRowIndex"]);
            string url = string.Empty;

            string recID = RadGridEvents.MasterTableView.DataKeyValues[radGridClickedRowIndex]["EventID"].ToString();

            switch (e.Item.Value)
            {
                case "EditItem":
                    url = string.Format("~/Pages/EventPage.aspx?evid={0}", recID);

                    break;
                case "Delete":
                    if (!string.IsNullOrEmpty(recID))
                    {
                        POD.Logic.ProgramCourseClassLogic.DeleteEvent(int.Parse(recID));
                        RadGridEvents.Rebind();
                    }
                    break;
            }
            if (!string.IsNullOrEmpty(url))
            {
                Response.Redirect(url);
            }

        }
    }
}