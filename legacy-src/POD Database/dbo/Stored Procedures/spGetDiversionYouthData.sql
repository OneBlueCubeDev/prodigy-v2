

CREATE PROCEDURE [dbo].[spGetDiversionYouthData]
	@minDate DATETIME,
	@maxDate DATETIME,
	@programId INT,
	@siteLocationId INT = NULL
AS
	/*******************************************
	* Data Query
	*******************************************/
	DECLARE @yearStartDate DATETIME
	DECLARE @yearEndDate DATETIME
	DECLARE @yesterday DATETIME
	DECLARE @today DATETIME
	
	SET @minDate = dbo.udfMinimumDate(@minDate)
	SET @maxDate = dbo.udfMaximumDate(@maxDate)
	SELECT @yearStartDate = ugy.StartDate,
	       @yearEndDate = ugy.EndDate
	FROM   dbo.udfGrantYear(@minDate) ugy
	
	SELECT @today = CASE 
	                     WHEN GETDATE() > @maxDate THEN @maxDate
	                     ELSE GETDATE()
	                END
	
	SELECT @yesterday = CASE 
	                         WHEN @today = @maxDate THEN @maxDate
	                         ELSE DATEADD(HOUR, -24, @today)
	                    END
	
	DECLARE @diversionTypeId INT
	SET @diversionTypeId = dbo.udfEnrollmentTypeByName('Diversion Youth')
	
	DECLARE @statusGraduatedId INT
	SET @statusGraduatedId = dbo.udfStatusTypeByName('Graduated')
	
	DECLARE @programClasses TABLE (ClassID INT)
	INSERT INTO @programClasses
	SELECT mcj.ClassID
	FROM   Classes mcj
	       INNER JOIN CourseInstances mcij
	            ON  mcij.CourseInstanceID = mcj.CourseInstanceID
	WHERE  mcj.DateStart BETWEEN @yearStartDate AND @maxDate
	       AND mcij.ProgramID = @programId
	
	SELECT DISTINCT p.PersonID,
	       p.FirstName,
	       p.LastName,
	       p.DJJIDNum,
	       MIN(ca.DateTimeStamp)  AS [StartDate],
	       e.DateGraduated        AS [CompletionDate],
	       CASE 
	            WHEN e.StatusTypeID = @statusGraduatedId
	                 AND e.DateGraduated <= @yesterday THEN CAST(1 AS BIT)
	            WHEN (ceq.RequiredProgrammingHours - SUM(DATEDIFF(HOUR, c.DateStart, c.DateEnd))) = 0 THEN CAST(1 AS BIT)
	            ELSE CAST(0 AS BIT)
	       END                    AS [CompletedDiversion],
	       [ExpectedCompletionDate] = DATEADD(DAY, ceq.ExpectedLengthInDays, MIN(ca.DateTimeStamp)),
	       [HoursLeftToComplete] = ceq.RequiredProgrammingHours - SUM(DATEDIFF(HOUR, c.DateStart, c.DateEnd)),
	       [ClassName] = co.Name,
	       [ClassHours] = SUM(DATEDIFF(HOUR, c.DateStart, c.DateEnd)),
	       cir.CircuitID,
	       cir.Name               AS [CircuitName],
	       pcmgr.FirstName        AS [CaseManagerFirstName],
	       pcmgr.LastName         AS [CaseManagerLastName],
	       ste.LocationID           AS [SiteLocationID],
	       ste.SiteName                 AS [SiteLocationName]
	FROM   Persons p
	       INNER JOIN Students s
	            ON  s.PersonID = p.PersonID
	       LEFT JOIN Persons pcmgr
	            ON  pcmgr.PersonID = s.CaseMgrStaffPersonID
	       INNER JOIN Enrollments e
	            ON  e.PersonID = p.PersonID
	       INNER JOIN ClassAttendances ca -- Month classes
	            ON  ca.Student_PersonID = p.PersonID
	            AND ca.ClassID IN (SELECT ClassID
	                               FROM   @programClasses)
	       INNER JOIN Classes c
	            ON  c.ClassID = ca.ClassID
	       INNER JOIN PersonsToCourseInstances ptci
	            ON  ptci.PersonID = p.PersonID
	       INNER JOIN CourseInstances ci
	            ON  ci.CourseInstanceID = ptci.CourseInstanceID
	       INNER JOIN Courses co
	            ON  co.CourseID = ci.CourseID
	       INNER JOIN Sites ste
	            ON  ste.LocationID = ci.SiteLocationID
	       INNER JOIN Locations l
	            ON  l.LocationID = ste.LocationID
	       INNER JOIN Addresses a
	            ON  a.AddressID = l.AddressID
	       INNER JOIN Counties cnt
	            ON  cnt.CountyID = a.CountyID
	       INNER JOIN Circuits cir
	            ON  cir.CircuitID = cnt.CircuitID
	       INNER JOIN Programs prog
	            ON  prog.ProgramID = e.ProgramID
	       LEFT JOIN ContractsToPrograms ctp
	            ON  ctp.ProgramID = prog.ProgramID
	       LEFT JOIN Contracts cp
	            ON  cp.ContractID = ctp.ContractID
	            AND cp.DateStart < @maxDate
	            AND cp.DateEnd > @minDate
	       LEFT JOIN ContractEnrollmentQuotas ceq
	            ON  ceq.ContractID = cp.ContractID
	            AND ceq.EnrollmentTypeID = @diversionTypeId
	WHERE  e.Admitted = 1 -- Must have been Admitted
	       AND e.ProgramID = @programId -- Must be enrolled in the Program specified
	       AND e.Admitted = 1
	       AND e.EnrollmentTypeID = @diversionTypeId
	       AND COALESCE(e.GrantYear, e.DateApplied) BETWEEN @yearStartDate AND @maxDate -- Must have been created before the max date and within the grant year
	       AND ci.ProgramID = @programId
	       AND ca.DateTimeStamp BETWEEN COALESCE(e.GrantYear, e.DateApplied) AND @maxDate -- Must have attended within the range
	       AND (
	               @siteLocationId IS NULL
	               OR ste.LocationID = @siteLocationId
	           )
	GROUP BY
	       p.PersonID,
	       p.FirstName,
	       p.LastName,
	       p.DJJIDNum,
	       e.EnrollmentID,
	       e.DateGraduated,
	       e.StatusTypeID,
	       ste.LocationID,
	       ste.SiteName,
	       co.Name,
	       ceq.ExpectedLengthInDays,
	       ceq.RequiredProgrammingHours,
	       pcmgr.FirstName,
	       pcmgr.LastName,
	       cir.CircuitID,
	       cir.Name
	ORDER BY
	       p.LastName, p.FirstName