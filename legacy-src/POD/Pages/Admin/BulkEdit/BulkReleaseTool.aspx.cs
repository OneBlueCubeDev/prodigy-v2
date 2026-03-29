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
    public partial class BulkReleaseTool : System.Web.UI.Page
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

                this.RadcbYouthtype.DataSource = POD.Logic.ManageTypesLogic.GetYouthTypes();
                this.RadcbYouthtype.DataBind();

                this.RadComboBoxGrantYear.DataSource = POD.Logic.ManageTypesLogic.GetGrantYears(Convert.ToInt32(RadcbYouthtype.SelectedItem.Value));
                this.RadComboBoxGrantYear.DataBind();

                RadComboBoxItem currentYear = RadComboBoxGrantYear.Items.FindItemByText(POD.Logic.ManageTypesLogic.GetCurrentGrantYear(Convert.ToInt32(RadcbYouthtype.SelectedItem.Value)));
                if (currentYear != null)
                {
                    currentYear.Selected = true;
                }

                //GetData();
            }
        }

        protected void RadcbYouthtype_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            if (!string.IsNullOrEmpty(e.Value))
            {
                int youthtypeid = 0;
                int.TryParse(e.Value, out youthtypeid);
                this.RadComboBoxGrantYear.DataSource = POD.Logic.ManageTypesLogic.GetGrantYears(Convert.ToInt32(youthtypeid));
                this.RadComboBoxGrantYear.DataBind();

                RadComboBoxItem currentYear = RadComboBoxGrantYear.Items.FindItemByText(POD.Logic.ManageTypesLogic.GetCurrentGrantYear(Convert.ToInt32(youthtypeid)));
                if (currentYear != null)
                {
                    currentYear.Selected = true;
                }
            }
        }

        protected void secureFilterSite_OnAuthorizationFailed(object sender, EventArgs e)
        {
            var siteId = Convert.ToInt32(Session["UsersSiteID"]);
            if (Page.IsPostBack == false)
            {
                DropDownSites.Items.Clear();
                Site site = LookUpTypesLogic.GetSiteByID(siteId);
                DropDownSites.DataSource = new[] { site };
                DropDownSites.DataBind();


            }
        }

        protected void secureFilterSite_OnAuthorizationPassed(object sender, EventArgs e)
        {
            if (Page.IsPostBack == false)
            {
                DropDownSites.DataSource = LookUpTypesLogic.GetSites();
                DropDownSites.DataBind();
                if (Security.UserInRole("Administrators") || !Security.UserInRole("CentralTeamUsers"))
                {
                    this.DropDownSites.Items.Insert(0, new RadComboBoxItem("All", ""));
                }
            }
        }

        private void GetData()
        {
            int? grantyearid = Convert.ToInt32(RadComboBoxGrantYear.SelectedItem.Value)  ;
            int? youthtypeid = Convert.ToInt32(RadcbYouthtype.SelectedItem.Value);
            int? tempsiteid = DropDownSites.SelectedItem.Value != string.Empty ? Convert.ToInt32(DropDownSites.SelectedItem.Value) : 0;

            int? siteid = null;

            if (tempsiteid == 0)
            {
                siteid = null;
            }
            else
            {
                siteid = tempsiteid;
            }
            
            
            
            int progID = 0;
            if (Session["ProgramID"] != null)
            {
                int.TryParse(Session["ProgramID"].ToString(), out progID);
            }
            if (ListViewData.Items.Count != 0) { ListViewData.Items.Clear(); }
            if (Filter == 0 && !ClassRelatedFilter.HasValue)
            {
                //ListViewData.DataSource = POD.Logic.PeopleLogic.GetYouthBulkEdit(progID, siteid, null, null, null, grantyearid, youthtypeid);
                //ListViewData.DataBind();

                RadGrid1.DataSource = POD.Logic.PeopleLogic.GetYouthBulkEdit(progID, siteid, null, null, null, grantyearid, youthtypeid);
                RadGrid1.DataBind();
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
                ListViewData.DataSource = POD.Logic.PeopleLogic.GetYouthBulkEdit(progID, siteid, null, noClass, rollOVer, grantyearid, youthtypeid);
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
                ListViewData.DataSource = POD.Logic.PeopleLogic.GetYouthBulkEdit(progID, siteid, enrollmentTypeID, noClass, rollOVer, grantyearid, youthtypeid);
                ListViewData.DataBind();
            }

        }

        protected void ListViewData_ItemUpdating(object sender, ListViewUpdateEventArgs e)
        {
            int itemIndex = CurrentStartingPageIndex != 0 ? e.ItemIndex - CurrentStartingPageIndex : e.ItemIndex;

            ListViewItem item = (ListViewItem)ListViewData.Items[itemIndex];

            if (item != null)
            {

                CheckBox releasecheck = (CheckBox)item.FindControl("CheckBox");
                if (releasecheck.Checked)
                {
                    int personid = Convert.ToInt32(ListViewData.DataKeys[itemIndex].Values["PersonID"]);
                    int enrollID = Convert.ToInt32(ListViewData.DataKeys[itemIndex].Values["EnrollmentID"]);
                    string type = ListViewData.DataKeys[itemIndex].Values["EnrollmentTypeName"].ToString();
                    int addressid = Convert.ToInt32(ListViewData.DataKeys[itemIndex].Values["AddressID"]);
                    int phoneid = Convert.ToInt32(ListViewData.DataKeys[itemIndex].Values["HomePhoneID"]);

                    var test = RadioButtonListReleaseAgency.SelectedValue;
                    //int? grantyearid = this.RadioButtonListReleaseAgency.SelectedIndex != -1 ? this.RadioButtonListReleaseAgency.SelectedValue : string.Empty
                    //int? agencyid = Convert.ToInt32(RadioButtonListReleaseAgency.SelectedItem.Value);
                    //int? tempsiteid = Convert.ToInt32(DropDownSites.SelectedItem.Value);

                    enrollmentIDList.Add(POD.Logic.RiskAssessmentLogic.GetEnrollmentIDByEnrollmentIDOrRiskAssessmentID(enrollID, type));

                    try
                    {
                        ReleaseStudents();
                        enrollmentIDList.Clear();
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
            //if (enrollmentIDList.Count > 0 && ReleaseDatePicker.SelectedDate.HasValue && !string.IsNullOrEmpty(this.TextBoxReleaseAgency.Text) && !string.IsNullOrEmpty(this.TextBoxReleaseReason.Text))
            //{
            //    ReleaseStudents();
            //    enrollmentIDList.Clear();
            //}
        }

        /// <summary>
        /// updates all selected records with release dates
        /// </summary>
        private void ReleaseStudents()
        {
            var agency = RadioButtonListReleaseAgency.SelectedValue;
            var releaseReason = RadioButtonListRelReason.SelectedValue;
            var releasedate = RadDatePickerReleaseDate.SelectedDate;

            string result = POD.Logic.RiskAssessmentLogic.ReleaseEnrollmentList(enrollmentIDList.Where(r => r != 0).Distinct().ToList(), (DateTime)releasedate, agency, releaseReason);
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

            sp_GetPersonForBulkRelease_Result dtItem = (sp_GetPersonForBulkRelease_Result)lvdi.DataItem;

            RadDatePicker dob = (RadDatePicker)e.Item.FindControl("RadDatePickerDOB");
            RadMaskedTextBox zip = (RadMaskedTextBox)e.Item.FindControl("TextBoxZip");
            RadMaskedTextBox phone = (RadMaskedTextBox)e.Item.FindControl("TextBoxPhone");
            RadComboBox county = (RadComboBox)e.Item.FindControl("RadComboBoxCounty");

            if (dtItem.DateOfBirth.HasValue)
            {
                dob.SelectedDate = dtItem.DateOfBirth;
            }
           
        }

        protected void RadGrid1_ItemDataBound(object sender, Telerik.Web.UI.GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem dataItem = e.Item as GridDataItem;
                if (dataItem.Selected)
                {
                    CheckBox checkBox = (CheckBox)dataItem["ClientSelectColumn"].Controls[0];
                    dataItem.Selected = true;
                }
            }
        }

        protected void Update_Click(object sender, EventArgs e)
        {

            var selected = RadGrid1.SelectedItems;

            foreach (GridDataItem item in RadGrid1.MasterTableView.Items)
            {
                CheckBox chk = (CheckBox)item["ClientSelectColumn"].Controls[0];
                if (chk.Checked)
                {
                    string value = item["OrderID"].Text;// access the cell value using ColumnUniqueName
                   
                }
            }

            ListViewData.SaveItems();
            GetData();
        }

        protected void Find_Click(object sender, EventArgs e)
        {
            GetData();
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

        protected void RadGrid1_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridHeaderItem headerItem = (GridHeaderItem)RadGrid1.MasterTableView.GetItems(GridItemType.Header)[0];
            CheckBox headerChkBox = (CheckBox)headerItem["GridClientSelectColumn"].Controls[0];
            if (headerChkBox.Checked)
            {
                // header CheckBox is clicked
            }
            else
            {
                // check box inside Grid row is clicked
            }
        }

        protected void RadGrid1_ItemCreated(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridHeaderItem)
            {
                GridHeaderItem headerItem = (GridHeaderItem)e.Item;
               // CheckBox headerChkBox = (CheckBox)headerItem["GridClientSelectColumn"].Controls[0];
                //headerChkBox.AutoPostBack = true;
                //headerChkBox.CheckedChanged += new EventHandler(headerChkBox_CheckedChanged);
            }
        }

        void headerChkBox_CheckedChanged(object sender, EventArgs e)
        {
            // Here is your code when header clicked
        }
    }
}