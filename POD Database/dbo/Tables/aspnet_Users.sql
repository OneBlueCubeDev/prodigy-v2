CREATE TABLE [dbo].[aspnet_Users] (
    [ApplicationId]    UNIQUEIDENTIFIER NOT NULL,
    [UserId]           UNIQUEIDENTIFIER CONSTRAINT [DF__aspnet_Us__UserI__15502E78] DEFAULT (newid()) NOT NULL,
    [UserName]         NVARCHAR (256)   NOT NULL,
    [LoweredUserName]  NVARCHAR (256)   NOT NULL,
    [MobileAlias]      NVARCHAR (16)    CONSTRAINT [DF__aspnet_Us__Mobil__164452B1] DEFAULT (NULL) NULL,
    [IsAnonymous]      BIT              CONSTRAINT [DF__aspnet_Us__IsAno__173876EA] DEFAULT ((0)) NOT NULL,
    [LastActivityDate] DATETIME         NOT NULL,
    CONSTRAINT [PK__aspnet_U__1788CC4D1273C1CD] PRIMARY KEY NONCLUSTERED ([UserId] ASC),
    CONSTRAINT [FK__aspnet_Us__Appli__145C0A3F] FOREIGN KEY ([ApplicationId]) REFERENCES [dbo].[aspnet_Applications] ([ApplicationId])
);


GO
CREATE NONCLUSTERED INDEX [aspnet_Users_Index2]
    ON [dbo].[aspnet_Users]([ApplicationId] ASC, [LastActivityDate] ASC);


GO
CREATE UNIQUE CLUSTERED INDEX [aspnet_Users_Index]
    ON [dbo].[aspnet_Users]([ApplicationId] ASC, [LoweredUserName] ASC);

