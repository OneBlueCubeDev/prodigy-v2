CREATE TABLE [dbo].[ClassAttendances] (
    [ClassAttendanceID] INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]           UNIQUEIDENTIFIER CONSTRAINT [DF_ClassAttendances_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp]     SMALLDATETIME    CONSTRAINT [DF_ClassAttendances_DateTimeStamp] DEFAULT (getdate()) NULL,
    [LastModifiedBy]    NVARCHAR (255)   CONSTRAINT [DF_ClassAttendances_LastModifiedBy] DEFAULT ('SQL Server Management Studio') NULL,
    [ClassID]           INT              NOT NULL,
    [Student_PersonID]  INT              NOT NULL,
    [Tardy]             BIT              CONSTRAINT [DF_ClassAttendances_Tardy] DEFAULT ((0)) NOT NULL,
    [LeftEarly]         BIT              CONSTRAINT [DF_ClassAttendances_LeftEarly] DEFAULT ((0)) NOT NULL,
    [Notes]             NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_ClassAttendances] PRIMARY KEY CLUSTERED ([ClassAttendanceID] ASC),
    CONSTRAINT [FK_ClassAttendances_Classes] FOREIGN KEY ([ClassID]) REFERENCES [dbo].[Classes] ([ClassID]),
    CONSTRAINT [FK_ClassAttendances_Persons] FOREIGN KEY ([Student_PersonID]) REFERENCES [dbo].[Persons] ([PersonID])
);




GO

CREATE TRIGGER [dbo].[tr_ClassAttendaces]
   ON  [dbo].[ClassAttendances]
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
		INSERT INTO [POD].[dbo].[ClassAttendances_Audit]
			   ([ClassAttendanceID]
			   ,[rowguid]
			   ,[DateTimeStamp]
			   ,[LastModifiedBy]
			   ,[ClassID]
			   ,[Student_PersonID]
			   ,[Tardy]
			   ,[LeftEarly]
			   ,[Notes]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   ClassAttendanceID, 
			   rowguid, 
			   DateTimeStamp, 
			   LastModifiedBy, 
			   ClassID, 
			   Student_PersonID, 
			   Tardy, 
			   LeftEarly, 
			   Notes, 
			   @Type, 
			   getdate(), 
			   LastModifiedBy, 
			   SUSER_SNAME()
		FROM Deleted
     ELSE
		INSERT INTO [POD].[dbo].[ClassAttendances_Audit]
			   ([ClassAttendanceID]
			   ,[rowguid]
			   ,[DateTimeStamp]
			   ,[LastModifiedBy]
			   ,[ClassID]
			   ,[Student_PersonID]
			   ,[Tardy]
			   ,[LeftEarly]
			   ,[Notes]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   ClassAttendanceID, 
			   rowguid, 
			   DateTimeStamp, 
			   LastModifiedBy, 
			   ClassID, 
			   Student_PersonID, 
			   Tardy, 
			   LeftEarly, 
			   Notes, 
			   @Type, 
			   getdate(), 
			   LastModifiedBy, 
			   SUSER_SNAME()
		FROM Inserted
END
GO
CREATE NONCLUSTERED INDEX [IX_ClassAttendances_DateTimeStamp]
    ON [dbo].[ClassAttendances]([Student_PersonID] ASC, [DateTimeStamp] ASC);
GO
CREATE NONCLUSTERED INDEX [IX_ClassAttendances_DateTimeStamp_Census]
	ON [dbo].[ClassAttendances] ([DateTimeStamp]) INCLUDE ([ClassID],[Student_PersonID]);
GO