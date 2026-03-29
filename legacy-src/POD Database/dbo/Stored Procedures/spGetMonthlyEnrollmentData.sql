



CREATE PROCEDURE [dbo].[spGetMonthlyEnrollmentData]
	@targetDate DATETIME,
	@programId INT,
	@siteLocationId INT
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
	
	SELECT @today = CASE 
	                     WHEN GETDATE() > @monthEndDate THEN @monthEndDate
	                     ELSE GETDATE()
	                END
	
	SELECT @yesterday = CASE 
	                         WHEN @today = @monthEndDate THEN @monthEndDate
	                         ELSE DATEADD(HOUR, -24, @today)
	                    END
	
	DECLARE @diversionTypeId INT
	SET @diversionTypeId = dbo.udfEnrollmentTypeByName('Diversion Youth')
	
	DECLARE @statusGraduatedId INT
	SET @statusGraduatedId = dbo.udfStatusTypeByName('Graduated')
	
	DECLARE @enrollmentData TABLE (
	            PersonID INT NOT NULL,
	            EnrollmentTypeID INT NOT NULL,
	            EnrollmentDateTimeStamp SMALLDATETIME,
	            IsNewlyAdmitted BIT NOT NULL,
	            CompletedDiversion BIT NOT NULL,
	            SiteLocationID INT NOT NULL,
	            SiteLocationName NVARCHAR(255),
	            ProgLocationID INT NOT NULL,
	            ProgLocationName NVARCHAR(255)
	        )
	
	DECLARE @enrollmentCountData TABLE (
	            EnrollmentTypeID INT NOT NULL,
	            SiteLocationID INT NOT NULL,
	            SiteNewEnrollmentCountMTD INT,
	            SiteNewEnrollmentCountYTD INT,
	            SiteEnrollmentQuota INT,
	            ProgramNewEnrollmentCountMTD INT,
	            ProgramNewEnrollmentCountYTD INT,
	            ProgramEnrollmentQuota INT,
	            CurrentMonthEnrollmentPercentage FLOAT,
	            PreviousMonthEnrollmentPercentage FLOAT
	        )

	DECLARE @programClasses TABLE (ClassID INT)
	INSERT INTO @programClasses
	SELECT mcj.ClassID
	FROM   Classes mcj
	       INNER JOIN CourseInstances mcij
	            ON  mcij.CourseInstanceID = mcj.CourseInstanceID
	WHERE  mcj.DateStart BETWEEN @yearStartDate AND @monthEndDate
	       AND mcij.ProgramID = @programId
	
	INSERT INTO @enrollmentData
	SELECT DISTINCT p.PersonID,
	       e.EnrollmentTypeID        AS [EnrollmentTypeID],
	       COALESCE(e.GrantYear, e.DateApplied)           AS [EnrollmentDateTimeStamp],
	       CASE 
				WHEN @monthStartDate = @yearStartDate THEN CAST(1 AS BIT)
	            WHEN e.EnrollmentID = el.EnrollmentID
	                 AND MIN(cay.DateTimeStamp) BETWEEN @monthStartDate 
	                 AND @monthEndDate THEN CAST(1 AS BIT)
	            ELSE CAST(0 AS BIT)
	       END                     AS [IsNewlyAdmitted],
	       CASE 
	            WHEN ed.EnrollmentID IS NOT NULL THEN CAST(1 AS BIT)
	            ELSE CAST(0 AS BIT)
	       END                       AS [CompletedDiversion],
	       sit.LocationID             AS [SiteLocationID],
	       sit.SiteName                   AS [SiteLocationName],
	       ISNULL(cl.LocationID, sl.LocationID) AS [ProgLocationID],
	       ISNULL(cl.Name, sl.Name)  AS [ProgLocationName]
	FROM   Persons p
	       INNER JOIN Students s
	            ON  s.PersonID = p.PersonID
	       INNER JOIN Enrollments e
	            ON  e.PersonID = p.PersonID
	       INNER JOIN Enrollments el -- First Admitted Enrollment
	            ON  el.EnrollmentID = (
	                    SELECT MIN(ea.EnrollmentID) -- Only get the first Enrollment that matches the criteria
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
	       LEFT JOIN ClassAttendances cay -- Year Classes projection, used to determine the start date
	            ON  cay.Student_PersonID = p.PersonID
	            AND cay.ClassID IN (SELECT ClassID
	                                FROM   @programClasses)
	            AND cay.DateTimeStamp BETWEEN @yearStartDate AND @monthEndDate AND cay.DateTimeStamp >= COALESCE(e.GrantYear, e.DateApplied)
	       INNER JOIN PersonsToCourseInstances ptci
	            ON  ptci.PersonID = p.PersonID
	       INNER JOIN CourseInstances ci
	            ON  ci.CourseInstanceID = ptci.CourseInstanceID
	       INNER JOIN Sites sit
	            ON  sit.LocationID = ci.SiteLocationID
	       INNER JOIN Locations sl
				ON  sl.LocationID = ci.SiteLocationID
	       LEFT JOIN Classes c
	            ON  c.CourseInstanceID = ci.CourseInstanceID
	       LEFT JOIN Locations cl
	            ON  cl.LocationID = c.SpecificLocationID
	       INNER JOIN Programs prog
	            ON  prog.ProgramID = e.ProgramID
	WHERE  e.Admitted = 1 -- Must have been Admitted
	       AND e.ProgramID = @programId -- Must be enrolled in the Program specified
	       AND ci.ProgramID = @programId
	       AND COALESCE(e.GrantYear, e.DateApplied) BETWEEN @yearStartDate AND @monthEndDate
	       AND (@siteLocationId IS NULL OR sl.LocationID = @siteLocationId)
	GROUP BY
	       p.PersonID,
	       e.DateAdmitted,
	       e.EnrollmentID,
	       e.GrantYear, 
		   e.DateApplied,
	       el.EnrollmentID,
	       el.GrantYear, 
		   el.DateApplied,
	       e.EnrollmentTypeID,
	       e.StatusTypeID,
	       ed.EnrollmentID,
	       sit.LocationID,
	       sit.SiteName,
	       sl.LocationID,
	       sl.Name,
	       cl.LocationID,
	       cl.Name
	
	INSERT INTO @enrollmentCountData
	SELECT DISTINCT ed.EnrollmentTypeID,
	       ed.SiteLocationID,
	       (
	           SELECT COUNT(DISTINCT PersonID)
	           FROM   @enrollmentData
	           WHERE  IsNewlyAdmitted        = 1
	                  AND SiteLocationID     = ed.SiteLocationID
	                  AND EnrollmentTypeID = ed.EnrollmentTypeID
	       )                             AS [SiteNewEnrollmentCountMTD],
	       (
	           SELECT COUNT(DISTINCT PersonID)
	           FROM   @enrollmentData
	           WHERE  SiteLocationID = ed.SiteLocationID
	                  AND EnrollmentTypeID = ed.EnrollmentTypeID
	       )                             AS [SiteNewEnrollmentCountYTD],
	       sceq.Amount                   AS [SiteEnrollmentQuota],
	       (
	           SELECT COUNT(DISTINCT PersonID)
	           FROM   @enrollmentData
	           WHERE  IsNewlyAdmitted = 1
	                  AND EnrollmentTypeID = ed.EnrollmentTypeID
	       )                             AS [ProgramNewEnrollmentCountMTD],
	       (
	           SELECT COUNT(DISTINCT PersonID)
	           FROM   @enrollmentData
	           WHERE  EnrollmentTypeID = ed.EnrollmentTypeID
	       )                             AS [ProgramNewEnrollmentCountYTD],
	       pceq.Amount                   AS [ProgramEnrollmentQuota],
	       mep_now.EnrollmentPercentage  AS [CurrentMonthEnrollmentPercentage],
	       ISNULL(mep_prev.EnrollmentPercentage, 0) AS 
	       [PreviousMonthEnrollmentPercentage]
	FROM   (
	           SELECT DISTINCT EnrollmentTypeID,
	                  SiteLocationID
	           FROM   @enrollmentData
	       ) ed
	       LEFT JOIN ContractsToSites cts
	            ON  cts.SiteLocationID = ed.SiteLocationID
	       LEFT JOIN Contracts cs
	            ON  cs.ContractID = cts.ContractID
	            AND cs.DateStart < @monthEndDate
	            AND cs.DateEnd > @monthStartDate
	       LEFT JOIN ContractEnrollmentQuotas sceq
	            ON  sceq.ContractID = cs.ContractID
	            AND sceq.EnrollmentTypeID = ed.EnrollmentTypeID
	       LEFT JOIN ContractsToPrograms ctp
	            ON  ctp.ProgramID = @programId
	       LEFT JOIN Contracts cp
	            ON  cp.ContractID = ctp.ContractID
	            AND cp.DateStart < @monthEndDate
	            AND cp.DateEnd > @monthStartDate
	       LEFT JOIN ContractEnrollmentQuotas pceq
	            ON  pceq.ContractID = cp.ContractID
	            AND pceq.EnrollmentTypeID = ed.EnrollmentTypeID
	       LEFT JOIN MonthlyEnrollmentPercentages mep_now
	            ON  mep_now.MonthID = MONTH(@targetDate)
	       LEFT JOIN MonthlyEnrollmentPercentages mep_prev
	            ON  mep_prev.MonthID = MONTH(DATEADD(MONTH, -1, @targetDate))
	            AND mep_prev.EnrollmentPercentage < mep_now.EnrollmentPercentage
	
	SELECT q.*,
	       CASE 
	            WHEN q.SiteEnrollmentPercentageMTD > 1.1 THEN 'Lime Green'
	            WHEN q.SiteEnrollmentPercentageMTD >= 1 THEN 'Yellow'
	            ELSE 'Red'
	       END  AS [SiteEnrollmentPercentageMTDStatus],
	       CASE 
	            WHEN q.SiteEnrollmentPercentageYTD > q.CurrentMonthEnrollmentPercentage 
	                 + 0.1 THEN 'Lime Green'
	            WHEN q.SiteEnrollmentPercentageYTD >= q.CurrentMonthEnrollmentPercentage THEN 
	                 'Yellow'
	            ELSE 'Red'
	       END  AS [SiteEnrollmentPercentageYTDStatus],
	       CASE 
	            WHEN q.[ProgramEnrollmentPercentageMTD] > 1.1 THEN 'Lime Green'
	            WHEN q.[ProgramEnrollmentPercentageMTD] >= 1 THEN 'Yellow'
	            ELSE 'Red'
	       END  AS [ProgramEnrollmentPercentageMTDStatus],
	       CASE 
	            WHEN q.[ProgramEnrollmentPercentageYTD] > q.CurrentMonthEnrollmentPercentage 
	                 + 0.1 THEN 'Lime Green'
	            WHEN q.[ProgramEnrollmentPercentageYTD] >= q.CurrentMonthEnrollmentPercentage THEN 
	                 'Yellow'
	            ELSE 'Red'
	       END  AS [ProgramEnrollmentPercentageYTDStatus]
	FROM   (
	           SELECT ed.*,
	                  ecd.SiteNewEnrollmentCountYTD,
	                  [SiteEnrollmentPercentageMTD] = ecd.SiteNewEnrollmentCountMTD 
	                  / (
	                      ecd.SiteEnrollmentQuota * (
	                          ecd.CurrentMonthEnrollmentPercentage - ecd.PreviousMonthEnrollmentPercentage
	                      )
	                  ),
	                  [SiteEnrollmentPercentageYTD] = CAST(ecd.SiteNewEnrollmentCountYTD AS FLOAT) 
	                  / ecd.SiteEnrollmentQuota,
	                  ecd.ProgramNewEnrollmentCountYTD,
	                  [ProgramEnrollmentPercentageMTD] = ecd.ProgramNewEnrollmentCountMTD 
	                  / (
	                      ecd.ProgramEnrollmentQuota * (
	                          ecd.CurrentMonthEnrollmentPercentage - ecd.PreviousMonthEnrollmentPercentage
	                      )
	                  ),
	                  [ProgramEnrollmentPercentageYTD] = CAST(ecd.ProgramNewEnrollmentCountYTD AS FLOAT) 
	                  / ecd.ProgramEnrollmentQuota,
	                  ecd.CurrentMonthEnrollmentPercentage
	           FROM   @enrollmentData ed
	                  INNER JOIN @enrollmentCountData ecd
	                       ON  ecd.EnrollmentTypeID = ed.EnrollmentTypeID
	                       AND ecd.SiteLocationID = ed.SiteLocationID
	       )       q