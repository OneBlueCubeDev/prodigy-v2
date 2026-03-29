CREATE TABLE [dbo].[ContractEnrollmentQuotas] (
    [ContractID]               INT NOT NULL,
    [EnrollmentTypeID]         INT NOT NULL,
    [Amount]                   INT NOT NULL,
    [ExpectedLengthInDays]     INT NOT NULL,
    [RequiredProgrammingHours] INT NOT NULL,
    CONSTRAINT [PK_ContractEnrollmentQuotas] PRIMARY KEY CLUSTERED ([ContractID] ASC, [EnrollmentTypeID] ASC),
    CONSTRAINT [FK_ContractEnrollmentQuotas_Contracts] FOREIGN KEY ([ContractID]) REFERENCES [dbo].[Contracts] ([ContractID]),
    CONSTRAINT [FK_ContractEnrollmentQuotas_EnrollmentTypes] FOREIGN KEY ([EnrollmentTypeID]) REFERENCES [dbo].[EnrollmentTypes] ([EnrollmentTypeID])
);

