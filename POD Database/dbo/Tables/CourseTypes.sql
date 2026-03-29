CREATE TABLE [dbo].[CourseTypes] (
    [CourseTypeID]  INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]       UNIQUEIDENTIFIER CONSTRAINT [DF_CourseTypes_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp] SMALLDATETIME    CONSTRAINT [DF_CourseTypes_DateTimeStamp] DEFAULT (getdate()) NULL,
    [Name]          NVARCHAR (100)   NOT NULL,
    [Description]   NVARCHAR (MAX)   NULL,
    [IsActive]      BIT              CONSTRAINT [DF_CourseTypes_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_CourseTypes] PRIMARY KEY CLUSTERED ([CourseTypeID] ASC)
);

