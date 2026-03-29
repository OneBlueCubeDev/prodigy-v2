CREATE TABLE [dbo].[PersonRelationshipTypes] (
    [PersonRelationshipTypeID] INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]                  UNIQUEIDENTIFIER CONSTRAINT [DF_PersonRelationshipTypes_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp]            SMALLDATETIME    CONSTRAINT [DF_PersonRelationshipTypes_DateTimeStamp] DEFAULT (getdate()) NULL,
    [Name]                     NVARCHAR (100)   NOT NULL,
    [Description]              NVARCHAR (MAX)   NULL,
    [IsActive]                 BIT              CONSTRAINT [DF_PersonRelationshipTypes_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_RelationshipTypes] PRIMARY KEY CLUSTERED ([PersonRelationshipTypeID] ASC)
);

