CREATE TABLE [dbo].[EventTypes] (
    [EventTypeID]   INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]       UNIQUEIDENTIFIER CONSTRAINT [DF_EventTypes_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp] SMALLDATETIME    CONSTRAINT [DF_EventTypes_DateTimeStamp] DEFAULT (getdate()) NULL,
    [Name]          NVARCHAR (100)   NOT NULL,
    [Description]   NVARCHAR (MAX)   NULL,
    [IsActive]      BIT              CONSTRAINT [DF_EventTypes_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_EventTypes] PRIMARY KEY CLUSTERED ([EventTypeID] ASC)
);

