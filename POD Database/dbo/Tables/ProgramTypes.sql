CREATE TABLE [dbo].[ProgramTypes] (
    [ProgramTypeID] INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]       UNIQUEIDENTIFIER CONSTRAINT [DF_ProgramTypes_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp] SMALLDATETIME    CONSTRAINT [DF_ProgramTypes_DateTimeStamp] DEFAULT (getdate()) NULL,
    [Name]          NVARCHAR (100)   NOT NULL,
    [Description]   NVARCHAR (MAX)   NULL,
    [IsActive]      BIT              CONSTRAINT [DF_ProgramTypes_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_ProgramTypes] PRIMARY KEY CLUSTERED ([ProgramTypeID] ASC)
);

