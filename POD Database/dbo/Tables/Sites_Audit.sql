CREATE TABLE [dbo].[Sites_Audit] (
    [AuditID]              INT            IDENTITY (1, 1) NOT NULL,
    [LocationID]           INT            NULL,
    [Organization]         NVARCHAR (255) NULL,
    [AuditAction]          NVARCHAR (10)  NULL,
    [AuditDateTime]        SMALLDATETIME  CONSTRAINT [DF_Sites_Audit_AuditDateTime] DEFAULT (getdate()) NULL,
    [AuditUser]            NVARCHAR (250) NULL,
    [AuditSQLUser]         NVARCHAR (250) NULL,
    [AttendanceLockedDate] DATETIME       NULL,
    CONSTRAINT [PK_Sites_Audit_1] PRIMARY KEY CLUSTERED ([AuditID] ASC)
);

