
CREATE PROCEDURE dbo.spGetProdigyStaffReportData
	@siteLocationId INT = NULL,
	@locationId INT = NULL,
	@instructorPersonId INT = NULL,
	@minDate DATETIME = NULL,
	@maxDate DATETIME = NULL,
	@programId INT
AS
	SELECT DISTINCT c.ClassID,
	       c.Name                  AS [ClassName],
	       ci.CourseInstanceID,
	       co.CourseID,
	       co.Name                 AS [CourseName],
	       c.DateStart,
	       c.DateEnd,
	       DATEDIFF(HOUR, c.DateStart, c.DateEnd) AS [ClassProgrammingHours],
	       (
	           SELECT SUM(DATEDIFF(HOUR, phs.DateStart, phs.DateEnd))
	           FROM   (
	                      SELECT DISTINCT cphs.ClassID,
	                             cphs.DateStart,
	                             cphs.DateEnd
	                      FROM   Classes cphs
	                      WHERE  cphs.CourseInstanceID = ci.CourseInstanceID
	                             AND cphs.SpecificLocationID = cl.LocationID
	                  ) phs
	       )                       AS [CourseProgrammingHours],
	       ct.ClassTypeID,
	       ct.Name                 AS [ClassType],
	       coty.CourseTypeID,
	       coty.Name               AS [CourseType],
	       ag.AgeMinimum,
	       ag.AgeMaximum,
	       COUNT(DISTINCT ca.Student_PersonID) AS [AttendanceCount],
	       STUFF(
	           (
	               SELECT '/' + tx.[Name]
	               FROM   (
	                          SELECT DISTINCT((DATEPART(dw, clcd.DateStart) + @@DATEFIRST) % 7) AS 
	                                 [Weekday],
	                                 dbo.udfGetWeekDayNameOfDate(clcd.DateStart) AS 
	                                 [Name]
	                          FROM   Classes clcd
	                          WHERE  clcd.CourseInstanceID = ci.CourseInstanceID
	                      ) tx
	               ORDER BY
	                      tx.[Weekday] FOR XML PATH(''),
	                      TYPE
	           ).value('.', 'VARCHAR(MAX)'),
	           1,
	           1,
	           ''
	       )                       AS ClassDays,
	       cs.LocationID           AS [SiteLocationID],
	       cs.Organization,
	       cs.SiteName,
	       cl.LocationID,
	       cl.Name                 AS [LocationName],
	       cla.AddressLine1,
	       cla.City,
	       cla.[State],
	       cla.Zip,
	       STUFF(
	           (
	               SELECT ', ' + tx.Phone
	               FROM   (
	                          SELECT pn.Phone
	                          FROM   LocationsToPhoneNumbers ltpn
	                                 INNER JOIN PhoneNumbers pn
	                                      ON  pn.PhoneNumberID = ltpn.PhoneNumberID
	                          WHERE  ltpn.LocationID = cl.LocationID
	                      ) tx
	               ORDER BY
	                      tx.Phone FOR XML PATH(''),
	                      TYPE
	           ).value('.', 'varchar(max)'),
	           1,
	           2,
	           ''
	       )                       AS PhoneNumber,
	       ipr.PersonID            AS InstructorPersonID,
	       ipr.FirstName           AS InstructorFirstName,
	       ipr.LastName            AS InstructorLastName,
	       apr.PersonID            AS AssistantPersonID,
	       apr.FirstName           AS AssistantFirstName,
	       apr.LastName            AS AssistantLastName,
	       spr.PersonID            AS StudentPersonID,
	       spr.DJJIDNum            AS StudentDJJID,
	       spr.FirstName           AS StudentFirstName,
	       spr.LastName            AS StudentLastName
	FROM   Classes c
	       INNER JOIN CourseInstances ci
	            ON  ci.CourseInstanceID = c.CourseInstanceID
	       INNER JOIN Courses co
	            ON  co.CourseID = ci.CourseID
	       INNER JOIN LessonPlans lp
	            ON  lp.LessonPlanID = c.LessonPlanID
	       INNER JOIN ClassTypes ct
	            ON  ct.ClassTypeID = c.ClassTypeID
	       INNER JOIN AgeGroups ag
	            ON  ag.AgeGroupID = lp.AgeGroupID
	       INNER JOIN CourseTypes coty
	            ON  coty.CourseTypeID = co.CourseTypeID
	       INNER JOIN Sites cs
	            ON  cs.LocationID = ci.SiteLocationID
	       INNER JOIN Locations cl
	            ON  cl.LocationID = c.SpecificLocationID
	       INNER JOIN Addresses cla
	            ON  cla.AddressID = cl.AddressID
	       INNER JOIN StaffMembers ism
	            ON  ism.PersonID = ci.InstructorPersonID
	       INNER JOIN Persons ipr
	            ON  ipr.PersonID = ism.PersonID
	       LEFT JOIN StaffMembers  asm
	            ON  asm.PersonID = ci.AssistantPersonID
	       LEFT JOIN Persons apr
	            ON  apr.PersonID = asm.PersonID
	       LEFT JOIN ClassAttendances ca
	            ON  ca.ClassID = c.ClassID
	       LEFT JOIN Persons spr
	            ON  spr.PersonID = ca.Student_PersonID
	WHERE  (@siteLocationId IS NULL OR ci.SiteLocationID = @siteLocationId)
		   AND (@locationId IS NULL OR c.SpecificLocationID = @locationId)
	       AND (
	               @instructorPersonId IS NULL
	               OR ci.InstructorPersonID = @instructorPersonId
	       )
	       AND ci.ProgramID = @programId
	       AND (@minDate IS NULL OR c.DateStart >= dbo.udfMinimumDate(@minDate)) 
	       AND (@maxDate IS NULL OR c.DateStart <= dbo.udfMaximumDate(@maxDate))
	GROUP BY
	       c.ClassID,
	       ci.CourseInstanceID,
	       co.CourseID,
	       c.Name,
	       co.Name,
	       c.DateStart,
	       c.DateEnd,
	       ct.ClassTypeID,
	       ct.Name,
	       coty.CourseTypeID,
	       coty.Name,
	       ag.AgeMinimum,
	       ag.AgeMaximum,
	       cs.LocationID,
	       cs.Organization,
	       cs.SiteName,
	       cl.LocationID,
	       cl.Name,
	       cla.AddressLine1,
	       cla.City,
	       cla.[State],
	       cla.Zip,
	       ipr.PersonID,
	       ipr.FirstName,
	       ipr.LastName,
	       apr.PersonID,
	       apr.FirstName,
	       apr.LastName,
	       spr.PersonID,
	       spr.DJJIDNum,
	       spr.FirstName,
	       spr.LastName