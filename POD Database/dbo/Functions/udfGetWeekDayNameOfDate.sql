/************************************************************
 * Code formatted by SoftTree SQL Assistant © v6.3.153
 * Time: 11/14/2012 8:44:50 AM
 ************************************************************/

----------------------------------------
--- GetWeekDayNameOfDate
--- Returns Week Day Name in English
--- Takes @@DATEFIRST into consideration
--- You can edit udf for other languages
----------------------------------------
CREATE FUNCTION udfGetWeekDayNameOfDate
(
	@Date DATETIME
)
RETURNS NVARCHAR(50)

BEGIN
	DECLARE @DayName NVARCHAR(50)
	
	SELECT @DayName = CASE (DATEPART(dw, @Date) + @@DATEFIRST) % 7
	                       WHEN 1 THEN 'Sun'
	                       WHEN 2 THEN 'Mon'
	                       WHEN 3 THEN 'Tue'
	                       WHEN 4 THEN 'Wed'
	                       WHEN 5 THEN 'Thu'
	                       WHEN 6 THEN 'Fri'
	                       WHEN 0 THEN 'Sat'
	                  END
	
	RETURN @DayName
END