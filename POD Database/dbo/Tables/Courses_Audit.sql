CREATE TABLE [dbo].[Courses_Audit] (
    [AuditID]        INT              IDENTITY (1, 1) NOT NULL,
    [CourseID]       INT              NULL,
    [rowguid]        UNIQUEIDENTIFIER NULL,
    [DateTimeStamp]  SMALLDATETIME    NULL,
    [LastModifiedBy] NVARCHAR (255)   NULL,
    [CourseTypeID]   INT              NULL,
    [ProgramID]      INT              NULL,
    [StatusTypeID]   INT              NULL,
    [Name]           NVARCHAR (100)   NULL,
    [Description]    NVARCHAR (MAX)   NULL,
    [AuditAction]    NVARCHAR (10)    NULL,
    [AuditDateTime]  SMALLDATETIME    CONSTRAINT [DF_Courses_Audit_AuditDateTime] DEFAULT (getdate()) NULL,
    [AuditUser]      NVARCHAR (250)   NULL,
    [AuditSQLUser]   NVARCHAR (250)   NULL,
    CONSTRAINT [PK_Courses_Audit_1] PRIMARY KEY CLUSTERED ([AuditID] ASC)
);

