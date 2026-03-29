

CREATE PROCEDURE [dbo].[spGetInventoryReportData]
	@locationId INT = NULL
AS
	SELECT ii.InventoryItemID,
	       ii.SerialNum,
	       ii.Model,
	       ii.Manufacturer,
	       ii.[Description],
	       ii.AcquisitionCost,
	       ii.AcquisitionDate,
	       ii.Organization,
	       l.LocationID        AS [LocationID],
	       l.Name              AS [LocationName],
	       ii.UACDCTagNum,
	       ii.DJJTagNum,
	       ii.Condition,
	       ii.Comments
	FROM   InventoryItems ii
	       INNER JOIN Locations l
	            ON  l.LocationID = ii.LocationID
	WHERE  ii.LocationID = @locationId
	       OR  @locationId IS     NULL