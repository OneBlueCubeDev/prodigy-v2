--/*
CREATE PROCEDURE [dbo].[spGetMonthlyEnrollmentReportData_withRisk]
	@targetDate DATETIME,
	@programId INT,
	@siteLocationId INT
AS
--*/ 
/*

--test
Declare @targetDate datetime
Declare @programID int
Declare @siteLocationID int = null
Set @targetDate = '11/01/2014'
Set @programID = 1
Set @siteLocationID = null
--end test
*/
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
-- Most recent Enrollment
Declare @RecentEnrollment table (EnrollmentID int, PersonID int)
Insert into @RecentEnrollment
		SELECT MIN(ea.EnrollmentID) as EnrollmentID, ea.PersonID -- Only get the most recent Enrollment that matches the criteria
	                    FROM   Enrollments ea
	                    WHERE  ea.Admitted = 1 -- Must have been admitted
	                           AND ea.ProgramID = @programId
	                           AND COALESCE(ea.GrantYear, ea.DateApplied) BETWEEN @yearStartDate AND @monthEndDate
							   and ea.siteLocationID = @SiteLocationID
		Group by ea.PersonID

--Diversion Enrollment
Declare @DiversionEnrollment table (PersonID int, EnrollmentID int)
Insert into @DiversionEnrollment

SELECT MAX(eb.EnrollmentID), PersonID -- Only get the most recent Enrollment that matches the criteria
	                    FROM   Enrollments eb
	                    WHERE  eb.Admitted = 1 -- Must have been admitted
	                           AND eb.EnrollmentTypeID = @diversionTypeId -- Diversion
	                           AND eb.ProgramID = @programId
	                           AND eb.DateGraduated <= @monthEndDate
	                           AND eb.DateGraduated >= @yesterday -- 24 Hours wait time before graduations count
	                           AND COALESCE(eb.GrantYear, eb.DateApplied) BETWEEN @yearStartDate AND @monthEndDate
							   and eb.SiteLocationID = @SiteLocationID
Group by PersonID

--FirstAttendanceDate
Declare @FirstAttendanceDate table (Student_PersonID int, FirstAtendanceDate datetime)
Insert into @FirstAttendanceDate
Select Student_PersonID, FirstAttendanceDate 
From (
Select Student_PersonID
,min(DateTimeStamp) FirstAttendanceDate
		   From ClassAttendances		   
		   group by Student_PersonID
		  ) dataset
	where FirstAttendanceDate between @MonthStartDate and @MonthEndDate		                
--Performance Form Data
	               
Declare @FormData table (personID int, IsRisk varchar(1), Domain int, [PAT Complete] varchar(1), [Pat Reportable] varchar(1), DateUpdated datetime, DateCompleted datetime)
				Insert into @FormData 
				Select PF.personID
				,Case when sum(Cast(FQC.IsRisk as int)) > 0 then 'Y' else 'N'end  as IsRisk
				,FQ.SectionID + 2 as Domain
				,Case when PF.IsComplete = 1 then 'Y' else 'N' end as [PAT Complete]
				,Case when PF.isReportable =1 then 'Y' else 'N' end as [PAT Reportable]
				,PF.DateUpdated
				,PF.DateCompleted

				from PersonFormQuestionChoice PFQC
				Left outer Join PersonForm PF on PF.PersonFormID = PFQC.PersonFormID
				Left Outer Join FormQuestionChoice FQC on FQC.ChoiceID = PFQC.ChoiceID
				Left outer Join FormQuestion FQ on FQ.QuestionID = FQC.QuestionID
				--Where PF.Iscomplete = 1
				group by
				PF.PersonID
				,FQ.SectionID
				,PF.IsComplete
				,PF.isReportable
				,PF.DateUpdated
				,PF.Datecompleted
				--having personid = 49615
				
				Order by personid, Domain
				

Declare @PivotData table (personid int, Domain int, IsRisk varchar(1))
Insert into @pivotData 
Select personid, domain, isrisk from @FormData

Declare @PivotTable table (personid int, [3] varchar(1),[4] varchar(1),[5] varchar(1),[6] varchar(1),
[7] varchar(1),[8] varchar(1),[9] varchar(1),[10] varchar(1),[11] varchar(1),[12] varchar(1))
Insert into @PivotTable (personid, [3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
				Select * from @PivotData
				Pivot
				(Min(IsRisk) for Domain in ([3],[4],[5],[6],[7],[8],[9],[10],[11],[12])) as PivotTable


 
Select distinct p.lastname
,p.firstname
,  P.FirstName + ' ' + P.MiddleName + ' ' + P.LastName as Name

, P.DJJIDnum, P.StatusTypeID, P.PersonTypeID, P.LocationID, P.CountyID, P.PersonID

--,Min(ca.datetimestamp) as startDate
, PD.[3],PD.[4],PD.[5],PD.[6],PD.[7],PD.[8],PD.[9],PD.[10],PD.[11],PD.[12]
,PF.IsComplete, PF.IsReportable, PF.IsValid, PF.dateCompleted
,Case when PF.IsComplete = 1 then 'Y' else 'N' end as [PAT Complete]
,Case when PF.isReportable =1 then 'Y' else 'N' end as [PAT Reportable]
,Case when (E.isWrapAroundServices = 1 and E.EnrollmentTypeID = 1)
			then 'Prevention Wrap Around'
		when (E.isWrapAroundServices = 0 and E.EnrollmentTypeID = 1)
			then 'Prevention'	 
		when (E.isWrapAroundServices = 1 and E.EnrollmentTypeID = 3)
			then 'Diversion' 
		when (E.isWrapAroundServices = 0 and E.EnrollmentTypeID = 3)	
			then 'Diversion'
		else ''
			
			end  as [Youth Service Category]
,e.dateApplied, E.DateAdmitted, e.GrantYear,e.LocationID
, dbo.udfValidationDate(e.DateAdmitted, Pf.DateUpdated,  FAD.FirstAtendanceDate) as [ValidationDate]
			,IsNull(e.DateGraduated,null) as DateGraduated
			,Ste.Sitename
			,Ste.Organization
			,IsNull(e.RelDate,null) as RelDate
			,IsNull(FAD.FirstAtendanceDate,null) as FirstAtendanceDate
			,EnrollmentTypeID
			,pf.formID
			,e.programID

From Persons P
Inner Join Students S on S.PersonID = P.PersonID
Inner Join Enrollments E on E.personID = P.PersonID
LEFT Outer JOIN PersonForm pf ON  pf.PersonID = p.PersonID 
Left Outer Join @RecentEnrollment Re on Re.PersonID = P.PersonID
Left Outer Join @DiversionEnrollment DE on DE.personID = P.PersonID
  /*     
	Inner JOIN ClassAttendances ca -- Month classes
	            ON  ca.Student_PersonID = p.PersonID
	            AND ca.ClassID IN (SELECT ClassID
	                               FROM   @programClasses)
								   	       LEFT JOIN ClassAttendances cay -- Year Classes projection, used to determine the start date
	            ON  cay.Student_PersonID = p.PersonID
	            AND cay.ClassID IN (SELECT ClassID
	                                FROM   @programClasses)
	            AND cay.DateTimeStamp BETWEEN @yearStartDate AND @monthEndDate AND cay.DateTimeStamp >= COALESCE(e.GrantYear, e.DateApplied)
	      INNER  JOIN PersonsToCourseInstances ptci
	            ON  ptci.PersonID = p.PersonID
	       INNER JOIN CourseInstances ci
	            ON  ci.CourseInstanceID = ptci.CourseInstanceID
*/
	       Inner  JOIN Sites ste
	            ON  ste.LocationID = e.SiteLocationID
	       INNER JOIN Locations l
	            ON  l.LocationID = ste.LocationID
	       Inner JOIN Programs prog
	            ON  prog.ProgramID = e.ProgramID
			Left Outer Join @FirstAttendanceDate FAD on FAD.Student_PersonID = P.PersonID
			Left Outer JOIN @PivotTable PD on PD.PersonID = e.PersonID
			
			
Where  /*(
		RE.PersonID is not null or DE.PersonID is not null
		)
	and*/  e.Admitted = 1 -- Must have been Admitted
			and e.DateAdmitted between @monthStartDate and @monthEndDate
	       AND e.ProgramID = @programId -- Must be enrolled in the Program specified
	       --AND ci.ProgramID = @programId
	       --AND ca.DateTimeStamp BETWEEN @monthStartDate AND @monthEndDate -- Must have attended a class this month
	       AND COALESCE(e.GrantYear, e.DateApplied) BETWEEN @yearStartDate AND @monthEndDate -- Must have been created before the month end and within the grant year
	       AND (
	               @siteLocationId IS NULL
	               OR ste.LocationID = @siteLocationId
	           ) 		 
			   	     /*  AND (
	               (pf.FormId IS NOT NULL and pf.IsComplete = 1)
	               OR e.EnrollmentTypeID = @diversionTypeId 
	           ) */-- If the EnrollmentType is NOT Diversion, then the youth must have a RiskAssessment record
			   --and e.personid = 533527
			--AND p.LOCATIONID = @SITELOCATIONid
--Order by P.LastName, P.Firstname
/*
group by P.FirstName + ' ' + P.MiddleName + ' ' + P.LastName 
,P.Lastname 
,P.Firstname
, P.DJJIDnum, P.StatusTypeID, P.PersonTypeID, P.LocationID, P.CountyID, P.PersonID
, PD.[3],PD.[4],PD.[5],PD.[6],PD.[7],PD.[8],PD.[9],PD.[10],PD.[11],PD.[12]
,PF.IsComplete, PF.IsReportable, PF.IsValid, PF.dateCompleted
,E.isWrapAroundServices
,e.dateApplied, E.DateAdmitted, e.GrantYear,e.LocationID
,e.DateAdmitted, Pf.DateUpdated,  FaD.FirstAtendanceDate, e.dateGraduated
,Ste.Sitename
,Ste.Organization
,e.RelDate
,EnrollmentTypeID
,e.ProgramID
,pf.formid
*/


order by p.personID,p.lastname, p.firstname

GO

