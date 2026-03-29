using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using POD.Logic;
using Telerik.Web.UI;
using POD.Data.Entities;

namespace POD.Pages
{
    public partial class MyAccount : System.Web.UI.Page
    {
        private int personid = 0;
        int phoneTypeKey;
        int cellPhoneTypeID;
        int homephonetype;
        int addressTypeid;
        StaffMember currentPerson;
        private int PersonID
        {
            get
            {
                if (ViewState["PersonID"] != null)
                {
                    int.TryParse(ViewState["PersonID"].ToString(), out personid);
                }
                return personid;
            }
            set
            {
                ViewState["PersonID"] = value;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            phoneTypeKey = ManageTypesLogic.GetPhoneNumberTypeIDByName("work");
            cellPhoneTypeID = POD.Logic.ManageTypesLogic.GetPhoneNumberTypeIDByName("cell");
            homephonetype = POD.Logic.ManageTypesLogic.GetPhoneNumberTypeIDByName("home");
            addressTypeid = POD.Logic.ManageTypesLogic.GetAddressTypeIDByName("mailing");
            if (!IsPostBack)
            {
                Guid userID = new Guid(POD.Logic.Security.GetCurrentUserProfile().ProviderUserKey.ToString());
                currentPerson = POD.Logic.PeopleLogic.GetStaffByUserID(userID);
                PersonID = currentPerson.PersonID;

                LoadDropDowns();
                LoadPerson();
            }
        }

        private void LoadDropDowns()
        {
            //gender
            RadioListGender.DataSource = POD.Logic.LookUpTypesLogic.GetGenders();
            RadioListGender.DataBind();
        }

        private void LoadPerson()
        {
            this.ParticipantAddress.SetValidation(false, "");
            //this.ParticipantAddress.SetValidation(true, "Save");
            this.CellPhone.PhoneTypeID = cellPhoneTypeID;
            this.HomePhone.PhoneTypeID = homephonetype;
            this.WorkPhone.PhoneTypeID = phoneTypeKey;
            this.CellPhone.SetValidation(false, "");
            this.HomePhone.SetValidation(false, "");
            this.WorkPhone.SetValidation(false, "");

            if (PersonID > 0)
            {
                if (currentPerson.UserID.HasValue)
                {
                    MembershipUser currentUser = POD.Logic.Security.GetUserByUserID(currentPerson.UserID.Value);
                    this.TextBoxUserName.Text = currentUser.UserName;
                    this.TextBoxPassword.Text = currentUser.GetPassword();
                    this.HiddenOriginal.Value = currentUser.UserName;
                    this.HiddenFieldPassword.Value = currentUser.GetPassword();
                    List<string> rolesList = POD.Logic.Security.GetRolesForUser(currentUser.UserName);
                }

                //set gender
                if (currentPerson.GenderID.HasValue)
                {
                    ListItem gender = this.RadioListGender.Items.FindByValue(currentPerson.Gender.GenderID.ToString());
                    if (gender != null)
                    {
                        gender.Selected = true;
                    }
                }
                //location

                RadComboBoxLocation.DataBind();
                if (currentPerson.LocationID.HasValue)
                {
                    RadComboBoxItem location = RadComboBoxLocation.Items.FindItemByValue(currentPerson.LocationID.ToString());
                    if (location != null)
                    {
                        location.Selected = true;
                    }
                }

                this.TextBoxEmail.Text = currentPerson.Email;
                this.TextboxFirstName.Text = currentPerson.FirstName;
                this.TextboxLastName.Text = currentPerson.LastName;
                this.TextboxMiddle.Text = currentPerson.MiddleName;
                this.TextboxSalutation.Text = currentPerson.Salutation;
                this.TextboxCompany.Text = currentPerson.CompanyName;
                this.TextboxTitle.Text = currentPerson.Title;

                this.RadDatePickerDOB.SelectedDate = currentPerson.DateOfBirth;
                //set address possibly mailing
                if (currentPerson.MailingAddress != null)
                {
                    this.ParticipantAddress.ShowAddress(true);
                    this.ParticipantAddress.AddressID = currentPerson.MailingAddress.AddressID;
                    this.ParticipantAddress.AddressTypeID = addressTypeid;
                    this.ParticipantAddress.LoadAddress(currentPerson.PersonID, addressTypeid);

                }

                //phone
                this.HomePhone.LoadPhoneNumber(currentPerson.PersonID, homephonetype);
                this.CellPhone.LoadPhoneNumber(currentPerson.PersonID, cellPhoneTypeID);
                this.WorkPhone.LoadPhoneNumber(currentPerson.PersonID, phoneTypeKey);

            }
        }

        protected void ButtonCreateUser_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                MembershipCreateStatus status;
                if (PersonID != 0)
                {
                    //update user related data
                    POD.Data.Entities.StaffMember currentPerson = POD.Logic.PeopleLogic.GetStaffByID(PersonID);
                    if (HiddenOriginal.Value != this.TextBoxUserName.Text)
                    {
                        POD.Logic.PeopleLogic.UpdateUserName(currentPerson.UserID.Value, this.TextBoxUserName.Text);
                    }
                    string emailChangeText = this.HiddenFieldEmail.Value != this.TextBoxEmail.Text ? this.TextBoxEmail.Text : string.Empty;
                    if (HiddenFieldPassword.Value != this.TextBoxPassword.Text)
                    {
                        POD.Logic.Security.UpdatePasswordAndEmail(currentPerson.UserID.Value, HiddenFieldPassword.Value, this.TextBoxPassword.Text, emailChangeText);
                    }
                    status = MembershipCreateStatus.Success;


                    int? locid = null;
                    int? genderid = null;
                    if (status == MembershipCreateStatus.Success)
                    {
                        //create staff record
                        MembershipUser currentUser = Membership.GetUser(this.TextBoxUserName.Text.Trim());
                        Guid userid = new Guid(currentUser.ProviderUserKey.ToString());
                        if (RadioListGender.SelectedIndex != -1)
                        {
                            int gID = 0;
                            int.TryParse(RadioListGender.SelectedValue, out gID);
                            if (gID != 0)
                            {
                                genderid = gID;
                            }
                        }
                        if (!string.IsNullOrEmpty(RadComboBoxLocation.SelectedValue))
                        {
                            int id = 0;
                            int.TryParse(RadComboBoxLocation.SelectedValue, out id);
                            if (id != 0)
                            {
                                locid = id;
                            }
                        }
                        int typeid = POD.Logic.ManageTypesLogic.GetPersonTypeIDByName("staff");

                        PersonID = POD.Logic.PeopleLogic.AddUpdateStaff(PersonID, typeid, this.TextboxFirstName.Text.Trim(), this.TextboxLastName.Text.Trim(), this.TextboxMiddle.Text.Trim(),
                                                                 this.TextBoxEmail.Text.Trim(), this.TextboxTitle.Text.Trim(), this.TextboxCompany.Text.Trim(), this.TextboxSalutation.Text.Trim(),
                                                                 genderid, this.RadDatePickerDOB.SelectedDate, userid, locid);

                        this.ParticipantAddress.AddressTypeID = addressTypeid;
                        this.ParticipantAddress.SaveAndAssignAddress(PersonID);
                        this.HomePhone.SaveAndAssignPhone(PersonID);
                        this.CellPhone.SaveAndAssignPhone(PersonID);
                        this.WorkPhone.SaveAndAssignPhone(PersonID);
                        
                        if (PersonID != 0)
                        {
                            Response.Redirect(Page.ResolveUrl("~/Pages/ControlPanel.aspx"));
                        }
                        else
                        {
                            LabelFeedback.Text = "Your account could not be updated at this time, please contact the System Administrator";
                        }
                    }
                }
                else
                {
                    LabelFeedback.Text = "Your account could not be updated at this time, please contact the System Administrator";
                }
            }
        }

        protected void CustomValidatorUserName_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = false;
            if (!string.IsNullOrEmpty(this.HiddenOriginal.Value) && this.HiddenOriginal.Value == this.TextBoxUserName.Text)
            {
                args.IsValid = true;
            }
            else
            {
                args.IsValid = !POD.Logic.Security.UserNameExist(this.TextBoxUserName.Text);

            }
        }

        protected void CustomValidatorEmailUnique_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = false;
            if (!string.IsNullOrEmpty(this.HiddenFieldEmail.Value) && this.HiddenFieldEmail.Value == this.TextBoxEmail.Text)
            {
                args.IsValid = true;
            }
            else
            {
                args.IsValid = !POD.Logic.Security.UserNameExist(this.TextBoxEmail.Text);

            }
        }
    }
}