using Microsoft.Reporting.WebForms;
using POD.Data.Entities;
using POD.Logic;
using POD.Logic.Reporting;
using System;
using System.Collections.Generic;
using System.Web.UI;
using Telerik.Web.UI;
using Telerik.Web.UI.Calendar;

namespace POD.Pages.Reporting
{
    public partial class EnrollmentNotesReport : Page, IReportParametersContainer
    {

        //protected int SiteId => Convert.ToInt32(Session["UsersSiteID"]);


        protected DateTime StartDate
        {
            get
            {
                return DatePickerStartDate.SelectedDate.HasValue
                           ? DatePickerStartDate.SelectedDate.Value.Date
                           : DateTime.MinValue;
            }
        }

        protected int SiteId
        {
            get
            {
                return DropDownSites.SelectedValue != null
                          ? Convert.ToInt32(DropDownSites.SelectedValue)
                          : Convert.ToInt32(Session["UsersSiteID"]);
            }
        }

        protected DateTime EndDate
        {
            get
            {
                return DatePickerEndDate.SelectedDate.HasValue
                           ? DatePickerEndDate.SelectedDate.Value.Date
                           : DateTime.MinValue;
            }
        }

        protected string NullIfEmpty(string str)
        {
            return string.IsNullOrEmpty(str) ? null : str;
        }



        #region IReportParametersContainer Members

        public IEnumerable<ReportParameter> ReportParameters
        {
            
            get {

                yield return new ReportParameter("startdate", StartDate.ToString("MM/dd/yyy"));
                yield return new ReportParameter("siteid", SiteId.ToString());
                yield return new ReportParameter("enddate", EndDate.ToString("MM/dd/yyy"));

                //yield return new ReportParameter("startdate", "04/01/2020");
                //yield return new ReportParameter("siteid", "1");
                //yield return new ReportParameter("enddate", "04/11/2020");

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

        protected void DatePickerStartDate_OnSelectedDateChanged(object sender, SelectedDateChangedEventArgs e)
        {
            int siteLocationId;
            if (e.NewDate != e.OldDate
                && Int32.TryParse(DropDownSites.SelectedValue, out siteLocationId)
                && siteLocationId > 0)
            {
                
            }
        }


        protected void DatePickerEndDate_OnSelectedDateChanged(object sender, SelectedDateChangedEventArgs e)
        {
            int siteLocationId;
            if (e.NewDate != e.OldDate
                && Int32.TryParse(DropDownSites.SelectedValue, out siteLocationId)
                && siteLocationId > 0)
            {
                
            }
        }

        protected void DatePickerStartDate_OnLoad(object sender, EventArgs e)
        {
            var dp = (RadDatePicker)sender;
            if (Page.IsPostBack == false)
            {
                dp.SelectedDate = DateTime.Now;
            }
        }

        protected void DropDownSites_OnSelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            int siteLocationId;
            if (e.OldValue != e.Value
                && Int32.TryParse(e.Value, out siteLocationId)
                && siteLocationId > 0)
            {
                
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
                DropDownSites_OnSelectedIndexChanged(sender, new RadComboBoxSelectedIndexChangedEventArgs(site.SiteName, null, siteId.ToString(), null));
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