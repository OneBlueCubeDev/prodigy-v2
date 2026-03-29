CREATE TABLE [dbo].[Persons] (
    [PersonID]              INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]               UNIQUEIDENTIFIER CONSTRAINT [DF_Persons_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp]         SMALLDATETIME    CONSTRAINT [DF_Persons_DateTimeStamp] DEFAULT (getdate()) NULL,
    [LastModifiedBy]        NVARCHAR (255)   CONSTRAINT [DF_Persons_LastModifiedBy] DEFAULT ('SQL Server Management Studio') NULL,
    [PersonTypeID]          INT              NOT NULL,
    [CommunityID]           INT              NULL,
    [LocationID]            INT              NULL,
    [CountyID]              INT              NULL,
    [StatusTypeID]          INT              NOT NULL,
    [DJJIDNum]              NVARCHAR (50)    NULL,
    [FirstName]             NVARCHAR (100)   NULL,
    [LastName]              NVARCHAR (100)   NULL,
    [MiddleName]            NVARCHAR (100)   NULL,
    [Email]                 NVARCHAR (255)   NULL,
    [Title]                 NVARCHAR (100)   NULL,
    [CompanyName]           NVARCHAR (100)   NULL,
    [Salutation]            NVARCHAR (50)    NULL,
    [Honorific]             NVARCHAR (50)    NULL,
    [GenderID]              INT              NULL,
    [SocialSecurityNumber]  NVARCHAR (9)     NULL,
    [DateOfBirth]           DATE             NULL,
    [PrimaryLanguageSpoken] NVARCHAR (50)    NULL,
    [OtherLanguagesSpoken]  NVARCHAR (255)   NULL,
    [Notes]                 NVARCHAR (MAX)   NULL,
    [CapTrackID]            INT              NULL,
    CONSTRAINT [PK_Persons] PRIMARY KEY CLUSTERED ([PersonID] ASC),
    CONSTRAINT [FK_Persons_Communities] FOREIGN KEY ([CommunityID]) REFERENCES [dbo].[Communities] ([CommunityID]),
    CONSTRAINT [FK_Persons_Counties] FOREIGN KEY ([CountyID]) REFERENCES [dbo].[Counties] ([CountyID]),
    CONSTRAINT [FK_Persons_Genders] FOREIGN KEY ([GenderID]) REFERENCES [dbo].[Genders] ([GenderID]) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT [FK_Persons_Locations] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Locations] ([LocationID]),
    CONSTRAINT [FK_Persons_PersonTypes] FOREIGN KEY ([PersonTypeID]) REFERENCES [dbo].[PersonTypes] ([PersonTypeID]),
    CONSTRAINT [FK_Persons_StatusTypes] FOREIGN KEY ([StatusTypeID]) REFERENCES [dbo].[StatusTypes] ([StatusTypeID]) ON UPDATE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_Persons]
    ON [dbo].[Persons]([PersonTypeID] ASC);


GO
CREATE TRIGGER [dbo].[tr_Persons]
   ON [dbo].[Persons]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	DECLARE @Type nvarchar(10)
	IF EXISTS (SELECT * FROM Inserted)
		IF EXISTS (SELECT * FROM Deleted)
			SELECT @Type = 'Update'
		ELSE
			SELECT @Type = 'Insert'
		ELSE
			SELECT @Type = 'Delete' 

	IF @Type='Delete'
		INSERT INTO [POD].[dbo].[Persons_Audit]
			   ([PersonID]
			   ,[rowguid]
			   ,[DateTimeStamp]
			   ,[LastModifiedBy]
			   ,[PersonTypeID]
			   ,[CommunityID]
			   ,[LocationID]
			   ,[CountyID]
			   ,[StatusTypeID]
			   ,[DJJIDNum]
			   ,[FirstName]
			   ,[LastName]
			   ,[MiddleName]
			   ,[Email]
			   ,[Title]
			   ,[CompanyName]
			   ,[Salutation]
			   ,[Honorific]
			   ,[GenderID]
			   ,[SocialSecurityNumber]
			   ,[DateOfBirth]
			   ,[PrimaryLanguageSpoken]
			   ,[OtherLanguagesSpoken]
			   ,[Notes]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   PersonID, 
			   rowguid,
			   DateTimeStamp, 
			   LastModifiedBy, 
			   PersonTypeID, 
			   CommunityID,
			   LocationID, 
			   CountyID, 
			   StatusTypeID,
			   DJJIDNum, 
			   FirstName, 
			   LastName, 
			   MiddleName, 
			   Email, 
			   Title, 
			   CompanyName, 
			   Salutation, 
			   Honorific, 
			   GenderID, 
			   SocialSecurityNumber, 
			   DateOfBirth, 
			   PrimaryLanguageSpoken, 
			   OtherLanguagesSpoken,
			   Notes, 
			   @Type, 
			   getdate(), 
			   LastModifiedBy, 
			   SUSER_SNAME()
		FROM Deleted
	ELSE
		INSERT INTO [POD].[dbo].[Persons_Audit]
			   ([PersonID]
			   ,[rowguid]
			   ,[DateTimeStamp]
			   ,[LastModifiedBy]
			   ,[PersonTypeID]
			   ,[CommunityID]
			   ,[LocationID]
			   ,[CountyID]
			   ,[StatusTypeID]
			   ,[DJJIDNum]
			   ,[FirstName]
			   ,[LastName]
			   ,[MiddleName]
			   ,[Email]
			   ,[Title]
			   ,[CompanyName]
			   ,[Salutation]
			   ,[Honorific]
			   ,[GenderID]
			   ,[SocialSecurityNumber]
			   ,[DateOfBirth]
			   ,[PrimaryLanguageSpoken]
			   ,[OtherLanguagesSpoken]
			   ,[Notes]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   PersonID, 
			   rowguid,
			   DateTimeStamp, 
			   LastModifiedBy, 
			   PersonTypeID, 
			   CommunityID, 
			   LocationID,
			   CountyID, 
			   StatusTypeID,
			   DJJIDNum, 
			   FirstName, 
			   LastName, 
			   MiddleName, 
			   Email, 
			   Title, 
			   CompanyName, 
			   Salutation, 
			   Honorific, 
			   GenderID, 
			   SocialSecurityNumber, 
			   DateOfBirth, 
			   PrimaryLanguageSpoken, 
			   OtherLanguagesSpoken,
			   Notes, 
			   @Type, 
			   getdate(), 
			   LastModifiedBy, 
			   SUSER_SNAME()
		FROM Inserted

END