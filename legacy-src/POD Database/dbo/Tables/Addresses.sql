CREATE TABLE [dbo].[Addresses] (
    [AddressID]      INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]        UNIQUEIDENTIFIER CONSTRAINT [DF_Addresses_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp]  SMALLDATETIME    CONSTRAINT [DF_Addresses_DateTimeStamp] DEFAULT (getdate()) NULL,
    [LastModifiedBy] NVARCHAR (255)   CONSTRAINT [DF_Addresses_LastModifiedBy] DEFAULT ('SQL Server Management Studio') NULL,
    [AddressTypeID]  INT              NOT NULL,
    [StatusTypeID]   INT              NOT NULL,
    [AddressLine1]   NVARCHAR (500)   NULL,
    [AddressLine2]   NVARCHAR (500)   NULL,
    [AptNum]         NVARCHAR (50)    NULL,
    [City]           NVARCHAR (100)   NULL,
    [State]          NVARCHAR (4)     NULL,
    [Zip]            NVARCHAR (10)    NULL,
    [CountyID]       INT              NULL,
    [CommunityID]    INT              NULL,
    [CapTrackID]     INT              NULL,
    CONSTRAINT [PK_Addresses] PRIMARY KEY CLUSTERED ([AddressID] ASC),
    CONSTRAINT [FK_Addresses_AddressTypes] FOREIGN KEY ([AddressTypeID]) REFERENCES [dbo].[AddressTypes] ([AddressTypeID]),
    CONSTRAINT [FK_Addresses_Communities] FOREIGN KEY ([CommunityID]) REFERENCES [dbo].[Communities] ([CommunityID]),
    CONSTRAINT [FK_Addresses_Counties] FOREIGN KEY ([CountyID]) REFERENCES [dbo].[Counties] ([CountyID]) ON DELETE SET NULL ON UPDATE SET NULL,
    CONSTRAINT [FK_Addresses_StatusTypes] FOREIGN KEY ([StatusTypeID]) REFERENCES [dbo].[StatusTypes] ([StatusTypeID]) ON UPDATE CASCADE
);


GO

CREATE TRIGGER [dbo].[tr_Addresses_Audit]
   ON  [dbo].[Addresses]
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
		INSERT INTO [POD].[dbo].[Addresses_Audit]
			   ([AddressID]
			   ,[rowguid]
			   ,[DateTimeStamp]
			   ,[LastModifiedBy]
			   ,[AddressTypeID]
			   ,[StatusTypeID]
			   ,[AddressLine1]
			   ,[AddressLine2]
			   ,[AptNum]
			   ,[City]
			   ,[State]
			   ,[Zip]
			   ,[CountyID]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   AddressID, 
			   rowguid, 
			   DateTimeStamp, 
			   LastModifiedBy, 
			   AddressTypeID, 
			   StatusTypeID, 
			   AddressLine1, 
			   AddressLine2, 
			   AptNum, 
			   City, 
			   State, 
			   Zip, 
			   CountyID, 
			   @Type, 
			   getdate(), 
			   LastModifiedBy, 
			   SUSER_SNAME()
		 FROM Deleted
     ELSE
     	INSERT INTO [POD].[dbo].[Addresses_Audit]
			   ([AddressID]
			   ,[rowguid]
			   ,[DateTimeStamp]
			   ,[LastModifiedBy]
			   ,[AddressTypeID]
			   ,[StatusTypeID]
			   ,[AddressLine1]
			   ,[AddressLine2]
			   ,[AptNum]
			   ,[City]
			   ,[State]
			   ,[Zip]
			   ,[CountyID]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   AddressID, 
			   rowguid, 
			   DateTimeStamp, 
			   LastModifiedBy, 
			   AddressTypeID, 
			   StatusTypeID, 
			   AddressLine1, 
			   AddressLine2, 
			   AptNum, 
			   City, 
			   State, 
			   Zip, 
			   CountyID, 
			   @Type, 
			   getdate(), 
			   LastModifiedBy, 
			   SUSER_SNAME()
		 FROM Inserted

END