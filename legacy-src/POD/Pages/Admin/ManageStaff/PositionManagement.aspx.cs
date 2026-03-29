using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using POD.Logic;
using Telerik.Web.UI;

namespace POD.Pages.Admin.ManageStaff
{
    public partial class PositionManagement : System.Web.UI.Page
    {
        protected int ProgramID
        {
            get { return Convert.ToInt32(Session["ProgramID"] ?? "1"); }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            LiteralError.Visible = false;
            if (!IsPostBack)
            {
                POD.MasterPages.AdminWide mtPage = (POD.MasterPages.AdminWide)this.Master;
                if (mtPage != null)
                {
                    mtPage.SetNavigation("Staff");
                }
            }
        }

        protected void RadGridPositions_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            var grid = (RadGrid)sender;
            grid.DataSource = Logic.PeopleLogic
                .GetPositionsBySearch(programId: ProgramID);
        }

        protected void RadGridPositions_ItemCommand(object sender, GridCommandEventArgs e)
        {
            var item = e.Item as GridDataItem;
            if (item != null)
            {
                int id = Convert.ToInt32(item.GetDataKeyValue("PositionID"));
                string title = item["JobTitleColumn"].Text;
                if (e.CommandName == "Modify")
                {
                    Response.Redirect(string.Format("PositionPage.aspx?id={0}", id), false);
                }
                else if (e.CommandName == "Delete")
                {
                    string message;
                    if (Logic.PeopleLogic.DeletePosition(id, out message) == false)
                    {
                        LiteralError.Text = string.Format("<b style='color:red;'>An error occured trying to delete Position:{0}</b><br/>Message:{1}", title, message);
                        LiteralError.Visible = true;
                    }
                }
            }
        }

        protected void RadGridPositions_ItemDataBound(object sender, GridItemEventArgs e)
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