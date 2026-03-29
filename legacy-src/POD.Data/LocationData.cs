using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using System.Transactions;
using POD.Data.Entities;
using POD.Logging;

namespace POD.Data
{
    public static class LocationData
    {

        public static Location GetLocationByID(int key)
        {
            using (PODContext context = new PODContext())
            {
                return context.Locations.Include(x => x.Address).FirstOrDefault(l => l.LocationID == key);
            }
        }
        public static Site GetSiteByID(int key)
        {
            using (PODContext context = new PODContext())
            {
                var r = context.Locations.FirstOrDefault(x => x.LocationID == key);
                return context.Locations.OfType<Site>().Include(x => x.Address).FirstOrDefault(l => l.LocationID == key);
            }
        }

        public static Site GetSiteByStaffMemberUserName(string userName)
        {
            Site currentSite = null;

            using (PODContext context = new PODContext())
            {
                aspnet_User currentASPNETUser = context.aspnet_Users.FirstOrDefault(p => p.UserName == userName.Trim());
                if (currentASPNETUser != null)
                {
                    currentSite = GetSiteByStaffMemberUserID(currentASPNETUser.UserId);
                }

                return currentSite;
            }
        }

        public static Site GetSiteByStaffMemberUserID(Guid userId)
        {
            using (var context = new PODContext())
            {
                int? locationId = context.Persons
                    .OfType<StaffMember>()
                    .Where(x => x.UserID == userId)
                    .Select(x => x.LocationID).
                    FirstOrDefault();

                if (locationId != null)
                {
                    return context.Locations.OfType<Site>()
                        .Include(x => x.ChildrenLocations)
                        .FirstOrDefault(x => x.LocationID == locationId
                                             || x.ChildrenLocations.Any(l => l.LocationID == locationId));
                }
                return null;
            }
        }

        public static int AddUpdateLocation(int addressid, string name, string sitename, string orgname, string notes, bool issite, int? parentSiteID, int typeid, int status, int key, bool isSiteLocked, string username)
        {
            int result = 0;
            bool isadd = false;
            using (PODContext context = new PODContext())
            {
                try
                {
                    if (issite)
                    {
                        Site loc = context.Locations.OfType<Site>().FirstOrDefault(a => a.LocationID == key);
                        if (loc == null)
                        {
                            isadd = true;
                            loc = new Site();
                            loc.rowguid = Guid.NewGuid();
                            loc.DateTimeStamp = DateTime.Now;

                        }
                        loc.Organization = orgname;
                        loc.SiteName = sitename;
                        loc.MandatoryAttendanceLock = isSiteLocked;
                        loc.Name = name;
                        loc.Notes = notes;
                        loc.AddressID = addressid;
                        loc.StatusTypeID = status;
                        loc.LocationTypeID = typeid;
                        if (isadd)
                        {
                            context.Locations.AddObject(loc);
                        }
                        context.SaveChanges();
                        result = loc.LocationID;
                    }
                    else
                    {
                        Location loc = context.Locations.FirstOrDefault(a => a.LocationID == key);
                        if (loc == null)
                        {
                            isadd = true;
                            loc = new Location();
                            loc.rowguid = Guid.NewGuid();
                            loc.DateTimeStamp = DateTime.Now;

                        }
                        loc.SiteLocationID = parentSiteID;
                        loc.Name = name;
                        loc.Notes = notes;
                        loc.AddressID = addressid;

                        loc.StatusTypeID = status;
                        loc.LocationTypeID = typeid;
                        if (isadd)
                        {
                            context.Locations.AddObject(loc);
                        }
                        context.SaveChanges();
                        result = loc.LocationID;
                    }



                }
                catch (Exception ex)
                {
                    ex.Log();
                }
                return result;
            }
        }


        public static int AddUpdateLocation(int addressid, string name, string sitename, string orgname, string notes, bool issite, int? parentSiteID, int typeid, int status, int key, DateTime? lockDate, string username)
        {
            int result = 0;
            bool isadd = false;
            using (PODContext context = new PODContext())
            {
                try
                {
                    if (issite)
                    {
                        Site loc = context.Locations.OfType<Site>().FirstOrDefault(a => a.LocationID == key);
                        if (loc == null)
                        {
                            isadd = true;
                            loc = new Site();
                            loc.rowguid = Guid.NewGuid();
                            loc.DateTimeStamp = DateTime.Now;

                        }
                        loc.Organization = orgname;
                        loc.SiteName = sitename;
                        loc.AttendanceLockedDate = lockDate;
                        loc.Name = name;
                        loc.Notes = notes;
                        loc.AddressID = addressid;
                        loc.StatusTypeID = status;
                        loc.LocationTypeID = typeid;
                        if (isadd)
                        {
                            context.Locations.AddObject(loc);
                        }
                        context.SaveChanges();
                        result = loc.LocationID;
                    }
                    else
                    {
                        Location loc = context.Locations.FirstOrDefault(a => a.LocationID == key);
                        if (loc == null)
                        {
                            isadd = true;
                            loc = new Location();
                            loc.rowguid = Guid.NewGuid();
                            loc.DateTimeStamp = DateTime.Now;

                        }
                        loc.SiteLocationID = parentSiteID;
                        loc.Name = name;
                        loc.Notes = notes;
                        loc.AddressID = addressid;
                        loc.StatusTypeID = status;
                        loc.LocationTypeID = typeid;
                        if (isadd)
                        {
                            context.Locations.AddObject(loc);
                        }
                        context.SaveChanges();
                        result = loc.LocationID;
                    }



                }
                catch (Exception ex)
                {
                    ex.Log();
                }
                return result;
            }
        }
        public static string DeleteLocation(int key)
        {
            string result = string.Empty;
            using (PODContext context = new PODContext())
            {
                try
                {
                    Location loc = context.Locations.FirstOrDefault(a => a.LocationID == key);
                    if (loc != null)
                    {
                        context.Locations.DeleteObject(loc);
                        context.SaveChanges();
                    }
                }
                catch (Exception ex)
                {
                    ex.Log();
                    result = ex.Message;
                }
                return result;
            }
        }

        public static string AddPhoneNumberToLocation(int locid, int phoneid)
        {
            string results = string.Empty;
            using (PODContext context = new PODContext())
            {
                try
                {
                    Location currentLoc = context.Locations.FirstOrDefault(p => p.LocationID == locid);
                    if (currentLoc != null)
                    {
                        var number = context.PhoneNumbers.FirstOrDefault(p => p.PhoneNumberID == phoneid);
                        if (number != null && !currentLoc.PhoneNumbers.Any(p => p.PhoneNumberID == phoneid))
                        {
                            currentLoc.PhoneNumbers.Add(number);

                        }
                        context.SaveChanges();
                    }
                }
                catch (Exception ex)
                {
                    ex.Log();
                    results = ex.Message;
                }
            }

            return results;
        }

        public static string DeletePhoneNumberToLocation(int locid, int phoneid)
        {
            string results = string.Empty;
            using (PODContext context = new PODContext())
            {
                try
                {
                    Location currentLoc = context.Locations.FirstOrDefault(p => p.LocationID == locid);
                    if (currentLoc != null)
                    {
                        var number = context.PhoneNumbers.FirstOrDefault(p => p.PhoneNumberID == phoneid);
                        if (number != null)
                        {
                            currentLoc.PhoneNumbers.Remove(number);
                        }
                        context.SaveChanges();
                    }
                }
                catch (Exception ex)
                {
                    ex.Log();
                    results = ex.Message;
                }
            }

            return results;

        }

        /// <summary>
        /// deletes related data or sets keys to null
        /// cleans up the data for Classess LessonPlans, Course Instances
        /// Phone Numbers People and Risk Assessments
        /// update currently we don't want to allow deleting related data or locations
        /// with related data, so changed logic to not delete
        /// if any major data exist
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public static string DeleteLocationRelations(int key)
        {
            string result = string.Empty;
            using (PODContext context = new PODContext())
            {
                try
                {
                   Location currentLoc= context.Locations.FirstOrDefault(l => l.LocationID == key);
                   if (currentLoc != null && currentLoc.Persons.Count == 0 && currentLoc.Classes.Count == 0 &&
                       currentLoc.Events.Count == 0 && currentLoc.LessonPlans.Count == 0)
                   {
                       using (
                           var tran = new TransactionScope(TransactionScopeOption.Required,
                                                           new TransactionOptions()
                                                               {
                                                                   IsolationLevel = IsolationLevel.ReadCommitted
                                                               }))
                       {
                           context.sp_DeleteLocationRelatedData(key);
                           tran.Complete();
                       }
                   }
                }
                catch (Exception ex)
                {
                    ex.Log();
                    result = ex.Message;
                }
                return result;
            }
        }

        /// <summary>
        /// sets all sites to the same attendance locked date
        /// </summary>
        /// <param name="date">date when to lock the attendance entering</param>
        /// <param name="username">user that made the change</param>
        /// <returns></returns>
        public static string UpdateAttendanceLockedDate(bool mandatorylock, string username)
        {
            string result = string.Empty;
            using (PODContext context = new PODContext())
            {
                try
                {
                    var allsites = context.Locations.OfType<Site>();
                    foreach (Site st in allsites)
                    {
                        //st.AttendanceLockedDate = DateTime.;
                        st.MandatoryAttendanceLock = mandatorylock;
                        st.LastModifiedBy = username;
                    }
                    context.SaveChanges();
                }
                catch (Exception ex)
                {
                    ex.Log();
                    result = ex.Message;
                }
                return result;
            }
        }
    }
}
