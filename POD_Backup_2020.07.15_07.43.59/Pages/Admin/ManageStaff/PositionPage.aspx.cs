using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using POD.Data.Entities;

namespace POD.Pages.Admin.ManageStaff
{
    public partial class PositionPage : System.Web.UI.Page
    {
        protected int PositionID
        {
            get { return Convert.ToInt32(Request.QueryString["id"] ?? "0"); }
        }

        protected int ProgramID
        {
            get { return Convert.ToInt32(Session["ProgramID"] ?? "1"); }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Page.IsPostBack == false)
            {
                if (!IsPostBack)
                {
                    POD.MasterPages.AdminWide mtPage = (POD.MasterPages.AdminWide)this.Master;
                    if (mtPage != null)
                    {
                        mtPage.SetNavigation("Staff");
                    }
                }
                Bind();
            }

            LiteralError.Visible = false;    
        }

        private void Bind()
        {
            if (PositionID > 0)
            {
                var position = Logic.PeopleLogic.GetPositionByID(PositionID);
                if (position != null)
                {
                    TextBoxJobTitle.Text = position.JobTitle;
                    RadComboLocation.SelectedValue = position.LocationID != null
                                                         ? position.LocationID.Value.ToString()
                                                         : string.Empty;
                    RadComboPerson.SelectedValue = position.PersonID != null
                                                       ? position.PersonID.Value.ToString()
                                                       : string.Empty;
                    CheckBoxIsOpen.Checked = position.IsOpen;
                    RadDatePickerVacancy.SelectedDate = position.VacancyDate;
                }
            }
        }

        protected void ButtonSave_OnClick(object sender, EventArgs e)
        {
            int? locationId = string.IsNullOrEmpty(RadComboLocation.SelectedValue)
                                  ? (int?)null
                                  : Convert.ToInt32(RadComboLocation.SelectedValue);
            int? personId = string.IsNullOrEmpty(RadComboPerson.SelectedValue)
                                  ? (int?)null
                                  : Convert.ToInt32(RadComboPerson.SelectedValue);
            if (Page.IsValid)
            {
                int id = Logic.PeopleLogic.AddUpdatePosition(
                    PositionID,
                    CheckBoxIsOpen.Checked,
                    locationId,
                    ProgramID,
                    personId,
                    TextBoxJobTitle.Text,
                    RadDatePickerVacancy.SelectedDate);

                if (id == 0)
                {
                    LiteralError.Text = string.Format("<b style='color:red;'>An error occured trying to save the Position:{0}</b>", TextBoxJobTitle.Text);
                    LiteralError.Visible = true;
                }
                else
                {
                    Response.Redirect("PositionManagement.aspx");
                }
            }
        }
    }
}