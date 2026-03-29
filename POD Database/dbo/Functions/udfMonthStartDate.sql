
CREATE FUNCTION [dbo].[udfMonthStartDate] 
(
	@targetDate DATETIME
)
RETURNS DATETIME
AS
BEGIN
	RETURN dbo.udfMinimumDate(DATEADD(DAY, 1, @targetDate - DAY(@targetDate) + 1) - 1)
END