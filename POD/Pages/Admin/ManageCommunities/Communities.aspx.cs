using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using POD.Logic;
using Telerik.Web.UI;

namespace POD.Pages.Admin.ManageCommunities
{
    public partial class Communities : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //only admin and central admins can delete
                if (!Security.UserInRole("Administrators") && !Security.UserInRole("CentralTeamUsers"))
                {
                    this.RadContextMenuLP.Visible = false;
                    this.RadContextMenuCT.Visible = false;
                    this.RadMenuOptions.Visible = false;
                }
                else if (!Security.UserInRole("Administrators"))
                {
                    RadMenuItem item = this.RadMenuOptions.Items.FindItemByValue("DeleteCommunity");
                    if (item != null)
                    {
                        item.Visible = false;
                    }
                    item = this.RadContextMenuLP.Items.FindItemByValue("DeleteCircuit");
                    if (item != null)
                    {
                        item.Visible = false;
                    } item = this.RadContextMenuCT.Items.FindItemByValue("DeleteCounty");
                    if (item != null)
                    {
                        item.Visible = false;
                    }

                }
            }
        }

        protected void RadMenu1_ItemClick(object sender, Telerik.Web.UI.RadMenuEventArgs e)
        {
            int radGridClickedRowIndex;
            radGridClickedRowIndex = Convert.ToInt32(Request.Form["radGridClickedRowIndex"]);

            string url = string.Empty;
            string circuitid = string.Empty;
            int cID = 0;
            switch (e.Item.Value)
            {
                case "Circuit":
                    circuitid = RadGridCircuits.MasterTableView.DataKeyValues[radGridClickedRowIndex]["CircuitID"].ToString();
                    url = string.Format("~/Pages/Admin/ManageCommunities/CommunityPage.aspx?type=circuit&cid={0}", circuitid);
                    break;
                case "DeleteCircuit":
                    cID = 0;
                    circuitid = RadGridCircuits.MasterTableView.DataKeyValues[radGridClickedRowIndex]["CircuitID"].ToString();
                    int.TryParse(circuitid, out cID);
                    POD.Logic.ProgramCourseClassLogic.DeleteCircuit(cID);
                    RadGridCircuits.Rebind();
                    break;
                case "Community":
                    string communityID = RadGridCommunities.MasterTableView.DataKeyValues[radGridClickedRowIndex]["CommunityID"].ToString();
                    url = string.Format("~/Pages/Admin/ManageCommunities/CommunityPage.aspx?type=com&cid={0}", communityID);
                    break;
                case "DeleteCommunity":
                    circuitid = RadGridCommunities.MasterTableView.DataKeyValues[radGridClickedRowIndex]["CommunityID"].ToString();
                    int.TryParse(circuitid, out cID);
                    POD.Logic.ProgramCourseClassLogic.DeleteCommunity(cID);
                    RadGridCommunities.Rebind();
                    break;
                case "County":
                    string countyid = RadGridCounties.MasterTableView.DataKeyValues[radGridClickedRowIndex]["CountyID"].ToString();
                    url = string.Format("~/Pages/Admin/ManageCommunities/CommunityPage.aspx?type=county&cid={0}", countyid);
                    break;
                case "DeleteCounty":
                    circuitid = RadGridCounties.MasterTableView.DataKeyValues[radGridClickedRowIndex]["CountyID"].ToString();
                    int.TryParse(circuitid, out cID);
                    POD.Logic.ProgramCourseClassLogic.DeleteCounty(cID);
                    RadGridCounties.Rebind();
                    break;

            }
            if (!string.IsNullOrEmpty(url))
            {
                Response.Redirect(url);
            }
        }

        private void GiveSpacesToRadGridFilterMenu()
        {
            #region Counties
            GridFilterMenu menu = RadGridCounties.FilterMenu;
            foreach (RadMenuItem item in menu.Items)
            {
                if (item.Text == "NoFilter")
                {
                    item.Text = "No Filter";
                }


                if (item.Text == "DoesNotContain")
                {
                    item.Text = "Does Not Contain";
                }

                if (item.Text == "StartsWith")
                {
                    item.Text = "Starts With";
                }

                if (item.Text == "EndsWith")
                {
                    item.Text = "Ends With";
                }

                if (item.Text == "EqualTo")
                {
                    item.Text = "Equal To";
                }

                if (item.Text == "NotEqualTo")
                {
                    item.Text = "Not Equal To";
                }

                if (item.Text == "GreaterThan")
                {
                    item.Text = "Greater Than";
                }

                if (item.Text == "LessThan")
                {
                    item.Text = "Less Than";
                }

                if (item.Text == "GreaterThanOrEqualTo")
                {
                    item.Text = "Greater Than or Equal To";
                }

                if (item.Text == "LessThanOrEqualTo")
                {
                    item.Text = "Less Than or Equal To";
                }

                if (item.Text == "NotBetween")
                {
                    item.Text = "Not Between";
                }

                if (item.Text == "IsEmpty")
                {
                    item.Text = "Is Empty";
                }

                if (item.Text == "NotIsEmpty")
                {
                    item.Text = "Is Not Empty";
                }

                if (item.Text == "IsNull")
                {
                    item.Text = "Is Null";
                }

                if (item.Text == "NotIsNull")
                {
                    item.Text = "Is Not Null";
                }
            }
            #endregion
            #region Circuit
            menu = RadGridCircuits.FilterMenu;
            foreach (RadMenuItem it in menu.Items)
            {
                if (it.Text == "NoFilter")
                {
                    it.Text = "No Filter";
                }

                if (it.Text == "DoesNotContain")
                {
                    it.Text = "Does Not Contain";
                }

                if (it.Text == "StartsWith")
                {
                    it.Text = "Starts With";
                }
                if (it.Text == "EndsWith")
                {
                    it.Text = "Ends With";
                }

                if (it.Text == "EqualTo")
                {
                    it.Text = "Equal To";
                }

                if (it.Text == "NotEqualTo")
                {
                    it.Text = "Not Equal To";
                }
                if (it.Text == "GreaterThan")
                {
                    it.Text = "Greater Than";
                }

                if (it.Text == "LessThan")
                {
                    it.Text = "Less Than";
                }

                if (it.Text == "GreaterThanOrEqualTo")
                {
                    it.Text = "Greater Than or Equal To";
                }

                if (it.Text == "LessThanOrEqualTo")
                {
                    it.Text = "Less Than or Equal To";
                }

                if (it.Text == "NotBetween")
                {
                    it.Text = "Not Between";
                }
                if (it.Text == "IsEmpty")
                {
                    it.Text = "Is Empty";
                }

                if (it.Text == "NotIsEmpty")
                {
                    it.Text = "Is Not Empty";
                }

                if (it.Text == "IsNull")
                {
                    it.Text = "Is Null";
                }

                if (it.Text == "NotIsNull")
                {
                    it.Text = "Is Not Null";
                }
            }
            #endregion
            #region Circuit
            menu = RadGridCommunities.FilterMenu;
            foreach (RadMenuItem it in menu.Items)
            {
                if (it.Text == "NoFilter")
                {
                    it.Text = "No Filter";
                }

                if (it.Text == "DoesNotContain")
                {
                    it.Text = "Does Not Contain";
                }

                if (it.Text == "StartsWith")
                {
                    it.Text = "Starts With";
                }
                if (it.Text == "EndsWith")
                {
                    it.Text = "Ends With";
                }

                if (it.Text == "EqualTo")
                {
                    it.Text = "Equal To";
                }

                if (it.Text == "NotEqualTo")
                {
                    it.Text = "Not Equal To";
                }
                if (it.Text == "GreaterThan")
                {
                    it.Text = "Greater Than";
                }

                if (it.Text == "LessThan")
                {
                    it.Text = "Less Than";
                }

                if (it.Text == "GreaterThanOrEqualTo")
                {
                    it.Text = "Greater Than or Equal To";
                }

                if (it.Text == "LessThanOrEqualTo")
                {
                    it.Text = "Less Than or Equal To";
                }

                if (it.Text == "NotBetween")
                {
                    it.Text = "Not Between";
                }
                if (it.Text == "IsEmpty")
                {
                    it.Text = "Is Empty";
                }

                if (it.Text == "NotIsEmpty")
                {
                    it.Text = "Is Not Empty";
                }

                if (it.Text == "IsNull")
                {
                    it.Text = "Is Null";
                }

                if (it.Text == "NotIsNull")
                {
                    it.Text = "Is Not Null";
                }
            }
            #endregion
        }

        protected void RadGridCounties_Init(object sender, EventArgs e)
        {
            GridFilterMenu menu = RadGridCounties.FilterMenu;
            int i = 0;
            while (i < menu.Items.Count)
            {
                if (menu.Items[i].Text == "NoFilter" ||
                   menu.Items[i].Text == "Contains" ||
                   menu.Items[i].Text == "DoesNotContain" ||
                   menu.Items[i].Text == "StartsWith" ||
                   menu.Items[i].Text == "EndsWith" ||
                   menu.Items[i].Text == "EqualTo" ||
                   menu.Items[i].Text == "NotEqualTo" ||
                   menu.Items[i].Text == "GreaterThanOrEqualTo" ||
                   menu.Items[i].Text == "LessThanOrEqualTo"
                   )
                {
                    i++;
                }
                else
                {
                    menu.Items.RemoveAt(i);
                }
            }
        }

        protected void RadGridCommunities_Init(object sender, EventArgs e)
        {
            GridFilterMenu menu = RadGridCommunities.FilterMenu;
            int i = 0;
            while (i < menu.Items.Count)
            {
                if (menu.Items[i].Text == "NoFilter" ||
                   menu.Items[i].Text == "Contains" ||
                   menu.Items[i].Text == "DoesNotContain" ||
                   menu.Items[i].Text == "StartsWith" ||
                   menu.Items[i].Text == "EndsWith" ||
                   menu.Items[i].Text == "EqualTo" ||
                   menu.Items[i].Text == "NotEqualTo" ||
                   menu.Items[i].Text == "GreaterThanOrEqualTo" ||
                   menu.Items[i].Text == "LessThanOrEqualTo"
                   )
                {
                    i++;
                }
                else
                {
                    menu.Items.RemoveAt(i);
                }
            }
        }

        protected void RadGridCircuits_Init(object sender, EventArgs e)
        {
            GridFilterMenu menu = RadGridCircuits.FilterMenu;
            int i = 0;
            while (i < menu.Items.Count)
            {
                if (menu.Items[i].Text == "NoFilter" ||
                   menu.Items[i].Text == "Contains" ||
                   menu.Items[i].Text == "DoesNotContain" ||
                   menu.Items[i].Text == "StartsWith" ||
                   menu.Items[i].Text == "EndsWith" ||
                   menu.Items[i].Text == "EqualTo" ||
                   menu.Items[i].Text == "NotEqualTo" ||
                   menu.Items[i].Text == "GreaterThanOrEqualTo" ||
                   menu.Items[i].Text == "LessThanOrEqualTo"
                   )
                {
                    i++;
                }
                else
                {
                    menu.Items.RemoveAt(i);
                }
            }
        }
    }
}