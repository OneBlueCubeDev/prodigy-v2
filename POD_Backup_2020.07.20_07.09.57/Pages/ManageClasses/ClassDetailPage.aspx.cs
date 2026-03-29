using POD.Data.Entities;
using POD.Logic;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace POD.Pages.Admin.ManageProgramsAndCourses
{
    public partial class ClassDetailPage : System.Web.UI.Page
    {
        private int courseId = 0;
        private int lessonPlanSetID = 0;
        public int CourseID
        {
            get
            {
                if (ViewState["CourseID"] != null)
                {
                    int.TryParse(ViewState["CourseID"].ToString(), out courseId);
                }
                return courseId;
            }
            set
            {
                ViewState["CourseID"] = value;
            }
        }

        public int LessonPlanSetID
        {
            get
            {
                if (ViewState["LessonPlanSetID"] != null)
                {
                    int.TryParse(ViewState["LessonPlanSetID"].ToString(), out lessonPlanSetID);
                }
                return lessonPlanSetID;
            }
            set
            {
                ViewState["LessonPlanSetID"] = value;
            }
        }

        private IEnumerable<CourseInstance> courseInstance = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            LiteralErrorMessage.Text = string.Empty;
            if (!IsPostBack)
            {
                POD.MasterPages.AdminWide mtPage = (POD.MasterPages.AdminWide)this.Master;
                if (mtPage != null)
                {
                    mtPage.SetNavigation("Class");
                    mtPage.CheckSession();
                }
                if (!string.IsNullOrEmpty(Request.QueryString["cid"]))
                {
                    int.TryParse(Request.QueryString["cid"].ToString(), out courseId);
                    CourseID = courseId;

                }
                //for the lesson set information
                if (!string.IsNullOrEmpty(Request.QueryString["ls"]))
                {
                    int.TryParse(Request.QueryString["ls"].ToString(), out lessonPlanSetID);
                    LessonPlanSetID = lessonPlanSetID;

                }
                HiddenFieldCourseID.Value = CourseID.ToString();
                if (CourseID != 0)
                {
                    this.btnUpdate.Text = "Update";
                    this.btnUpdate.CommandArgument = CourseID.ToString();
                    this.btnUpdate.CommandName = "Update";

                    courseInstance = ProgramCourseClassLogic.GetCourseInstancesByCourseID(CourseID);

                    //load up the Lesson Plan Set Information
                    if (courseInstance.FirstOrDefault().LessonPlanSetID != null)
                    {
                        LessonPlanSetID = (int)courseInstance.FirstOrDefault().LessonPlanSetID;
                    }


                }
                this.ClassesLinks1.SetVisibility(true, false);
                LoadCourse();

                if (!Security.UserInRole("Administrators") && !Security.UserInRole("Administrators-NA") && !Security.UserInRole("CentralTeamUsers") && !Security.UserInRole("SiteTeamUsers"))
                {
                    this.RadEditoDesc.Enabled = false;
                }


            }
        }

        private void LoadCourse()
        {
            //Get the Lesson PLan Set information to Prefil
            LessonPlanSet LPset = POD.Logic.ProgramCourseClassLogic.GetLessonPlanSet(LessonPlanSetID);
            

            if (CourseID != 0)
            {
                Course currentcourse = POD.Logic.ProgramCourseClassLogic.GetCourseByID(CourseID);
                

                if (currentcourse != null)
                {
                    if (LPset != null)
                    {
                        TextBoxName.Text = LPset.Name;
                        
                    }

                    TextBoxName.Enabled = false;
                    RadEditoDesc.Content = currentcourse.Description;
                    RadComboProgramType.DataBind();

                    RadComboBoxItem type = RadComboProgramType.Items.FindItemByValue(LPset.DisciplineTypeID.ToString());
                    if (type != null)
                    {
                        type.Selected = true;
                    }
                    RadComboStatusType.DataBind();
                    RadComboBoxItem status = RadComboStatusType.Items.FindItemByValue(currentcourse.StatusType.StatusTypeID.ToString());
                    if (type != null)
                    {
                        type.Selected = true;
                    }

                    if (!Security.UserInRole("Administrators") && !Security.UserInRole("Administrator-NA") && !Security.UserInRole("CentralTeamUsers"))
                    {
                        if (!Security.UserInRole("SiteTeamUsers"))
                        {
                            this.RadGridCourseInstance.MasterTableView.CommandItemSettings.ShowAddNewRecordButton =
                                false;
                        }
                        DataSourceCourseInstance.Where += " && it.[SiteLocationID] ==" + int.Parse(Session["UsersSiteID"].ToString());
                        this.RadGridCourseInstance.Rebind();
                    }

                }
            }
            else
            {
                TextBoxName.Text = LPset.Name;
                TextBoxName.Enabled = false;
                RadComboBoxItem type = RadComboProgramType.Items.FindItemByValue(LPset.DisciplineTypeID.ToString());
                if (type != null)
                {
                    type.Selected = true;
                }
                RadComboStatusType.DataBind();
                RadComboBoxItem status = RadComboStatusType.Items.FindItemByValue(LPset.StatusTypeID.ToString());
                if (type != null)
                {
                    type.Selected = true;
                }
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            Save();
        }

        private void Save()
        {
            Page.Validate();
            if (Page.IsValid)
            {
                int stId = 0;
                int typeid = 0;
                int.TryParse(this.RadComboProgramType.SelectedValue, out typeid);
                int.TryParse(this.RadComboStatusType.SelectedValue, out stId);
                int progID = 0;
                if (Session["ProgramID"] != null)
                {
                    int.TryParse(Session["ProgramID"].ToString(), out progID);
                }
                CourseID = POD.Logic.ProgramCourseClassLogic.AddUpdateCourse(CourseID, this.TextBoxName.Text.Trim(), progID, typeid, stId, this.RadEditoDesc.Content.ToString());
                if (CourseID != 0)
                {
                    this.btnUpdate.Text = "Update";
                    this.btnUpdate.CommandArgument = CourseID.ToString();
                    this.btnUpdate.CommandName = "Update";

                    HiddenFieldCourseID.Value = CourseID.ToString();
                    this.RadGridCourseInstance.SelectedIndexes.Clear();
                    this.RadGridCourseInstance.Rebind();
                }
            }
        }

        protected void ButtonCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Pages/LessonPlans/LessonPlans.aspx?tp=1");
        }

        #region Course Instance aka Class

        protected void RadGridCourseInstance_ItemDatabound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridEditFormItem && e.Item.IsInEditMode)
            {
                GridEditFormItem editItem = (GridEditFormItem)e.Item;

                if (e.Item.OwnerTableView.Name == "RadGridClassess") //class eidt/insert
                {
                    LessonPlanSet LPset = null;
                    int courseInstanceID = 0;
                    CourseInstance currentInstance = null;
                    if (e.Item.OwnerTableView.ParentItem != null) //try getting course instance 
                    {
                        GridDataItem parentItem = e.Item.OwnerTableView.ParentItem as GridDataItem;
                        int.TryParse(parentItem.GetDataKeyValue("CourseInstanceID").ToString(), out courseInstanceID);
                        currentInstance = POD.Logic.ProgramCourseClassLogic.GetCoursesInstanceByID(courseInstanceID);

                        LPset = POD.Logic.ProgramCourseClassLogic.GetLessonPlanSet((int)currentInstance.LessonPlanSetID);
                    }

                    if (editItem != null) //we are editing
                    {
                        List<StaffMember> personList = null;

                        //shane populate of the data
                        var siteList = POD.Logic.LookUpTypesLogic.GetSites().Where(s => s.LocationID == LPset.SiteLocationID);
                        var locationList = POD.Logic.LookUpTypesLogic.GetLocationByID((int)LPset.SpecificLocationID);
                        personList = POD.Logic.PeopleLogic.GetStaff(null);


                        //find the controls
                        var lblAssistant = (Label)editItem.FindControl("lblClassAssistant");
                        var hfAssistant = (HiddenField)editItem.FindControl("hfAssistantSch");
                        
                        var hfsite = (HiddenField)editItem.FindControl("hfSiteSch");

                        var lbltype = (Label)editItem.FindControl("lblClasstype");
                        var hftype = (HiddenField)editItem.FindControl("hftypeSch");

                        var lblInstructor = (Label)editItem.FindControl("lblClassInstructor");
                        var hfInstructor = (HiddenField)editItem.FindControl("hfInstructorSch");

                        var lblLessonPlanLocation = (Label)editItem.FindControl("lblClassLocation");
                        var hfLocation = (HiddenField)editItem.FindControl("hfLocationSch");

                        var lblLessonPlanSetName = (Label)editItem.FindControl("lblClassLessonPlanName");
                        var hfLessonPlanSetName = (HiddenField)editItem.FindControl("hfSetNameSch");
                        var hfLessonPlanSetId = (HiddenField)editItem.FindControl("hfSetIdSch");

                        hfLessonPlanSetId.Value = LPset.LessonPlanSetID.ToString();
                        hfLessonPlanSetName.Value = LPset.Name;
                        hfAssistant.Value = LPset.AssistantPersonID.ToString();
                        hfInstructor.Value = LPset.InstructorPersonID.ToString();
                        hfLocation.Value = LPset.SpecificLocationID.ToString();
                        hftype.Value = LPset.DisciplineTypeID.ToString();
                        hfsite.Value = LPset.SiteLocationID.ToString();
                        //this.hfClassName.Value = LPset.Name;
                        //this.hfAgegroup.Value = LPset.AgeGroupID.ToString();
                        //this.hfSite.Value = LPset.SiteLocationID.ToString();
                        //this.hfClassType.Value = LPset.DisciplineTypeID.ToString();


                        //assign the labels
                        lblAssistant.Text = personList.FirstOrDefault(p => p.PersonID == LPset.AssistantPersonID).FullName;
                        lblInstructor.Text = personList.FirstOrDefault(p => p.PersonID == LPset.InstructorPersonID).FullName;
                        lblLessonPlanSetName.Text = LPset.Name;
                        lblLessonPlanLocation.Text = locationList.Name;
                        

                        //lbltype.Text = LPset.DisciplineTypeID != null ? POD.Logic.ManageTypesLogic.GetStatusTypeNameByID((int)LPset.DisciplineTypeID) : "";

                        //if (Security.UserInRole("Administrators") || Security.UserInRole("Administrator") || Security.UserInRole("Administrator-NA") || Security.UserInRole("CentralTeamUsers"))
                        //{
                        //    personList = POD.Logic.PeopleLogic.GetStaff(null);
                        //}
                        //else
                        //{
                        //    int siteid = 0;
                        //    int.TryParse(Session["UsersSiteID"].ToString(), out siteid);
                        //    personList = POD.Logic.PeopleLogic.GetStaff(siteid);
                        //}

                        RadComboBox instructor = (RadComboBox)editItem.FindControl("RadComboBoxInstructors");
                        RadComboBox assistant = (RadComboBox)editItem.FindControl("RadComboBoxAssistant");

                        RadComboBox statusbox = (RadComboBox)editItem.FindControl("RadComboBoxStatusType");
                        //RadComboBox typeBox = (RadComboBox)editItem.FindControl("RadComboBoxClassTypes");

                        RadComboBox siteBox = (RadComboBox)editItem.FindControl("RadComboBoxSite");
                        RadComboBox locBox = (RadComboBox)editItem.FindControl("RadComboBoxLocation");

                        RadComboBox lessonPlan = (RadComboBox)editItem.FindControl("RadComboBoxLessonPlan");
                        RadDatePicker datePicker = (RadDatePicker)editItem.FindControl("DatePicker");
                        RadTimePicker startPicker = (RadTimePicker)editItem.FindControl("StartTimePicker");
                        RadTimePicker endPicker = (RadTimePicker)editItem.FindControl("EndTimePicker");

                        if (instructor != null)
                        {
                            instructor.DataSource = personList;
                            instructor.DataBind();
                        }
                        if (assistant != null)
                        {
                            assistant.DataSource = personList;
                            assistant.DataBind();
                        }
                        if (currentInstance.LessonPlanSetID.HasValue)
                        {
                            lessonPlan.DataSource =
                                POD.Logic.ProgramCourseClassLogic.GetLessonPlansBySetID(
                                    LessonPlanSetID).OrderBy(c => c.WeekNumber);
                            lessonPlan.DataBind();
                        }
                        if (editItem.DataItem != null && editItem.DataItem is Class)
                        {
                            Class inst = (Class)editItem.DataItem;
                            if (inst.InstructorPersonID.HasValue)
                            {
                                RadComboBoxItem item =
                                    instructor.Items.FindItemByValue(inst.InstructorPersonID.ToString());
                                if (item != null)
                                {
                                    item.Selected = true;
                                }
                            }
                            if (inst.AssistantPersonID.HasValue)
                            {
                                RadComboBoxItem item = assistant.Items.FindItemByValue(inst.AssistantPersonID.ToString());
                                if (item != null)
                                {
                                    item.Selected = true;
                                }
                            }

                            if (inst.LessonPlanID.HasValue)
                            {
                                lessonPlan.DataBind();
                                RadComboBoxItem lpItem = lessonPlan.Items.FindItemByValue(inst.LessonPlanID.ToString());
                                if (lpItem != null)
                                {
                                    lpItem.Selected = true;
                                }
                            }
                            //statusbox.DataBind();
                            //RadComboBoxItem stItem = statusbox.Items.FindItemByValue(inst.CurrentStatusTypeID.ToString());
                            //if (stItem != null)
                            //{
                            //    stItem.Selected = true;
                            //}
                            //typeBox.DataBind();
                            //RadComboBoxItem typeItem = typeBox.Items.FindItemByValue(inst.ClassTypeID.ToString());
                            //if (typeItem != null)
                            //{
                            //    typeItem.Selected = true;
                            //}
                            //if (inst.SiteLocationID.HasValue)
                            //{
                            //    siteBox.DataBind();
                            //    RadComboBoxItem siteItem = siteBox.Items.FindItemByValue(inst.SiteLocationID.ToString());
                            //    if (siteItem != null)
                            //    {
                            //        siteItem.Selected = true;
                            //    }
                            //}
                            //if (inst.SpecificLocationID.HasValue)
                            //{
                            //    locBox.DataBind();
                            //    RadComboBoxItem locItem =
                            //        locBox.Items.FindItemByValue(inst.SpecificLocationID.ToString());
                            //    if (locItem != null)
                            //    {
                            //        locItem.Selected = true;
                            //    }
                            //}

                            if (inst.DateStart.HasValue)
                            {
                                datePicker.SelectedDate = inst.DateStart;
                                startPicker.SelectedDate = inst.DateStart;
                            }
                            if (inst.DateEnd.HasValue)
                            {
                                endPicker.SelectedDate = inst.DateEnd;
                                //endPicker.SelectedTime = inst.DateEnd;
                            }

                        }
                        //preset values for parent course instance
                        else if (currentInstance != null)
                        {
                            LPset = POD.Logic.ProgramCourseClassLogic.GetLessonPlanSet(LessonPlanSetID);

                            if (currentInstance.InstructorPersonID.HasValue)
                            {
                                RadComboBoxItem instrItem =
                                    instructor.Items.FindItemByValue(LPset.InstructorPersonID.ToString());
                                if (instrItem != null)
                                {
                                    instrItem.Selected = true;
                                }
                            }
                            if (currentInstance.AssistantPersonID.HasValue)
                            {
                                RadComboBoxItem assisItem =
                                    assistant.Items.FindItemByValue(LPset.AssistantPersonID.ToString());
                                if (assisItem != null)
                                {
                                    assisItem.Selected = true;
                                }
                            }
                            if (currentInstance.StartDate.HasValue)
                            {
                                datePicker.SelectedDate = currentInstance.StartDate;
                            }
                            locBox.DataBind();
                            
                        }
                    }
                }
                else //course instance edit
                {
                    if (editItem != null)
                    {
                        var LPset = POD.Logic.ProgramCourseClassLogic.GetLessonPlanSet(LessonPlanSetID);
                        List<StaffMember> personList = null;



                        //shane populate of the data
                        var siteList = POD.Logic.LookUpTypesLogic.GetSites().Where(s => s.LocationID == LPset.SiteLocationID);
                        var locationList = POD.Logic.LookUpTypesLogic.GetLocationByID((int)LPset.SpecificLocationID);
                        personList = POD.Logic.PeopleLogic.GetStaff(null);

                        //find the controls
                        var lblAssistant = (Label)editItem.FindControl("lblLessonPlanAssistant");
                        var hfAssistant = (HiddenField)editItem.FindControl("hfAssistant");

                        var lblInstructor = (Label)editItem.FindControl("lblLessonPlanInstructor");
                        var hfInstructor = (HiddenField)editItem.FindControl("hfInstructor");

                        var lblLessonPlanLocation = (Label)editItem.FindControl("lblLessonPlanLocation");
                        var hfLocation = (HiddenField)editItem.FindControl("hfLocation");

                        var lblLessonPlanSetName = (Label)editItem.FindControl("lblLessonPlanSetName");
                        var hfLessonPlanSetName = (HiddenField)editItem.FindControl("hfLessonPlanSetName");
                        var hfLessonPlanSetId = (HiddenField)editItem.FindControl("hfLessonPlanSetId");


                        //assign the hidden controls

                        hfLessonPlanSetId.Value = LPset.LessonPlanSetID.ToString();
                        hfLessonPlanSetName.Value = LPset.Name;
                        hfAssistant.Value = LPset.AssistantPersonID.ToString();
                        hfInstructor.Value = LPset.InstructorPersonID.ToString();
                        hfLocation.Value = LPset.SiteLocationID.ToString();


                        //assign the labels
                        lblAssistant.Text = personList.FirstOrDefault(p => p.PersonID == LPset.AssistantPersonID).FullName;
                        lblInstructor.Text = personList.FirstOrDefault(p => p.PersonID == LPset.InstructorPersonID).FullName;
                        lblLessonPlanSetName.Text = LPset.Name;
                        lblLessonPlanLocation.Text = locationList.Name;

                        //end shane section 


                        
                        RadComboBox instructor = (RadComboBox)editItem.FindControl("RadComboBoxInstructors");
                        //RadComboBox assistant = (RadComboBox)editItem.FindControl("RadComboBoxAssistant");
                        if (instructor != null)
                        {
                            instructor.DataSource = personList;
                            instructor.DataBind();
                            var item = instructor.Items.FindItemByValue(LPset.SpecificLocationID.ToString());
                            if (item != null)
                            {
                                item.Selected = true;
                            }
                        }
                        
                    }
                }
            }
            else if (e.Item is GridDataItem)
            {
                //if not admin then no editing/deleting or adding new classess
                if (!Security.UserInRole("Administrators") && !Security.UserInRole("Administrators-NA") &&
                    !Security.UserInRole("CentralTeamUsers") && !Security.UserInRole("SiteTeamUsers"))
                {
                    if (e.Item.OwnerTableView.Name == "RadGridClassess")
                    {
                        e.Item.OwnerTableView.CommandItemSettings.ShowAddNewRecordButton = false;
                        e.Item.OwnerTableView.Columns.FindByUniqueName("EditColumn").Visible = false;
                       // e.Item.OwnerTableView.Columns.FindByUniqueName("DeleteColumn").Visible = false;

                    }
                    else
                    {
                        e.Item.OwnerTableView.CommandItemSettings.ShowAddNewRecordButton = false;
                        e.Item.OwnerTableView.Columns.FindByUniqueName("EditColumn").Visible = false;
                        //e.Item.OwnerTableView.Columns.FindByUniqueName("DeleteColumn").Visible = false;
                    }
                }

            }
        }
        protected void RadGridCourseInstance_DetailTableBind(object sender, GridDetailTableDataBindEventArgs e)
        {
            //if not admin then no editing/deleting or adding new classess
            if (!Security.UserInRole("Administrators") && !Security.UserInRole("Administrator-NA") && !Security.UserInRole("CentralTeamUsers") && !Security.UserInRole("SiteTeamUsers"))
            {
                e.DetailTableView.CommandItemSettings.ShowAddNewRecordButton = false;
                e.DetailTableView.Columns.FindByUniqueName("EditColumn").Visible = false;
                //e.DetailTableView.Columns.FindByUniqueName("DeleteColumn").Visible = false;

            }
        }
        protected void RadGridCourseInstance_ItemCommand(object sender, GridCommandEventArgs e)
        {
            if ((e.CommandName == "InitInsert") && CourseID == 0)
            {
                Save();
            }
            if (e.CommandName == "AssignPeople")
            {
                string instancekey = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["CourseInstanceID"].ToString();
                string courseKey = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["CourseID"].ToString();
                Response.Redirect(string.Format("~/Pages/ManageClasses/ClassRegistration.aspx?cid={0}&clid={1}", courseKey, instancekey));
            }
        }

        protected void RadGridCourseInstance_Delete(object sender, GridCommandEventArgs e)
        {
            if (e.CommandName == "Delete")
            {
                if (e.Item.OwnerTableView.Name == "RadGridClassess") //class delete
                {
                    int clID = 0;
                    string classStringID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["ClassID"].ToString();
                    int.TryParse(classStringID, out clID);
                    POD.Logic.ProgramCourseClassLogic.DeleteClass(clID);
                }
                else //course instance delete
                {
                    int cID = 0;
                    string courseStringID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["CourseInstanceID"].ToString();
                    int.TryParse(courseStringID, out cID);
                    POD.Logic.ProgramCourseClassLogic.DeleteCourseInstance(cID);
                }
            }
        }

        protected void RadGridCourseInstance_ItemInserted(object sender, GridInsertedEventArgs e)
        {
            GridEditableItem item = (GridEditableItem)e.Item;

            if (e.Exception != null)
            {
                e.KeepInInsertMode = true;
                e.ExceptionHandled = true;
            }
        }

        protected void RadGridCourseInstance_ItemUpdated(object sender, GridUpdatedEventArgs e)
        {
            GridEditableItem item = (GridEditableItem)e.Item;
            if (e.Exception != null)
            {
                e.KeepInEditMode = true;
                e.ExceptionHandled = true;
            }
        }

        protected void RadGridCourseInstance_InsertCommand(object sender, GridCommandEventArgs e)
        {
            LiteralErrorMessage.Visible = false;
            if (e.Item is GridEditFormItem && e.Item.IsInEditMode)
            {
                GridEditFormItem editItem = (GridEditFormItem)e.Item;
                if (e.Item.OwnerTableView.Name == "RadGridClassess") //class insert
                {
                    if (editItem != null)
                    {
                        int courseInstanceID = 0;
                        int.TryParse(e.Item.OwnerTableView.ParentItem.GetDataKeyValue("CourseInstanceID").ToString(), out courseInstanceID);

                        Hashtable values = new Hashtable();
                        editItem.ExtractValues(values);
                        DateTime? start = null;
                        DateTime? end = null;
                        int? locationid = null;
                        int? lessonplanID = null;
                        int lpID = 0;
                        int locid = 0;
                        int siteid = 0;
                        int typeid = 0;
                        int statusid = 0;
                        int? instructorId = null;
                        int? assistantid = null;
                        int instid = 0;
                        int assisid = 0;


                        //start new fields

                        var lblAssistant = (Label)editItem.FindControl("lblClassAssistant");
                        var hfAssistant = (HiddenField)editItem.FindControl("hfAssistantSch");
                        var hfsite = (HiddenField)editItem.FindControl("hfSiteSch");

                        var lbltype = (Label)editItem.FindControl("lblClasstype");
                        var hftype = (HiddenField)editItem.FindControl("hftypeSch");

                        var lblInstructor = (Label)editItem.FindControl("lblClassInstructor");
                        var hfInstructor = (HiddenField)editItem.FindControl("hfInstructorSch");

                        var lblLessonPlanLocation = (Label)editItem.FindControl("lblClassLocation");
                        var hfLocation = (HiddenField)editItem.FindControl("hfLocationSch");

                        var lblLessonPlanSetName = (Label)editItem.FindControl("lblClassLessonPlanName");
                        var hfLessonPlanSetName = (HiddenField)editItem.FindControl("hfSetNameSch");
                        var hfLessonPlanSetId = (HiddenField)editItem.FindControl("hfSetIdSch");

                        instructorId = Convert.ToInt32(hfInstructor.Value);
                        assistantid = Convert.ToInt32(hfAssistant.Value);
                        typeid = Convert.ToInt32(hftype.Value);
                        locationid = Convert.ToInt32(hfLocation.Value);
                        lessonplanID = Convert.ToInt32(hfLessonPlanSetId.Value);
                        siteid = Convert.ToInt32(hfsite.Value);

                        //end new fields
                        //RadComboBox instructor = (RadComboBox)editItem.FindControl("RadComboBoxInstructors");
                        //RadComboBox assistant = (RadComboBox)editItem.FindControl("RadComboBoxAssistant");
                        //RadComboBox locBox = (RadComboBox)editItem.FindControl("RadComboBoxLocation");
                        //RadComboBox lpBox = (RadComboBox)editItem.FindControl("RadComboBoxLessonPlan");
                        //RadComboBox typeBox = (RadComboBox)editItem.FindControl("RadComboBoxClassTypes");

                        RadComboBox siteBox = (RadComboBox)editItem.FindControl("RadComboBoxSite");                        
                        RadComboBox statusbox = (RadComboBox)editItem.FindControl("RadComboBoxStatusType");
                        RadDatePicker datePicker = (RadDatePicker)editItem.FindControl("DatePicker");
                        RadTimePicker startPicker = (RadTimePicker)editItem.FindControl("StartTimePicker");
                        RadTimePicker endPicker = (RadTimePicker)editItem.FindControl("EndTimePicker");

                        if (startPicker.SelectedDate.HasValue && endPicker.SelectedDate.HasValue)
                        {
                            if (startPicker.SelectedDate.Value >= endPicker.SelectedDate.Value)
                            {
                                LiteralErrorMessage.Text = "End Time must be after Start Time";
                                LiteralErrorMessage.Visible = true;
                                e.Canceled = true;
                                return;
                            }
                        }

                        //int.TryParse(lpBox.SelectedValue, out lpID);
                        //if (lpID != 0)
                        //{
                        //    lessonplanID = lpID;
                        //}
                        //int.TryParse(instructor.SelectedValue, out instid);
                        //if (instid != 0)
                        //{
                        //    instructorId = instid;
                        //}
                        //int.TryParse(assistant.SelectedValue, out assisid);
                        //if (assisid != 0)
                        //{
                        //    assistantid = assisid;
                        //}
                        //int.TryParse(locBox.SelectedValue, out locid);
                        //if (locid != 0)
                        //{
                        //    locationid = locid;
                        //}
                        //int.TryParse(siteBox.SelectedValue, out siteid);
                        //int.TryParse(typeBox.SelectedValue, out typeid);
                        int.TryParse(statusbox.SelectedValue, out statusid);

                        if (datePicker.SelectedDate.HasValue && startPicker.SelectedDate.HasValue)
                        {
                            string startDateString = datePicker.SelectedDate.Value.ToShortDateString() + " " + startPicker.SelectedDate.Value.ToShortTimeString();
                            start = Convert.ToDateTime(startDateString);
                        }
                        if (datePicker.SelectedDate.HasValue && endPicker.SelectedDate.HasValue)
                        {
                            string endDateString = datePicker.SelectedDate.Value.ToShortDateString() + " " + endPicker.SelectedDate.Value.ToShortTimeString();
                            end = Convert.ToDateTime(endDateString);
                        }

                        POD.Logic.ProgramCourseClassLogic.AddUpdateClass(0, typeid, courseInstanceID, siteid, locationid, lessonplanID, instructorId.Value, assistantid, statusid, start, end, values["Name"].ToString());
                    }
                }
                else //insert course instance
                {
                    if (editItem != null)
                    {
                        Hashtable values = new Hashtable();
                        editItem.ExtractValues(values);
                        DateTime? start = null;
                        DateTime? end = null;
                        int locationid = 0;
                        int? instructorId = null;
                        int? assistantid = null;
                        int instid = 0;
                        int assisid = 0;
                        int programid = 0;
                        int? lessonplanSetID = null;
                        int.TryParse(Session["ProgramID"].ToString(), out programid);

                        // Shane new fields 


                        var hfAssistant = (HiddenField)editItem.FindControl("hfAssistant");

                        var hfInstructor = (HiddenField)editItem.FindControl("hfInstructor");

                        var hfLocation = (HiddenField)editItem.FindControl("hfLocation");

                        var hfLessonPlanSetName = (HiddenField)editItem.FindControl("hfLessonPlanSetName");
                        var hfLessonPlanSetId = (HiddenField)editItem.FindControl("hfLessonPlanSetId");

                        instructorId = Convert.ToInt32(hfInstructor.Value);
                        assistantid = Convert.ToInt32(hfAssistant.Value);
                        lessonplanSetID = Convert.ToInt32(hfLessonPlanSetId.Value);
                        locationid = Convert.ToInt32(hfLocation.Value);

                        //
                        //RadComboBox instructor = (RadComboBox)editItem.FindControl("RadComboBoxInstructors");
                        //RadComboBox assistant = (RadComboBox)editItem.FindControl("RadComboBoxAssistant");
                        //int.TryParse(instructor.SelectedValue, out instid);
                        //if (instid != 0)
                        //{
                        //    instructorId = instid;
                        //}
                        //int.TryParse(assistant.SelectedValue, out assisid);
                        //if (assisid != 0)
                        //{
                        //    assistantid = assisid;
                        //}

                        //if (!string.IsNullOrEmpty(values["LessonPlanSetID"].ToString()))
                        //{
                        //    lessonplanSetID = int.Parse(values["LessonPlanSetID"].ToString());
                        //}
                        //int.TryParse(values["SiteLocationID"].ToString(), out locationid);

                        if (!string.IsNullOrEmpty(values["StartDate"].ToString()))
                        {
                            start = Convert.ToDateTime(values["StartDate"].ToString());
                        }
                        if (!string.IsNullOrEmpty(values["EndDate"].ToString()))
                        {
                            end = Convert.ToDateTime(values["EndDate"].ToString());
                        }

                        POD.Logic.ProgramCourseClassLogic.AddUpdateCourseInstance(0, CourseID, locationid, lessonplanSetID, start, end, instructorId, assistantid, values["Notes"].ToString());


                        RadGridCourseInstance.Rebind();
                    }
                }

            }

        }

        protected void RadGridCourseInstance_UpdateCommand(object sender, GridCommandEventArgs e)
        {
            if (e.Item is GridEditFormItem && e.Item.IsInEditMode)
            {
                GridEditFormItem editItem = (GridEditFormItem)e.Item;
                if (e.Item.OwnerTableView.Name == "RadGridClassess") //class edit
                {
                    if (editItem != null)
                    {
                        int courseInstID = 0;
                        int.TryParse(editItem.GetDataKeyValue("CourseInstanceID").ToString(), out courseInstID);
                        int classid = 0;
                        int.TryParse(editItem.GetDataKeyValue("ClassID").ToString(), out classid);

                        Hashtable values = new Hashtable();
                        editItem.ExtractValues(values);
                        DateTime? start = null;
                        DateTime? end = null;
                        int? locationid = null;
                        int locid = 0;
                        int siteid = 0;
                        int typeid = 0;
                        int statusid = 0;
                        int? instructorId = null;
                        int? assistantid = null;
                        int instid = 0;
                        int assisid = 0;
                        int? lessonplanID = null;
                        int lpID = 0;
                        RadComboBox instructor = (RadComboBox)editItem.FindControl("RadComboBoxInstructors");
                        RadComboBox assistant = (RadComboBox)editItem.FindControl("RadComboBoxAssistant");
                        RadComboBox statusbox = (RadComboBox)editItem.FindControl("RadComboBoxStatusType");
                        RadComboBox typeBox = (RadComboBox)editItem.FindControl("RadComboBoxClassTypes");
                        RadComboBox siteBox = (RadComboBox)editItem.FindControl("RadComboBoxSite");
                        RadComboBox locBox = (RadComboBox)editItem.FindControl("RadComboBoxLocation");
                        RadComboBox lpBox = (RadComboBox)editItem.FindControl("RadComboBoxLessonPlan");
                        RadDatePicker datePicker = (RadDatePicker)editItem.FindControl("DatePicker");
                        RadTimePicker startPicker = (RadTimePicker)editItem.FindControl("StartTimePicker");
                        RadTimePicker endPicker = (RadTimePicker)editItem.FindControl("EndTimePicker");

                        if (startPicker.SelectedDate.HasValue && endPicker.SelectedDate.HasValue)
                        {
                            if (startPicker.SelectedDate.Value.TimeOfDay >= endPicker.SelectedDate.Value.TimeOfDay)
                            {
                                LiteralErrorMessage.Text = "End Time must be after Start Time";
                                LiteralErrorMessage.Visible = true;
                                e.Canceled = true;
                                return;
                            }
                        }
                        int.TryParse(lpBox.SelectedValue, out lpID);
                        if (lpID != 0)
                        {
                            lessonplanID = lpID;
                        }
                        int.TryParse(instructor.SelectedValue, out instid);
                        if (instid != 0)
                        {
                            instructorId = instid;
                        }
                        int.TryParse(assistant.SelectedValue, out assisid);
                        if (assisid != 0)
                        {
                            assistantid = assisid;
                        }
                        int.TryParse(locBox.SelectedValue, out locid);
                        if (locid != 0)
                        {
                            locationid = locid;
                        }
                        int.TryParse(siteBox.SelectedValue, out siteid);
                        int.TryParse(typeBox.SelectedValue, out typeid);
                        int.TryParse(statusbox.SelectedValue, out statusid);

                        if (datePicker.SelectedDate.HasValue && startPicker.SelectedDate.HasValue)
                        {
                            string startDateString = datePicker.SelectedDate.Value.ToShortDateString() + " " + startPicker.SelectedDate.Value.ToShortTimeString();
                            start = Convert.ToDateTime(startDateString);
                        }
                        if (datePicker.SelectedDate.HasValue && endPicker.SelectedDate.HasValue)
                        {
                            string endDateString = datePicker.SelectedDate.Value.ToShortDateString() + " " + endPicker.SelectedDate.Value.ToShortTimeString();
                            end = Convert.ToDateTime(endDateString);
                        }

                        POD.Logic.ProgramCourseClassLogic.AddUpdateClass(classid, typeid, courseInstID, siteid, locationid, lessonplanID, instructorId.Value, assistantid, statusid, start, end, values["Name"].ToString());
                    }

                }
                else//course instance edit
                {
                    if (editItem != null)
                    {
                        int courseInstanceId = 0;
                        int.TryParse(editItem.GetDataKeyValue("CourseInstanceID").ToString(), out courseInstanceId);
                        Hashtable values = new Hashtable();
                        editItem.ExtractValues(values);
                        DateTime? start = null;
                        DateTime? end = null;
                        int locationid = 0;
                        int? instructorId = null;
                        int? assistantid = null;
                        int instid = 0;
                        int assisid = 0;
                        int programid = 0;
                        int? lessonplanSetID = null;
                        int.TryParse(Session["ProgramID"].ToString(), out programid);

                        if (courseInstanceId != null)
                        {
                            var currentInstance = POD.Logic.ProgramCourseClassLogic.GetCoursesInstanceByID(courseInstanceId);

                            instid = currentInstance.InstructorPersonID.Value;
                            assisid = currentInstance.AssistantPersonID.Value;
                            locationid = currentInstance.SiteLocationID;
                            lessonplanSetID = currentInstance.LessonPlanSetID;
                            start = currentInstance.StartDate.Value;
                            end = currentInstance.EndDate.Value;

                        }
                        

                        //RadComboBox instructor = (RadComboBox)editItem.FindControl("RadComboBoxInstructors");
                        //RadComboBox assistant = (RadComboBox)editItem.FindControl("RadComboBoxAssistant");
                        //int.TryParse(instructor.SelectedValue, out instid);
                        //if (instid != 0)
                        //{
                        //    instructorId = instid;
                        //}
                        //int.TryParse(assistant.SelectedValue, out assisid);
                        //if (assisid != 0)
                        //{
                        //    assistantid = assisid;
                        //}
                        //int.TryParse(values["SiteLocationID"].ToString(), out locationid);
                        //if (!string.IsNullOrEmpty(values["LessonPlanSetID"].ToString()))
                        //{
                        //    lessonplanSetID = int.Parse(values["LessonPlanSetID"].ToString());
                        //}
                        //if (!string.IsNullOrEmpty(values["StartDate"].ToString()))
                        //{
                        //    start = Convert.ToDateTime(values["StartDate"].ToString());
                        //}
                        //if (!string.IsNullOrEmpty(values["EndDate"].ToString()))
                        //{
                        //    end = Convert.ToDateTime(values["EndDate"].ToString());
                        //}

                        POD.Logic.ProgramCourseClassLogic.AddUpdateCourseInstance(courseInstanceId, CourseID, locationid, lessonplanSetID, start, end, instructorId, assistantid, values["Notes"].ToString());
                    }
                }
            }
        }

        #endregion


    }
}