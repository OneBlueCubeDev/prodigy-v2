CREATE TABLE [dbo].[PersonsToEthnicities] (
    [PersonID]    INT NOT NULL,
    [EthnicityID] INT NOT NULL,
    CONSTRAINT [PK_PersonsToEthnicities] PRIMARY KEY CLUSTERED ([PersonID] ASC, [EthnicityID] ASC),
    CONSTRAINT [FK_PersonsToEthnicities_Ethnicities] FOREIGN KEY ([EthnicityID]) REFERENCES [dbo].[Ethnicities] ([EthnicityID]),
    CONSTRAINT [FK_PersonsToEthnicities_Persons] FOREIGN KEY ([PersonID]) REFERENCES [dbo].[Persons] ([PersonID]) ON DELETE CASCADE ON UPDATE CASCADE
);

