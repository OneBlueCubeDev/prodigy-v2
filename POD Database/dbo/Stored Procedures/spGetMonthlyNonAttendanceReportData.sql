CREATE PROCEDURE [dbo].[spGetMonthlyNonAttendanceReportData]
	@minDate DATETIME,
	@maxDate DATETIME,
	@minDays INT,
	@siteLocationId varchar(16) ,
	@programId INT
AS
	--DECLARE @enrolledStatusTypeID INT
	--SELECT @enrolledStatusTypeID = st.StatusTypeID
	--FROM   StatusTypes st
	--WHERE  st.Name = 'Enrolled'
	--       AND st.Category = 'Enrollment'
	
	SELECT [PersonID],
	       [DJJIDNum],
	       [FirstName],
	       [LastName],
	       [DateAttended],
	       [LocationID],
	       [LocationName],
	       [SiteLocationID],
	       [SiteLocationName],
	       [GuardianPersonID],
	       [GuardianFirstName],
	       [GuardianLastName],
	       [GuardianContactNumber],
	       [GuardianEmail]
	FROM   (
	           SELECT p.PersonID,
	                  p.DJJIDNum,
	                  p.FirstName,
	                  p.LastName,
	                  c2.DateStart      AS [DateAttended],
	                  l.LocationID,
	                  l.Name            AS [LocationName],
	                  e.SiteLocationID AS [SiteLocationID],
	                  sit.SiteName AS [SiteLocationName],
	                  p2.PersonID       AS [GuardianPersonID],
	                  p2.FirstName      AS [GuardianFirstName],
	                  p2.LastName       AS [GuardianLastName],
	                  pnx.PhoneNumbers  AS [GuardianContactNumber],
	                  p2.Email          AS [GuardianEmail],
	                  ROW_NUMBER() OVER(PARTITION BY p.PersonID, sit.LocationID ORDER BY c2.DateStart DESC) AS 
	                  [DateAttendedRank]
	           FROM   Persons p
	                  INNER JOIN Students s
	                       ON  s.PersonID = p.PersonID
	                  INNER JOIN Enrollments e
	                       ON  e.PersonID = p.PersonID
	                  INNER JOIN PersonsToCourseInstances ptci
	                       ON  ptci.PersonID = p.PersonID
	                  INNER JOIN Sites sit ON sit.LocationID = e.SiteLocationID
	                  INNER JOIN Classes c
	                       ON  c.CourseInstanceID = ptci.CourseInstanceID
	                  LEFT JOIN ClassAttendances ca
	                       ON  ca.ClassID = c.ClassID
	                       AND ca.Student_PersonID = p.PersonID
	                  LEFT JOIN Classes c2
	                       ON  c2.ClassID = ca.ClassID
	                  LEFT JOIN Locations l
	                       ON  l.LocationID = c2.SpecificLocationID
	                  LEFT JOIN PersonRelationships pr
	                       ON  pr.PersonRelationshipID = (
	                               SELECT TOP 1 px.PersonRelationshipID
	                               FROM   PersonRelationships px
	                               WHERE  px.PersonID = p.PersonID
	                                      AND px.IsGuardian = 1
	                                      AND px.IsActive = 1
	                               ORDER BY
	                                      px.ListOrder
	                           )
	                  LEFT JOIN Persons p2
	                       ON  p2.PersonID = pr.RelatedPersonID
	                  LEFT JOIN (
	                           SELECT p3.PersonID,
	                                  STUFF(
	                                      (
	                                          SELECT ', ' + pn.Phone
	                                          FROM   PersonsToPhoneNumbers ptpn
	                                                 INNER JOIN PhoneNumbers pn
	                                                      ON  pn.PhoneNumberID = 
	                                                          ptpn.PhoneNumberID
	                                          WHERE  ptpn.PersonID = p3.PersonID
	                                                 AND pn.Phone IS NOT NULL
	                                                 AND pn.Phone != ''
	                                                     FOR XML PATH(''), TYPE
	                                      ).value('.', 'varchar(max)'),
	                                      1,
	                                      2,
	                                      ''
	                                  ) AS [PhoneNumbers]
	                           FROM   Persons p3
	                       ) pnx
	                       ON  pnx.PersonID = p2.PersonID
	           WHERE  e.Admitted = 1 and e.StatusTypeID = 2
	                  AND c.DateStart >= @minDate
	                  AND e.DateAdmitted <= @maxDate
	                  AND c.DateStart <= @maxDate
	                  AND e.SiteLocationID like @siteLocationId
	                  AND e.ProgramID = @programId
	       ) DATA
	WHERE  DATA.[DateAttendedRank] = 1
	       AND DATEDIFF(DAY, DATA.DateAttended, @maxDate) >= @minDays
	ORDER BY
	       DATA.DateAttended DESC, DATA.LastName, data.FirstName
