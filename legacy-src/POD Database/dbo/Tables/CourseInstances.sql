CREATE TABLE [dbo].[CourseInstances] (
    [CourseInstanceID]   INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]            UNIQUEIDENTIFIER CONSTRAINT [DF_CourseInstances_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp]      SMALLDATETIME    CONSTRAINT [DF_CourseInstances_DateTimeStamp] DEFAULT (getdate()) NULL,
    [LastModifiedBy]     NVARCHAR (255)   CONSTRAINT [DF_CourseInstances_LastModifiedBy] DEFAULT ('SQL Server Management Studio') NULL,
    [CourseID]           INT              NOT NULL,
    [ProgramID]          INT              NOT NULL,
    [SiteLocationID]     INT              NOT NULL,
    [StartDate]          DATETIME         NULL,
    [EndDate]            DATETIME         NULL,
    [InstructorPersonID] INT              NULL,
    [AssistantPersonID]  INT              NULL,
    [Notes]              NVARCHAR (MAX)   NULL,
    [LessonPlanSetID]    INT              NULL,
    CONSTRAINT [PK_CourseInstances] PRIMARY KEY CLUSTERED ([CourseInstanceID] ASC),
    CONSTRAINT [FK_CourseInstances_Courses] FOREIGN KEY ([CourseID]) REFERENCES [dbo].[Courses] ([CourseID]),
    CONSTRAINT [FK_CourseInstances_LessonPlanSets] FOREIGN KEY ([LessonPlanSetID]) REFERENCES [dbo].[LessonPlanSets] ([LessonPlanSetID]),
    CONSTRAINT [FK_CourseInstances_Programs] FOREIGN KEY ([ProgramID]) REFERENCES [dbo].[Programs] ([ProgramID]),
    CONSTRAINT [FK_CourseInstances_Sites] FOREIGN KEY ([SiteLocationID]) REFERENCES [dbo].[Sites] ([LocationID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_CourseInstances_StaffMembers_Assistant] FOREIGN KEY ([AssistantPersonID]) REFERENCES [dbo].[StaffMembers] ([PersonID]),
    CONSTRAINT [FK_CourseInstances_StaffMembers_Instructor] FOREIGN KEY ([InstructorPersonID]) REFERENCES [dbo].[StaffMembers] ([PersonID])
);


GO
CREATE NONCLUSTERED INDEX [IX_CourseInstances]
    ON [dbo].[CourseInstances]([CourseID] ASC);


GO
CREATE TRIGGER [dbo].[tr_CourseInstances]
   ON  [dbo].[CourseInstances] 
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
		INSERT INTO [POD].[dbo].[CourseInstances_Audit]
			   ([CourseInstanceID]
			   ,[rowguid]
			   ,[DateTimeStamp]
			   ,[LastModifiedBy]
			   ,[CourseID]
			   ,[ProgramID]
			   ,[LocationID]
			   ,[StartDate]
			   ,[EndDate]
			   ,[InstructorPersonID]
			   ,[AssistantPersonID]
			   ,[Notes]
			   ,[LessonPlanSetID]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   CourseInstanceID, 
			   rowguid, 
			   DateTimeStamp, 
			   LastModifiedBy, 
			   CourseID, 
			   ProgramID, 
			   SiteLocationID, 
			   StartDate, 
			   EndDate, 
			   InstructorPersonID,
			   AssistantPersonID, 
			   Notes,
			   [LessonPlanSetID], 
			   @Type, 
			   getdate(), 
			   LastModifiedBy, 
			   SUSER_SNAME()
		FROM Deleted
	ELSE
		INSERT INTO [POD].[dbo].[CourseInstances_Audit]
			   ([CourseInstanceID]
			   ,[rowguid]
			   ,[DateTimeStamp]
			   ,[LastModifiedBy]
			   ,[CourseID]
			   ,[ProgramID]
			   ,[LocationID]
			   ,[StartDate]
			   ,[EndDate]
			   ,[InstructorPersonID]
			   ,[AssistantPersonID]
			   ,[Notes]
			   ,[LessonPlanSetID]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   CourseInstanceID, 
			   rowguid, 
			   DateTimeStamp, 
			   LastModifiedBy, 
			   CourseID, 
			   ProgramID, 
			   SiteLocationID, 
			   StartDate, 
			   EndDate, 
			   InstructorPersonID,
			   AssistantPersonID, 
			   Notes,
			   [LessonPlanSetID],
			   @Type, 
			   getdate(), 
			   LastModifiedBy, 
			   SUSER_SNAME()
		FROM Inserted
END