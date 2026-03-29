using POD.Data.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using POD.Logic;

namespace POD.Pages.LessonPlans
{
    public partial class ReviewLessonPlans : System.Web.UI.Page
    {
        int apprStatusid = 0;
        public int ApprovedStatusID
        {
            get
            {
                if (ViewState["ApprovedStatusID"] != null)
                {
                    int.TryParse(ViewState["ApprovedStatusID"].ToString(), out apprStatusid);
                }
                return apprStatusid;
            }
            set
            {
                ViewState["ApprovedStatusID"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ApprovedStatusID = POD.Logic.ManageTypesLogic.GetStatusTypeIDByName("approved");
                LoadDropDowns();
            }
        }

        protected void RadComboBoxSiteLesson_OnSelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            int siteLocationId;
            if (e.OldValue != e.Value
                && Int32.TryParse(e.Value, out siteLocationId)
                && siteLocationId > 0)
            {

                this.RadComboBoxLocation.ClearSelection();
                this.RadComboBoxLocation.Items.Clear();

                this.RadComboBoxClassInstructor.ClearSelection();
                this.RadComboBoxClassInstructor.Items.Clear();


                var personList = Logic.PeopleLogic.GetStaff(siteLocationId);

                var locationsList = Logic.LookUpTypesLogic.GetLocationsBySite(siteLocationId);

                this.RadComboBoxLocation.DataSource = Logic.LookUpTypesLogic.GetLocationsBySite(siteLocationId);
                RadComboBoxClassInstructor.DataSource = personList;
                

                this.RadComboBoxLocation.DataBind();                
                RadComboBoxClassInstructor.DataBind();

                RadComboBoxLocation.Items.Insert(0, new RadComboBoxItem("All", string.Empty));
                RadComboBoxClassInstructor.Items.Insert(0, new RadComboBoxItem("All", string.Empty));

            }
        }
        private void LoadDropDowns()
        {
            this.RadComboBoxLessonPlanType.DataSource = POD.Logic.ManageTypesLogic.GetTypesByType(Data.TypesData.Types.LessonPlanType);
            this.RadComboBoxLessonPlanType.DataBind();

            this.RadComboBoxSite.DataSource = POD.Logic.LookUpTypesLogic.GetSites();
            this.RadComboBoxSite.DataBind();

            this.RadComboBoxLocation.DataSource = POD.Logic.LookUpTypesLogic.GetLocations();
            this.RadComboBoxLocation.DataBind();

            this.RadComboBoxClassInstructor.DataSource = POD.Logic.PeopleLogic.GetStaff(null);
            this.RadComboBoxClassInstructor.DataBind();
            this.RadComboBoxClassInstructor.Filter = RadComboBoxFilter.Contains;

        }
        private List<LessonPlanSet> GetData()
        {
            int progid = 0;
            int? instrcutorid = null;
            int? locid = null;
            int? siteid = null;
            int? typeid = null;
            int? statusid = null;
            if (!string.IsNullOrEmpty(this.RadComboBoxLessonPlanType.SelectedValue))
            {
                int tpid = 0;
                int.TryParse(this.RadComboBoxLessonPlanType.SelectedValue, out tpid);
                if (tpid != 0)
                {
                    typeid = tpid;
                }
            }
            if (!string.IsNullOrEmpty(this.RadComboBoxLocation.SelectedValue))
            {
                int tpid = 0;
                int.TryParse(this.RadComboBoxLocation.SelectedValue, out tpid);
                if (tpid != 0)
                {
                    locid = tpid;
                }
            }
            if (!string.IsNullOrEmpty(this.RadComboBoxSite.SelectedValue))
            {
                int tpid = 0;
                int.TryParse(this.RadComboBoxSite.SelectedValue, out tpid);
                if (tpid != 0)
                {
                    siteid = tpid;
                }
            }
            if (!string.IsNullOrEmpty(this.RadComboBoxClassInstructor.SelectedValue))
            {
                int tpid = 0;
                int.TryParse(this.RadComboBoxClassInstructor.SelectedValue, out tpid);
                if (tpid != 0)
                {
                    instrcutorid = tpid;
                }
            }

            if (!string.IsNullOrEmpty(this.RadComboBoxStatusLPS.SelectedValue))
            {
                int stID = 0;
                int.TryParse(this.RadComboBoxStatusLPS.SelectedValue, out stID);
                if (statusid != 0)
                {
                    statusid = stID;
                }
            }
            string classname = !string.IsNullOrEmpty(this.TextBoxClassName.Text.Trim()) ? this.TextBoxClassName.Text.ToLower().Trim() : string.Empty;
            int.TryParse(Session["ProgramID"].ToString(), out progid);
            IEnumerable<LessonPlanSet> planSets = POD.Logic.ProgramCourseClassLogic.GetLessonPlansSetsByFiltersAdmin(progid, typeid, locid, siteid, instrcutorid, statusid, classname);
            return planSets.OrderBy(s=> s.StatusType.Name).ThenBy(s=> s.Name).ToList();
        }
        protected void RadGridLessonPlanSet_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            RadGridLessonPlanSet.DataSource =  GetData();

        }
        protected void RadGridLessonPlanSet_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item.ItemType == GridItemType.Item || e.Item.ItemType == GridItemType.AlternatingItem)
            {
                GridDataItem dataItem = (GridDataItem)e.Item;
                string statusType = dataItem.GetDataKeyValue("StatusTypeID") != null ? dataItem.GetDataKeyValue("StatusTypeID").ToString() : string.Empty;
                string instuctor = dataItem.GetDataKeyValue("InstructorPersonID") != null ? dataItem.GetDataKeyValue("InstructorPersonID").ToString() : string.Empty;
                int typeID = 0;
                int instructorID = 0;
                int.TryParse(statusType, out typeID);
                int.TryParse(instuctor, out instructorID);
            }

        }

        protected void RadGridLessonPlanSet_DetailTableBind(object sender, Telerik.Web.UI.GridDetailTableDataBindEventArgs e)
        {
            GridDataItem dataItem = (GridDataItem)e.DetailTableView.ParentItem;
            string statusType = dataItem.GetDataKeyValue("StatusTypeID") != null ? dataItem.GetDataKeyValue("StatusTypeID").ToString() : string.Empty;
            string instuctor = dataItem.GetDataKeyValue("InstructorPersonID") != null ? dataItem.GetDataKeyValue("InstructorPersonID").ToString() : string.Empty;
            int typeID = 0;
            int instructorID = 0;
            int.TryParse(statusType, out typeID);
            int.TryParse(instuctor, out instructorID);

        }

        protected void RadGridLessonPlanSet_ItemCommand(object sender, GridCommandEventArgs e)
        {

            string url = "~/Pages/LessonPlans/LessonPlanDetailPage.aspx";
            string lpID = string.Empty;
            string lpSetID = string.Empty;
            switch (e.CommandName)
            {
                case "Edit":
                    if (e.Item.OwnerTableView.Name == "LessonPlanDetail")
                    {
                        lpID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["LessonPlanID"].ToString();
                        lpSetID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["LessonPlanSetID"].ToString();
                        Response.Redirect(string.Format("{0}?ls={1}&lp={2}&tp=lp&a=1", url, lpSetID, lpID));
                    }
                    else
                    {
                        lpSetID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["LessonPlanSetID"].ToString();
                        Response.Redirect(string.Format("{0}?ls={1}&tp=ls&a=1", url, lpSetID));
                    }
                    break;
                case "InitInsert":
                    if (e.Item.OwnerTableView.Name == "LessonPlanDetail")
                    {
                        lpSetID = e.Item.OwnerTableView.ParentItem.GetDataKeyValue("LessonPlanSetID").ToString();
                        Response.Redirect(string.Format("{0}?ls={1}&tp=lp&a=1", url, lpSetID));
                    }
                    else
                    {
                        Response.Redirect(string.Format("{0}?tp=ls&a=1", url));
                    }
                    break;
                case "Delete":
                    if (e.Item.OwnerTableView.Name == "LessonPlanDetail")
                    {
                        lpID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["LessonPlanID"].ToString();
                        string result = POD.Logic.ProgramCourseClassLogic.DeleteLessonPlan(Convert.ToInt32(lpID));
                        if (!string.IsNullOrEmpty(result))
                        {
                            LiteralMessage.Text = string.Format("<span style='color:red;'><strong>{0}</strong></span>",
                                                                result);
                            this.RadGridLessonPlanSet.Rebind();
                        }
                    }
                    else
                    {
                        lpSetID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["LessonPlanSetID"].ToString();
                        string result = POD.Logic.ProgramCourseClassLogic.DeleteLessonPlanSet(Convert.ToInt32(lpSetID));
                        if (!string.IsNullOrEmpty(result))
                        {
                            LiteralMessage.Text = string.Format("<span style='color:red;'><strong>{0}</strong></span>",
                                                                result);
                            this.RadGridLessonPlanSet.Rebind();
                        }
                    }
                    break;
            }
        }

        protected void RadGridLessonPlanSet_EditCommand(object sender, GridCommandEventArgs e)
        {
            e.Canceled = true;
        }

        protected void RadGridLessonPlanSet_InsertCommand(object sender, GridCommandEventArgs e)
        {
            e.Canceled = true;
        }

        /// <summary>
        /// all selected records get approved
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ButtonApprove_Click(object sender, EventArgs e)
        {
            IList<int> lessonPlanSetIDList = new List<int>();
            foreach (GridItem item in this.RadGridLessonPlanSet.Items)
            {
                if (item is GridDataItem)
                {
                    CheckBox box = (CheckBox)item.FindControl("CheckBoxApproval");
                    if (box != null && box.Checked)
                    {
                        GridDataItem dataItem = (GridDataItem)item;
                        string lessonplansetid = dataItem.GetDataKeyValue("LessonPlanSetID").ToString();
                        int ID = 0;
                        int.TryParse(lessonplansetid, out ID);
                        lessonPlanSetIDList.Add(ID);
                    }

                }
            }
            //update to approve status
            if (lessonPlanSetIDList.Count > 0)
            {
                POD.Logic.ProgramCourseClassLogic.UpdateLessonPlanSets(lessonPlanSetIDList, ApprovedStatusID);
            }

            //loop through all the selected lesson plan sets and perform the following action

            foreach (var lpsId in lessonPlanSetIDList)
            {

                var lps = POD.Logic.ProgramCourseClassLogic.GetLessonPlanSet(lpsId);

                //this is where you need to comment back in SKB 09102016

                //Get the lesson plan set information
                if (lps != null)
            {
                var lessonPlanList = POD.Logic.ProgramCourseClassLogic.GetLessonPlansBySetID(lpsId);

                //for each lesson plan in the approved Lesson Plan Set go ahead
                //and create a class , course and schedule
                if (lessonPlanList != null && lessonPlanList.Any())
                {
                    //Create the class
                    var iCourseID = POD.Logic.ProgramCourseClassLogic.AddUpdateCourse(0, lps.Name, Convert.ToInt32(lps.ProgramID), Convert.ToInt32(lps.DisciplineTypeID), Convert.ToInt32(lps.StatusTypeID), "Lesson Plan Set Approved On: " + DateTime.Now + "Class for " + lps.Name + " - Further details to follow");

                    //Create Class Details


                    if (iCourseID > 0)
                    {
                            var courseInstanceId =
                            POD.Logic.ProgramCourseClassLogic.AddUpdateCourseInstance(iCourseID,
                                Convert.ToInt32(lps.SiteLocationID),
                                lps.LessonPlanSetID, lps.StartDate, lps.EndDate, lps.InstructorPersonID,
                                lps.AssistantPersonID,
                                "System Generated Message : Inital Schedule Creation. Class Details to Follow");

                                foreach (var lp in lessonPlanList)
                                {
                                    if (iCourseID > 0)
                                    {
                                        //Create the Schedule for each of the lesson plans 
                                        if (POD.Logic.ProgramCourseClassLogic.AddUpdateClass(0, Convert.ToInt32(lps.DisciplineTypeID), courseInstanceId, Convert.ToInt32(lps.SiteLocationID), lps.SpecificLocationID,
                                        lp.LessonPlanID, lps.InstructorPersonID, lps.AssistantPersonID, Convert.ToInt32(lps.StatusTypeID), lp.StartDate, lp.EndDate, lp.Name))
                                        {

                                        }
                                    }

                                }
                    }
                }

            }

            }


            this.RadGridLessonPlanSet.Rebind();
        }

        protected void secureFilterSite_OnAuthorizationFailed(object sender, EventArgs e)
        {
            var siteId = Convert.ToInt32(Session["UsersSiteID"]);
            if (Page.IsPostBack == false)
            {
                RadComboBoxSite.Items.Clear();
                Site site = LookUpTypesLogic.GetSiteByID(siteId);
                RadComboBoxSite.DataSource = new[] { site };
                RadComboBoxSite.DataBind();
                RadComboBoxSiteLesson_OnSelectedIndexChanged(sender, new RadComboBoxSelectedIndexChangedEventArgs(site.SiteName, null, siteId.ToString(), null));
            }
        }

        protected void secureFilterSite_OnAuthorizationPassed(object sender, EventArgs e)
        {
            if (Page.IsPostBack == false)
            {
                RadComboBoxSite.DataSource = LookUpTypesLogic.GetSites();
                RadComboBoxSite.DataBind();
            }
        }

        protected void Searchbutton_Click(object sender, EventArgs e)
        {
            this.RadGridLessonPlanSet.Rebind();
        }
    }
}