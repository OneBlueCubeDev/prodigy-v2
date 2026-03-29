CREATE TABLE [dbo].[LessonPlanSets] (
    [LessonPlanSetID]    INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]            UNIQUEIDENTIFIER CONSTRAINT [DF_LessonPlanSets_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [DateTimeStamp]      SMALLDATETIME    CONSTRAINT [DF_LessonPlanSets_DateTimeStamp] DEFAULT (getdate()) NOT NULL,
    [LastModifiedBy]     NVARCHAR (255)   NULL,
    [IsPublic]           BIT              CONSTRAINT [DF_LessonPlanSets_IsPublic] DEFAULT ((0)) NOT NULL,
    [Name]               NVARCHAR (255)   NOT NULL,
    [InstructorPersonID] INT              NOT NULL,
    [StatusTypeID]       INT              NULL,
    [ProgramID]          INT              NULL,
    CONSTRAINT [PK_LessonPlanSets] PRIMARY KEY CLUSTERED ([LessonPlanSetID] ASC),
    CONSTRAINT [FK_LessonPlanSets_Programs] FOREIGN KEY ([ProgramID]) REFERENCES [dbo].[Programs] ([ProgramID]),
    CONSTRAINT [FK_LessonPlanSets_StaffMembers] FOREIGN KEY ([InstructorPersonID]) REFERENCES [dbo].[StaffMembers] ([PersonID]),
    CONSTRAINT [FK_LessonPlanSets_StatusTypes] FOREIGN KEY ([StatusTypeID]) REFERENCES [dbo].[StatusTypes] ([StatusTypeID])
);

