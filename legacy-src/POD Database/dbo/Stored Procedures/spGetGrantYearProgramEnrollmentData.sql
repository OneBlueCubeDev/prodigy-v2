
CREATE PROCEDURE [dbo].[spGetGrantYearProgramEnrollmentData]
	@targetDate DATETIME,
	@programId INT
AS
	DECLARE @yearStartDate DATETIME
	DECLARE @yearEndDate DATETIME
	
	SELECT @yearStartDate = ugy.StartDate,
	       @yearEndDate = ugy.EndDate
	FROM   dbo.udfGrantYear(@targetDate) ugy
	
	DECLARE @monthStartDate DATETIME
	SET @monthStartDate = dbo.udfMonthStartDate(@targetDate)
	
	DECLARE @monthEndDate DATETIME
	SET @monthEndDate = dbo.udfMonthEndDate(@targetDate)
	
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
	WHERE  mcj.DateStart BETWEEN @yearStartDate AND @monthEndDate
	       AND mcij.ProgramID = @programId		
	
	SELECT DISTINCT 
	       e.EnrollmentTypeID,
	       l.LocationID                AS [SiteLocationID],
	       l.Name                      AS [SiteLocationName],
	       COUNT(DISTINCT p.PersonID)  AS [SiteYouthServedCount],
	       COUNT(
	           CASE 
	                WHEN e.EnrollmentID = el.EnrollmentID THEN 1
	                ELSE NULL
	           END
	       )                           AS [SiteNewEnrollmentCountYTD],
	       COUNT(
	           CASE 
	                WHEN e.EnrollmentID = el.EnrollmentID
	           AND COALESCE(e.GrantYear, e.DateApplied) BETWEEN @monthStartDate AND @monthEndDate 
	               THEN 1
	               ELSE NULL
	               END
	       )                           AS [SiteNewEnrollmentCountMTD],
	       sceq.Amount                 AS [SiteEnrollmentQuota],
	       pr.ProgramID,
	       pceq.Amount                 AS [ProgramEnrollmentQuota]
	FROM   Persons p
	       INNER JOIN Students s
	            ON  s.PersonID = p.PersonID
	       INNER JOIN Enrollments e
	            ON  e.PersonID = p.PersonID
	       INNER JOIN Enrollments el
	            ON  el.EnrollmentID = (
	                    SELECT MIN(eb.EnrollmentID)
	                    FROM   Enrollments eb
	                    WHERE  eb.PersonID = p.PersonID
	                           AND eb.ProgramID = @programId
	                           AND eb.Admitted = 1
	                           AND COALESCE(eb.GrantYear, eb.DateApplied) BETWEEN @yearStartDate AND @monthEndDate
	                )
	       INNER JOIN ClassAttendances cay -- Year Classes projection
	            ON  cay.Student_PersonID = p.PersonID
	            AND cay.ClassID IN (SELECT ClassID
	                                FROM   @programClasses)
	            AND cay.DateTimeStamp BETWEEN @yearStartDate AND @monthEndDate
	       LEFT JOIN RiskAssessments ra
	            ON  ra.PersonID = p.PersonID
	            AND ra.RiskAssessmentID = e.RiskAssessmentID
	       INNER JOIN Programs pr
	            ON  pr.ProgramID = e.ProgramID
	       INNER JOIN Sites si
	            ON  si.LocationID = e.SiteLocationID
	       INNER JOIN Locations l
	            ON  l.LocationID = si.LocationID
	       LEFT JOIN ContractsToSites cts
	            ON  cts.SiteLocationID = si.LocationID
	       LEFT JOIN Contracts cs
	            ON  cs.ContractID = cts.ContractID
	            AND cs.DateStart < @monthEndDate
	            AND cs.DateEnd > @monthStartDate
	       LEFT JOIN ContractEnrollmentQuotas sceq
	            ON  sceq.ContractID = cs.ContractID
	       INNER JOIN Programs prog
	            ON  prog.ProgramID = e.ProgramID
	       LEFT JOIN ContractsToPrograms ctp
	            ON  ctp.ProgramID = prog.ProgramID
	       LEFT JOIN Contracts cp
	            ON  cp.ContractID = ctp.ContractID
	            AND cp.DateStart < @monthEndDate
	            AND cp.DateEnd > @monthStartDate
	       LEFT JOIN ContractEnrollmentQuotas pceq
	            ON  pceq.ContractID = cp.ContractID
	WHERE  COALESCE(e.GrantYear, e.DateApplied) BETWEEN @yearStartDate AND @monthEndDate
	       AND e.ProgramID = @programId
	       AND e.Admitted = 1
	       AND (
	               ra.RiskAssessmentID IS NOT NULL
	               OR e.EnrollmentTypeID = @diversionTypeId
	           )
	GROUP BY
	       e.EnrollmentTypeID,
	       l.LocationID,
	       l.Name,
	       sceq.Amount,
	       pr.ProgramID,
	       pceq.Amount