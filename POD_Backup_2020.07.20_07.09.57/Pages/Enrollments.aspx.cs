using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using POD.Data.Entities;
using POD.Logic;

using System.Configuration;

namespace POD.Pages
{
    public partial class Enrollments : System.Web.UI.Page
    {
        string enrollmentType = string.Empty;
        int statusTypeid = 0;
        int enrollTypeID = 0;
        Dictionary<string, string> searchParm;
        protected void Page_Load(object sender, EventArgs e)
        {
            //hide appropriate button and set status
            if (!string.IsNullOrEmpty(Request.QueryString["status"]) && Request.QueryString["status"].ToString() == "0")
            {
                statusTypeid = POD.Logic.ManageTypesLogic.GetStatusTypeIDByName("inactive");
                this.EnrollmentLinks1.ShowButtons(2);
            }
            else if (!string.IsNullOrEmpty(Request.QueryString["status"]) && Request.QueryString["status"].ToString() == "1")
            {
                statusTypeid = POD.Logic.ManageTypesLogic.GetStatusTypeIDByName("enrolled");
                this.EnrollmentLinks1.ShowButtons(3);
            }
            else if (!string.IsNullOrEmpty(Request.QueryString["status"]) && Request.QueryString["status"].ToString() == "2")
            {
                statusTypeid = POD.Logic.ManageTypesLogic.GetStatusTypeIDByName("rollover");
                this.EnrollmentLinks1.ShowButtons(4);
            }
            else if (!string.IsNullOrEmpty(Request.QueryString["erid"]) && Request.QueryString["erid"].ToString().ToLower() == "diversion youth")
            {
                //statusTypeid = POD.Logic.ManageTypesLogic.GetStatusTypeIDByName("enrolled");
                this.EnrollmentLinks1.ShowButtons(5);
            }

            if (!IsPostBack)
            {
                POD.MasterPages.Admin mtPage = (POD.MasterPages.Admin)this.Master;
                if (mtPage != null)
                {
                    mtPage.SetSearch("Enrollment");
                    mtPage.SetNavigation("Youth");
                }

                if (!string.IsNullOrEmpty(Request.QueryString["erid"]))
                {
                    enrollmentType = Request.QueryString["erid"].ToString().ToLower();
                    enrollTypeID = POD.Logic.ManageTypesLogic.GetEnrollmentTypeIDByName(enrollmentType);
                }

                //only admin and central admins can delete
                if (!Security.UserInRole("Administrators") && !Security.UserInRole("Administrators-NA") &&
                    !Security.UserInRole("CentralTeamUsers") && !Security.UserInRole("SiteTeamUsers") && !Security.UserInRole("SiteTeamUsers-NA"))
                {
                    this.RadMenuOptions.Visible = false;
                    this.RadMenuOptionsInactive.Visible = false;
                }
                else if (!Security.UserInRole("Administrators") && !Security.UserInRole("CentralTeamUsers") && !Security.UserInRole("SiteTeamUsers"))
                {
                    //active menu
                    RadMenuItem item = this.RadMenuOptions.Items.FindItemByValue("Transfer");
                    if (item != null)
                    {
                        item.Visible = false;
                    }
                    item = this.RadMenuOptions.Items.FindItemByValue("Release");
                    if (item != null)
                    {
                        item.Visible = false;
                    }
                    item = this.RadMenuOptions.Items.FindItemByValue("CompletionCertificate");
                    if (item != null)
                    {
                        item.Visible = false;
                    }
                    item = this.RadMenuOptions.Items.FindItemByValue("Delete");
                    if (item != null)
                    {
                        item.Visible = false;
                    }
                    item = this.RadMenuOptions.Items.FindItemByValue("Rollover");
                    if (item != null)
                    {
                        item.Visible = false;
                    }

                    //inactive menu
                    item = this.RadMenuOptionsInactive.Items.FindItemByValue("ReEnrollment");
                    if (item != null)
                    {
                        item.Visible = false;
                    }
                    item = this.RadMenuOptionsInactive.Items.FindItemByValue("Rollover");
                    if (item != null)
                    {
                        item.Visible = false;
                    }
                    item = this.RadMenuOptionsInactive.Items.FindItemByValue("Delete");
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
        private List<sp_GetPersonEnrollments_Result> GetData()
        {
             if (!string.IsNullOrEmpty(Request.QueryString["sc"]))
            {
                searchParm = POD.Logic.Utilities.GetSearchFilters(Request.QueryString["sc"].ToString(), "Enrollment");
            }
            else
            {
                searchParm = POD.Logic.Utilities.SetDefaultSearchFilters("Enrollment");
            }
            List<sp_GetPersonEnrollments_Result> list = new List<sp_GetPersonEnrollments_Result>();
            int? typeid = null;
            int? statusid = null;
            int? grantYearID = null;
            DateTime? startDate = null;
            DateTime? endDate = null;
            if (searchParm["Type"] != "-1")
            {
                typeid = int.Parse(searchParm["Type"].ToString());
                if (typeid == 3)//diversion
                {
                    this.EnrollmentLinks1.ShowButtons(5);
                }

            }
            else if (enrollTypeID != 0)//check if we have query string 
            {
                typeid = enrollTypeID;
            }
            if (searchParm["Status"] != "-1")
            {
                statusid = int.Parse(searchParm["Status"].ToString());
            }
            else if (statusTypeid != 0)//check if we have query string
            {
                statusid = statusTypeid;
            }
            if (searchParm["Year"] != "-1")
            {
                grantYearID = int.Parse(searchParm["Year"].ToString());
            }
            if (searchParm["RegStartDate"] != "-1")
            {
                startDate = DateTime.Parse(searchParm["RegStartDate"].ToString());
            }
            if (searchParm["RegEndDate"] != "-1")
            {
                endDate = DateTime.Parse(searchParm["RegEndDate"].ToString());
            }
            int? siteid = null;
            if (!Security.UserInRole("Administrators") && !Security.UserInRole("Administrators-NA") && !Security.UserInRole("CentralTeamUsers"))
            {
                siteid = int.Parse(Session["UsersSiteID"].ToString());
            }
            int programid = 0;
            int.TryParse(Session["ProgramID"].ToString(), out programid);
            list = POD.Logic.PeopleLogic.GetPersonBySearch(programid, siteid, grantYearID, searchParm["Name"] != "-1" ? searchParm["Name"].ToString() : null, searchParm["Guardian"] != "-1" ? searchParm["Guardian"].ToString() : null,
                                                                searchParm["Zip"] != "-1" ? searchParm["Zip"].ToString() : null, searchParm["School"] != "-1" ? searchParm["School"].ToString() : null,
                                                                typeid, statusid, startDate, endDate, searchParm["Race"] != "-1" ? searchParm["Race"].ToString() : string.Empty, searchParm["DJJ"] != "-1" ? searchParm["DJJ"].ToString() : null);



            return list;

        }

        /// <summary>
        /// redirect to action page or delete
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void RadMenu1_ItemClick(object sender, RadMenuEventArgs e)
        {
            int radGridClickedRowIndex;
            POD.MasterPages.Admin mtPage = (POD.MasterPages.Admin)this.Master;
            radGridClickedRowIndex = Convert.ToInt32(Request.Form["radGridClickedRowIndex"]);
            string personID = RadGridEnrollments.MasterTableView.DataKeyValues[radGridClickedRowIndex]["PersonID"].ToString();
            string enrollmentID = RadGridEnrollments.MasterTableView.DataKeyValues[radGridClickedRowIndex]["EnrollmentID"].ToString();
            string enrollmentType = RadGridEnrollments.MasterTableView.DataKeyValues[radGridClickedRowIndex]["EnrollmentTypeName"].ToString();

            string url = string.Empty;
            switch (e.Item.Value)
            {
                case "Rollover":
                    url = string.Format("~/Pages/EnrollmentPage.aspx?id={0}&ro=1&eid={1}", personID, enrollmentID);
                    break;
                case "ReEnrollment":
                    url = string.Format("~/Pages/EnrollmentPage.aspx?id={0}", personID);
                    break;
                case "Enrollment":
                    if (enrollmentType == "Risk Assessment")
                    {
                        url = string.Format("~/Pages/EnrollmentPage.aspx?id={0}&rid={1}", personID, enrollmentID);
                    }
                    else
                    {
                        url = string.Format("~/Pages/EnrollmentPage.aspx?id={0}&eid={1}", personID, enrollmentID);
                    }
                    break;
                case "PAT":
                    url = string.Format("~/Pages/PATForms.aspx?id={0}", personID);
                    break;
                case "RiskAssessment":
                    if (enrollmentType == "Risk Assessment")
                    {
                        url = string.Format("~/Pages/RiskAssessmentPage.aspx?pid={0}&rid={1}", personID, enrollmentID);
                    }
                    else
                    {
                        url = string.Format("~/Pages/RiskAssessmentPage.aspx?pid={0}&eid={1}", personID, enrollmentID);
                    }
                    break;
                case "Attendance":
                    url = string.Format("~/Pages/YouthAttendances.aspx?id={0}", personID);
                    break;
                case "Transfer":
                    break;
                case "Release":
                    break;
                case "CompletionCertificate":
                    break;
                case "Delete":
                    if (enrollmentType == "Risk Assessment")
                    {
                        int eID = 0;
                        int.TryParse(enrollmentID, out eID);
                        string result = POD.Logic.PersonRelatedLogic.DeleteRiskAssessment(eID);
                        if (string.IsNullOrEmpty(result))
                        {
                            RadGridEnrollments.Rebind();
                        }
                    }
                    else if (!string.IsNullOrEmpty(enrollmentID))
                    {
                        int eID = 0;
                        int.TryParse(enrollmentID, out eID);
                        string result = POD.Logic.PersonRelatedLogic.DeleteEnrollment(eID);
                        if (string.IsNullOrEmpty(result))
                        {
                            RadGridEnrollments.Rebind();
                        }
                    }
                    break;
            }
            if (!string.IsNullOrEmpty(url))
            {
                Response.Redirect(url);
            }
        }

        /// <summary>
        /// binds data
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void RadGridEnrollments_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            RadGridEnrollments.DataSource = GetData();
        }


    }
}