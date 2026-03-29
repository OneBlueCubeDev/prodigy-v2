using System;
using System.Collections.Generic;
using System.Web.UI;
using Microsoft.Reporting.WebForms;
using POD.Logic;
using POD.Logic.Reporting;
using Telerik.Web.UI;

namespace POD.Pages.Reporting
{
    public partial class ProdigyEnrollmentReport : Page, IReportParametersContainer
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
            }
        }
    }
}