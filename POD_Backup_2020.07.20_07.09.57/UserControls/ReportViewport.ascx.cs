using System;
using System.Configuration;
using System.Web.UI;
using POD.Logic.Reporting;

namespace POD.UserControls
{
    public partial class ReportViewport : UserControl, IReportViewer
    {
        public string ReportName { get; set; }

        #region IReportViewer Members

        public void Render(IReportParametersContainer container)
        {
            if (string.IsNullOrEmpty(ReportName) == false)
            {
                MainReportViewer.ServerReport
                    .SetParameters(container.ReportParameters);
                MainReportViewer.ShowReportBody = true;
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

        public void Initialize()
        {
            string reportServerUserName = ConfigurationManager
                .AppSettings["ReportServerUserName"];
            string reportServerPassword = ConfigurationManager
                .AppSettings["ReportServerPassword"];
            string reportServerUrl = ConfigurationManager
                .AppSettings["ReportServerUrl"];
            string reportsBasePath = ConfigurationManager
                .AppSettings["ReportsBasePath"];

            MainReportViewer.ShowReportBody = false;
            MainReportViewer.ServerReport.ReportServerCredentials = 
                new ReportServerCredentials(reportServerUserName, reportServerPassword);
            MainReportViewer.ServerReport.ReportServerUrl = 
                new Uri(reportServerUrl);
            if (string.IsNullOrEmpty(ReportName) == false)
            {
                MainReportViewer.ServerReport.ReportPath = string.Format("{0}/{1}", reportsBasePath.TrimEnd('/'), ReportName.TrimStart('/'));
            }
        }
    }
}