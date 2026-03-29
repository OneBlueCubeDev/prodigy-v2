CREATE TABLE [dbo].[Programs_Audit] (
    [AuditID]        INT              IDENTITY (1, 1) NOT NULL,
    [ProgramID]      INT              NULL,
    [rowguid]        UNIQUEIDENTIFIER NULL,
    [DateTimeStamp]  SMALLDATETIME    NULL,
    [LastModifiedBy] NVARCHAR (255)   NULL,
    [ProgramTypeID]  INT              NULL,
    [StatusTypeID]   INT              NULL,
    [Name]           NVARCHAR (100)   NULL,
    [Description]    NVARCHAR (MAX)   NULL,
    [ProviderName]   NVARCHAR (255)   NULL,
    [AuditAction]    NVARCHAR (10)    NULL,
    [AuditDateTime]  SMALLDATETIME    CONSTRAINT [DF_Programs_Audit_AuditDateTime] DEFAULT (getdate()) NULL,
    [AuditUser]      NVARCHAR (250)   NULL,
    [AuditSQLUser]   NVARCHAR (250)   NULL,
    CONSTRAINT [PK_Programs_Audit_1] PRIMARY KEY CLUSTERED ([AuditID] ASC)
);

