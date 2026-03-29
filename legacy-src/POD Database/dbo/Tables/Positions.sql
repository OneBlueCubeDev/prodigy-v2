CREATE TABLE [dbo].[Positions] (
    [PositionID]     INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]        UNIQUEIDENTIFIER CONSTRAINT [DF_Positions_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [DateTimeStamp]  SMALLDATETIME    CONSTRAINT [DF_Positions_DateTimeStamp] DEFAULT (getdate()) NOT NULL,
    [LastModifiedBy] NVARCHAR (255)   NULL,
    [IsOpen]         BIT              NOT NULL,
    [LocationID]     INT              NULL,
    [ProgramID]      INT              NOT NULL,
    [PersonID]       INT              NULL,
    [JobTitle]       NVARCHAR (255)   NOT NULL,
    [VacancyDate]    DATETIME         NULL,
    CONSTRAINT [PK_Positions] PRIMARY KEY CLUSTERED ([PositionID] ASC),
    CONSTRAINT [FK_Positions_Locations] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Locations] ([LocationID]),
    CONSTRAINT [FK_Positions_Programs] FOREIGN KEY ([ProgramID]) REFERENCES [dbo].[Programs] ([ProgramID]),
    CONSTRAINT [FK_Positions_StaffMembers] FOREIGN KEY ([PersonID]) REFERENCES [dbo].[StaffMembers] ([PersonID])
);

