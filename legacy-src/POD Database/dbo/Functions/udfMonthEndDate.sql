
CREATE FUNCTION [dbo].[udfMonthEndDate] 
(
	@targetDate DATETIME
)
RETURNS DATETIME
AS
BEGIN
	RETURN dbo.udfMaximumDate(DATEADD(MONTH, 1, @targetDate - DAY(@targetDate) + 1) - 1)
END