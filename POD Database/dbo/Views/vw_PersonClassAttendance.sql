CREATE VIEW dbo.vw_PersonClassAttendance
AS
SELECT dbo.ClassAttendances.ClassAttendanceID,
       dbo.ClassAttendances.Tardy,
       dbo.ClassAttendances.LeftEarly,
       dbo.ClassAttendances.Notes,
       dbo.Classes.ClassID,
       dbo.Classes.DateStart AS [DateStart],
	   dbo.ClassAttendances.DateTimeStamp AS [AttendanceDate],
       dbo.Locations.Name        AS LocationName,
       dbo.Locations.LocationID,
       dbo.Classes.Name          AS ClassName,
       dbo.Persons.LastName,
       dbo.Persons.FirstName,
       dbo.Persons.MiddleName,
       dbo.PersonTypes.Name      AS PersonTypeName,
       dbo.Persons.PersonID,
       Locations_1.Name          AS SiteLocationName,
       dbo.Sites.LocationID      AS SiteLocationID,
       dbo.Courses.ProgramID
FROM   dbo.ClassAttendances
       INNER JOIN dbo.Classes
            ON  dbo.ClassAttendances.ClassID = dbo.Classes.ClassID
       INNER JOIN dbo.Persons
            ON  dbo.ClassAttendances.Student_PersonID = dbo.Persons.PersonID
       INNER JOIN dbo.PersonTypes
            ON  dbo.Persons.PersonTypeID = dbo.PersonTypes.PersonTypeID
       INNER JOIN dbo.CourseInstances
            ON  dbo.Classes.CourseInstanceID = dbo.CourseInstances.CourseInstanceID
       INNER JOIN dbo.Courses
            ON  dbo.CourseInstances.CourseID = dbo.Courses.CourseID
       LEFT OUTER JOIN dbo.Locations
            ON  dbo.Classes.SpecificLocationID = dbo.Locations.LocationID
       LEFT OUTER JOIN dbo.Sites
       INNER JOIN dbo.Locations  AS Locations_1
            ON  dbo.Sites.LocationID = Locations_1.LocationID
            ON  dbo.Classes.SiteLocationID = dbo.Sites.LocationID
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_PersonClassAttendance';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'   DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Sites"
            Begin Extent = 
               Top = 117
               Left = 725
               Bottom = 227
               Right = 889
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Locations_1"
            Begin Extent = 
               Top = 0
               Left = 1128
               Bottom = 59
               Right = 1292
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 10
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1200
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3156
         Alias = 1488
         Table = 1512
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_PersonClassAttendance';




GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[44] 4[26] 2[14] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[41] 4[33] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ClassAttendances"
            Begin Extent = 
               Top = 12
               Left = 5
               Bottom = 220
               Right = 186
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Classes"
            Begin Extent = 
               Top = 2
               Left = 303
               Bottom = 215
               Right = 495
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Persons"
            Begin Extent = 
               Top = 244
               Left = 80
               Bottom = 414
               Right = 287
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "PersonTypes"
            Begin Extent = 
               Top = 297
               Left = 272
               Bottom = 416
               Right = 436
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "CourseInstances"
            Begin Extent = 
               Top = 259
               Left = 506
               Bottom = 378
               Right = 687
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "Courses"
            Begin Extent = 
               Top = 245
               Left = 778
               Bottom = 364
               Right = 942
            End
            DisplayFlags = 280
            TopColumn = 5
         End
         Begin Table = "Locations"
            Begin Extent = 
               Top = 8
               Left = 663
               Bottom = 127
               Right = 827
            End
         ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_PersonClassAttendance';



