CREATE TABLE [dbo].[PersonsToRaces] (
    [PersonID] INT NOT NULL,
    [RaceID]   INT NOT NULL,
    CONSTRAINT [PK_PersonsToRaces] PRIMARY KEY CLUSTERED ([PersonID] ASC, [RaceID] ASC),
    CONSTRAINT [FK_PersonsToRaces_Persons] FOREIGN KEY ([PersonID]) REFERENCES [dbo].[Persons] ([PersonID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_PersonsToRaces_Races] FOREIGN KEY ([RaceID]) REFERENCES [dbo].[Races] ([RaceID]) ON DELETE CASCADE ON UPDATE CASCADE
);

