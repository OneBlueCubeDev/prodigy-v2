using System;
using System.Collections.Generic;
using System.Web.UI;
using Microsoft.Reporting.WebForms;
using POD.Data.Entities;
using POD.Logic;
using POD.Logic.Reporting;

namespace POD.Pages.Reporting
{
    public partial class MonthlyNonAttendanceReport : Page, IReportParametersContainer
    {
        protected string ProgramID
        {
            get
            {
                return Session["ProgramID"] != null
                           ? Session["ProgramID"].ToString()
                           : "1";
            }
        }

        #region IReportParametersContainer Members

        public IEnumerable<ReportParameter> ReportParameters
        {
            get
            {
                DateTime maxDate = DateTime.Today;
                DateTime minDate = maxDate.AddYears(-1);
                yield return new ReportParameter("minDate", minDate.ToShortDateString());
                yield return new ReportParameter("maxDate", maxDate.ToShortDateString());
                yield return new ReportParameter("minDays", DropDownDays.SelectedValue);
                yield return new ReportParameter("siteLocationId", DropDownSites.SelectedValue);
                yield return new ReportParameter("programId", ProgramID);
            }
        }

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void ButtonExecuteReport_OnClick(object sender, EventArgs e)
        {
            ReportViewport.Render(this);
        }

        protected void secureFilterSite_OnAuthorizationFailed(object sender, EventArgs e)
        {
            int siteId = Convert.ToInt32(Session["UsersSiteID"]);
            if (Page.IsPostBack == false)
            {
                DropDownSites.Items.Clear();
                Site site = LookUpTypesLogic.GetSiteByID(siteId);
                DropDownSites.DataSource = new[] {site};
                DropDownSites.DataBind();
            }
        }

        protected void secureFilterSite_OnAuthorizationPassed(object sender, EventArgs e)
        {
            if (Page.IsPostBack == false)
            {
                DropDownSites.DataSource = LookUpTypesLogic.GetSites();
                DropDownSites.DataBind();
            }
        }
    }
}