using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using POD.Data.Entities;

namespace POD.UserControls
{
    public partial class AddPerson : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDropDowns();
            }
        }

        private void LoadDropDowns()
        {

            this.RadComboBoxStatus.DataSource = POD.Logic.ManageTypesLogic.GetTypesByType(Data.TypesData.Types.StatusType);
            this.RadComboBoxStatus.DataBind();
        }
        /// <summary>
        /// set enabled and validation group
        /// </summary>
        /// <param name="enabled"></param>
        /// <param name="validationGroup"></param>
        public void SetValidation(bool enabled)
        {
            this.RegularExpressionValidator1.Enabled = enabled;
            this.ReqValDOBPart.Enabled = enabled;
            this.ReqValFirstNamePart.Enabled = enabled;
            this.ReqValLastNamePart.Enabled = enabled;
            this.RequiredFieldValidator1.Enabled = enabled;
        }

        protected void ButtonAdd_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                var list = POD.Logic.PeopleLogic.GetPeopleByNameMatch(this.EnrollmentFirstNameTextBox.Text.Trim(), this.EnrollmentLastNameTextBox.Text.Trim(), this.RadDatePickerDOB.SelectedDate);
                if (list.Count > 0)
                {
                    this.DataListPersonMatches.DataSource = list;
                    this.DataListPersonMatches.DataBind();
                    this.PanelMatches.Visible = true;

                }
                else
                {
                    int statusID = 0;
                    int.TryParse(this.RadComboBoxStatus.SelectedValue, out statusID);
                    int typeid = 0;
                    typeid = POD.Logic.ManageTypesLogic.GetPersonTypeIDByName("non-student");
                    Person newPerson = POD.Logic.PeopleLogic.AddUpdatePerson(0, this.EnrollmentFirstNameTextBox.Text.Trim(), this.EnrollmentLastNameTextBox.Text.Trim(), this.EnrollmentMITextBox.Text.Trim(), this.RadDatePickerDOB.SelectedDate, this.EmailTextBox.Text.Trim(), statusID, typeid);
                    literalCloseWindow.Text = "<script  type='text/javascript' language='javascript'>returnToParent(" + newPerson.PersonID.ToString() + ");</script>";
                }
            }
        }

        protected void ButtonNew_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                int statusID = int.Parse(this.RadComboBoxStatus.SelectedValue);
                int typeid = 0;

                typeid = POD.Logic.ManageTypesLogic.GetPersonTypeIDByName("non-student");
                Person newPerson = POD.Logic.PeopleLogic.AddUpdatePerson(0, this.EnrollmentFirstNameTextBox.Text.Trim(), this.EnrollmentLastNameTextBox.Text.Trim(), this.EnrollmentMITextBox.Text.Trim(), this.RadDatePickerDOB.SelectedDate, this.EmailTextBox.Text.Trim(), statusID, typeid);
                literalCloseWindow.Text = "<script  type='text/javascript' language='javascript'>returnToParent(" + newPerson.PersonID.ToString() + ");</script>";

            }
        }

    }
}