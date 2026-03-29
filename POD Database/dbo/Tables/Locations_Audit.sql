CREATE TABLE [dbo].[Locations_Audit] (
    [AuditID]        INT              IDENTITY (1, 1) NOT NULL,
    [LocationID]     INT              NULL,
    [rowguid]        UNIQUEIDENTIFIER NULL,
    [DateTimeStamp]  SMALLDATETIME    NULL,
    [LastModifiedBy] NVARCHAR (255)   CONSTRAINT [DF_Locations_Audit_LastModifiedBy] DEFAULT ('SQL Server Management Studio') NULL,
    [LocationTypeID] INT              NULL,
    [AddressID]      INT              NULL,
    [StatusTypeID]   INT              NULL,
    [Name]           NVARCHAR (255)   NULL,
    [Notes]          NVARCHAR (MAX)   NULL,
    [SiteLocationID] INT              NULL,
    [AuditAction]    NVARCHAR (10)    NULL,
    [AuditDateTime]  SMALLDATETIME    CONSTRAINT [DF_Locations_Audit_AuditDateTime] DEFAULT (getdate()) NULL,
    [AuditUser]      NVARCHAR (250)   NULL,
    [AuditSQLUser]   NVARCHAR (250)   NULL,
    CONSTRAINT [PK_Locations_Audit_1] PRIMARY KEY CLUSTERED ([AuditID] ASC)
);

