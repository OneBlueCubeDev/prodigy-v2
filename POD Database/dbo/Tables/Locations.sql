CREATE TABLE [dbo].[Locations] (
    [LocationID]     INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]        UNIQUEIDENTIFIER CONSTRAINT [DF_Locations_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp]  SMALLDATETIME    CONSTRAINT [DF_Locations_DateTimeStamp] DEFAULT (getdate()) NULL,
    [LastModifiedBy] NVARCHAR (255)   CONSTRAINT [DF_Locations_LastModifiedBy] DEFAULT ('SQL Server Management Studio') NULL,
    [LocationTypeID] INT              NOT NULL,
    [AddressID]      INT              NOT NULL,
    [StatusTypeID]   INT              NOT NULL,
    [Name]           NVARCHAR (255)   NULL,
    [Notes]          NVARCHAR (MAX)   NULL,
    [SiteLocationID] INT              NULL,
    CONSTRAINT [PK_Locations] PRIMARY KEY CLUSTERED ([LocationID] ASC),
    CONSTRAINT [FK_Locations_Addresses] FOREIGN KEY ([AddressID]) REFERENCES [dbo].[Addresses] ([AddressID]),
    CONSTRAINT [FK_Locations_LocationTypes] FOREIGN KEY ([LocationTypeID]) REFERENCES [dbo].[LocationTypes] ([LocationTypeID]),
    CONSTRAINT [FK_Locations_Sites] FOREIGN KEY ([SiteLocationID]) REFERENCES [dbo].[Sites] ([LocationID]),
    CONSTRAINT [FK_Locations_StatusTypes] FOREIGN KEY ([StatusTypeID]) REFERENCES [dbo].[StatusTypes] ([StatusTypeID]) ON UPDATE CASCADE
);


GO

CREATE TRIGGER [dbo].[tr_Locations]
   ON [dbo].[Locations]
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
		INSERT INTO [POD].[dbo].[Locations_Audit]
			   ([LocationID]
			   ,[rowguid]
			   ,[DateTimeStamp]
			   ,[LastModifiedBy]
			   ,[LocationTypeID]
			   ,[AddressID]
			   ,[StatusTypeID]
			   ,[Name]
			   ,[Notes]
			   ,[SiteLocationID]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   LocationID,
			   rowguid,
			   DateTimeStamp,
			   LastModifiedBy, 
			   LocationTypeID, 
			   AddressID, 
			   StatusTypeID, 
			   Name, 
			   Notes,
			   [SiteLocationID], 
			   @Type, 
			   getdate(), 
			   LastModifiedBy, 
			   SUSER_SNAME()
		FROM Deleted
	ELSE
		INSERT INTO [POD].[dbo].[Locations_Audit]
			   ([LocationID]
			   ,[rowguid]
			   ,[DateTimeStamp]
			   ,[LastModifiedBy]
			   ,[LocationTypeID]
			   ,[AddressID]
			   ,[StatusTypeID]
			   ,[Name]
			   ,[Notes]
			   ,[SiteLocationID]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   LocationID,
			   rowguid,
			   DateTimeStamp,
			   LastModifiedBy, 
			   LocationTypeID, 
			   AddressID, 
			   StatusTypeID, 
			   Name, 
			   Notes, 
			   [SiteLocationID],
			   @Type, 
			   getdate(), 
			   LastModifiedBy, 
			   SUSER_SNAME()
		FROM Inserted

END