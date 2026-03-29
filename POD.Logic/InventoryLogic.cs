using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using POD.Data.Entities;

namespace POD.Logic
{
    public static class InventoryLogic
    {
        public static List<InventoryItem> GetInventory(string name, int? siteid, int? locid, int? typeid, string manuft, string serial, string org, string tag, string djjTag)
        {
            return POD.Data.InventoryData.GetInventory(name, siteid, locid, typeid, manuft, serial, org, tag, djjTag);
        }

        public static InventoryItem GetInventoryitemByID(int key)
        {
            return POD.Data.InventoryData.GetInventoryitemByID(key);
        }
        public static int AddUpdateInventoryItem(InventoryItem item)
        {
            return POD.Data.InventoryData.AddUpdateInventoryItem(item, Security.GetCurrentUserProfile().UserName);
        }
        public static string DeleteInventoryItem(int key)
        {
            return POD.Data.InventoryData.DeleteInventoryItem(key, Security.GetCurrentUserProfile().UserName);
        }
    }
}
