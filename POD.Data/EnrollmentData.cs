using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using POD.Data.Entities;
using POD.Logging;

namespace POD.Data
{
    public static class EnrollmentData
    {

        public static int AddUpdateEnrollment(int programid, int enrollmentid, int personid, int riskID, int typeid, int referraltypeid, int agencyTypeID, int statusTypeid, DateTime? dateApplied, DateTime? dateAdmitted, string notes, string username, bool isWrapAroundServices, DateTime? PreWebDateAdmitted)
        {
            int newEnrollmentID = 0;
            bool isAdd = false;
            using (PODContext context = new PODContext())
            {
                try
                {
                    Enrollment enroll = context.Enrollments.FirstOrDefault(e => e.EnrollmentID == enrollmentid);
                    if (enroll == null)
                    {
                        isAdd = true;
                        enroll = new Enrollment();
                        enroll.rowguid = Guid.NewGuid();
                        enroll.DateTimeStamp = DateTime.Now;
                        enroll.ProgramID = programid;
                    }

                    enroll.LastModifiedBy = username;
                    enroll.RiskAssessmentID = riskID;
                    enroll.EnrollmentTypeID = typeid;
                    enroll.ReferralTypeID = referraltypeid;
                    enroll.ReferringAgencyTypeID = agencyTypeID;
                    enroll.StatusTypeID = statusTypeid;
                    enroll.DateApplied = dateApplied;
                    enroll.DateAdmitted = dateAdmitted;
                    enroll.Admitted = dateAdmitted != null;
                    enroll.FollowUpNotes = notes;
                    enroll.PersonID = personid;
                    enroll.isWrapAroundServices = isWrapAroundServices;
                    enroll.PreWebDateAdmitted = PreWebDateAdmitted;

                    if (isAdd)
                    {
                        context.Enrollments.AddObject(enroll);
                    }
                    context.SaveChanges();
                    newEnrollmentID = enroll.EnrollmentID;
                }
                catch (Exception ex)
                {
                    ex.Log();
                }
                return newEnrollmentID;
            }
        }
        /// <summary>
        /// this sets the applied date and status 
        /// </summary>
        /// <param name="enrollmentid"></param>
        /// <param name="personid"></param>
        /// <param name="typeid"></param>
        /// <param name="dateApplied"></param>
        /// <param name="username"></param>
        /// <returns></returns>
        public static int AddUpdateEnrollment(int programid, int enrollmentid, int? siteLocationID, int? locationID, int personid, int typeid, int statusTypeid, DateTime? dateApplied, string recommendedBy, string username, bool isWrapAroundServices, DateTime? PreWebDateAdmitted)
        {
            int newEnrollmentID = 0;
            bool isAdd = false;
            using (PODContext context = new PODContext())
            {
                try
                {
                    Enrollment enroll = context.Enrollments.FirstOrDefault(e => e.EnrollmentID == enrollmentid);
                    if (enroll == null)
                    {
                        isAdd = true;
                        enroll = new Enrollment();
                        enroll.rowguid = Guid.NewGuid();
                        enroll.DateTimeStamp = DateTime.Now;
                        enroll.ProgramID = programid;
                        enroll.DateAdmitted = DateTime.Now;
                        enroll.Admitted = true;
                    }
                    enroll.RecommendedBy = recommendedBy;
                    enroll.SiteLocationID = siteLocationID;
                    enroll.LocationID = locationID;
                    enroll.StatusTypeID = statusTypeid;
                    enroll.EnrollmentTypeID = typeid;
                    enroll.LastModifiedBy = username;
                    enroll.DateApplied = dateApplied;
                    enroll.PersonID = personid;
                    enroll.isWrapAroundServices = isWrapAroundServices;
                    enroll.PreWebDateAdmitted = PreWebDateAdmitted;

                    if (isAdd)
                    {
                        context.Enrollments.AddObject(enroll);
                    }
                    context.SaveChanges();
                    newEnrollmentID = enroll.EnrollmentID;
                }
                catch (Exception ex)
                {
                    ex.Log();
                }
                return newEnrollmentID;
            }
        }

        public static int UpdateEnrollment(int enrollmentid, int riskID, string username)
        {
            int newEnrollmentID = 0;
            using (PODContext context = new PODContext())
            {
                try
                {
                    Enrollment enroll = context.Enrollments.FirstOrDefault(e => e.EnrollmentID == enrollmentid);

                    enroll.LastModifiedBy = username;
                    enroll.RiskAssessmentID = riskID;

                    context.SaveChanges();
                    newEnrollmentID = enroll.EnrollmentID;
                }
                catch (Exception ex)
                {
                    ex.Log();
                }
                return newEnrollmentID;
            }
        }

        public static int UpdateEnrollmentAppliedDate(int personId, DateTime completedPATDate)
        {
            int newEnrollmentID = 0;
            using (PODContext context = new PODContext())
            {
                try
                {
                    Enrollment enroll = context.Enrollments.FirstOrDefault(e => e.PersonID == personId);

                    //if (enroll.DateApplied == null)
                    //{
                        enroll.StatusTypeID = 2;
                        enroll.DateApplied = completedPATDate;
                        context.SaveChanges();
                    //}

                    newEnrollmentID = enroll.EnrollmentID;
                }
                catch (Exception ex)
                {
                    ex.Log();
                }
                return newEnrollmentID;
            }
        }

        public static int UpdateEnrollment(int enrollmentid, int riskID, int statusid, string username)
        {
            int newEnrollmentID = 0;
            using (PODContext context = new PODContext())
            {
                try
                {
                    Enrollment enroll = context.Enrollments.FirstOrDefault(e => e.EnrollmentID == enrollmentid);

                    enroll.LastModifiedBy = username;
                    enroll.RiskAssessmentID = riskID;
                    enroll.StatusTypeID = statusid;
                    context.SaveChanges();
                    newEnrollmentID = enroll.EnrollmentID;
                }
                catch (Exception ex)
                {
                    ex.Log();
                }
                return newEnrollmentID;
            }
        }

        public static string DeleteEnrollment(int enrollmentid, string username)
        {
            string result = string.Empty;
            using (PODContext context = new PODContext())
            {
                try
                {
                    context.DeleteEnrollment(enrollmentid);
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
        /// gets all enrollments disregarding the status
        /// </summary>
        /// <param name="personid"></param>
        /// <returns></returns>
        public static List<Enrollment> GetEnrollmentsByPersonID(int personid)
        {
            using (PODContext context = new PODContext())
            {
                return context.Enrollments.Where(e => e.PersonID == personid).ToList();
            }
        }

        public static List<EnrollmentNote> GetEnrollmentNotesByEnrollmentID(int enrollmentid)
        {
            List<EnrollmentNote> resultNotes = new List<EnrollmentNote>();
            using (PODContext context = new PODContext())
            {
                resultNotes =  context.EnrollmentNotes.Include("NoteContactType").Include("Enrollment").Where(e => e.EnrollmentID == enrollmentid).ToList();
            }
            return resultNotes;
        }

        public static int AddUpdateEnrollmentNoteById(int noteid, int noteContactTypeId, 
            int enrollmentID, string followUp, string enrollmentnote, string username, DateTime noteDate, string contactPerson )
        {
            int newEnrollmentNoteID = noteid;
            bool isAdd = false;
            using (PODContext context = new PODContext())
            {

                try
                {
                    EnrollmentNote enrollNote = context.EnrollmentNotes.FirstOrDefault(e => e.EnrollmentNoteID == newEnrollmentNoteID);
                    if (enrollNote == null)
                    {
                        isAdd = true;
                        enrollNote = new EnrollmentNote();
                        enrollNote.rowguid = Guid.NewGuid();
                        enrollNote.DateTimeStamp = DateTime.Now;
                        enrollNote.DateCreated = DateTime.Now;
                        enrollNote.CreateUserName = username;
                    }

                    enrollNote.Note = enrollmentnote;
                    enrollNote.Followup = followUp;
                    enrollNote.NoteContactTypeID = noteContactTypeId;
                    enrollNote.LastModifiedBy = username;
                    enrollNote.EnrollmentID = enrollmentID;
                    enrollNote.UpdateUserName = username;
                    enrollNote.DateUpdated = DateTime.Now;
                    enrollNote.ContactPerson = contactPerson;
                    

                    if (isAdd)
                    {
                        context.EnrollmentNotes.AddObject(enrollNote);
                    }
                    context.SaveChanges();
                    newEnrollmentNoteID = enrollNote.EnrollmentNoteID;
                }
                catch (Exception ex)
                {
                    ex.Log();
                }
                return newEnrollmentNoteID;
            }
        }
        /// <summary>
        /// gets all enrollments for person and grant year
        /// </summary>
        /// <param name="personid"></param>
        /// <returns></returns>
        public static List<Enrollment> GetEnrollmentsByGrantYearByPersonID(int personid, DateTime grantYearDateReference)
        {
            DateTime? startGrantYear = null;
            DateTime? endGrantYear = null;
            using (PODContext context = new PODContext())
            {
                TimePeriod currentPeriod = context.TimePeriods.FirstOrDefault(tp => tp.StartDate.HasValue && tp.EndDate.HasValue &&
                                                          grantYearDateReference >= tp.StartDate && grantYearDateReference <= tp.EndDate);
                if (currentPeriod != null)
                {
                    startGrantYear = currentPeriod.StartDate;
                    endGrantYear = currentPeriod.EndDate;
                }
                if (startGrantYear.HasValue && endGrantYear.HasValue)
                {
                    return context.Enrollments.Where(e => e.PersonID == personid && e.DateApplied >= startGrantYear && e.DateApplied <= endGrantYear).ToList();
                }
                else
                {
                    return context.Enrollments.Where(e => e.PersonID == personid).ToList();
                }
            }
        }



        /// <summary>
        /// gets all enrollment for identifier
        /// </summary>
        /// <param name="personid"></param>
        /// <returns></returns>
        public static Enrollment GetEnrollmentByID(int enrollid)
        {
            using (PODContext context = new PODContext())
            {
                return context.Enrollments.Include(x => x.RiskAssessment).FirstOrDefault(e => e.EnrollmentID == enrollid);
            }
        }

        /// <summary>
        /// gets enrollment for specified risk assessment id
        /// </summary>
        /// <param name="personid"></param>
        /// <returns></returns>
        public static Enrollment GetEnrollmentByRiskAssessmentID(int raid)
        {
            using (PODContext context = new PODContext())
            {
                return context.Enrollments.OrderByDescending(e => e.DateTimeStamp).FirstOrDefault(e => e.RiskAssessmentID == raid);
            }
        }

        public static int[] GetEnrollmentIDsByRiskAssessmentID(int riskassessmentID)
        {
            using (PODContext context = new PODContext())
            {
                return
                    context.Enrollments.Where(x => x.RiskAssessmentID == riskassessmentID)
                           .Select(x => x.EnrollmentID)
                           .ToArray();
            }
        }

        /// <summary>
        /// gets latest audit record if exist
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public static Enrollments_Audit GetEnrollmentAudit(int key)
        {
            using (PODContext context = new PODContext())
            {
                return context.Enrollments_Audit.Where(e => e.EnrollmentID == key).OrderByDescending(e => e.DateTimeStamp).FirstOrDefault();
            }
        }

        /// <summary>
        /// sets all release information on the enrollment record in list
        /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static string ReleaseEnrollmentList(List<int> enrollListID, int statusid, DateTime releaseDate, string releaseAgency, string reason, string username)
        {
            string results = string.Empty;
            using (PODContext context = new PODContext())
            {
                try
                {
                    foreach (int enrollID in enrollListID)
                    {
                        Enrollment currentEnrollment = context.Enrollments.FirstOrDefault(r => r.EnrollmentID == enrollID);
                        if (currentEnrollment == null)
                        {
                            results += string.Format("Enrollment with ID: {} could not be found <br/>", enrollID);
                        }
                        else
                        {
                            currentEnrollment.LastModifiedBy = username;
                            currentEnrollment.RelReasonForLeaving = reason;
                            currentEnrollment.RelAgency = releaseAgency;
                            currentEnrollment.RelDate = releaseDate;
                            currentEnrollment.StatusTypeID = statusid;

                            if (currentEnrollment.RiskAssessmentID.HasValue)
                            {
                                RiskAssessment ra = currentEnrollment.RiskAssessment;
                                ra.LastModifiedBy = username;
                                ra.DateModified = DateTime.Now;
                                ra.RelReasonForLeaving = reason;
                                ra.RelAgency = releaseAgency;
                                ra.RelDate = releaseDate;
                                ra.StatusTypeID = statusid;
                            }

                        }
                    }
                    context.SaveChanges();
                }
                catch (Exception ex)
                {
                    ex.Log();
                    results += "Error Message: " + ex.Message;
                }
            }
            return results;
        }
        /// <summary>
        /// sets all release information on the enrollment record
        /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static string ReleaseEnrollment(int enrollID, int statusid, DateTime releaseDate, string releaseAgency, string reason, string username)
        {
            string results = string.Empty;
            using (PODContext context = new PODContext())
            {
                try
                {
                    Enrollment currentEnrollment = context.Enrollments.FirstOrDefault(r => r.EnrollmentID == enrollID);
                    if (currentEnrollment == null)
                    {
                        results += string.Format("Enrollment with ID: {} could not be found <br/>", enrollID);
                    }
                    else
                    {
                        currentEnrollment.LastModifiedBy = username;
                        currentEnrollment.RelReasonForLeaving = reason;
                        currentEnrollment.RelAgency = releaseAgency;
                        currentEnrollment.RelDate = releaseDate;
                        currentEnrollment.StatusTypeID = statusid;
                        context.SaveChanges();
                    }
                }
                catch (Exception ex)
                {
                    ex.Log();
                    results += "Error Message: " + ex.Message;
                }
            }
            return results;
        }

        public static bool IsDateAHoliday(DateTime currentDate)
        {
            try
            {
                using (PODContext context = new PODContext())
                {
                    // Check if any holiday matches the provided date
                    bool isHoliday = context.Holidays.Any(h => h.HolidayDate == currentDate.Date);

                    // Return the result directly
                    return isHoliday;
                }
            }
            catch (Exception ex)
            {
                // Log or handle the exception appropriately
                Console.WriteLine($"An error occurred: {ex.Message}");
                return false; // or throw the exception if appropriate for your scenario
            }

        }

        public static void SetEnrollmentDateGraduated(int enrollmentId, DateTime date)
        {
            using (PODContext context = new PODContext())
            {
                var enrollment = context.Enrollments.FirstOrDefault(
                    x => x.EnrollmentID == enrollmentId && x.DateGraduated == null);
                if (enrollment != null)
                {
                    enrollment.DateGraduated = date;
                    context.SaveChanges();
                }
            }
        }

        public static void UpdateEnrollmentLocation(int enrollmentID, int? locationID, int? siteLocationID)
        {
            using (var context = new PODContext())
            {
                var enrollment = context.Enrollments.SingleOrDefault(x => x.EnrollmentID == enrollmentID);
                if (enrollment != null)
                {
                    enrollment.LocationID = locationID;
                    enrollment.SiteLocationID = siteLocationID;
                    context.SaveChanges();
                }
            }
        }
    }
}
