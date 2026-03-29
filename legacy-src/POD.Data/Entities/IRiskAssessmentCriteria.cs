using System;

namespace POD.Data.Entities
{
    public interface IRiskAssessmentCriteria
    {
        Boolean AttSkipClass { get; set; }

        Boolean AttSkipSchool { get; set; }

        Boolean AttTruant { get; set; }

        Boolean AttNotEnrolled { get; set; }

        Boolean BehSuspended { get; set; }

        Boolean BehExpelled { get; set; }

        Boolean BehSuspendedPrev { get; set; }

        Boolean BehExpelledPrev { get; set; }

        Boolean AcFailingSixMos { get; set; }

        Boolean AcFailingOnce { get; set; }

        Boolean AcFailingMoreThanOnce { get; set; }

        Boolean AcLearningDisabilities { get; set; }

        Boolean ParControl { get; set; }

        Boolean ParUnclear { get; set; }

        Boolean ParFreeTimeWhere { get; set; }

        Boolean ParFreeTimeWithWhom { get; set; }

        Boolean ParProbinSchool { get; set; }

        Boolean HistChildAbuse { get; set; }

        Boolean HistNeglect { get; set; }

        Boolean HistDCF { get; set; }

        Boolean InfCriminalRecord { get; set; }

        Boolean InfPrisonTime { get; set; }

        Boolean InfProbation { get; set; }

        Boolean SATobacco { get; set; }

        Boolean SADrugs { get; set; }

        Boolean SACharged { get; set; }

        Boolean StealFamily { get; set; }

        Boolean StealCharged { get; set; }

        Boolean RunOnce { get; set; }

        Boolean RunThree { get; set; }

        Boolean RunCurrent { get; set; }

        Boolean GangMember { get; set; }

        Boolean GangReported { get; set; }

        Boolean GangLaw { get; set; }

        Boolean GangAssociated { get; set; }

        Boolean GangAssocRecord { get; set; }

        Boolean GangRecord { get; set; }
    }
}