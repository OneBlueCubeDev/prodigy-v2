using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using POD.Data.Entities;
using POD.Logging;

namespace POD.UserControls
{
    public partial class AddEditPhoneNumber : System.Web.UI.UserControl
    {
        int phoneid = 0;
        int phonetypeid = 0;

        public int PhoneID
        {
            get
            {
                if (ViewState["PhoneID"] != null)
                {
                    int.TryParse(ViewState["PhoneID"].ToString(), out phoneid);
                }
                return phoneid;
            }
            set
            {
                ViewState["PhoneID"] = value;
            }
        }

        public int PhoneTypeID
        {
            get
            {
                if (ViewState["PhoneTypeID"] != null)
                {
                    int.TryParse(ViewState["PhoneTypeID"].ToString(), out phonetypeid);
                }
                return phonetypeid;
            }
            set
            {
                ViewState["PhoneTypeID"] = value;
            }
        }

        public PhoneNumber currentPhoneNumber = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (PhoneTypeID != 0)
                {
                    this.LabelPhone.Text = ((PhoneNumberType)POD.Logic.ManageTypesLogic.GetTypeByTypeAndID(Data.TypesData.Types.PhoneNumberType, PhoneTypeID)).Name;
                }
                else
                {
                    this.LabelPhone.Text = "Phone";
                }
            }

        }

        /// <summary>
        /// set enabled and validation group
        /// </summary>
        /// <param name="enabled"></param>
        /// <param name="validationGroup"></param>
        public void SetValidation(bool enabled, string validationGroup)
        {
            reqValPhone.Enabled = enabled;
            reqValPhone.ValidationGroup = validationGroup;

        }
        public bool HasPhoneNumber()
        {
            return !string.IsNullOrEmpty(this.TextBoxPhone.Text);
        }
        public void ClearPhoneNumber()
        {
            this.TextBoxPhone.Text = string.Empty;
        }

        public void LoadPhoneNumber(int? personID, int? phoneTypeid)
        {
            if (PhoneID != 0)
            {
                currentPhoneNumber = POD.Logic.AddressPhoneNumerLogic.GetPhoneNumberByID(PhoneID);
            }
            else if (personID.HasValue && phoneTypeid.HasValue)
            {
                currentPhoneNumber = POD.Logic.AddressPhoneNumerLogic.GetPhoneNumberByTypeAndPersonID(phoneTypeid.Value, personID.Value);
            }

            if (currentPhoneNumber != null)
            {
                this.TextBoxPhone.Text = currentPhoneNumber.Phone;
                this.LabelPhone.Text = currentPhoneNumber.PhoneNumberType.Name;
            }

        }

        public void SaveAndAssignPhone(int personid)
        {
            if (!string.IsNullOrEmpty(this.TextBoxPhone.Text))
            {
                SavePhone(personid);
                List<int> idList = new List<int>();
                idList.Add(PhoneID);
                POD.Logic.PeopleLogic.AddPhoneNumbersToPerson(personid, idList);
            }

        }

        private void SavePhone(int personid)
        {
            try
            {
                int newPhoneID = POD.Logic.AddressPhoneNumerLogic.AddUpdatePhoneNumber(PhoneID, personid, this.TextBoxPhone.TextWithLiterals, PhoneTypeID);
                if (PhoneID != 0)
                {
                    //if we created a new phone number remove the original to keep record clean
                    //this only happens if number was assigned to multiple people and we changed it for this person
                    if (newPhoneID != PhoneID)
                    {
                        POD.Logic.PeopleLogic.DeletePhoneNumberFromPerson(personid, PhoneID);
                        PhoneID = newPhoneID;
                        List<int> phoneIDList = new List<int>();
                        phoneIDList.Add(newPhoneID);
                        POD.Logic.PeopleLogic.AddPhoneNumbersToPerson(personid, phoneIDList);
                    }
                }
                else { PhoneID = newPhoneID; }
            }
            catch (Exception ex)
            {
                ex.Log();
            }
        }
        public int SavePhone()
        {
            try
            {
                int phoneid = POD.Logic.AddressPhoneNumerLogic.AddUpdatePhoneNumber(PhoneID, this.TextBoxPhone.TextWithLiterals, PhoneTypeID);
                this.TextBoxPhone.Text = string.Empty;
                return phoneid;
                
            }
            catch (Exception ex)
            {
                ex.Log();
                return 0;
            }
        }

    }
}