CREATE TABLE [dbo].[PersonRelationships] (
    [PersonRelationshipID]     INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]                  UNIQUEIDENTIFIER CONSTRAINT [DF_PersonRelationships_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp]            SMALLDATETIME    CONSTRAINT [DF_PersonRelationships_DateTimeStamp] DEFAULT (getdate()) NULL,
    [PersonID]                 INT              NOT NULL,
    [RelatedPersonID]          INT              NOT NULL,
    [PersonRelationshipTypeID] INT              NOT NULL,
    [ListOrder]                SMALLINT         NULL,
    [IsActive]                 BIT              NOT NULL,
    [IsGuardian]               BIT              CONSTRAINT [DF_PersonRelationships_IsGuardian] DEFAULT ((0)) NOT NULL,
    [IsEmergencyContact]       BIT              CONSTRAINT [DF_PersonRelationships_IsEmergencyContact] DEFAULT ((0)) NOT NULL,
    [IsAuthPerson]             BIT              CONSTRAINT [DF_PersonRelationships_IsAuthPerson] DEFAULT ((0)) NOT NULL,
    [IsPhysician]              BIT              CONSTRAINT [DF_PersonRelationships_IsPhysician] DEFAULT ((0)) NOT NULL,
    [RelationShipOther]        NVARCHAR (150)   NULL,
    CONSTRAINT [PK_PersonRelationships] PRIMARY KEY CLUSTERED ([PersonRelationshipID] ASC),
    CONSTRAINT [FK_PersonRelationships_PersonRelationshipTypes1] FOREIGN KEY ([PersonRelationshipTypeID]) REFERENCES [dbo].[PersonRelationshipTypes] ([PersonRelationshipTypeID]),
    CONSTRAINT [FK_PersonRelationships_Persons] FOREIGN KEY ([RelatedPersonID]) REFERENCES [dbo].[Persons] ([PersonID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_PersonRelationships_Persons1] FOREIGN KEY ([PersonID]) REFERENCES [dbo].[Persons] ([PersonID])
);

