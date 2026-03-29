using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using POD.Logic;
using System.Web.Security;

namespace POD
{
	public partial class Testpage : System.Web.UI.Page
	{
        protected void Page_Load(object sender, EventArgs e)
        {
            int count = POD.Logic.PeopleLogic.GetPeopleByNameMatchCount("akari","isaac", Convert.ToDateTime("9/4/2004"));
            var list = POD.Logic.PeopleLogic.GetPeopleByNameMatch("akari", "isaac", Convert.ToDateTime("9/4/2004"));
            var test = list.Count;



        }
	}
}