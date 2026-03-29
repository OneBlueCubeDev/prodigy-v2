CREATE TABLE [dbo].[EventCategories] (
    [EventCategoryID]  INT              IDENTITY (1, 1) NOT NULL,
    [rowguid]          UNIQUEIDENTIFIER CONSTRAINT [DF_EventCategories_rowguid] DEFAULT (newid()) NULL,
    [DateTimeStamp]    SMALLDATETIME    CONSTRAINT [DF_EventCategories_DateTimeStamp] DEFAULT (getdate()) NULL,
    [Name]             NVARCHAR (150)   NOT NULL,
    [EventTypeID]      INT              NOT NULL,
    [ParentCategoryID] INT              NULL,
    [IsActive]         BIT              CONSTRAINT [DF_EventCategories_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_EventCategories] PRIMARY KEY CLUSTERED ([EventCategoryID] ASC),
    CONSTRAINT [FK_EventCategories_EventCategories] FOREIGN KEY ([ParentCategoryID]) REFERENCES [dbo].[EventCategories] ([EventCategoryID]),
    CONSTRAINT [FK_EventCategories_EventTypes] FOREIGN KEY ([EventTypeID]) REFERENCES [dbo].[EventTypes] ([EventTypeID])
);


GO
CREATE NONCLUSTERED INDEX [IX_EventCategories]
    ON [dbo].[EventCategories]([EventCategoryID] ASC);

