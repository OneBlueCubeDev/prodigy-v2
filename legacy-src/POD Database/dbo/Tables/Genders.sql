CREATE TABLE [dbo].[Genders] (
    [GenderID]      INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]       UNIQUEIDENTIFIER CONSTRAINT [DF_Genders_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp] SMALLDATETIME    CONSTRAINT [DF_Genders_DateTimeStamp] DEFAULT (getdate()) NULL,
    [Name]          NVARCHAR (50)    NOT NULL,
    CONSTRAINT [PK_Genders] PRIMARY KEY CLUSTERED ([GenderID] ASC)
);

