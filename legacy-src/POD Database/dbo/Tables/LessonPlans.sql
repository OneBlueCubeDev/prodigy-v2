CREATE TABLE [dbo].[LessonPlans] (
    [LessonPlanID]       INT              IDENTITY (1, 1) NOT NULL,
    [Name]               NVARCHAR (250)   NOT NULL,
    [rowguid]            UNIQUEIDENTIFIER CONSTRAINT [DF_LessonPlans_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp]      SMALLDATETIME    CONSTRAINT [DF_LessonPlans_DateTimeStamp] DEFAULT (getdate()) NULL,
    [LastModifiedBy]     NVARCHAR (255)   CONSTRAINT [DF_LessonPlans_LastModifiedBy] DEFAULT ('SQL Server Management Studio') NULL,
    [LessonPlanTypeID]   INT              NOT NULL,
    [DisciplineTypeID]   INT              NOT NULL,
    [SiteLocationID]     INT              NOT NULL,
    [SpecificLocationID] INT              NOT NULL,
    [InstructorPersonID] INT              NOT NULL,
    [AssistantPersonID]  INT              NULL,
    [StatusTypeID]       INT              NOT NULL,
    [AgeGroupID]         INT              NOT NULL,
    [WeekNumber]         INT              NULL,
    [Topic]              NVARCHAR (MAX)   NULL,
    [Objective]          NVARCHAR (MAX)   NULL,
    [Introduction]       NVARCHAR (MAX)   NULL,
    [Discussion]         NVARCHAR (MAX)   NULL,
    [ActivityProcedures] NVARCHAR (MAX)   NULL,
    [MaterialsNeeded]    NVARCHAR (MAX)   NULL,
    [WrapUpActivity]     NVARCHAR (MAX)   NULL,
    [LessonPlanSetID]    INT              NOT NULL,
    [ProgramID]          INT              NOT NULL,
    [CommunityTheme]     NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_LessonPlans] PRIMARY KEY CLUSTERED ([LessonPlanID] ASC),
    CONSTRAINT [FK_LessonPlans_AgeGroups] FOREIGN KEY ([AgeGroupID]) REFERENCES [dbo].[AgeGroups] ([AgeGroupID]) ON UPDATE CASCADE,
    CONSTRAINT [FK_LessonPlans_DisciplineTypes] FOREIGN KEY ([DisciplineTypeID]) REFERENCES [dbo].[DisciplineTypes] ([DisciplineTypeID]),
    CONSTRAINT [FK_LessonPlans_LessonPlans_Asssistant] FOREIGN KEY ([AssistantPersonID]) REFERENCES [dbo].[StaffMembers] ([PersonID]),
    CONSTRAINT [FK_LessonPlans_LessonPlanSets] FOREIGN KEY ([LessonPlanSetID]) REFERENCES [dbo].[LessonPlanSets] ([LessonPlanSetID]),
    CONSTRAINT [FK_LessonPlans_LessonPlanTypes] FOREIGN KEY ([LessonPlanTypeID]) REFERENCES [dbo].[LessonPlanTypes] ([LessonPlanTypeID]),
    CONSTRAINT [FK_LessonPlans_Locations] FOREIGN KEY ([SpecificLocationID]) REFERENCES [dbo].[Locations] ([LocationID]),
    CONSTRAINT [FK_LessonPlans_Programs] FOREIGN KEY ([ProgramID]) REFERENCES [dbo].[Programs] ([ProgramID]),
    CONSTRAINT [FK_LessonPlans_Sites] FOREIGN KEY ([SiteLocationID]) REFERENCES [dbo].[Sites] ([LocationID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_LessonPlans_StaffMembers_Instructor] FOREIGN KEY ([InstructorPersonID]) REFERENCES [dbo].[StaffMembers] ([PersonID]),
    CONSTRAINT [FK_LessonPlans_StatusTypes] FOREIGN KEY ([StatusTypeID]) REFERENCES [dbo].[StatusTypes] ([StatusTypeID]) ON UPDATE CASCADE
);


GO
CREATE TRIGGER [dbo].[tr_LessonPlans]
   ON [dbo].[LessonPlans]
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
		INSERT INTO [POD].[dbo].[LessonPlans_Audit]
			   ([LessonPlanID]
			   ,[Name]
			   ,[rowguid]
			   ,[DateTimeStamp]
			   ,[LastModifiedBy]
			   ,[LessonPlanTypeID]
			   ,[DisciplineTypeID]
			   ,[SiteLocationID]
			   ,[SpecificLocationID]
			   ,[InstructorPersonID]
			   ,[AssistantPersonID]
			   ,[StatusTypeID]
			   ,[AgeGroupID]
			   ,[WeekNumber]
			   ,[Topic]
			   ,[Objective]
			   ,[Introduction]
			   ,[Discussion]
			   ,[ActivityProcedures]
			   ,[MaterialsNeeded]
			   ,[WrapUpActivity]
			   ,[ProgramID]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   LessonPlanID,
			   Name,
			   rowguid,
			   DateTimeStamp, 
			   LastModifiedBy, 
			   LessonPlanTypeID, 
			   DisciplineTypeID,
			   SiteLocationID, 
			   SpecificLocationID, 
			   InstructorPersonID, 
			   AssistantPersonID, 
			   StatusTypeID, 
			   AgeGroupID, 
			   WeekNumber, 
			   Topic, 
			   Objective, 
			   Introduction, 
			   Discussion,
			   ActivityProcedures, 
			   MaterialsNeeded, 
			   WrapUpActivity, 
			   ProgramID, 
			   @Type, 
			   getdate(), 
			   LastModifiedBy, 
			   SUSER_SNAME()
		FROM Deleted
	ELSE
		INSERT INTO [POD].[dbo].[LessonPlans_Audit]
			   ([LessonPlanID]
			   ,[Name]
			   ,[rowguid]
			   ,[DateTimeStamp]
			   ,[LastModifiedBy]
			   ,[LessonPlanTypeID]
			   ,[DisciplineTypeID]
			   ,[SiteLocationID]
			   ,[SpecificLocationID]
			   ,[InstructorPersonID]
			   ,[AssistantPersonID]
			   ,[StatusTypeID]
			   ,[AgeGroupID]
			   ,[WeekNumber]
			   ,[Topic]
			   ,[Objective]
			   ,[Introduction]
			   ,[Discussion]
			   ,[ActivityProcedures]
			   ,[MaterialsNeeded]
			   ,[WrapUpActivity]
			   ,[ProgramID]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   LessonPlanID,
			   Name,
			   rowguid,
			   DateTimeStamp, 
			   LastModifiedBy, 
			   LessonPlanTypeID, 
			   DisciplineTypeID,
			   SiteLocationID, 
			   SpecificLocationID, 
			   InstructorPersonID, 
			   AssistantPersonID, 
			   StatusTypeID, 
			   AgeGroupID, 
			   WeekNumber, 
			   Topic, 
			   Objective, 
			   Introduction, 
			   Discussion,
			   ActivityProcedures, 
			   MaterialsNeeded, 
			   WrapUpActivity,  
			   ProgramID,
			   @Type, 
			   getdate(), 
			   LastModifiedBy, 
			   SUSER_SNAME()
		FROM Inserted

END