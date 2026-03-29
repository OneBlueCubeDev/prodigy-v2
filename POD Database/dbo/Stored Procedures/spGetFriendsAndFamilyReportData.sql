

CREATE PROCEDURE [dbo].[spGetFriendsAndFamilyReportData]
	@programId INT,
	@siteLocationId INT,
	@startDate DATETIME,
	@endDate DATETIME
AS
	DECLARE @friendsAndFamilyTypeId INT
	SELECT @friendsAndFamilyTypeId = et.EventTypeID
	FROM   EventTypes et
	WHERE  et.Name = 'Friends and Family'
	
	SELECT e.EventID,
	       s.LocationID  AS [SiteLocationID],
	       s.SiteName,
	       s.Organization,
	       e.DateStart   AS [Date],
	       e.Name        AS [EventName],
	       COALESCE(e.EventLocation, el.Name) AS [EventLocation],
	       e.Category,
	       e.[Description],
	       e.YouthAttendanceCount,
	       e.StaffAttendanceCount,
	       e.FamilyAttendanceCount,
	       'Sign-in Sheet' AS [AttendanceVerifiedBy]
	FROM   Events e
	       INNER JOIN Sites s
	            ON  s.LocationID = e.SiteLocationID
	       INNER JOIN Locations sl
	            ON  sl.LocationID = s.LocationID
	       LEFT JOIN Locations el
	            ON  el.LocationID = e.LocationID
	WHERE  e.ProgramID = @programId
	       AND (
	               @startDate IS NULL
	               OR e.DateStart >= dbo.udfMinimumDate(@startDate)
	           )
	       AND (
	               @endDate IS NULL
	               OR e.DateEnd <= dbo.udfMaximumDate(@endDate)
	           )
	       AND (
	               @siteLocationId IS NULL
	               OR e.SiteLocationID = @siteLocationId
	           )
	       AND e.EventTypeID = @friendsAndFamilyTypeId
	ORDER BY e.DateStart