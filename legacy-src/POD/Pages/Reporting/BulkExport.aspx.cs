using System;
using System.Collections.Generic;
using System.Web.UI;
using Microsoft.Reporting.WebForms;
using POD.Logic;
using POD.Logic.Reporting;

namespace POD.Pages.Reporting
{
    public partial class BulkExport : Page, IReportParametersContainer
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
            get { yield break; }
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
        }

        protected void ButtonExecuteReport_OnClick(object sender, EventArgs e)
        {
            ReportViewport.ReportName = DropDownReports.SelectedValue;
            ReportViewport.Initialize();
            ReportViewport.Render(this);
        }
    }
}