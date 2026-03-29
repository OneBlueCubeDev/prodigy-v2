using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace POD.Pages
{
    public partial class ShowDuplicateStudents : System.Web.UI.Page
    {
        string personInfo = string.Empty;
        public string PersonInfo
        {
            get
            {
                if (!string.IsNullOrEmpty(Request.QueryString["pinf"]))
                {
                    personInfo = Request.QueryString["pinf"].ToString();
                }
                return personInfo;
            }
            set { personInfo = value; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!string.IsNullOrEmpty(PersonInfo))
                {
                    string[] personinfoArray = PersonInfo.Split('|');
                    DateTime? dob = null;
                    if (personinfoArray.Count() > 3)
                    {
                        DateTime tempdob;
                        if (DateTime.TryParse(personinfoArray[3].ToString(), out tempdob))
                        {
                            dob = tempdob;
                        }
                    }

                    var list = POD.Logic.PeopleLogic.GetPeopleByNameMatch(personinfoArray[0], personinfoArray[1], dob);
                    if (list.Count > 0)
                    {
                        this.DataListPersonMatches.DataSource = list;
                        this.DataListPersonMatches.DataBind();
                    }
                    else
                    {
                       literalCloseWindow.Text ="<script  type='text/javascript' language='javascript'>returnToParent(0);</script>";
                    }
                }
            }
        }
    }
}