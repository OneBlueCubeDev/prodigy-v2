using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using Microsoft.Reporting.WebForms;
using POD.Data.Entities;
using POD.Logic;
using POD.Logic.Reporting;
using Telerik.Web.UI;
using Telerik.Web.UI.Calendar;

namespace POD.Pages.Reporting
{
    public partial class MonthlyAttendanceReport : Page, IReportParametersContainer
    {
        protected DateTime TargetDate
        {
            get
            {
                return DatePickerTargetDate.SelectedDate.HasValue
                           ? DatePickerTargetDate.SelectedDate.Value.Date
                           : DateTime.MinValue;
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
                yield return new ReportParameter("courseInstanceId", DropDownCourseInstances.SelectedValue);
                yield return new ReportParameter("programId", ProgramID);
            }
        }

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        private IEnumerable GetCourseInstances(int siteLocationId)
        {
            return ProgramCourseClassLogic
                .GetCourseInstances(null, int.Parse(ProgramID),
                                    siteLocationId, null, null,
                                    null, null, null, null)
                .ToList()
                .Where(CourseIsWithinTargetDateBounds)
                .Select(x =>
                        new
                            {
                                Name = string.Format(
                                    "{0} ({1:MM/dd/syy} - {2:MM/dd/yy})",
                                    x.Course.Name,
                                    x.StartDate,
                                    x.EndDate),
                                x.CourseInstanceID
                            });
        }

        private bool CourseIsWithinTargetDateBounds(CourseInstance courseInstance)
        {
            if (TargetDate == DateTime.MinValue)
                return true;

           

            DateTime monthStartDate = TargetDate.Date.AddDays(-TargetDate.Day + 1);
            DateTime monthEndDate = monthStartDate.AddMonths(1).AddMilliseconds(-3);

            return courseInstance.StartDate != null
                   && courseInstance.EndDate != null
                   && courseInstance.StartDate.Value <= monthEndDate
                   && courseInstance.EndDate.Value >= monthStartDate;
        }

        protected void ButtonExecuteReport_OnClick(object sender, EventArgs e)
        {
            ReportViewport.Render(this);
        }

        protected void DropDownSites_OnSelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            int siteLocationId;
            if (e.OldValue != e.Value
                && Int32.TryParse(e.Value, out siteLocationId)
                && siteLocationId > 0)
            {
                DropDownCourseInstances.DataSource = GetCourseInstances(siteLocationId);
                DropDownCourseInstances.DataBind();
                DropDownCourseInstances.Items.Insert(0, new RadComboBoxItem(string.Empty, string.Empty));
            }
        }

        protected void DatePickerTargetDate_OnSelectedDateChanged(object sender, SelectedDateChangedEventArgs e)
        {
            int siteLocationId;
            if (e.NewDate != e.OldDate
                && Int32.TryParse(DropDownSites.SelectedValue, out siteLocationId)
                && siteLocationId > 0)
            {
                DropDownCourseInstances.DataSource = GetCourseInstances(siteLocationId);
                DropDownCourseInstances.DataBind();
                DropDownCourseInstances.Items.Insert(0, new RadComboBoxItem(string.Empty, string.Empty));
            }
        }

        protected void DatePickerTargetDate_OnLoad(object sender, EventArgs e)
        {
            var dp = (RadMonthYearPicker)sender;
            if (Page.IsPostBack == false)
            {
                dp.SelectedDate = DateTime.Now;
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