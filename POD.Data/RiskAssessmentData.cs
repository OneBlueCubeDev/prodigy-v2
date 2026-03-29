using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using POD.Data.Entities;
using POD.Logging;

namespace POD.Data
{
    public static class RiskAssessmentData
    {
        /// <summary>
        /// returns riskassessment for enrollment
        /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static RiskAssessment GetRiskAssessmentByEnrollmentID(int enrollID)
        {
            using (PODContext context = new PODContext())
            {
                return context.RiskAssessments.Include(x => x.Enrollments).Include(x => x.Person).FirstOrDefault(p => p.Enrollments.Any(e => e.EnrollmentID == enrollID));
            }
        }

        public static int? GetRiskAssessmentIDByEnrollmentID(int enrollmentID)
        {
            using (PODContext context = new PODContext())
            {
                return context.Enrollments.Where(x => x.EnrollmentID == enrollmentID).Select(x => x.RiskAssessmentID)
                           .FirstOrDefault();
            }
        }

        /// <summary>
        /// returns riskassessment for person
        /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static RiskAssessment GetRiskAssessmentByPersonID(int personid)
        {
            using (PODContext context = new PODContext())
            {
                return context.RiskAssessments.Include(x => x.Enrollments).Include(x => x.Person).Where(p => p.PersonID == personid).OrderByDescending(r => r.DateEntered).FirstOrDefault();
            }
        }
        /// <summary>
        /// returns riskassessment for enrollment
        /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static RiskAssessment GetRiskAssessmentByID(int riskID)
        {
            using (PODContext context = new PODContext())
            {
                return context.RiskAssessments.Include(x => x.Enrollments).Include(x => x.Person).FirstOrDefault(p => p.RiskAssessmentID == riskID);
            }
        }

        /// <summary>
        /// returns riskassessment for enrollment
        /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static int AddUpdateRiskAssessment(RiskAssessment currentAssessment, string username)
        {
            bool isAdd = false;
            int raID = 0;

            using (PODContext context = new PODContext())
            {
                try
                {
                    RiskAssessment originalRA = context.RiskAssessments.FirstOrDefault(r => r.RiskAssessmentID == currentAssessment.RiskAssessmentID);
                    if (originalRA == null)
                    {
                        originalRA = new RiskAssessment();
                        originalRA.PersonID = currentAssessment.PersonID;
                        originalRA.rowguid = Guid.NewGuid();
                        originalRA.DateTimeStamp = DateTime.Now;
                        originalRA.DateCreated = DateTime.Now;
                        originalRA.ModifiedByPersonID = username;
                        originalRA.DateModified = DateTime.Now;
                        originalRA.DateEntered = DateTime.Now;
                        originalRA.ProgramID = currentAssessment.ProgramID;
                        isAdd = true;
                    }
                    else
                    {

                        originalRA.ModifiedByPersonID = username;
                        originalRA.DateModified = DateTime.Now;
                    }
                    originalRA.StatusTypeID = currentAssessment.StatusTypeID;
                    originalRA.CreatedByPersonID = currentAssessment.CreatedByPersonID;
                    originalRA.GjDate = currentAssessment.GjDate;
                    originalRA.GjEligible = currentAssessment.GjEligible;
                    originalRA.GjObtained = currentAssessment.GjObtained;
                    originalRA.RelAgency = currentAssessment.RelAgency;
                    originalRA.RelDate = currentAssessment.RelDate;
                    originalRA.RelReasonForLeaving = currentAssessment.RelReasonForLeaving;
                    originalRA.SSNumberDays = currentAssessment.SSNumberDays;
                    originalRA.SSPossibleDays = currentAssessment.SSPossibleDays;
                    originalRA.AcFailingMoreThanOnce = currentAssessment.AcFailingMoreThanOnce;
                    originalRA.AcFailingOnce = currentAssessment.AcFailingOnce;
                    originalRA.AcFailingSixMos = currentAssessment.AcFailingSixMos;
                    originalRA.AcLearningDisabilities = currentAssessment.AcLearningDisabilities;
                    originalRA.AttNotEnrolled = currentAssessment.AttNotEnrolled;
                    originalRA.AttSkipClass = currentAssessment.AttSkipClass;
                    originalRA.AttSkipSchool = currentAssessment.AttSkipSchool;
                    originalRA.AttTruant = currentAssessment.AttTruant;
                    originalRA.BehExpelled = currentAssessment.BehExpelled;
                    originalRA.BehExpelledPrev = currentAssessment.BehExpelledPrev;
                    originalRA.BehSuspended = currentAssessment.BehSuspended;
                    originalRA.BehSuspendedPrev = currentAssessment.BehSuspendedPrev;
                    originalRA.DateApplied = currentAssessment.DateApplied;
                    originalRA.FamilyStatus = currentAssessment.FamilyStatus;
                    originalRA.GangAssociated = currentAssessment.GangAssociated;
                    originalRA.GangAssocRecord = currentAssessment.GangAssocRecord;
                    originalRA.GangLaw = currentAssessment.GangLaw;
                    originalRA.GangMember = currentAssessment.GangMember;
                    originalRA.GangRecord = currentAssessment.GangRecord;
                    originalRA.GangReported = currentAssessment.GangReported;
                    originalRA.HistChildAbuse = currentAssessment.HistChildAbuse;
                    originalRA.HistDCF = currentAssessment.HistDCF;
                    originalRA.HistNeglect = currentAssessment.HistNeglect;
                    originalRA.InfCriminalRecord = currentAssessment.InfCriminalRecord;
                    originalRA.InfPrisonTime = currentAssessment.InfPrisonTime;
                    originalRA.InfProbation = currentAssessment.InfProbation;
                    originalRA.LocationID = currentAssessment.LocationID;
                    originalRA.SiteLocationID = currentAssessment.SiteLocationID;
                    originalRA.ParControl = currentAssessment.ParControl;
                    originalRA.ParentStatus = currentAssessment.ParentStatus;
                    originalRA.ParFreeTimeWhere = currentAssessment.ParFreeTimeWhere;
                    originalRA.ParFreeTimeWithWhom = currentAssessment.ParFreeTimeWithWhom;
                    originalRA.ParProbinSchool = currentAssessment.ParProbinSchool;
                    originalRA.ParUnclear = currentAssessment.ParUnclear;
                    originalRA.ReferredBy = currentAssessment.ReferredBy;
                    originalRA.RefByOther = currentAssessment.RefByOther;
                    originalRA.RunCurrent = currentAssessment.RunCurrent;
                    originalRA.RunOnce = currentAssessment.RunOnce;
                    originalRA.RunThree = currentAssessment.RunThree;
                    originalRA.SACharged = currentAssessment.SACharged;
                    originalRA.SADrugs = currentAssessment.SADrugs;
                    originalRA.SATobacco = currentAssessment.SATobacco;
                    originalRA.SiteMgrInitials = currentAssessment.SiteMgrInitials;
                    originalRA.StealCharged = currentAssessment.StealCharged;
                    originalRA.StealFamily = currentAssessment.StealFamily;

                    if (isAdd)
                    {
                        context.RiskAssessments.AddObject(originalRA);
                    }
                    context.SaveChanges();
                    raID = originalRA.RiskAssessmentID;

                }
                catch (Exception ex)
                {
                    ex.Log();
                }
            }
            return raID;
        }

        /// <summary>
        /// delete identified riskassessment
        /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static string DeleteRiskAssessment(int riskID)
        {
            using (PODContext context = new PODContext())
            {
                try
                {
                    context.DeleteRiskAssessment(riskID);
                    return string.Empty;
                }
                catch (Exception ex)
                {
                    ex.Log();
                    return ex.Message.ToString();
                }
            }
        }
    }
}
