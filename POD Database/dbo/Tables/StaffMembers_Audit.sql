CREATE TABLE [dbo].[StaffMembers_Audit] (
    [AuditID]       INT            IDENTITY (1, 1) NOT NULL,
    [PersonID]      INT            NULL,
    [HireDate]      DATETIME       NULL,
    [AuditAction]   NVARCHAR (10)  NULL,
    [AuditDateTime] SMALLDATETIME  CONSTRAINT [DF_StaffMembers_Audit_AuditDateTime] DEFAULT (getdate()) NULL,
    [AuditUser]     NVARCHAR (250) NULL,
    [AuditSQLUser]  NVARCHAR (250) NULL,
    CONSTRAINT [PK_StaffMembers_Audit_1] PRIMARY KEY CLUSTERED ([AuditID] ASC)
);

