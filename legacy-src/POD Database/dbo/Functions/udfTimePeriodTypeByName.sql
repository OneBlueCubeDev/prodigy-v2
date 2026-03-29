
CREATE FUNCTION dbo.udfTimePeriodTypeByName
(
	@name NVARCHAR(100)
)
RETURNS INT
AS
BEGIN
	-- Declare the return variable here
	DECLARE @timePeriodTypeId INT
	
	-- Add the T-SQL statements to compute the return value here
	SELECT @timePeriodTypeId = tpt.TimePeriodTypeID
	FROM   TimePeriodTypes tpt
	WHERE  tpt.Name = @name
	
	-- Return the result of the function
	RETURN @timePeriodTypeId
END