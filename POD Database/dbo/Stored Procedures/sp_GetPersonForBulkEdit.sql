-- =============================================
-- Author:		Jessica Chong
-- Create date: 5/22/2012
-- Description:	retrieves Person and Enrollment information
--				based on search criteria
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetPersonForBulkEdit]
	@ProgramId int,
	@SiteID int =null,
	@EnrollmentTypeID int = null,
	@NoAttendance bit = null,
	@HasClassOverlap bit = null
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
Declare @currentDate datetime
DECLARE @GrantYearID int 
Declare @startGrantDate datetime
Declare @endGrantDate datetime

Set @currentDate = getdate()

SET @GrantYearID = 
		(Select TimePeriodID from dbo.TimePeriods t INNER JOIN dbo.TimePeriodTypes tt
			ON t.TimeperiodTypeID = tt.TimePeriodTypeID 
			Where t.EndDate Is NOT NULL and @currentDate <= t.EndDate)

Select @startGrantDate =startdate from dbo.TimePeriods where timeperiodid = @GrantYearID
Select @endGrantDate = enddate from dbo.TimePeriods where timeperiodid = @GrantYearID

  SELECT   distinct  p.PersonID, p.DJJIDNum, p.FirstName, p.LastName, p.CompanyName, p.MiddleName,
             dbo.EnrollmentTypes.Name AS EnrollmentTypeName, dbo.Enrollments.EnrollmentID, 
             dbo.Enrollments.DateApplied, dbo.Enrollments.DateAdmitted, dbo.Addresses.AddressID, dbo.Addresses.City,
             dbo.Addresses.State, dbo.Addresses.Zip, dbo.Addresses.CountyID, dbo.Addresses.AddressLine1,
             p.DateOfBirth, dbo.Calc_Age(p.DateOfBirth, GETDATE()) AS Age,             
             dbo.StatusTypes.StatusTypeID, dbo.StatusTypes.Description AS EnrollmentStatusName,
             (Select top 1 Phone from dbo.PhoneNumbers ph 
             inner join dbo.PersonsToPhoneNumbers pp on pp.phoneNumberID = ph.PhoneNumberID
             inner join dbo.PhoneNumberTypes pt on pt.PhoneNumberTypeID = ph.PhoneNumberTypeID
						Where pp.PersonID = p.PersonID and pt.Name ='Home') AS HomePhone,
			
						 (Select top 1Phone from dbo.PhoneNumbers ph 
             inner join dbo.PersonsToPhoneNumbers pp on pp.phoneNumberID = ph.PhoneNumberID
             inner join dbo.PhoneNumberTypes pt on pt.PhoneNumberTypeID = ph.PhoneNumberTypeID
						Where pp.PersonID = p.PersonID and pt.Name ='Cell') AS CellPhone,
						 (Select top 1 ph.phoneNumberID from dbo.PhoneNumbers ph 
             inner join dbo.PersonsToPhoneNumbers pp on pp.phoneNumberID = ph.PhoneNumberID
             inner join dbo.PhoneNumberTypes pt on pt.PhoneNumberTypeID = ph.PhoneNumberTypeID
						Where pp.PersonID = p.PersonID and pt.Name ='Home') AS HomePhoneID,
						 (Select top 1 ph.phoneNumberID from dbo.PhoneNumbers ph 
             inner join dbo.PersonsToPhoneNumbers pp on pp.phoneNumberID = ph.PhoneNumberID
             inner join dbo.PhoneNumberTypes pt on pt.PhoneNumberTypeID = ph.PhoneNumberTypeID
						Where pp.PersonID = p.PersonID and pt.Name ='Cell') AS CellPhoneID
        FROM
  dbo.Enrollments INNER JOIN
  dbo.Persons p ON dbo.Enrollments.PersonID = p.PersonID
  LEFT OUTER JOIN  dbo.PersonsToAddresses on p.PersonID = dbo.PersonsToAddresses.PersonID 
  LEFT OUTER JOIN  dbo.Addresses  ON dbo.Addresses.AddressID = dbo.PersonsToAddresses.AddressID 
  LEFT OUTER JOIN       dbo.AddressTypes ON dbo.AddressTypes.AddressTypeID = dbo.Addresses.AddressTypeID
  INNER JOIN       dbo.EnrollmentTypes ON dbo.Enrollments.EnrollmentTypeID = dbo.EnrollmentTypes.EnrollmentTypeID
  INNER JOIN       students s on s.personid = p.personid
  INNER JOIN       dbo.StatusTypes ON dbo.Enrollments.StatusTypeID = dbo.StatusTypes.StatusTypeID
  LEFT OUTER JOIN  dbo.ClassAttendances ca on ca.Student_PersonID = p.PersonID
                      
WHERE   dbo.enrollments.ProgramId = @ProgramId
	AND (@SiteID is null OR dbo.Enrollments.SiteLocationID =@SiteID)
	AND (@EnrollmentTypeID IS NULL OR dbo.EnrollmentTypes.EnrollmentTypeID= @EnrollmentTypeID)
	--AND (dbo.AddressTypes.Name is null  OR dbo.AddressTypes.Name = 'Mailing')	
	AND( @NoAttendance IS NULL OR (@NoAttendance = 1 AND (SELECT MAX(
		DateStart) FROM dbo.Classes c inner join dbo.ClassAttendances ca on ca.ClassID = c.ClassID 
		where ca.Student_PersonID = p.PersonID) < DateAdd(day, -90,getdate())))
				AND( @startGrantDate is null OR dbo.Enrollments.DateApplied >= @startGrantDate)
				 AND(@endGrantDate IS null OR dbo.Enrollments.DateApplied <= @endGrantDate)
			AND( @HasClassOverlap IS NULL OR (@HasClassOverlap = 1 AND (Select Count(*) 
                      FROM dbo.Classes c inner join dbo.CourseInstances ci on ci.CourseInstanceID = c.CourseInstanceID
                      inner join dbo.PersonsToCourseInstances pci on pci.CourseInstanceID = ci.CourseInstanceID
                      where pci.personid = p.Personid and c.DateEnd > @endGrantDate)>1))	 
		
UNION ALL 
  SELECT    Distinct p.PersonID, p.DJJIDNum, p.FirstName, p.LastName, p.CompanyName, p.MiddleName,
             'Risk Assessment' AS EnrollmentTypeName, dbo.RiskAssessments.RiskAssessmentID, 
             dbo.RiskAssessments.DateApplied, dbo.RiskAssessments.DateEntered,dbo.Addresses.AddressID, dbo.Addresses.City,
             dbo.Addresses.State, dbo.Addresses.Zip, dbo.Addresses.CountyID, dbo.Addresses.AddressLine1,
             p.DateOfBirth, dbo.Calc_Age(p.DateOfBirth, GETDATE()) AS Age, 
             dbo.StatusTypes.StatusTypeID, StatusTypes.Description AS EnrollmentStatusName,
            (Select top 1 Phone from dbo.PhoneNumbers ph 
             inner join dbo.PersonsToPhoneNumbers pp on pp.phoneNumberID = ph.PhoneNumberID
             inner join dbo.PhoneNumberTypes pt on pt.PhoneNumberTypeID = ph.PhoneNumberTypeID
						Where pp.PersonID = p.PersonID and pt.Name ='Home') AS HomePhone,
						 (Select Phone from dbo.PhoneNumbers ph 
             inner join dbo.PersonsToPhoneNumbers pp on pp.phoneNumberID = ph.PhoneNumberID
             inner join dbo.PhoneNumberTypes pt on pt.PhoneNumberTypeID = ph.PhoneNumberTypeID
						Where pp.PersonID = p.PersonID and pt.Name ='Cell') AS CellPhone,
                      (Select top 1 ph.phoneNumberID from dbo.PhoneNumbers ph 
             inner join dbo.PersonsToPhoneNumbers pp on pp.phoneNumberID = ph.PhoneNumberID
             inner join dbo.PhoneNumberTypes pt on pt.PhoneNumberTypeID = ph.PhoneNumberTypeID
						Where pp.PersonID = p.PersonID and pt.Name ='Home') AS HomePhoneID,
						 (Select top 1 ph.phoneNumberID from dbo.PhoneNumbers ph 
             inner join dbo.PersonsToPhoneNumbers pp on pp.phoneNumberID = ph.PhoneNumberID
             inner join dbo.PhoneNumberTypes pt on pt.PhoneNumberTypeID = ph.PhoneNumberTypeID
						Where pp.PersonID = p.PersonID and pt.Name ='Cell') AS CellPhoneID
FROM		 dbo.Persons p  left JOIN  
			 students s on s.personid = p.personid inner JOIN 
			 dbo.RiskAssessments ON dbo.RiskAssessments.PersonID = p.PersonID LEFT OUTER JOIN
             dbo.PersonsToAddresses ON p.Personid = dbo.PersonsToAddresses.Personid left outer join
             dbo.Addresses ON PersonsToAddresses.AddressID = dbo.Addresses.AddressID  Left outer  JOIN  
			 dbo.AddressTypes ON dbo.AddressTypes.AddressTypeID = dbo.Addresses.AddressTypeID   left outer JOIN  
             dbo.StatusTypes ON dbo.RiskAssessments.StatusTypeID = dbo.StatusTypes.StatusTypeID  
                      
 WHERE  dbo.RiskAssessments.ProgramId = @ProgramId
		AND (@EnrollmentTypeID IS NULL)
		AND (@SiteID is null OR dbo.RiskAssessments.SiteLocationID =@SiteID)
	--	AND (dbo.AddressTypes.Name is null OR dbo.AddressTypes.Name = 'Mailing')
		AND( @NoAttendance IS NULL OR (@NoAttendance = 1 AND (SELECT MAX(
		DateStart) FROM dbo.Classes c inner join dbo.ClassAttendances ca on ca.ClassID = c.ClassID 
		where ca.Student_PersonID = p.PersonID) < DateAdd(day, -90,getdate())))
		AND( @startGrantDate is null OR dbo.RiskAssessments.DateApplied >= @startGrantDate)
				 AND(@endGrantDate IS null OR dbo.RiskAssessments.DateApplied <= @endGrantDate)
		AND( @HasClassOverlap IS NULL OR (@HasClassOverlap = 1 AND( Select Count(*) 
                      FROM dbo.Classes c inner join dbo.CourseInstances ci on ci.CourseInstanceID = c.CourseInstanceID
                      inner join dbo.PersonsToCourseInstances pci on pci.CourseInstanceID = ci.CourseInstanceID
                      where pci.personid = p.Personid and c.DateEnd > @endGrantDate)>1))
		AND (dbo.RiskAssessments.RiskAssessmentID NOT IN (select RiskAssessmentID 
		from dbo.Enrollments where riskassessmentid  is not null))
		

END