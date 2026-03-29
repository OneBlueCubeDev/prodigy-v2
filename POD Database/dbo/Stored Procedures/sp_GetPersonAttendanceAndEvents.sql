-- =============================================
-- Author:		Jessica Chong
-- Create date: 6/4/2012
-- Description:	retrieves Person Attendance and Event Information
--				based on search criteria
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetPersonAttendanceAndEvents]
	@name varchar(250) =null,
	@attendee varchar(250) =null,
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
[ClassAttendanceID]  as RecordID
		,[Tardy]
		 ,[LeftEarly]
       ,[ClassID]
       ,[ClassName]
      , 'Class' as RecordType
      ,[DateStart]
	  ,[AttendanceDate]
      ,[LocationName]
      ,[LocationID]
            ,[LastName]
      ,[FirstName]
      ,[MiddleName]
       ,[PersonID]
      ,[SiteLocationName]
      ,[SiteLocationID]
      ,[PersonTypeName]
  FROM [POD].[dbo].[vw_PersonClassAttendance] 
  
 WHERE ProgramID = @ProgramID  
		 AND (@name IS NULL OR className like '%' +@name +'%')
		 AND  (@attendee is null OR firstName Like '%' + @attendee+ '%' OR MiddleName Like '%' + @attendee+ '%' OR LastName Like '%' + @attendee+ '%')
		 AND  (@classID IS NULL OR ClassID = @classID)
         AND  (@siteID IS NULL OR SiteLocationID = SiteLocationID)
         AND  (@locID IS NULL OR LocationID = LocationID)
         AND  (@startDate is null OR DateStart > @startDate)
         AND  (@endDate IS null OR DateStart < @endDate)     
   
  UNION ALL
  SELECT 
     [EventAttendanceID] as RecordID
      ,NULL
      ,NULL
     
      ,[EventID]
      ,[EventName]
       ,'Event' as RecordType
      ,[DateStart]
	  ,[AttendanceDate]
      ,[LocationName]
      ,[LocationID]
      ,[LastName]
      ,[FirstName]
      ,[MiddleName]
      ,[PersonID]
      ,[SiteLocationName]
      ,[SiteLocationID]
        ,[PersonTypeName]
  FROM [POD].[dbo].[vw_PersonEvents] e
  
  WHERE   ProgramID = @ProgramID  
   AND (@name IS NULL OR eventname like '%' +@name +'%')
		  AND   (@attendee is null OR e.firstName Like '%' + @attendee+ '%' OR e.MiddleName Like '%' + @attendee+ '%' OR e.LastName Like '%' + @attendee+ '%')
		  AND (@eventID IS NULL OR e.EventID = @eventID)
          AND  (@siteID IS NULL OR e.SiteLocationID = SiteLocationID)
          AND  (@locID IS NULL OR e.LocationID = LocationID)
          AND(@startDate IS NULL OR DateStart > @startDate)
          AND(@endDate IS NULL OR DateStart < @endDate)
END