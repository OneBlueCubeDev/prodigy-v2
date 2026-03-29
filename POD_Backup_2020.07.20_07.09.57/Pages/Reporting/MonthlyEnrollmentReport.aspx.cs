using System;
using System.Collections;
using System.Collections.Generic;
using System.Web.UI;
using Microsoft.Reporting.WebForms;
using POD.Data.Entities;
using POD.Logic;
using POD.Logic.Reporting;
using Telerik.Web.UI;

namespace POD.Pages.Reporting
{
    public partial class MonthlyEnrollmentReport : Page, IReportParametersContainer
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

        protected DateTime TargetDate
        {
            get
            {
                return DatePickerTargetDate.SelectedDate.HasValue
                           ? DatePickerTargetDate.SelectedDate.Value.Date
                           : DateTime.MinValue;
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
        }

        protected void ButtonExecuteReport_OnClick(object sender, EventArgs e)
        {
            ReportViewport.Render(this);
        }

        protected void DatePicker_OnLoad(object sender, EventArgs e)
        {
            var dp = (RadMonthYearPicker)sender;
            if (Page.IsPostBack == false)
            {
                dp.SelectedDate = DateTime.Now;

                // Must set a minimum date for this control.  The Risk Assessments have been removed
                // which invalidates all reports prior to this event.  So we must set a minimum date.
                // P.S. Owner requested this change backed out.
                //dp.MinDate = new DateTime(2014, 8, 1);
            }
        }

        protected void secureFilterSite_OnAuthorizationFailed(object sender, EventArgs e)
        {
            var siteId = Convert.ToInt32(Session["UsersSiteID"]);
            if (Page.IsPostBack == false)
            {
                DropDownSites.Items.Clear();
                Site site = LookUpTypesLogic.GetSiteByID(siteId);
                DropDownSites.DataSource = new[] { site };
                DropDownSites.DataBind();
                
                
            }
        }

        protected void secureFilterSite_OnAuthorizationPassed(object sender, EventArgs e)
        {
            if (Page.IsPostBack == false)
            {
                DropDownSites.DataSource = LookUpTypesLogic.GetSites();
                DropDownSites.DataBind();
                if (Security.UserInRole("Administrators") || !Security.UserInRole("CentralTeamUsers"))
                {
                    this.DropDownSites.Items.Insert(0, new RadComboBoxItem("All", ""));
                }
            }
        }
    }
}