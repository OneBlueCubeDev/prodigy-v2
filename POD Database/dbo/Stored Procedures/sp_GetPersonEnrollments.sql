-- =============================================
-- Author:		Jessica Chong
-- Create date: 5/22/2012
-- Description:	retrieves Person and Enrollment information
--				based on search criteria
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetPersonEnrollments]
	@name VARCHAR(250) = NULL,
	@guardian VARCHAR(250) = NULL,
	@enrollmentType INT = NULL,
	@statusType INT = NULL,
	@school VARCHAR(200) = NULL,
	@startDate DATETIME = NULL,
	@endDate DATETIME = NULL,
	@zip VARCHAR(50) = NULL,
	@ProgramId INT,
	@SiteID INT = NULL,
	@GrantYearID INT = NULL,
	@DJJNum VARCHAR(50) = NULL,
	@xmlRaces XML
AS
	--exec sp_GetPersonEnrollments null, null, null, 5, null,null,null,null,1,null,null

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--get current date for comparison	
	DECLARE @currentDate DATETIME
	--we need to determine start and end date of chosen or current grant year
	DECLARE @startGrantDate DATETIME
	DECLARE @endGrantDate DATETIME
	SET @currentDate = GETDATE()
	IF (@GrantYearID IS NULL)--if not supplied use current year
	BEGIN
	    SET @GrantYearID = (
	            SELECT TOP 1 TimePeriodID
	            FROM   dbo.TimePeriods t
	                   INNER JOIN dbo.TimePeriodTypes tt
	                        ON  t.TimeperiodTypeID = tt.TimePeriodTypeID
	            WHERE  t.EndDate IS NOT NULL
	                   AND @currentDate <= t.EndDate
	        )
	END
	
	SELECT @startGrantDate = startdate
	FROM   dbo.TimePeriods
	WHERE  timeperiodid = @GrantYearID
	
	SELECT @endGrantDate = enddate
	FROM   dbo.TimePeriods
	WHERE  timeperiodid = @GrantYearID
	
	DECLARE @lastName NVARCHAR(250)
	DECLARE @Firstname NVARCHAR(250)
	--split name into 2 parts if spaces are encountered
	IF (CHARINDEX(CHAR(32), @name) > 0)
	BEGIN
	    SELECT @lastName = LTRIM(
	               REVERSE(
	                   SUBSTRING(REVERSE(@name), 1, CHARINDEX(' ', REVERSE(@name)))
	               )
	           )
	    
	    SET @Firstname = SUBSTRING(
	            @name,
	            CHARINDEX(' ', @name) + 1,
	            DATALENGTH(@name) - CHARINDEX(' ', @name)
	        )
	END
	ELSE
	BEGIN
	    SET @lastName = NULL
	    SET @Firstname = @name
	END
	--print @GrantYearID
	--print @startGrantDate
	--print @endGrantDate

	DECLARE @races TABLE (RaceID INT PRIMARY KEY NOT NULL)
	
	IF (@xmlRaces IS NOT NULL)
	BEGIN
	    INSERT INTO @races
	    SELECT node.value('.', 'int') AS [RaceID]
	    FROM   @xmlRaces.nodes('//ArrayOfInt/int') AS x(node)
	END
	
	SELECT DISTINCT p.PersonID,
	       p.DJJIDNum,
	       p.FirstName,
	       p.LastName,
	       p.CompanyName,
	       p.MiddleName,
	       dbo.EnrollmentTypes.Name     AS EnrollmentTypeName,
	       dbo.Enrollments.EnrollmentID,
	       dbo.Enrollments.DateApplied,
	       dbo.Enrollments.DateAdmitted,
	       dbo.Addresses.City,
	       dbo.Addresses.State,
	       dbo.Addresses.Zip,
	       dbo.Addresses.CountyID,
	       dbo.Addresses.AddressLine1,
	       p.DateOfBirth,
	       dbo.Calc_Age(p.DateOfBirth, GETDATE()) AS Age,
	       ISNULL(sl.SiteName, '')      AS SiteName,
	       ISNULL(pl.Name, '')          AS LocationName,
	       dbo.StatusTypes.StatusTypeID,
	       dbo.StatusTypes.Description  AS EnrollmentStatusName
	FROM   dbo.AddressTypes
	       INNER JOIN dbo.Addresses
	            ON  dbo.AddressTypes.AddressTypeID = dbo.Addresses.AddressTypeID
	       INNER JOIN dbo.PersonsToAddresses
	            ON  dbo.Addresses.AddressID = dbo.PersonsToAddresses.AddressID
	       RIGHT OUTER JOIN dbo.Enrollments
	       INNER JOIN dbo.Persons p
	            ON  dbo.Enrollments.PersonID = p.PersonID
	       INNER JOIN dbo.EnrollmentTypes
	            ON  dbo.Enrollments.EnrollmentTypeID = dbo.EnrollmentTypes.EnrollmentTypeID
	       INNER JOIN students s
	            ON  s.personid = p.personid
	       INNER JOIN dbo.StatusTypes
	            ON  dbo.Enrollments.StatusTypeID = dbo.StatusTypes.StatusTypeID
	            ON  dbo.PersonsToAddresses.PersonID = p.PersonID
	       LEFT OUTER JOIN dbo.PersonRelationships r
	            ON  r.personid = p.personid
	       LEFT OUTER JOIN dbo.Persons rp
	            ON  rp.personid = r.relatedpersonid
	       LEFT OUTER JOIN dbo.PersonsToRaces ra
	            ON  p.Personid = ra.personid
	       LEFT OUTER JOIN dbo.Sites sl
	            ON  dbo.Enrollments.SiteLocationID = sl.Locationid
	       LEFT OUTER JOIN dbo.Locations pl
	            ON  dbo.Enrollments.LocationID = pl.LocationID
	WHERE  dbo.enrollments.ProgramId = @ProgramId
	       AND (
	               @lastname IS NULL
	               OR p.firstName LIKE '%' + @lastname + '%'
	               OR p.MiddleName LIKE '%' + @lastname + '%'
	               OR p.LastName LIKE '%' + @lastname + '%'
	           )
	       AND (
	               @firstname IS NULL
	               OR p.firstName LIKE '%' + @firstname + '%'
	               OR p.Lastname LIKE '%' + @firstname + '%'
	               OR p.middlename LIKE '%' + @firstname + '%'
	           )
	       AND (
	               (r.IsGuardian = 1)
	               OR (
	                      @guardian IS NULL
	                      OR rp.firstName LIKE '%' + @guardian + '%'
	                      OR rp.MiddleName LIKE '%' + @guardian + '%'
	                      OR rp.LastName LIKE '%' + @guardian + '%'
	                  )
	           )
	       AND (
	               @school IS NULL
	               OR s.SchoolAttending LIKE '%' + @school + '%'
	           )
	       AND (
	               @enrollmentType IS NULL
	               OR dbo.EnrollmentTypes.EnrollmentTypeID = @enrollmentType
	           )
	       AND (
	               @statusType IS NULL
	               OR dbo.StatusTypes.StatusTypeID = @statusType
	           )
	       AND (@zip IS NULL OR dbo.Addresses.Zip = @zip)
	       AND (
	               @startDate IS NULL
	               OR COALESCE(dbo.Enrollments.GrantYear, dbo.Enrollments.DateApplied) 
	                  >= @startDate
	           )
	       AND (
	               @endDate IS NULL
	               OR COALESCE(dbo.Enrollments.GrantYear, dbo.Enrollments.DateApplied) 
	                  <= @endDate
	           )
	       AND (
	               @SiteID IS NULL
	               OR dbo.Enrollments.SiteLocationID = @SiteID
	           )
	       AND (
	               @startGrantDate IS NULL
	               OR COALESCE(dbo.Enrollments.GrantYear, dbo.Enrollments.DateApplied) 
	                  >= @startGrantDate
	           )
	       AND (
	               @endGrantDate IS NULL
	               OR COALESCE(dbo.Enrollments.GrantYear, dbo.Enrollments.DateApplied) 
	                  <= @endGrantDate
	           )
	       AND (@DJJNum IS NULL OR p.DJJIDNum LIKE '%' + @DJJNum + '%')
		   AND (@xmlRaces IS NULL OR EXISTS(SELECT rx.RaceID FROM @races rx WHERE rx.RaceID = ra.RaceID))

	UNION ALL 

	SELECT DISTINCT p.PersonID,
	       p.DJJIDNum,
	       p.FirstName,
	       p.LastName,
	       p.CompanyName,
	       p.MiddleName,
	       'Risk Assessment' AS        EnrollmentTypeName,
	       dbo.RiskAssessments.RiskAssessmentID,
	       dbo.RiskAssessments.DateApplied,
	       dbo.RiskAssessments.DateEntered,
	       dbo.Addresses.City,
	       dbo.Addresses.State,
	       dbo.Addresses.Zip,
	       dbo.Addresses.CountyID,
	       dbo.Addresses.AddressLine1,
	       p.DateOfBirth,
	       dbo.Calc_Age(p.DateOfBirth, GETDATE()) AS Age,
	       ISNULL(sl.SiteName, '')  AS SiteName,
	       ISNULL(pl.Name, '')      AS LocationName,
	       dbo.StatusTypes.StatusTypeID,
	       StatusTypes.Description  AS EnrollmentStatusName
	FROM   dbo.Persons p
	       LEFT JOIN students s
	            ON  s.personid = p.personid
	       INNER JOIN dbo.RiskAssessments
	            ON  dbo.RiskAssessments.PersonID = p.PersonID
	       LEFT OUTER JOIN dbo.PersonsToAddresses
	            ON  p.Personid = dbo.PersonsToAddresses.Personid
	       LEFT OUTER JOIN dbo.Addresses
	            ON  PersonsToAddresses.AddressID = dbo.Addresses.AddressID
	       LEFT OUTER  JOIN dbo.AddressTypes
	            ON  dbo.AddressTypes.AddressTypeID = dbo.Addresses.AddressTypeID
	       LEFT OUTER JOIN dbo.StatusTypes
	            ON  dbo.RiskAssessments.StatusTypeID = dbo.StatusTypes.StatusTypeID
	       LEFT OUTER JOIN dbo.PersonRelationships r
	            ON  r.personid = p.personid
	       LEFT OUTER JOIN dbo.Persons rp
	            ON  rp.personid = r.relatedpersonid
	       LEFT OUTER JOIN dbo.PersonsToRaces ra
	            ON  p.Personid = ra.personid
	       LEFT OUTER JOIN dbo.Sites sl
	            ON  dbo.RiskAssessments.SiteLocationID = sl.Locationid
	       LEFT OUTER JOIN dbo.Locations pl
	            ON  dbo.RiskAssessments.LocationID = pl.LocationID
	WHERE  dbo.RiskAssessments.ProgramId = @ProgramId
	       AND (
	               @lastname IS NULL
	               OR p.firstName LIKE '%' + @lastname + '%'
	               OR p.MiddleName LIKE '%' + @lastname + '%'
	               OR p.LastName LIKE '%' + @lastname + '%'
	           )
	       AND (
	               @firstname IS NULL
	               OR p.firstName LIKE '%' + @firstname + '%'
	               OR p.Lastname LIKE '%' + @firstname + '%'
	               OR p.middlename LIKE '%' + @firstname + '%'
	           )
	       AND (
	               (r.IsGuardian = 1)
	               OR (
	                      @guardian IS NULL
	                      OR rp.firstName LIKE '%' + @guardian + '%'
	                      OR rp.MiddleName LIKE '%' + @guardian + '%'
	                      OR rp.LastName LIKE '%' + @guardian + '%'
	                  )
	           )
	       AND (
	               @school IS NULL
	               OR s.SchoolAttending LIKE '%' + @school + '%'
	           )
	       AND (
	               @statusType IS NULL
	               OR dbo.StatusTypes.StatusTypeID = @statusType
	           )
	       AND (@enrollmentType IS NULL)
	       AND (@zip IS NULL OR dbo.Addresses.Zip = @zip)
	       AND (
	               @startDate IS NULL
	               OR COALESCE(
	                      dbo.RiskAssessments.GrantYear,
	                      dbo.RiskAssessments.DateApplied
	                  ) >= @startDate
	           )
	       AND (
	               @endDate IS NULL
	               OR COALESCE(
	                      dbo.RiskAssessments.GrantYear,
	                      dbo.RiskAssessments.DateApplied
	                  ) <= @endDate
	           )
	       AND (
	               @SiteID IS NULL
	               OR dbo.RiskAssessments.SiteLocationID = @SiteID
	           )
	       AND (
	               @startGrantDate IS NULL
	               OR COALESCE(
	                      dbo.RiskAssessments.GrantYear,
	                      dbo.RiskAssessments.DateApplied
	                  ) >= @startGrantDate
	           )
	       AND (
	               @endGrantDate IS NULL
	               OR COALESCE(
	                      dbo.RiskAssessments.GrantYear,
	                      dbo.RiskAssessments.DateApplied
	                  ) <= @endGrantDate
	           )
	       AND (@DJJNum IS NULL OR p.DJJIDNum LIKE '%' + @DJJNum + '%')
	       AND (
	               dbo.RiskAssessments.RiskAssessmentID NOT IN (SELECT 
	                                                                   RiskAssessmentID
	                                                            FROM   dbo.Enrollments
	                                                            WHERE  
	                                                                   riskassessmentid 
	                                                                   IS NOT 
	                                                                   NULL)
	           )
	       AND (@xmlRaces IS NULL OR EXISTS(SELECT rx.RaceID FROM @races rx WHERE rx.RaceID = ra.RaceID))
END