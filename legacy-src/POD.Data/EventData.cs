using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using POD.Data.Entities;
using POD.Logging;

namespace POD.Data
{
    public static class EventData
    {
        public static List<EventCategory> GetEventCategoriesByEventType(int eventTypeId)
        {
            using (var context = new PODContext())
            {
                return context.EventCategories
                    .Include(x => x.ChildrenCategories)
                    .Include(x => x.EventCategoryFields)
                    .Where(x => x.EventTypeID == eventTypeId)
                    .ToList();
            }
        }

        public static EventCategory GetEventCategoryByID(int eventCategoryId)
        {
            using (var context = new PODContext())
            {
                return context.EventCategories
                    .Include(x => x.ChildrenCategories)
                    .Include(x => x.EventCategoryFields)
                    .FirstOrDefault(x => x.EventCategoryID == eventCategoryId);
            }
        }

        /// <summary>
        ///gets all events  
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static List<Event> GetAllEvents(int programid)
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    return context.Events.Where(e => e.ProgramID == programid).OrderByDescending(e => e.DateStart).ThenBy(e => e.Name).ToList();
                }
            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }
        }

        /// <summary>
        ///delete event 
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static string DeleteEvent(int eventid)
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    Event currentEvent = context.Events.FirstOrDefault(e => e.EventID == eventid);
                    if (currentEvent != null)
                    {
                        context.Events.DeleteObject(currentEvent);
                        context.SaveChanges();

                    }
                }
                return string.Empty;
            }
            catch (Exception ex)
            {
                ex.Log();
                return ex.Message;
            }
        }

        /// <summary>
        ///get event 
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static Event GetEvent(int eventid)
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    return context.Events.Include(x => x.Site).FirstOrDefault(e => e.EventID == eventid);
                }
            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }
        }

        /// <summary>
        ///add or update event 
        /// </summary>
        /// <param name="newEvent">new event data</param>
        /// <param name="programid">current Program ID</param>
        ///<param name="username">current logged in user</param> 
        /// <returns></returns>
        public static int AddUpdateEvent(Event newEvent, int programid, string username)
        {
            int eventID = 0;
            bool isAdd = false;
            using (PODContext context = new PODContext())
            {
                try
                {
                    Event ev = context.Events.FirstOrDefault(e => e.EventID == newEvent.EventID);
                    if (ev == null)
                    {
                        isAdd = true;
                        ev = new Event();
                        ev.rowguid = Guid.NewGuid();
                        ev.DateTimeStamp = DateTime.Now;
                        ev.ProgramID = programid;
                    }
                    ev.Notes = newEvent.Notes;
                    ev.Name = newEvent.Name;
                    ev.Description = newEvent.Description;
                    ev.DateStart = newEvent.DateStart;
                    ev.DateEnd = newEvent.DateEnd;
                    ev.LastModifiedBy = username;
                    ev.LocationID = newEvent.LocationID;
                    ev.EventLocation = newEvent.EventLocation;
                    ev.Category = newEvent.Category;
                    ev.YouthAttendanceCount = newEvent.YouthAttendanceCount;
                    ev.StaffAttendanceCount = newEvent.StaffAttendanceCount;
                    ev.FamilyAttendanceCount = newEvent.FamilyAttendanceCount;
                    ev.SiteLocationID = newEvent.SiteLocationID;
                    ev.StatusTypeID = newEvent.StatusTypeID;
                    ev.EventTypeID = newEvent.EventTypeID;

                    if (isAdd)
                    {
                        context.Events.AddObject(ev);
                    }
                    context.SaveChanges();
                    eventID = ev.EventID;
                }
                catch (Exception ex)
                {
                    ex.Log();
                }
                return eventID;
            }
        }

        /// <summary>
        ///get attendance for specified  event 
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static List<EventAttendance> GetEventAttendanceList(int eventid)
        {
            List<EventAttendance> list = new List<EventAttendance>();
            try
            {
                using (PODContext context = new PODContext())
                {
                    list = context.EventAttendances.Include(x => x.Event).Include(x => x.Person).Where(ea => ea.EventID == eventid).OrderBy(ea => ea.Event.Name).ToList();
                }
                return list;
            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }
        }

        /// <summary>
        ///gets all events with filter applied
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static List<Event> GetEvents(string name, int programid, int? siteid,  int? locationID, int? typeID, int? statusid, DateTime? startDate, DateTime? startDate2, DateTime? endDate, DateTime? endDate2)
        {
            List<Event> filteredEvents = new List<Event>();
            try
            {
                using (PODContext context = new PODContext())
                {
                    var events = context.Events.Include(x => x.EventType).Include(x => x.StatusType).Include(x => x.Location).Include(x => x.Site).Where(e => e.ProgramID == programid);
                    if (siteid.HasValue)
                    {
                        events = events.Where(ev => ev.SiteLocationID == siteid.Value);
                    }
                    if (!string.IsNullOrEmpty(name))
                    {
                        events = events.Where(e => e.Name.Contains(name));
                    }
                    if (locationID.HasValue)
                    {
                        events = events.Where(e => e.LocationID.HasValue && e.LocationID == locationID);
                    }
                    if (typeID.HasValue)
                    {
                        events = events.Where(e => e.EventTypeID == typeID.Value);
                    }
                    if (statusid.HasValue)
                    {
                        events = events.Where(e => e.StatusTypeID == statusid.Value);
                    }
                    if (startDate.HasValue && startDate2.HasValue)
                    {
                        events = events.Where(e => e.DateStart.HasValue && e.DateStart.Value >= startDate.Value && e.DateStart.Value <= startDate2.Value);
                    }
                    else if (startDate.HasValue)
                    {
                        events = events.Where(e => e.DateStart.HasValue && e.DateStart.Value >= startDate.Value);

                    }
                    else if (startDate2.HasValue)
                    {
                        events = events.Where(e => e.DateStart.HasValue && e.DateStart.Value <= startDate2.Value);
                    }
                    if (endDate.HasValue && endDate2.HasValue)
                    {
                        events = events.Where(e => e.DateEnd.HasValue && e.DateEnd.Value >= endDate.Value && e.DateEnd.Value.Date <= endDate2.Value);
                    }
                    else if (endDate.HasValue)
                    {
                        events = events.Where(e => e.DateEnd.HasValue && e.DateEnd.Value >= endDate.Value);

                    }
                    else if (endDate2.HasValue)
                    {
                        events = events.Where(e => e.DateEnd.HasValue && e.DateEnd.Value <= endDate2.Value);
                    }

                    if (events.Count() > 0)
                    {
                        filteredEvents = events.OrderBy(e => e.DateStart).ThenBy(e => e.Name).ToList();
                    }
                    return filteredEvents;
                }
            }
            catch (Exception ex)
            {
                ex.Log();
                return filteredEvents;
            }
        }
    }
}
