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
    public partial class ProdigyCollectiveStaffReport : Page, IReportParametersContainer
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
                yield return new ReportParameter("siteLocationId", string.IsNullOrEmpty(DropDownSites.SelectedValue)
                                                     ? null
                                                     : DropDownSites.SelectedValue);
                yield return new ReportParameter("locationId", value: null);
                yield return new ReportParameter("instructorPersonId", value: null);
                yield return new ReportParameter("minDate", MinDate.ToShortDateString());
                yield return new ReportParameter("maxDate", MaxDate.ToShortDateString());
                yield return new ReportParameter("programId", ProgramID);
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
            if (Security.UserInRole("Administrators") || !Security.UserInRole("CentralTeamUsers"))
            {
                this.DropDownSites.Items.Insert(0, new RadComboBoxItem("All", ""));
            }
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
    }
}