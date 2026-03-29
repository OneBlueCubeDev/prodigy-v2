CREATE PROCEDURE dbo.spMaintenance_RegisterStudentsToClassesWithAttendance
AS
BEGIN
	INSERT INTO PersonsToCourseInstances
	  (
	    PersonID,
	    CourseInstanceID
	  )
	SELECT DISTINCT p.PersonID,
	       c.CourseInstanceID
	FROM   Persons                      AS p
	       INNER JOIN Students          AS s
	            ON  s.PersonID = p.PersonID
	       INNER JOIN ClassAttendances  AS ca
	            ON  ca.Student_PersonID = p.PersonID
	       INNER JOIN Classes           AS c
	            ON  c.ClassID = ca.ClassID
	       INNER JOIN CourseInstances   AS ci
	       INNER JOIN Courses           AS c2
	            ON  c2.CourseID = ci.CourseID
	            ON  ci.CourseInstanceID = c.CourseInstanceID
	       LEFT JOIN PersonsToCourseInstances AS ptci
	            ON  ptci.PersonID = p.PersonID
	            AND ptci.CourseInstanceID = c.CourseInstanceID
	WHERE  ptci.PersonID IS NULL
	       AND ptci.CourseInstanceID IS NULL
END
GO