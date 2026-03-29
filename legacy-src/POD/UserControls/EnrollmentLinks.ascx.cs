using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace POD.UserControls
{
    public partial class EnrollmentLinks : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

            }
        }

        /// <summary>
        /// 1 =all three buttons show
        /// 2=Inactive is hidden
        /// 3=Active is hidden
        /// </summary>
        /// <param name="option"></param>
        public void ShowButtons(int option)
        {
            switch (option)
            {
                case 1:
                    this.LiInactive.Visible = true;
                    this.LiActive.Visible = true;
                    //this.LiPreEnrolled.Visible = true;
                    break;
                case 2:
                    this.LiInactive.Visible = false;
                    this.LiActive.Visible = true;
                    //this.LiRiskAssessment.Visible = false;
                    break;
                case 3:
                    this.LiInactive.Visible = true;
                    this.LiActive.Visible = false;
                    break;
                case 4:
                    this.LiInactive.Visible = true;
                    this.LiActive.Visible = true;
                   // this.LiPreEnrolled.Visible = false;
                    //this.LiRiskAssessment.Visible = false;
                    break;
                case 5:
                    this.LiActive.Visible = false;
                    this.LiInactive.Visible = true;
                    //this.LiRiskAssessment.Visible = false;
                    break;
            }
        }
    }
}