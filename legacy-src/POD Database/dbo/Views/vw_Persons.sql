

/************************************************************
 * Code formatted by SoftTree SQL Assistant © v6.2.112
 * Time: 10/12/2012 12:07:22 PM
 ************************************************************/
CREATE VIEW [dbo].[vw_Persons]
AS
SELECT p.PersonID,
       p.DJJIDNum,
       p.FirstName,
       p.LastName,
       p.MiddleName,
       p.Email,
       --p.Title,
       --p.CompanyName,
       --p.Salutation,
       --p.Honorific,
       g.Name AS [GenderName],
       p.SocialSecurityNumber,
       p.DateOfBirth,
       p.PrimaryLanguageSpoken,
       p.OtherLanguagesSpoken,
       st.Name                          AS StatusName,
       c.Name                           AS CommunityName,
       l.Name                           AS LocationName,
       c2.Name                          AS CountyName
       --p.Notes
FROM   dbo.Persons                      AS p
       LEFT OUTER JOIN dbo.Communities  AS c
            ON  c.CommunityID = p.CommunityID
       LEFT OUTER JOIN dbo.Locations    AS l
            ON  l.LocationID = p.LocationID
       LEFT OUTER JOIN dbo.Counties     AS c2
            ON  c2.CountyID = p.CountyID
       LEFT OUTER JOIN dbo.StatusTypes  AS st
            ON  st.StatusTypeID = p.StatusTypeID
       LEFT JOIN Genders g
            ON  g.GenderID = p.GenderID
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_Persons';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'  Output = 720
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_Persons';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
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
         Begin Table = "p"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 259
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s"
            Begin Extent = 
               Top = 6
               Left = 297
               Bottom = 135
               Right = 512
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 550
               Bottom = 135
               Right = 724
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "l"
            Begin Extent = 
               Top = 6
               Left = 762
               Bottom = 135
               Right = 936
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c2"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 267
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "st"
            Begin Extent = 
               Top = 138
               Left = 250
               Bottom = 267
               Right = 424
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
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
       ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_Persons';

