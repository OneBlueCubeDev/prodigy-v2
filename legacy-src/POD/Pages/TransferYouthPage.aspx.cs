using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using POD.Logic;
using POD.Data.Entities;
using Telerik.Web.UI;

namespace POD.Pages
{
    public partial class TransferYouthPage : System.Web.UI.Page
    {
        private int personid = 0;
       // private int enrollID = 0;
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
            if (!IsPostBack)
            {
                if(!string.IsNullOrEmpty(Request.QueryString["pid"]))
                {
                    int.TryParse(Request.QueryString["pid"].ToString(), out personid);
                    PersonID = personid;
                }
                //only show if user is admin
                if (Security.UserInRole("Administrators"))
                {
                    RadComboBoxProdigyLocation.DataSource = POD.Logic.LookUpTypesLogic.GetLocations();
                }
                else
                {
                    int siteid = int.Parse(Session["UsersSiteID"].ToString());
                    RadComboBoxProdigyLocation.DataSource = POD.Logic.LookUpTypesLogic.GetLocationsBySite(siteid);
                }
                RadComboBoxProdigyLocation.DataBind();
                Person currentPerson = POD.Logic.PeopleLogic.GetPersonByID(PersonID);
                string locationName = "n/a";
                if (currentPerson != null )
                {                   
                    if (currentPerson.LocationID.HasValue)
                    {
                        RadComboBoxItem item = this.RadComboBoxProdigyLocation.Items.FindItemByValue(currentPerson.LocationID.Value.ToString());
                        if (item != null)
                        {
                            item.Selected = true;
                            locationName = item.Text;
                        }
                    }
                    LiteralYouth.Text = string.Format("{0} {1}'s current location:<br> {2}", currentPerson.FirstName, currentPerson.LastName, locationName);
                }
            }
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                int locid = 0;
                int.TryParse(this.RadComboBoxProdigyLocation.SelectedValue, out locid);
                string result = POD.Logic.PeopleLogic.UpdatePersonLocation(PersonID, locid);

                if(!string.IsNullOrEmpty(result))
                {
                    LiteralErrorMsg.Visible = true;
                    LiteralErrorMsg.Text = "<p>An error occured, please contact your System Administrator<br/><br/>Details: <br/>" + result + "</p>";
                }
                else{
                  ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "CallPArentFunc", "returnToParent();", true);
                }
            }
        }
                
    }
}