
CREATE VIEW [dbo].[vw_Classes]
AS
SELECT dbo.Classes.ClassID,
       dbo.Classes.DateStart,
       dbo.Classes.DateEnd,
       dbo.Classes.Name               AS ClassName,
       dbo.Locations.Name             AS LocationName,
       dbo.Sites.SiteName               AS SiteLocationName,
       COUNT(dbo.PersonsToCourseInstances.PersonID) AS PeopleAssignedToClass,
       dbo.CourseInstances.ProgramID,
       dbo.Persons.FirstName + N' ' + dbo.Persons.LastName AS 
       InstructorFullName,
       Persons_1.FirstName + N' ' + Persons_1.LastName AS AssistantFullName,
       dbo.Classes.SiteLocationID,
       dbo.Classes.SpecificLocationID,
       dbo.Classes.InstructorPersonID,
       dbo.Classes.AssistantPersonID,
       dbo.Classes.CurrentStatusTypeID,
       dbo.Classes.CourseInstanceID
FROM   dbo.PersonsToCourseInstances
       RIGHT OUTER JOIN dbo.Persons
       RIGHT OUTER JOIN dbo.Persons   AS Persons_1
       RIGHT OUTER JOIN dbo.Classes
       INNER JOIN dbo.CourseInstances
            ON  dbo.Classes.CourseInstanceID = dbo.CourseInstances.CourseInstanceID
       LEFT OUTER JOIN dbo.Locations
            ON  dbo.Classes.SpecificLocationID = dbo.Locations.LocationID
            ON  Persons_1.PersonID = dbo.Classes.AssistantPersonID
            ON  dbo.Persons.PersonID = dbo.Classes.InstructorPersonID
       LEFT OUTER JOIN dbo.Locations  AS Locations_1
       INNER JOIN dbo.Sites
            ON  Locations_1.LocationID = dbo.Sites.LocationID
            ON  dbo.Classes.SiteLocationID = dbo.Sites.LocationID
            ON  dbo.PersonsToCourseInstances.CourseInstanceID = dbo.CourseInstances.CourseInstanceID
GROUP BY
       dbo.Classes.ClassID,
       dbo.Classes.DateStart,
       dbo.Classes.DateEnd,
       dbo.Classes.Name,
       dbo.Locations.Name,
       dbo.Sites.SiteName,
       Locations_1.Name,
       dbo.CourseInstances.ProgramID,
       dbo.Persons.FirstName + N' ' + dbo.Persons.LastName,
       Persons_1.FirstName + N' ' + Persons_1.LastName,
       dbo.Classes.SiteLocationID,
       dbo.Classes.SpecificLocationID,
       dbo.Classes.InstructorPersonID,
       dbo.Classes.AssistantPersonID,
       dbo.Classes.CurrentStatusTypeID,
       dbo.Classes.CourseInstanceID
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_Classes';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'         DisplayFlags = 344
            TopColumn = 10
         End
         Begin Table = "Persons_1"
            Begin Extent = 
               Top = 163
               Left = 546
               Bottom = 436
               Right = 753
            End
            DisplayFlags = 344
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
         Width = 3030
         Width = 1905
         Width = 3210
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1770
         Alias = 2730
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_Classes';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[43] 4[18] 2[20] 3) )"
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
         Configuration = "(H (1[56] 4[18] 2) )"
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
         Begin Table = "Classes"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 316
               Right = 230
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CourseInstances"
            Begin Extent = 
               Top = 6
               Left = 268
               Bottom = 291
               Right = 449
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "PersonsToCourseInstances"
            Begin Extent = 
               Top = 0
               Left = 862
               Bottom = 89
               Right = 1038
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Sites"
            Begin Extent = 
               Top = 251
               Left = 285
               Bottom = 441
               Right = 445
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Locations"
            Begin Extent = 
               Top = 125
               Left = 463
               Bottom = 367
               Right = 627
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "Locations_1"
            Begin Extent = 
               Top = 237
               Left = 569
               Bottom = 469
               Right = 733
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "Persons"
            Begin Extent = 
               Top = 75
               Left = 451
               Bottom = 354
               Right = 658
            End
   ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_Classes';

