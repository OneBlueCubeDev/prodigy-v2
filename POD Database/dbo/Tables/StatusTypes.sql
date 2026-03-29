CREATE TABLE [dbo].[StatusTypes] (
    [StatusTypeID]  INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]       UNIQUEIDENTIFIER CONSTRAINT [DF_StatusTypes_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp] SMALLDATETIME    CONSTRAINT [DF_StatusTypes_DateTimeStamp] DEFAULT (getdate()) NULL,
    [Name]          NVARCHAR (100)   NOT NULL,
    [Description]   NVARCHAR (MAX)   NULL,
    [IsActive]      BIT              CONSTRAINT [DF_StatusTypes_IsActive] DEFAULT ((1)) NOT NULL,
    [Category]      NVARCHAR (150)   NULL,
    CONSTRAINT [PK_StatusTypes] PRIMARY KEY CLUSTERED ([StatusTypeID] ASC)
);

