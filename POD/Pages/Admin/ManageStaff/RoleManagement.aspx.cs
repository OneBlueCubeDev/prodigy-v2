using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using POD.Logging;
using POD.Logic;
using Telerik.Web.UI;

namespace POD.Pages.Admin.ManageStaff
{
    public partial class RoleManagement : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void RadGridRoles_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            if (e.CommandName == "Insert")
            {
                e.Canceled = true; //  Response.Redirect("TagTypeForm.aspx?Mode=Insert");
            }
            if (e.CommandName == "Delete")
            {
                GridDataItem item = (GridDataItem)e.Item;
                string roleName = item["NameColumn"].Text;
                try
                {
                    string result = POD.Logic.Security.DeleteRole(roleName);
                    if (!string.IsNullOrEmpty(result))
                    {
                        LiteralError.Text = string.Format("<b style='color:red;'>An error occured trying to delete Role:{0}</b><br/>Message:{1}", roleName, result);
                        LiteralError.Visible = true;
                    }
                }
                catch (Exception ex)
                {
                    ex.Log();
                    e.Canceled = true;
                }
            }
        }


        protected void Panel_AjaxRequest(object sender, AjaxRequestEventArgs e)
        {
            if (e.Argument == "Rebind")
            {
                RadGridRoles.MasterTableView.SortExpressions.Clear();
                RadGridRoles.Rebind();
            }

        }
        protected void RadGridRoles_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            grid.DataSource = POD.Logic.Security.GetRolesList().Select(r => new { Name = r });
        }

        protected void RadGridRoles_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item.ItemType == GridItemType.Item || e.Item.ItemType == GridItemType.AlternatingItem)
            {
                //if not admin then no deleting or adding positions
                if (!Security.UserInRole("Administrators"))
                {
                    e.Item.OwnerTableView.Columns.FindByUniqueName("DeleteColumn").Visible = false;

                }
            }
        }
    }
}