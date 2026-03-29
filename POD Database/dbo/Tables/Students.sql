CREATE TABLE [dbo].[Students] (
    [PersonID]                INT            NOT NULL,
    [SchoolAttending]         NVARCHAR (255) NULL,
    [SchoolAddressID]         INT            NULL,
    [GradeLevel]              NVARCHAR (25)  NULL,
    [PartOtherProgSchool]     BIT            NULL,
    [PartOtherProgNames]      NVARCHAR (MAX) NULL,
    [MedicalConditions]       NVARCHAR (MAX) NULL,
    [Medications]             NVARCHAR (MAX) NULL,
    [MedicalSpecialNeeds]     NVARCHAR (MAX) NULL,
    [InsuranceCompany]        NVARCHAR (255) NULL,
    [InsurancePolicyNum]      NVARCHAR (50)  NULL,
    [RideBusAlone]            BIT            NOT NULL,
    [SignInOut]               BIT            NOT NULL,
    [WalkHomeAlone]           BIT            NOT NULL,
    [RideBikeHomeAlone]       BIT            NOT NULL,
    [SignedInOutGuardOnly]    BIT            NOT NULL,
    [ReleaseOther]            BIT            NOT NULL,
    [ReleaseOtherText]        NVARCHAR (MAX) NULL,
    [CaseMgrStaffPersonID]    INT            NULL,
    [SignatureRelease]        BIT            NULL,
    [SignatureReleaseDate]    DATETIME       NULL,
    [SignatureMedical]        BIT            NULL,
    [SignatureMedicalDate]    DATETIME       NULL,
    [SignatureProdigy]        BIT            NULL,
    [SignatureProdigyDate]    DATETIME       NULL,
    [SignatureGrievance]      BIT            NULL,
    [SignatureGrievanceDate]  DATETIME       NULL,
    [InsurancePolicyGroupNum] NVARCHAR (50)  NULL,
    CONSTRAINT [PK_Students] PRIMARY KEY CLUSTERED ([PersonID] ASC),
    CONSTRAINT [FK_Students_Addresses] FOREIGN KEY ([SchoolAddressID]) REFERENCES [dbo].[Addresses] ([AddressID]),
    CONSTRAINT [FK_Students_Persons] FOREIGN KEY ([PersonID]) REFERENCES [dbo].[Persons] ([PersonID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_Students_StaffMembers] FOREIGN KEY ([CaseMgrStaffPersonID]) REFERENCES [dbo].[StaffMembers] ([PersonID])
);


GO
CREATE TRIGGER [dbo].[tr_Students]
   ON [dbo].[Students]
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
		INSERT INTO [POD].[dbo].[Students_Audit]
				   ([PersonID]
				   ,[SchoolAttending]
				   ,[GradeLevel]
				   ,[PartOtherProgSchool]
				   ,[PartOtherProgNames]
				   ,[MedicalConditions]
				   ,[Medications]
				   ,[MedicalSpecialNeeds]
				   ,[InsuranceCompany]
				   ,[InsurancePolicyNum]
				   ,[InsurancePolicyGroupNum]
				   ,[RideBusAlone]
				   ,[SignInOut]
				   ,[WalkHomeAlone]
				   ,[RideBikeHomeAlone]
				   ,[SignedInOutGuardOnly]
				   ,[ReleaseOther]
				   ,[ReleaseOtherText]
				   ,[CaseMgrStaffPersonID]
				   ,[AuditAction]
				   ,[AuditDateTime]
				   ,[AuditUser]
				   ,[AuditSQLUser])
			 SELECT
				   PersonID,  
				   SchoolAttending, 
				   GradeLevel, 
				   PartOtherProgSchool, 
				   PartOtherProgNames, 
				   MedicalConditions, 
				   Medications, 
				   MedicalSpecialNeeds, 
				   InsuranceCompany, 
				   InsurancePolicyNum,
				   InsurancePolicyGroupNum, 
				   RideBusAlone, 
				   SignInOut, 
				   WalkHomeAlone, 
				   RideBikeHomeAlone, 
				   SignedInOutGuardOnly, 
				   ReleaseOther, 
				   ReleaseOtherText, 
				   CaseMgrStaffPersonID, 
				   @Type, 
				   getdate(), 
				   (Select TOP 1 LastModifiedBy From Persons Where PersonID=PersonID), 
				   SUSER_SNAME()
			FROM Deleted
		ELSE
		INSERT INTO [POD].[dbo].[Students_Audit]
				   ([PersonID]
				   ,[SchoolAttending]
				   ,[GradeLevel]
				   ,[PartOtherProgSchool]
				   ,[PartOtherProgNames]
				   ,[MedicalConditions]
				   ,[Medications]
				   ,[MedicalSpecialNeeds]
				   ,[InsuranceCompany]
				   ,[InsurancePolicyNum]
				   ,[InsurancePolicyGroupNum]
				   ,[RideBusAlone]
				   ,[SignInOut]
				   ,[WalkHomeAlone]
				   ,[RideBikeHomeAlone]
				   ,[SignedInOutGuardOnly]
				   ,[ReleaseOther]
				   ,[ReleaseOtherText]
				   ,[CaseMgrStaffPersonID]
				   ,[AuditAction]
				   ,[AuditDateTime]
				   ,[AuditUser]
				   ,[AuditSQLUser])
			 SELECT
				   PersonID,   
				   SchoolAttending, 
				   GradeLevel, 
				   PartOtherProgSchool, 
				   PartOtherProgNames, 
				   MedicalConditions, 
				   Medications, 
				   MedicalSpecialNeeds, 
				   InsuranceCompany, 
				   InsurancePolicyNum, 
				   InsurancePolicyGroupNum,
				   RideBusAlone, 
				   SignInOut, 
				   WalkHomeAlone, 
				   RideBikeHomeAlone, 
				   SignedInOutGuardOnly, 
				   ReleaseOther, 
				   ReleaseOtherText, 
				   CaseMgrStaffPersonID, 
				   @Type, 
				   getdate(), 
				   (Select TOP 1 LastModifiedBy From Persons Where PersonID=PersonID), 
				   SUSER_SNAME()
			FROM Inserted

END