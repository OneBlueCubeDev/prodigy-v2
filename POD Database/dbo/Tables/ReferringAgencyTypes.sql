CREATE TABLE [dbo].[ReferringAgencyTypes] (
    [ReferringAgencyTypeID] INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]               UNIQUEIDENTIFIER CONSTRAINT [DF_ReferringAgencyTypes_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp]         SMALLDATETIME    CONSTRAINT [DF_ReferringAgencyTypes_DateTimeStamp] DEFAULT (getdate()) NULL,
    [Name]                  NVARCHAR (100)   NOT NULL,
    [Description]           NVARCHAR (MAX)   NULL,
    [IsActive]              BIT              CONSTRAINT [DF_ReferringAgencyTypes_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_ReferringAgencyTypes] PRIMARY KEY CLUSTERED ([ReferringAgencyTypeID] ASC)
);

