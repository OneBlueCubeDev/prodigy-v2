CREATE TABLE [dbo].[EventAttendances_Audit] (
    [AuditID]           INT              IDENTITY (1, 1) NOT NULL,
    [EventAttendanceID] INT              NULL,
    [rowguid]           UNIQUEIDENTIFIER NULL,
    [DateTimeStamp]     SMALLDATETIME    NULL,
    [LastModifiedBy]    NVARCHAR (255)   NULL,
    [PersonID]          INT              NULL,
    [EventID]           INT              NULL,
    [AuditAction]       NVARCHAR (10)    NULL,
    [AuditDateTime]     SMALLDATETIME    CONSTRAINT [DF_EventAttendances_Audit_AuditDateTime] DEFAULT (getdate()) NULL,
    [AuditUser]         NVARCHAR (250)   NULL,
    [AuditSQLUser]      NVARCHAR (250)   NULL,
    CONSTRAINT [PK_EventAttendances_Audit_1] PRIMARY KEY CLUSTERED ([AuditID] ASC)
);

