using System;
using System.Collections.Generic;
using System.Web.UI;
using Microsoft.Reporting.WebForms;
using POD.Logic;
using POD.Logic.Reporting;
using Telerik.Web.UI;

namespace POD.Pages.Reporting
{
    public partial class BulkEnrollmentExport : Page, IReportParametersContainer
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
                yield return new ReportParameter("GrantYear", RadComboBoxGrantYear.SelectedValue);
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
            if (!Page.IsPostBack)
            {
                Initialize();

                this.RadcbYouthtype.DataSource = POD.Logic.ManageTypesLogic.GetYouthTypes();
                this.RadcbYouthtype.DataBind();


                this.RadComboBoxGrantYear.DataSource = POD.Logic.ManageTypesLogic.GetGrantYears(Convert.ToInt32(RadcbYouthtype.SelectedItem.Value));
                this.RadComboBoxGrantYear.DataBind();

                RadComboBoxItem currentYear = RadComboBoxGrantYear.Items.FindItemByText(POD.Logic.ManageTypesLogic.GetCurrentGrantYear(Convert.ToInt32(RadcbYouthtype.SelectedItem.Value)));
                if (currentYear != null)
                {
                    currentYear.Selected = true;
                }
            }
        }

        protected void RadcbYouthtype_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            if (!string.IsNullOrEmpty(e.Value))
            {
                int youthtypeid = 0;
                int.TryParse(e.Value, out youthtypeid);
                this.RadComboBoxGrantYear.DataSource = POD.Logic.ManageTypesLogic.GetGrantYears(Convert.ToInt32(youthtypeid));
                this.RadComboBoxGrantYear.DataBind();

                RadComboBoxItem currentYear = RadComboBoxGrantYear.Items.FindItemByText(POD.Logic.ManageTypesLogic.GetCurrentGrantYear(Convert.ToInt32(youthtypeid)));
                if (currentYear != null)
                {
                    currentYear.Selected = true;
                }
            }
        }

        private void Initialize()
        {
            DropDownSites.DataSource = LookUpTypesLogic.GetSites();
            DropDownSites.DataBind();
        }

        protected void ButtonExecuteReport_OnClick(object sender, EventArgs e)
        {
            //ReportViewport.ReportName = DropDownReports.SelectedValue;
            //ReportViewport.Initialize();
            ReportViewport.Render(this);
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