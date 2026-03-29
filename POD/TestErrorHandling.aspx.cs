using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using POD.Logging;

namespace POD
{
    public partial class TestErrorHandling : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Button1_OnClick(object sender, EventArgs e)
        {
            try
            {
                throw new ApplicationException("testing error handling");
            }
            catch (Exception ex)
            {
                ex.Log();
            }
        }
    }
}