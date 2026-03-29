
CREATE FUNCTION dbo.udfStatusTypeByName 
(
	@name NVARCHAR(100)
)
RETURNS INT
AS
BEGIN
	DECLARE @statusTypeId INT
	SELECT @statusTypeId = st.StatusTypeID FROM StatusTypes st WHERE st.Name = @name
	RETURN @statusTypeId
END