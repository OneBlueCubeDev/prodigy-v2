using System.Collections.Generic;
using Microsoft.Reporting.WebForms;

namespace POD.Logic.Reporting
{
    public interface IReportParametersContainer
    {
        IEnumerable<ReportParameter> ReportParameters { get; }
    }
}