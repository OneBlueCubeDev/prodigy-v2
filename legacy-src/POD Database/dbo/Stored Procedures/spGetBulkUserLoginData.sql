
CREATE PROCEDURE [dbo].[spGetBulkUserLoginData]
AS
	SELECT p.PersonID,
	       au.UserName,
	       p.FirstName,
	       p.LastName,
	       p.Email,
	       l.Name AS [LocationName],
	       s.SiteName,
	       s.Organization
	FROM   Persons p
	       INNER JOIN StaffMembers sm
	            ON  sm.PersonID = p.PersonID
	       INNER JOIN aspnet_Users au
	            ON  au.UserId = sm.UserID
	       LEFT JOIN Locations l
	            ON  l.LocationID = p.LocationID
	       LEFT JOIN Sites s
	            ON  s.LocationID = l.SiteLocationID