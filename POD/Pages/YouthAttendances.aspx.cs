using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using POD.Data.Entities;
using Telerik.Web.UI;

namespace POD.Pages
{
    public partial class EventAttendances : System.Web.UI.Page
    {
        private int personid = 0;
        public int PersonID
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
                    mtPage.SetSearch("Enrollment");
                    mtPage.SetNavigation("Enrollment");
                }

                if (!string.IsNullOrEmpty(Request.QueryString["id"]))
                {
                    int.TryParse(Request.QueryString["id"].ToString(), out personid);
                    PersonID = personid;
                }
                RadGriAttendances.DataBind();
            }
        }
        /// <summary>
        /// returns data for grid filterd by parameters
        /// </summary>
        /// <param name="searchParm"></param>
        /// <returns></returns>
        private List<sp_GetPersonAttendanceAndEvents_Result> GetData()
        {
            int progID = 0;
            int.TryParse(Session["ProgramID"].ToString(), out progID);
            List<sp_GetPersonAttendanceAndEvents_Result> list = new List<sp_GetPersonAttendanceAndEvents_Result>();
            if (PersonID != 0)
            {
                list = POD.Logic.PersonRelatedLogic.GetAttendanceByPerson(progID, PersonID);
            }
            if (list.Count > 0)
            {
                sp_GetPersonAttendanceAndEvents_Result res = list.FirstOrDefault();
                if (res != null)
                {
                    this.LiteralHeader.Text = string.Format("Attendances for {0}  {1}", res.FirstName, res.LastName);
                }
            }
            else {
                Person currentPerson = POD.Logic.PeopleLogic.GetPersonByID(PersonID);
                if (currentPerson != null)
                {
                    this.LiteralHeader.Text = string.Format("Attendances for {0}  {1}", currentPerson.FirstName, currentPerson.LastName);
                }
            }
            return list;

        }

        protected void RadGriAttendances_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            RadGrid evGrid = (RadGrid)sender;
            evGrid.DataSource = GetData();
        }
    }
}