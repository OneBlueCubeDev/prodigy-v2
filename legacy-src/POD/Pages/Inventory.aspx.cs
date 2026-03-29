using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using POD.Data.Entities;
using POD.Logic;

namespace POD.Pages
{
    public partial class Inventory : System.Web.UI.Page
    {
        Dictionary<string, string> searchParm;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                POD.MasterPages.Admin mtPage = (POD.MasterPages.Admin)this.Master;
                if (mtPage != null)
                {
                    mtPage.SetSearch("Inventory");
                    mtPage.SetNavigation("Inventory");
                }
                if (!Security.UserInRole("Administrators") && 
                 !Security.UserInRole("CentralTeamUsers") && !Security.UserInRole("SiteTeamUsers"))
                {
                    RadMenuItem item = this.RadMenuOptions.Items.FindItemByValue("Delete");
                    if (item != null)
                    {
                        item.Visible = false;
                    }
                }
            }
        }

        /// <summary>
        /// returns data for grid filterd by parameters
        /// </summary>
        /// <param name="searchParm"></param>
        /// <returns></returns>
        private List<InventoryItem> GetData()
        {
            //search parameters
            if (!string.IsNullOrEmpty(Request.QueryString["sc"]))
            {
                searchParm = POD.Logic.Utilities.GetSearchFilters(Request.QueryString["sc"].ToString(), "Inventory");
            }
            else
            {
                searchParm = POD.Logic.Utilities.SetDefaultSearchFilters("Inventory");
            }
            List<InventoryItem> list = new List<InventoryItem>();
            int? locID = null;
            int? typeid = null;
            if (searchParm["Loc"] != "-1")
            {
                locID = int.Parse(searchParm["Loc"].ToString());
            }
            if (searchParm["Type"] != "-1")
            {
                typeid = int.Parse(searchParm["Type"].ToString());
            }
            int? siteid = null;
            if (!Security.UserInRole("Administrators") && !Security.UserInRole("Administrators-NA") && !Security.UserInRole("CentralTeamUsers") && !Security.UserInRole("CentralTeamUsers-NA"))
            {
                siteid = int.Parse(Session["UsersSiteID"].ToString());
            }
            list = POD.Logic.InventoryLogic.GetInventory(searchParm["Name"] != "-1" ? searchParm["Name"].ToString() : string.Empty,siteid, locID, typeid, searchParm["Man"] != "-1" ? searchParm["Man"].ToString() : string.Empty,
                                                    searchParm["Serial"] != "-1" ? searchParm["Serial"].ToString() : string.Empty, searchParm["Org"] != "-1" ? searchParm["Org"].ToString() : string.Empty,
                                                    searchParm["Tag"] != "-1" ? searchParm["Tag"].ToString() : string.Empty, searchParm["DJJTag"] != "-1" ? searchParm["DJJTag"].ToString() : string.Empty);

            return list;

        }
        
        protected void RadMenu1_ItemClick(object sender, RadMenuEventArgs e)
        {
            int radGridClickedRowIndex;
            
            radGridClickedRowIndex = Convert.ToInt32(Request.Form["radGridClickedRowIndex"]);
            string invID = RadGridInventory.MasterTableView.DataKeyValues[radGridClickedRowIndex]["InventoryItemID"].ToString();
           string url = string.Empty;
            switch (e.Item.Value)
            {
                case "EditItem":
                    url = string.Format("~/Pages/InventoryItemPage.aspx?id={0}", invID);
                    break;
                 case "Delete":
                    if (!string.IsNullOrEmpty(invID))
                    {
                        POD.Logic.InventoryLogic.DeleteInventoryItem(int.Parse(invID));
                        RadGridInventory.Rebind();
                    }
                    break;
            }
            if (!string.IsNullOrEmpty(url))
            {
                Response.Redirect(url);
            }
        }

        protected void RadGridInventory_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            grid.DataSource = GetData();
            
        }
    }
}