CREATE TABLE [dbo].[Addresses_Audit] (
    [AuditID]        INT              IDENTITY (1, 1) NOT NULL,
    [AddressID]      INT              NULL,
    [rowguid]        UNIQUEIDENTIFIER NULL,
    [DateTimeStamp]  SMALLDATETIME    NULL,
    [LastModifiedBy] NVARCHAR (255)   NULL,
    [AddressTypeID]  INT              NULL,
    [StatusTypeID]   INT              NULL,
    [AddressLine1]   NVARCHAR (500)   NULL,
    [AddressLine2]   NVARCHAR (500)   NULL,
    [AptNum]         NVARCHAR (50)    NULL,
    [City]           NVARCHAR (100)   NULL,
    [State]          NVARCHAR (4)     NULL,
    [Zip]            NVARCHAR (10)    NULL,
    [CountyID]       INT              NULL,
    [AuditAction]    NVARCHAR (10)    NULL,
    [AuditDateTime]  SMALLDATETIME    CONSTRAINT [DF_Addresses_Audit_AuditDateTime] DEFAULT (getdate()) NULL,
    [AuditUser]      NVARCHAR (250)   NULL,
    [AuditSQLUser]   NVARCHAR (250)   NULL,
    CONSTRAINT [PK_Addresses_Audit_1] PRIMARY KEY CLUSTERED ([AuditID] ASC)
);

