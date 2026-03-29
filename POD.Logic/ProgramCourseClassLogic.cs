using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using POD.Data.Entities;

namespace POD.Logic
{
    public static class ProgramCourseClassLogic
    {
        #region Attendance
        /// <summary>
        /// applies search filter if provided
        /// gets all attendances and events any person has attended
        /// </summary>
        /// <param name="name"></param>
        /// <param name="guardian"></param>
        /// <param name="enrollmentTypeid"></param>
        /// <param name="statusType"></param>
        /// <param name="school"></param>
        /// <param name="startDate"></param>
        /// <param name="endDate"></param>
        /// <param name="zip"></param>
        /// <returns></returns>
        public static IList<sp_GetClassessAndEvents_Result> GetAttendancesAndEvents(int programid, string name, int? siteLocID, int? locID, int? classid, int? eventid, DateTime? startDate, DateTime? endDate)
        {
            return POD.Data.ProgramCourseClassData.GetAttendancesAndEvents(programid, name, siteLocID, locID, classid, eventid, startDate, endDate);
        }

        public static string DeleteLessonPlanSetTemplateByID(int Id)
        {
            return POD.Data.ProgramCourseClassData.DeleteLessonPlanSetTemplateByID(Id);
        }



        public static string DeleteAttendanceRecord(string type, int key)
        {
            if (type == "Event")
            {
                return POD.Data.AttendanceData.DeleteEventAttendance(key, Security.GetCurrentUserProfile().UserName);
            }
            else
            {
                return POD.Data.AttendanceData.DeleteClassAttendance(key, Security.GetCurrentUserProfile().UserName);
            }
        }

        /// <summary>
        /// gets active programs
        /// </summary>
        /// <returns></returns>
        public static IList<Program> GetPrograms()
        {
            return POD.Data.ProgramCourseClassData.GetPrograms();
        }
        #endregion

        #region Program
        public static string DeleteProgram(int progID)
        {
            return POD.Data.ProgramCourseClassData.DeleteProgram(progID);
        }

        /// <summary>
        /// gets first program id 
        /// </summary>
        /// <returns></returns>
        public static int GetProgramID()
        {
            return POD.Data.ProgramCourseClassData.GetProgramID();
        }
        #endregion

        #region Courses
        /// <summary>
        ///gets all course instances with filter applied
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static IList<CourseInstance> GetCourseInstances(string name, int programid, int? siteID, int? instrcutorID, int? assistantID, DateTime? startDate, DateTime? startDate2, DateTime? endDate, DateTime? endDate2)
        {
            return POD.Data.ProgramCourseClassData.GetCourseInstances(name, programid, siteID, instrcutorID, assistantID, startDate, startDate2, endDate, endDate2);
        }
        /// <summary>
        /// create or update course 
        /// </summary>
        /// <param name="courseID"></param>
        /// <param name="typeid"></param>
        /// <param name="status"></param>
        /// <param name="description"></param>
        /// <returns></returns>
        public static int AddUpdateCourse(int courseID, string name, int programid, int typeid, int status, string description)
        {
            return POD.Data.ProgramCourseClassData.AddUpdateCourse(courseID, name, programid, typeid, status, description, Security.GetCurrentUserProfile().UserName);
        }

        /// <summary>
        ///gets Course by  identifier
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static Course GetCourseByID(int cid)
        {
            return POD.Data.ProgramCourseClassData.GetCourseByID(cid);
        }
        /// <summary>
        ///gets Courses by program
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static IList<Course> GetCoursesByProgramID(int progID)
        {
            return POD.Data.ProgramCourseClassData.GetCoursesByProgramID(progID);
        }
        /// <summary>
        /// deletes specified Course, including all related data
        /// </summary>
        /// <param name="courseid"></param>
        /// <returns></returns>
        public static string DeleteCourse(int courseId)
        {
            return POD.Data.ProgramCourseClassData.DeleteCourse(courseId);
        }

        /// <summary>
        /// deletes specified Class, including all related data
        /// </summary>
        /// <param name="courseid"></param>
        /// <returns></returns>
        public static string DeleteClass(int classid)
        {
            return POD.Data.ProgramCourseClassData.DeleteClass(classid);
        }

        /// <summary>
        /// create or update course instance
        /// </summary>
        /// <param name="courseInstanceID"></param>
        /// <param name="courseId"></param>
        /// <param name="LocationID"></param>
        /// <param name="startDate"></param>
        /// <param name="endDate"></param>
        /// <param name="instructorID"></param>
        /// <param name="assitantID"></param>
        /// <param name="notes"></param>
        /// <param name="username"></param>
        /// <returns></returns>
        public static bool AddUpdateCourseInstance(int courseInstanceID, int courseId, int LocationID, int? lessonplanSetID, DateTime? startDate, DateTime? endDate, int? instructorID, int? assitantID, string notes)
        {
            return POD.Data.ProgramCourseClassData.AddUpdateCourseInstance(courseInstanceID, courseId, LocationID, lessonplanSetID, startDate, endDate, instructorID, assitantID, notes, Security.GetCurrentUserProfile().UserName);
        }

        public static int AddUpdateCourseInstance( int courseId, int LocationID, int? lessonplanSetID, DateTime? startDate, DateTime? endDate, int? instructorID, int? assitantID, string notes)
        {
            return POD.Data.ProgramCourseClassData.AddUpdateCourseInstance(courseId, LocationID, lessonplanSetID, startDate, endDate, instructorID, assitantID, notes, Security.GetCurrentUserProfile().UserName);
        }


        /// <summary>
        /// deletes specified Course instance
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static string DeleteCourseInstance(int instanceid)
        {
            return POD.Data.ProgramCourseClassData.DeleteCourseInstance(instanceid);
        }
        /// <summary>
        ///gets Course instances by program
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static IEnumerable<CourseInstance> GetCourseInstancesByProgramID(int progID)
        {
            return POD.Data.ProgramCourseClassData.GetCourseInstancesByProgramID(progID);

        }

        /// <summary>
        ///gets Course instances by person and program
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static IEnumerable<CourseInstance> GetCourseInstancesByPersonIDAndProgramID(int personid, int progID)
        {
            return POD.Data.ProgramCourseClassData.GetCourseInstancesByPersonIDAndProgramID(personid, progID);

        }

        /// <summary>
        /// gets  Course instance by course id
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static IEnumerable<CourseInstance> GetCourseInstancesByCourseID(int courseID)
        {
            return POD.Data.ProgramCourseClassData.GetCourseInstancesByCourseID(courseID);

        }

        /// <summary>
        /// gets  Course instance by LessonPlanSetID
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static IEnumerable<CourseInstance> GetCourseInstancesByLessonPlanSetID(int LessonPlanSetID)
        {
            return POD.Data.ProgramCourseClassData.GetCourseInstancesByLessonPlanSetID(LessonPlanSetID);

        }

        /// <summary>
        /// gets  Course instances
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static IEnumerable<CourseInstance> GetCourseInstances()
        {
            return POD.Data.ProgramCourseClassData.GetCourseInstances();

        }

        /// <summary>
        ///gets course instance by identifier
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static CourseInstance GetCoursesInstanceByID(int id)
        {
            return POD.Data.ProgramCourseClassData.GetCoursesInstanceByID(id);
        }

        /// <summary>
        ///add person to course instance
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static string AddPersonToCourseInstance(int personID, int instID)
        {
            return POD.Data.ProgramCourseClassData.AddPersonToCourseInstance(personID, instID);
        }

        public static void RemoveFutureCourseInstancesByPersonID(int personID, DateTime? releaseDate)
        {
            POD.Data.ProgramCourseClassData.RemoveFutureCourseInstancesByPersonID(personID, releaseDate);
        }

        /// <summary>
        ///remove person to course instance
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static string RemovePersonToCourseInstance(int personID, int instID)
        {
            return POD.Data.ProgramCourseClassData.RemovePersonToCourseInstance(personID, instID);

        }
        #endregion

        #region Classess
        /// <summary>
        ///gets Classes attendances
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static List<ClassAttendance> GetClassAttendances(int classid)
        {
            return POD.Data.ProgramCourseClassData.GetClassAttendances(classid);
        }


        /// <summary>
        ///gets Classess by  course instance
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static List<Class> GetClassessByCourseInstanceIDList(List<int> instIDList)
        {
            return POD.Data.ProgramCourseClassData.GetClassessByCourseInstanceIDList(instIDList);

        }
        /// <summary>
        ///gets Classess by  course instance list
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static List<Class> GetClassessByProgramID(int programid)
        {
            return POD.Data.ProgramCourseClassData.GetClassessByProgramID(programid);

        }
        /// <summary>
        ///gets Classess by  course instance list
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static List<Class> GetClassessByProgramAndSite(int programid, int siteid)
        {
            return POD.Data.ProgramCourseClassData.GetClassessByProgramAndSite(programid, siteid);
        }
        /// <summary>
        ///gets Classess by  course instance
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static List<Class> GetClassessByCourseInstanceID(int instID)
        {
            return POD.Data.ProgramCourseClassData.GetClassessByCourseInstanceID(instID);

        }

        /// <summary>
        ///gets Class by  identifier
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static Class GetClassByID(int classid)
        {
            return POD.Data.ProgramCourseClassData.GetClassByID(classid);

        }

        /// <summary>
        ///updates class lesson plan
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static bool UpdateClass(int classid, int lessonplanid)
        {
            return POD.Data.ProgramCourseClassData.UpdateClass(classid, lessonplanid, Security.GetCurrentUserProfile().UserName);
        }

        /// <summary>
        ///updates or creates new class
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static bool AddUpdateClass(int classid, int typeid, int courseinstanceid, int siteid, int? locid, int? lessonPlanid, int instructorID, int? assistantid, int status, DateTime? start, DateTime? end, string name)
        {
            return POD.Data.ProgramCourseClassData.AddUpdateClass(classid, typeid, courseinstanceid, siteid, locid, lessonPlanid, instructorID, assistantid, status, start, end, name, Security.GetCurrentUserProfile().UserName);
        }

        #endregion

        #region LessonPlan
        /// <summary>
        ///gets lesson plan
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static LessonPlan GetLessonPlan(int planid)
        {
            return POD.Data.ProgramCourseClassData.GetLessonPlan(planid);
        }
        public static IEnumerable<LessonPlanSet> GetLessonPlansSetsByFilters(IEnumerable<LessonPlanSet> currentLPS, int progID, int? locID,
                                                                           int? siteid, int? instructorid, int? statusid,
                                                                            int? assistantId, DateTime? startDate, DateTime? endDate, string nameLPS)
        {
            return POD.Data.ProgramCourseClassData.GetLessonPlansSetsByFilters(currentLPS, progID, locID, siteid, instructorid, statusid, assistantId, startDate, endDate, nameLPS);
        }
        
        /// <summary>
        ///updates or creates new lesson plan
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static int AddUpdateLessonPlan(LessonPlan plan)
        {
            return POD.Data.ProgramCourseClassData.AddUpdateLessonPlan(plan, Security.GetCurrentUserProfile().UserName);
        }

        /// <summary>
        ///updates or creates new lesson plan
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static int AddUpdateLessonPlan(LessonPlan plan, bool addCourseInformation)
        {
            int result = 0;
            bool classId = false;
            int courseId = 0;
            int courseInstanceId = 0;

                        
            result = POD.Data.ProgramCourseClassData.AddUpdateLessonPlan(plan, Security.GetCurrentUserProfile().UserName);

            if(addCourseInformation)
            {

                //courseId = AddUpdateCourse(0, plan.Name, plan.ProgramID, plan.DisciplineTypeID, plan.StatusTypeID, "");

                //if(courseId != 0)
                //{
                //    var ci = AddUpdateCourseInstance(0, courseId, plan.SpecificLocationID, plan.LessonPlanSetID, plan.StartDate, plan.EndDate, plan.InstructorPersonID, plan.AssistantPersonID, "");
                //    courseInstanceId = AddUpdateCourseInstance(courseId, plan.SpecificLocationID, plan.LessonPlanSetID, plan.StartDate, plan.EndDate, plan.InstructorPersonID, plan.AssistantPersonID, "");
                //}

                //if (courseInstanceId != 0)
                //{
                //    classId = POD.Data.ProgramCourseClassData.AddUpdateClass(0, plan.StatusTypeID, courseInstanceId, plan.SiteLocationID, plan.SpecificLocationID, plan.LessonPlanID, plan.InstructorPersonID, plan.AssistantPersonID, plan.StatusTypeID, plan.StartDate, plan.EndDate, plan.Name, Security.GetCurrentUserProfile().UserName);
                //}
               
            }

            return result;
        }
        /// <summary>
        ///gets Lesson Plans by program
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static IEnumerable<LessonPlan> GetLessonPlansByProgramID(int progID)
        {
            return POD.Data.ProgramCourseClassData.GetLessonPlansByProgramID(progID);
        }
        /// <summary>
        ///gets Lesson Plans by set
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static IEnumerable<LessonPlan> GetLessonPlansBySetID(int setID)
        {
            return POD.Data.ProgramCourseClassData.GetLessonPlansBySetID(setID);
        }

        /// <summary>
        ///gets Lesson Plans sets by serach criteria
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static IEnumerable<LessonPlanSet> GetLessonPlanBySearchCriteria(string name)
        {
            return POD.Data.ProgramCourseClassData.GetLessonPlanBySearchCriteria(name);
        }
        /// <summary>
        /// deletes specified LessonPlan, including all related data
        /// </summary>
        /// <param name="courseid"></param>
        /// <returns></returns>
        public static string DeleteLessonPlan(int lessonplanid)
        {
            return POD.Data.ProgramCourseClassData.DeleteLessonPlan(lessonplanid);
        }

        /// <summary>
        /// deletes specified Lesson Plan set, including all related data
        /// </summary>
        /// <param name="setId"></param>
        /// <returns></returns>
        public static string DeleteLessonPlanSet(int setId)
        {
            return POD.Data.ProgramCourseClassData.DeleteLessonPlanSet(setId);
        }

        /// <summary>
        ///adds skill type to lesson plan
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static bool AddLifeSkillToLessonPlan(int planid, int skillID)
        {
            return POD.Data.ProgramCourseClassData.AddLifeSkillToLessonPlan(planid, skillID);
        }

        /// <summary>
        ///deletes skill type from lesson plan
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static void DeleteLifeSkillFromLessonPlan(int planid, int skillID)
        {
            POD.Data.ProgramCourseClassData.DeleteLifeSkillFromLessonPlan(planid, skillID);
        }

        /// <summary>
        ///gets all skill type from lesson plan
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static IEnumerable<LifeSkillType> GetLifeSkillsByLessonPlanID(int planid)
        {
            return POD.Data.ProgramCourseClassData.GetLifeSkillsByLessonPlanID(planid);

        }
        /// <summary>
        ///gets Lesson Plans Sets 
        ///that have a status of pre approved
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static IEnumerable<LessonPlanSet> GetUnapprovedLessonPlansSetsByProgramID(int progID)
        {
            return POD.Data.ProgramCourseClassData.GetUnapprovedLessonPlansSetsByProgramID(progID);
        }
        /// <summary>
        ///gets Lesson Plans Sets 
        ///that have a status of pre approved
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static IEnumerable<LessonPlanSet> GetLessonPlansSetsByFilters(int progID, int? typeID, int? siteid, int? instructorid, bool InstructorOnly)
        {
            return POD.Data.ProgramCourseClassData.GetLessonPlansSetsByFilters(progID, typeID, siteid, instructorid, InstructorOnly);
        }

        /// <summary>
        ///gets Lesson Plans Sets 
        ///that have a status of pre approved
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static IEnumerable<LessonPlanSet> GetLessonPlansSetsByFiltersAdmin(int progID, int? typeID, int? locID,
                                                                           int? siteid, int? instructorid, int? statusid,
                                                                           string classname)
        {
            return POD.Data.ProgramCourseClassData.GetLessonPlansSetsByFiltersAdmin(progID, typeID, locID, siteid, instructorid, statusid, classname);
        }

        public static LessonPlanSet GetLessonPlanSet(int setId)
        {

            return POD.Data.ProgramCourseClassData.GetLessonPlanSet(setId);
        }

        public static IList<LessonPlanSetTemplate> GetLessonPlanSetTemplatesByID(int instructorId)
        {
            return POD.Data.ProgramCourseClassData.GetLessonPlanSetTemplatesByID(instructorId);
        }

        public static int AddUpdateLessonPlanSetTemplate(LessonPlanSetTemplate lessonPlanTemplate)
        {
            return POD.Data.ProgramCourseClassData.AddUpdateLessonPlanSetTemplate(lessonPlanTemplate, Security.GetCurrentUserProfile().UserName);
        }

        public static int AddUpdateLessonPlanSet(LessonPlanSet plan, int statusTypeid)
        {
            return POD.Data.ProgramCourseClassData.AddUpdateLessonPlanSet(plan, statusTypeid, Security.GetCurrentUserProfile().UserName);
        }

        public static string UpdateLessonPlanSets(IList<int> planIDList, int statusTypeid)
        {
            return POD.Data.ProgramCourseClassData.UpdateLessonPlanSets(planIDList, statusTypeid, Security.GetCurrentUserProfile().UserName);
        }

        #endregion

        #region Events
        /// <summary>
        ///gets all events  
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static IEnumerable<Event> GetAllEvents(int programid)
        {
            return POD.Data.EventData.GetAllEvents(programid);
        }
        /// <summary>
        ///gets all events  
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static IEnumerable<Event> GetAllEvents(int programid, int siteid)
        {
            return POD.Data.EventData.GetAllEvents(programid).Where(e => e.SiteLocationID == siteid).ToList();
        }

        /// <summary>
        ///gets all events with filter applied
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static IEnumerable<Event> GetEvents(string name, int programid, int? siteid, int? locationID, int? typeID, int? statusid, DateTime? startDate, DateTime? startDate2, DateTime? endDate, DateTime? endDate2)
        {

            return POD.Data.EventData.GetEvents(name, programid, siteid, locationID, typeID, statusid, startDate, startDate2, endDate, endDate2);
        }
        /// <summary>
        ///delete event 
        /// </summary>
        /// <param name="eventid"> event identifier</param>
        /// <returns></returns>
        public static string DeleteEvent(int eventid)
        {
            return POD.Data.EventData.DeleteEvent(eventid);

        }

        /// <summary>
        ///get attendance for specified  event 
        /// </summary>
        /// <param name="eventid"> event identifier</param>
        /// <returns></returns>
        public static IList<EventAttendance> GetEventAttendanceList(int eventid)
        {
            return POD.Data.EventData.GetEventAttendanceList(eventid);
        }
        /// <summary>
        ///get event 
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static Event GetEvent(int eventid)
        {
            return POD.Data.EventData.GetEvent(eventid);
        }

        /// <summary>
        ///add or update event 
        /// </summary>
        /// <param name="newEvent">new event data</param>
        /// <param name="programid">current Program ID</param>
        /// <returns></returns>
        public static int AddUpdateEvent(Event newEvent, int programid)
        {
            return POD.Data.EventData.AddUpdateEvent(newEvent, programid, Security.GetCurrentUserProfile().UserName);
        }



        #endregion

        #region Community
        /// <summary>
        ///gets Community 
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static Community GetCommunityByID(int id)
        {
            return POD.Data.ProgramCourseClassData.GetCommunityByID(id);
        }
        /// <summary>
        /// deletes specified Community, including all related data
        /// </summary>
        /// <param name="courseid"></param>
        /// <returns></returns>
        public static string DeleteCommunity(int Id)
        {
            return POD.Data.ProgramCourseClassData.DeleteCommunity(Id);
        }
        /// <summary>
        ///updates or creates new Community
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static int AddUpdateCommunity(int id, string name, string desc)
        {
            return POD.Data.ProgramCourseClassData.AddUpdateCommunity(id, name, desc, Security.GetCurrentUserProfile().UserName);
        }

        /// <summary>
        ///adds county to Community
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static bool AddCountyToCommunity(int countyid, int comID)
        {
            return POD.Data.ProgramCourseClassData.AddCountyToCommunity(countyid, comID);
        }

        /// <summary>
        ///deletes County From Community
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static void DeleteCountyFromCommunity(int countyid, int comID)
        {
            POD.Data.ProgramCourseClassData.DeleteCountyFromCommunity(countyid, comID);
        }

        /// <summary>
        ///gets Community 
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static IEnumerable<County> GetCountiesForCommunityByID(int id)
        {
            return POD.Data.ProgramCourseClassData.GetCountiesForCommunityByID(id);

        }
        #endregion

        #region Circuit
        /// <summary>
        ///gets Circuit 
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static Circuit GetCircuitByID(int id)
        {
            return POD.Data.ProgramCourseClassData.GetCircuitByID(id);
        }

        /// <summary>
        /// deletes specified Circuit, including all related data
        /// </summary>
        /// <param name="courseid"></param>
        /// <returns></returns>
        public static string DeleteCircuit(int Id)
        {
            return POD.Data.ProgramCourseClassData.DeleteCircuit(Id);

        }
        /// <summary>
        ///updates or add Circuit
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static int AddUpdateCircuit(int id, string name)
        {
            return POD.Data.ProgramCourseClassData.AddUpdateCircuit(id, name, Security.GetCurrentUserProfile().UserName);
        }
        #endregion

        #region County
        /// <summary>
        ///gets County 
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static County GetCountyByID(int id)
        {
            return POD.Data.ProgramCourseClassData.GetCountyByID(id);
        }

        /// <summary>
        /// deletes specified County, including all related data
        /// </summary>
        /// <param name="courseid"></param>
        /// <returns></returns>
        public static string DeleteCounty(int Id)
        {
            return POD.Data.ProgramCourseClassData.DeleteCounty(Id);

        }
        /// <summary>
        ///updates or add County
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static int AddUpdateCounty(int id, string name, int circuitid)
        {
            return POD.Data.ProgramCourseClassData.AddUpdateCounty(id, name, circuitid, Security.GetCurrentUserProfile().UserName);
        }
        #endregion


        #region "class Updates"

        /// <summary>
        ///gets Classes attendances
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        //public static List<ClassAttendance> GetClassAttendances(int classid)
        //{
        //    return POD.Data.ProgramCourseClassData.GetClassAttendances(classid);
        //}


        /// <summary>
        ///gets Classess by  course instance
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static List<Class> GetClassessByCourseInstanceIDList_POD(List<int> instIDList)
        {
            return POD.Data.ProgramCourseClassData.GetClassessByCourseInstanceIDList(instIDList);

        }
        /// <summary>
        ///gets Classess by  course instance list
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static List<Class> GetClassessByProgramID_POD(int programid)
        {
            return POD.Data.ProgramCourseClassData.GetClassessByProgramID(programid);

        }
        /// <summary>
        ///gets Classess by  course instance list
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static List<Class> GetClassessByProgramAndSite_POD(int programid, int siteid)
        {
            return POD.Data.ProgramCourseClassData.GetClassessByProgramAndSite(programid, siteid);
        }
        /// <summary>
        ///gets Classess by  course instance
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static List<Class> GetClassessByCourseInstanceID_POD(int instID)
        {
            return POD.Data.ProgramCourseClassData.GetClassessByCourseInstanceID(instID);

        }

        /// <summary>
        ///gets Class by  identifier
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static Class GetClassByID_POD(int classid)
        {
            return POD.Data.ProgramCourseClassData.GetClassByID(classid);

        }

        /// <summary>
        ///updates class lesson plan
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static bool UpdateClass_POD(int classid, int lessonplanid)
        {
            return POD.Data.ProgramCourseClassData.UpdateClass(classid, lessonplanid, Security.GetCurrentUserProfile().UserName);
        }

        /// <summary>
        ///updates or creates new class
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static bool AddUpdateClass_POD(int classid, int typeid, int courseinstanceid, int siteid, int? locid, int? lessonPlanid, int instructorID, int? assistantid, int status, DateTime? start, DateTime? end, string name)
        {
            return POD.Data.ProgramCourseClassData.AddUpdateClass(classid, typeid, courseinstanceid, siteid, locid, lessonPlanid, instructorID, assistantid, status, start, end, name, Security.GetCurrentUserProfile().UserName);
        }



        #endregion
    }
}
