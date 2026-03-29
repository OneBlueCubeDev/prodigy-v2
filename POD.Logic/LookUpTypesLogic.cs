using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using POD.Data;
using POD.Data.Entities;
using POD.Logic.Reporting.Custom;

namespace POD.Logic
{
    public static class LookUpTypesLogic
    {
        #region Event Categories

        public static List<EventCategory> GetEventCategoriesByEventType(int eventTypeId)
        {
            return EventData.GetEventCategoriesByEventType(eventTypeId);
        }

        public static EventCategory GetEventCategoryByID(int eventCategoryID)
        {
            return EventData.GetEventCategoryByID(eventCategoryID);
        }

        #endregion
        
        #region Race

        public static List<Race> GetRaces()
        {
            List<Race> tempRaces = new List<Race>();
            tempRaces = POD.Data.LookUpTypesData.GetRaces();

            List<int> preferences = new List<int> { 3, 4, 1, 2, 6 };

            IEnumerable<Race> orderedData = tempRaces.OrderBy(
               item => preferences.IndexOf(item.RaceID));

            return orderedData.ToList();

        }
        #endregion

        #region AgeGroups

        public static List<AgeGroup> GetAgeGroups()
        {
            return POD.Data.LookUpTypesData.GetAgeGroups();

        }
        #endregion

        #region LessonPlanStatusType

        public static List<StatusType> GetLessonPlanStatusType()
        {
            return POD.Data.LookUpTypesData.GetLessonPlanStatusType();

        }
        #endregion

        #region Ethnicity

        public static List<Ethnicity> GetEthnicities()
        {
            return POD.Data.LookUpTypesData.GetEthnicities();

        }
        #endregion

        #region Gender

        public static List<Gender> GetGenders()
        {
            return POD.Data.LookUpTypesData.GetGenders();

        }
        #endregion

        #region Counties
        public static List<County> GetCounties()
        {
            return POD.Data.LookUpTypesData.GetCounties();

        }

        public static List<State> GetStates()
        {
            return POD.Data.LookUpTypesData.GetStates();

        }
        #endregion

        #region Locations

        public static List<Location> GetLocations()
        {
            return POD.Data.LookUpTypesData.GetLocations();
        }

        public static List<Location> GetLocationsBySite(int siteid)
        {
            return POD.Data.LookUpTypesData.GetLocations().Where(l=> l.SiteLocationID.HasValue && l.SiteLocationID.Value == siteid).ToList();
        }
        public static List<Location> GetAllLocations()
        {
            return POD.Data.LookUpTypesData.GetAllLocations();
        }
        public static List<Site> GetSites()
        {
            return POD.Data.LookUpTypesData.GetSites();
        }

        public static List<Site> GetAllSites()
        {
            return POD.Data.LookUpTypesData.GetAllSites();
        }

        public static Location GetLocationByID(int key)
        {
            return POD.Data.LocationData.GetLocationByID(key);
        }
        public static Site GetSiteByID(int key)
        {
            return POD.Data.LocationData.GetSiteByID(key);
        }

        public static Site GetSiteByStaffMemberUserID(Guid userId)
        {
            return POD.Data.LocationData.GetSiteByStaffMemberUserID(userId);
        }

        public static Site GetSiteByStaffMemberUserName(string userName)
        {
            return POD.Data.LocationData.GetSiteByStaffMemberUserName(userName);
        }

        public static int AddUpdateLocation(int addressid, string name, string sitename, string orgname, string notes, bool issite, int? parentsiteID, int typeid, int status, int key, DateTime? lockDate)
        {
            return POD.Data.LocationData.AddUpdateLocation(addressid, name, sitename, orgname, notes, issite, parentsiteID, typeid, status, key, lockDate, Security.GetCurrentUserProfile().UserName);
        }

        public static int AddUpdateLocation(int addressid, string name, string sitename, string orgname, string notes, bool issite, int? parentsiteID, int typeid, int status, int key, bool isSiteLocked)
        {
            return POD.Data.LocationData.AddUpdateLocation(addressid, name, sitename, orgname, notes, issite, parentsiteID, typeid, status, key, isSiteLocked, Security.GetCurrentUserProfile().UserName);
        }

        public static string DeleteLocation(int key)
        {
            return POD.Data.LocationData.DeleteLocation(key);
        }
        /// <summary>
        /// deletes related data or sets keys to null
        /// cleans up the data for Classess LessonPlans, Course Instances
        /// Phone Numbers People and Risk Assessments
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public static string DeleteLocationRelations(int key)
        {
            return POD.Data.LocationData.DeleteLocationRelations(key);
        }

        public static string AddPhoneNumberToLocation(int locid, int phoneid)
        {
            return POD.Data.LocationData.AddPhoneNumberToLocation(locid, phoneid);
        }

        public static string DeletePhoneNumberToLocation(int locid, int phoneid)
        {
            return POD.Data.LocationData.DeletePhoneNumberToLocation(locid, phoneid);

        }

        /// <summary>
        /// sets all sites to the same attendance locked date
        /// </summary>
        /// <param name="date">date when to lock the attendance entering</param>
        /// <returns></returns>
        public static string UpdateAttendanceLockedDate(bool mandatorylock)
        {
            return POD.Data.LocationData.UpdateAttendanceLockedDate(mandatorylock, Security.GetCurrentUserProfile().UserName);
        }

        #endregion

        #region Reporting

        public static MasterClassScheduleReportParameters GetMasterClassScheduleReportParameters(int programId)
        {
            var data = ReportingData.GetMasterClassScheduleParameterLookupData(programId);
            return new MasterClassScheduleReportParameters(data);
        }

        #endregion
    }
}
