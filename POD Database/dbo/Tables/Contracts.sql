CREATE TABLE [dbo].[Contracts] (
    [ContractID]     INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]        UNIQUEIDENTIFIER CONSTRAINT [DF_Contracts_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [DateTimeStamp]  DATETIME         CONSTRAINT [DF_Contracts_DateTimeStamp] DEFAULT (getdate()) NOT NULL,
    [LastModifiedBy] NVARCHAR (255)   NULL,
    [StatusTypeID]   INT              NOT NULL,
    [ContractNumber] NVARCHAR (255)   NOT NULL,
    [DateStart]      DATETIME         NULL,
    [DateEnd]        DATETIME         NULL,
    CONSTRAINT [PK_Contracts] PRIMARY KEY CLUSTERED ([ContractID] ASC),
    CONSTRAINT [FK_Contracts_StatusTypes] FOREIGN KEY ([StatusTypeID]) REFERENCES [dbo].[StatusTypes] ([StatusTypeID])
);

