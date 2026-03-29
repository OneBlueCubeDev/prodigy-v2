CREATE TABLE [dbo].[Sites] (
    [LocationID]           INT            NOT NULL,
    [SiteName]             NVARCHAR (255) NULL,
    [Organization]         NVARCHAR (255) NULL,
    [AttendanceLockedDate] DATETIME       NULL,
    CONSTRAINT [PK_Sites] PRIMARY KEY CLUSTERED ([LocationID] ASC),
    CONSTRAINT [FK_Sites_Locations] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Locations] ([LocationID])
);


GO
CREATE TRIGGER [dbo].[tr_Sites]
   ON  [dbo].[Sites]
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
		INSERT INTO [POD].[dbo].[Sites_Audit]
			   ([LocationID]
			   ,[Organization]
			   ,[AttendanceLockedDate]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   LocationID,
			   Organization, 
			   AttendanceLockedDate,
			   @Type, 
			   getdate(), 
			   (SELECT TOP 1 l.LastModifiedBy FROM Locations l WHERE l.LocationID = LocationID), 
			   SUSER_SNAME()
		FROM Deleted
	ELSE
		INSERT INTO [POD].[dbo].[Sites_Audit]
			   ([LocationID]
			   ,[Organization]
			   ,[AttendanceLockedDate]
			   ,[AuditAction]
			   ,[AuditDateTime]
			   ,[AuditUser]
			   ,[AuditSQLUser])
		 SELECT
			   LocationID,
			   Organization, 
			   AttendanceLockedDate,
			   @Type, 
			   getdate(), 
			   (SELECT TOP 1 l.LastModifiedBy FROM Locations l WHERE l.LocationID = LocationID), 
			   SUSER_SNAME()
		FROM Inserted

END