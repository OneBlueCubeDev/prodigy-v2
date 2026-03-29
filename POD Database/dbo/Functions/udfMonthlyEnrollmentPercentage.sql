
CREATE FUNCTION dbo.udfMonthlyEnrollmentPercentage
(
	@Month INT
)
RETURNS FLOAT
WITH 

 EXECUTE AS CALLER
AS
-- place the body of the function here
BEGIN
	DECLARE @Percentage FLOAT
	
	SELECT @Percentage = ISNULL(mep.EnrollmentPercentage, 0)
	FROM   MonthlyEnrollmentPercentages mep
	WHERE  mep.MonthID = @Month
	
	RETURN @Percentage
END