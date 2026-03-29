CREATE VIEW dbo.vw_PersonsEnrollments
AS
SELECT     dbo.Persons.PersonID, dbo.Persons.DJJIDNum, dbo.Persons.FirstName, dbo.Persons.LastName, dbo.Persons.CompanyName, 
                      dbo.EnrollmentTypes.Name AS EnrollmentTypeName, dbo.Enrollments.EnrollmentID, dbo.Enrollments.DateApplied, dbo.Enrollments.DateAdmitted, 
                      dbo.Addresses.City, dbo.Addresses.State, dbo.Addresses.Zip, dbo.Addresses.CountyID, dbo.Addresses.AddressLine1, dbo.Persons.DateOfBirth, 
                      dbo.Calc_Age(dbo.Persons.DateOfBirth, GETDATE()) AS Age, dbo.StatusTypes.StatusTypeID, dbo.StatusTypes.Name AS EnrollmentStatusName, 
                      dbo.Persons.MiddleName, dbo.Programs.ProgramID
FROM         dbo.Programs INNER JOIN
                      dbo.Enrollments INNER JOIN
                      dbo.Persons ON dbo.Enrollments.PersonID = dbo.Persons.PersonID INNER JOIN
                      dbo.EnrollmentTypes ON dbo.Enrollments.EnrollmentTypeID = dbo.EnrollmentTypes.EnrollmentTypeID INNER JOIN
                      dbo.StatusTypes ON dbo.Enrollments.StatusTypeID = dbo.StatusTypes.StatusTypeID ON dbo.Programs.ProgramID = dbo.Enrollments.ProgramID LEFT OUTER JOIN
                      dbo.AddressTypes INNER JOIN
                      dbo.Addresses ON dbo.AddressTypes.AddressTypeID = dbo.Addresses.AddressTypeID INNER JOIN
                      dbo.PersonsToAddresses ON dbo.Addresses.AddressID = dbo.PersonsToAddresses.AddressID ON 
                      dbo.Persons.PersonID = dbo.PersonsToAddresses.PersonID
WHERE     (dbo.AddressTypes.Name = N'Mailing')
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_PersonsEnrollments';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'          DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Enrollments"
            Begin Extent = 
               Top = 80
               Left = 262
               Bottom = 289
               Right = 467
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
      Begin ColumnWidths = 9
         Width = 284
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
         Alias = 2400
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_PersonsEnrollments';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[51] 4[13] 2[20] 3) )"
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
         Begin Table = "AddressTypes"
            Begin Extent = 
               Top = 6
               Left = 945
               Bottom = 125
               Right = 1109
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "Addresses"
            Begin Extent = 
               Top = 1
               Left = 698
               Bottom = 174
               Right = 862
            End
            DisplayFlags = 280
            TopColumn = 5
         End
         Begin Table = "PersonsToAddresses"
            Begin Extent = 
               Top = 0
               Left = 450
               Bottom = 89
               Right = 610
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "EnrollmentTypes"
            Begin Extent = 
               Top = 176
               Left = 547
               Bottom = 295
               Right = 721
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "StatusTypes"
            Begin Extent = 
               Top = 143
               Left = 831
               Bottom = 262
               Right = 995
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Programs"
            Begin Extent = 
               Top = 224
               Left = 578
               Bottom = 283
               Right = 742
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Persons"
            Begin Extent = 
               Top = 3
               Left = 13
               Bottom = 321
               Right = 220
            End
  ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_PersonsEnrollments';

