CREATE TABLE [dbo].[TimePeriodTypes] (
    [TimePeriodTypeID] INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]          UNIQUEIDENTIFIER CONSTRAINT [DF_TimePeriodTypes_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp]    SMALLDATETIME    CONSTRAINT [DF_TimePeriodTypes_DateTimeStamp] DEFAULT (getdate()) NULL,
    [Name]             NVARCHAR (100)   NOT NULL,
    [Description]      NVARCHAR (MAX)   NULL,
    [IsActive]         BIT              CONSTRAINT [DF_TimePeriodTypes_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_TimePeriodTypes] PRIMARY KEY CLUSTERED ([TimePeriodTypeID] ASC)
);

