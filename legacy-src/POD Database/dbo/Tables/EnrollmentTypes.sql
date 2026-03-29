CREATE TABLE [dbo].[EnrollmentTypes] (
    [EnrollmentTypeID] INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]          UNIQUEIDENTIFIER CONSTRAINT [DF_EnrollmentTypes_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp]    SMALLDATETIME    CONSTRAINT [DF_EnrollmentTypes_DateTimeStamp] DEFAULT (getdate()) NULL,
    [Name]             NVARCHAR (100)   NOT NULL,
    [Description]      NVARCHAR (MAX)   NULL,
    [IsActive]         BIT              CONSTRAINT [DF_EnrollmentTypes_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_EnrollmentTypes] PRIMARY KEY CLUSTERED ([EnrollmentTypeID] ASC)
);

