/*********  Edit Notes    

20150623 - added to remove duplicate   on ((p.personId = ed.PersonID) and  (ed.GrantYear between @yearStartDate and @yearEndDate))    
Samyra Chrisp  All Covered


******************/

Alter PROCEDURE [dbo].[spGetCensusReportData]
	@targetDate DATETIME,
	@programId INT,
	@siteLocationId INT = NULL
AS

DECLARE @yearStartDate DATETIME
DECLARE @yearEndDate DATETIME
DECLARE @monthStartDate DATETIME
DECLARE @monthEndDate DATETIME
DECLARE @yesterday DATETIME

SET @monthStartDate = dbo.udfMonthStartDate(@targetDate)
SET @monthEndDate = dbo.udfMonthEndDate(@targetDate)

SELECT @yearStartDate = ugy.StartDate,
       @yearEndDate = ugy.EndDate
FROM   dbo.udfGrantYear(@targetDate) ugy


-- DEBUG DEBUG DEBUG
--select @TODAY as Today, @yearStartDate as YearStart, @yearEndDate as YearEnd, @monthStartDate as MonthStart, @monthEndDate as MonthEnd
	
DECLARE @diversionTypeId INT
SET @diversionTypeId = dbo.udfEnrollmentTypeByName('Diversion Youth')

DECLARE @statusGraduatedId INT
SET @statusGraduatedId = dbo.udfStatusTypeByName('Graduated');



-- get attendances for Diversion youth
/* Orginal Diversion Selection with [firstAttendanceDate]
select Student_PersonID, min(ca.datetimestamp) as [firstAttendanceDate], 
	0 as [isPreventionYouth], 0 as [isPreventionYouthWrapAroundServices], 1 as [isDiversionYouth]
	into #DiversionFirstAttendance
	from ClassAttendances ca INNER JOIN Students s
	ON  ca.Student_PersonID = s.PersonID
	inner join Enrollments e
	on ca.Student_PersonID = e.PersonID
	where e.ProgramID = @programId and
	e.EnrollmentTypeID = 3 and
	e.Admitted = 1
	and ca.datetimestamp > @yearStartDate
	AND (
	   @siteLocationId IS NULL
	   OR e.SiteLocationID = @siteLocationId
	)
	group by Student_PersonID
	HAVING min(ca.DateTimeStamp) between @monthStartDate and @monthEndDate
*/
--/* New Diversion Selection based on DateApplied
select s.PersonID as [Student_PersonID], e.DateApplied as [firstAttendanceDate],
	--, min(ca.datetimestamp) as [firstAttendanceDate], 
	0 as [isPreventionYouth], 0 as [isPreventionYouthWrapAroundServices], 1 as [isDiversionYouth]
	into #DiversionFirstAttendance
	from 
	(Students s inner join Enrollments e on s.PersonID = e.PersonID)
	left join ClassAttendances ca ON ca.Student_PersonID = s.PersonID
	where e.ProgramID = 1 
	and e.EnrollmentTypeID = 3 -- Diversion Youth
	and e.Admitted = 1
	and e.DateApplied between @monthStartDate and @monthEndDate
	AND (
	   @siteLocationId IS NULL
	   OR e.SiteLocationID = @siteLocationId
	)	
	Order by e.DateApplied, Student_PersonID
--*/
-- DEBUG DEBUG DEBUG
--select '#DiversionFirstAttendance table follows'
--select dfa.*, p.FirstName, p.LastName
--from #DiversionFirstAttendance dfa inner join persons p
--on dfa.Student_PersonID = p.PersonID
--order by p.LastName
-- DEBUG DEBUG DEBUG


--drop table #PreventionFirstAttendance
-- get attendances for Prevention youth
select Student_PersonID, min(ca.datetimestamp) as [firstAttendanceDate], MIN(pf.DateCompleted) as [PATCompletedDate], 
	1 as [isPreventionYouth], e.isWrapAroundServices as [isPreventionYouthWrapAroundServices], 0 as [isDiversionYouth] 
	into #PreventionFirstAttendance
	from ClassAttendances ca INNER JOIN Persons p
	ON  ca.Student_PersonID = p.PersonID
	inner join Enrollments e
	on ca.Student_PersonID = e.PersonID
	inner join PersonForm pf
	on ca.Student_PersonID = pf.PersonId
	where e.ProgramID = @programId and
	e.EnrollmentTypeID = 1 and
	e.Admitted = 1 and
	ca.DateTimeStamp > @yearStartDate
	AND (
	   @siteLocationId IS NULL
	   OR e.SiteLocationID = @siteLocationId
	)	
	and pf.DateCompleted is not null 
	group by Student_PersonID, e.isWrapAroundServices
	
--client want 'prevention youth with wrap around services' not to appear as prevention youth since that is implied.
update #PreventionFirstAttendance
set isPreventionYouth = 0
where isPreventionYouthWrapAroundServices = 1

--Identify Prevention youth who have at least one attendance and a PAT completed date.  The latter of
--their first attendance date and PAT completed date must fall within the period of this report.
delete #PreventionFirstAttendance
where dbo.udfValidationDate2(firstAttendanceDate, [PATCompletedDate]) not between @monthStartDate and @monthEndDate
-- ALL of the Prevention youth in #PreventionFirstAttendance are report for this report.  Just get their attendance
-- for this month, even if they have no attendance during the period of this report.  This is different from Diversion
-- youth, who must have attendance during the period of this report.

--debug debug debug
--select '#PreventionFirstAttendance table follows'
--select * 
--from #PreventionFirstAttendance
--order by Student_PersonID


	--BEGIN BUILD THE CALENDAR TABLE
	--BEGIN BUILD THE CALENDAR TABLE
	--BEGIN BUILD THE CALENDAR TABLE
	
	DECLARE @personId int
	DECLARE @attendanceDate int
		
	declare @attendanceCalendar TABLE (
		personId int,
		D1 int default (0),
		D2 int default (0),
		D3 int default (0),
		D4 int default (0),
		D5 int default (0),
		D6 int default (0),
		D7 int default (0),
		D8 int default (0),
		D9 int default (0),
		D10 int default (0),
		D11 int default (0),
		D12 int default (0),
		D13 int default (0),
		D14 int default (0),
		D15 int default (0),
		D16 int default (0),
		D17 int default (0),
		D18 int default (0),
		D19 int default (0),
		D20 int default (0),
		D21 int default (0),
		D22 int default (0),
		D23 int default (0),
		D24 int default (0),
		D25 int default (0),
		D26 int default (0),
		D27 int default (0),
		D28 int default (0),
		D29 int default (0),
		D30 int default (0),
		D31 int default (0),
		dayCount int default (0)
		);
		
		

WITH CTE (personID) AS
(
select Student_PersonID
from #PreventionFirstAttendance
--where dbo.udfValidationDate2(firstAttendanceDate, [PATCompletedDate]) between @monthStartDate and @monthEndDate
union
select Student_PersonID
from #DiversionFirstAttendance
)
	select CTE.personID as personID, DATEPART(dd, datetimestamp) as [attendanceDate]
	into #rawAttendance
	from CTE left join ClassAttendances ca
	on CTE.personID = ca.Student_PersonID
	where DateTimeStamp between @monthStartDate and @monthEndDate

-- NOTE:  The prevention youths may have zero attendances for the report month in the #rawAttendance table	


	
	DECLARE Attendance_Cursor CURSOR FAST_FORWARD FOR 
	select personID, attendanceDate from #rawAttendance

	OPEN Attendance_Cursor;

	FETCH NEXT FROM Attendance_Cursor
	into @personId, @attendanceDate;

	WHILE @@FETCH_STATUS = 0
	   BEGIN
		IF NOT EXISTS (select personId from @attendanceCalendar where personId = @personId)
			INSERT INTO @attendanceCalendar(personId, dayCount) 
			values (
			@personId,
			(select COUNT(personID) from #rawAttendance where personID = @personId)
			)
			
		If @attendanceDate = 1
			Begin
				UPDATE @attendanceCalendar SET D1 = 1 WHERE personId = @personId
			End
		Else 
		If @attendanceDate = 2
			Begin
				UPDATE @attendanceCalendar SET D2 = 1 WHERE personId = @personId
			End
		Else 
		If @attendanceDate = 3
			Begin
				UPDATE @attendanceCalendar SET D3 = 1 WHERE personId = @personId
			End
		Else 
		If @attendanceDate = 4
			Begin
				UPDATE @attendanceCalendar SET D4 = 1 WHERE personId = @personId
			End
		Else 
		If @attendanceDate = 5
			Begin
				UPDATE @attendanceCalendar SET D5 = 1 WHERE personId = @personId
			End
		Else 
		If @attendanceDate = 6
			Begin
				UPDATE @attendanceCalendar SET D6 = 1 WHERE personId = @personId
			End
		Else 
		If @attendanceDate = 7
			Begin
				UPDATE @attendanceCalendar SET D7 = 1 WHERE personId = @personId
			End
		Else 
		If @attendanceDate = 8
			Begin
				UPDATE @attendanceCalendar SET D8 = 1 WHERE personId = @personId
			End
		Else 
		If @attendanceDate = 9
			Begin
				UPDATE @attendanceCalendar SET D9 = 1 WHERE personId = @personId
			End
		Else 
		IF @attendanceDate = 10
			Begin
				UPDATE @attendanceCalendar SET D10 = 1 WHERE personId = @personId
			End
		If @attendanceDate = 11
			Begin
				UPDATE @attendanceCalendar SET D11 = 1 WHERE personId = @personId
			End
		Else 
		If @attendanceDate = 12
			Begin
				UPDATE @attendanceCalendar SET D12 = 1 WHERE personId = @personId
			End
		Else 
		If @attendanceDate = 13
			Begin
				UPDATE @attendanceCalendar SET D13 = 1 WHERE personId = @personId
			End
		Else 
		If @attendanceDate = 14
			Begin
				UPDATE @attendanceCalendar SET D14 = 1 WHERE personId = @personId
			End
		Else 
		If @attendanceDate = 15
			Begin
				UPDATE @attendanceCalendar SET D15 = 1 WHERE personId = @personId
			End
		Else 
		If @attendanceDate = 16
			Begin
				UPDATE @attendanceCalendar SET D16 = 1 WHERE personId = @personId
			End
		Else 
		If @attendanceDate = 17
			Begin
				UPDATE @attendanceCalendar SET D17 = 1 WHERE personId = @personId
			End
		Else 
		If @attendanceDate = 18
			Begin
				UPDATE @attendanceCalendar SET D18 = 1 WHERE personId = @personId
			End
		Else 
		If @attendanceDate = 19
			Begin
				UPDATE @attendanceCalendar SET D19 = 1 WHERE personId = @personId
			End
		Else 
		IF @attendanceDate = 20
			Begin
				UPDATE @attendanceCalendar SET D20 = 1 WHERE personId = @personId
			End
		If @attendanceDate = 21
			Begin
				UPDATE @attendanceCalendar SET D21 = 1 WHERE personId = @personId
			End
		Else 
		If @attendanceDate = 22
			Begin
				UPDATE @attendanceCalendar SET D22 = 1 WHERE personId = @personId
			End
		Else 
		If @attendanceDate = 23
			Begin
				UPDATE @attendanceCalendar SET D23 = 1 WHERE personId = @personId
			End
		Else 
		If @attendanceDate = 24
			Begin
				UPDATE @attendanceCalendar SET D24 = 1 WHERE personId = @personId
			End
		Else 
		If @attendanceDate = 25
			Begin
				UPDATE @attendanceCalendar SET D25 = 1 WHERE personId = @personId
			End
		Else 
		If @attendanceDate = 26
			Begin
				UPDATE @attendanceCalendar SET D26 = 1 WHERE personId = @personId
			End
		Else 
		If @attendanceDate = 27
			Begin
				UPDATE @attendanceCalendar SET D27 = 1 WHERE personId = @personId
			End
		Else 
		If @attendanceDate = 28
			Begin
				UPDATE @attendanceCalendar SET D28 = 1 WHERE personId = @personId
			End
		Else 
		If @attendanceDate = 29
			Begin
				UPDATE @attendanceCalendar SET D29 = 1 WHERE personId = @personId
			End
		Else 
		IF @attendanceDate = 30
			Begin
				UPDATE @attendanceCalendar SET D30 = 1 WHERE personId = @personId
			End
		IF @attendanceDate = 31
			Begin
				UPDATE @attendanceCalendar SET D31 = 1 WHERE personId = @personId
			End
		  FETCH NEXT FROM Attendance_Cursor
		  into @personId, @attendanceDate;
	   END;
	CLOSE Attendance_Cursor;
	DEALLOCATE Attendance_Cursor;


--Add dummy attendance records for Prevention youth who have no attendance for this month.
	insert into @attendanceCalendar (personId)
		select Student_PersonID as [personId] from #PreventionFirstAttendance
		except
		select personid from @attendanceCalendar
	



-- DEBUG DEBUG DEBUG
--select * from @attendanceCalendar

	--END BUILD THE CALENDAR TABLE
	--END BUILD THE CALENDAR TABLE
	--ENDBUILD THE CALENDAR TABLE
	
	DECLARE @CENSUSREPORT TABLE (
	personId int,
	FirstName varchar,
	LastName varchar,
	DJJIDNum varchar,
	StartDate datetime,
	--EnrollmentTypeId int,
--	isPreventionYouth int default(0),
--	isPreventionYouthWrapAroundServices int default(0),
--	isDiversionYouth int default(0),
	IsNewlyAdmitted bit,
	ProgramID int,
	CompletedDiversion as char(1),
	ProgramProvider varchar,
	ProgramContract varchar,
	SiteLocationName varchar,
	SiteContractNumber varchar,
	SiteOrganizationName varchar
	);



	declare @programName nvarchar(100)
	
	select @programName = ProviderName
	from Programs 
	where ProgramID = @programId;
	
WITH CTE2 (personID, firstAttendanceDate, isPreventionYouth, isPreventionYouthWrapAroundServices, isDiversionYouth) AS
(
select Student_PersonID, firstAttendanceDate, isPreventionYouth, isPreventionYouthWrapAroundServices, isDiversionYouth
from #PreventionFirstAttendance
--where dbo.udfValidationDate2(firstAttendanceDate, [PATCompletedDate]) between @monthStartDate and @monthEndDate
union
select Student_PersonID, firstAttendanceDate, isPreventionYouth, isPreventionYouthWrapAroundServices, isDiversionYouth
from #DiversionFirstAttendance
)
	select 	
	p.personId, 
	p.firstName, 
	p.LastName, 
	p.DJJIDNum, 
	cte2.firstAttendanceDate as StartDate,
	CASE 
		WHEN (cte2.isPreventionYouth = 1 and ed.isWrapAroundServices = 0) then 1
		else 0
	END as [isPreventionYouth],	
	CAST(ed.isWrapAroundServices AS INT) as [isPreventionYouthWrapAroundServices], 
	cte2.isDiversionYouth,
	CASE 
		WHEN @monthStartDate = @yearStartDate THEN CAST(1 AS BIT)
		WHEN cte2.firstAttendanceDate BETWEEN @monthStartDate 
			 AND @monthEndDate THEN CAST(1 AS BIT)
		ELSE CAST(0 AS BIT)
	END                     AS [IsNewlyAdmitted],
	@programId as ProgramID,
	CASE 
		WHEN (ed.EnrollmentTypeID =@diversionTypeId and ed.StatusTypeID IS NULL) THEN NULL
		WHEN (ed.EnrollmentTypeID =@diversionTypeId and ed.StatusTypeID = @statusGraduatedId) THEN 'Y'
		ELSE 'N'
	END                     AS [CompletedDiversion],	

	@programName as ProviderProvider,
	(
		SELECT TOP 1 cp.ContractNumber
		FROM   ContractsToPrograms ctp
		LEFT JOIN Contracts cp
		ON  cp.ContractID = ctp.ContractID
		AND cp.DateStart < @monthEndDate
		AND cp.DateEnd > @monthStartDate
		WHERE  ctp.ProgramID = @programId
		AND cp.ContractID IS NOT NULL
	)                       AS [ProgramContract],
	ste.SiteName            AS [SiteLocationName],
	(
	SELECT TOP 1 cs.ContractNumber
	FROM   ContractsToSites cts
	LEFT JOIN Contracts cs
	ON  cs.ContractID = cts.ContractID
	AND cs.DateStart < @monthEndDate
	AND cs.DateEnd > @monthStartDate
	WHERE  cts.SiteLocationID = ste.LocationID
	AND cs.ContractID IS NOT NULL
	)                       AS [SiteContractNumber],
	ste.Organization        AS [SiteOrganizationName]
	into #CensusReport 
	from Persons p inner join cte2
	on p.personId = cte2.personID
	inner join Enrollments ed
	on ((p.personId = ed.PersonID) and  (ed.GrantYear between @yearStartDate and @yearEndDate))    -- added to remove individual who were not enrolled in grant year
	INNER JOIN Sites ste
	ON  ste.LocationID = ed.SiteLocationID


	Select cs.*, ac.*
	from #CensusReport cs left join @attendanceCalendar ac
	on cs.PersonID = ac.personId
	ORDER BY cs.LastName, cs.FirstName









GO


