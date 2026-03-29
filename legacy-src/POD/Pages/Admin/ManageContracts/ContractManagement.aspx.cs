using System;
using System.Web.UI;
using POD.Logic;
using Telerik.Web.UI;

namespace POD.Pages.Admin.ManageContracts
{
    public partial class ContractManagement : Page
    {
        protected int ProgramID
        {
            get { return Convert.ToInt32(Session["ProgramID"] ?? "1"); }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            LiteralError.Visible = false;
        }

        protected void RadGridContracts_ItemCommand(object sender, GridCommandEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                var item = (GridDataItem)e.Item;
                int id = Convert.ToInt32(item.GetDataKeyValue("ContractID"));
                string title = item["ContractNumberColumn"].Text;
                if (e.CommandName == "Modify")
                {
                    Response.Redirect(string.Format("ContractPage.aspx?id={0}", id), false);
                }
                else if (e.CommandName == "Delete")
                {
                    string message;
                    if (ContractLogic.DeleteContract(id, out message) == false)
                    {
                        LiteralError.Text =
                            string.Format(
                                "<b style='color:red;'>An error occured trying to delete Contract:{0}</b><br/>Message:{1}",
                                title, message);
                        LiteralError.Visible = true;
                    }
                }
            }
        }

        protected DateTime? FilterToDate(string filter)
        {
            DateTime dt;
            if (DateTime.TryParse(filter, out dt))
            {
                return dt;
            }

            return null;
        }

        protected void RadGridContracts_OnNeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            var grid = (RadGrid)sender;
            grid.DataSource = ContractLogic.GetContractsBySearch();
        }

        private void GiveSpacesToRadGridFilterMenu()
        {
            GridFilterMenu menu = RadGridContracts.FilterMenu;
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

        protected void RadGridContacts_Init(object sender, EventArgs e)
        {
            GridFilterMenu menu = RadGridContracts.FilterMenu;
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

        protected void RadGridContracts_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item.ItemType == GridItemType.Item || e.Item.ItemType == GridItemType.AlternatingItem)
            {
                //if not admin then no deleting, eidting or adding quotas
                if (!Security.UserInRole("Administrators"))
                {
                    e.Item.OwnerTableView.Columns.FindByUniqueName("ModifyColumn").Visible = false;
                    e.Item.OwnerTableView.Columns.FindByUniqueName("DeleteColumn").Visible = false;

                }
            }
        }
    }
}