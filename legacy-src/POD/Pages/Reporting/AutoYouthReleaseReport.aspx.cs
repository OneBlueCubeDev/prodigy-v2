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
    public partial class AutoYouthReleaseReport : Page, IReportParametersContainer
    {
        //protected DateTime MaxDate
        //{
        //    get { return DatePickerToDate.SelectedDate ?? DateTime.MinValue; }
        //}

        //protected DateTime MinDate
        //{
        //    get { return DatePickerFromDate.SelectedDate ?? DateTime.MinValue; }
        //}

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
                yield return new ReportParameter("selecteddate", DatePickerTargetDate.SelectedDate.ToString());
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
            if (!IsPostBack)
            {

                this.RadcbYouthtype.DataSource = POD.Logic.ManageTypesLogic.GetYouthTypes();
                this.RadcbYouthtype.DataBind();


                ////grant year
                //this.RadComboBoxGrantYear.DataSource = POD.Logic.ManageTypesLogic.GetGrantYears();
                //this.RadComboBoxGrantYear.DataBind();

                //RadComboBoxItem currentYear = RadComboBoxGrantYear.Items.FindItemByText(POD.Logic.ManageTypesLogic.GetCurrentGrantYear());
                //if (currentYear != null)
                //{
                //    currentYear.Selected = true;
                //}
            }
        }

        protected void RadcbYouthtype_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            //if (!string.IsNullOrEmpty(e.Value))
            //{
            //    int youthtypeid = 0;
            //    int.TryParse(e.Value, out youthtypeid);
            //    this.RadComboBoxGrantYear.DataSource = POD.Logic.ManageTypesLogic.GetGrantYears(Convert.ToInt32(youthtypeid));
            //    this.RadComboBoxGrantYear.DataBind();

            //    RadComboBoxItem currentYear = RadComboBoxGrantYear.Items.FindItemByText(POD.Logic.ManageTypesLogic.GetCurrentGrantYear(Convert.ToInt32(youthtypeid)));
            //    if (currentYear != null)
            //    {
            //        currentYear.Selected = true;
            //    }
            //}
        }

        protected void ButtonExecuteReport_OnClick(object sender, EventArgs e)
        {

            ReportViewport.Render(this);
        }

        //protected void DatePicker_OnLoad(object sender, EventArgs e)
        //{
        //    var dp = (RadDatePicker) sender;
        //    if (Page.IsPostBack == false)
        //    {
        //        dp.SelectedDate = DateTime.Now;
        //        // Must set a minimum date for this control.  The Risk Assessments have been removed
        //        // which invalidates all reports prior to this event.  So we must set a minimum date.
        //        // P.S.  User requested this change be backed out.
        //        //dp.MinDate = new DateTime(2014, 8, 1);

        //    }
        //}

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
            }
        }
    }
}