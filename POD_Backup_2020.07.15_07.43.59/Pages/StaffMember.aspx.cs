using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Data;
using System.Configuration;
using System.Web.Security;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Telerik.Web.UI;
using POD.Logic;
using System.Collections.Generic;

namespace POD.Pages.Admin.ManageStaff
{
    public partial class StaffMember : System.Web.UI.Page
    {
        private int personid = 0;
        int phoneTypeKey;
        int cellPhoneTypeID;
        int homephonetype;
        int addressTypeid;
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
            phoneTypeKey = POD.Logic.ManageTypesLogic.GetPhoneNumberTypeIDByName("work");
            cellPhoneTypeID = POD.Logic.ManageTypesLogic.GetPhoneNumberTypeIDByName("cell");
            homephonetype = POD.Logic.ManageTypesLogic.GetPhoneNumberTypeIDByName("home");
            addressTypeid = POD.Logic.ManageTypesLogic.GetAddressTypeIDByName("mailing");
            if (!IsPostBack)
            {
                POD.MasterPages.AdminWide mtPage = (POD.MasterPages.AdminWide)this.Master;
                if (mtPage != null)
                {
                    mtPage.SetNavigation("Staff");
                }
                if (!string.IsNullOrEmpty(Request.QueryString["id"]))
                {
                    int.TryParse(Request.QueryString["id"].ToString(), out personid);
                    PersonID = personid;
                }
                LoadDropDowns();
                LoadPerson();
            }
        }

        private void LoadDropDowns()
        {
            //gender
            RadioListGender.DataSource = POD.Logic.LookUpTypesLogic.GetGenders();
            RadioListGender.DataBind();
            //roles
            if (Security.UserInRole("Administrators"))
            {
                CheckboxListRoles.DataSource = Security.GetRolesList();
                CheckboxListRoles.DataBind();
            }
            else if (Security.UserInRole("CentralTeamUsers") || Security.UserInRole("SiteTeamUsers"))
            {
                PanelRoles.Visible = false;
            }
            else
            {
                PanelHireDate.Visible = false;
                PanelEndDate.Visible = false;
            }

            if (!Security.UserInRole("Administrators") && !Security.UserInRole("CentralTeamUsers"))//filter locations
            {
                DataSourceSites.Where = "it.LocationID = " + Session["UsersSiteID"].ToString() + "";
                DataSourceLocations.Where = "it.SiteLocationID = " + Session["UsersSiteID"].ToString() + "";
                DataSourceSites.DataBind();
                RadComboBoxLocation.DataBind();
            }

        }

        private void LoadPerson()
        {
            this.ParticipantAddress.SetValidation(false, "");
            this.CellPhone.PhoneTypeID = cellPhoneTypeID;
            this.HomePhone.PhoneTypeID = homephonetype;
            this.WorkPhone.PhoneTypeID = phoneTypeKey;
            this.CellPhone.SetValidation(false, "");
            this.HomePhone.SetValidation(false, "");
            this.WorkPhone.SetValidation(false, "");

            if (PersonID > 0)
            {

                POD.Data.Entities.StaffMember currentPerson = POD.Logic.PeopleLogic.GetStaffByID(PersonID);
                if (currentPerson.UserID.HasValue)
                {
                    MembershipUser currentUser = POD.Logic.Security.GetUserByUserID(currentPerson.UserID.Value);
                    this.TextBoxUserName.Text = currentUser.UserName;
                    this.TextBoxPassword.Text = currentUser.GetPassword();
                    this.HiddenOriginal.Value = currentUser.UserName;
                    this.HiddenFieldPassword.Value = currentUser.GetPassword();
                    if (Security.UserInRole("Administrators"))
                    {
                        List<string> rolesList = POD.Logic.Security.GetRolesForUser(currentUser.UserName);
                        foreach (string role in rolesList)
                        {
                            ListItem item = CheckboxListRoles.Items.FindByText(role);
                            if (item != null)
                            {
                                item.Selected = true;
                            }
                        }
                        this.RadDatePickerEndDate.SelectedDate = currentPerson.EndDate;
                        this.RadDatePickerHireDate.SelectedDate = currentPerson.HireDate;
                    }
                    else
                    {
                        this.RadDatePickerEndDate.SelectedDate = currentPerson.EndDate;
                        this.RadDatePickerHireDate.SelectedDate = currentPerson.HireDate;
                    }

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
                //active
                ListItem activeItem = RadioButtonListActive.Items.FindByValue(currentPerson.IsActive.ToString());
                if (activeItem != null)
                {
                    activeItem.Selected = true;
                }

                this.TextBoxEmail.Text = currentPerson.Email;
                this.HiddenFieldEmail.Value = currentPerson.Email;
                this.TextboxFirstName.Text = currentPerson.FirstName;
                this.TextboxLastName.Text = currentPerson.LastName;
                this.TextboxMiddle.Text = currentPerson.MiddleName;
                this.TextboxSalutation.Text = currentPerson.Salutation;
                RadComboBoxSites.DataBind();
                if (!string.IsNullOrEmpty(currentPerson.CompanyName))
                {
                    RadComboBoxItem itemSite = this.RadComboBoxSites.Items.FindItemByText(currentPerson.CompanyName);
                    if (itemSite != null)
                    {
                        itemSite.Selected = true;
                    }
                }
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
                DateTime? hireDate = null;
                DateTime? endDate = null;
                POD.Data.Entities.StaffMember currentPerson = null;
                if (PersonID != 0)
                {
                    //update user related data
                    currentPerson = POD.Logic.PeopleLogic.GetStaffByID(PersonID);
                    if (!currentPerson.UserID.HasValue)// user record does not exist
                    {
                        status = Security.CreateUser(TextBoxUserName.Text, TextBoxPassword.Text, TextBoxEmail.Text);
                    }
                    else //check for changes
                    {
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
                    }
                }
                else
                {
                    status = Security.CreateUser(TextBoxUserName.Text, TextBoxPassword.Text, TextBoxEmail.Text);

                }
                int? locid = null;
                int? genderid = null;
                if (status == MembershipCreateStatus.Success)
                {
                    if (Security.UserInRole("Administrators"))
                    {
                        //set roles
                        List<string> roleList = new List<string>();
                        foreach (ListItem item in CheckboxListRoles.Items)
                        {
                            if (item.Selected)
                            {
                                roleList.Add(item.Text);
                            }
                        }
                        Security.SetRoleForUser(TextBoxUserName.Text, roleList.ToArray());
                    }
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
                    bool isActive = this.RadioButtonListActive.SelectedIndex != -1 ? Convert.ToBoolean(this.RadioButtonListActive.SelectedValue) : false;
                    bool isAdmin = false;

                    if (Security.UserInRole("Administrators") || Security.UserInRole("CentralTeamUsers") || Security.UserInRole("SiteTeamUsers"))
                    {
                        hireDate = this.RadDatePickerHireDate.SelectedDate;
                        endDate = this.RadDatePickerEndDate.SelectedDate;
                    }
                    else if (currentPerson != null)
                    {
                        hireDate = currentPerson.HireDate;
                        endDate = currentPerson.EndDate;
                    }
                    int typeid = POD.Logic.ManageTypesLogic.GetPersonTypeIDByName("staff");
                    int statusId = isActive ? POD.Logic.ManageTypesLogic.GetStatusTypeByCategoryAndName("common", "active").StatusTypeID : POD.Logic.ManageTypesLogic.GetStatusTypeByCategoryAndName("common", "inactive").StatusTypeID;
                    PersonID = POD.Logic.PeopleLogic.AddUpdateStaff(PersonID, typeid, statusId, this.TextboxFirstName.Text.Trim(), this.TextboxLastName.Text.Trim(), this.TextboxMiddle.Text.Trim(),
                        this.TextBoxEmail.Text.Trim(), this.TextboxTitle.Text.Trim(), this.RadComboBoxSites.SelectedItem != null ? this.RadComboBoxSites.SelectedItem.Text : string.Empty, this.TextboxSalutation.Text.Trim(),
                                                             genderid, this.RadDatePickerDOB.SelectedDate, userid, isActive, isAdmin, locid, hireDate, endDate);

                    this.ParticipantAddress.AddressTypeID = addressTypeid;
                    this.ParticipantAddress.SaveAndAssignAddress(PersonID);
                    this.HomePhone.SaveAndAssignPhone(PersonID);
                    this.CellPhone.SaveAndAssignPhone(PersonID);
                    this.WorkPhone.SaveAndAssignPhone(PersonID);

                    if (PersonID != 0)
                    {
                        Response.Redirect(Page.ResolveUrl("~/Pages/Staff.aspx"));
                    }
                    else
                    {
                        LabelFeedback.Text = "Staff Member Save failed, please contact the System Administrator";
                    }
                }
                else
                {
                    LabelFeedback.Text = "User creation failed for the following reason: " + status.ToString();
                }
            }
        }

        protected void DeleteButton_Click(object sender, EventArgs e)
        {
            POD.Logic.PeopleLogic.DeleteStaff(PersonID);
            Response.Redirect("~/Pages/Staff.aspx");

        }

        protected void ButtonCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect(Page.ResolveUrl("~/Pages/Staff.aspx"));
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