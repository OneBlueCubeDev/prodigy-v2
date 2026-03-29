CREATE TABLE [dbo].[InventoryItems] (
    [InventoryItemID]     INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]             UNIQUEIDENTIFIER CONSTRAINT [DF_InventoryItems_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp]       SMALLDATETIME    CONSTRAINT [DF_InventoryItems_DateTimeStamp] DEFAULT (getdate()) NULL,
    [LastModifiedBy]      NVARCHAR (255)   CONSTRAINT [DF_InventoryItems_LastModifiedBy] DEFAULT ('SQL Server Management Studio') NULL,
    [LocationID]          INT              NULL,
    [InventoryItemTypeID] INT              NULL,
    [Name]                NVARCHAR (255)   NULL,
    [Description]         NVARCHAR (MAX)   NULL,
    [Manufacturer]        NVARCHAR (255)   NULL,
    [Model]               NVARCHAR (255)   NULL,
    [SerialNum]           NVARCHAR (50)    NULL,
    [AcquisitionCost]     MONEY            NULL,
    [AcquisitionDate]     SMALLDATETIME    NULL,
    [Organization]        NVARCHAR (255)   NULL,
    [UACDCTagNum]         NVARCHAR (50)    NULL,
    [DJJTagNum]           NVARCHAR (50)    NULL,
    [Condition]           NVARCHAR (255)   NULL,
    [Comments]            NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_InventoryItems] PRIMARY KEY CLUSTERED ([InventoryItemID] ASC),
    CONSTRAINT [FK_InventoryItems_InventoryItemTypes] FOREIGN KEY ([InventoryItemTypeID]) REFERENCES [dbo].[InventoryItemTypes] ([InventoryItemTypeID]) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT [FK_InventoryItems_Locations] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Locations] ([LocationID]) ON DELETE SET NULL ON UPDATE CASCADE
);


GO

CREATE TRIGGER [dbo].[fr_InventoryItems]
   ON  [dbo].[InventoryItems]
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
		INSERT INTO [POD].[dbo].[InventoryItems_Audit]
			   ([InventoryItemID]
			   ,[rowguid]
			   ,[DateTimeStamp]
			   ,[LastModifiedBy]
			   ,[LocationID]
			   ,[InventoryItemTypeID]
			   ,[Name]
			   ,[Description]
			   ,[Manufacturer]
			   ,[Model]
			   ,[SerialNum]
			   ,[AcquisitionCost]
			   ,[AcquisitionDate]
			   ,[Organization]
			   ,[UACDCTagNum]
			   ,[DJJTagNum]
			   ,[Condition]
			   ,[Comments]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   InventoryItemID, 
			   rowguid, 
			   DateTimeStamp, 
			   LastModifiedBy, 
			   LocationID, 
			   InventoryItemTypeID, 
			   Name, 
			   Description, 
			   Manufacturer, 
			   Model, 
			   SerialNum, 
			   AcquisitionCost, 
			   AcquisitionDate, 
			   Organization, 
			   UACDCTagNum, 
			   DJJTagNum, 
			   Condition, 
			   Comments, 
			   @Type, 
			   getdate(), 
			   LastModifiedBy, 
			   SUSER_SNAME()
		FROM Deleted
	ELSE
		INSERT INTO [POD].[dbo].[InventoryItems_Audit]
			   ([InventoryItemID]
			   ,[rowguid]
			   ,[DateTimeStamp]
			   ,[LastModifiedBy]
			   ,[LocationID]
			   ,[InventoryItemTypeID]
			   ,[Name]
			   ,[Description]
			   ,[Manufacturer]
			   ,[Model]
			   ,[SerialNum]
			   ,[AcquisitionCost]
			   ,[AcquisitionDate]
			   ,[Organization]
			   ,[UACDCTagNum]
			   ,[DJJTagNum]
			   ,[Condition]
			   ,[Comments]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   InventoryItemID, 
			   rowguid, 
			   DateTimeStamp, 
			   LastModifiedBy, 
			   LocationID, 
			   InventoryItemTypeID, 
			   Name, 
			   Description, 
			   Manufacturer, 
			   Model, 
			   SerialNum, 
			   AcquisitionCost, 
			   AcquisitionDate, 
			   Organization, 
			   UACDCTagNum, 
			   DJJTagNum, 
			   Condition, 
			   Comments, 
			   @Type, 
			   getdate(), 
			   LastModifiedBy, 
			   SUSER_SNAME()
		FROM Inserted

END