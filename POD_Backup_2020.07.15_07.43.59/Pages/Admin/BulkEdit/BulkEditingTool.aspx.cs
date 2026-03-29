using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using POD.Logging;
using Telerik.Web.UI;
using POD.Data.Entities;
using POD.Logic;

namespace POD.Pages.Admin.BulkEdit
{
    public partial class BulkEditingTool : System.Web.UI.Page
    {
        public List<int> enrollmentIDList = new List<int>();
        private int filter = 0;
        private int startIndex = 0;
        public int CurrentStartingPageIndex
        {
            get
            {
                if (ViewState["CurrentStartingPageIndex"] != null)
                {
                    int.TryParse(ViewState["CurrentStartingPageIndex"].ToString(), out startIndex);
                    return startIndex;
                }
                else return 0;
            }
            set
            {
                ViewState["CurrentStartingPageIndex"] = value;
            }
        }
        public int Filter
        {
            get
            {
                if (ViewState["Filter"] != null)
                {
                    int.TryParse(ViewState["Filter"].ToString(), out filter);
                    return filter;
                }
                else return 0;
            }
            set
            {
                ViewState["Filter"] = value;
            }
        }
        public bool? ClassRelatedFilter
        {
            get
            {
                if (ViewState["ClassRelatedFilter"] != null)
                {
                    return bool.Parse(ViewState["ClassRelatedFilter"].ToString());

                }
                else return null;
            }
            set
            {
                ViewState["ClassRelatedFilter"] = value;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GetData();
            }
        }

        private void GetData()
        {
            int? siteid = null;
            if (!Security.UserInRole("Administrators"))
            {
                siteid = int.Parse(Session["UsersSiteID"].ToString());
            }
            int progID = 0;
            if (Session["ProgramID"] != null)
            {
                int.TryParse(Session["ProgramID"].ToString(), out progID);
            }
            if (ListViewData.Items.Count != 0) { ListViewData.Items.Clear(); }
            if (Filter == 0 && !ClassRelatedFilter.HasValue)
            {
                ListViewData.DataSource = POD.Logic.PeopleLogic.GetYouthBulkEdit(progID, siteid, null, null, null);
                ListViewData.DataBind();
            }
            else if (ClassRelatedFilter.HasValue)
            {
                bool? noClass = null;
                bool? rollOVer = null;
                if (ClassRelatedFilter.HasValue && ClassRelatedFilter.Value == true)
                {
                    noClass = true;
                }
                else if (ClassRelatedFilter.HasValue)
                {
                    rollOVer = true;
                }
                ListViewData.DataSource = POD.Logic.PeopleLogic.GetYouthBulkEdit(progID, siteid, null, noClass, rollOVer);
                ListViewData.DataBind();
            }
            else
            {
                string enrollmentType = filter == 1 ? "intervention" : Filter == 2 ? "diversion" : "prevention";
                int? enrollmentTypeID = POD.Logic.ManageTypesLogic.GetEnrollmentTypeIDByName(enrollmentType);
                bool? noClass = null;
                bool? rollOVer = null;
                if (ClassRelatedFilter.HasValue && ClassRelatedFilter.Value == true)
                {
                    noClass = true;
                }
                else if (ClassRelatedFilter.HasValue)
                {
                    rollOVer = true;
                }
                ListViewData.DataSource = POD.Logic.PeopleLogic.GetYouthBulkEdit(progID, siteid, enrollmentTypeID, noClass, rollOVer);
                ListViewData.DataBind();
            }

        }

        protected void ListViewData_ItemUpdating(object sender, ListViewUpdateEventArgs e)
        {
            int itemIndex = CurrentStartingPageIndex != 0 ? e.ItemIndex - CurrentStartingPageIndex : e.ItemIndex;

            ListViewItem item = (ListViewItem)ListViewData.Items[itemIndex];

            if (item != null)
            {
                TextBox flagBox = (TextBox)item.FindControl("TextBox");
                if (flagBox != null && !string.IsNullOrEmpty(flagBox.Text))
                {
                    int personid = Convert.ToInt32(ListViewData.DataKeys[itemIndex].Values["PersonID"]);
                    int enrollID = Convert.ToInt32(ListViewData.DataKeys[itemIndex].Values["EnrollmentID"]);
                    string type = ListViewData.DataKeys[itemIndex].Values["EnrollmentTypeName"].ToString();
                    int addressid = Convert.ToInt32(ListViewData.DataKeys[itemIndex].Values["AddressID"]);
                    int phoneid = Convert.ToInt32(ListViewData.DataKeys[itemIndex].Values["HomePhoneID"]);
                    int cellid = Convert.ToInt32(ListViewData.DataKeys[itemIndex].Values["CellPhoneID"]);

                    RadDatePicker dob = (RadDatePicker)item.FindControl("RadDatePickerDOB");
                    // RadComboBox stateBox = (RadComboBox)e.Item.FindControl("RadComboBoxState");
                    RadMaskedTextBox zip = (RadMaskedTextBox)item.FindControl("TextBoxZip");
                    RadMaskedTextBox phone = (RadMaskedTextBox)item.FindControl("TextBoxPhone");
                    RadMaskedTextBox cell = (RadMaskedTextBox)item.FindControl("TextBoxCell");
                    RadComboBox statusBox = (RadComboBox)item.FindControl("RadComboBoxStatus");
                    RadComboBox county = (RadComboBox)item.FindControl("RadComboBoxCounty");
                    CheckBox check = (CheckBox)item.FindControl("CheckBox");
                    if (check.Checked)
                    {
                        enrollmentIDList.Add(POD.Logic.RiskAssessmentLogic.GetEnrollmentIDByEnrollmentIDOrRiskAssessmentID(enrollID, type));
                    }
                    int? countyID = null;
                    int ctid = 0;
                    int statusid = 0;
                    int.TryParse(statusBox.SelectedValue, out statusid);
                    if (county.SelectedValue != "")
                    {
                        int.TryParse(county.SelectedValue, out ctid);
                        countyID = ctid;
                    }
                    try
                    {
                        SavePerson(personid, e.NewValues["FirstName"] != null ? e.NewValues["FirstName"].ToString() : null, e.NewValues["MiddleName"] != null ? e.NewValues["MiddleName"].ToString() : null, e.NewValues["LastName"] != null ? e.NewValues["LastName"].ToString() : null, dob.SelectedDate, statusid, e.NewValues["DJJIDNum"] != null ? e.NewValues["DJJIDNum"].ToString() : null);
                        SaveAddress(personid, addressid, e.NewValues["AddressLine1"] != null ? e.NewValues["AddressLine1"].ToString() : null, zip.Text, "FL", e.NewValues["City"] != null ? e.NewValues["City"].ToString() : null, countyID);
                        SavePhone(personid, phoneid, "home", phone.Text);
                        SavePhone(personid, cellid, "cell", cell.Text);
                    }
                    catch (Exception ex)
                    {
                        ex.Log();
                    }
                }
            }
        }

        protected void ListViewData_ItemUpdated(object sender, ListViewUpdatedEventArgs e)
        {
            if (enrollmentIDList.Count > 0 && ReleaseDatePicker.SelectedDate.HasValue && !string.IsNullOrEmpty(this.TextBoxReleaseAgency.Text) && !string.IsNullOrEmpty(this.TextBoxReleaseReason.Text))
            {
                ReleaseStudents();
                enrollmentIDList.Clear();
            }
        }

        /// <summary>
        /// updates all selected records with release dates
        /// </summary>
        private void ReleaseStudents()
        {
            string result = POD.Logic.RiskAssessmentLogic.ReleaseEnrollmentList(enrollmentIDList.Where(r => r != 0).Distinct().ToList(), ReleaseDatePicker.SelectedDate.Value, this.TextBoxReleaseAgency.Text.Trim(), this.TextBoxReleaseReason.Text.Trim());
        }
        private void SaveAddress(int personid, int addressid, string address, string zip, string state, string city, int? countyid)
        {
            int statusid = POD.Logic.ManageTypesLogic.GetStatusTypeIDByName("active");
            int AddressTypeID = POD.Logic.ManageTypesLogic.GetAddressTypeIDByName("mailing");

            int newAddressID = POD.Logic.AddressPhoneNumerLogic.AddUpdateAddress(addressid, address, string.Empty, string.Empty,
                                                                           city, state, zip, countyid, AddressTypeID, statusid);
            List<int> addressIDList = new List<int>();
            addressIDList.Add(newAddressID);
            if (addressid != 0 && addressid != newAddressID)
            {
                POD.Logic.PeopleLogic.DeleteAddressFromPerson(personid, addressid);
                POD.Logic.PeopleLogic.AddAddressToPerson(personid, addressIDList);
            }
            else if (addressid == 0)
            {
                POD.Logic.PeopleLogic.AddAddressToPerson(personid, addressIDList);
            }
        }

        private void SavePhone(int personid, int phoneid, string type, string phone)
        {
            int PhoneTypeID = POD.Logic.ManageTypesLogic.GetPhoneNumberTypeIDByName(type);
            int newPhoneID = POD.Logic.AddressPhoneNumerLogic.AddUpdatePhoneNumber(phoneid, personid, phone, PhoneTypeID);
            List<int> phoneIDList = new List<int>();
            phoneIDList.Add(newPhoneID);
            if (phoneid != 0)
            {                //if we created a new phone number remove the original to keep record clean
                //this only happens if number was assigned to multiple people and we changed it for this person
                if (newPhoneID != phoneid)
                {
                    POD.Logic.PeopleLogic.DeletePhoneNumberFromPerson(personid, phoneid);

                    POD.Logic.PeopleLogic.AddPhoneNumbersToPerson(personid, phoneIDList);
                }
            }
            else
            {
                POD.Logic.PeopleLogic.AddPhoneNumbersToPerson(personid, phoneIDList);
            }
        }

        private void SavePerson(int personid, string first, string middle, string last, DateTime? dob, int statustypeid, string djjnum)
        {
            Person p = POD.Logic.PeopleLogic.AddUpdatePerson(personid, first, last, middle, dob, statustypeid, djjnum,null);
        }

        protected void ListViewData_ItemDataBound(object sender, ListViewItemEventArgs e)
        {
            ListViewDataItem lvdi = (ListViewDataItem)e.Item;

            BulkEditStudents_Result dtItem = (BulkEditStudents_Result)lvdi.DataItem;

            RadDatePicker dob = (RadDatePicker)e.Item.FindControl("RadDatePickerDOB");
            // RadComboBox stateBox = (RadComboBox)e.Item.FindControl("RadComboBoxState");
            RadMaskedTextBox zip = (RadMaskedTextBox)e.Item.FindControl("TextBoxZip");
            RadMaskedTextBox phone = (RadMaskedTextBox)e.Item.FindControl("TextBoxPhone");
           // RadMaskedTextBox cell = (RadMaskedTextBox)e.Item.FindControl("TextBoxCell");
           // RadComboBox statusBox = (RadComboBox)e.Item.FindControl("RadComboBoxStatus");
            RadComboBox county = (RadComboBox)e.Item.FindControl("RadComboBoxCounty");

            if (dtItem.DateOfBirth.HasValue)
            {
                dob.SelectedDate = dtItem.DateOfBirth;
            }
            if (!string.IsNullOrEmpty(dtItem.Zip))
            {
                zip.Text = dtItem.Zip;
            }
            if (!string.IsNullOrEmpty(dtItem.HomePhone))
            {
                phone.Text = dtItem.HomePhone;
            }
            //if (!string.IsNullOrEmpty(dtItem.CellPhone))
            //{
            //    cell.Text = dtItem.CellPhone;
            //}
            if (dtItem.CountyID.HasValue)
            {
                county.DataBind();
                RadComboBoxItem item = county.FindItemByValue(dtItem.CountyID.Value.ToString());
                if (item != null)
                {
                    item.Selected = true;
                }
            }
        }

        protected void Update_Click(object sender, EventArgs e)
        {
            ListViewData.SaveItems();
        }

        protected void ListViewData_PagePropertiesChanging(object sender, PagePropertiesChangingEventArgs e)
        {
            ListViewData.SaveItems();
            DataPagerStudents.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);
            GetData();
            CurrentStartingPageIndex = e.StartRowIndex;
        }

        protected void RadcomboBoxFilter_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            //save first
            ListViewData.SaveItems();

            switch (e.Value.ToString())
            {
                case "All":
                    Filter = 0;
                    ClassRelatedFilter = null;
                    break;
                case "Intervention":
                    Filter = 1;
                    ClassRelatedFilter = null;
                    break;
                case "Diversion":
                    Filter = 2;
                    ClassRelatedFilter = null;
                    break;
                case "Prevention":
                    Filter = 3;
                    ClassRelatedFilter = null;
                    break;
                case "NoAttendance":
                    Filter = 0;
                    ClassRelatedFilter = true;
                    break;
                case "GrantYearRollover":
                    Filter = 0;
                    ClassRelatedFilter = false;
                    break;
            }
            GetData();
        }
    }
}