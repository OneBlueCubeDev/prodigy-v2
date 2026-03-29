CREATE TABLE [dbo].[LifeSkillTypes] (
    [LifeSkillTypeID] INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]         UNIQUEIDENTIFIER CONSTRAINT [DF_LifeSkillTypes_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp]   SMALLDATETIME    CONSTRAINT [DF_LifeSkillTypes_DateTimeStamp] DEFAULT (getdate()) NULL,
    [Name]            NVARCHAR (100)   NOT NULL,
    [Description]     NVARCHAR (MAX)   NULL,
    [IsActive]        BIT              CONSTRAINT [DF_LifeSkillTypes_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_LifeSkillTypes] PRIMARY KEY CLUSTERED ([LifeSkillTypeID] ASC)
);

