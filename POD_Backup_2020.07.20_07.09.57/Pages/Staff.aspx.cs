using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using POD.Logic;

namespace POD.Pages.Admin.ManageStaff
{
    public partial class Staff : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                
                POD.MasterPages.AdminWide mtPage = (POD.MasterPages.AdminWide)this.Master;
                if (mtPage != null)
                {
                    mtPage.SetNavigation("Staff");
                }
                if (!Security.UserInRole("Administrators") &&
                   !Security.UserInRole("CentralTeamUsers") && !Security.UserInRole("SiteTeamUsers"))
                {
                    Response.Redirect("~/Pages/ControlPanel.aspx");
                    this.RadMenuOptions.Visible = false;
                }
            }
        }

        protected void RadGridStaffMembers_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            int? siteid = null;
            if (!Security.UserInRole("Administrators") && !Security.UserInRole("CentralTeamUsers"))
            {
                siteid = int.Parse(Session["UsersSiteID"].ToString());
            }
            RadGrid grid = (RadGrid)sender;
            grid.DataSource = POD.Logic.PeopleLogic.GetAllStaff(siteid);
        }
        private void GiveSpacesToRadGridFilterMenu()
        {
            GridFilterMenu menu = RadGridStaffMembers.FilterMenu;
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

        protected void RadGridStaffMembers_Init(object sender, EventArgs e)
        {
            GridFilterMenu menu = RadGridStaffMembers.FilterMenu;
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

        protected void RadMenu1_ItemClick(object sender, Telerik.Web.UI.RadMenuEventArgs e)
        {
            int radGridClickedRowIndex;
            radGridClickedRowIndex = Convert.ToInt32(Request.Form["radGridClickedRowIndex"]);

            string url = string.Empty;
            switch (e.Item.Value)
            {
                case "Edit":
                    string personid = RadGridStaffMembers.MasterTableView.DataKeyValues[radGridClickedRowIndex]["PersonID"].ToString();
                    url = string.Format("~/Pages/StaffMember.aspx?id={0}", personid);
                    break;
                case "Delete":
                    int cID = 0;
                    string personidString = RadGridStaffMembers.MasterTableView.DataKeyValues[radGridClickedRowIndex]["PersonID"].ToString();
                    int.TryParse(personidString, out cID);
                    POD.Logic.PeopleLogic.DeleteStaff(cID);
                    RadGridStaffMembers.Rebind();
                    break;
            }
            if (!string.IsNullOrEmpty(url))
            {
                Response.Redirect(url);
            }

        }
    }
}