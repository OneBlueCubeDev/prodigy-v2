CREATE TABLE [dbo].[AddressTypes] (
    [AddressTypeID] INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]       UNIQUEIDENTIFIER CONSTRAINT [DF_AddressTypes_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp] SMALLDATETIME    CONSTRAINT [DF_AddressTypes_DateTimeStamp] DEFAULT (getdate()) NULL,
    [Name]          NVARCHAR (100)   NOT NULL,
    [Description]   NVARCHAR (MAX)   NULL,
    [IsActive]      BIT              CONSTRAINT [DF_AddressTypes_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_AddressTypes] PRIMARY KEY CLUSTERED ([AddressTypeID] ASC)
);

