CREATE VIEW dbo.vw_PersonEvents
AS
SELECT dbo.Persons.LastName,
       dbo.Persons.FirstName,
       dbo.Persons.MiddleName,
       dbo.PersonTypes.Name      AS PersonTypeName,
       dbo.Persons.PersonID,
       dbo.Events.EventID,
       dbo.Events.DateStart,
       dbo.EventAttendances.DateTimeStamp AS [AttendanceDate],
       dbo.Events.Name           AS EventName,
       dbo.Events.Description,
       dbo.Events.Notes,
       dbo.Locations.LocationID,
       dbo.Locations.Name        AS LocationName,
       Locations_1.Name          AS SiteLocationName,
       dbo.Sites.LocationID      AS SiteLocationID,
       dbo.EventAttendances.EventAttendanceID,
       dbo.Events.ProgramID
FROM   dbo.Sites
       INNER JOIN dbo.Locations  AS Locations_1
            ON  dbo.Sites.LocationID = Locations_1.LocationID
       RIGHT OUTER JOIN dbo.PersonTypes
       INNER JOIN dbo.Persons
            ON  dbo.PersonTypes.PersonTypeID = dbo.Persons.PersonTypeID
       INNER JOIN dbo.EventAttendances
            ON  dbo.Persons.PersonID = dbo.EventAttendances.PersonID
       INNER JOIN dbo.Events
            ON  dbo.EventAttendances.EventID = dbo.Events.EventID
            ON  dbo.Sites.LocationID = dbo.Events.SiteLocationID
       LEFT OUTER JOIN dbo.Locations
            ON  dbo.Events.LocationID = dbo.Locations.LocationID
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_PersonEvents';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'layFlags = 280
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
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 3480
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_PersonEvents';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[38] 4[25] 2[20] 3) )"
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
         Begin Table = "PersonTypes"
            Begin Extent = 
               Top = 15
               Left = 779
               Bottom = 134
               Right = 943
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "Persons"
            Begin Extent = 
               Top = 6
               Left = 487
               Bottom = 125
               Right = 694
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "Sites"
            Begin Extent = 
               Top = 131
               Left = 567
               Bottom = 250
               Right = 731
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Locations_1"
            Begin Extent = 
               Top = 165
               Left = 805
               Bottom = 224
               Right = 969
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Locations"
            Begin Extent = 
               Top = 86
               Left = 532
               Bottom = 145
               Right = 696
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Events"
            Begin Extent = 
               Top = 12
               Left = 269
               Bottom = 207
               Right = 433
            End
            DisplayFlags = 280
            TopColumn = 5
         End
         Begin Table = "EventAttendances"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 195
               Right = 222
            End
            Disp', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_PersonEvents';

