CREATE TABLE [dbo].[InventoryItemTypes] (
    [InventoryItemTypeID] INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]             UNIQUEIDENTIFIER CONSTRAINT [DF_InventoryItemTypes_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp]       SMALLDATETIME    CONSTRAINT [DF_InventoryItemTypes_DateTimeStamp] DEFAULT (getdate()) NULL,
    [Name]                NVARCHAR (50)    NULL,
    [Description]         NVARCHAR (MAX)   NULL,
    [IsActive]            BIT              CONSTRAINT [DF_InventoryItemTypes_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_InventoryItemTypes] PRIMARY KEY CLUSTERED ([InventoryItemTypeID] ASC)
);

