CREATE TABLE [dbo].[LocationsToPhoneNumbers] (
    [LocationID]    INT NOT NULL,
    [PhoneNumberID] INT NOT NULL,
    CONSTRAINT [PK_LocationsToPhoneNumbers] PRIMARY KEY CLUSTERED ([LocationID] ASC, [PhoneNumberID] ASC),
    CONSTRAINT [FK_LocationsToPhoneNumbers_Locations] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Locations] ([LocationID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_LocationsToPhoneNumbers_PhoneNumbers] FOREIGN KEY ([PhoneNumberID]) REFERENCES [dbo].[PhoneNumbers] ([PhoneNumberID]) ON DELETE CASCADE ON UPDATE CASCADE
);

