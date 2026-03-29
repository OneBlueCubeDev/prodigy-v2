CREATE TABLE [dbo].[EventCategoryFields] (
    [EventCategoryFieldID] INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [DF_EventCategoryFields_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp]        SMALLDATETIME    CONSTRAINT [DF_EventCategoryFields_DateTimeStamp] DEFAULT (getdate()) NULL,
    [Name]                 NVARCHAR (150)   NOT NULL,
    [EventCategoryID]      INT              NOT NULL,
    [ValidationExpression] NVARCHAR (255)   NULL,
    [IsRequired]           BIT              CONSTRAINT [DF_EventCategoryFields_IsRequired] DEFAULT ((0)) NOT NULL,
    [IsActive]             BIT              CONSTRAINT [DF_EventCategoryFields_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_EventCategoryFields] PRIMARY KEY CLUSTERED ([EventCategoryFieldID] ASC),
    CONSTRAINT [FK_EventCategoryFields_EventCategories] FOREIGN KEY ([EventCategoryID]) REFERENCES [dbo].[EventCategories] ([EventCategoryID])
);

