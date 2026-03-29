CREATE TABLE [dbo].[CourseInstances_Audit] (
    [AuditID]            INT              IDENTITY (1, 1) NOT NULL,
    [CourseInstanceID]   INT              NULL,
    [rowguid]            UNIQUEIDENTIFIER NULL,
    [DateTimeStamp]      SMALLDATETIME    NULL,
    [LastModifiedBy]     NVARCHAR (255)   NULL,
    [CourseID]           INT              NULL,
    [ProgramID]          INT              NULL,
    [LocationID]         INT              NULL,
    [StartDate]          DATE             NULL,
    [EndDate]            DATE             NULL,
    [InstructorPersonID] INT              NULL,
    [AssistantPersonID]  INT              NULL,
    [Notes]              NVARCHAR (MAX)   NULL,
    [LessonPlanSetID]    INT              NULL,
    [AuditAction]        NVARCHAR (10)    NULL,
    [AuditDateTime]      SMALLDATETIME    CONSTRAINT [DF_CourseInstances_Audit_AuditDateTime] DEFAULT (getdate()) NULL,
    [AuditUser]          NVARCHAR (250)   NULL,
    [AuditSQLUser]       NVARCHAR (250)   NULL,
    CONSTRAINT [PK_CourseInstances_Audit_1] PRIMARY KEY CLUSTERED ([AuditID] ASC)
);

