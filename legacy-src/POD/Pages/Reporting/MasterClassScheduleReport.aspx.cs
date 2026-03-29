using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using Microsoft.Reporting.WebForms;
using POD.Logic;
using POD.Logic.Reporting;
using POD.Logic.Reporting.Custom;

namespace POD.Pages.Reporting
{
    public partial class MasterClassScheduleReport : Page, IReportParametersContainer
    {
        protected string[] ClassDays
        {
            get { return DropDownClassDays.CheckedItems.Select(x => x.Value).ToArray(); }
        }

        protected DateTime? EndDate
        {
            get { return DatePickerEndDate.SelectedDate; }
        }

        protected DateTime? StartDate
        {
            get { return DatePickerStartDate.SelectedDate; }
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
                yield return new ReportParameter("startDate", StartDate == null ? null : StartDate.Value.ToShortDateString());
                yield return new ReportParameter("endDate", EndDate == null ? null : EndDate.Value.ToShortDateString());
                yield return new ReportParameter("siteLocationId", NullIfEmpty(DropDownSite.SelectedValue));
                yield return new ReportParameter("classDays", NullIfEmpty(string.Join(",", ClassDays)));
                yield return new ReportParameter("classHour", NullIfEmpty(DropDownTime.SelectedValue));
                //yield return new ReportParameter("locationId", NullIfEmpty(DropDownProgrammingLocation.SelectedValue));
                yield return new ReportParameter("courseTypeId", NullIfEmpty(DropDownClassType.SelectedValue));
                yield return new ReportParameter("courseId", NullIfEmpty(DropDownClassName.SelectedValue));
                yield return new ReportParameter("ageGroupId", NullIfEmpty(DropDownAge.SelectedValue));
                yield return new ReportParameter("instructorPersonId", NullIfEmpty(DropDownInstructor.SelectedValue));
                
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
            int programId;
            if (int.TryParse(ProgramID, out programId))
            {
                MasterClassScheduleReportParameters data =
                    LookUpTypesLogic.GetMasterClassScheduleReportParameters(programId);
                DropDownSite.DataSource = data.Sites;
                DropDownSite.DataBind();

                //DropDownProgrammingLocation.DataSource = data.ProgrammingLocations;
                //DropDownProgrammingLocation.DataBind();

                DropDownClassType.DataSource = data.ClassTypes;
                DropDownClassType.DataBind();

                DropDownClassName.DataSource = data.Classes;
                DropDownClassName.DataBind();

                DropDownAge.DataSource = data.Ages;
                DropDownAge.DataBind();

                DropDownTime.DataSource = data.Times;
                DropDownTime.DataBind();

                DropDownInstructor.DataSource = data.Instructors;
                DropDownInstructor.DataBind();
            }
        }

        protected string NullIfEmpty(string str)
        {
            return string.IsNullOrEmpty(str) ? null : str;
        }

        protected void ButtonExecuteReport_OnClick(object sender, EventArgs e)
        {
            ReportViewport.Render(this);
        }
    }
}