CREATE TABLE [dbo].[Races] (
    [RaceID]        INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]       UNIQUEIDENTIFIER CONSTRAINT [DF_Races_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp] SMALLDATETIME    CONSTRAINT [DF_Races_DateTimeStamp] DEFAULT (getdate()) NULL,
    [Name]          NVARCHAR (50)    NOT NULL,
    CONSTRAINT [PK_Races] PRIMARY KEY CLUSTERED ([RaceID] ASC)
);

