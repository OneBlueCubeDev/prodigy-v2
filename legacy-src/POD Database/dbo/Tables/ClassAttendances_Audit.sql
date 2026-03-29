CREATE TABLE [dbo].[ClassAttendances_Audit] (
    [AuditID]           INT              IDENTITY (1, 1) NOT NULL,
    [ClassAttendanceID] INT              NULL,
    [rowguid]           UNIQUEIDENTIFIER NULL,
    [DateTimeStamp]     SMALLDATETIME    NULL,
    [LastModifiedBy]    NVARCHAR (255)   NULL,
    [ClassID]           INT              NULL,
    [Student_PersonID]  INT              NULL,
    [Tardy]             BIT              CONSTRAINT [DF_ClassAttendances_Audit_Tardy] DEFAULT ((0)) NULL,
    [LeftEarly]         BIT              CONSTRAINT [DF_ClassAttendances_Audit_LeftEarly] DEFAULT ((0)) NULL,
    [Notes]             NVARCHAR (MAX)   NULL,
    [AuditAction]       NVARCHAR (10)    NULL,
    [AuditDateTime]     SMALLDATETIME    CONSTRAINT [DF_ClassAttendances_Audit_AuditDateTime] DEFAULT (getdate()) NULL,
    [AuditUser]         NVARCHAR (250)   NULL,
    [AuditSQLUser]      NVARCHAR (250)   NULL,
    CONSTRAINT [PK_ClassAttendances_Audit_1] PRIMARY KEY CLUSTERED ([AuditID] ASC)
);

