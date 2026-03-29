CREATE TABLE [dbo].[Courses] (
    [CourseID]       INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]        UNIQUEIDENTIFIER CONSTRAINT [DF_Courses_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp]  SMALLDATETIME    CONSTRAINT [DF_Courses_DateTimeStamp] DEFAULT (getdate()) NULL,
    [LastModifiedBy] NVARCHAR (255)   CONSTRAINT [DF_Courses_LastModifiedBy] DEFAULT ('SQL Server Management Studio') NULL,
    [CourseTypeID]   INT              NOT NULL,
    [ProgramID]      INT              NOT NULL,
    [StatusTypeID]   INT              NOT NULL,
    [Name]           NVARCHAR (100)   NOT NULL,
    [Description]    NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_CourseDefinitions] PRIMARY KEY CLUSTERED ([CourseID] ASC),
    CONSTRAINT [FK_Courses_CourseTypes] FOREIGN KEY ([CourseTypeID]) REFERENCES [dbo].[CourseTypes] ([CourseTypeID]),
    CONSTRAINT [FK_Courses_Programs] FOREIGN KEY ([ProgramID]) REFERENCES [dbo].[Programs] ([ProgramID]),
    CONSTRAINT [FK_Courses_StatusTypes] FOREIGN KEY ([StatusTypeID]) REFERENCES [dbo].[StatusTypes] ([StatusTypeID]) ON UPDATE CASCADE
);


GO

CREATE TRIGGER [dbo].[tr_Courses] 
   ON  [dbo].[Courses]
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
		INSERT INTO [POD].[dbo].[Courses_Audit]
			   ([CourseID]
			   ,[rowguid]
			   ,[DateTimeStamp]
			   ,[LastModifiedBy]
			   ,[CourseTypeID]
			   ,[ProgramID]
			   ,[StatusTypeID]
			   ,[Name]
			   ,[Description]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   CourseID, 
			   rowguid, 
			   DateTimeStamp, 
			   LastModifiedBy, 
			   CourseTypeID, 
			   ProgramID, 
			   StatusTypeID, 
			   Name, 
			   Description, 
			   @Type, 
			   getdate(), 
			   LastModifiedBy, 
			   SUSER_SNAME()
		FROM Deleted
	ELSE
		INSERT INTO [POD].[dbo].[Courses_Audit]
			   ([CourseID]
			   ,[rowguid]
			   ,[DateTimeStamp]
			   ,[LastModifiedBy]
			   ,[CourseTypeID]
			   ,[ProgramID]
			   ,[StatusTypeID]
			   ,[Name]
			   ,[Description]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   CourseID, 
			   rowguid, 
			   DateTimeStamp, 
			   LastModifiedBy, 
			   CourseTypeID, 
			   ProgramID, 
			   StatusTypeID, 
			   Name, 
			   Description, 
			   @Type, 
			   getdate(), 
			   LastModifiedBy, 
			   SUSER_SNAME()
		FROM Inserted

END