CREATE TABLE [dbo].[StaffMembers] (
    [PersonID] INT              NOT NULL,
    [isAdmin]  BIT              CONSTRAINT [DF_StaffMembers_isAdmin] DEFAULT ((0)) NULL,
    [isActive] BIT              CONSTRAINT [DF_StaffMembers_isActive] DEFAULT ((1)) NOT NULL,
    [UserID]   UNIQUEIDENTIFIER NULL,
    [HireDate] DATETIME         NULL,
    [EndDate]  DATETIME         NULL,
    CONSTRAINT [PK_StaffMembers] PRIMARY KEY CLUSTERED ([PersonID] ASC),
    CONSTRAINT [FK_StaffMembers_aspnet_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[aspnet_Users] ([UserId]) ON DELETE SET NULL ON UPDATE SET NULL,
    CONSTRAINT [FK_StaffMembers_Persons] FOREIGN KEY ([PersonID]) REFERENCES [dbo].[Persons] ([PersonID])
);


GO
CREATE TRIGGER [dbo].[tr_StaffMembers]
   ON  [dbo].[StaffMembers]
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
		INSERT INTO [POD].[dbo].[StaffMembers_Audit]
			   ([PersonID]
			   ,[HireDate]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   PersonID,
			   HireDate, 
			   @Type, 
			   getdate(), 
			   (Select TOP 1 LastModifiedBy From Persons Where PersonID=PersonID), 
			   SUSER_SNAME()
		FROM Deleted
	ELSE
		INSERT INTO [POD].[dbo].[StaffMembers_Audit]
			   ([PersonID]
			   ,[HireDate]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   PersonID, 
			   HireDate,
			   @Type, 
			   getdate(), 
			   (Select TOP 1 LastModifiedBy From Persons Where PersonID=PersonID), 
			   SUSER_SNAME()
		FROM Inserted

END