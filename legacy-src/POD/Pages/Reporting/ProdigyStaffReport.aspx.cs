using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using Microsoft.Reporting.WebForms;
using POD.Data.Entities;
using POD.Logic;
using POD.Logic.Reporting;
using Telerik.Web.UI;

namespace POD.Pages.Reporting
{
    public partial class ProdigyStaffReport : Page, IReportParametersContainer
    {
        protected DateTime MaxDate
        {
            get { return DatePickerToDate.SelectedDate ?? DateTime.MinValue; }
        }

        protected DateTime MinDate
        {
            get { return DatePickerFromDate.SelectedDate ?? DateTime.MinValue; }
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
                yield return new ReportParameter("siteLocationId", DropDownSites.SelectedValue);
                yield return new ReportParameter("locationId", DropDownLocation.SelectedValue);
                yield return new ReportParameter("instructorPersonId", value: null);
                yield return new ReportParameter("minDate", MinDate.ToShortDateString());
                yield return new ReportParameter("maxDate", MaxDate.ToShortDateString());
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

        protected void DatePicker_OnLoad(object sender, EventArgs e)
        {
            var dp = (RadDatePicker) sender;
            if (Page.IsPostBack == false)
            {
                dp.SelectedDate = DateTime.Now;
            }
        }

        protected void DropDownSites_OnSelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            DropDownLocation.ClearSelection();
            int siteLocationId;
            if (string.IsNullOrEmpty(DropDownSites.SelectedValue) == false
                && int.TryParse(DropDownSites.SelectedValue, out siteLocationId))
            {
                DropDownLocation.DataSource = LookUpTypesLogic.GetLocationsBySite(siteLocationId);
            }
            else
            {
                DropDownLocation.DataSource = Enumerable.Empty<Location>();
            }
            DropDownLocation.DataBind();
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
                DropDownSites_OnSelectedIndexChanged(this, null);
            }
        }

        protected void secureFilterSite_OnAuthorizationPassed(object sender, EventArgs e)
        {
            if (Page.IsPostBack == false)
            {
                DropDownSites.DataSource = LookUpTypesLogic.GetSites();
                DropDownSites.DataBind();
                DropDownSites_OnSelectedIndexChanged(this, null);
            }
        }
    }
}