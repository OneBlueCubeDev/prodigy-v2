CREATE TABLE [dbo].[Classes_Audit] (
    [AuditID]             INT              IDENTITY (1, 1) NOT NULL,
    [ClassID]             INT              NULL,
    [rowguid]             UNIQUEIDENTIFIER NULL,
    [DateTimeStamp]       SMALLDATETIME    NULL,
    [LastModifiedBy]      NVARCHAR (255)   NULL,
    [ClassTypeID]         INT              NULL,
    [CourseInstanceID]    INT              NULL,
    [LessonPlanID]        INT              NULL,
    [SiteLocationID]      INT              NULL,
    [SpecificLocationID]  INT              NULL,
    [InstructorPersonID]  INT              NULL,
    [AssistantPersonID]   INT              NULL,
    [CurrentStatusTypeID] INT              NULL,
    [DateStart]           SMALLDATETIME    NULL,
    [DateEnd]             SMALLDATETIME    NULL,
    [AuditAction]         NVARCHAR (10)    NULL,
    [AuditDateTime]       SMALLDATETIME    CONSTRAINT [DF_Classes_Audit_AuditDateTime] DEFAULT (getdate()) NULL,
    [AuditUser]           NVARCHAR (250)   NULL,
    [AuditSQLUser]        NVARCHAR (250)   NULL,
    CONSTRAINT [PK_Classes_Audit_1] PRIMARY KEY CLUSTERED ([AuditID] ASC)
);

