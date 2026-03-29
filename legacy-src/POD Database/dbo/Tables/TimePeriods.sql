CREATE TABLE [dbo].[TimePeriods] (
    [TimePeriodID]     INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]          UNIQUEIDENTIFIER CONSTRAINT [DF_TimePeriods_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp]    SMALLDATETIME    CONSTRAINT [DF_TimePeriods_DateTimeStamp] DEFAULT (getdate()) NULL,
    [TimePeriodTypeID] INT              NOT NULL,
    [StartDate]        DATE             NULL,
    [EndDate]          DATE             NULL,
    CONSTRAINT [PK_TimePeriods] PRIMARY KEY CLUSTERED ([TimePeriodID] ASC),
    CONSTRAINT [FK_TimePeriods_TimePeriodTypes] FOREIGN KEY ([TimePeriodTypeID]) REFERENCES [dbo].[TimePeriodTypes] ([TimePeriodTypeID]) ON UPDATE CASCADE
);

