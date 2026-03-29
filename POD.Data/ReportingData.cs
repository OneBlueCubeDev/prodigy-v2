using System.Collections.Generic;
using System.Linq;
using POD.Data.Entities;

namespace POD.Data
{
    public static class ReportingData
    {
        public static List<spGetMasterClassScheduleParameterLookupData_Result> GetMasterClassScheduleParameterLookupData(int programId)
        {
            using (var context = new PODContext())
            {
                return context.GetMasterClassScheduleParameterLookupData(programId)
                    .ToList();
            }
        }
    }
}