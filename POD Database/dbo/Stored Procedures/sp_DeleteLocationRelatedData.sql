
-- =============================================
-- Author:		Jessica Chong
-- Create date: 6/4/2012
-- Description:deletes location related data
--				
-- =============================================
CREATE PROCEDURE [dbo].[sp_DeleteLocationRelatedData]
	@locID int =null
		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	      
Update Classes
set SpecificLocationID = null
where SpecificLocationID = @locID
;

Update Classes
set SiteLocationID = null
where SiteLocationID = @locID
;

delete Events
where SiteLocationID = @locID

update Classes
set LessonPlanID = null
where LessonPlanID in (select LessonPlanID from LessonPlans where SiteLocationID = @locID OR SpecificLocationID = @locID)
;
	
Delete from LessonPlans
where SiteLocationID = @locID OR SpecificLocationID = @locID
;

Update Persons
set LocationID = NULL
where LocationID = @locID 
;

delete from [dbo].[LocationsToPhoneNumbers]
where LocationID = @locID 
;

Update RiskAssessments
set SiteLocationID = NULL
where SiteLocationID = @locID 
;

Update Enrollments
set SiteLocationID = NULL
where SiteLocationID = @locID 
;

END