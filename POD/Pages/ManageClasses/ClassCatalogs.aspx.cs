using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using POD.Logic;
using Telerik.Web.UI;

namespace POD.Pages.ManageClasses
{
    public partial class ClassCatalogs : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                POD.MasterPages.AdminWide mtPage = (POD.MasterPages.AdminWide)this.Master;
                if (mtPage != null)
                {
                    mtPage.SetNavigation("Class");
                }
                this.ClassesLinks1.SetVisibility(true, true);

                //only admin and central admins can delete
                if (!Security.UserInRole("Administrators") && !Security.UserInRole("Administrators-NA") &&
                    !Security.UserInRole("CentralTeamUsers;") && !Security.UserInRole("SiteTeamUsers"))
                {
                    RadMenuItem deleteItem = this.RadMenuOptions.Items.FindItemByValue("DeleteClass");
                    if (deleteItem != null)
                    {
                        deleteItem.Visible = false;
                    }
                }
            }

        }
        protected void RadMenu1_ItemClick(object sender, RadMenuEventArgs e)
        {
            int radGridClickedRowIndex;
            radGridClickedRowIndex = Convert.ToInt32(Request.Form["radGridClickedRowIndex"]);

            string url = string.Empty;
            switch (e.Item.Value)
            {
                case "CourseInstances":
                    string courseID = RadGridCourses.MasterTableView.DataKeyValues[radGridClickedRowIndex]["CourseID"].ToString();
                    url = string.Format("~/Pages/ManageClasses/ClassDetailPage.aspx?cid={0}", courseID);
                    break;
                case "DeleteClass":
                    int cID = 0;
                    string courseStringID = RadGridCourses.MasterTableView.DataKeyValues[radGridClickedRowIndex]["CourseID"].ToString();
                    int.TryParse(courseStringID, out cID);
                    POD.Logic.ProgramCourseClassLogic.DeleteCourse(cID);
                    RadGridCourses.Rebind();
                    break;
            }
            if (!string.IsNullOrEmpty(url))
            {
                Response.Redirect(url);
            }

        }

        protected void RadGridCourses_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            int progid = 0;
            int.TryParse(Session["ProgramID"].ToString(), out progid);

            grid.DataSource = POD.Logic.ProgramCourseClassLogic.GetCoursesByProgramID(progid);
        }

        private void GiveSpacesToRadGridFilterMenu()
        {
            GridFilterMenu menu = RadGridCourses.FilterMenu;
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

        protected void RadGridCourses_Init(object sender, EventArgs e)
        {
            GridFilterMenu menu = RadGridCourses.FilterMenu;
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