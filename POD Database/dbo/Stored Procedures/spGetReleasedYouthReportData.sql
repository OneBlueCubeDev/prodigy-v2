

CREATE PROCEDURE [dbo].[spGetReleasedYouthReportData]
	@GrantYear int,
	@programId INT,
	@siteLocationId INT = NULL
AS

/*
Declare @GrantYear int
Declare	@programId INT
Declare	@siteLocationId INT = NULL

Set @GrantYear = 2013
Set	@programId = 1
Set	@siteLocationId = 1
--*/

Declare	@minDate date
Declare	@maxDate date
--Set	@minDate = Cast(Cast(@GrantYear as varchar(4)) + '-07-01 00:00:00' as datetime)
--Set	@maxDate = Cast(Cast((@GrantYear + 1) as varchar(4)) + '-06-30 23:59:59' as datetime)

select @minDate = tp.StartDate, @maxDate = tp.EndDate
from TimePeriods tp
where tp.TimePeriodID = @GrantYear

declare @attendanceTable TABLE
(personID int,
PATCompletedDate date null,
FirstDateOfAttendance date null,
LastDateOfAttendance date null)

insert into @attendanceTable
select ca.Student_PersonID,
max(pf.dateupdated),
MIN(ca.datetimestamp),
MAX(ca.DateTimeStamp)
from ClassAttendances ca left outer join PersonForm pf
on ca.Student_PersonID = pf.PersonId
and pf.IsComplete = 1
group by ca.Student_PersonID

	SELECT DISTINCT p.PersonID,
	       p.FirstName,
	       p.LastName,
	       p.DJJIDNum,
	       e.EnrollmentTypeID,
	       cir.CircuitID,
	       si.LocationID          AS [SiteLocationID],
	       si.SiteName            AS [SiteLocationName],
	       cir.Name               AS [CircuitName],
--	       e.DateAdmitted         AS [StartDate],
		   attT.PATCompletedDate as [PATCompletedDate],
           attT.FirstDateOfAttendance AS [FirstDateOfAttendance],
           attT.LastDateOfAttendance AS [LastDateOfAttendance],
	       e.RelDate              AS [ReleaseDate],
	       e.RelReasonForLeaving  AS [ReleaseReason],
	       e.RelAgency            AS [ReleaseAgency],
	       (
	           SELECT SUM(DATEDIFF(HOUR, cls.DateStart, cls.DateEnd))
	           FROM   ClassAttendances ca
	                  INNER JOIN Classes cls
	                       ON  cls.ClassID = ca.ClassID
	                       AND cls.ClassID IN (SELECT cls2.ClassID
	                                           FROM   Classes cls2
	                                                  INNER JOIN CourseInstances 
	                                                       ci2
	                                                       ON  cls2.CourseInstanceID = 
	                                                           ci2.CourseInstanceID
	                                           WHERE  ci2.ProgramID = @programId)
	           WHERE  ca.DateTimeStamp >= e.DateTimeStamp
	                  AND ca.DateTimeStamp <= e.RelDate
	                  AND ca.Student_PersonID = p.PersonID
	       )                      AS [TotalHours],
	       pcmgr.PersonID         AS [CaseManagerPersonID],
	       pcmgr.FirstName        AS [CaseManagerFirstName],
	       pcmgr.LastName         AS [CaseManagerLastName],
	       pro.ProgramID,
	       pro.Name               AS [ProgramName],
	       pro.ProviderName
	FROM   Persons p
	       INNER JOIN Students s
	            ON  s.PersonID = p.PersonID
	       INNER JOIN @attendanceTable attT
				ON p.PersonID = attT.personID
	       INNER JOIN Enrollments e
	            ON  e.PersonID = p.PersonID
	       INNER JOIN Programs pro
	            ON  pro.ProgramID = e.ProgramID
	       LEFT JOIN Persons pcmgr
	            ON  pcmgr.PersonID = s.CaseMgrStaffPersonID
	       LEFT JOIN Sites si
	            ON  si.LocationID = e.SiteLocationID
	       LEFT JOIN Locations l
	            ON  l.LocationID = si.LocationID
	       LEFT JOIN Addresses a
	            ON  a.AddressID = l.AddressID
	       LEFT JOIN Counties c
	            ON  c.CountyID = a.CountyID
	       LEFT JOIN Circuits cir
	            ON  cir.CircuitID = c.CircuitID
	       LEFT JOIN ClassAttendances ca
	            ON  ca.Student_PersonID = p.PersonID
	            AND ca.DateTimeStamp <= @maxDate
	       LEFT JOIN PersonForm pf
				ON pf.PersonId = p.PersonID
	WHERE  e.Admitted = 1
	       AND pro.ProgramID = @programId
	       AND e.StatusTypeID in (8, 11)  -- Inactive status or Released status
	       AND e.RelDate BETWEEN @minDate AND @maxDate
	       AND e.SiteLocationID IS NOT NULL
	       AND (
	               e.SiteLocationID = @siteLocationId
	               OR @siteLocationId IS NULL
	           )
	ORDER BY p.LastName, p.FirstName

/*
Exec [dbo].[spGetReleasedYouthReportData] '2013-07-01', '2014-06-30', 1, 1
Exec [dbo].[spGetReleasedYouthReportDataTest] 2013, 1, 1
*/

