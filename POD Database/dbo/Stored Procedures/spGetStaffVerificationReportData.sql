




CREATE PROCEDURE [dbo].[spGetStaffVerificationReportData]
	@organization NVARCHAR(255)
AS
DECLARE @statusActive INT

SELECT @statusActive = st.StatusTypeID
FROM   StatusTypes st
WHERE  st.Name = 'Active'
       AND st.Category = 'Common'


SELECT c2.Name  AS [CircuitName],
       p.FirstName,
       p.MiddleName,
       p.LastName,
       p.SocialSecurityNumber,
       p.DateOfBirth,
       p2.JobTitle,
       sm.HireDate,
       CASE 
            WHEN sm.HireDate < sm.EndDate THEN sm.EndDate
            ELSE NULL
       END      AS VacancyDate,
       s.Organization
FROM   Persons p
       INNER JOIN StaffMembers sm
            ON  sm.PersonID = p.PersonID
       INNER JOIN Persons ps
	        ON ps.PersonID = sm.PersonID
       LEFT JOIN Positions p2
            ON  p2.PersonID = sm.PersonID
       INNER JOIN Locations l
            ON  l.LocationID = COALESCE(p2.LocationID, p.LocationID)
       INNER JOIN Sites s
            ON  s.LocationID = COALESCE(l.SiteLocationID, l.LocationID)
       INNER JOIN Addresses a
            ON  a.AddressID = l.AddressID
       INNER JOIN Counties c
            ON  c.CountyID = COALESCE(a.CountyID, p.CountyID)
       INNER JOIN Circuits c2
            ON  c2.CircuitID = c.CircuitID
WHERE (s.Organization = @organization OR @organization IS NULL) AND ps.StatusTypeID = @statusActive
ORDER BY p.LastName, p.FirstName