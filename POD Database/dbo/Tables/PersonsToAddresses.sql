CREATE TABLE [dbo].[PersonsToAddresses] (
    [PersonID]  INT NOT NULL,
    [AddressID] INT NOT NULL,
    CONSTRAINT [PK_PersonsToAddresses] PRIMARY KEY CLUSTERED ([PersonID] ASC, [AddressID] ASC),
    CONSTRAINT [FK_PersonsToAddresses_Addresses] FOREIGN KEY ([AddressID]) REFERENCES [dbo].[Addresses] ([AddressID]),
    CONSTRAINT [FK_PersonsToAddresses_Persons] FOREIGN KEY ([PersonID]) REFERENCES [dbo].[Persons] ([PersonID]) ON DELETE CASCADE ON UPDATE CASCADE
);

