using POD.Data.Entities;
using POD.Logic;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace POD.Pages.LessonPlans
{
    public partial class LessonPlanDetailPage : System.Web.UI.Page
    {
        private int lessonplanID = 0;
        private int lessonplansetid = 0;
        int staffID = 0;
        List<StaffMember> personList;
        private string detailType = string.Empty;
        private bool IsReviewAdminEdit = false;

        //public int IsReviewAdminEdit
        //{
        //    get
        //    {
        //        if (ViewState["CurrentuserStaffMemberID"] != null)
        //        {
        //            int.TryParse(ViewState["CurrentuserStaffMemberID"].ToString(), out staffID);
        //        }
        //        return staffID;
        //    }
        //    set
        //    {
        //        ViewState["CurrentuserStaffMemberID"] = value;
        //    }
        //}

        public int CurrentuserStaffMemberID
        {
            get
            {
                if (ViewState["CurrentuserStaffMemberID"] != null)
                {
                    int.TryParse(ViewState["CurrentuserStaffMemberID"].ToString(), out staffID);
                }
                return staffID;
            }
            set
            {
                ViewState["CurrentuserStaffMemberID"] = value;
            }
        }
        public int LessonPlanID
        {
            get
            {
                if (ViewState["LessonPlanID"] != null)
                {
                    int.TryParse(ViewState["LessonPlanID"].ToString(), out lessonplanID);
                }
                return lessonplanID;
            }
            set
            {
                ViewState["LessonPlanID"] = value;
            }
        }
        public bool keepEnabled  = true;
        public bool IsCopied = false;
        public int LessonPlanSetID
        {
            get
            {
                if (ViewState["LessonPlanSetID"] != null)
                {
                    int.TryParse(ViewState["LessonPlanSetID"].ToString(), out lessonplansetid);
                }
                return lessonplansetid;
            }
            set
            {
                ViewState["LessonPlanSetID"] = value;
            }
        }

        static string prevPage = String.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            
            if (!IsPostBack)
            {
                ViewState["prevPage"] = Request.UrlReferrer.ToString();
                
                this.TextBoxNameLPS.Attributes["onBlur"] = "populateCalcName()";
                POD.MasterPages.AdminWide mtPage = (POD.MasterPages.AdminWide)this.Master;
                if (mtPage != null)
                {
                    mtPage.SetNavigation("LessonPlan");
                    mtPage.CheckSession();
                }
                if (!string.IsNullOrEmpty(Request.QueryString["c"]))
                {
                    IsCopied = true;
                }

                //Review Admin Check
                if (!string.IsNullOrEmpty(Request.QueryString["a"]))
                {
                    IsReviewAdminEdit = true;
                }

                if (!string.IsNullOrEmpty(Request.QueryString["tp"]))
                {
                    detailType = Request.QueryString["tp"].ToString();
                }
                if (!string.IsNullOrEmpty(Request.QueryString["ls"]))
                {
                    int.TryParse(Request.QueryString["ls"].ToString(), out lessonplansetid);
                    LessonPlanSetID = lessonplansetid;

                }
                if (!string.IsNullOrEmpty(Request.QueryString["lp"]))
                {
                    int.TryParse(Request.QueryString["lp"].ToString(), out lessonplanID);
                    LessonPlanID = lessonplanID;
                }

                if ((LessonPlanID != 0 && detailType == "lp") || (LessonPlanSetID != 0 && detailType == "ls"))
                {
                    this.btnUpdate.Text = "Update";
                    this.btnUpdate.CommandArgument = LessonPlanID != 0 ? LessonPlanID.ToString() : LessonPlanSetID.ToString();
                    this.btnUpdate.CommandName = LessonPlanID != 0 ? "UpdateLessonPlan" : "UpdateLessonPlanSet";

                }
                else if (detailType == "ls")
                {
                    this.btnUpdate.CommandName = "InsertLessonPlanSet";
                }
                else
                {
                    this.btnUpdate.CommandName = "InsertLessonPlan";
                }
                this.ClassesLinks1.SetVisibility(false, false);
                LoadDropDowns();
                LoadLessonPlan();
            }
        }

        private void LoadDropDowns()
        {
            
            

            //filter the list of staff down correctly
            if (Security.UserInRole("SiteTeamUsers") || Security.UserInRole("SiteTeamUsers-NA"))
            {
                int siteid = 0;
                int.TryParse(Session["UsersSiteID"].ToString(), out siteid);
                personList = POD.Logic.PeopleLogic.GetStaff(siteid);
            }
            else
            {
                personList = POD.Logic.PeopleLogic.GetStaff(null);
            }

            RadComboBoxInstructorLPS.DataSource = personList;
            //RadComboBoxInstructorLPS.Filter = RadComboBoxFilter.Contains;
            RadComboBoxInstructorLPS.DataBind();

            //this.RadComboBoxClassAgeGroup.DataSource = POD.Logic.LookUpTypesLogic.GetAgeGroups();
            //this.RadComboBoxClassAgeGroup.DataBind();

            this.RadComboBoxClassAgeGroupLPS.DataSource = POD.Logic.LookUpTypesLogic.GetAgeGroups();
            this.RadComboBoxClassAgeGroupLPS.DataBind();

            this.RadComboBoxLessonPlanType.DataSource = POD.Logic.ManageTypesLogic.GetTypesByType(Data.TypesData.Types.LessonPlanType);
            this.RadComboBoxLessonPlanType.DataBind();

            //status list
                
                var statusList = POD.Logic.LookUpTypesLogic.GetLessonPlanStatusType();

                if(statusList.Count > 0)
                {
                    if (Security.UserInRole("Administrators")) //can see all statuses
                    {
                        if (IsReviewAdminEdit)
                        {
                            statusList = statusList.Where(x => x.Category.ToLower() == "lessonplanset").OrderBy(x => x.Name).ToList();
                        }
                        else
                        {
                            statusList = statusList.Where(x => x.Category.ToLower() == "lessonplanset" && x.Name.ToLower() != "approved").OrderBy(x => x.Name).ToList();
                        }
                        

                    }
                    else
                    {                        
                        statusList = (from x in statusList
                                      where x.Description.ToLower() == "in progress"
                                      select x).OrderBy(x => x.Name).ToList();
                    }
                }

                this.RadComboBoxStatusLPS.Items.Clear();
                this.RadComboBoxStatusLPS.DataSource = statusList;
           

                this.RadComboBoxStatusLPS.DataBind();



            if (Security.UserInRole("Administrators")) //can see all sites
            {
                this.RadComboBoxClassAssistantLesson.DataSource = POD.Logic.PeopleLogic.GetStaff();
                this.RadComboBoxLocationNew.DataSource = POD.Logic.LookUpTypesLogic.GetLocations();
            }
            else
            {
                int siteid = 0;
                int.TryParse(Session["UsersSiteID"].ToString(), out siteid);
                this.RadComboBoxLocationNew.DataSource = POD.Logic.LookUpTypesLogic.GetLocationsBySite(siteid);
                this.RadComboBoxClassAssistantLesson.DataSource = POD.Logic.PeopleLogic.GetStaff(siteid);
            }

            this.RadComboBoxLocationNew.DataBind();
            //this.RadComboBoxLocationNew.Filter = RadComboBoxFilter.Contains;
            this.RadComboBoxClassAssistantLesson.DataBind();
            //this.RadComboBoxClassAssistantLesson.Filter = RadComboBoxFilter.Contains;


            if (detailType == "ls")
            {
                POD.Data.Entities.StaffMember currentStaff = POD.Logic.PeopleLogic.GetStaffByUserID((Guid)POD.Logic.Security.GetCurrentUserProfile().ProviderUserKey);
                if (currentStaff != null)
                {
                    CurrentuserStaffMemberID = currentStaff.PersonID;
                    RadComboBoxItem item = RadComboBoxInstructorLPS.Items.FindItemByValue(CurrentuserStaffMemberID.ToString());
                    if (item != null)
                    {
                        item.Selected = true;
                    }
                }
            }

            if (Security.UserInRole("Administrators") || Security.UserInRole("CentralTeamUsers"))
            {
                //this.RadComboBoxSite.DataSource = POD.Logic.LookUpTypesLogic.GetSites();
                this.RadComboBoxAssistant.DataSource = personList;
                this.RadComboBoxSiteLesson.DataSource = POD.Logic.LookUpTypesLogic.GetSites();

            }
            else
            {
                int siteid = 0;
                int.TryParse(Session["UsersSiteID"].ToString(), out siteid);
                //this.RadComboBoxSite.DataSource =
                //    POD.Logic.LookUpTypesLogic.GetSites().Where(s => s.LocationID == siteid);
                this.RadComboBoxSiteLesson.DataSource =
                    POD.Logic.LookUpTypesLogic.GetSites().Where(s => s.LocationID == siteid);
                RadComboBoxAssistant.DataSource = POD.Logic.PeopleLogic.GetStaff(siteid);
            }
            RadComboBoxAssistant.DataBind();
            //this.RadComboBoxSite.DataBind();
            this.RadComboBoxSiteLesson.DataBind();
            //this.RadComboBoxSiteLesson.Filter = RadComboBoxFilter.Contains;

        }

        private static string GetClassName(string strName)
        {
            string result = strName;
            //parse out the 
            try
            {
               result = strName.Substring(strName.IndexOf("[") + 1, (strName.LastIndexOf("]") - strName.IndexOf("[") - 1 ));

            }
            catch (Exception ex)
            {


                
            }
            return result;
        }

        protected void RadComboBoxSiteLesson_OnSelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            int siteLocationId;
            if (e.OldValue != e.Value
                && Int32.TryParse(e.Value, out siteLocationId)
                && siteLocationId > 0)
            {

                this.RadComboBoxLocationNew.ClearSelection();
                this.RadComboBoxLocationNew.Items.Clear();

                this.RadComboBoxInstructorLPS.ClearSelection();
                this.RadComboBoxInstructorLPS.Items.Clear();

                this.RadComboBoxClassAssistantLesson.ClearSelection();
                this.RadComboBoxClassAssistantLesson.Items.Clear();

                var personList = POD.Logic.PeopleLogic.GetStaff(siteLocationId);

                this.RadComboBoxLocationNew.DataSource = POD.Logic.LookUpTypesLogic.GetLocationsBySite(siteLocationId);
                RadComboBoxInstructorLPS.DataSource = personList;
                this.RadComboBoxClassAssistantLesson.DataSource = personList;

                this.RadComboBoxLocationNew.DataBind();
                this.RadComboBoxClassAssistantLesson.DataBind();                
                RadComboBoxInstructorLPS.DataBind();

                RadComboBoxLocationNew.Items.Insert(0, new RadComboBoxItem("Select Location", string.Empty));                
                RadComboBoxInstructorLPS.Items.Insert(0, new RadComboBoxItem("Select Instructor", string.Empty));
                RadComboBoxClassAssistantLesson.Items.Insert(0, new RadComboBoxItem("Select Assistant", string.Empty));


            }
        }

        private void LoadLessonPlan()
        {
            //set to false by default
            //this.RequiredFieldValidator9.Enabled = false;
            if (detailType == "ls")
            {
                this.PanelLessonPlan.Visible = false;
                this.PanelLessonPlanSet.Visible = true;
                // update the button fields
                this.btnSaveAndNext.Visible = false;
                this.btnUpdate.Text = "Save";
                if (LessonPlanSetID != 0)
                {
                    LessonPlanSet set = POD.Logic.ProgramCourseClassLogic.GetLessonPlanSet(LessonPlanSetID);
                    this.lblCalcName.Text = set.Name;
                    this.hflpsName.Value = set.Name;
                    this.TextBoxNameLPS.Text = GetClassName(set.Name);





                    //status list

                    var statusList = POD.Logic.LookUpTypesLogic.GetLessonPlanStatusType();

                    if (statusList.Count > 0)
                    {
                        if (Security.UserInRole("Administrators")) //can see all sites
                        {
                            if (IsReviewAdminEdit)
                            {
                                statusList = statusList.Where(x => x.Category.ToLower() == "lessonplanset").OrderBy(x => x.Name).ToList();
                            }
                            else
                            {
                                statusList = statusList.Where(x => x.Category.ToLower() == "lessonplanset" && x.Name.ToLower() != "approved").OrderBy(x => x.Name).ToList();
                            }

                        }
                        else
                        {
                            var filteredStatus = statusList.Where(o => o.Description == "in progress");
                            statusList = (from x in statusList
                                          where x.Description.ToLower() == "in progress"
                                          select x).OrderBy(x => x.Name).ToList();
                        }
                    }

                    this.RadComboBoxStatusLPS.Items.Clear();
                    this.RadComboBoxStatusLPS.DataSource = statusList;

                    RadComboBoxStatusLPS.DataBind();
                    RadComboBoxItem item = RadComboBoxStatusLPS.Items.FindItemByValue(set.StatusTypeID.ToString());
                    if (item != null)
                    {
                        item.Selected = true;
                    }
                    item = this.RadComboBoxInstructorLPS.Items.FindItemByValue(set.InstructorPersonID.ToString());
                    if (item != null)
                    {
                        item.Selected = true;
                    }

                    if (Security.UserInRole("Administrators") || Security.UserInRole("SiteTeamUsers"))
                    {
                        this.PanelMarkCompleted.Visible = true;
                    }
                    //new date fields
                    this.rdpstartdatestart.SelectedDate = set.StartDate;
                    this.rdpenddate.SelectedDate = set.EndDate;

                    //this.RadComboBoxClassAgeGroupLPS.DataSource = POD.Logic.LookUpTypesLogic.GetAgeGroups();
                    //this.RadComboBoxClassAgeGroupLPS.DataBind();
                    item = this.RadComboBoxClassAgeGroupLPS.Items.FindItemByValue(set.AgeGroupID.ToString());
                    if (item != null)
                    {
                        item.Selected = true;
                    }

                    item = this.RadComboBoxLocationNew.Items.FindItemByValue(set.SpecificLocationID.ToString());
                    if (item != null)
                    {
                        item.Selected = true;
                    }


                    item = this.RadComboBoxLessonPlanType.Items.FindItemByValue(set.DisciplineTypeID.ToString());
                    if (item != null)
                    {
                        item.Selected = true;
                    }

                    item = this.RadComboBoxSiteLesson.Items.FindItemByValue(set.SiteLocationID.ToString());
                    if (item != null)
                    {
                        item.Selected = true;
                    }

                    item = this.RadComboBoxClassAssistantLesson.Items.FindItemByValue(set.AssistantPersonID.ToString());
                    if (item != null)
                    {
                        item.Selected = true;
                    }

                    

                }
                // Is logged in user an Admin? show the admin option for status
                if (POD.Logic.Security.UserInRole("Administrators"))
                {
                    this.PanelAdminStatus.Visible = true;
                    this.PanelMarkCompleted.Visible = false;
                   // this.RequiredFieldValidator9.Enabled = true;
                }
            }
            else
            {
                this.PanelLessonPlan.Visible = true;
                this.PanelLessonPlanSet.Visible = false;
                LessonPlanSet set = POD.Logic.ProgramCourseClassLogic.GetLessonPlanSet(LessonPlanSetID);

                this.lifeskilltext.Attributes["style"] = "visibility:hidden";
                //load the hidden fields
                this.hfLessonPlanSetId.Value = set.LessonPlanSetID.ToString();
                this.hfLessonPlanSetName.Value = set.Name;
                this.hfAssistant.Value = set.AssistantPersonID.ToString();
                this.hfClassName.Value = set.Name;
                this.hfAgegroup.Value = set.AgeGroupID.ToString();
                this.hfLocation.Value = set.SpecificLocationID.ToString();
                this.hfSite.Value = set.SiteLocationID.ToString();
                this.hfClassType.Value = set.DisciplineTypeID.ToString();

                var siteList = POD.Logic.LookUpTypesLogic.GetSites();

                var newsitelist = LookUpTypesLogic.GetSiteByID(Convert.ToInt32(set.SiteLocationID));
                var locationList = LookUpTypesLogic.GetLocationByID((int)set.SpecificLocationID);
                var ageGroupList = LookUpTypesLogic.GetAgeGroups();
                var planTypeList = (List<LessonPlanType>)ManageTypesLogic.GetTypesByType(Data.TypesData.Types.LessonPlanType) ;

               


                this.lblLessonPlanSetName.Text = set.Name;
                this.lbclassName.Text = set.Name;

                var assistantCheck = personList.FirstOrDefault(t => t.PersonID == set.AssistantPersonID);
                var displayName = string.Empty;
                if (assistantCheck != null)
                {
                    displayName = assistantCheck.FullName;
                }
                

                if (set.AssistantPersonID != null)
                {
                    this.lblLessonPlanAssistant.Text = displayName;
                }

                var planSite = siteList.FirstOrDefault(s => s.LocationID == set.SiteLocationID);
                if (planSite != null)
                    this.lblLessonPlanSite.Text = planSite.Name.ToString();

                this.lblLessonPlanLocation.Text = locationList.Name;

                var foo = planTypeList.FirstOrDefault(p => p.LessonPlanTypeID == set.DisciplineTypeID);
                var sLessonPlanTypeName = "";

                var planType = planTypeList.FirstOrDefault();
                if (planType != null)
                    sLessonPlanTypeName = foo != null ? foo.Name : planType.Name;


                this.lblLessonPlanType.Text = sLessonPlanTypeName;
                this.lblLessonPlanAgeGroup.Text = ageGroupList.FirstOrDefault(p => p.AgeGroupID == set.AgeGroupID).Name;

                //update the button fields
                this.btnUpdate.Text = "Save and Close";
                this.btnSaveAndNext.Visible = true;

                if (LessonPlanID != 0)
                {
                    LessonPlan plan = POD.Logic.ProgramCourseClassLogic.GetLessonPlan(LessonPlanID);
                    StaffMember instructor = personList.FirstOrDefault(p => p.PersonID == plan.InstructorPersonID);
                    if (instructor != null)
                    {
                        this.lblLessonPlanInfoInstructor.Text = instructor.FullName;
                    }
                    RadDatePickerStart.SelectedDate = plan.StartDate;
                    RadDatePickerEndTime.SelectedDate = plan.EndDate;
                    RadDatePickerStartTime.SelectedDate = plan.StartDate;
                    RadEditorObject.Content = plan.Objective;
                    RadEditorTopic.Content = plan.Topic;
                    RadEditorMatNeeded.Content = plan.MaterialsNeeded;
                    RadEditorActProc.Content = plan.ActivityProcedures;
                    RadEditrWrapUp.Content = plan.WrapUpActivity;
                    RadEditorDiscus.Content = plan.Discussion;
                    RadEditorIntro.Content = plan.Introduction;
                    //this.TextboxTheme.Text = plan.CommunityTheme;
                    //this.TextBoxName.Text = plan.Name;
                    this.TextBoxWeek.Text = plan.WeekNumber.ToString();

                    this.RadComboBoxAgeGroup.DataBind();
                    RadComboBoxItem item = this.RadComboBoxAgeGroup.Items.FindItemByValue(plan.AgeGroupID.ToString());
                    if (item != null)
                    {
                        item.Selected = true;
                       
                    }
                    this.RadComboProgramType.DataBind();
                    item = this.RadComboProgramType.Items.FindItemByValue(plan.LessonPlanTypeID.ToString());
                    if (item != null)
                    {
                        item.Selected = true;
                     
                    }
                   
                    //set to selected site related staff
                    this.RadComboBoxAssistant.ClearSelection();
                    this.RadComboBoxAssistant.Items.Clear();
                    this.RadComboBoxAssistant.DataSource = POD.Logic.PeopleLogic.GetStaff(plan.SiteLocationID);
                    this.RadComboBoxAssistant.DataBind();
                    this.RadComboBoxAssistant.Items.Insert(0, new RadComboBoxItem("Select Assistant", ""));


                    if (plan.AssistantPersonID.HasValue)
                    {
                        item = this.RadComboBoxAssistant.Items.FindItemByValue(plan.AssistantPersonID.ToString());
                        if (item != null)
                        {
                            item.Selected = true;
                           
                        }
                    }
                    //this.RadComboBoxDiscipline.DataBind();
                    //item = this.RadComboBoxDiscipline.Items.FindItemByValue(plan.DisciplineTypeID.ToString());
                    //if (item != null)
                    //{
                    //    item.Selected = true;
                    //}

                    //item = this.RadComboBoxSite.Items.FindItemByValue(plan.SiteLocationID.ToString());
                    //if (item != null)
                    //{
                    //    item.Selected = true;
                       
                    //}
                    this.RadComboBoxLocation.DataSource =
                        POD.Logic.LookUpTypesLogic.GetLocationsBySite(plan.SiteLocationID);
                    this.RadComboBoxLocation.DataBind();
                    item = this.RadComboBoxLocation.Items.FindItemByValue(plan.SpecificLocationID.ToString());
                    if (item != null)
                    {
                        item.Selected = true;
                       
                    }

                    //if approved disabel all the inputs
                    if ((plan.LessonPlanSet.StatusType.Name.ToLower() == "approved" || plan.LessonPlanSet.StatusType.Name.ToLower() == "z-inactive")
                        && !POD.Logic.Security.UserInRole("Administrators"))
                    {
                        this.RadComboBoxLocation.Enabled = false;                        
                        this.RadComboBoxAgeGroup.Enabled = false;
                        this.RadComboBoxAssistant.Enabled = false;
                        //this.RadComboBoxDiscipline.Enabled = false;
                        this.RadDatePickerEndTime.Enabled = false;
                        this.RadDatePickerStartTime.Enabled = false;
                        this.RadDatePickerStart.Enabled = false;
                        this.RadComboBoxLifeSkill.Enabled = false;
                        this.ButtonAddLifeskill.Visible = false;
                        this.RadEditorActProc.Enabled = false;
                        this.RadEditorDiscus.Enabled = false;
                        this.RadEditorIntro.Enabled = false;
                        this.RadEditorMatNeeded.Enabled = false;
                        this.RadEditorObject.Enabled = false;
                        this.RadEditorTopic.Enabled = false;
                        this.RadEditrWrapUp.Enabled = false;
                        this.TextBoxWeek.Enabled = false;                       
                        this.RadComboProgramType.Enabled = false;
                        this.btnSaveAndNext.Enabled = false;
                        this.btnUpdate.Visible = false;
                        keepEnabled = false;
                    }
                    BindLifeSkills();
                }
                else
                {
                    var lessonNumber = checkLessonPlanNumber(LessonPlanSetID);
                    this.TextBoxWeek.Text = lessonNumber.ToString();
                    StaffMember instructor = personList.FirstOrDefault(p => p.PersonID == set.InstructorPersonID);
                    if (instructor != null)
                    {
                        this.lblLessonPlanInfoInstructor.Text = instructor.FullName;
                        this.lbclassName.Text = set.Name;
                    }
                }
            }
            CleanupRadEditorContent(RadEditorActProc);
            CleanupRadEditorContent(RadEditorDiscus);
            CleanupRadEditorContent(RadEditorIntro);
            CleanupRadEditorContent(RadEditorMatNeeded);
            CleanupRadEditorContent(RadEditorObject);
            CleanupRadEditorContent(RadEditorTopic);
            CleanupRadEditorContent(RadEditrWrapUp);
        }

        private readonly Regex _cleanupComments = new Regex(@"<!--\[.*?\]-->", RegexOptions.Compiled);
        private void CleanupRadEditorContent(RadEditor radEditor)
        {
            string html = radEditor.Content;
            radEditor.Content = _cleanupComments.Replace(html, string.Empty);
        }

        protected void RadComboBoxSite_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {

            this.RadComboBoxLocation.ClearSelection();
            this.RadComboBoxLocation.Items.Clear();
            this.RadComboBoxAssistant.ClearSelection();
            this.RadComboBoxAssistant.Items.Clear();
            if (!string.IsNullOrEmpty(e.Value))
            {
                this.RadComboBoxLocation.DataSource =
                     POD.Logic.LookUpTypesLogic.GetLocationsBySite(Convert.ToInt32(e.Value));
                this.RadComboBoxLocation.DataBind();
                RadComboBoxAssistant.DataSource = POD.Logic.PeopleLogic.GetStaff(Convert.ToInt32(e.Value));
                RadComboBoxAssistant.DataBind();
            }

            this.RadComboBoxAssistant.Items.Insert(0, new RadComboBoxItem("Select Assistant", ""));
            this.RadComboBoxLocation.Items.Insert(0, new RadComboBoxItem("Select Location", ""));
        }

        protected void ButtonCancel_Click(object sender, EventArgs e)
        {
            //object refUrl = ViewState["prevPage"];
            //if (refUrl != null)
            //    Response.Redirect((string)refUrl);
            Response.Redirect("~/Pages/LessonPlans/LessonPlans.aspx?tp=1");
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            Save(btn.CommandName, true);
        }

        protected static int checkLessonPlanNumber(int lessonPlanSetID)
        {
            var result = 1;

            //need to check the lessonNumber By LessonPlanSetID
            var lessonplans = POD.Logic.ProgramCourseClassLogic.GetLessonPlansBySetID(lessonPlanSetID);

            if(lessonplans.Count() == 0)
            {
                return result;
            }
            else
            {
                    result = (lessonplans.Max(p => (int)p.WeekNumber) + 1);                
            }

            return result;
        }


        private void Save(string name, bool redirect)
        {
            
            if (Page.IsValid)
            {
                if (name == "UpdateLessonPlan" || name == "InsertLessonPlan" || name.ToLower() == "saveadd")
                {
                    LessonPlan newPlan = new LessonPlan();
                    newPlan.LessonPlanID = LessonPlanID;
                    int typeid = 0;

                    int progId = 0;
                    int.TryParse(Session["ProgramID"].ToString(), out progId);
                    int.TryParse(this.RadComboProgramType.SelectedValue, out typeid);

                   
                    LessonPlanSet set = POD.Logic.ProgramCourseClassLogic.GetLessonPlanSet(LessonPlanSetID);

                    

                    var dt = DateTime.Now.ToString("");

                    //SKB WORKING THIS OUT todo
                    var lessonPlanDate = Convert.ToDateTime(RadDatePickerStart.SelectedDate).ToString("MM/dd/yyyy");
                    var dtStartTime = Convert.ToDateTime(RadDatePickerStartTime.SelectedDate).ToString("hh:mm:ss tt");
                    var dtEndTime = Convert.ToDateTime(RadDatePickerEndTime.SelectedDate).ToString("hh:mm:ss tt");

                    var LessonPlanStartDate = Convert.ToDateTime(lessonPlanDate + " " + dtStartTime );
                    var LessonPlanEndDate = Convert.ToDateTime(lessonPlanDate + " " + dtEndTime);

                    newPlan.StartDate = LessonPlanStartDate;
                    newPlan.EndDate = LessonPlanEndDate;
                    //END OF THE EXPERIMENT

                    newPlan.Objective = RadEditorObject.Content.ToString();
                    newPlan.Topic = RadEditorTopic.Content.ToString();
                    newPlan.MaterialsNeeded = RadEditorMatNeeded.Content.ToString();
                    newPlan.ActivityProcedures = RadEditorActProc.Content.ToString();
                    newPlan.WrapUpActivity = RadEditrWrapUp.Content.ToString();
                    newPlan.Discussion = RadEditorDiscus.Content.ToString();
                    newPlan.Introduction = RadEditorIntro.Content.ToString();
                    newPlan.WeekNumber = Convert.ToInt32(TextBoxWeek.Text.Trim());
                    newPlan.Name = set.Name;
                    newPlan.LessonPlanTypeID = (int)set.StatusTypeID;
                    newPlan.StatusTypeID = POD.Logic.ManageTypesLogic.GetStatusTypeIDByName("active");
                    newPlan.ProgramID = (int)set.ProgramID;
                    newPlan.AgeGroupID = (int)set.AgeGroupID;                    
                    newPlan.DisciplineTypeID = (int)set.DisciplineTypeID;
                    newPlan.SiteLocationID = (int)set.SiteLocationID;
                    newPlan.SpecificLocationID = (int)set.SpecificLocationID;
                    newPlan.InstructorPersonID = set.InstructorPersonID;
                    newPlan.AssistantPersonID = set.AssistantPersonID;
                    newPlan.LessonPlanSetID = set.LessonPlanSetID;
                    newPlan.LessonPlanTypeID = (int)set.DisciplineTypeID;

                    if (newPlan.LessonPlanID != 0)
                    {
                        LessonPlanID = POD.Logic.ProgramCourseClassLogic.AddUpdateLessonPlan(newPlan);

                       
                    }
                    else
                    {
                        //LessonPlanID = POD.Logic.ProgramCourseClassLogic.AddUpdateLessonPlan(newPlan, true);

                        LessonPlanID = POD.Logic.ProgramCourseClassLogic.AddUpdateLessonPlan(newPlan);

                        //skb 09142016
                        //var courseIdtmp = POD.Logic.ProgramCourseClassLogic.AddUpdateCourse(0, newPlan.Name, newPlan.ProgramID, newPlan.DisciplineTypeID, newPlan.StatusTypeID, "");

                        //if (courseIdtmp != 0)
                        //{
                        //    //var ci = POD.Logic.ProgramCourseClassLogic.AddUpdateCourseInstance(0, courseIdtmp, newPlan.SpecificLocationID, newPlan.LessonPlanSetID, newPlan.StartDate, newPlan.EndDate, newPlan.InstructorPersonID, newPlan.AssistantPersonID, "");
                        //    var courseInstanceId = POD.Logic.ProgramCourseClassLogic.AddUpdateCourseInstance(courseIdtmp, newPlan.SiteLocationID, newPlan.LessonPlanSetID, newPlan.StartDate, newPlan.EndDate, newPlan.InstructorPersonID, newPlan.AssistantPersonID, "");

                        //    if (courseInstanceId != 0)
                        //    {
                        //        var classId = POD.Data.ProgramCourseClassData.AddUpdateClass(0, newPlan.StatusTypeID, courseInstanceId, newPlan.SiteLocationID, newPlan.SpecificLocationID, LessonPlanID, newPlan.InstructorPersonID, newPlan.AssistantPersonID, newPlan.StatusTypeID, newPlan.StartDate, newPlan.EndDate, newPlan.Name, Security.GetCurrentUserProfile().UserName);
                        //    }
                        //}

                        
                    }

                    //LessonPlanID = POD.Logic.ProgramCourseClassLogic.AddUpdateLessonPlan(newPlan);

                    if (LessonPlanID != 0)//change button
                    {
                        this.btnUpdate.Text = "Update";
                        this.btnUpdate.CommandArgument = LessonPlanID.ToString();
                        this.btnUpdate.CommandName = "UpdateLessonPlan";
                    }
                }
                else
                {
                    if (name == "Dupe")
                    {
                        
                    }
                    LessonPlanSet set = new LessonPlanSet();
                    int progId = 0;
                    int? assistantid = null;
                    int assistID = 0;
                    int locid = 0;
                    int siteId = 0;
                    int typeid = 0;
                    int ageGroupid = 0;
                    int disciplineid = 0;
                    int instructorID = 0;

                    int.TryParse(Session["ProgramID"].ToString(), out progId);
                    

                    //new fields for the lesson plan set

                    int.TryParse(this.RadComboBoxClassAssistantLesson.SelectedValue, out assistID);
                    if (assistID != 0)
                    {
                        assistantid = assistID;
                    }
                    int.TryParse(this.RadComboBoxLocationNew.SelectedValue, out locid);
                    int.TryParse(this.RadComboBoxSiteLesson.SelectedValue, out siteId);
                    int.TryParse(this.RadComboBoxClassAgeGroupLPS.SelectedValue, out ageGroupid);
                    int.TryParse(this.RadComboBoxLessonPlanType.SelectedValue, out disciplineid);
                    int.TryParse(RadComboBoxInstructorLPS.SelectedValue, out instructorID);

                    

                    set.LessonPlanSetID = LessonPlanSetID;
                    set.ProgramID = progId;
                    set.IsPublic = true;
                    set.Name = this.hflpsName.Value;
                    set.StartDate = rdpstartdatestart.SelectedDate;
                    set.EndDate = rdpenddate.SelectedDate;
                    set.AssistantPersonID = assistID;
                    set.AgeGroupID = ageGroupid;
                    set.DisciplineTypeID = disciplineid; 
                    set.InstructorPersonID = instructorID;
                    set.SpecificLocationID = locid;
                    set.SiteLocationID = siteId;

                    int statusTypeid = 0;
                    // Is logged in user an Admin? show the admin option for status
                    if (POD.Logic.Security.UserInRole("Administrators"))
                    {
                        int.TryParse(this.RadComboBoxStatusLPS.SelectedValue, out statusTypeid);
                    }
                    else if (CheckboxMarkCompleted.Checked)
                    {
                        statusTypeid = POD.Logic.ManageTypesLogic.GetStatusTypeIDByName("completed");
                    }
                    else//set to not approved by default
                    {
                        statusTypeid = POD.Logic.ManageTypesLogic.GetStatusTypeIDByName("pre-approved");
                    }
                    LessonPlanSetID = POD.Logic.ProgramCourseClassLogic.AddUpdateLessonPlanSet(set, statusTypeid);

                    //Save for reuse
                    //// THIS IS A NEW FEATURE
                    if (this.cbSaveTemplate.Checked)
                    {
                        var lessonPlanTemplate = new LessonPlanSetTemplate()
                        {
                            LessonPlanSetId = LessonPlanSetID,
                            IsActive = true,
                            LessonPlanSetTemplateType1 = (LessonPlanSetTemplateType)POD.Data.TypesData.GetTypeByTypeAndID(POD.Data.TypesData.Types.LessonPlanSetTemplateType, 2),
                            InstructorId = CurrentuserStaffMemberID,
                            TemplateName = !string.IsNullOrWhiteSpace(this.txtNickName.Text) ? this.txtNickName.Text : "Template Nick Name"

                        };

                        var LessonPlanSetTemplateID = POD.Logic.ProgramCourseClassLogic.AddUpdateLessonPlanSetTemplate(lessonPlanTemplate);
                    }

                    if (LessonPlanSetID != 0)//change button
                    {
                        this.btnUpdate.Text = "Update";
                        this.btnUpdate.CommandArgument = LessonPlanSetID.ToString();
                        this.btnUpdate.CommandName = "UpdateLessonPlanSet";
                    }
                }
                if (redirect)
                {
                    if (!string.IsNullOrEmpty(Request["a"]))//redirect to admin screen.
                    {
                        Response.Redirect("~/Pages/Admin/ReviewLessonPlans.aspx");
                    }
                    else
                    {
                        if (this.cblessonplanadd.Checked)
                        {
                            Server.Transfer("~/Pages/LessonPlans/LessonPlanDetailPage.aspx?ls=" + LessonPlanSetID + "&tp=lp");
                        }
                        else
                        {
                            //if save and add is clicked redirect to a new clean lesson plan
                            if(name == "" || name.ToLower() == "saveadd")
                            {
                                Response.Redirect("~/Pages/LessonPlans/LessonPlanDetailPage.aspx?ls=" + LessonPlanSetID + "&tp=lp");
                            }
                            else
                            {
                                //object refUrl = ViewState["prevPage"];
                                //if (refUrl != null)
                                //    Response.Redirect((string)refUrl);
                               
                                Response.Redirect("~/Pages/LessonPlans/LessonPlans.aspx?tp=1");
                            }
                            
                        }
                        
                    }
                }


            }
        }

        #region Lifeskill

        protected void ButtonAddLifeskill_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                if (LessonPlanID == 0)
                {
                    Save("InsertLessonPlan", false);
                }

                int skillId = 0;
                int.TryParse(this.RadComboBoxLifeSkill.SelectedValue, out skillId);
                POD.Logic.ProgramCourseClassLogic.AddLifeSkillToLessonPlan(LessonPlanID, skillId);

                this.RadComboBoxLifeSkill.ClearSelection();
                BindLifeSkills();
            }
        }

        private void BindLifeSkills()
        {
            var lifeskills = POD.Logic.ProgramCourseClassLogic.GetLifeSkillsByLessonPlanID(LessonPlanID);
            this.DataListLifeSkills.DataSource = lifeskills;

            if (lifeskills.Count() > 0)
            {
                this.lifeskilltext.Text = "1";
            }
            else
            {
                this.lifeskilltext.Text = "";
            }

            this.DataListLifeSkills.DataBind();
        }

        protected void DataListLifeSkills_ItemCommand(object source, DataListCommandEventArgs e)
        {
            int skillId = 0;
            int.TryParse(e.CommandArgument.ToString(), out skillId);
            POD.Logic.ProgramCourseClassLogic.DeleteLifeSkillFromLessonPlan(LessonPlanID, skillId);
            BindLifeSkills();
        }
        
        #endregion

        protected void DataListLifeSkills_ItemDataBound(object sender, DataListItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
            {
                LinkButton button = (LinkButton) e.Item.FindControl("ButtonDelete");
                if (button != null)
                {
                    if (!keepEnabled)
                    {
                        button.Visible = false;
                    }
                }
            }
            
        }

        protected void RadGridTemplate_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            RadGrid lessonSetTemplate = (RadGrid)sender;
            lessonSetTemplate.DataSource = GetLessonPlanSetTemplateData();
        }

        private object GetLessonPlanSetTemplateData()
        {
            var lpsTemplates =  POD.Logic.ProgramCourseClassLogic.GetLessonPlanSetTemplatesByID(CurrentuserStaffMemberID);
            List<LPSTemplateResult> result = new List<LPSTemplateResult>();

            foreach (var item in lpsTemplates)
            {
                var lpsinfo = POD.Logic.ProgramCourseClassLogic.GetLessonPlanSet(item.LessonPlanSetId);
                result.Add(new LPSTemplateResult
                {
                    LessonPlanSetTemplateId = item.LessonPlanSetTemplateId,
                    LessonPlanSetDetails = lpsinfo,
                    LPSTemplateType = item.LessonPlanSetTemplateType, 
                    TemplateName = item.TemplateName
                });
            };
            return result;
        }

        public class LPSTemplateResult
        {
            public int LessonPlanSetTemplateId { get; set; }
            public LessonPlanSet LessonPlanSetDetails { get; set; }
            public int LPSTemplateType { get; set; }
            public string TemplateName { get; set; }
        }

        protected void RadGridTemplate_ItemCommand1(object sender, GridCommandEventArgs e)
        {

            GridDataItem item = e.Item as GridDataItem;
            string strId = item.GetDataKeyValue("LessonPlanSetTemplateId").ToString();
            //var lpstID = [e.Item.ItemIndex]["LessonPlanID"].ToString();
            //var lpSetID = e.Item.OwnerTableView.ParentItem.GetDataKeyValue("LessonPlanSetTemplateId").ToString();
            string result = POD.Logic.ProgramCourseClassLogic.DeleteLessonPlanSetTemplateByID(Convert.ToInt32(strId));
            //if (!string.IsNullOrEmpty(result))
            //{
            //    LiteralMessage.Text = string.Format("<span style='color:red;'><strong>{0}</strong></span>",
            //                                        result);
            this.RadGridTemplate.Rebind();
            //}
        }
    }
}