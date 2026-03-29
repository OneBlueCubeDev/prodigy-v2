

CREATE PROCEDURE [dbo].[spGetMasterClassScheduleParameterLookupData]
	@programId INT
AS
	SELECT DISTINCT c.CourseID,
	       c.Name                         AS [CourseName],
	       ct.CourseTypeID,
	       ct.Name                        AS [CourseTypeName],
	       DATEPART(HOUR, cls.DateStart)  AS [ClassTime],
	       ins.PersonID                   AS [InstructorPersonID],
	       ins.FirstName                  AS [InstructorFirstName],
	       ins.LastName                   AS [InstructorLastName],
	       ci.SiteLocationID              AS [SiteLocationID],
	       ci_site.SiteName                   AS [SiteLocationName],
	       cls.SiteLocationID             AS [ScheduledSiteLocationID],
	       cls_site.SiteName                  AS [ScheduledSiteLocationName],
	       cls.SpecificLocationID         AS [ScheduledSpecificLocationID],
	       cls_loc.Name                   AS [ScheduledSpecificLocationName]
	FROM   CourseInstances ci
	       INNER JOIN Courses c
	            ON  c.CourseID = ci.CourseID
	       INNER JOIN Persons ins
	            ON  ins.PersonID = ci.InstructorPersonID
	       INNER JOIN CourseTypes ct
	            ON  ct.CourseTypeID = c.CourseTypeID
	       INNER JOIN Classes cls
	            ON  cls.CourseInstanceID = ci.CourseInstanceID
	       INNER JOIN LessonPlans lp
	            ON  lp.LessonPlanID = cls.LessonPlanID
	       LEFT JOIN Sites ci_site
	            ON  ci_site.LocationID = ci.SiteLocationID
	       LEFT JOIN Sites cls_site
	            ON  cls_site.LocationID = cls.SiteLocationID
	       LEFT JOIN Locations cls_loc
	            ON  cls_loc.LocationID = cls.SpecificLocationID
	WHERE ci.ProgramID = @programId
	AND c.ProgramID = @programId
	AND lp.ProgramID = @programId