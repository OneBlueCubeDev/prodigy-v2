using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using POD.Data.Entities;
using POD.Logging;

namespace POD.Data
{
    public static class AttendanceData
    {

        #region ClassAttendance

        /// <summary>
        /// returns class attendance for person
        /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static ClassAttendance GetClassAttendanceByPersonAndClass(int personid, int classAttendaceID)
        {
            using (PODContext context = new PODContext())
            {
                return context.ClassAttendances.FirstOrDefault(p => p.Student_PersonID == personid && p.ClassAttendanceID == classAttendaceID);
            }
        }


        /// <summary>
        /// adds /updates class attendance for person
        /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static string AddUpdateClassAttendance(int attendanceid, int personid, int classid, bool leftEarly, bool isTardy, string notes, string username, bool isAlternateActivity)
        {
            bool IsAdd = false;
            using (PODContext context = new PODContext())
            {
                try
                {
                    bool isRegistered =
                        context.Classes
                               .Any(x => x.ClassID == classid
                                         && x.CourseInstance.Persons
                                             .Any(p => p.PersonID == personid));

                    if (!isRegistered)
                        throw new ApplicationException(string.Format("Student [{0}] is not registered to Class [{1}]", personid, classid));

                    var cls = context.Classes
                                     .Where(x => x.ClassID == classid)
                                     .Select(x => new
                                                      {
                                                          x.ClassID,
                                                          x.DateStart
                                                      })
                                     .FirstOrDefault();
                    if (cls == null)
                        throw new ArgumentException(string.Format("Class {0} not found", classid));
                    ClassAttendance origAttendance = context.ClassAttendances.FirstOrDefault(a => a.ClassAttendanceID == attendanceid);
                    if (origAttendance == null)//try person class match
                    {
                        origAttendance = context.ClassAttendances.FirstOrDefault(a => a.Student_PersonID == personid && a.ClassID == classid);
                    }
                    if (origAttendance == null)
                    {
                        IsAdd = true;
                        origAttendance = new ClassAttendance();
                        origAttendance.DateTimeStamp = cls.DateStart;
                        origAttendance.rowguid = Guid.NewGuid();
                    }
                    origAttendance.DateTimeStamp = cls.DateStart;
                    origAttendance.LastModifiedBy = username;
                    origAttendance.LeftEarly = leftEarly;
                    origAttendance.Tardy = isTardy;
                    origAttendance.Student_PersonID = personid;
                    origAttendance.ClassID = classid;
                    origAttendance.Notes = notes;
                    origAttendance.IsAlternateActivity = isAlternateActivity;

                    if (IsAdd)
                    {
                        context.ClassAttendances.AddObject(origAttendance);
                    }

                    context.SaveChanges();
                    return string.Empty;
                }
                catch (Exception ex)
                {
                    ex.Log();
                    return ex.Message;
                }
            }
        }

        /// <summary>
        /// delete attendance
        /// </summary>
        /// <returns></returns>
        public static string DeleteClassAttendance(int attendanceid, string username)
        {
            using (PODContext context = new PODContext())
            {
                try
                {
                    ClassAttendance origAttendance = context.ClassAttendances.FirstOrDefault(a => a.ClassAttendanceID == attendanceid);
                    if (origAttendance != null)
                    {
                        origAttendance.LastModifiedBy = username;
                        context.ClassAttendances.DeleteObject(origAttendance);
                    }
                    context.SaveChanges();
                    return string.Empty;
                }
                catch (Exception ex)
                {
                    ex.Log();
                    return ex.Message;
                }
            }
        }

        #endregion

        #region EventAttendance

        /// <summary>
        /// returns class attendance for person
        /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static EventAttendance GetEventAttendanceByPersonAndEvent(int personid, int eventAttendanceID)
        {
            using (PODContext context = new PODContext())
            {
                return context.EventAttendances.FirstOrDefault(p => p.PersonID == personid && p.EventAttendanceID == eventAttendanceID);
            }
        }

        /// <summary>
        /// adds /updates event attendance for person
        /// </summary>
        /// <returns></returns>
        public static string AddUpdateEventAttendance(int attendanceid, int personid, int eventid, string username)
        {
            bool IsAdd = false;
            using (PODContext context = new PODContext())
            {
                try
                {
                    var evnt = context.Events
                                      .Where(x => x.EventID == eventid)
                                      .Select(x => new
                                                       {
                                                           x.EventID,
                                                           x.DateStart
                                                       })
                                      .FirstOrDefault();
                    if (evnt == null)
                        throw new ArgumentException(string.Format("Event {0} not found", eventid));

                    EventAttendance origAttendance = context.EventAttendances.FirstOrDefault(a => a.EventAttendanceID == attendanceid);
                    if (origAttendance == null)
                    {
                        origAttendance = context.EventAttendances.FirstOrDefault(a => a.PersonID == personid && a.EventID == eventid);
                    }
                    if (origAttendance == null)
                    {
                        IsAdd = true;
                        origAttendance = new EventAttendance();
                        origAttendance.DateTimeStamp = evnt.DateStart;
                        origAttendance.rowguid = Guid.NewGuid();
                    }
                    origAttendance.LastModifiedBy = username;
                    origAttendance.PersonID = personid;
                    origAttendance.EventID = eventid;
                    origAttendance.DateTimeStamp = evnt.DateStart;

                    if (IsAdd)
                    {
                        context.EventAttendances.AddObject(origAttendance);
                    }
                    context.SaveChanges();
                    return string.Empty;
                }
                catch (Exception ex)
                {
                    ex.Log();
                    return ex.Message;
                }
            }
        }

        /// <summary>
        /// delete attendance
        /// </summary>
        /// <returns></returns>
        public static string DeleteEventAttendance(int attendanceid, string username)
        {
            using (PODContext context = new PODContext())
            {
                try
                {
                    EventAttendance origAttendance = context.EventAttendances.FirstOrDefault(a => a.EventAttendanceID == attendanceid);
                    if (origAttendance != null)
                    {
                        origAttendance.LastModifiedBy = username;
                        context.EventAttendances.DeleteObject(origAttendance);
                    }
                    context.SaveChanges();
                    return string.Empty;
                }
                catch (Exception ex)
                {
                    ex.Log();
                    return ex.Message;
                }
            }
        }
        
        #endregion
    }
}
