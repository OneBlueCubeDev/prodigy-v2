using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using POD.Logic;
using Telerik.Web.UI;

namespace POD.Pages
{
    public partial class PATForms : System.Web.UI.Page
    {
        private int _personId
        {
            get { return Convert.ToInt32(txtPersonId.Text); }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                POD.MasterPages.Admin mtPage = (POD.MasterPages.Admin)this.Master;
                if (mtPage != null)
                {
                    mtPage.SetSearch("Enrollment");
                    mtPage.SetNavigation("Youth");
                }

                txtPersonId.Text = Request["id"];
                var p = PeopleLogic.GetPersonByID(_personId);
                if (p != null)
                {
                    lblPersonName.Text = p.FullName;
                }

                var personForms = PATFormLogic.GetPersonForms(_personId);
                if (personForms == null || personForms.Count == 0)
                {
                    Response.Redirect(string.Format("~/Pages/PATForm.aspx?personFormId={0}&personId={1}", 0, _personId));
                }

                if (Security.AuthorizeRoles("Administrators,CentralTeamUsers,SiteTeamUsers"))
                {
                    RadMenuItem deleteForm = RadMenuOptions.FindItemByText("Delete Form");
                    if (deleteForm != null)
                    {
                        deleteForm.Enabled = true;
                    }
                }

            }
        }

        protected void RadMenu1_ItemClick(object sender, RadMenuEventArgs e)
        {
            int radGridClickedRowIndex;
            POD.MasterPages.Admin mtPage = (POD.MasterPages.Admin)this.Master;
            radGridClickedRowIndex = Convert.ToInt32(Request.Form["radGridClickedRowIndex"]);
            string personFormId = patFormGrid.MasterTableView.DataKeyValues[radGridClickedRowIndex]["PersonFormId"].ToString();

            string url = string.Empty;
            switch (e.Item.Value)
            {
                case "Edit":
                    url = string.Format("~/Pages/PATForm.aspx?personFormId={0}&personId={1}", personFormId, _personId);
                    break;
                case "Delete":

                    PATFormLogic.DeletePersonForm(Convert.ToInt32(personFormId));
                    url = HttpContext.Current.Request.Url.ToString();

                    break;
            }
            if (!string.IsNullOrEmpty(url))
            {
                Response.Redirect(url);
            }
        }

        protected void patFormGrid_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            var personForms = PATFormLogic.GetPersonForms(_personId);
            patFormGrid.DataSource = personForms;
        }

        protected void NewButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Pages/PATForm.aspx?personFormId=0&personId=" + _personId.ToString());
        }
    }
}