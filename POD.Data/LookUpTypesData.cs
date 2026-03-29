using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using POD.Data.Entities;

namespace POD.Data
{
   public static  class LookUpTypesData
    {
        #region Race

        public static List<Race> GetRaces()
        {
            using (PODContext context = new PODContext())
            {
                return context.Races.Where(r => r.RaceID != 7 ).OrderBy(r => r.Name).ToList();
            }
        }
        #endregion

        #region AgeGroups

        public static List<AgeGroup> GetAgeGroups()
        {
            using (PODContext context = new PODContext())
            {
                return context.AgeGroups.Where(r => r.IsActive == true).OrderBy(r => r.AgeGroupID).ToList();
            }
        }
        #endregion

        #region LessonPlanStatusType

        public static List<StatusType> GetLessonPlanStatusType()
        {
            using (PODContext context = new PODContext())
            {
                return context.StatusTypes.OrderBy(r => r.Category == "LessonPlanSet").ToList();
            }
            
        }
        #endregion

        #region Ethnicity

        public static List<Ethnicity> GetEthnicities()
        {
            using (PODContext context = new PODContext())
            {
                return context.Ethnicities.Where(r => r.EthnicityID != 5).OrderBy(r => r.Name).ToList();
            }
        }
        #endregion

        #region Gender

        public static List<Gender> GetGenders()
        {
            using (PODContext context = new PODContext())
            {
                return context.Genders.OrderBy(r => r.Name).ToList();
            }
        }
        #endregion

        #region Counties
        public static List<County> GetCounties()
        {
            using (PODContext context = new PODContext())
            {
                return context.Counties.OrderBy(r => r.Name).ToList();
            }

        }
        #endregion

        #region States

        public static List<State> GetStates()
        {
            using (PODContext context = new PODContext())
            {
                return context.States.OrderBy(r => r.Name).ToList();
            }

        }
        #endregion

        #region Locations

        public static List<Location> GetLocations()
        {
            using (PODContext context = new PODContext())
            {
                return context.Locations.Where(r=>  r.StatusType.Name != "Inactive").OrderBy(r => r.Name).ToList();
            }
        }

        public static List<Location> GetAllLocations()
        {
            using (PODContext context = new PODContext())
            {
                return context.Locations.Include(x => x.Address).Include(x => x.StatusType).Include(x => x.LocationType).OrderBy(r => r.Name).ToList();
            }
        }
        public static List<Site> GetSites()
        {
            using (PODContext context = new PODContext())
            {
                return context.Locations.OfType<Site>().Include(x => x.StatusType).Include(x=> x.Address).Where(r => r.StatusType.Name != "Inactive").OrderBy(r => r.Name).ToList();
            }
        }
        public static List<Site> GetAllSites()
        {
            using (PODContext context = new PODContext())
            {
                return context.Locations.OfType<Site>().Include(x => x.Address).Include(x => x.StatusType).OrderBy(r => r.Name).ToList();
            }
        }
        #endregion
    }
}
