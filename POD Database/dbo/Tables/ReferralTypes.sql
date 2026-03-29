CREATE TABLE [dbo].[ReferralTypes] (
    [ReferralTypeID] INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]        UNIQUEIDENTIFIER CONSTRAINT [DF_ReferralTypes_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp]  SMALLDATETIME    CONSTRAINT [DF_ReferralTypes_DateTimeStamp] DEFAULT (getdate()) NULL,
    [Name]           NVARCHAR (100)   NOT NULL,
    [Description]    NVARCHAR (MAX)   NULL,
    [IsActive]       BIT              CONSTRAINT [DF_ReferralTypes_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_ReferralTypes] PRIMARY KEY CLUSTERED ([ReferralTypeID] ASC)
);

