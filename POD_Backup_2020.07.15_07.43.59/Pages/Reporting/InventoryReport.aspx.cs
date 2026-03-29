using Microsoft.Reporting.WebForms;
using POD.Logic;
using POD.Logic.Reporting;
using System;
using System.Collections.Generic;
using System.Web.UI;
using Telerik.Web.UI;

namespace POD.Pages.Reporting
{
    public partial class InventoryReport : Page, IReportParametersContainer
    {

        protected int SiteId => Convert.ToInt32(Session["UsersSiteID"]);
        
        protected string LocationId
        {
            get
            {
                if (string.IsNullOrEmpty(DropDownLocations.SelectedValue))
                {
                    return null;
                }

                return DropDownLocations.SelectedValue;
            }
        }

        

        #region IReportParametersContainer Members

        public IEnumerable<ReportParameter> ReportParameters
        {
            
            get {
                
                yield return new ReportParameter("locationId", string.IsNullOrEmpty(DropDownLocations.SelectedValue)
                                                     ? null
                                                     : DropDownLocations.SelectedValue);
                yield return new ReportParameter("siteid", SiteId.ToString());


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
                DropDownLocations.Items.Clear();
                DropDownLocations.DataSource = LookUpTypesLogic.GetLocationsBySite(siteId);
                DropDownLocations.DataBind();
                if (Security.UserInRole("SiteTeamUsers") || Security.UserInRole("Administrators") || !Security.UserInRole("CentralTeamUsers"))
                {
                    this.DropDownLocations.Items.Insert(0, new RadComboBoxItem("All", ""));
                }
            }
        }

        protected void secureFilterSite_OnAuthorizationPassed(object sender, EventArgs e)
        {
            if (Page.IsPostBack == false)
            {
                DropDownLocations.DataSource = LookUpTypesLogic.GetLocations();
                DropDownLocations.DataBind();
                if (Security.UserInRole("SiteTeamUsers") || Security.UserInRole("Administrators") || !Security.UserInRole("CentralTeamUsers"))
                {
                    this.DropDownLocations.Items.Insert(0, new RadComboBoxItem("All", ""));
                }
            }
        }
    }
}