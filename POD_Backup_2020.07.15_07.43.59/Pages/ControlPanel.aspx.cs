using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace POD.Pages
{
    public partial class ControlPanel : System.Web.UI.Page
    {
        protected void Page_Load( object sender, EventArgs e )
        {
            if (!IsPostBack)
            {
                POD.MasterPages.AdminWide mtPage = (POD.MasterPages.AdminWide)this.Master;
                if (mtPage != null)
                {
                    mtPage.SetNavigation("Dashboard");
                }
            }
        }
    }
}