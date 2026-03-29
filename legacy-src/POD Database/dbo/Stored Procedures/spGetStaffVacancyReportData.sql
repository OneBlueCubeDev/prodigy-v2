



CREATE PROCEDURE [dbo].[spGetStaffVacancyReportData]
	@programId INT,
	@siteLocationId INT = NULL
AS
	SELECT c2.CircuitID,
	       c2.Name       AS [CircuitName],
	       p2.FirstName,
	       p2.MiddleName,
	       p2.LastName,
	       p.JobTitle,
	       sm.HireDate,
		   CASE 
				WHEN sm.HireDate < p.VacancyDate THEN p.VacancyDate
				ELSE NULL
		   END      AS VacancyDate,
	       s.LocationID  AS [SiteLocationID],
	       s.Organization
	FROM   Positions p
	       INNER JOIN Locations l
	            ON  l.LocationID = p.LocationID
	       INNER JOIN Sites s
	            ON  s.LocationID = l.LocationID OR s.LocationID = l.SiteLocationID
	       LEFT JOIN StaffMembers sm
	            ON  sm.PersonID = p.PersonID
	       LEFT JOIN Persons p2
	            ON  p2.PersonID = sm.PersonID
	       LEFT JOIN Addresses a
	            ON  a.AddressID = l.AddressID
	       LEFT JOIN Counties c
	            ON  c.CountyID = a.CountyID
	       LEFT JOIN Circuits c2
	            ON  c2.CircuitID = c.CircuitID
	WHERE  p.ProgramID = @programId
	       AND (s.LocationID = @siteLocationId OR @siteLocationId IS NULL)
	       AND (p.IsOpen = 1)
	ORDER BY p2.LastName, p2.FirstName