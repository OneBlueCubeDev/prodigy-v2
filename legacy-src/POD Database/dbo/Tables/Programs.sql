CREATE TABLE [dbo].[Programs] (
    [ProgramID]      INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]        UNIQUEIDENTIFIER CONSTRAINT [DF_Programs_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp]  SMALLDATETIME    CONSTRAINT [DF_Programs_DateTimeStamp] DEFAULT (getdate()) NULL,
    [LastModifiedBy] NVARCHAR (255)   CONSTRAINT [DF_Programs_LastModifiedBy] DEFAULT ('SQL Server Management Studio') NULL,
    [ProgramTypeID]  INT              NOT NULL,
    [StatusTypeID]   INT              NOT NULL,
    [Name]           NVARCHAR (100)   NOT NULL,
    [Description]    NVARCHAR (MAX)   NULL,
    [ProviderName]   NVARCHAR (255)   CONSTRAINT [DF_Programs_Provider] DEFAULT (N'University Area Community Development Corporation, Inc. (UACDC)') NULL,
    CONSTRAINT [PK_Programs] PRIMARY KEY CLUSTERED ([ProgramID] ASC),
    CONSTRAINT [FK_Programs_ProgramTypes] FOREIGN KEY ([ProgramTypeID]) REFERENCES [dbo].[ProgramTypes] ([ProgramTypeID]),
    CONSTRAINT [FK_Programs_StatusTypes] FOREIGN KEY ([StatusTypeID]) REFERENCES [dbo].[StatusTypes] ([StatusTypeID]) ON UPDATE CASCADE
);


GO

CREATE TRIGGER [dbo].[tr_Programs]
   ON  [dbo].[Programs]
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
		INSERT INTO [POD].[dbo].[Programs_Audit]
			   ([ProgramID]
			   ,[rowguid]
			   ,[DateTimeStamp]
			   ,[LastModifiedBy]
			   ,[ProgramTypeID]
			   ,[StatusTypeID]
			   ,[Name]
			   ,[Description]
			   ,[ProviderName]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   ProgramID, 
			   rowguid, 
			   DateTimeStamp, 
			   LastModifiedBy, 
			   ProgramTypeID, 
			   StatusTypeID, 
			   Name, 
			   [Description],
			   [ProviderName],			    
			   @Type, 
			   getdate(), 
			   LastModifiedBy, 
			   SUSER_SNAME()
		FROM Deleted
	ELSE
		INSERT INTO [POD].[dbo].[Programs_Audit]
			   ([ProgramID]
			   ,[rowguid]
			   ,[DateTimeStamp]
			   ,[LastModifiedBy]
			   ,[ProgramTypeID]
			   ,[StatusTypeID]
			   ,[Name]
			   ,[Description]
			   ,[ProviderName]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   ProgramID, 
			   rowguid, 
			   DateTimeStamp, 
			   LastModifiedBy, 
			   ProgramTypeID, 
			   StatusTypeID, 
			   Name, 
			   [Description],
			   [ProviderName],			    
			   @Type, 
			   getdate(), 
			   LastModifiedBy, 
			   SUSER_SNAME()
		FROM Inserted

END