using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using POD.Data.Entities;

namespace POD.Templates.Certificates
{
    public partial class PODCompletionCertificate : System.Web.UI.Page
    {
        int personid = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["pid"]))
            {
                int.TryParse(Request.QueryString["pid"].ToString(), out personid);

                Person currentPerson = POD.Logic.PeopleLogic.GetPersonByID(personid);
                if (currentPerson != null)
                {
                    this.LabelRecipient.Text = string.Format("{0} {1}", !string.IsNullOrEmpty(currentPerson.MiddleName) ? currentPerson.FirstName + " " + currentPerson.MiddleName : currentPerson.FirstName, currentPerson.LastName);
                }
            }

        }
    }
}