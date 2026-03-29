CREATE TABLE [dbo].[Circuits] (
    [CircuitID]     INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]       UNIQUEIDENTIFIER CONSTRAINT [DF_Circuits_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp] SMALLDATETIME    CONSTRAINT [DF_Circuits_DateTimeStamp] DEFAULT (getdate()) NULL,
    [Name]          NVARCHAR (50)    NOT NULL,
    CONSTRAINT [PK_Circuits] PRIMARY KEY CLUSTERED ([CircuitID] ASC)
);

