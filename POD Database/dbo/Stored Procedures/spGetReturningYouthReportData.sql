




CREATE PROCEDURE [dbo].[spGetReturningYouthReportData]
	@programId INT,
	@siteLocationId INT,
	@enrollmentTypeId INT,
	@startDate DATETIME,
	@endDate DATETIME
AS
	SELECT p.PersonID,
	       p.LastName + ', ' + p.FirstName AS [YouthName],
	       p.DJJIDNum,
	       p.DateOfBirth,
	       MAX(COALESCE(eb.RelDate, eb.DateGraduated)) AS ReleaseDate,
	       e.EnrollmentID,
	       e.EnrollmentTypeID,
	       sit.LocationID AS [SiteLocationID],
	       sit.SiteName,
	       sit.Organization,
	       pro.ProgramID
	FROM   Persons p
	       INNER JOIN Students s
	            ON  s.PersonID = p.PersonID
	       INNER JOIN Enrollments e
	            ON  e.EnrollmentID = (
	                    SELECT MAX(ex.EnrollmentID)
	                    FROM   Enrollments ex
	                    WHERE  ex.PersonID = p.PersonID
	                           AND ex.ProgramID = @programId
	                )
	       INNER JOIN Enrollments eb
	            ON  eb.EnrollmentID = (
	                    SELECT TOP 1 ez.EnrollmentID
	                    FROM   Enrollments ez
	                    WHERE  ez.PersonID = p.PersonID
	                           AND ez.ProgramID = @programId
	                           AND ez.EnrollmentID != e.EnrollmentID
	                    ORDER BY
	                           ez.EnrollmentID DESC
	                )
	       LEFT JOIN RiskAssessments ra
	            ON  ra.PersonID = p.PersonID
	            AND ra.RiskAssessmentID = eb.RiskAssessmentID
	       LEFT JOIN Locations pl
	            ON  pl.LocationID = p.LocationID
	       LEFT JOIN Locations sl1
	            ON  sl1.LocationID = pl.SiteLocationID
	       LEFT JOIN Locations sl2
	            ON  sl2.LocationID = e.SiteLocationID
	       LEFT JOIN Locations sl
	            ON  sl.LocationID = COALESCE(sl1.LocationID, sl2.LocationID)
	       LEFT JOIN Sites sit
	            ON  sit.LocationID = sl.LocationID
	       INNER JOIN Programs pro
	            ON  pro.ProgramID = @programId
	GROUP BY
	       p.PersonID,
	       p.LastName,
	       p.FirstName,
	       p.DJJIDNum,
	       p.DateOfBirth,
	       e.EnrollmentID,
	       eb.EnrollmentID,
	       e.SiteLocationID,
	       e.GrantYear,
		   e.DateApplied,
	       e.EnrollmentTypeID,
	       sit.LocationID,
	       sit.SiteName,
	       sit.Organization,
	       pro.ProgramID
	HAVING DATEDIFF(
	           DAY,
	           MAX(COALESCE(ra.RelDate, eb.DateGraduated)),
	           COALESCE(e.GrantYear, e.DateApplied)
	       ) > 90
	       AND COALESCE(e.GrantYear, e.DateApplied) BETWEEN dbo.udfMinimumDate(@startDate) AND dbo.udfMaximumDate(@endDate)
	       AND (
	           e.EnrollmentTypeID = @enrollmentTypeId
	           OR @enrollmentTypeId IS NULL
	       )
	       AND (
	           sit.LocationID = @siteLocationId
	           OR @siteLocationId IS NULL
	       )
	ORDER BY p.LastName, p.FirstName