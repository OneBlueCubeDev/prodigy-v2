using Microsoft.Reporting.WebForms;
using POD.Logic;
using POD.Logic.Reporting;
using System;
using System.Collections.Generic;
using System.Web.UI;

namespace POD.Pages.Reporting
{
    public partial class StaffVerificationReport : Page, IReportParametersContainer
    {
        #region IReportParametersContainer Members

        public IEnumerable<ReportParameter> ReportParameters
        {
            get
            {
                yield return new ReportParameter("organization",
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

        protected void secureFilterSite_OnAuthorizationFailed(object sender, EventArgs e)
        {
            var siteId = Convert.ToInt32(Session["UsersSiteID"]);
            if (Page.IsPostBack == false)
            {
                DropDownSites.Items.Clear();
                var site = LookUpTypesLogic.GetSiteByID(siteId);
                DropDownSites.DataSource = site;
                DropDownSites.DataBind();
            }
        }

        protected void secureFilterSite_OnAuthorizationPassed(object sender, EventArgs e)
        {
            if (Page.IsPostBack == false)
            {
                var sitelist = LookUpTypesLogic.GetSites(); //LookUpTypesLogic.GetSites().Select(x => x.Organization).Distinct();
                DropDownSites.DataSource = sitelist;
                DropDownSites.DataBind();
            }
        }
    }
}