CREATE TABLE [dbo].[aspnet_Paths] (
    [ApplicationId] UNIQUEIDENTIFIER NOT NULL,
    [PathId]        UNIQUEIDENTIFIER CONSTRAINT [DF__aspnet_Pa__PathI__628FA481] DEFAULT (newid()) NOT NULL,
    [Path]          NVARCHAR (256)   NOT NULL,
    [LoweredPath]   NVARCHAR (256)   NOT NULL,
    CONSTRAINT [PK__aspnet_P__CD67DC585FB337D6] PRIMARY KEY NONCLUSTERED ([PathId] ASC),
    CONSTRAINT [FK__aspnet_Pa__Appli__619B8048] FOREIGN KEY ([ApplicationId]) REFERENCES [dbo].[aspnet_Applications] ([ApplicationId])
);


GO
CREATE UNIQUE CLUSTERED INDEX [aspnet_Paths_index]
    ON [dbo].[aspnet_Paths]([ApplicationId] ASC, [LoweredPath] ASC);

