using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using POD.Data.Entities;

namespace POD.Logic
{
    public static class RiskAssessmentLogic
    {
        /// <summary>
        /// returns riskassessment for enrollment
        /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static Enrollment GetEnrollmentByRAID(int raID)
        {
            return POD.Data.EnrollmentData.GetEnrollmentByRiskAssessmentID(raID);
        }

        /// <summary>
        /// returns the passed in id since it already is risk assessment
        /// or determines risk assessment based on enrollment info
        /// </summary>
        /// <param name="id"></param>
        /// <param name="type"></param>
        /// <returns></returns>
        public static int GetEnrollmentIDByEnrollmentIDOrRiskAssessmentID(int id, string type)
        {
            int raID = 0;
            if (type == "Risk Assessment")
            {
                raID = GetEnrollmentByRAID(id).EnrollmentID;
            }
            else
            {
                raID = id;
            }

            return raID;
        }

        /// <summary>
        /// sets all release information on the enrollment record in list
        /// status is automatically set to released
        /// </summary>
        /// <param name="key">identifier</param>
        /// <returns></returns>
        public static string ReleaseEnrollmentList(List<int> enrollListID, DateTime releaseDate, string releaseAgency, string reason)
        {
            int statusID = POD.Logic.ManageTypesLogic.GetStatusTypeIDByName("released");

            return POD.Data.EnrollmentData.ReleaseEnrollmentList(enrollListID, statusID, releaseDate, releaseAgency, reason, Security.GetCurrentUserProfile().UserName);
        }

    }
}
