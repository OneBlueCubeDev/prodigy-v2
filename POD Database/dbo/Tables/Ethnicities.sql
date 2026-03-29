CREATE TABLE [dbo].[Ethnicities] (
    [EthnicityID]   INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]       UNIQUEIDENTIFIER CONSTRAINT [DF_Ethnicities_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp] SMALLDATETIME    CONSTRAINT [DF_Ethnicities_DateTimeStamp] DEFAULT (getdate()) NULL,
    [Name]          NVARCHAR (50)    NOT NULL,
    CONSTRAINT [PK_Ethnicities] PRIMARY KEY CLUSTERED ([EthnicityID] ASC)
);

