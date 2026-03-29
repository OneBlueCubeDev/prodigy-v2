using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using POD.Data;
using POD.Data.Entities;
using POD.Logic.Reporting.Support;

namespace POD.Logic.Reporting.Custom
{
    public class MasterClassScheduleReportParameters
    {
        private readonly ReadOnlyCollection<AgeGroup> _ageData;
        private readonly ReadOnlyCollection<spGetMasterClassScheduleParameterLookupData_Result> _data;
        private readonly IEqualityComparer<KeyValuePair<int, string>> _comparer;

        public MasterClassScheduleReportParameters(IEnumerable<spGetMasterClassScheduleParameterLookupData_Result> data)
        {
            _data = data.ToList().AsReadOnly();
            _ageData = TypesData.GetAgeGroups().AsReadOnly();

            _comparer = new GenericEqualityComparer<KeyValuePair<int, string>>(
                (a, b) => a.Key == b.Key,
                x => x.Key.GetHashCode());
        }

        public Dictionary<int, string> Sites
        {
            get
            {
                return _data
                    .Where(x => x.SiteLocationID != null)
                    .Select(x => new KeyValuePair<int, string>(x.SiteLocationID.Value, x.SiteLocationName))
                    .Distinct(_comparer)
                    .OrderBy(x => x.Value)
                    .ToDictionary(x => x.Key, x => x.Value);
            }
        }

        public Dictionary<int, string> ProgrammingLocations
        {
            get
            {
                return _data
                    .Where(x => x.ScheduledSpecificLocationID != null)
                    .Select(
                        x => new KeyValuePair<int, string>(
                            x.ScheduledSpecificLocationID.Value,
                            x.ScheduledSpecificLocationName))
                    .Distinct(_comparer)
                    .OrderBy(x => x.Value)
                    .ToDictionary(x => x.Key, x => x.Value);
            }
        }

        public Dictionary<int, string> ClassTypes
        {
            get
            {
                return _data
                    .Select(x => new KeyValuePair<int, string>(x.CourseTypeID, x.CourseTypeName))
                    .Distinct(_comparer)
                    .OrderBy(x => x.Value)
                    .ToDictionary(x => x.Key, x => x.Value);
            }
        }

        public Dictionary<int, string> Classes
        {
            get
            {
                return _data
                    .Select(x => new KeyValuePair<int, string>(x.CourseID, x.CourseName))
                    .Distinct(_comparer)
                    .OrderBy(x => x.Value)
                    .ToDictionary(x => x.Key, x => x.Value);
            }
        }

        public Dictionary<int, string> Ages
        {
            get
            {
                return _ageData
                    .OrderBy(x => x.AgeGroupID)
                    .ToDictionary(x => x.AgeGroupID, x => x.Name);
            }
        }

        public Dictionary<int, string> Times
        {
            get
            {
                return _data
                    .Where(x => x.ClassTime != null)
                    .Select(x => new KeyValuePair<int, string>(x.ClassTime.Value, DateTime.Today.AddHours(x.ClassTime.Value).ToString("h tt")))
                    .Distinct(_comparer)
                    .OrderBy(x => x.Key)
                    .ToDictionary(x => x.Key, x => x.Value);
            }
        }

        public Dictionary<int, string> Instructors
        {
            get
            {
                return _data
                    .Select(x => new KeyValuePair<int, string>(x.InstructorPersonID, string.Format("{0} {1}", x.InstructorFirstName, x.InstructorLastName)))
                    .Distinct(_comparer)
                    .OrderBy(x => x.Value)
                    .ToDictionary(x => x.Key, x => x.Value);
            }
        }
    }
}