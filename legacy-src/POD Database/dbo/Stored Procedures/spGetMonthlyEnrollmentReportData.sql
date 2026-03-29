CREATE PROCEDURE [dbo].[spGetMonthlyEnrollmentReportData]
	@targetDate DATETIME,
	@programId INT,
	@siteLocationId INT = NULL
AS
	DECLARE @monthStartDate DATETIME
	DECLARE @monthEndDate DATETIME
	DECLARE @yearStartDate DATETIME
	DECLARE @yearEndDate DATETIME
	DECLARE @yesterday DATETIME
	DECLARE @today DATETIME
	
	SET @monthStartDate = dbo.udfMonthStartDate(@targetDate)
	SET @monthEndDate = dbo.udfMonthEndDate(@targetDate)
	SELECT @yearStartDate = ugy.StartDate,
	       @yearEndDate = ugy.EndDate
	FROM   dbo.udfGrantYear(@targetDate) ugy
	
	DECLARE @diversionTypeId INT
	SET @diversionTypeId = dbo.udfEnrollmentTypeByName('Diversion Youth')

	SELECT @today = CASE 
	                     WHEN GETDATE() > @monthEndDate THEN @monthEndDate
	                     ELSE GETDATE()
	                END

	SELECT @yesterday = CASE 
	                         WHEN @today = @monthEndDate THEN @monthEndDate
	                         ELSE DATEADD(HOUR, -24, @today)
	                    END
	
	DECLARE @programClasses TABLE (ClassID INT)
	INSERT INTO @programClasses
	SELECT mcj.ClassID
	FROM   Classes mcj
	       INNER JOIN CourseInstances mcij
	            ON  mcij.CourseInstanceID = mcj.CourseInstanceID
	WHERE  mcj.DateStart BETWEEN @yearStartDate AND @monthEndDate
	       AND mcij.ProgramID = @programId		

	SELECT [PersonID],
	       [FirstName],
	       [LastName],
	       [DJJIDNum],
	       [EnrollmentTypeID],
	       [StartDate],
	       [ReleaseDate],
	       [LocationID],
	       [LocationName],
	       [ProgramID],
	       [ProgramName],
	       [OrganizationName],
	       [GrantYear],
	       --dateadmitted,
	       --dateupdated,
	       --firstattendancedate,
	       dbo.udfValidationDate(DateAdmitted, DateUpdated, FirstAttendanceDate) as [ValidationDate]
    FROM (SELECT DISTINCT p.PersonID,
	       p.FirstName,
	       p.LastName,
	       p.DJJIDNum,
	       e.EnrollmentTypeID,
	       MIN(cay.DateTimeStamp)  AS [StartDate],
	       CASE 
				WHEN @monthStartDate = @yearStartDate THEN CAST(1 AS BIT)
	            WHEN e.EnrollmentID = el.EnrollmentID
	                 AND MIN(cay.DateTimeStamp) BETWEEN @monthStartDate 
	                 AND @monthEndDate THEN CAST(1 AS BIT)
	            ELSE CAST(0 AS BIT)
	       END                     AS [IsNewlyAdmitted],
	       e.RelDate              AS [ReleaseDate],
	       l.LocationID,
	       ste.SiteName             AS [LocationName],
	       prog.ProgramID,
	       prog.Name                AS [ProgramName],
	       ste.Organization         AS [OrganizationName],
	       e.GrantYear,
	       e.DateAdmitted,
	       pf.DateUpdated,
	       min(cay.DateTimeStamp) as [FirstAttendanceDate]
	FROM   Persons p
	       INNER JOIN Students s
	            ON  s.PersonID = p.PersonID
	       INNER JOIN Enrollments e
	            ON  e.PersonID = p.PersonID
	       --LEFT JOIN RiskAssessments ra
	       --     ON  ra.PersonID = p.PersonID
	       --     AND ra.RiskAssessmentID = e.RiskAssessmentID
	       LEFT JOIN PersonForm pf
	            ON  pf.PersonID = p.PersonID      
	       INNER JOIN Enrollments el -- Latest Admitted Enrollment
	            ON  el.EnrollmentID = (
	                    SELECT MIN(ea.EnrollmentID) -- Only get the most recent Enrollment that matches the criteria
	                    FROM   Enrollments ea
	                    WHERE  ea.PersonID = p.PersonID
	                           AND ea.Admitted = 1 -- Must have been admitted
	                           AND ea.ProgramID = @programId
	                           AND COALESCE(ea.GrantYear, ea.DateApplied) BETWEEN @yearStartDate AND @monthEndDate
	                )
	       LEFT JOIN Enrollments ed -- Student Has Enrolled in Diversion and Graduated?
	            ON  ed.EnrollmentID = (
	                    SELECT MAX(eb.EnrollmentID) -- Only get the most recent Enrollment that matches the criteria
	                    FROM   Enrollments eb
	                    WHERE  eb.PersonID = p.PersonID
	                           AND eb.Admitted = 1 -- Must have been admitted
	                           AND eb.EnrollmentTypeID = @diversionTypeId -- Diversion
	                           AND eb.ProgramID = @programId
	                           AND eb.DateGraduated <= @monthEndDate
	                           AND eb.DateGraduated >= @yesterday -- 24 Hours wait time before graduations count
	                           AND COALESCE(eb.GrantYear, eb.DateApplied) BETWEEN @yearStartDate AND @monthEndDate
	                )
	       INNER JOIN ClassAttendances ca -- Month classes
	            ON  ca.Student_PersonID = p.PersonID
	            AND ca.ClassID IN (SELECT ClassID
	                               FROM   @programClasses)
	       LEFT JOIN ClassAttendances cay -- Year Classes projection, used to determine the start date
	            ON  cay.Student_PersonID = p.PersonID
	            AND cay.ClassID IN (SELECT ClassID
	                                FROM   @programClasses)
	            AND cay.DateTimeStamp BETWEEN @yearStartDate AND @monthEndDate AND cay.DateTimeStamp >= COALESCE(e.GrantYear, e.DateApplied)
	       INNER JOIN PersonsToCourseInstances ptci
	            ON  ptci.PersonID = p.PersonID
	       INNER JOIN CourseInstances ci
	            ON  ci.CourseInstanceID = ptci.CourseInstanceID
	       INNER JOIN Sites ste
	            ON  ste.LocationID = e.SiteLocationID
	       INNER JOIN Locations l
	            ON  l.LocationID = ste.LocationID
	       INNER JOIN Programs prog
	            ON  prog.ProgramID = e.ProgramID
	WHERE  e.Admitted = 1 -- Must have been Admitted
	       AND e.ProgramID = @programId -- Must be enrolled in the Program specified
	       AND ci.ProgramID = @programId
	       AND ca.DateTimeStamp BETWEEN @monthStartDate AND @monthEndDate -- Must have attended a class this month
	       AND COALESCE(e.GrantYear, e.DateApplied) BETWEEN @yearStartDate AND @monthEndDate -- Must have been created before the month end and within the grant year
	       AND (
	               @siteLocationId IS NULL
	               OR ste.LocationID = @siteLocationId
	           )
	       AND (
	               (pf.FormId IS NOT NULL and pf.IsComplete = 1)
	               OR e.EnrollmentTypeID = @diversionTypeId
	           ) -- If the EnrollmentType is NOT Diversion, then the youth must have a RiskAssessment record
	GROUP BY
	       p.PersonID,
	       p.FirstName,
	       p.LastName,
	       p.DJJIDNum,
		   e.EnrollmentID,
		   el.EnrollmentID,
	       e.EnrollmentTypeID,
	       e.RelDate,
	       l.LocationID,
	       ste.SiteName,
	       prog.ProgramID,
	       prog.Name,
	       ste.Organization,
	       e.GrantYear,
	       e.DateAdmitted,
	       pf.DateUpdated
	       --cay.DateTimeStamp
	       ) dx
	WHERE dx.IsNewlyAdmitted = 1
	ORDER BY dx.LastName, dx.FirstName

