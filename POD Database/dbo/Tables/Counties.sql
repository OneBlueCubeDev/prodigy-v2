CREATE TABLE [dbo].[Counties] (
    [CountyID]      INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]       UNIQUEIDENTIFIER CONSTRAINT [DF_Counties_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp] SMALLDATETIME    CONSTRAINT [DF_Counties_DateTimeStamp] DEFAULT (getdate()) NULL,
    [CircuitID]     INT              NOT NULL,
    [Name]          NVARCHAR (50)    NOT NULL,
    CONSTRAINT [PK_Counties] PRIMARY KEY CLUSTERED ([CountyID] ASC),
    CONSTRAINT [FK_Counties_Circuits] FOREIGN KEY ([CircuitID]) REFERENCES [dbo].[Circuits] ([CircuitID])
);

