CREATE TABLE [dbo].[PhoneNumbers] (
    [PhoneNumberID]     INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]           UNIQUEIDENTIFIER CONSTRAINT [DF_PhoneNumbers_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp]     SMALLDATETIME    CONSTRAINT [DF_PhoneNumbers_DateTimeStamp] DEFAULT (getdate()) NULL,
    [LastModifiedBy]    NVARCHAR (255)   CONSTRAINT [DF_PhoneNumbers_LastModifiedBy] DEFAULT ('SQL Server Management Studio') NULL,
    [PhoneNumberTypeID] INT              NOT NULL,
    [Phone]             NVARCHAR (50)    NOT NULL,
    [Extension]         NVARCHAR (50)    NULL,
    [CapTrackID]        INT              NULL,
    CONSTRAINT [PK_PhoneNumbers] PRIMARY KEY CLUSTERED ([PhoneNumberID] ASC),
    CONSTRAINT [FK_PhoneNumbers_PhoneNumberTypes] FOREIGN KEY ([PhoneNumberTypeID]) REFERENCES [dbo].[PhoneNumberTypes] ([PhoneNumberTypeID])
);


GO
CREATE TRIGGER [dbo].[tr_PhoneNumers]
   ON  dbo.PhoneNumbers
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
		INSERT INTO [POD].[dbo].[PhoneNumbers_Audit]
			   ([PhoneNumberID]
			   ,[rowguid]
			   ,[DateTimeStamp]
			   ,[LastModifiedBy]
			   ,[PhoneNumberTypeID]
			   ,[Phone]
			   ,[Extension]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   PhoneNumberID, 
			   rowguid, 
			   DateTimeStamp, 
			   LastModifiedBy, 
			   PhoneNumberTypeID, 
			   Phone, 
			   Extension, 
			   @Type, 
			   getdate(), 
			   LastModifiedBy, 
			   SUSER_SNAME()
		FROM Deleted
	ELSE
		INSERT INTO [POD].[dbo].[PhoneNumbers_Audit]
			   ([PhoneNumberID]
			   ,[rowguid]
			   ,[DateTimeStamp]
			   ,[LastModifiedBy]
			   ,[PhoneNumberTypeID]
			   ,[Phone]
			   ,[Extension]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   PhoneNumberID, 
			   rowguid, 
			   DateTimeStamp, 
			   LastModifiedBy, 
			   PhoneNumberTypeID, 
			   Phone, 
			   Extension, 
			   @Type, 
			   getdate(), 
			   LastModifiedBy, 
			   SUSER_SNAME()
		FROM Inserted

END