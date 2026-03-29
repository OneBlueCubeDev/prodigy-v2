CREATE TABLE [dbo].[PersonsToPhoneNumbers] (
    [PersonID]      INT NOT NULL,
    [PhoneNumberID] INT NOT NULL,
    CONSTRAINT [PK_PersonsToPhoneNumbers] PRIMARY KEY CLUSTERED ([PersonID] ASC, [PhoneNumberID] ASC),
    CONSTRAINT [FK_PersonsToPhoneNumbers_Persons] FOREIGN KEY ([PersonID]) REFERENCES [dbo].[Persons] ([PersonID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_PersonsToPhoneNumbers_PhoneNumbers] FOREIGN KEY ([PhoneNumberID]) REFERENCES [dbo].[PhoneNumbers] ([PhoneNumberID]) ON DELETE CASCADE ON UPDATE CASCADE
);

