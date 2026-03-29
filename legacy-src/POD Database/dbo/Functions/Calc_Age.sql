--DATEDIFF() Is not the best way to calculate age
--It will not produce reliable results
--This is the simplest and most reliable way I have found to calculate age
CREATE FUNCTION [dbo].Calc_Age (
 @in_DOB AS DATETIME,
 @now AS DATETIME = NULL)
RETURNS INT
AS
BEGIN
  DECLARE @age AS INT

  -- If no @now value was provided, we'll assume it is the current datetime
  IF @now IS NULL
    SET @now = GETDATE()

  -- First we assume that the birthday has already arrived this year
  SET @age = YEAR(@now) - YEAR(@in_DOB)

  -- If the birthday has not yet arrived this year we subtract 1
  IF (MONTH(@now) < MONTH(@in_DOB))
      OR (MONTH(@now) = MONTH(@in_DOB) AND DAY(@now) < DAY(@in_DOB))
    SET @age = @age - 1
  RETURN @age
END