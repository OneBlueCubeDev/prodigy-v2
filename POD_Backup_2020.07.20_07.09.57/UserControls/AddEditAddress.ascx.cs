using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using POD.Data.Entities;
using POD.Logging;
using Telerik.Web.UI;


namespace POD.UserControls
{
    public partial class AddEditAddress : System.Web.UI.UserControl
    {
        int addressid = 0;
        int addressTypeid = 0;

        public int AddressID
        {
            get
            {
                if (ViewState["AddressID"] != null)
                {
                    int.TryParse(ViewState["AddressID"].ToString(), out addressid);
                }
                return addressid;
            }
            set
            {
                ViewState["AddressID"] = value;
            }
        }

        public int AddressTypeID
        {
            get
            {
                if (ViewState["AddressTypeID"] != null)
                {
                    int.TryParse(ViewState["AddressTypeID"].ToString(), out addressTypeid);
                }
                return addressTypeid;
            }
            set
            {
                ViewState["AddressTypeID"] = value;
            }
        }

        public Address currentAddress = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadLists();

            }
        }
        private void LoadLists()
        {
            if (this.RadComboBoxCounty.Items.Count == 0)
            {
                this.RadComboBoxCounty.DataSource = POD.Logic.LookUpTypesLogic.GetCounties();
                this.RadComboBoxCounty.DataBind();
            }
        }
        public void ShowAddress(bool showAll)
        {
            this.PanelAptNum.Visible = showAll;
            this.PanelCounty.Visible = showAll;
            this.PanelStreet2.Visible = showAll;
        }

        public void ClearAddress()
        {
            this.RadComboBoxCounty.ClearSelection();
            this.RadComboBoxState.ClearSelection();
            this.TextBoxAddress.Text = string.Empty;
            this.TextBoxAddress2.Text = string.Empty;
            this.TextBoxAptNum.Text = string.Empty;
            this.TextBoxCity.Text = string.Empty;
            this.TextBoxZip.Text = string.Empty;

        }

        /// <summary>
        /// set enabled and validation group
        /// </summary>
        /// <param name="enabled"></param>
        /// <param name="validationGroup"></param>

        public void SetValidation(bool enabled, string validationGroup)
        {
            reqValCity.Enabled = enabled;
            reqValStreet.Enabled = enabled;
            reqValZip.Enabled = enabled;

            reqValCity.ValidationGroup = validationGroup;
            reqValStreet.ValidationGroup = validationGroup;
            reqValZip.ValidationGroup = validationGroup;
        }


        public void LoadAddress(int? personID, int? addresstypeid)
        {
            LoadLists();
            if (AddressID != 0)
            {
                currentAddress = POD.Logic.AddressPhoneNumerLogic.GetAddressByID(AddressID);
            }
            else if (personID.HasValue && addresstypeid.HasValue)
            {
                currentAddress = POD.Logic.AddressPhoneNumerLogic.GetAddressByTypeAndPersonID(addresstypeid.Value, personID.Value);
            }

            if (currentAddress != null)
            {
                this.TextBoxAddress.Text = currentAddress.AddressLine1;
                this.TextBoxAddress2.Text = currentAddress.AddressLine2;
                this.TextBoxAptNum.Text = currentAddress.AptNum;
                this.TextBoxCity.Text = currentAddress.City;
                this.TextBoxZip.Text = currentAddress.Zip;
                if (currentAddress.CountyID.HasValue)
                {
                    RadComboBoxItem countyItem = (RadComboBoxItem)this.RadComboBoxCounty.Items.FindItemByValue(currentAddress.CountyID.Value.ToString());
                    if (countyItem != null)
                    {
                        countyItem.Selected = true;
                    }
                }
                RadComboBoxItem stateItem = (RadComboBoxItem)this.RadComboBoxState.Items.FindItemByValue(currentAddress.State);
                if (stateItem != null)
                {
                    stateItem.Selected = true;
                }
            }
        }


        public void SaveAndAssignAddress(int personid)
        {
            SaveAddress(personid);
            List<int> addressIDList = new List<int>();
            addressIDList.Add(AddressID);
            POD.Logic.PeopleLogic.AddAddressToPerson(personid, addressIDList);

        }

        public void SaveAndAssignSchoolAddress(int personid)
        {
            SaveAddress();

            POD.Logic.PeopleLogic.AddSchoolAddressToPerson(personid, AddressID);

        }

        private void SaveAddress(int personid)
        {
            try
            {
                int statusid = POD.Logic.ManageTypesLogic.GetStatusTypeIDByName("active");
                
                int cid = 0;
                int? countyId = null;
                if (this.PanelCounty.Visible && int.TryParse(this.RadComboBoxCounty.SelectedValue.ToString(), out cid))
                {
                    countyId = cid;
                }
                if (AddressTypeID == 0)
                {
                    AddressTypeID = POD.Logic.ManageTypesLogic.GetAddressTypeIDByName("mailing");
                }
                if (AddressID != 0)
                {
                    int newAddressid = POD.Logic.AddressPhoneNumerLogic.AddUpdateAddress(AddressID, personid, this.TextBoxAddress.Text.Trim(), this.TextBoxAddress2.Text.Trim(), this.TextBoxAptNum.Text.Trim(),
                                                                         this.TextBoxCity.Text.Trim(), this.RadComboBoxState.SelectedValue, this.TextBoxZip.Text.Trim(), countyId,
                                                                                               AddressTypeID, statusid);
                    //if we created a new address remove the original to keep record clean
                    //this only happens if address was assigned to multiple people and we changed it for this person
                    if (newAddressid != AddressID)
                    {
                        POD.Logic.PeopleLogic.DeleteAddressFromPerson(personid, AddressID);
                        AddressID = newAddressid;
                    }
                }
                else
                {
                    AddressID = POD.Logic.AddressPhoneNumerLogic.AddUpdateAddress(null, personid, this.TextBoxAddress.Text.Trim(), this.TextBoxAddress2.Text.Trim(), this.TextBoxAptNum.Text.Trim(),
                                                                           this.TextBoxCity.Text.Trim(), this.RadComboBoxState.SelectedValue, this.TextBoxZip.Text.Trim(), countyId,
                                                                           AddressTypeID, statusid);
                }
            }
            catch (Exception ex)
            {
                ex.Log();
            }
        }

        public int SaveAddress()
        {
            try
            {
                int statusid = POD.Logic.ManageTypesLogic.GetStatusTypeIDByName("active");
                if (AddressTypeID == 0)
                {
                    AddressTypeID = POD.Logic.ManageTypesLogic.GetAddressTypeIDByName("mailing");
                }
                int cid = 0;
                int? countyId = null;
                if (this.PanelCounty.Visible && int.TryParse(this.RadComboBoxCounty.SelectedValue.ToString(), out cid))
                {
                    countyId = cid;
                }
                if (AddressID != 0)
                {
                    AddressID = POD.Logic.AddressPhoneNumerLogic.AddUpdateAddress(AddressID, this.TextBoxAddress.Text.Trim(), this.TextBoxAddress2.Text.Trim(), this.TextBoxAptNum.Text.Trim(),
                                                                         this.TextBoxCity.Text.Trim(), this.RadComboBoxState.SelectedValue, this.TextBoxZip.Text.Trim(), countyId,
                                                                                               AddressTypeID, statusid);
                                     
                }
                else
                {
                    AddressID = POD.Logic.AddressPhoneNumerLogic.AddUpdateAddress(null,  this.TextBoxAddress.Text.Trim(), this.TextBoxAddress2.Text.Trim(), this.TextBoxAptNum.Text.Trim(),
                                                                           this.TextBoxCity.Text.Trim(), this.RadComboBoxState.SelectedValue, this.TextBoxZip.Text.Trim(), countyId,
                                                                           AddressTypeID, statusid);
                }

                return AddressID;
            }
            catch (Exception ex)
            {
                ex.Log();
                return 0;
            }
        }

    }
}