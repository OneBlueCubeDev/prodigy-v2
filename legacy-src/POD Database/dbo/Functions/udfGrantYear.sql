
CREATE FUNCTION [dbo].[udfGrantYear]
(
	@targetDate DATETIME
)
RETURNS @grantYear TABLE
        (StartDate DATETIME NOT NULL, EndDate DATETIME NOT NULL)
AS


BEGIN
	DECLARE @startDate DATETIME
	DECLARE @endDate DATETIME
	DECLARE @grantYearTypeId INT
	
	SET @startDate = CONVERT(DATETIME, CONVERT(VARCHAR, YEAR(@targetDate)) + '-07-01')
	SET @endDate = DATEADD(MILLISECOND, -3, DATEADD(YEAR, 1, @startDate))
	SET @grantYearTypeId = dbo.udfTimePeriodTypeByName('Grant Year')
	
	IF NOT @targetDate BETWEEN @startDate AND @endDate
	BEGIN
	    SET @startDate = DATEADD(YEAR, -1, @startDate)
	    SET @endDate = DATEADD(YEAR, -1, @endDate)
	END
	
	INSERT INTO @grantYear
	  (
	    StartDate,
	    EndDate
	  )
	SELECT TOP 1 dbo.udfMinimumDate(tp.StartDate),
	       dbo.udfMaximumDate(tp.EndDate)
	FROM   TimePeriods tp
	WHERE  tp.TimePeriodTypeID = @grantYearTypeId
	       AND @targetDate BETWEEN tp.StartDate AND tp.EndDate
	
	IF (
	       SELECT COUNT(1)
	       FROM   @grantYear
	   ) = 0
	    INSERT INTO @grantYear
	      (
	        StartDate,
	        EndDate
	      )
	    SELECT @startDate,
	           @endDate

	RETURN
END