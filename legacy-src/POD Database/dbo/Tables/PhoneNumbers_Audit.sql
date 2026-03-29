CREATE TABLE [dbo].[PhoneNumbers_Audit] (
    [AuditID]           INT              IDENTITY (1, 1) NOT NULL,
    [PhoneNumberID]     INT              NULL,
    [rowguid]           UNIQUEIDENTIFIER NULL,
    [DateTimeStamp]     SMALLDATETIME    NULL,
    [LastModifiedBy]    NVARCHAR (255)   NULL,
    [PhoneNumberTypeID] INT              NULL,
    [Phone]             NVARCHAR (50)    NULL,
    [Extension]         NVARCHAR (50)    NULL,
    [AuditAction]       NVARCHAR (10)    NULL,
    [AuditDateTime]     SMALLDATETIME    CONSTRAINT [DF_PhoneNumbers_Audit_AuditDateTime] DEFAULT (getdate()) NULL,
    [AuditUser]         NVARCHAR (250)   NULL,
    [AuditSQLUser]      NVARCHAR (250)   NULL,
    CONSTRAINT [PK_PhoneNumbers_Audit_1] PRIMARY KEY CLUSTERED ([AuditID] ASC)
);

