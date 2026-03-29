using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using POD.Data.Entities;
using POD.Logging;

namespace POD.Data
{
    public static class InventoryData
    {
        public static List<InventoryItem> GetInventory(string name, int? siteid,  int? locid, int? typeid, string manuft, string serial, string org, string tag, string djjTag)
        {
            List<InventoryItem> items = new List<InventoryItem>();
            using (PODContext context = new PODContext())
            {
                items = context.InventoryItems.Include(x => x.InventoryItemType).Include(x => x.Location).ToList();
                if (siteid.HasValue)
                {
                    items = items.Where(i => i.LocationID.HasValue && i.Location.SiteLocationID == siteid.Value || i.LocationID.HasValue && i.LocationID == siteid).ToList();
                }
                if (!string.IsNullOrEmpty(name))
                {
                    items = items.Where(i =>  i.Name.ToLower().Contains(name)).ToList();
                }
                if (!string.IsNullOrEmpty(manuft))
                {
                    items = items.Where(i => i.Manufacturer.ToLower().Contains(manuft)).ToList();
                }
                if (!string.IsNullOrEmpty(serial))
                {
                    items = items.Where(i => i.SerialNum.ToLower().Contains(serial)).ToList();
                }
                if (!string.IsNullOrEmpty(org))
                {
                    items = items.Where(i => i.Organization.ToLower().Contains(org)).ToList();
                }
                if (!string.IsNullOrEmpty(djjTag))
                {
                    items = items.Where(i => i.DJJTagNum.ToLower().Contains(djjTag)).ToList();
                }
                if (!string.IsNullOrEmpty(tag))
                {
                    items = items.Where(i => i.UACDCTagNum.ToLower().Contains(tag)).ToList();
                }

                if (locid.HasValue)
                {
                    items = items.Where(i => i.Location.LocationID == locid.Value).ToList();
                }
                if (typeid.HasValue)
                {
                    items = items.Where(i => i.InventoryItemType.InventoryItemTypeID == typeid.Value).ToList();
                }
            }
            return items;

        }

        public static InventoryItem GetInventoryitemByID(int key)
        {

            using (PODContext context = new PODContext())
            {
                return context.InventoryItems.Include(x => x.InventoryItemType).Include(x => x.Location).FirstOrDefault(i => i.InventoryItemID == key);
                            }
        }


        public static int AddUpdateInventoryItem(InventoryItem item, string username)
        {
            int newInvItem = 0;
            bool isAdd = false;
            using (PODContext context = new PODContext())
            {
                try
                {
                    InventoryItem invItem = context.InventoryItems.FirstOrDefault(e => e.InventoryItemID == item.InventoryItemID);
                    if (invItem == null)
                    {
                        isAdd = true;
                        invItem = new InventoryItem();
                        invItem.rowguid = Guid.NewGuid();
                        invItem.DateTimeStamp = DateTime.Now;

                    }
                    invItem.Name = item.Name;
                    invItem.Description = item.Description;
                    invItem.Organization = item.Organization;
                    invItem.Manufacturer = item.Manufacturer;
                    invItem.Model = item.Model;
                    invItem.Organization = item.Organization;
                    invItem.SerialNum = item.SerialNum;
                    invItem.UACDCTagNum = item.UACDCTagNum;
                    invItem.DJJTagNum = item.DJJTagNum;
                    invItem.AcquisitionCost = item.AcquisitionCost;
                    invItem.AcquisitionDate = item.AcquisitionDate;
                    invItem.Condition = item.Condition;
                    invItem.Comments = item.Comments;
                    invItem.LocationID = item.LocationID;
                    invItem.InventoryItemTypeID = item.InventoryItemTypeID;
                    invItem.Room = item.Room;
                    invItem.LastModifiedBy = username;
                    if (isAdd)
                    {
                        context.InventoryItems.AddObject(invItem);
                    }
                    context.SaveChanges();
                    newInvItem = invItem.InventoryItemID;
                }
                catch (Exception ex)
                {
                    ex.Log();
                }
                return newInvItem;
            }
        }

        public static string DeleteInventoryItem(int key, string username)
        {
            using (PODContext context = new PODContext())
            {
                try
                {
                    InventoryItem invItem = context.InventoryItems.FirstOrDefault(e => e.InventoryItemID == key);
                    if (invItem != null)
                    {
                        invItem.LastModifiedBy = username;
                        context.InventoryItems.DeleteObject(invItem);

                    }
                    context.SaveChanges();
                    return string.Empty;
                }
                catch (Exception ex)
                {
                    ex.Log();
                    return ex.Message;
                }
            }
        }
    }
}
