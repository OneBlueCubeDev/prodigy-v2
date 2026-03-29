CREATE TABLE [dbo].[ClassTypes] (
    [ClassTypeID]   INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]       UNIQUEIDENTIFIER CONSTRAINT [DF_ClassTypes_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp] SMALLDATETIME    CONSTRAINT [DF_ClassTypes_DateTimeStamp] DEFAULT (getdate()) NULL,
    [Name]          NVARCHAR (100)   NOT NULL,
    [Description]   NVARCHAR (MAX)   NULL,
    [IsActive]      BIT              CONSTRAINT [DF_ClassTypes_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_ClassTypes] PRIMARY KEY CLUSTERED ([ClassTypeID] ASC)
);

