
CREATE PROCEDURE [dbo].[spGetMonthlyAttendanceReportData]
	@targetDate DATETIME,
	@courseInstanceId INT,
	@programId INT
AS
	DECLARE @monthStartDate DATETIME
	DECLARE @monthEndDate DATETIME
	
	SET @monthStartDate = dbo.udfMonthStartDate(@targetDate)
	SET @monthEndDate = dbo.udfMonthEndDate(@targetDate)
	
	SELECT DISTINCT p.PersonID,
	       p.FirstName,
	       p.LastName,
	       p.DJJIDNum,
	       e.EnrollmentTypeID,
	       co.CourseID            AS [CourseID],
	       co.Name                AS [CourseName],
	       DAY(ca.DateTimeStamp)  AS [ClassAttendanceDay],
	       l.LocationID           AS [ClassLocationID],
	       l.Name                 AS [ClassLocationName],
	       c.DateStart            AS [ClassDateStart],
	       c.DateEnd              AS [ClassDateEnd],
	       pt.PersonID            AS [InstructorPersonID],
	       pt.FirstName           AS [InstructorFirstName],
	       pt.LastName            AS [InstructorLastName]
	FROM   Persons p
	       INNER JOIN Students s
	            ON  s.PersonID = p.PersonID
	       INNER JOIN Enrollments e
	            ON  e.PersonID = p.PersonID
	       INNER JOIN PersonsToCourseInstances ptci
	            ON  ptci.PersonID = p.PersonID
	       INNER JOIN CourseInstances ci
	            ON  ci.CourseInstanceID = ptci.CourseInstanceID
	       INNER JOIN Courses co
	            ON  co.CourseID = ci.CourseID
	       INNER JOIN Classes c
	            ON  c.CourseInstanceID = ci.CourseInstanceID
	       LEFT JOIN ClassAttendances ca
	            ON  ca.Student_PersonID = p.PersonID
	            AND ca.ClassID = c.ClassID
	       INNER JOIN Persons pt
	            ON  pt.PersonID = ci.InstructorPersonID
	       INNER JOIN Locations l
	            ON  l.LocationID = ci.SiteLocationID
	WHERE  ci.CourseInstanceID = @courseInstanceId OR @courseInstanceId IS NULL
	       AND ci.ProgramID = @programId
	       AND co.ProgramID = @programId
	       AND e.ProgramID = @programId
	       AND (
	               ca.DateTimeStamp BETWEEN @monthStartDate AND @monthEndDate
	               OR ca.ClassAttendanceID IS NULL
	           )
	GROUP BY
	       p.PersonID,
	       p.FirstName,
	       p.LastName,
	       p.DJJIDNum,
	       e.EnrollmentTypeID,
	       ca.DateTimeStamp,
	       pt.PersonID,
	       pt.FirstName,
	       pt.LastName,
	       co.CourseID,
	       co.Name,
	       l.LocationID,
	       l.Name,
	       c.DateStart,
	       c.DateEnd
	ORDER BY
	       e.EnrollmentTypeID,
	       p.LastName,
		   p.FirstName