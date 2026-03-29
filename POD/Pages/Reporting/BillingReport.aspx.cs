using System;
using System.Collections.Generic;
using System.Web.UI;
using Microsoft.Reporting.WebForms;
using POD.Logic;
using POD.Logic.Reporting;

namespace POD.Pages.Reporting
{
    public partial class BillingReport : Page, IReportParametersContainer
    {
        protected DateTime TargetDate
        {
            get
            {
                return DatePickerTargetDate.SelectedDate ?? DateTime.MinValue;
            }
        }

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
                yield return new ReportParameter("targetDate", TargetDate.ToShortDateString());
                yield return new ReportParameter("programId", ProgramID);
                yield return new ReportParameter("siteLocationId",
                                                 string.IsNullOrEmpty(DropDownSites.SelectedValue)
                                                     ? null
                                                     : DropDownSites.SelectedValue);
            }
        }

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Page.IsPostBack == false)
            {
                Initialize();
            }
        }

        private void Initialize()
        {
            DropDownSites.DataSource = LookUpTypesLogic.GetSites();
            DropDownSites.DataBind();
        }

        protected void ButtonExecuteReport_OnClick(object sender, EventArgs e)
        {
            ReportViewport.Render(this);
        }

        protected void DatePickerTargetDate_OnLoad(object sender, EventArgs e)
        {
            if (Page.IsPostBack == false)
            {
                DatePickerTargetDate.SelectedDate = DateTime.Now;
                // Must set a minimum date for this control.  The Risk Assessments have been removed
                // which invalidates all reports prior to this event.  So we must set a minimum date.
                //DatePickerTargetDate.MinDate = new DateTime(2014, 8, 1);
            }
        }

        protected void secureFilterSite_OnAuthorizationFailed(object sender, EventArgs e)
        {
            var siteId = Session["UsersSiteID"].ToString();
            var item = DropDownSites.FindItemByValue(siteId);
            if (item != null)
            {
                item.Selected = true;
            }
            else
            {
                throw new SiteNotFoundException(siteId);
            }
        }
    }
}