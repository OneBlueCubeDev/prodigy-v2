using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using POD.Data.Entities;

namespace POD.Logic
{
    public static class PersonRelatedLogic
    {
        #region Enrollment
        public static int AddUpdateEnrollment(int programid, int enrollmentid, int personid, int riskID, int typeid, int referraltypeid, int agencyTypeID, int statusTypeid, DateTime? dateApplied, DateTime? dateAdmitted, string notes, bool isWrapAroundServices, DateTime? PreWebDateAdmitted)
        {
            return POD.Data.EnrollmentData.AddUpdateEnrollment(programid, enrollmentid, personid, riskID, typeid, referraltypeid, agencyTypeID, statusTypeid, dateApplied, dateAdmitted, notes, Security.GetCurrentUserProfile().UserName, isWrapAroundServices, PreWebDateAdmitted);
        }



        public static int AddUpdateEnrollment(int programid, int enrollmentid, int? siteLocationID, int? locationID, int personid, int typeid, int statusTypeid, DateTime? dateApplied, string recommendedBy, bool isWrapAroundServices, DateTime? PreWebDateAdmitted)
        {
            return POD.Data.EnrollmentData.AddUpdateEnrollment(programid, enrollmentid, siteLocationID, locationID, personid, typeid, statusTypeid, dateApplied, recommendedBy,Security.GetCurrentUserProfile().UserName, isWrapAroundServices, PreWebDateAdmitted);
        }
        public static int UpdateEnrollment(int enrollmentid, int riskID)
        {
            return POD.Data.EnrollmentData.UpdateEnrollment(enrollmentid, riskID, Security.GetCurrentUserProfile().UserName);
        }
        public static int UpdateEnrollment(int enrollmentid, int riskID, int statusID)
        {
            return POD.Data.EnrollmentData.UpdateEnrollment(enrollmentid, riskID, statusID, Security.GetCurrentUserProfile().UserName);
        }
        /// <summary>
        /// gets all enrollment for identifier
        /// </summary>
        /// <param name="personid"></param>
        /// <returns></returns>
        public static Enrollment GetEnrollmentByID(int enrollid)
        {
            return POD.Data.EnrollmentData.GetEnrollmentByID(enrollid);
        }
        /// <summary>
        /// gets latest audit record if exist
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public static Enrollments_Audit GetEnrollmentAudit(int key)
        {
            return POD.Data.EnrollmentData.GetEnrollmentAudit(key);
        }

        /// <summary>
        /// gets all enrollments for person
        /// </summary>
        /// <param name="personid"></param>
        /// <returns></returns>
        public static List<Enrollment> GetEnrollmentsByPersonID(int personid)
        {
            return POD.Data.EnrollmentData.GetEnrollmentsByPersonID(personid);
        }

        public static List<EnrollmentNote> GetEnrollmentNotesByEnrollmentID(int enrollmentId)
        {
            return POD.Data.EnrollmentData.GetEnrollmentNotesByEnrollmentID(enrollmentId);
        }

        public static int AddUpdateEnrollmentNoteById(int noteId, int noteContactTypeId, int enrollmentID, string followUp, string enrollmentnote, string username, DateTime noteDate , string contactPerson)
        {
            return POD.Data.EnrollmentData.AddUpdateEnrollmentNoteById(noteId, noteContactTypeId, enrollmentID, followUp, enrollmentnote, Security.GetCurrentUserProfile().UserName, noteDate, contactPerson);
        }

        /// <summary>
        /// gets all enrollments for person and grant year
        /// </summary>
        /// <param name="personid"></param>
        /// <returns></returns>
        public static List<Enrollment> GetEnrollmentsByGrantYearByPersonID(int personid, DateTime grantYearDateReference)
        {
            return POD.Data.EnrollmentData.GetEnrollmentsByGrantYearByPersonID(personid, grantYearDateReference);
        }

        /// <summary>
        /// sets all release information on the enrollment record
        /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static string ReleaseEnrollment(int enrollID, int statusid, DateTime releaseDate, string releaseAgency, string reason)
        {
            return POD.Data.EnrollmentData.ReleaseEnrollment(enrollID, statusid, releaseDate, releaseAgency, reason, Security.GetCurrentUserProfile().UserName);
        }

        public static bool IsDateAHoliday()
        {
            var result = POD.Data.EnrollmentData.IsDateAHoliday(DateTime.Now);
            return result;
        }

        public static string DeleteEnrollment(int enrollmentid)
        {
            int? raID = POD.Data.RiskAssessmentData.GetRiskAssessmentIDByEnrollmentID(enrollmentid);
            string result = POD.Data.EnrollmentData.DeleteEnrollment(enrollmentid, Security.GetCurrentUserProfile().UserName);
            if (raID != null)
            {
                DeleteOrphanedRiskAssessment(raID.Value);
            }
            return result;
        }
        #endregion

        #region RiskAssessment

        /// <summary>
        /// returns riskassessment for enrollment
        /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static RiskAssessment GetRiskAssessmentByEnrollmentID(int enrollID)
        {
            return POD.Data.RiskAssessmentData.GetRiskAssessmentByEnrollmentID(enrollID);
        }

        /// <summary>
        /// returns riskassessment for person
        /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static RiskAssessment GetRiskAssessmentByPersonID(int personid)
        {
            return POD.Data.RiskAssessmentData.GetRiskAssessmentByPersonID(personid);
        }
        /// <summary>
        /// returns riskassessment for enrollment
        /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static RiskAssessment GetRiskAssessmentByID(int riskID)
        {
            return POD.Data.RiskAssessmentData.GetRiskAssessmentByID(riskID);
        }

        /// <summary>
        /// returns riskassessment for enrollment
        /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static int AddUpdateRiskAssessment(RiskAssessment currentAssessment)
        {
            return POD.Data.RiskAssessmentData.AddUpdateRiskAssessment(currentAssessment, Security.GetCurrentUserProfile().UserName);
        }

        /// <summary>
        /// delete identified riskassessment
        /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static string DeleteRiskAssessment(int riskID)
        {
            int[] enrollmentIDs = POD.Data.EnrollmentData.GetEnrollmentIDsByRiskAssessmentID(riskID);
            foreach (var enrollmentID in enrollmentIDs)
            {
                POD.Data.EnrollmentData.DeleteEnrollment(enrollmentID, Security.GetCurrentUserProfile().UserName);
            }
            return POD.Data.RiskAssessmentData.DeleteRiskAssessment(riskID);
        }

        public static string DeleteOrphanedRiskAssessment(int riskID)
        {
            int[] enrollmentIDs = POD.Data.EnrollmentData.GetEnrollmentIDsByRiskAssessmentID(riskID);
            if (enrollmentIDs.Length == 0)
                return POD.Data.RiskAssessmentData.DeleteRiskAssessment(riskID);
            return null;
        }

        #endregion

        #region ClassAttendance

        /// <summary>
        /// returns class attendance for person
        /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static ClassAttendance GetClassAttendanceByPersonAndClass(int personid, int classid)
        {
            return POD.Data.AttendanceData.GetClassAttendanceByPersonAndClass(personid, classid);
        }
        /// <summary>
        /// returns class attendance for person
        /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static List<sp_GetPersonAttendanceAndEvents_Result> GetAttendanceByPerson(int programid, int personid)
        {
            return POD.Data.ProgramCourseClassData.GetAttendancesAndEventsByPerson(programid, personid);
        }

        /// <summary>
        /// adds /updates class attendance for person
        /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static string AddUpdateClassAttendance(int attendanceid, int personid, int classid, bool leftEarly, bool isTardy, string notes, bool isAlternateActivity)
        {
            return POD.Data.AttendanceData.AddUpdateClassAttendance(attendanceid, personid, classid, leftEarly, isTardy, notes, Security.GetCurrentUserProfile().UserName, isAlternateActivity);
        }
        /// <summary>
        /// delete attendance
        /// </summary>
        /// <returns></returns>
        public static string DeleteClassAttendance(int attendanceid)
        {
            return POD.Data.AttendanceData.DeleteClassAttendance(attendanceid, Security.GetCurrentUserProfile().UserName);
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
            return POD.Data.AttendanceData.GetEventAttendanceByPersonAndEvent(personid, eventAttendanceID);
        }

        /// <summary>
        /// adds /updates event attendance for person
        /// </summary>
        /// <returns></returns>
        public static string AddUpdateEventAttendance(int attendanceid, int personid, int eventid)
        {
            return POD.Data.AttendanceData.AddUpdateEventAttendance(attendanceid, personid, eventid, Security.GetCurrentUserProfile().UserName);
        }

        /// <summary>
        /// delete attendance
        /// </summary>
        /// <returns></returns>
        public static string DeleteEventAttendance(int attendanceid)
        {
            return POD.Data.AttendanceData.DeleteEventAttendance(attendanceid, Security.GetCurrentUserProfile().UserName);
        }
        #endregion

        #region CourseInstances
        /// <summary>
        /// gets all students that are assigned to course
        /// </summary>
        /// <returns>list</returns>
        public static IEnumerable<Student> GetStudentsByCourseInstanceID(int id)
        {
            return POD.Data.PeopleData.GetStudentsByCourseInstanceID(id);
        }
        #endregion

        public static void UpdateEnrollmentLocation(int enrollmentID, int? locationID, int? siteLocationID)
        {
            POD.Data.EnrollmentData.UpdateEnrollmentLocation(enrollmentID, locationID, siteLocationID);
        }

        public static List<Student> GetStudentsForCourseRegistration(int siteLocationID, DateTime registrationStartDate)
        {
            return POD.Data.PeopleData.GetStudentsForCourseRegistration(siteLocationID, registrationStartDate);
        }
    }
}
