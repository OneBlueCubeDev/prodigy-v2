
-- =============================================
-- Author:		Jessica Chong
-- Create date: 7/29/2013
-- Description:deletes riskassessment
--				
-- =============================================
CREATE PROCEDURE [dbo].[sp_DeleteEnrollment]
	@enrollmentID int
		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
	
delete from Enrollments
where EnrollmentID = @enrollmentID


END