CREATE TABLE [dbo].[PhoneNumberTypes] (
    [PhoneNumberTypeID] INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]           UNIQUEIDENTIFIER CONSTRAINT [DF_PhoneNumberTypes_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp]     SMALLDATETIME    CONSTRAINT [DF_PhoneNumberTypes_DateTimeStamp] DEFAULT (getdate()) NULL,
    [Name]              NVARCHAR (100)   NOT NULL,
    [Description]       NVARCHAR (MAX)   NULL,
    [IsActive]          BIT              CONSTRAINT [DF_PhoneNumberTypes_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_PhoneTypes] PRIMARY KEY CLUSTERED ([PhoneNumberTypeID] ASC)
);

