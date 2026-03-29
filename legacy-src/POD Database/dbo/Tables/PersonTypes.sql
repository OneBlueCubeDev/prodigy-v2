CREATE TABLE [dbo].[PersonTypes] (
    [PersonTypeID]  INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]       UNIQUEIDENTIFIER CONSTRAINT [DF_PersonTypes_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp] SMALLDATETIME    CONSTRAINT [DF_PersonTypes_DateTimeStamp] DEFAULT (getdate()) NULL,
    [Name]          NVARCHAR (100)   NOT NULL,
    [Description]   NVARCHAR (MAX)   NULL,
    [IsActive]      BIT              CONSTRAINT [DF_PersonTypes_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_PersonTypes] PRIMARY KEY CLUSTERED ([PersonTypeID] ASC)
);

