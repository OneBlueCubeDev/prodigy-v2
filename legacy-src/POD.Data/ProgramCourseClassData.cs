using POD.Data.Entities;
using POD.Logging;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Validation;
using System.Linq;

namespace POD.Data
{
    public static class ProgramCourseClassData
    {
        public static List<sp_GetClassessAndEvents_Result> GetAttendancesAndEvents(int programid, string name, int? siteLocID, int? locID, int? classid, int? eventid, DateTime? startDate, DateTime? endDate)
        {
            using (PODContext context = new PODContext())
            {
                return context.GetClassessAndEvents(name, siteLocID, locID, classid, eventid, startDate, endDate, programid).ToList();

            }
        }

        public static void RemoveFutureCourseInstancesByPersonID ( int personId, DateTime? releaseDate)
        {
            List<int> courseInstances = null;

            using (PODContext context = new PODContext())
            {
                //CourseInstance inst = context.CourseInstances.FirstOrDefault(c => c. == personId);
                //return context.Courses.Include(x => x.Program).Include(x => x.StatusType).Include(x => x.CourseType).Where(ci => ci. == progID).ToList();
                
               
                context.SP_DeleteYouthFromFutureCourseInstances(releaseDate, personId);
                
      
            }
        }


        public static string DeleteLessonPlanSetTemplateByID(int Id)
        {
            using (PODContext context = new PODContext())
            {
                LessonPlanSetTemplate currentLessonPlanSetTemplate = context.LessonPlanSetTemplates.FirstOrDefault(p => p.LessonPlanSetTemplateId == Id);
                if (currentLessonPlanSetTemplate != null)
                {
                    context.LessonPlanSetTemplates.DeleteObject(currentLessonPlanSetTemplate);
                    context.SaveChanges();
                }

            }
            return string.Empty;
        }

        public static IList<LessonPlanSetTemplate> GetLessonPlanSetTemplatesByID(int instructorId)
        {
            using (PODContext context = new PODContext())
            {
                return context.LessonPlanSetTemplates.Where(ci => ci.InstructorId == instructorId).ToList();

            }
        }

        public static List<sp_GetPersonAttendanceAndEvents_Result> GetAttendancesAndEventsByPerson(int programid, int personid)
        {
            using (PODContext context = new PODContext())
            {
                return context.sp_GetPersonAttendanceAndEvents(null, null, null, null, null, null, null, null, programid).Where(p => p.PersonID == personid).ToList();

            }
        }

        #region Program
        /// <summary>
        /// deletes specified program, including all related data
        /// 
        /// </summary>
        /// <param name="progID"></param>
        /// <returns></returns>
        public static string DeleteProgram(int progID)
        {
            try
            {
                using (PODContext context = new PODContext())
                {

                    Program currentProgram = context.Programs.FirstOrDefault(p => p.ProgramID == progID);
                    if (currentProgram != null)
                    {
                        context.Programs.DeleteObject(currentProgram);
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
        /// gets first program id 
        /// </summary>
        /// <returns></returns>
        public static int GetProgramID()
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    return context.Programs.FirstOrDefault().ProgramID;
                }
            }
            catch (Exception ex)
            {
                ex.Log();
                return 0;
            }
        }

        /// <summary>
        /// gets active programs
        /// </summary>
        /// <returns></returns>
        public static List<Program> GetPrograms()
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    return context.Programs.Where(p => p.StatusType.Name == "Active").ToList();
                }
            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }
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
            IList<CourseInstance> filteredcourses = new List<CourseInstance>();
            try
            {
                using (PODContext context = new PODContext())
                {
                    var courses = context.CourseInstances.Include(x => x.Classes).Include(x => x.Course).Include(x => x.Instructor).Include(x => x.Site).Where(c => c.ProgramID == programid);
                    if (!string.IsNullOrEmpty(name))
                    {
                        courses = courses.Where(e => e.Course.Name.Contains(name));
                    }
                    if (siteID.HasValue)
                    {
                        courses = courses.Where(ci => ci.SiteLocationID == siteID.Value);
                    }
                    if (instrcutorID.HasValue)
                    {
                        courses = courses.Where(ci => ci.InstructorPersonID.HasValue && ci.InstructorPersonID == instrcutorID || ci.Classes.Any(cl => cl.InstructorPersonID.HasValue && cl.InstructorPersonID == instrcutorID));
                    }
                    if (assistantID.HasValue)
                    {
                        courses = courses.Where(ci => ci.AssistantPersonID.HasValue && ci.AssistantPersonID == instrcutorID || ci.Classes.Any(cl => cl.AssistantPersonID.HasValue && cl.AssistantPersonID == instrcutorID));
                    }
                    if (startDate.HasValue && startDate2.HasValue)
                    {
                        courses = courses.Where(ci => ci.StartDate.HasValue && ci.StartDate.Value.Date >= startDate.Value.Date && ci.StartDate.Value.Date <= startDate2.Value.Date);
                    }
                    else if (startDate.HasValue)
                    {
                        courses = courses.Where(ci => ci.StartDate.HasValue && ci.StartDate.Value.Date >= startDate.Value.Date);
                    }
                    else if (startDate2.HasValue)
                    {
                        courses = courses.Where(ci => ci.StartDate.HasValue && ci.StartDate.Value.Date <= startDate2.Value.Date);

                    }
                    if (endDate.HasValue && endDate2.HasValue)
                    {
                        courses.Where(ci => ci.EndDate.HasValue && ci.EndDate.Value.Date >= startDate.Value.Date && ci.EndDate.Value.Date <= startDate2.Value.Date);
                    }
                    else if (endDate.HasValue)
                    {
                        courses.Where(ci => ci.EndDate.HasValue && ci.EndDate.Value.Date >= startDate.Value.Date);
                    }
                    else if (endDate2.HasValue)
                    {
                        courses.Where(ci => ci.EndDate.HasValue && ci.EndDate.Value.Date <= endDate2.Value.Date);
                    }

                    if (courses.Count() > 0)
                    {
                        filteredcourses = courses.OrderBy(c => c.StartDate).ThenBy(c => c.Course.Name).ToList();
                    }
                    return filteredcourses;
                }
            }
            catch (Exception ex)
            {
                ex.Log();
                return filteredcourses;
            }
        }

        /// <summary>
        /// create or update course 
        /// </summary>
        /// <param name="courseID"></param>
        /// <param name="typeid"></param>
        /// <param name="status"></param>
        /// <param name="description"></param>
        /// <returns></returns>
        public static int AddUpdateCourse(int courseID, string name, int programid, int typeid, int status, string description, string username)
        {
            int courseId = 0;


            bool isAdd = false;
            try
            {
                using (PODContext context = new PODContext())
                {
                    Course currentcourse = context.Courses.FirstOrDefault(c => c.CourseID == courseID);
                    if (currentcourse == null)
                    {
                        isAdd = true;
                        currentcourse = new Course();
                        currentcourse.rowguid = Guid.NewGuid();
                        currentcourse.ProgramID = programid;
                        currentcourse.DateTimeStamp = DateTime.Now;

                    }

                    currentcourse.LastModifiedBy = username.Trim();
                    currentcourse.StatusTypeID = status;
                    currentcourse.CourseTypeID = MapTypeID(typeid);
                    currentcourse.Description = description.Trim();
                    currentcourse.Name = name.Trim();
                    if (isAdd)
                    {
                        context.Courses.AddObject(currentcourse);
                    }

                    context.SaveChanges();
                    courseId = currentcourse.CourseID;
                }
                return courseId;
            }
            catch (DbEntityValidationException ex)
            {
                foreach (var error in ex.EntityValidationErrors)
                {
                    Console.WriteLine("====================");
                    Console.WriteLine("Entity {0} in state {1} has validation errors:",
                        error.Entry.Entity.GetType().Name, error.Entry.State);
                    foreach (var ve in error.ValidationErrors)
                    {
                        Console.WriteLine("\tProperty: {0}, Error: {1}",
                            ve.PropertyName, ve.ErrorMessage);
                    }
                    Console.WriteLine();
                }
                throw;
            }
            catch (Exception ex)
            {

                ex.Log();
                return courseId;
            }
        }


        private static int MapClassTypeID(int typeid)
        {
            int result = 0;

            //LessonPlanType passed in , needs to map to coursetype

            //5 = 1
            //2 = 4
            //3 = 3
            //4 = 2

            switch (typeid)
            {
                case 0: //nothing
                    result = 1;
                    break;
                case 2: // 1 lessonplantype = 
                    result = 4;
                    break;
                case 3:
                    result = 3;
                    break;
                case 4:
                    result = 2;
                    break;
                case 5:
                    result = 1;
                    break;
            }
            return result;
        }

        //helper funciton to correct the incorrect mapping of the course types
        private static int MapTypeID(int typeid)
        {
            int result = 0;

            //LessonPlanType passed in , needs to map to coursetype

            ///  2 = 1
            //   3 = 2
            //   4 = 3
            //   5 = 4

            switch (typeid)
            {
                case 0: //nothing
                    result = 1;
                    break;
                case 2: // 1 lessonplantype = 
                    result = 1;
                    break;
                case 3:
                    result = 2;
                    break;
                case 4:
                    result = 3;
                    break;
                case 5:
                    result = 4;
                    break;
            }
            return result;
        }

        /// <summary>
        ///gets Courses by program
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static IList<Course> GetCoursesByProgramID(int progID)
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    return context.Courses.Include(x => x.Program).Include(x => x.StatusType).Include(x => x.CourseType).Where(ci => ci.ProgramID == progID).ToList();
                }
            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }

        }

        /// <summary>
        ///gets Course by  identifier
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static Course GetCourseByID(int cid)
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    return context.Courses.Include(x => x.StatusType).Include(x => x.CourseType).FirstOrDefault(c => c.CourseID == cid);
                }
            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }

        }

        /// <summary>
        /// deletes specified Course, including all related data
        /// 
        /// </summary>
        /// <param name="courseid"></param>
        /// <returns></returns>
        public static string DeleteCourse(int courseId)
        {
            try
            {
                using (PODContext context = new PODContext())
                {

                    Course currentCourse = context.Courses.FirstOrDefault(p => p.CourseID == courseId);
                    if (currentCourse != null)
                    {
                        context.Courses.DeleteObject(currentCourse);
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
        /// deletes specified Course instance
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static string DeleteCourseInstance(int instanceid)
        {
            try
            {
                using (PODContext context = new PODContext())
                {

                    CourseInstance currentCourse = context.CourseInstances.FirstOrDefault(p => p.CourseInstanceID == instanceid);

                    if (currentCourse != null)
                    {
                        IList<Person> assignedPeople = currentCourse.Persons != null ? currentCourse.Persons.ToList() : null;
                        IList<Class> assignedClassList = currentCourse.Classes != null ? currentCourse.Classes.ToList() : null;




                        if (assignedPeople != null)
                        {

                            foreach (var person in assignedPeople)
                            {

                                List<ClassAttendance> assignedClassAttendance = person.ClassAttendances != null ? person.ClassAttendances.ToList() : null;

                                if (assignedClassAttendance != null)
                                {
                                    foreach (var classAttendance in assignedClassAttendance)
                                    {
                                        context.ClassAttendances.DeleteObject(classAttendance);
                                    }
                                }

                                currentCourse.Persons.Remove(person);
                            }
                        }

                        if (assignedClassList != null)
                        {
                            foreach (var cl in assignedClassList)
                            {
                                context.Classes.DeleteObject(cl);
                            }
                        }
                        context.CourseInstances.DeleteObject(currentCourse);
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
        public static bool AddUpdateCourseInstance(int courseInstanceID, int courseId, int siteID, int? lessonplanSetID, DateTime? startDate, DateTime? endDate, int? instructorID, int? assitantID, string notes, string username)
        {
            bool result = false;
            bool isAdd = false;
            try
            {
                using (PODContext context = new PODContext())
                {
                    Course currentCourse = context.Courses.FirstOrDefault(p => p.CourseID == courseId);
                    CourseInstance origInstance = context.CourseInstances.FirstOrDefault(cc => cc.CourseInstanceID == courseInstanceID);
                    if (origInstance == null)
                    {
                        origInstance = new CourseInstance();
                        origInstance.rowguid = Guid.NewGuid();
                        origInstance.DateTimeStamp = DateTime.Now;
                        origInstance.LastModifiedBy = username;
                        isAdd = true;
                    }
                    origInstance.LessonPlanSetID = lessonplanSetID;
                    origInstance.CourseID = courseId;
                    origInstance.ProgramID = currentCourse.ProgramID;
                    origInstance.StartDate = startDate;
                    origInstance.EndDate = endDate;
                    origInstance.InstructorPersonID = instructorID;
                    if(origInstance.AssistantPersonID != null && origInstance.AssistantPersonID != 0)
                    {
                        origInstance.AssistantPersonID = assitantID;
                    }
                    
                    origInstance.SiteLocationID = siteID;
                    origInstance.Notes = notes;
                    if (isAdd)
                    {
                        context.CourseInstances.AddObject(origInstance);
                    }
                    context.SaveChanges();
                    result = true;
                }
                return result;
            }
            catch (Exception ex)
            {
                ex.Log();
                return result;
            }

        }

        public static int AddUpdateCourseInstance(int courseId, int siteID, int? lessonplanSetID, DateTime? startDate, DateTime? endDate, int? instructorID, int? assitantID, string notes, string username)
        {
            //only for the initial add 
            int result = 0;
            bool isAdd = false;
            try
            {
                using (PODContext context = new PODContext())
                {
                    Course currentCourse = context.Courses.FirstOrDefault(p => p.CourseID == courseId);
                    CourseInstance origInstance = context.CourseInstances.FirstOrDefault(cc => cc.CourseInstanceID == 0);
                    if (origInstance == null)
                    {
                        origInstance = new CourseInstance();
                        origInstance.rowguid = Guid.NewGuid();
                        origInstance.DateTimeStamp = DateTime.Now;
                        origInstance.LastModifiedBy = username;
                        isAdd = true;
                    }
                    origInstance.LessonPlanSetID = lessonplanSetID;
                    origInstance.CourseID = courseId;
                    origInstance.ProgramID = currentCourse.ProgramID;
                    origInstance.StartDate = startDate;
                    origInstance.EndDate = endDate;
                    origInstance.InstructorPersonID = instructorID;
                    if(origInstance.AssistantPersonID != null && origInstance.AssistantPersonID != 0)
                    {
                        origInstance.AssistantPersonID = assitantID;
                    }
                    
                    origInstance.SiteLocationID = siteID;
                    origInstance.Notes = notes;
                    if (isAdd)
                    {
                        context.CourseInstances.AddObject(origInstance);
                    }
                    context.SaveChanges();

                    int id = origInstance.CourseInstanceID;

                    result = origInstance.CourseInstanceID;
                }
                return result;
            }
            catch (Exception ex)
            {
                ex.Log();
                return result;
            }

        }

        /// <summary>
        ///gets Course instances by program
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static List<CourseInstance> GetCourseInstancesByProgramID(int progID)
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    return context.CourseInstances.Include(x => x.Site).Include(x => x.Program).Include(x => x.Course).Include(x => x.Instructor).Where(ci => ci.ProgramID == progID).ToList();
                }
            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }

        }

        /// <summary>
        ///gets Course instances by program
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static List<CourseInstance> GetCourseInstancesByPersonIDAndProgramID(int personid, int progID)
        {
            try
            {
                using (PODContext context = new PODContext())
                {

                    return context.CourseInstances.Include(x => x.Site).Include(x => x.Program).Include(x => x.Course).Include(x => x.Instructor).Where(ci => ci.Persons.Any(p => p.PersonID == personid) && ci.ProgramID == progID).ToList();
                }
            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }

        }
        /// <summary>
        /// gets  Course instance by course id
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static IEnumerable<CourseInstance> GetCourseInstancesByCourseID(int courseID)
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    return context.CourseInstances.Include(x => x.Site).Include(x => x.Program).Include(x => x.Course).Include(x => x.Instructor).Where(ci => ci.CourseID == courseID).ToList();
                }
            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }
        }

        /// <summary>
        /// gets  Course instance by course id
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static IEnumerable<CourseInstance> GetCourseInstancesByLessonPlanSetID(int LessonPlanSetId)
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    return context.CourseInstances.Include(x => x.Site).Include(x => x.Program).Include(x => x.Course).Include(x => x.Instructor).Where(ci => ci.LessonPlanSetID == LessonPlanSetId).ToList();
                }
            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }
        }


        public static int AddUpdateLessonPlanSetTemplate(LessonPlanSetTemplate lessonPlanTemplates, string userName)
        {
            int result = 0;
            bool isAdd = false;
            try
            {
                using (PODContext context = new PODContext())
                {
                    LessonPlanSetTemplate origInstance = context.LessonPlanSetTemplates.FirstOrDefault(cc => cc.LessonPlanSetTemplateId == lessonPlanTemplates.LessonPlanSetTemplateId);

                    if (origInstance == null)
                    {
                        origInstance = new LessonPlanSetTemplate();
                        isAdd = true;
                    }

                    origInstance.InstructorId = lessonPlanTemplates.InstructorId;
                    origInstance.IsActive = lessonPlanTemplates.IsActive;
                    origInstance.LessonPlanSetTemplateType = lessonPlanTemplates.LessonPlanSetTemplateType;
                    origInstance.LessonPlanSetId = lessonPlanTemplates.LessonPlanSetId;
                    origInstance.TemplateName = !string.IsNullOrWhiteSpace(lessonPlanTemplates.TemplateName) ? lessonPlanTemplates.TemplateName : "";

                    if (isAdd)
                    {
                        context.LessonPlanSetTemplates.AddObject(origInstance);
                    }
                    context.SaveChanges();
                    result = origInstance.LessonPlanSetTemplateId;
                }
                return result;
            }
            catch (Exception ex)
            {
                ex.Log();
                return result;
            }
        }

        /// <summary>
        /// gets  Course instance 
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static List<CourseInstance> GetCourseInstances()
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    return context.CourseInstances.Include(x => x.Site).Include(x => x.Program).Include(x => x.Course).Include(x => x.Instructor).ToList();
                }
            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }
        }

        /// <summary>
        ///gets course instance by identifier
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static CourseInstance GetCoursesInstanceByID(int id)
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    return context.CourseInstances.Include(x => x.Course).Include(x => x.Instructor).Include(x => x.Assistant).Include(x => x.Site).FirstOrDefault(ci => ci.CourseInstanceID == id);
                }
            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }

        }

        /// <summary>
        ///add person to course instance
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static string AddPersonToCourseInstance(int personID, int instID)
        {
            string result = string.Empty;
            try
            {
                using (PODContext context = new PODContext())
                {
                    Person currentPerson = context.Persons.FirstOrDefault(p => p.PersonID == personID);
                    if (currentPerson != null)
                    {
                        CourseInstance inst = context.CourseInstances.FirstOrDefault(c => c.CourseInstanceID == instID);
                        if (inst != null)
                        {
                            if (!inst.Persons.Any(p => p.PersonID == currentPerson.PersonID))
                            {
                                inst.Persons.Add(currentPerson);
                                context.SaveChanges();
                            }
                        }
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

        /// <summary>
        ///remove person to course instance
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static string RemovePersonToCourseInstance(int personID, int instID)
        {
            string result = string.Empty;
            try
            {
                using (PODContext context = new PODContext())
                {
                    Person currentPerson = context.Persons.FirstOrDefault(p => p.PersonID == personID);
                    if (currentPerson != null)
                    {
                        CourseInstance inst = context.CourseInstances.FirstOrDefault(c => c.CourseInstanceID == instID);
                        if (inst != null)
                        {
                            if (inst.Persons.Any(p => p.PersonID == currentPerson.PersonID))
                            {
                                inst.Persons.Remove(currentPerson);
                                context.SaveChanges();
                            }
                        }
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

        #endregion

        #region Classess

        /// <summary>
        ///gets Classes attendances
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static List<ClassAttendance> GetClassAttendances(int classid)
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    return context.ClassAttendances.Include("Person").Include("Class").Where(c => c.ClassID == classid).ToList();
                }
            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }
        }
        /// <summary>
        ///gets Classess by  course instance
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static List<Class> GetClassessByCourseInstanceID(int instID)
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    return context.Classes.Include(x => x.CourseInstance.Course).Include(x => x.Location).Include(x => x.StatusType).Where(cl => cl.CourseInstanceID == instID).ToList();
                }
            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }

        }

        /// <summary>
        ///gets Classess by  course instance list
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static List<Class> GetClassessByCourseInstanceIDList(List<int> instIDList)
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    return context.Classes.Include(x => x.CourseInstance.Course).Include(x => x.Location).Include(x => x.StatusType).Where(cl => instIDList.Contains(cl.CourseInstanceID)).ToList();
                }
            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }

        }

        /// <summary>
        ///gets Classess by  course instance list
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static List<Class> GetClassessByProgramID(int programid)
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    return context.Classes.Include(x => x.CourseInstance.Course).Include(x => x.Location).Include(x => x.StatusType).Where(cl => cl.CourseInstance.Course.ProgramID == programid).ToList();
                }
            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }

        }

        /// <summary>
        ///gets Classess by  course instance list
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static List<Class> GetClassessByProgramAndSite(int programid, int siteid)
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    return context.Classes.Include(x => x.CourseInstance.Course).Include(x => x.Location).Include(x => x.StatusType).Where(cl => ((cl.SpecificLocationID.HasValue && cl.SpecificLocationID == siteid) || (cl.SiteLocationID.HasValue && cl.SiteLocationID == siteid) || (cl.CourseInstance.SiteLocationID == siteid)) && cl.CourseInstance.Course.ProgramID == programid).ToList();
                }
            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }

        }

        /// <summary>
        ///gets Class by  identifier
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static Class GetClassByID(int classid)
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    return context.Classes.Include(x => x.CourseInstance.Course).Include(x => x.Location).Include(x => x.Site).Include(x => x.StatusType).FirstOrDefault(cl => cl.ClassID == classid);
                }
            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }

        }

        /// <summary>
        ///updates class lesson plan
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static bool UpdateClass(int classid, int lessonplanid, string username)
        {
            bool result = true;

            try
            {
                using (PODContext context = new PODContext())
                {
                    Class currentClass = context.Classes.FirstOrDefault(cl => cl.ClassID == classid);
                    if (currentClass != null)
                    {
                        currentClass.LessonPlanID = lessonplanid;
                        currentClass.LastModifiedBy = username;
                        context.SaveChanges();
                    }
                }
                return result;
            }
            catch (Exception ex)
            {
                ex.Log();
                result = false;
                return result;
            }
        }

        /// <summary>
        ///updates or creates new class
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static bool AddUpdateClass(int classid, int typeid, int courseinstanceid, int siteid, int? locid, int? lessonPlanid, int instructorID, int? assistantid, int status, DateTime? start, DateTime? end, string name, string username)
        {
            bool result = true;
            bool isAdd = false;
            try
            {
                using (PODContext context = new PODContext())
                {
                    CourseInstance origInstance = context.CourseInstances.FirstOrDefault(cc => cc.CourseInstanceID == courseinstanceid);
                    Class currentClass = context.Classes.FirstOrDefault(cl => cl.ClassID == classid);

                    if (currentClass == null)
                    {
                        currentClass = new Class();
                        currentClass.rowguid = Guid.NewGuid();
                        currentClass.DateTimeStamp = DateTime.Now;
                        currentClass.LastModifiedBy = username;
                        isAdd = true;
                    }
                    currentClass.Name = name;
                    currentClass.CourseInstanceID = courseinstanceid;
                    currentClass.DateStart = start;
                    currentClass.DateEnd = end;
                    currentClass.InstructorPersonID = instructorID;
                    if (currentClass.AssistantPersonID != null && currentClass.AssistantPersonID != 0)
                    {
                        currentClass.AssistantPersonID = assistantid;
                    }
                    
                    currentClass.SpecificLocationID = locid;
                    currentClass.SiteLocationID = siteid;
                    currentClass.CurrentStatusTypeID = status;
                    currentClass.ClassTypeID = MapClassTypeID(typeid);
                    currentClass.LessonPlanID = lessonPlanid;

                    if (isAdd)
                    {
                        context.Classes.AddObject(currentClass);
                    }
                    context.SaveChanges();

                }
                return result;
            }
            catch (Exception ex)
            {
                ex.Log();
                result = false;
                return result;
            }
        }

        /// <summary>
        /// deletes specified Class, including all related data
        /// 
        /// </summary>
        /// <param name="courseid"></param>
        /// <returns></returns>
        public static string DeleteClass(int classid)
        {
            try
            {
                using (PODContext context = new PODContext())
                {

                    Class currentClass = context.Classes.FirstOrDefault(p => p.ClassID == classid);
                    if (currentClass != null)
                    {
                        context.Classes.DeleteObject(currentClass);
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
        #endregion

        #region LessonPlan

        /// <summary>
        ///gets lesson plan
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static LessonPlan GetLessonPlan(int planid)
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    return context.LessonPlans.Include(x => x.LessonPlanSet).Include(x => x.LessonPlanSet.StatusType).FirstOrDefault(pl => pl.LessonPlanID == planid);
                }

            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }
        }

        /// <summary>
        ///gets Lesson Plans Sets 
        ///that have a status of pre approved
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static List<LessonPlanSet> GetUnapprovedLessonPlansSetsByProgramID(int progID)
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    return context.LessonPlanSets.Include(x => x.Program).Include(x => x.Instructor).
                                               Include(x => x.StatusType).Where(ci => ci.ProgramID == progID && ci.StatusType.Name == "Pre-Approved").ToList();
                }
            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }

        }


        /// <summary>
        ///gets Lesson Plans Sets by search criteria 
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static List<LessonPlanSet> GetLessonPlanBySearchCriteria(string name)
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    return context.LessonPlanSets.Include(x => x.Program).Include(x => x.Instructor).
                                               Include(x => x.StatusType).Where(ci => ci.Name == name && ci.StatusType.Name == "Pre-Approved").ToList();
                }
            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }

        }



        /// <summary>
        ///gets Lesson Plans Sets 
        ///based on permissions and settings
        /// </summary>
        /// <param name="progID"></param>
        /// <param name="typeID"></param>
        /// <param name="siteid"></param>
        /// <param name="instructorid"></param>
        /// <param name="InstructorOnly"></param>
        /// <returns></returns>
        public static IEnumerable<LessonPlanSet> GetLessonPlansSetsByFilters(
            int progID,
            int? typeID,
            int? siteid,
            int? instructorid,
            bool InstructorOnly)
        {
            int statusTypeId = 1;
            if (typeID == 1)
            {
                statusTypeId = TypesData.GetTypeIDByName(TypesData.Types.StatusType, "Pre-Approved");
            }
            else if (typeID == 2)
            {
                statusTypeId = TypesData.GetTypeIDByName(TypesData.Types.StatusType, "Approved");
            }

            IEnumerable<LessonPlanSet> sets = new List<LessonPlanSet>();
            try
            {
                using (PODContext context = new PODContext())
                {
                    var unfilteredList = context.LessonPlanSets.Include(x => x.Program).Include(x => x.Instructor).
                                                Include(x => x.StatusType).Where(ci => ci.ProgramID == progID).ToList();

                    if (!typeID.HasValue && !siteid.HasValue && !instructorid.HasValue)//admin
                    {
                        sets = unfilteredList;
                    }
                    else
                    {
                        if (typeID.HasValue && (!siteid.HasValue || !instructorid.HasValue))
                        {
                            if (typeID == 1)//my stuff
                            {
                                if (InstructorOnly)
                                {
                                    sets = unfilteredList.Where(l => l.InstructorPersonID == instructorid && l.StatusTypeID == statusTypeId);
                                }
                                else //my people stuff
                                {
                                    if (instructorid.HasValue)
                                    {
                                        sets = unfilteredList.Where(l => l.InstructorPersonID == instructorid || l.SiteLocationID == siteid);
                                    }
                                    else
                                    {
                                        sets = unfilteredList.Where(l => l.SiteLocationID == siteid && l.StatusTypeID == statusTypeId);
                                    }

                                }
                            }
                            else if (typeID == 2)//approved lesson plan sets disregard who it belongs to
                            {
                                if (!instructorid.HasValue)
                                {
                                    sets = unfilteredList.Where(l => l.StatusTypeID == statusTypeId);
                                }
                                else
                                {
                                    sets = unfilteredList.Where(l => l.InstructorPersonID == instructorid && l.StatusTypeID == statusTypeId);
                                }

                            }
                        }
                        else if (instructorid.HasValue && InstructorOnly)
                        {
                            sets = unfilteredList.Where(l => l.InstructorPersonID == instructorid || l.LessonPlans.Any(lp => lp.InstructorPersonID == instructorid.Value));
                            sets = unfilteredList.Where(l => l.StatusTypeID == statusTypeId);
                        }
                        else if (siteid.HasValue)
                        {
                            sets = unfilteredList.Where(l => l.InstructorPersonID == instructorid || l.SiteLocationID == siteid);
                            sets = unfilteredList.Where(l => l.StatusTypeID == statusTypeId);
                        }
                    }
                }
                return sets.Distinct().ToList();
            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }

        }

        /// <summary>
        ///gets Lesson Plans Sets 
        ///that have a status of pre approved
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static IEnumerable<LessonPlanSet> GetLessonPlansSetsByFilters(IEnumerable<LessonPlanSet> currentLPS, int progID,
            int? locID, int? siteid, int? instructorid, int? statusid, int? assistantId, DateTime? startDate, DateTime? endDate, string nameLPS)
        {
            IEnumerable<LessonPlanSet> sets = new List<LessonPlanSet>();
            try
            {
                using (PODContext context = new PODContext())
                {

                    // use the filtered list already
                    //var unfilteredList = currentLPS;

                    var unfilteredList = context.LessonPlanSets.Include(x => x.Program).Include(x => x.Instructor).
                                               Include(x => x.StatusType).Where(ci => ci.ProgramID == progID).ToList();

                    if (!locID.HasValue && !siteid.HasValue && !instructorid.HasValue && !statusid.HasValue && string.IsNullOrWhiteSpace(nameLPS))
                    {
                        sets = unfilteredList;
                    }
                    else
                    {
                        sets = unfilteredList;
                        if (!string.IsNullOrEmpty(nameLPS))
                        {

                            sets =
                                sets.Where(l => l.Name.ToLower().Contains(nameLPS.ToLower()) || l.Name.ToLower() == nameLPS.ToLower()).ToList();
                        }
                        if (locID.HasValue)
                        {
                            sets =
                                sets.Where(l => l.SpecificLocationID == locID.Value).ToList();
                        }

                        //if (siteid.HasValue)
                        //{
                        //    sets =
                        //        sets.Where(l => l.SiteLocationID == siteid.Value).ToList();
                        //}
                        if (instructorid.HasValue)
                        {
                            sets =
                                sets.Where(l => l.InstructorPersonID == instructorid).ToList();
                        }
                        if (assistantId.HasValue)
                        {
                            sets =
                                sets.Where(l => l.AssistantPersonID == assistantId).ToList();
                        }
                        if (statusid.HasValue)
                        {
                            sets =
                                sets.Where(l => l.StatusTypeID == statusid.Value).ToList();
                        }

                    }
                }

                return sets.Distinct().ToList();
            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }
        }



        /// <summary>
        ///gets Lesson Plans Sets 
        ///that have a status of pre approved
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static IEnumerable<LessonPlanSet> GetLessonPlansSetsByFiltersAdmin(int progID, int? typeID, int? locID, int? siteid, int? instructorid, int? statusid, string classname)
        {
            IEnumerable<LessonPlanSet> sets = new List<LessonPlanSet>();
            try
            {
                using (PODContext context = new PODContext())
                {

                    var unfilteredList = context.LessonPlanSets.Include(x => x.Program).Include(x => x.Instructor).
                                                Include(x => x.StatusType).Where(ci => ci.ProgramID == progID).ToList();

                    if (!typeID.HasValue && !locID.HasValue && !siteid.HasValue && !instructorid.HasValue && !statusid.HasValue && string.IsNullOrEmpty(classname))
                    {
                        sets = unfilteredList;
                    }
                    else
                    {
                        sets = unfilteredList;
                        if (typeID.HasValue)
                        {
                            sets =
                                sets.Where(l => l.DisciplineTypeID == typeID.Value).ToList();
                        }
                        if (locID.HasValue)
                        {
                            sets =
                                sets.Where(l => l.SpecificLocationID == locID.Value).ToList();
                        }
                        if (siteid.HasValue)
                        {
                            sets =
                                sets.Where(l => l.SiteLocationID == siteid.Value).ToList();
                        }
                        if (instructorid.HasValue)
                        {
                            sets =
                                sets.Where(l => l.InstructorPersonID == instructorid || l.InstructorPersonID == instructorid).ToList();
                        }
                        if (statusid.HasValue)
                        {
                            sets =
                                sets.Where(l => l.StatusTypeID == statusid.Value).ToList();
                        }
                        if (!string.IsNullOrEmpty(classname))
                        {
                            sets =
                                sets.Where(l => l.Name.ToLower().Contains(classname) || l.Name.ToLower() == classname).ToList();
                        }
                    }
                }
                return sets.Distinct().ToList();
            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }
        }


        /// <summary>
        ///gets Lesson Plans by program
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static IEnumerable<LessonPlan> GetLessonPlansByProgramID(int progID)
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    return context.LessonPlans.Include(x => x.Program).Include(x => x.AgeGroup).Include(x => x.DisciplineType).Include(x => x.Site).Include(x => x.Location).Include(x => x.Instructor).
                                                Include(x => x.Assistant).Include(x => x.StatusType).Include(x => x.LessonPlanType).Where(ci => ci.ProgramID == progID).ToList();
                }
            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }

        }

        /// <summary>
        ///gets Lesson Plans by set
        /// </summary>
        /// <param name="instanceid"></param>
        /// <returns></returns>
        public static IEnumerable<LessonPlan> GetLessonPlansBySetID(int setID)
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    return context.LessonPlans.Where(ci => ci.LessonPlanSetID == setID).ToList();
                }
            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }

        }

        /// <summary>
        ///gets all skill type from lesson plan
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static IEnumerable<LifeSkillType> GetLifeSkillsByLessonPlanID(int planid)
        {
            List<LifeSkillType> list = new List<LifeSkillType>();
            try
            {
                using (PODContext context = new PODContext())
                {
                    LessonPlan plan = context.LessonPlans.FirstOrDefault(pl => pl.LessonPlanID == planid);
                    if (plan != null)
                    {
                        list = plan.LifeSkillTypes.ToList();

                    }
                }
                return list;
            }
            catch (Exception ex)
            {
                ex.Log();
                return list;
            }
        }

        /// <summary>
        /// deletes specified Lesson Plan, including all related data
        /// </summary>
        /// <param name="courseid"></param>
        /// <returns></returns>
        public static string DeleteLessonPlan(int planId)
        {
            string result = string.Empty;
            try
            {
                using (PODContext context = new PODContext())
                {

                    LessonPlan currentPlan = context.LessonPlans.Include(x => x.Classes).FirstOrDefault(p => p.LessonPlanID == planId);
                    if (currentPlan != null)
                    {
                        if (currentPlan.Classes != null && currentPlan.Classes.Count > 0)
                        {
                            result = "This lesson plan is used by a class you can't delete it";
                        }
                        else
                        {
                            context.LessonPlans.DeleteObject(currentPlan);
                            context.SaveChanges();
                        }
                    }
                }
                return result;
            }
            catch (Exception ex)
            {
                ex.Log();
                return ex.Message;
            }

        }

        /// <summary>
        ///updates or creates new lesson plan
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static int AddUpdateLessonPlan(LessonPlan plan, string username)
        {
            int result = 0;
            bool isAdd = false;
            try
            {
                using (PODContext context = new PODContext())
                {
                    LessonPlan origInstance = context.LessonPlans.FirstOrDefault(cc => cc.LessonPlanID == plan.LessonPlanID);

                    if (origInstance == null)
                    {
                        origInstance = new LessonPlan();
                        origInstance.rowguid = Guid.NewGuid();
                        origInstance.DateTimeStamp = DateTime.Now;
                        origInstance.LastModifiedBy = username;
                        origInstance.ProgramID = plan.ProgramID;
                        isAdd = true;
                    }
                    origInstance.StartDate = plan.StartDate;
                    origInstance.EndDate = plan.EndDate;
                    origInstance.LessonPlanSetID = plan.LessonPlanSetID;
                    origInstance.Name = plan.Name;
                    origInstance.LessonPlanTypeID = plan.LessonPlanTypeID;
                    origInstance.SpecificLocationID = plan.SpecificLocationID;
                    origInstance.SiteLocationID = plan.SiteLocationID;
                    origInstance.AgeGroupID = plan.AgeGroupID;
                    origInstance.DisciplineTypeID = plan.DisciplineTypeID;
                    origInstance.InstructorPersonID = plan.InstructorPersonID;
                    if(plan.AssistantPersonID > 0)
                    {
                        origInstance.AssistantPersonID = plan.AssistantPersonID;
                    }
                   
                    origInstance.StatusTypeID = plan.StatusTypeID;
                    origInstance.Discussion = plan.Discussion;
                    origInstance.Topic = plan.Topic;
                    origInstance.Objective = plan.Objective;
                    origInstance.Introduction = plan.Introduction;
                    origInstance.ActivityProcedures = plan.ActivityProcedures;
                    origInstance.WrapUpActivity = plan.WrapUpActivity;
                    origInstance.MaterialsNeeded = plan.MaterialsNeeded;
                    origInstance.WeekNumber = plan.WeekNumber;
                    origInstance.CommunityTheme = plan.CommunityTheme;
                    if (isAdd)
                    {
                        context.LessonPlans.AddObject(origInstance);
                    }
                    context.SaveChanges();
                    result = origInstance.LessonPlanID;
                }
                return result;
            }
            catch (Exception ex)
            {
                ex.Log();
                return result;
            }
        }


        /// <summary>
        ///adds skill type to lesson plan
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static bool AddLifeSkillToLessonPlan(int planid, int skillID)
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    LessonPlan origInstance = context.LessonPlans.FirstOrDefault(cc => cc.LessonPlanID == planid);

                    if (!origInstance.LifeSkillTypes.Any(l => l.LifeSkillTypeID == skillID))
                    {
                        LifeSkillType skillInstance = context.LifeSkillTypes.FirstOrDefault(l => l.LifeSkillTypeID == skillID);
                        origInstance.LifeSkillTypes.Add(skillInstance);
                        context.SaveChanges();
                    }

                }
                return true;
            }
            catch (Exception ex)
            {
                ex.Log();
                return false;
            }
        }

        /// <summary>
        ///deletes skill type from lesson plan
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static void DeleteLifeSkillFromLessonPlan(int planid, int skillID)
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    LessonPlan origInstance = context.LessonPlans.FirstOrDefault(cc => cc.LessonPlanID == planid);

                    LifeSkillType skillInstance = origInstance.LifeSkillTypes.FirstOrDefault(l => l.LifeSkillTypeID == skillID);
                    if (skillInstance != null)
                    {
                        origInstance.LifeSkillTypes.Remove(skillInstance);
                        context.SaveChanges();
                    }

                }
            }
            catch (Exception ex)
            {
                ex.Log();
            }
        }


        /// <summary>
        /// deletes specified Lesson Plan set, including all related data
        /// </summary>
        /// <param name="setId"></param>
        /// <returns></returns>
        public static string DeleteLessonPlanSet(int setId)
        {
            string result = string.Empty;
            try
            {
                using (PODContext context = new PODContext())
                {

                    LessonPlanSet currentSet = context.LessonPlanSets.Include(x => x.CourseInstances).FirstOrDefault(p => p.LessonPlanSetID == setId);
                    if (currentSet != null)
                    {
                        if (currentSet.CourseInstances != null && currentSet.CourseInstances.Count > 0)
                        {
                            result = "This lesson plan set is used by a class you can't delete it";
                        }
                        else
                        {
                            List<LessonPlan> plansInSet = currentSet.LessonPlans.ToList();
                            foreach (var lessonPlan in plansInSet)
                            {
                                context.LessonPlans.DeleteObject(lessonPlan);
                            }

                            List<LessonPlanSetTemplate> templates = currentSet.LessonPlanSetTemplates.ToList();

                            foreach (var template in templates)
                            {
                                context.LessonPlanSetTemplates.DeleteObject(template);
                            }

                            foreach (var lessonPlan in plansInSet)
                            {
                                context.LessonPlans.DeleteObject(lessonPlan);
                            }

                            context.LessonPlanSets.DeleteObject(currentSet);
                            context.SaveChanges();
                        }
                    }
                }
                return result;
            }
            catch (Exception ex)
            {
                ex.Log();
                return ex.Message;
            }

        }

        /// <summary>
        ///gets lesson plan set
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static LessonPlanSet GetLessonPlanSet(int setId)
        {

            try
            {
                using (PODContext context = new PODContext())
                {
                    return context.LessonPlanSets.Include(x => x.StatusType).FirstOrDefault(pl => pl.LessonPlanSetID == setId);
                }

            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }
        }



        public static int AddUpdateLessonPlanSet(LessonPlanSet plan, int statusTypeid, string username)
        {
            int result = 0;
            bool isAdd = false;
            try
            {
                using (PODContext context = new PODContext())
                {
                    LessonPlanSet origInstance = context.LessonPlanSets.FirstOrDefault(cc => cc.LessonPlanSetID == plan.LessonPlanSetID);

                    if (origInstance == null)
                    {
                        origInstance = new LessonPlanSet();
                        origInstance.rowguid = Guid.NewGuid();
                        origInstance.DateTimeStamp = DateTime.Now;
                        origInstance.ProgramID = plan.ProgramID;
                        origInstance.LastModifiedBy = username;
                        origInstance.StatusTypeID = statusTypeid;
                        origInstance.StartDate = plan.StartDate;
                        origInstance.EndDate = plan.EndDate;
                        origInstance.AgeGroupID = plan.AgeGroupID;
                        if (origInstance.AssistantPersonID != null && origInstance.AssistantPersonID != 0)
                        {
                            origInstance.AssistantPersonID = plan.AssistantPersonID;
                        }
                        
                        origInstance.DisciplineTypeID = plan.DisciplineTypeID;
                        origInstance.InstructorPersonID = plan.InstructorPersonID;
                        origInstance.SiteLocationID = plan.SiteLocationID;
                        origInstance.SpecificLocationID = plan.SpecificLocationID;
                        isAdd = true;
                    }
                    else //on edit simply keep the status 
                    {

                        origInstance.StatusTypeID = statusTypeid != 0 ? statusTypeid : plan.StatusTypeID;
                        origInstance.DateTimeStamp = DateTime.Now;
                        origInstance.ProgramID = plan.ProgramID;
                        origInstance.LastModifiedBy = username;
                        origInstance.StatusTypeID = statusTypeid;
                        origInstance.StartDate = plan.StartDate;
                        origInstance.EndDate = plan.EndDate;
                        origInstance.AgeGroupID = plan.AgeGroupID;
                        if (origInstance.AssistantPersonID != null && origInstance.AssistantPersonID != 0)
                        {
                            origInstance.AssistantPersonID = plan.AssistantPersonID;
                        }
                        
                        origInstance.DisciplineTypeID = plan.DisciplineTypeID;
                        origInstance.InstructorPersonID = plan.InstructorPersonID;
                        origInstance.SiteLocationID = plan.SiteLocationID;
                        origInstance.SpecificLocationID = plan.SpecificLocationID;
                    }
                    origInstance.Name = plan.Name;
                    origInstance.InstructorPersonID = plan.InstructorPersonID;
                    origInstance.IsPublic = plan.IsPublic;


                    if (isAdd)
                    {
                        context.LessonPlanSets.AddObject(origInstance);
                    }
                    else //on eidt make sure we stay consistent
                    {
                        List<LessonPlan> plans =
                            context.LessonPlans.Where(l => l.LessonPlanSetID == plan.LessonPlanSetID).ToList();
                        foreach (var lessonPlan in plans)
                        {
                            lessonPlan.InstructorPersonID = plan.InstructorPersonID;
                            lessonPlan.Name = plan.Name;
                        }
                    }
                    context.SaveChanges();
                    result = origInstance.LessonPlanSetID;
                }
                return result;
            }
            catch (Exception ex)
            {
                ex.Log();
                return result;
            }
        }


        public static string UpdateLessonPlanSets(IList<int> planIDList, int statusTypeid, string username)
        {
            string result = string.Empty;
            try
            {
                using (PODContext context = new PODContext())
                {
                    foreach (int setID in planIDList)
                    {
                        LessonPlanSet origInstance = context.LessonPlanSets.FirstOrDefault(cc => cc.LessonPlanSetID == setID);
                        origInstance.StatusTypeID = statusTypeid;
                        origInstance.LastModifiedBy = username;
                    }
                    context.SaveChanges();
                }
                return result;
            }
            catch (Exception ex)
            {
                ex.Log();
                return ex.Message.ToString();
            }
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

            try
            {
                using (PODContext context = new PODContext())
                {
                    return context.Communities.FirstOrDefault(pl => pl.CommunityID == id);
                }

            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }
        }

        /// <summary>
        /// deletes specified Community, including all related data
        /// </summary>
        /// <param name="courseid"></param>
        /// <returns></returns>
        public static string DeleteCommunity(int Id)
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    Community currentCommunity = context.Communities.FirstOrDefault(p => p.CommunityID == Id);
                    if (currentCommunity != null)
                    {
                        context.Communities.DeleteObject(currentCommunity);
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
        ///updates or creates new Community
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static int AddUpdateCommunity(int id, string name, string desc, string username)
        {
            int result = 0;
            bool isAdd = false;
            try
            {
                using (PODContext context = new PODContext())
                {
                    Community origInstance = context.Communities.FirstOrDefault(cc => cc.CommunityID == id);

                    if (origInstance == null)
                    {
                        origInstance = new Community();
                        origInstance.rowguid = Guid.NewGuid();
                        origInstance.DateTimeStamp = DateTime.Now;

                        isAdd = true;
                    }
                    origInstance.Name = name;
                    origInstance.Description = desc;


                    if (isAdd)
                    {
                        context.Communities.AddObject(origInstance);
                    }
                    context.SaveChanges();
                    result = origInstance.CommunityID;
                }
                return result;
            }
            catch (Exception ex)
            {
                ex.Log();
                return result;
            }
        }

        /// <summary>
        ///adds county to Community
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static bool AddCountyToCommunity(int countyid, int comID)
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    Community origInstance = context.Communities.FirstOrDefault(cc => cc.CommunityID == comID);

                    if (!origInstance.Counties.Any(l => l.CountyID == countyid))
                    {
                        County ct = context.Counties.FirstOrDefault(l => l.CountyID == countyid);
                        origInstance.Counties.Add(ct);
                        context.SaveChanges();
                    }

                }
                return true;
            }
            catch (Exception ex)
            {
                ex.Log();
                return false;
            }
        }

        /// <summary>
        ///deletes County From Community
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static void DeleteCountyFromCommunity(int countyid, int comID)
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    Community origInstance = context.Communities.FirstOrDefault(cc => cc.CommunityID == comID);

                    County ct = origInstance.Counties.FirstOrDefault(l => l.CountyID == countyid);
                    if (ct != null)
                    {
                        origInstance.Counties.Remove(ct);
                        context.SaveChanges();
                    }

                }
            }
            catch (Exception ex)
            {
                ex.Log();
            }
        }

        /// <summary>
        ///gets Community 
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static IEnumerable<County> GetCountiesForCommunityByID(int id)
        {

            try
            {
                using (PODContext context = new PODContext())
                {
                    return context.Counties.Where(pl => pl.Communities.Any(c => c.CommunityID == id)).ToList();
                }

            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }
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

            try
            {
                using (PODContext context = new PODContext())
                {
                    return context.Circuits.FirstOrDefault(pl => pl.CircuitID == id);
                }

            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }
        }

        /// <summary>
        /// deletes specified Circuit, including all related data
        /// </summary>
        /// <param name="courseid"></param>
        /// <returns></returns>
        public static string DeleteCircuit(int Id)
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    Circuit currentCircuit = context.Circuits.FirstOrDefault(p => p.CircuitID == Id);
                    if (currentCircuit != null)
                    {
                        context.Circuits.DeleteObject(currentCircuit);
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
        ///updates or add Circuit
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static int AddUpdateCircuit(int id, string name, string username)
        {
            int result = 0;
            bool isAdd = false;
            try
            {
                using (PODContext context = new PODContext())
                {
                    Circuit origInstance = context.Circuits.FirstOrDefault(cc => cc.CircuitID == id);

                    if (origInstance == null)
                    {
                        origInstance = new Circuit();
                        origInstance.rowguid = Guid.NewGuid();
                        origInstance.DateTimeStamp = DateTime.Now;

                        isAdd = true;
                    }
                    origInstance.Name = name;

                    if (isAdd)
                    {
                        context.Circuits.AddObject(origInstance);
                    }
                    context.SaveChanges();
                    result = origInstance.CircuitID;
                }
                return result;
            }
            catch (Exception ex)
            {
                ex.Log();
                return result;
            }
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

            try
            {
                using (PODContext context = new PODContext())
                {
                    return context.Counties.FirstOrDefault(pl => pl.CountyID == id);
                }

            }
            catch (Exception ex)
            {
                ex.Log();
                return null;
            }
        }

        /// <summary>
        /// deletes specified County, including all related data
        /// </summary>
        /// <param name="courseid"></param>
        /// <returns></returns>
        public static string DeleteCounty(int Id)
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    County currentCounty = context.Counties.FirstOrDefault(p => p.CountyID == Id);
                    if (currentCounty != null)
                    {
                        context.Counties.DeleteObject(currentCounty);
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
        ///updates or add County
        /// </summary>
        /// <param name="classid"></param>
        /// <returns></returns>
        public static int AddUpdateCounty(int id, string name, int circuitid, string username)
        {
            int result = 0;
            bool isAdd = false;
            try 
            {
                using (PODContext context = new PODContext())
                {
                    County origInstance = context.Counties.FirstOrDefault(cc => cc.CountyID == id);

                    if (origInstance == null)
                    {
                        origInstance = new County();
                        origInstance.rowguid = Guid.NewGuid();
                        origInstance.DateTimeStamp = DateTime.Now;

                        isAdd = true;
                    }
                    origInstance.Name = name;
                    origInstance.CircuitID = circuitid;

                    if (isAdd)
                    {
                        context.Counties.AddObject(origInstance);
                    }
                    context.SaveChanges();
                    result = origInstance.CountyID;
                }
                return result;
            }
            catch (Exception ex)
            {
                ex.Log();
                return result;
            }
        }
        #endregion
    }
}
