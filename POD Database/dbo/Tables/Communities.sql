CREATE TABLE [dbo].[Communities] (
    [CommunityID]   INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]       UNIQUEIDENTIFIER CONSTRAINT [DF_Communities_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp] SMALLDATETIME    CONSTRAINT [DF_Communities_DateTimeStamp] DEFAULT (getdate()) NULL,
    [Name]          NVARCHAR (50)    NOT NULL,
    [Description]   NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_Communities] PRIMARY KEY CLUSTERED ([CommunityID] ASC)
);

