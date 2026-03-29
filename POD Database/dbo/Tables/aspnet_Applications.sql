CREATE TABLE [dbo].[aspnet_Applications] (
    [ApplicationName]        NVARCHAR (256)   NOT NULL,
    [LoweredApplicationName] NVARCHAR (256)   NOT NULL,
    [ApplicationId]          UNIQUEIDENTIFIER CONSTRAINT [DF__aspnet_Ap__Appli__0F975522] DEFAULT (newid()) NOT NULL,
    [Description]            NVARCHAR (256)   NULL,
    CONSTRAINT [PK__aspnet_A__C93A4C9807F6335A] PRIMARY KEY NONCLUSTERED ([ApplicationId] ASC),
    CONSTRAINT [UQ__aspnet_A__17477DE40AD2A005] UNIQUE NONCLUSTERED ([LoweredApplicationName] ASC),
    CONSTRAINT [UQ__aspnet_A__309103310DAF0CB0] UNIQUE NONCLUSTERED ([ApplicationName] ASC)
);


GO
CREATE CLUSTERED INDEX [aspnet_Applications_Index]
    ON [dbo].[aspnet_Applications]([LoweredApplicationName] ASC);

