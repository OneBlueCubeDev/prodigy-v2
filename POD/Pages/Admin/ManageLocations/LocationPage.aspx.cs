using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using POD.Data.Entities;
using Telerik.Web.UI;

namespace POD.Pages.Admin.ManageLocations
{
    public partial class LocationPage : System.Web.UI.Page
    {
        private int locid = 0;
        // int LocTypeKey;
        //int homephonetype;
        private int LocationID
        {
            get
            {
                if (ViewState["LocationID"] != null)
                {
                    int.TryParse(ViewState["LocationID"].ToString(), out locid);
                }
                return locid;
            }
            set
            {
                ViewState["LocationID"] = value;
            }
        }

        private string redirectURL;
        protected void Page_Load(object sender, EventArgs e)
        {
            redirectURL = "~/Pages/Admin/ManageLocations/Locations.aspx";
            if (!string.IsNullOrEmpty((Request.QueryString["r"])))
            {
                if (Request.QueryString["r"].ToString() == "la")
                {
                    redirectURL = "~/Pages/Admin/ManageLocations/SiteAttendanceLockingManagement.aspx";
                }
            }

            if (!IsPostBack)
            {
                if (!string.IsNullOrEmpty(Request.QueryString["lid"]))
                {
                    int.TryParse(Request.QueryString["lid"].ToString(), out locid);
                    LocationID = locid;
                }

                LoadData();
            }
        }

        private void LoadData()
        {
            this.Phone.SetValidation(false, "");
            AddEditAddress1.SetValidation(false, "");
            Location currentLoc = POD.Logic.LookUpTypesLogic.GetLocationByID(LocationID);
            if (currentLoc != null)
            {
                
                if (currentLoc.IsSite)
                {
                    checkBoxSite.Checked = currentLoc.IsSite;
                    checkBoxSite.Enabled = false;
                    Site currentsite = (Site)currentLoc;
                    this.TextBoxsiteName.Text = currentsite.SiteName;
                    this.TextBoxOrgName.Text = currentsite.Organization;
                    //this.LockDatePicker.SelectedDate = currentsite.AttendanceLockedDate;
                    this.chkisSiteLocked.Checked = (bool)currentsite.MandatoryAttendanceLock;
                }
                else
                {
                    if (currentLoc.SiteLocationID.HasValue)//find parent and set to selection
                    {
                        this.RadComboBoxSite.DataBind();
                        RadComboBoxItem parentSite = this.RadComboBoxSite.FindItemByValue(currentLoc.SiteLocationID.ToString());
                        if (parentSite != null)
                        {
                            parentSite.Selected = true;
                        }
                    }

                    var siteInfo = POD.Logic.LookUpTypesLogic.GetSiteByID((int)currentLoc.SiteLocationID);

                    //Site currentsite = (Site)currentLoc.Site;
                    this.chkisSiteLocked.Checked = (bool)siteInfo.MandatoryAttendanceLock;
                    this.chkisSiteLocked.Enabled = false;
                }

                AddEditAddress1.AddressID = currentLoc.AddressID;
                AddEditAddress1.LoadAddress(null, currentLoc.AddressID);
                this.TextBoxName.Text = currentLoc.Name;
                this.RadEditoDesc.Content = currentLoc.Notes;
                this.RadComboLocType.DataBind();
                RadComboBoxItem item = this.RadComboLocType.FindItemByValue(currentLoc.LocationTypeID.ToString());
                if (item != null)
                {
                    item.Selected = true;
                }
                this.RadComboStatusType.DataBind();
                item = this.RadComboStatusType.FindItemByValue(currentLoc.StatusTypeID.ToString());
                if (item != null)
                {
                    item.Selected = true;
                }
                RadGridPhoneNumbers.DataBind();
            }
        }

        private void Save()
        {
            int addressid = this.AddEditAddress1.SaveAddress();
            int typeid = 0;
            int status = 0;
            int.TryParse(this.RadComboLocType.SelectedValue, out typeid);
            int.TryParse(this.RadComboStatusType.SelectedValue, out status);
            int? parentSiteID = null;
            //if not site add parent site id
            if (!this.checkBoxSite.Checked && !string.IsNullOrEmpty(this.RadComboBoxSite.SelectedValue))
            {
                int siteid = 0;
                int.TryParse(this.RadComboBoxSite.SelectedValue, out siteid);
                parentSiteID = siteid;
            }
            string sitename = this.checkBoxSite.Checked ? this.TextBoxsiteName.Text : string.Empty;
            string orgName = this.checkBoxSite.Checked ? this.TextBoxOrgName.Text : string.Empty;
            //DateTime? lockDate = this.checkBoxSite.Checked ? this.LockDatePicker.SelectedDate : null;
            bool isSiteLocked = this.chkisSiteLocked.Checked;
            LocationID = POD.Logic.LookUpTypesLogic.AddUpdateLocation(addressid, this.TextBoxName.Text.Trim(), sitename, orgName, this.RadEditoDesc.Content.ToString(), this.checkBoxSite.Checked, parentSiteID, typeid, status, LocationID, isSiteLocked);
        }

        protected void RadGridPhoneNumbers_NeedsDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            if (LocationID != 0)
            {
                this.RadGridPhoneNumbers.DataSource = POD.Logic.AddressPhoneNumerLogic.GetPhoneNumbersByLocationID(LocationID);
            }
        }

        protected void RadGridPhoneNumbers_DeleteCommand(object sender, GridCommandEventArgs e)
        {
            string phoneID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PhoneNumberID"].ToString();
            if (!string.IsNullOrEmpty(phoneID))
            {
                POD.Logic.LookUpTypesLogic.DeletePhoneNumberToLocation(LocationID, int.Parse(phoneID));
                RadGridPhoneNumbers.Rebind();
            }
        }

        protected void ButtonAddPhone_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                if (LocationID == 0)
                {
                    Save();
                }
                int phoneTypeID = 0;
                int.TryParse(RadComboBoxPhoneTypes.SelectedValue, out phoneTypeID);
                this.Phone.PhoneTypeID = phoneTypeID;
                int phoneid = this.Phone.SavePhone();
                POD.Logic.LookUpTypesLogic.AddPhoneNumberToLocation(LocationID, phoneid);

            }
            RadGridPhoneNumbers.Rebind();
        }

        protected void ButtonSaveLocation_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                Save();
                Response.Redirect(redirectURL);
            }

        }

        protected void DeleteButton_Click(object sender, EventArgs e)
        {
            POD.Logic.LookUpTypesLogic.DeleteLocationRelations(LocationID);
            POD.Logic.LookUpTypesLogic.DeleteLocation(LocationID);
            Response.Redirect(redirectURL);

        }
    }
}