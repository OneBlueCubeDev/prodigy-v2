CREATE TABLE [dbo].[EventAttendances] (
    [EventAttendanceID] INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]           UNIQUEIDENTIFIER CONSTRAINT [DF_EventAttendances_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp]     SMALLDATETIME    CONSTRAINT [DF_EventAttendances_DateTimeStamp] DEFAULT (getdate()) NULL,
    [LastModifiedBy]    NVARCHAR (255)   CONSTRAINT [DF_EventAttendances_LastModifiedBy] DEFAULT ('SQL Server Management Studio') NULL,
    [PersonID]          INT              NOT NULL,
    [EventID]           INT              NOT NULL,
    CONSTRAINT [PK_EventAttendances] PRIMARY KEY CLUSTERED ([EventAttendanceID] ASC),
    CONSTRAINT [FK_EventAttendances_Events] FOREIGN KEY ([EventID]) REFERENCES [dbo].[Events] ([EventID]),
    CONSTRAINT [FK_EventAttendances_Persons] FOREIGN KEY ([PersonID]) REFERENCES [dbo].[Persons] ([PersonID])
);


GO
CREATE TRIGGER [dbo].[tr_EventAttendances]
   ON  dbo.EventAttendances
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
		INSERT INTO [POD].[dbo].[EventAttendances_Audit]
			   ([EventAttendanceID]
			   ,[rowguid]
			   ,[DateTimeStamp]
			   ,[LastModifiedBy]
			   ,[PersonID]
			   ,[EventID]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   EventAttendanceID, 
			   rowguid, 
			   DateTimeStamp, 
			   LastModifiedBy, 
			   PersonID, 
			   EventID, 
			   @Type, 
			   getdate(), 
			   LastModifiedBy, 
			   SUSER_SNAME()
		FROM Deleted
	ELSE
		INSERT INTO [POD].[dbo].[EventAttendances_Audit]
			   ([EventAttendanceID]
			   ,[rowguid]
			   ,[DateTimeStamp]
			   ,[LastModifiedBy]
			   ,[PersonID]
			   ,[EventID]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   EventAttendanceID, 
			   rowguid, 
			   DateTimeStamp, 
			   LastModifiedBy, 
			   PersonID, 
			   EventID, 
			   @Type, 
			   getdate(), 
			   LastModifiedBy, 
			   SUSER_SNAME()
		FROM Inserted

END