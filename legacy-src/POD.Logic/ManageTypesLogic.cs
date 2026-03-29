using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Entity;
using POD.Data;
using POD.Data.Entities;

namespace POD.Logic
{
    public static class ManageTypesLogic
    {

        #region Types

        public static List<Data.TypesData.Types> GetTypesTypes()
        {
            return Enum.GetValues(typeof(Data.TypesData.Types)).Cast<Data.TypesData.Types>().ToList();
        }

        /// <summary>
        /// deletes specified type
        /// </summary>
        /// <param name="currentType">Type of ojb</param>
        /// <param name="key">Identifier</param>
        /// <returns>empty string or error message</returns>
        public static object GetTypeByTypeAndID(POD.Data.TypesData.Types currentType, int key)
        {
            return POD.Data.TypesData.GetTypeByTypeAndID(currentType, key);
        }

        /// <summary>
        /// deletes specified type
        /// </summary>
        /// <param name="currentType">Type of ojb</param>
        /// <param name="key">Identifier</param>
        /// <returns>empty string or error message</returns>
        public static object GetTypesByType(POD.Data.TypesData.Types currentType)
        {
            return POD.Data.TypesData.GetTypesByType(currentType);
        }

        public static object GetTransportationPersonRelationshipType ()
        {
            return POD.Data.TypesData.GetTransportationPersonRelationshipTypesByType();
        }

        /// <summary>
        /// takes in parameters to be updated or used to create new object.
        /// also takes in what type to add/update
        /// </summary>
        /// <param name="currentType">Type of ojb</param>
        /// <param name="name">name</param>
        /// <param name="desc">Description</param>
        /// <param name="status">Status</param>
        /// <param name="key">Identifier</param>
        /// <returns>empty string or error message</returns>
        public static string AddUpdateType(POD.Data.TypesData.Types currentType, string name, string desc, bool status, int key, string category)
        {
            return POD.Data.TypesData.AddUpdateType(currentType, name, desc, status, key, category);
        }
        /// <summary>
        /// deletes specified type
        /// </summary>
        /// <param name="currentType">Type of ojb</param>
        /// <param name="key">Identifier</param>
        /// <returns>empty string or error message</returns>
        public static string DeleteType(POD.Data.TypesData.Types currentType, int key)
        {
            return POD.Data.TypesData.DeleteType(currentType, key);
        }
        #region Age Groups
        public static List<AgeGroup> GetAgeGroups()
        {
            return POD.Data.TypesData.GetAgeGroups();
        }

        public static List<AgeGroup> GetAllAgeGroups()
        {
            return POD.Data.TypesData.GetAllAgeGroups();
        }
        /// <summary>
        /// delete identified age group
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public static string DeleteAgeGroup(int key)
        {
            return POD.Data.TypesData.DeleteAgeGroup(key);
        }

        /// <summary>
        /// add or update age group
        /// </summary>
        /// <param name="name"></param>
        /// <param name="minimumAge"></param>
        /// <param name="maximumAge"></param>
        /// <param name="key"></param>
        /// <returns></returns>
        public static string AddUpdateAgeGroup(string name, int minimumAge, int maximumAge, int key)
        {
            return POD.Data.TypesData.AddUpdateAgeGroup(name, minimumAge, maximumAge, key);
        }

        #endregion

        #region Time Periods
        public static List<TimePeriod> GetTimePeriods()
        {
            return POD.Data.TypesData.GetTimePeriods();
        }


        public static Dictionary<int, string> GetGrantYears()
        {
            Dictionary<int, string> grantYears = new Dictionary<int, string>();
            List<TimePeriod> periods = POD.Data.TypesData.GetTimePeriods();
            foreach (TimePeriod p in periods.Where(t => t.TimePeriodType.Name == "Grant Year"))
            {
                grantYears.Add(p.TimePeriodID, string.Format("{0}-{1}", p.StartDate.Value.Year.ToString(), p.EndDate.Value.Year.ToString()));
            }
            return grantYears;
        }

        public static Dictionary<int, string> GetGrantYears(int youthType)
        {
            Dictionary<int, string> grantYears = new Dictionary<int, string>();
            List<TimePeriod> periods = POD.Data.TypesData.GetTimePeriods();

            var timePeriodName = string.Empty;

            switch (youthType)
            {
                case 1:
                    timePeriodName = "DJJ Grant Year";
                    break;
                case 2:
                    timePeriodName = "HC Grant Year";
                    break;
                default:
                    timePeriodName = "DJJ Grant Year";
                    break;
            }
            foreach (TimePeriod p in periods.Where(t => t.TimePeriodType.Name.ToLower() == timePeriodName.ToLower()))
            {
                grantYears.Add(p.TimePeriodID, string.Format("{0}-{1}", p.StartDate.Value.Year.ToString(), p.EndDate.Value.Year.ToString()));
            }
            return grantYears;
        }

        public static Dictionary<int, string> GetYouthTypes()
        {
            Dictionary<int, string> youthTypes = new Dictionary<int, string>();

            youthTypes.Add(1,"DJJ");
            youthTypes.Add(2, "HC");

            return youthTypes;
        }

        public static string GetCurrentGrantYear()
        {
            DateTime current = DateTime.Now;
              List<TimePeriod> periods = POD.Data.TypesData.GetTimePeriods();
              TimePeriod p = periods.FirstOrDefault(t => t.TimePeriodType.Name == "Grant Year" && t.EndDate.HasValue && current <= t.EndDate.Value.AddDays(1));
              if (p != null && p.StartDate.HasValue && p.EndDate.HasValue)
              {
                  return string.Format("{0}-{1}",p.StartDate.Value.Year.ToString(), p.EndDate.Value.Year.ToString());
              }
              else {
                  return current.Year.ToString();
              }
        }

        public static string GetCurrentGrantYear(int youthType)
        {
            DateTime current = DateTime.Now;
            List<TimePeriod> periods = POD.Data.TypesData.GetTimePeriods();

            var timePeriodName = string.Empty;

            switch (youthType)
            {
                case 1:
                    timePeriodName = "DJJ Grant Year";
                    break;
                case 2:
                    timePeriodName = "HC Grant Year";
                    break;
                default:
                    timePeriodName = "DJJ Grant Year";
                    break;
            }

            TimePeriod p = periods.FirstOrDefault(t => t.TimePeriodType.Name.ToLower() == timePeriodName.ToLower() && t.EndDate.HasValue && current <= t.EndDate.Value.AddDays(1));
            if (p != null && p.StartDate.HasValue && p.EndDate.HasValue)
            {
                return string.Format("{0}-{1}", p.StartDate.Value.Year.ToString(), p.EndDate.Value.Year.ToString());
            }
            else
            {
                return current.Year.ToString();
            }
        }

        public static int? GetCurrentGrantYearID()
        {
            DateTime current = DateTime.Now;
            List<TimePeriod> periods = POD.Data.TypesData.GetTimePeriods();
            TimePeriod p = periods.FirstOrDefault(t => t.TimePeriodType.Name == "Grant Year" && t.EndDate.HasValue && current <= t.EndDate.Value.AddDays(1));
            if (p != null && p.StartDate.HasValue && p.EndDate.HasValue)
            {
               return p.TimePeriodID;
            }
            else
            {
                return null;
            }
        }

        public static int? GetCurrentGrantYearID(int youthType)
        {
            DateTime current = DateTime.Now;
            List<TimePeriod> periods = POD.Data.TypesData.GetTimePeriods();

            var timePeriodName = string.Empty;

            switch (youthType)
            {
                case 1:
                    timePeriodName = "DJJ Grant Year";
                    break;
                case 2:
                    timePeriodName = "HC Grant Year";
                    break;
                default:
                    timePeriodName = "DJJ Grant Year";
                    break;
            }

            TimePeriod p = periods.FirstOrDefault(t => t.TimePeriodType.Name.ToLower() == timePeriodName.ToLower() && t.EndDate.HasValue && current <= t.EndDate.Value.AddDays(1));
            if (p != null && p.StartDate.HasValue && p.EndDate.HasValue)
            {
                return p.TimePeriodID;
            }
            else
            {
                return null;
            }
        }


        public static string AddUpdateTimePeriod(int timeperiodTypeid, DateTime? startDate, DateTime? endDate, int key)
        {
            return POD.Data.TypesData.AddUpdateTimePeriod(timeperiodTypeid, startDate, endDate, key);
        }

        public static string DeleteTimePeriod(int key)
        {
            return POD.Data.TypesData.DeleteTimePeriod(key);
        }
        #endregion

        #endregion

        #region AddressType

        public static int GetAddressTypeIDByName(string name)
        {
            return POD.Data.TypesData.GetTypeIDByName(TypesData.Types.AddressType, name);
        }

        public static int GetLessonPlanTypeIDByName(string name)
        {
            return POD.Data.TypesData.GetTypeIDByName(TypesData.Types.LessonPlanSetTemplateType, name);
        }
        #endregion

        #region PhoneNumbers

        public static int GetPhoneNumberTypeIDByName(string name)
        {
            return POD.Data.TypesData.GetTypeIDByName(TypesData.Types.PhoneNumberType, name);
        }
        #endregion

        #region PersonType

        public static int GetPersonTypeIDByName(string name)
        {
            return POD.Data.TypesData.GetTypeIDByName(TypesData.Types.PersonType, name);
        }

        #endregion

        #region StatusType

        public static int GetStatusTypeIDByName(string name)
        {
            return POD.Data.TypesData.GetTypeIDByName(TypesData.Types.StatusType, name);
        }

        public static string GetStatusTypeNameByID(int id)
        {
            string name = string.Empty;
            StatusType type = (StatusType)POD.Data.TypesData.GetTypeByTypeAndID(TypesData.Types.StatusType, id);
            if (type != null)
            {
                name = type.Name;
            }
            return name;
        }

        /// <summary>
        /// retrieves status types by category
        /// </summary>
        /// <param name="currentType">Type of obj</param>
        /// <param name="Category">Category</param>
        /// <returns>List or null</returns>
        public static List<StatusType> GetStatusTypesByCategory(string category)
        {
            return POD.Data.TypesData.GetStatusTypesByCategory(category);
        }

        /// <summary>
        /// retrieves status type by category and name
        /// </summary>
        /// <param name="currentType">Type of obj</param>
        /// <param name="Category">Category</param>
        /// <returns>List or null</returns>
        public static StatusType GetStatusTypeByCategoryAndName(string category, string name)
        {
            return POD.Data.TypesData.GetStatusTypeByCategoryAndName(category, name);
        }
        #endregion

        #region Enrollment

        public static int GetEnrollmentTypeIDByName(string name)
        {
            return POD.Data.TypesData.GetTypeIDByName(TypesData.Types.EnrollmentType, name);
        }
        #endregion

        #region PersonRelationship

        public static int GetPersonRelationshipTypeIDByName(string name)
        {
            return POD.Data.TypesData.GetTypeIDByName(TypesData.Types.PersonRelationshipType, name);
        }
        #endregion



      
    }//class
}//namespace
