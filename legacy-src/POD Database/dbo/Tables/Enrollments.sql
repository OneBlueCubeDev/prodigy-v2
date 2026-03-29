CREATE TABLE [dbo].[Enrollments] (
    [EnrollmentID]          INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]               UNIQUEIDENTIFIER CONSTRAINT [DF_Enrollments_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp]         SMALLDATETIME    CONSTRAINT [DF_Enrollments_DateTimeStamp] DEFAULT (getdate()) NULL,
    [LastModifiedBy]        NVARCHAR (255)   CONSTRAINT [DF_Enrollments_LastModifiedBy] DEFAULT ('SQL Server Management Studio') NULL,
    [PersonID]              INT              NOT NULL,
    [RiskAssessmentID]      INT              NULL,
    [EnrollmentTypeID]      INT              NOT NULL,
    [ReferralTypeID]        INT              NULL,
    [ReferringAgencyTypeID] INT              NULL,
    [StatusTypeID]          INT              NOT NULL,
    [DateApplied]           SMALLDATETIME    NULL,
    [Admitted]              BIT              NULL,
    [DateAdmitted]          SMALLDATETIME    NULL,
    [DateGraduated]         SMALLDATETIME    NULL,
    [FollowUpNotes]         NVARCHAR (MAX)   NULL,
    [SiteLocationID]        INT              NULL,
	[LocationID]            INT              NULL,
    [ProgramID]             INT              NOT NULL,
    [RelReasonForLeaving]   NVARCHAR (255)   NULL,
    [RelAgency]             NVARCHAR (255)   NULL,
    [RelDate]               SMALLDATETIME    NULL,
    [RecommendedBy]         NVARCHAR (250)   NULL,
    [GrantYear]             AS               (case when [DateApplied]>='5/1/2013' AND [DateApplied]<='7/1/2013' then '7/1/2013' else [DateApplied] end),
    CONSTRAINT [PK_Enrollments] PRIMARY KEY CLUSTERED ([EnrollmentID] ASC),
	CONSTRAINT [FK_Enrollments_Locations] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Locations] ([LocationID]),
	CONSTRAINT [FK_Enrollments_Sites] FOREIGN KEY ([SiteLocationID]) REFERENCES [dbo].[Sites] ([LocationID]),
	CONSTRAINT [FK_Enrollments_EnrollmentTypes] FOREIGN KEY ([EnrollmentTypeID]) REFERENCES [dbo].[EnrollmentTypes] ([EnrollmentTypeID]),
	CONSTRAINT [FK_Enrollments_Persons] FOREIGN KEY ([PersonID]) REFERENCES [dbo].[Persons] ([PersonID]),
	CONSTRAINT [FK_Enrollments_Programs] FOREIGN KEY ([ProgramID]) REFERENCES [dbo].[Programs] ([ProgramID]),
	CONSTRAINT [FK_Enrollments_ReferralTypes] FOREIGN KEY ([ReferralTypeID]) REFERENCES [dbo].[ReferralTypes] ([ReferralTypeID]),
	CONSTRAINT [FK_Enrollments_ReferringAgencyTypes] FOREIGN KEY ([ReferralTypeID]) REFERENCES [dbo].[ReferringAgencyTypes] ([ReferringAgencyTypeID]),
	CONSTRAINT [FK_Enrollments_RiskAssessments] FOREIGN KEY ([RiskAssessmentID]) REFERENCES [dbo].[RiskAssessments] ([RiskAssessmentID])
);






GO
CREATE TRIGGER [dbo].[tr_Enrollments]
   ON  [dbo].[Enrollments]
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
		INSERT INTO [POD].[dbo].[Enrollments_Audit]
			   ([EnrollmentID]
			   ,[rowguid]
			   ,[DateTimeStamp]
			   ,[LastModifiedBy]
			   ,[PersonID]
			   ,[RiskAssessmentID]
			   ,[EnrollmentTypeID]
			   ,[ReferralTypeID]
			   ,[ReferringAgencyTypeID]
			   ,[StatusTypeID]
			    ,[ProgramID]
			   ,[DateApplied]
			   ,[Admitted]
			   ,[DateAdmitted]
			   ,[DateGraduated]
			   ,[FollowUpNotes]
			   ,[RelReasonForLeaving]
			   ,[RelAgency]
			   ,[RelDate]
			   ,[RecommendedBy]
			   ,[SiteLocationID]
			   ,[GrantYear]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   EnrollmentID, 
			   rowguid, 
			   DateTimeStamp, 
			   LastModifiedBy, 
			   PersonID, 
			   RiskAssessmentID, 
			   EnrollmentTypeID, 
			   ReferralTypeID, 
			   ReferringAgencyTypeID, 
			   StatusTypeID,
			   ProgramID, 
			   DateApplied, 
			   Admitted, 
			   DateAdmitted,
			   DateGraduated, 
			   FollowUpNotes,
			   [RelReasonForLeaving],
			   [RelAgency],
			   [RelDate],
			   [RecommendedBy],
			   [SiteLocationID],
			   [GrantYear],
			   @Type, 
			   getdate(), 
			   LastModifiedBy, 
			   SUSER_SNAME()
		FROM Deleted
	ELSE
		INSERT INTO [POD].[dbo].[Enrollments_Audit]
			   ([EnrollmentID]
			   ,[rowguid]
			   ,[DateTimeStamp]
			   ,[LastModifiedBy]
			   ,[PersonID]
			   ,[RiskAssessmentID]
			   ,[EnrollmentTypeID]
			   ,[ReferralTypeID]
			   ,[ReferringAgencyTypeID]
			   ,[StatusTypeID]
			   ,[ProgramID]
			   ,[DateApplied]
			   ,[Admitted]
			   ,[DateAdmitted]
			   ,[DateGraduated]
			   ,[FollowUpNotes]
			   ,[RelReasonForLeaving]
			   ,[RelAgency]
			   ,[RelDate]
			   ,[RecommendedBy]
			   ,[SiteLocationID]
			    ,[GrantYear]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   EnrollmentID, 
			   rowguid, 
			   DateTimeStamp, 
			   LastModifiedBy, 
			   PersonID, 
			   RiskAssessmentID, 
			   EnrollmentTypeID, 
			   ReferralTypeID, 
			   ReferringAgencyTypeID, 
			   StatusTypeID, 
			   ProgramID,
			   DateApplied, 
			   Admitted, 
			   DateAdmitted,
			   DateGraduated, 
			   FollowUpNotes,
			   [RelReasonForLeaving],
			   [RelAgency],
			   [RelDate],
			   [RecommendedBy],
			   [SiteLocationID],
			   [GrantYear],
			   @Type, 
			   getdate(), 
			   LastModifiedBy, 
			   SUSER_SNAME()
		FROM Inserted

END
GO
CREATE NONCLUSTERED INDEX [IX_Enrollments_PersonTypeAdmittedProgramGraduated]
    ON [dbo].[Enrollments]([PersonID] ASC, [EnrollmentTypeID] ASC, [Admitted] ASC, [ProgramID] ASC, [DateGraduated] ASC);

