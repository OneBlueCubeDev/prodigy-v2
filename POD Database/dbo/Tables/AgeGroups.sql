CREATE TABLE [dbo].[AgeGroups] (
    [AgeGroupID]    INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]       UNIQUEIDENTIFIER CONSTRAINT [DF_AgeGroups_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp] SMALLDATETIME    CONSTRAINT [DF_AgeGroups_DateTimeStamp] DEFAULT (getdate()) NULL,
    [Name]          NVARCHAR (50)    NULL,
    [AgeMinimum]    INT              NULL,
    [AgeMaximum]    INT              NULL,
    CONSTRAINT [PK_AgeGroups] PRIMARY KEY CLUSTERED ([AgeGroupID] ASC)
);

