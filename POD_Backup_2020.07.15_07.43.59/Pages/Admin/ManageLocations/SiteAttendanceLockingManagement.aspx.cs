using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace POD.Pages.Admin.ManageLocations
{
    public partial class SiteAttendanceLockingManagement : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            this.LiteralMessage.Text = string.Empty;

        }

        protected void RadGridSites_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            grid.DataSource = POD.Logic.LookUpTypesLogic.GetSites();
        }

        private void GiveSpacesToRadGridFilterMenu()
        {
            GridFilterMenu menu = RadGridSites.FilterMenu;
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
        }

        protected void RadGridSites_Init(object sender, EventArgs e)
        {
            GridFilterMenu menu = RadGridSites.FilterMenu;
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

        protected void RadMenu_ItemClick(object sender, Telerik.Web.UI.RadMenuEventArgs e)
        {
            int radGridClickedRowIndex = Convert.ToInt32(Request.Form["radGridClickedRowIndex"]);

            string url = string.Empty;
            switch (e.Item.Value)
            {
                case "Edit":
                    string locationID = RadGridSites.MasterTableView.DataKeyValues[radGridClickedRowIndex]["LocationID"].ToString();
                    url = string.Format("~/Pages/Admin/ManageLocations/LocationPage.aspx?lid={0}&r=la", locationID);
                    break;
            }
            if (!string.IsNullOrEmpty(url))
            {
                Response.Redirect(url);
            }
        }

        /// <summary>
        /// updates all sites with same date
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Update_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                if (this.LockDatePicker.SelectedDate.HasValue)
                {
                    string result =
                        POD.Logic.LookUpTypesLogic.UpdateAttendanceLockedDate(this.LockDatePicker.SelectedDate.Value);
                    if (!string.IsNullOrEmpty(result))
                    {
                        this.LiteralMessage.Text = result;
                    }
                    else
                    {
                        RadGridSites.Rebind();
                    }
                }
            }
        }
    }

}