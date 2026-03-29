

CREATE PROCEDURE [dbo].[spGetMasterClassScheduleReportData]
	@startDate DATETIME = NULL, -- Start Date Filter
	@endDate DATETIME = NULL, -- End Date Filter
	@siteLocationId INT = NULL, -- Site Filter
	@classDays NVARCHAR(50) = NULL, -- Class Days Filter
	@classHour INT = NULL, -- Class Time Filter
	@locationId INT = NULL, -- Programming Location Filter
	@courseTypeId INT = NULL, -- Class Type Filter
	@courseId INT = NULL, -- Class/Course by Name Filter
	@ageGroupId INT = NULL, -- Age Filter
	@instructorPersonId INT = NULL, -- Instructor Filter
	@programId INT -- Program Filter
AS
	DECLARE @classDaysTable TABLE ([Day] INT)
	DECLARE @classes TABLE ([CourseInstanceID] INT)
	
	INSERT INTO @classDaysTable
	SELECT [Value]
	FROM   dbo.udfSplitString(',', @classDays)
	
	INSERT INTO @classes
	SELECT DISTINCT ci.CourseInstanceID
	FROM   CourseInstances ci
	       INNER JOIN Courses c
	            ON  c.CourseID = ci.CourseID
	       INNER JOIN Classes cls
	            ON  cls.CourseInstanceID = ci.CourseInstanceID
	       INNER JOIN LessonPlans lp
	            ON  lp.LessonPlanID = cls.LessonPlanID
	       LEFT JOIN Locations ci_site
	            ON  ci_site.LocationID = ci.SiteLocationID
	       LEFT JOIN Locations cls_site
	            ON  cls_site.LocationID = cls.SiteLocationID
	       LEFT JOIN Locations cls_loc
	            ON  cls_loc.LocationID = cls.SpecificLocationID
	WHERE  1 = 1
	       AND c.ProgramID = @programId -- Program Filter
	       AND ci.ProgramID = @programId -- Program Filter
	       AND lp.ProgramID = @programId -- Program Filter
	       AND (
	               ci_site.LocationID = @siteLocationId
	               OR @siteLocationId IS NULL
	           ) -- Site Filter
	       AND (ci.StartDate >= @startDate OR @startDate IS NULL) -- Start Date Filter
	       AND (ci.EndDate <= @endDate OR @endDate IS NULL) -- End Date Filter
	       AND (
	               DATEPART(WEEKDAY, cls.DateStart) IN (SELECT [Day]
	                                                    FROM   @classDaysTable)
	               OR @classDays IS NULL
	           ) -- Class Days Filter
	       AND (c.CourseTypeID = @courseTypeId OR @courseTypeId IS NULL) -- Class Type Filter
	       AND (
	               cls.SiteLocationID = @locationId
	               OR cls.SpecificLocationID = @locationId
	               OR @locationId IS NULL
	           ) -- Programming Location Filter
	       AND (c.CourseID = @courseId OR @courseId IS NULL) -- Course (Class Name) Filter
	       AND (lp.AgeGroupID = @ageGroupId OR @ageGroupId IS NULL) -- Age Filter
	       AND (
	               ci.InstructorPersonID = @instructorPersonId
	               OR @instructorPersonId IS NULL
	           ) -- Instructor Filter
	       AND (
	               DATEPART(HOUR, cls.DateStart) = @classHour
	               OR @classHour IS NULL
	           ) -- Time Filter
	
	SELECT DISTINCT p.PersonID,
	       p.FirstName,
	       p.LastName,
	       dbo.Calc_Age(p.DateOfBirth, GETDATE()) AS [Age],
	       ci.CourseInstanceID,
	       c.CourseID,
	       c.Name  AS [CourseName],
	       sit.LocationID,
	       sit.SiteName  AS [LocationName]
	FROM   PersonsToCourseInstances ptci
	       INNER JOIN Persons p
	            ON  p.PersonID = ptci.PersonID
	       INNER JOIN CourseInstances ci
	            ON  ci.CourseInstanceID = ptci.CourseInstanceID
	       INNER JOIN Sites sit
	            ON  sit.LocationID = ci.SiteLocationID
	       INNER JOIN Courses c
	            ON  c.CourseID = ci.CourseID
	WHERE  ci.CourseInstanceID IN (SELECT c.CourseInstanceID
	                               FROM   @classes c)
	ORDER BY
	       ci.CourseInstanceID,
	       c.CourseID,
		   p.LastName,
		   p.FirstName