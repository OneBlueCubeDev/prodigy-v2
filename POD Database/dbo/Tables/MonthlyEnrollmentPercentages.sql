CREATE TABLE [dbo].[MonthlyEnrollmentPercentages] (
    [MonthID]              INT        NOT NULL,
    [EnrollmentPercentage] FLOAT (53) NOT NULL,
    CONSTRAINT [PK_MonthlyEnrollmentPercentages] PRIMARY KEY CLUSTERED ([MonthID] ASC)
);

