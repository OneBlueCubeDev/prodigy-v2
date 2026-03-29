CREATE TABLE [dbo].[RiskAssessments] (
    [RiskAssessmentID]       INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]                UNIQUEIDENTIFIER CONSTRAINT [DF_RiskAssessments_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp]          SMALLDATETIME    CONSTRAINT [DF_RiskAssessments_DateTimeStamp] DEFAULT (getdate()) NULL,
    [LastModifiedBy]         NVARCHAR (255)   CONSTRAINT [DF_RiskAssessments_LastModifiedBy] DEFAULT ('SQL Server Management Studio') NULL,
    [DateApplied]            SMALLDATETIME    NULL,
    [DateEntered]            SMALLDATETIME    NULL,
    [ParentStatus]           VARCHAR (255)    NULL,
    [FamilyStatus]           VARCHAR (255)    NULL,
    [ReferredBy]             VARCHAR (255)    NULL,
    [RefByOther]             VARCHAR (255)    NULL,
    [AttSkipClass]           BIT              CONSTRAINT [DF_RiskAssessments_Att_skipclass_1] DEFAULT ((0)) NOT NULL,
    [AttSkipSchool]          BIT              CONSTRAINT [DF_RiskAssessments_Att_skipschool_1] DEFAULT ((0)) NOT NULL,
    [AttTruant]              BIT              CONSTRAINT [DF_RiskAssessments_Att_truant_1] DEFAULT ((0)) NOT NULL,
    [AttNotEnrolled]         BIT              CONSTRAINT [DF_RiskAssessments_Att_notenrolled_1] DEFAULT ((0)) NOT NULL,
    [BehSuspended]           BIT              CONSTRAINT [DF_RiskAssessments_beh_suspended_1] DEFAULT ((0)) NOT NULL,
    [BehExpelled]            BIT              CONSTRAINT [DF_RiskAssessments_beh_expelled_1] DEFAULT ((0)) NOT NULL,
    [BehSuspendedPrev]       BIT              CONSTRAINT [DF_RiskAssessments_beh_suspendedprev_1] DEFAULT ((0)) NOT NULL,
    [BehExpelledPrev]        BIT              CONSTRAINT [DF_RiskAssessments_beh_expelledprev_1] DEFAULT ((0)) NOT NULL,
    [AcFailingSixMos]        BIT              CONSTRAINT [DF_RiskAssessments_Ac_failingsixmos_1] DEFAULT ((0)) NOT NULL,
    [AcFailingOnce]          BIT              CONSTRAINT [DF_RiskAssessments_Ac_failingonce_1] DEFAULT ((0)) NOT NULL,
    [AcFailingMoreThanOnce]  BIT              CONSTRAINT [DF_RiskAssessments_Ac_failingmorethanonce_1] DEFAULT ((0)) NOT NULL,
    [AcLearningDisabilities] BIT              CONSTRAINT [DF_RiskAssessments_Ac_learningdisabilities_1] DEFAULT ((0)) NOT NULL,
    [ParControl]             BIT              CONSTRAINT [DF_RiskAssessments_par_control_1] DEFAULT ((0)) NOT NULL,
    [ParUnclear]             BIT              CONSTRAINT [DF_RiskAssessments_par_unclear_1] DEFAULT ((0)) NOT NULL,
    [ParFreeTimeWhere]       BIT              CONSTRAINT [DF_RiskAssessments_par_freetimewhere_1] DEFAULT ((0)) NOT NULL,
    [ParFreeTimeWithWhom]    BIT              CONSTRAINT [DF_RiskAssessments_par_freetimewithwhom_1] DEFAULT ((0)) NOT NULL,
    [ParProbinSchool]        BIT              CONSTRAINT [DF_RiskAssessments_par_probinschool_1] DEFAULT ((0)) NOT NULL,
    [HistChildAbuse]         BIT              CONSTRAINT [DF_RiskAssessments_hist_childabuse_1] DEFAULT ((0)) NOT NULL,
    [HistNeglect]            BIT              CONSTRAINT [DF_RiskAssessments_hist_neglect_1] DEFAULT ((0)) NOT NULL,
    [HistDCF]                BIT              CONSTRAINT [DF_RiskAssessments_hist_DCF_1] DEFAULT ((0)) NOT NULL,
    [InfCriminalRecord]      BIT              CONSTRAINT [DF_RiskAssessments_inf_criminalrecord_1] DEFAULT ((0)) NOT NULL,
    [InfPrisonTime]          BIT              CONSTRAINT [DF_RiskAssessments_inf_prisontime_1] DEFAULT ((0)) NOT NULL,
    [InfProbation]           BIT              CONSTRAINT [DF_RiskAssessments_inf_probation_1] DEFAULT ((0)) NOT NULL,
    [SATobacco]              BIT              CONSTRAINT [DF_RiskAssessments_SA_tobacco_1] DEFAULT ((0)) NOT NULL,
    [SADrugs]                BIT              CONSTRAINT [DF_RiskAssessments_SA_drugs_1] DEFAULT ((0)) NOT NULL,
    [SACharged]              BIT              CONSTRAINT [DF_RiskAssessments_SA_charged_1] DEFAULT ((0)) NOT NULL,
    [StealFamily]            BIT              CONSTRAINT [DF_RiskAssessments_steal_family_1] DEFAULT ((0)) NOT NULL,
    [StealCharged]           BIT              CONSTRAINT [DF_RiskAssessments_steal_charged_1] DEFAULT ((0)) NOT NULL,
    [RunOnce]                BIT              CONSTRAINT [DF_RiskAssessments_run_once_1] DEFAULT ((0)) NOT NULL,
    [RunThree]               BIT              CONSTRAINT [DF_RiskAssessments_run_three_1] DEFAULT ((0)) NOT NULL,
    [RunCurrent]             BIT              CONSTRAINT [DF_RiskAssessments_run_current_1] DEFAULT ((0)) NOT NULL,
    [GangMember]             BIT              CONSTRAINT [DF_RiskAssessments_gang_member_1] DEFAULT ((0)) NOT NULL,
    [GangReported]           BIT              CONSTRAINT [DF_RiskAssessments_gang_reported_1] DEFAULT ((0)) NOT NULL,
    [GangLaw]                BIT              CONSTRAINT [DF_RiskAssessments_gang_law_1] DEFAULT ((0)) NOT NULL,
    [GangAssociated]         BIT              CONSTRAINT [DF_RiskAssessments_gang_associated_1] DEFAULT ((0)) NOT NULL,
    [GangAssocRecord]        BIT              CONSTRAINT [DF_RiskAssessments_gang_assocrecord_1] DEFAULT ((0)) NOT NULL,
    [GangRecord]             BIT              CONSTRAINT [DF_RiskAssessments_gang_record_1] DEFAULT ((0)) NOT NULL,
    [RelReasonForLeaving]    VARCHAR (255)    NULL,
    [RelAgency]              VARCHAR (255)    NULL,
    [RelDate]                SMALLDATETIME    NULL,
    [SSNumberDays]           INT              NULL,
    [SSPossibleDays]         INT              NULL,
    [GjEligible]             BIT              CONSTRAINT [DF_RiskAssessments_gj_eligible_1] DEFAULT ((0)) NOT NULL,
    [GjEligibleNo]           BIT              CONSTRAINT [DF_RiskAssessments_gj_eligible_no_1] DEFAULT ((0)) NOT NULL,
    [GjObtained]             BIT              CONSTRAINT [DF_RiskAssessments_gj_obtained_1] DEFAULT ((0)) NOT NULL,
    [GjObtainedNo]           BIT              CONSTRAINT [DF_RiskAssessments_gj_obtained_no_1] DEFAULT ((0)) NOT NULL,
    [GjDate]                 SMALLDATETIME    NULL,
    [SiteLocationID]         INT              NULL,
	[LocationID]             INT              NULL,
    [PersonID]               INT              NOT NULL,
    [ProgramID]              INT              NOT NULL,
    [StatusTypeID]           INT              NULL,
    [SiteMgrInitials]        BIT              NULL,
    [DateCreated]            SMALLDATETIME    NULL,
    [CreatedByPersonID]      NVARCHAR (255)   NULL,
    [DateModified]           SMALLDATETIME    NULL,
    [ModifiedByPersonID]     NVARCHAR (255)   NULL,
    [GrantYear]              AS               (case when [DateApplied]>='5/1/2013' AND [DateApplied]<='7/1/2013' then '7/1/2013' else [DateApplied] end),
    CONSTRAINT [PK_RiskAssessments] PRIMARY KEY CLUSTERED ([RiskAssessmentID] ASC),
    CONSTRAINT [FK_RiskAssessments_Persons] FOREIGN KEY ([PersonID]) REFERENCES [dbo].[Persons] ([PersonID]),
    CONSTRAINT [FK_RiskAssessments_Programs] FOREIGN KEY ([ProgramID]) REFERENCES [dbo].[Programs] ([ProgramID]),
    CONSTRAINT [FK_RiskAssessments_Sites] FOREIGN KEY ([SiteLocationID]) REFERENCES [dbo].[Sites] ([LocationID]),
	CONSTRAINT [FK_RiskAssessments_Locations] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Locations] ([LocationID]),
    CONSTRAINT [FK_RiskAssessments_StatusTypes] FOREIGN KEY ([StatusTypeID]) REFERENCES [dbo].[StatusTypes] ([StatusTypeID])
);




GO
CREATE TRIGGER [dbo].[tr_RiskAssessments]
   ON [dbo].[RiskAssessments]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	DECLARE @Type nvarchar(10)
	IF EXISTS (SELECT * FROM Inserted)
		IF EXISTS (SELECT * FROM Deleted)
			SELECT @Type = 'Update'
		ELSE
			SELECT @Type = 'Insert'
		ELSE
			SELECT @Type = 'Delete' 

	IF @Type='Delete'
		INSERT INTO [POD].[dbo].[RiskAssessments_Audit]
			   ([RiskAssessmentID]
			   ,[rowguid]
			   ,[DateTimeStamp]
			   ,[LastModifiedBy]
			   ,[DateApplied]
			   ,[DateEntered]
			   ,[ParentStatus]
			   ,[FamilyStatus]
			   ,[ReferredBy]
			   ,[RefByOther]
			   ,[AttSkipClass]
				,[AttSkipSchool]
			   ,[AttTruant]
			   ,[AttNotEnrolled]
			   ,[BehSuspended]
			   ,[BehExpelled]
			   ,[BehSuspendedPrev]
			   ,[BehExpelledPrev]
			   ,[AcFailingSixMos]
			   ,[AcFailingOnce]
			   ,[AcFailingMoreThanOnce]
			   ,[AcLearningDisabilities]
			   ,[ParControl]
			   ,[ParUnclear]
			   ,[ParFreeTimeWhere]
			   ,[ParFreeTimeWithWhom]
			   ,[ParProbinSchool]
			    ,[HistChildAbuse]
			   ,[HistNeglect]
			   ,[HistDCF]
			   ,[InfCriminalRecord]
			   ,[InfPrisonTime]
			   ,[InfProbation]
			   ,[SATobacco]
			   ,[SADrugs]
			   ,[SACharged]
			   ,[StealFamily]
			  ,[StealCharged]
			   ,[RunOnce]
			   ,[RunThree]
			   ,[RunCurrent]
			  ,[GangMember]
			  ,[GangReported]
			   ,[GangLaw]
			   ,[GangAssociated]
			   ,[GangAssocRecord]
			   ,[GangRecord]
			   ,[RelReasonForLeaving]
			   ,[RelAgency]
			   ,[RelDate]
			   ,[SSNumberDays]
			   ,[SSPossibleDays]
			   ,[GjEligible]
			   ,[GjEligibleNo]
			   ,[GjObtained]
			   ,[GjObtainedNo]
			   ,[GjDate]
			   ,[LocationID]
			   ,[PersonID]
			   ,[ProgramID]
			   ,[StatusTypeID]
			   ,[SiteMgrInitials]
			   ,[DateCreated]
			   ,[CreatedByPersonID]
			   ,[DateModified]
			   ,[ModifiedByPersonID]
			   ,[GrantYear]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   RiskAssessmentID, 
			   rowguid, 
			   DateTimeStamp, 
			   LastModifiedBy, 
			   DateApplied, 
			   DateEntered, 
			   ParentStatus, 
			   FamilyStatus, 
			   ReferredBy, 
			   RefByOther, 
			   AttSkipClass,
			   AttSkipSchool, 
			   AttTruant, 
			   AttNotEnrolled, 
			   BehSuspended, 
			   BehExpelled, 
			   BehSuspendedPrev, 
			   BehExpelledPrev, 
			   AcFailingSixMos, 
			   AcFailingOnce, 
			   AcFailingMoreThanOnce, 
			   AcLearningDisabilities, 
			   ParControl,
			   ParUnclear, 
			   ParFreeTimeWhere, 
			   ParFreeTimeWithWhom, 
			   ParProbinSchool, 
			   HistChildAbuse, 
			   HistNeglect, 
			   HistDCF, 
			   InfCriminalRecord, 
			   InfPrisonTime, 
			   InfProbation, 
			   SATobacco, 
			   SADrugs, 
			   SACharged, 
			   StealFamily, 
			   StealCharged, 
			   RunOnce, 
			   RunThree, 
			   RunCurrent, 
			   GangMember,
			   GangReported, 
			   GangLaw,
			   GangAssociated, 
			   GangAssocRecord, 
			   GangRecord,
			   RelReasonForLeaving, 
			   RelAgency, 
			   RelDate, 
			   SSNumberDays,
			   SSPossibleDays, 
			   GjEligible, 
			   GjEligibleNo, 
			   GjObtained,
			   GjObtainedNo,
			   GjDate, 
			   SiteLocationID,
			   PersonID,
			   ProgramID,
			   StatusTypeID,
			   SiteMgrInitials,
			   DateCreated, 
			   CreatedByPersonID,
			   DateModified,
			   ModifiedByPersonID, 
			   [GrantYear],
			   @Type, 
			   getdate(), 
			   LastModifiedBy, 
			   SUSER_SNAME()
		FROM Deleted
	ELSE
		INSERT INTO [POD].[dbo].[RiskAssessments_Audit]
			   ([RiskAssessmentID]
			   ,[rowguid]
			   ,[DateTimeStamp]
			   ,[LastModifiedBy]
			   ,[DateApplied]
			   ,[DateEntered]
			   ,[ParentStatus]
			   ,[FamilyStatus]
			   ,[ReferredBy]
			   ,[RefByOther]
			   ,[AttSkipClass]
				,[AttSkipSchool]
			   ,[AttTruant]
			   ,[AttNotEnrolled]
			   ,[BehSuspended]
			   ,[BehExpelled]
			   ,[BehSuspendedPrev]
			   ,[BehExpelledPrev]
			   ,[AcFailingSixMos]
			   ,[AcFailingOnce]
			   ,[AcFailingMoreThanOnce]
			   ,[AcLearningDisabilities]
			   ,[ParControl]
			   ,[ParUnclear]
			   ,[ParFreeTimeWhere]
			   ,[ParFreeTimeWithWhom]
			   ,[ParProbinSchool]
			    ,[HistChildAbuse]
			   ,[HistNeglect]
			   ,[HistDCF]
			   ,[InfCriminalRecord]
			   ,[InfPrisonTime]
			   ,[InfProbation]
			   ,[SATobacco]
			   ,[SADrugs]
			   ,[SACharged]
			   ,[StealFamily]
			  ,[StealCharged]
			   ,[RunOnce]
			   ,[RunThree]
			   ,[RunCurrent]
			  ,[GangMember]
			  ,[GangReported]
			   ,[GangLaw]
			   ,[GangAssociated]
			   ,[GangAssocRecord]
			   ,[GangRecord]
			   ,[RelReasonForLeaving]
			   ,[RelAgency]
			   ,[RelDate]
			   ,[SSNumberDays]
			   ,[SSPossibleDays]
			   ,[GjEligible]
			   ,[GjEligibleNo]
			   ,[GjObtained]
			   ,[GjObtainedNo]
			   ,[GjDate]
			   ,[LocationID]
			   ,[PersonID]
			   ,[ProgramID]
			   ,[StatusTypeID]
			   ,[SiteMgrInitials]
			   ,[DateCreated]
			   ,[CreatedByPersonID]
			   ,[DateModified]
			   ,[ModifiedByPersonID]
			   ,[GrantYear]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			  RiskAssessmentID, 
			   rowguid, 
			   DateTimeStamp, 
			   LastModifiedBy, 
			   DateApplied, 
			   DateEntered, 
			   ParentStatus, 
			   FamilyStatus, 
			   ReferredBy, 
			   RefByOther, 
			   AttSkipClass,
			   AttSkipSchool, 
			   AttTruant, 
			   AttNotEnrolled, 
			   BehSuspended, 
			   BehExpelled, 
			   BehSuspendedPrev, 
			   BehExpelledPrev, 
			   AcFailingSixMos, 
			   AcFailingOnce, 
			   AcFailingMoreThanOnce, 
			   AcLearningDisabilities, 
			   ParControl,
			   ParUnclear, 
			   ParFreeTimeWhere, 
			   ParFreeTimeWithWhom, 
			   ParProbinSchool, 
			   HistChildAbuse, 
			   HistNeglect, 
			   HistDCF, 
			   InfCriminalRecord, 
			   InfPrisonTime, 
			   InfProbation, 
			   SATobacco, 
			   SADrugs, 
			   SACharged, 
			   StealFamily, 
			   StealCharged, 
			   RunOnce, 
			   RunThree, 
			   RunCurrent, 
			   GangMember,
			   GangReported, 
			   GangLaw,
			   GangAssociated, 
			   GangAssocRecord, 
			   GangRecord,
			   RelReasonForLeaving, 
			   RelAgency, 
			   RelDate, 
			   SSNumberDays,
			   SSPossibleDays, 
			   GjEligible, 
			   GjEligibleNo, 
			   GjObtained,
			   GjObtainedNo,
			   GjDate, 
			   SiteLocationID,
			   PersonID,
			   ProgramID,
			   StatusTypeID,
			   SiteMgrInitials,
			   DateCreated, 
			   CreatedByPersonID,
			   DateModified,
			   ModifiedByPersonID, 
			   [GrantYear],
			   @Type, 
			   getdate(), 
			   LastModifiedBy, 
			   SUSER_SNAME()
		FROM Inserted

END