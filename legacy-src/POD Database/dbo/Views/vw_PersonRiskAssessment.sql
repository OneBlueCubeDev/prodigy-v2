
CREATE VIEW [dbo].[vw_PersonRiskAssessment]
AS
SELECT     dbo.Persons.PersonID, dbo.Persons.DJJIDNum, dbo.Persons.FirstName, dbo.Persons.LastName, dbo.Persons.CompanyName, dbo.Addresses.City, 
                      dbo.Addresses.State, dbo.Addresses.Zip, dbo.Addresses.CountyID, dbo.Addresses.AddressLine1, dbo.Persons.DateOfBirth, dbo.Calc_Age(dbo.Persons.DateOfBirth, 
                      GETDATE()) AS Age, dbo.Persons.MiddleName, dbo.Programs.ProgramID, dbo.RiskAssessments.RiskAssessmentID, dbo.RiskAssessments.DateApplied, 
                      dbo.RiskAssessments.SiteLocationID, dbo.AddressTypes.Name AS AddressTypeName, dbo.RiskAssessments.DateCreated, dbo.RiskAssessments.DateEntered, 
                      dbo.RiskAssessments.StatusTypeID, dbo.StatusTypes.Name AS StatusTypeName
FROM         dbo.Persons INNER JOIN
                      dbo.Programs INNER JOIN
                      dbo.RiskAssessments ON dbo.Programs.ProgramID = dbo.RiskAssessments.ProgramID ON 
                      dbo.Persons.PersonID = dbo.RiskAssessments.PersonID LEFT OUTER JOIN
                      dbo.StatusTypes ON dbo.RiskAssessments.StatusTypeID = dbo.StatusTypes.StatusTypeID LEFT OUTER JOIN
                      dbo.AddressTypes INNER JOIN
                      dbo.Addresses ON dbo.AddressTypes.AddressTypeID = dbo.Addresses.AddressTypeID INNER JOIN
                      dbo.PersonsToAddresses ON dbo.Addresses.AddressID = dbo.PersonsToAddresses.AddressID ON dbo.Persons.PersonID = dbo.PersonsToAddresses.PersonID
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_PersonRiskAssessment';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'        DisplayFlags = 344
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
         Column = 2100
         Alias = 3765
         Table = 2985
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_PersonRiskAssessment';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[36] 4[26] 2[20] 3) )"
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
         Begin Table = "Persons"
            Begin Extent = 
               Top = 9
               Left = 282
               Bottom = 110
               Right = 489
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Programs"
            Begin Extent = 
               Top = 45
               Left = 666
               Bottom = 164
               Right = 830
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RiskAssessments"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 298
               Right = 242
            End
            DisplayFlags = 280
            TopColumn = 51
         End
         Begin Table = "StatusTypes"
            Begin Extent = 
               Top = 138
               Left = 425
               Bottom = 257
               Right = 589
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AddressTypes"
            Begin Extent = 
               Top = 5
               Left = 958
               Bottom = 124
               Right = 1122
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "Addresses"
            Begin Extent = 
               Top = 3
               Left = 723
               Bottom = 122
               Right = 887
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "PersonsToAddresses"
            Begin Extent = 
               Top = 7
               Left = 527
               Bottom = 96
               Right = 687
            End
    ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_PersonRiskAssessment';

