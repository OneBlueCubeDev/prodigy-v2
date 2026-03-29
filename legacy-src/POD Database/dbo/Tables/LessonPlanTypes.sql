CREATE TABLE [dbo].[LessonPlanTypes] (
    [LessonPlanTypeID] INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]          UNIQUEIDENTIFIER CONSTRAINT [DF_LessonPlanTypes_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp]    SMALLDATETIME    CONSTRAINT [DF_LessonPlanTypes_DateTimeStamp] DEFAULT (getdate()) NULL,
    [Name]             NVARCHAR (100)   NOT NULL,
    [Description]      NVARCHAR (MAX)   NULL,
    [IsActive]         BIT              CONSTRAINT [DF_LessonPlanTypes_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_LessonPlanTypes] PRIMARY KEY CLUSTERED ([LessonPlanTypeID] ASC)
);

