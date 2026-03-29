CREATE TABLE [dbo].[DisciplineTypes] (
    [DisciplineTypeID] INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]          UNIQUEIDENTIFIER CONSTRAINT [DF_DisciplineTypes_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp]    SMALLDATETIME    CONSTRAINT [DF_DisciplineTypes_DateTimeStamp] DEFAULT (getdate()) NULL,
    [Name]             NVARCHAR (100)   NOT NULL,
    [Description]      NVARCHAR (MAX)   NULL,
    [IsActive]         BIT              CONSTRAINT [DF_DisciplineTypes_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_DisciplineTypes] PRIMARY KEY CLUSTERED ([DisciplineTypeID] ASC)
);

