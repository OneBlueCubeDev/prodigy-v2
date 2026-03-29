CREATE TABLE [dbo].[ContractsToSites] (
    [ContractID]     INT NOT NULL,
    [SiteLocationID] INT NOT NULL,
    CONSTRAINT [PK_ContractsToSites] PRIMARY KEY CLUSTERED ([ContractID] ASC, [SiteLocationID] ASC),
    CONSTRAINT [FK_ContractsToSites_Contracts] FOREIGN KEY ([ContractID]) REFERENCES [dbo].[Contracts] ([ContractID]),
    CONSTRAINT [FK_ContractsToSites_Sites] FOREIGN KEY ([SiteLocationID]) REFERENCES [dbo].[Sites] ([LocationID])
);

