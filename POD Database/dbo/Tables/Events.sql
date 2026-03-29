CREATE TABLE [dbo].[Events] (
    [EventID]               INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]               UNIQUEIDENTIFIER CONSTRAINT [DF_Events_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp]         SMALLDATETIME    CONSTRAINT [DF_Events_DateTimeStamp] DEFAULT (getdate()) NULL,
    [LastModifiedBy]        NVARCHAR (255)   CONSTRAINT [DF_Events_LastModifiedBy] DEFAULT ('SQL Server Management Studio') NULL,
    [EventTypeID]           INT              NOT NULL,
    [LocationID]            INT              NULL,
    [StatusTypeID]          INT              NOT NULL,
    [DateStart]             DATETIME         NULL,
    [DateEnd]               DATETIME         NULL,
    [Name]                  NVARCHAR (255)   NULL,
    [Description]           NVARCHAR (MAX)   NULL,
    [Notes]                 NVARCHAR (MAX)   NULL,
    [SiteLocationID]        INT              NOT NULL,
    [ProgramID]             INT              NOT NULL,
    [EventLocation]         NVARCHAR (255)   NULL,
    [Category]              NVARCHAR (255)   NULL,
    [YouthAttendanceCount]  INT              NULL,
    [StaffAttendanceCount]  INT              NULL,
    [FamilyAttendanceCount] INT              NULL,
    CONSTRAINT [PK_Events] PRIMARY KEY CLUSTERED ([EventID] ASC),
    CONSTRAINT [FK_Events_EventTypes] FOREIGN KEY ([EventTypeID]) REFERENCES [dbo].[EventTypes] ([EventTypeID]),
    CONSTRAINT [FK_Events_Locations] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Locations] ([LocationID]),
    CONSTRAINT [FK_Events_Programs] FOREIGN KEY ([ProgramID]) REFERENCES [dbo].[Programs] ([ProgramID]),
    CONSTRAINT [FK_Events_Sites] FOREIGN KEY ([SiteLocationID]) REFERENCES [dbo].[Sites] ([LocationID]),
    CONSTRAINT [FK_Events_StatusTypes] FOREIGN KEY ([StatusTypeID]) REFERENCES [dbo].[StatusTypes] ([StatusTypeID]) ON UPDATE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_Events]
    ON [dbo].[Events]([LocationID] ASC);


GO
CREATE TRIGGER [dbo].[tr_Events]
   ON  [dbo].[Events]
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
		INSERT INTO [POD].[dbo].[Events_Audit]
			   ([EventID]
			   ,[rowguid]
			   ,[DateTimeStamp]
			   ,[LastModifiedBy]
			   ,[EventTypeID]
			   ,[LocationID]
			   ,[StatusTypeID]
			   ,[DateStart]
			   ,[DateEnd]
			   ,[Name]
			   ,[Description]
			   ,[Notes]
			   ,[ProgramID]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   EventID, 
			   rowguid, 
			   DateTimeStamp, 
			   LastModifiedBy,
			   EventTypeID, 
			   LocationID, 
			   StatusTypeID, 
			   DateStart, 
			   DateEnd,
			   Name, 
			   Description, 
			   Notes, 
			   ProgramID,
			   @Type, 
			   getdate(), 
			   LastModifiedBy, 
			   SUSER_SNAME()
		FROM Deleted
	ELSE
		INSERT INTO [POD].[dbo].[Events_Audit]
			   ([EventID]
			   ,[rowguid]
			   ,[DateTimeStamp]
			   ,[LastModifiedBy]
			   ,[EventTypeID]
			   ,[LocationID]
			   ,[StatusTypeID]
			   ,[DateStart]
			   ,[DateEnd]
			   ,[Name]
			   ,[Description]
			   ,[Notes]
			   ,[ProgramID]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   EventID, 
			   rowguid, 
			   DateTimeStamp, 
			   LastModifiedBy,
			   EventTypeID, 
			   LocationID, 
			   StatusTypeID, 
			   DateStart, 
			   DateEnd,
			   Name, 
			   Description, 
			   Notes,
			   ProgramID, 
			   @Type, 
			   getdate(), 
			   LastModifiedBy, 
			   SUSER_SNAME()
		FROM Inserted

END