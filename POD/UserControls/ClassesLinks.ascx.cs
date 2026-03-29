using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using POD.Logic;

namespace POD.UserControls
{
    public partial class ClassesLinks : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public void SetVisibility(bool isClass, bool isCatalog)
        {
            if (isClass)
            {
                //liNewClass.Visible = true;
                LiSearchClass.Visible = isCatalog;
                //LiClassCatalogs.Visible = !isCatalog;
                LiNewLessonPlan.Visible = false;
                LiActiveLessonPlan.Visible = false;
                LiCompletedLessonPlan.Visible = false;
                LiReviewLessonPlan.Visible = false;
            }
            else
            {
                //liNewClass.Visible = false;
                LiSearchClass.Visible = false;
               // LiClassCatalogs.Visible = false;
                LiNewLessonPlan.Visible = true;
                LiReviewLessonPlan.Visible = true;
                LiActiveLessonPlan.Visible = true;
                LiCompletedLessonPlan.Visible = true;
            }
            }
    }
}