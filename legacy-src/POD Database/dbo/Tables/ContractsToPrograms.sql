CREATE TABLE [dbo].[ContractsToPrograms] (
    [ContractID] INT NOT NULL,
    [ProgramID]  INT NOT NULL,
    CONSTRAINT [PK_ContractsToPrograms] PRIMARY KEY CLUSTERED ([ContractID] ASC, [ProgramID] ASC),
    CONSTRAINT [FK_ContractsToPrograms_Contracts] FOREIGN KEY ([ContractID]) REFERENCES [dbo].[Contracts] ([ContractID]),
    CONSTRAINT [FK_ContractsToPrograms_Programs] FOREIGN KEY ([ProgramID]) REFERENCES [dbo].[Programs] ([ProgramID])
);

