CREATE FUNCTION [dbo].[udfSplitString]
(
	@delimiter     VARCHAR(5),
	@text          VARCHAR(MAX)
)
RETURNS @tableOfValues TABLE 
        ([ID] SMALLINT IDENTITY(1, 1), [Value] VARCHAR(MAX))
AS
BEGIN
	DECLARE @length INT 
	
	WHILE LEN(@text) > 0
	BEGIN
	    SELECT @length = (
	               CASE CHARINDEX(@delimiter, @text)
	                    WHEN 0 THEN LEN(@text)
	                    ELSE (CHARINDEX(@delimiter, @text) -1)
	               END
	           ) 
	    
	    INSERT INTO @tableOfValues
	    SELECT SUBSTRING(@text, 1, @length)
	    
	    SELECT @text = (
	               CASE (LEN(@text) - @length)
	                    WHEN 0 THEN ''
	                    ELSE RIGHT(@text, LEN(@text) - @length - 1)
	               END
	           )
	END
	
	RETURN
END