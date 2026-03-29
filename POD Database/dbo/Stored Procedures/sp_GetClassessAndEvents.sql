-- =============================================
-- Author:		Jessica Chong
-- Create date: 6/4/2012
-- Description:	retrieves Person Attendance and Event Information
--				based on search criteria
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetClassessAndEvents]
	@name varchar(250) =null,
	@siteID int =null,
	@locID int =null,
	@classID int =null,
	@eventID int =null,
	@startDate datetime = null,
	@endDate datetime = null,
	@ProgramID int
		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT 

[ClassID]  as RecordID
		
       ,[ClassName]
      , 'Class' as RecordType
      ,[DateStart]
      ,[LocationName]
      ,[SpecificLocationID] as LocationID
      ,[SiteLocationName]
      ,[SiteLocationID]
    ,InstructorFullName
    ,AssistantFullName
    ,PeopleAssignedToClass
    ,(Select count(classid) from dbo.ClassAttendances  where [vw_Classes].Classid = dbo.ClassAttendances.ClassID) As AttendanceCount
  FROM [POD].[dbo].[vw_Classes]  
   
 WHERE ProgramID = @ProgramID  
		 AND (@name IS NULL OR className like '%' +@name +'%')
		 AND  (@classID IS NULL OR ClassID = @classID)
		   AND (@eventID IS NULL OR ClassID = -1)
         AND  (@siteID IS NULL OR SiteLocationID = @siteID)
         AND  (@locID IS NULL OR SpecificLocationID = @locID)
         AND  (@startDate is null OR DateStart > @startDate)
         AND  (@endDate IS null OR DateStart < @endDate)     
			
  UNION ALL
  
   SELECT 
     [EventID] as RecordID
       ,[EventName]
       ,'Event' as RecordType
      ,[DateStart]
      ,[LocationName]
      ,[LocationID]
      ,[SiteLocationName]
      ,[SiteLocationID]
  ,''
  ,''
  ,0
  ,(Select count(eventid) from dbo.EventAttendances  where e.[EventID] = dbo.EventAttendances.[EventID]) As AttendanceCount
  FROM [POD].[dbo].[vw_Events] e
  
  WHERE   ProgramID = @ProgramID  
   AND (@name IS NULL OR eventname like '%' +@name +'%')
    AND (@eventID IS NULL OR e.EventID = @eventID)
		  AND (@classID IS NULL OR e.EventID = -1)
          AND  (@siteID IS NULL OR e.SiteLocationID = @siteID)
          AND  (@locID IS NULL OR e.LocationID = @locID)
          AND(@startDate IS NULL OR DateStart > @startDate)
          AND(@endDate IS NULL OR DateStart < @endDate)
END