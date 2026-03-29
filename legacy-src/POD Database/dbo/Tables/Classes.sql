CREATE TABLE [dbo].[Classes] (
    [ClassID]             INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]             UNIQUEIDENTIFIER CONSTRAINT [DF_Classes_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp]       SMALLDATETIME    CONSTRAINT [DF_Classes_DateTimeStamp] DEFAULT (getdate()) NULL,
    [LastModifiedBy]      NVARCHAR (255)   CONSTRAINT [DF_Classes_LastModifiedBy] DEFAULT ('SQL Server Management Studio') NULL,
    [ClassTypeID]         INT              NOT NULL,
    [CourseInstanceID]    INT              NOT NULL,
    [LessonPlanID]        INT              NULL,
    [SiteLocationID]      INT              NULL,
    [SpecificLocationID]  INT              NULL,
    [InstructorPersonID]  INT              NULL,
    [AssistantPersonID]   INT              NULL,
    [CurrentStatusTypeID] INT              NOT NULL,
    [DateStart]           SMALLDATETIME    NULL,
    [DateEnd]             SMALLDATETIME    NULL,
    [Name]                NVARCHAR (250)   NULL,
    CONSTRAINT [PK_Classes] PRIMARY KEY CLUSTERED ([ClassID] ASC),
    CONSTRAINT [FK_Classes_ClassTypes] FOREIGN KEY ([ClassTypeID]) REFERENCES [dbo].[ClassTypes] ([ClassTypeID]),
    CONSTRAINT [FK_Classes_CourseInstances] FOREIGN KEY ([CourseInstanceID]) REFERENCES [dbo].[CourseInstances] ([CourseInstanceID]),
    CONSTRAINT [FK_Classes_LessonPlans] FOREIGN KEY ([LessonPlanID]) REFERENCES [dbo].[LessonPlans] ([LessonPlanID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_Classes_Locations] FOREIGN KEY ([SpecificLocationID]) REFERENCES [dbo].[Locations] ([LocationID]),
    CONSTRAINT [FK_Classes_Sites] FOREIGN KEY ([SiteLocationID]) REFERENCES [dbo].[Sites] ([LocationID]),
    CONSTRAINT [FK_Classes_StaffMembers_Assistant] FOREIGN KEY ([AssistantPersonID]) REFERENCES [dbo].[StaffMembers] ([PersonID]),
    CONSTRAINT [FK_Classes_StaffMembers_Instructor] FOREIGN KEY ([InstructorPersonID]) REFERENCES [dbo].[StaffMembers] ([PersonID]),
    CONSTRAINT [FK_Classes_StatusTypes] FOREIGN KEY ([CurrentStatusTypeID]) REFERENCES [dbo].[StatusTypes] ([StatusTypeID])
);




GO
CREATE TRIGGER [dbo].[tr_Classes]
   ON  [dbo].[Classes]
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
		INSERT INTO [POD].[dbo].[Classes_Audit]
			   ([ClassID]
			   ,[rowguid]
			   ,[DateTimeStamp]
			   ,[LastModifiedBy]
			   ,[ClassTypeID]
			   ,[CourseInstanceID]
			   ,[LessonPlanID]
			   ,[SiteLocationID]
			   ,[SpecificLocationID]
			   ,[InstructorPersonID]
			   ,[AssistantPersonID]
			   ,[CurrentStatusTypeID]
			   ,[DateStart]
			   ,[DateEnd]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   ClassID,
			   rowguid, 
			   DateTimeStamp, 
			   LastModifiedBy, 
			   ClassTypeID, 
			   CourseInstanceID, 
			   LessonPlanID, 
			   SiteLocationID, 
			   SpecificLocationID, 
			   InstructorPersonID, 
			   AssistantPersonID, 
			   CurrentStatusTypeID, 
			   DateStart, 
			   DateEnd, 
			   @Type, 
			   getdate(), 
			   LastModifiedBy, 
			   SUSER_SNAME()
		FROM Deleted
	ELSE
		INSERT INTO [POD].[dbo].[Classes_Audit]
			   ([ClassID]
			   ,[rowguid]
			   ,[DateTimeStamp]
			   ,[LastModifiedBy]
			   ,[ClassTypeID]
			   ,[CourseInstanceID]
			   ,[LessonPlanID]
			   ,[SiteLocationID]
			   ,[SpecificLocationID]
			   ,[InstructorPersonID]
			   ,[AssistantPersonID]
			   ,[CurrentStatusTypeID]
			   ,[DateStart]
			   ,[DateEnd]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   ClassID,
			   rowguid, 
			   DateTimeStamp, 
			   LastModifiedBy, 
			   ClassTypeID, 
			   CourseInstanceID, 
			   LessonPlanID, 
			   SiteLocationID, 
			   SpecificLocationID, 
			   InstructorPersonID, 
			   AssistantPersonID, 
			   CurrentStatusTypeID, 
			   DateStart, 
			   DateEnd, 
			   @Type, 
			   getdate(), 
			   LastModifiedBy, 
			   SUSER_SNAME()
		FROM Inserted

END
GO
CREATE NONCLUSTERED INDEX [IX_Classes_DateStart_CourseInstanceID]
    ON [dbo].[Classes]([DateStart] ASC)
    INCLUDE([ClassID], [CourseInstanceID]);


GO
CREATE NONCLUSTERED INDEX [IX_Classes_CourseInstanceID_SpecificLocationID]
    ON [dbo].[Classes]([CourseInstanceID] ASC)
    INCLUDE([SpecificLocationID]);

