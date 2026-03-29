CREATE TABLE [dbo].[Events_Audit] (
    [AuditID]        INT              IDENTITY (1, 1) NOT NULL,
    [EventID]        INT              NULL,
    [rowguid]        UNIQUEIDENTIFIER NULL,
    [DateTimeStamp]  SMALLDATETIME    NULL,
    [LastModifiedBy] NVARCHAR (255)   NULL,
    [EventTypeID]    INT              NULL,
    [LocationID]     INT              NULL,
    [StatusTypeID]   INT              NULL,
    [DateStart]      DATETIME         NULL,
    [DateEnd]        DATETIME         NULL,
    [Name]           NVARCHAR (255)   NULL,
    [Description]    NVARCHAR (MAX)   NULL,
    [Notes]          NVARCHAR (MAX)   NULL,
    [ProgramID]      INT              NULL,
    [AuditAction]    NVARCHAR (10)    NULL,
    [AuditDateTime]  SMALLDATETIME    CONSTRAINT [DF_Events_Audit_AuditDateTime] DEFAULT (getdate()) NULL,
    [AuditUser]      NVARCHAR (250)   NULL,
    [AuditSQLUser]   NVARCHAR (250)   NULL,
    CONSTRAINT [PK_Events_Audit_1] PRIMARY KEY CLUSTERED ([AuditID] ASC)
);

