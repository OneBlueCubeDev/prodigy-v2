
CREATE FUNCTION dbo.udfEnrollmentTypeByName
(
	@name NVARCHAR(100)
)
RETURNS INT
AS
BEGIN
	DECLARE @enrollmentTypeId INT
	SELECT @enrollmentTypeId = et.EnrollmentTypeID FROM EnrollmentTypes et WHERE et.Name = @name
	RETURN @enrollmentTypeId
END