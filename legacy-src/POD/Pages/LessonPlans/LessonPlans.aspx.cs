using iTextSharp.text.pdf;
using POD.Data.Entities;
using POD.Logic;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using Telerik.Pdf;
using iTextSharp.text;
using iTextSharp.text.html.simpleparser;

namespace POD.Pages.LessonPlans
{
    public partial class LessonPlans : System.Web.UI.Page
    {
        Dictionary<string, string> searchParm;
        int apprStatusid = 0;
        int comStatusid = 0;
        int staffID = 0;
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

        public int CompletedStatusID
        {
            get
            {
                if (ViewState["CompletedStatusID"] != null)
                {
                    int.TryParse(ViewState["CompletedStatusID"].ToString(), out comStatusid);
                }
                return comStatusid;
            }
            set
            {
                ViewState["CompletedStatusID"] = value;
            }
        }
        public int InactiveStatusID
        {
            get
            {
                if (ViewState["InactiveStatusID"] != null)
                {
                    int.TryParse(ViewState["InactiveStatusID"].ToString(), out comStatusid);
                }
                return comStatusid;
            }
            set
            {
                ViewState["InactiveStatusID"] = value;
            }
        }
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
      
        protected void Page_Load(object sender, EventArgs e)
        {


            if (!IsPostBack)
            {
                POD.MasterPages.Admin mtPage = (POD.MasterPages.Admin)this.Master;
                if (mtPage != null)
                {
                    mtPage.SetNavigation("LessonPlan");
                    mtPage.SetSearch("LessonPlan");
                    mtPage.CheckSession();
                }
                ApprovedStatusID = POD.Logic.ManageTypesLogic.GetStatusTypeIDByName("approved");
                CompletedStatusID = POD.Logic.ManageTypesLogic.GetStatusTypeIDByName("completed");
                InactiveStatusID = POD.Logic.ManageTypesLogic.GetStatusTypeIDByName("z-inactive");

                POD.Data.Entities.StaffMember currentStaff = POD.Logic.PeopleLogic.GetStaffByUserID((Guid)POD.Logic.Security.GetCurrentUserProfile().ProviderUserKey);
                if (currentStaff != null)
                {
                    CurrentuserStaffMemberID = currentStaff.PersonID;
                }

                this.ClassesLinks1.SetVisibility(false, false);
            }
        }

        private IEnumerable<LessonPlanSet> GetData()
        {
            int progid = 0;
            bool IsSearching = false;
            //search parameters
            if (!string.IsNullOrEmpty(Request.QueryString["sc"]))
            {
                searchParm = POD.Logic.Utilities.GetSearchFilters(Request.QueryString["sc"].ToString(), "LessonPlan");
                IsSearching = true;

            }
            else
            {
                searchParm = POD.Logic.Utilities.SetDefaultSearchFilters("LessonPlan");
                IsSearching = false;
            }

            int? locID = null;
            string name = string.Empty;
            DateTime? startDate = null;
            DateTime? endDate = null;
            DateTime? startDate2 = null;
            DateTime? endDate2 = null;
            int? instructorID = null;
            int? assistantID = null;
            int? LessonPlanStatus = null;
            int? AgeGroup = null;

            int.TryParse(Session["ProgramID"].ToString(), out progid);
            IEnumerable<LessonPlanSet> planSets = new List<LessonPlanSet>();
            int? siteid = null;
            siteid = int.Parse(Session["UsersSiteID"].ToString());
            int type = 0;
            if (searchParm["Loc"] != "-1")
            {
                locID = int.Parse(searchParm["Loc"].ToString());
            }
            if (searchParm["Name"] != "-1")
            {
                name = searchParm["Name"].ToString();
            }
            if (searchParm["Instructor"] != "-1")
            {
                instructorID = int.Parse(searchParm["Instructor"].ToString());
            }
            if (searchParm["Assistant"] != "-1")
            {
                assistantID = int.Parse(searchParm["Assistant"].ToString());
            }
            if (searchParm["LessonPlanStatus"] != "-1")
            {
                LessonPlanStatus = int.Parse(searchParm["LessonPlanStatus"].ToString());
            }
            if (searchParm["AgeGroup"] != "-1")
            {
                AgeGroup = int.Parse(searchParm["AgeGroup"].ToString());
            }
            if (searchParm["RegStartDate"] != "-1")
            {
                startDate = DateTime.Parse(searchParm["RegStartDate"].ToString());
            }
            if (searchParm["RegEndDate"] != "-1")
            {
                endDate = DateTime.Parse(searchParm["RegEndDate"].ToString());
            }
            if (searchParm["RegStartDate2"] != "-1")
            {
                startDate2 = DateTime.Parse(searchParm["RegStartDate2"].ToString());
            }
            if (searchParm["RegEndDate2"] != "-1")
            {
                endDate2 = DateTime.Parse(searchParm["RegEndDate2"].ToString());
            }

            IEnumerable<LessonPlanSet> filteredList = new List<LessonPlanSet>();

            if (!string.IsNullOrEmpty(Request.QueryString["tp"]))
            {
                type = int.Parse(Request.QueryString["tp"].ToString());
            }
            //if (type != 0)
            //{
            if (Security.UserInRole("Administrators")) //admin all my people 
            {
                if (type == 0)
                    type = 1;
                planSets = POD.Logic.ProgramCourseClassLogic.GetLessonPlansSetsByFilters(progid, type, null, null, false);

                if (IsSearching)
                {
                    planSets = POD.Logic.ProgramCourseClassLogic.GetLessonPlansSetsByFilters(planSets, progid, locID, siteid, instructorID, LessonPlanStatus, assistantID, startDate, endDate, name);
                }
            }
            else if (Security.UserInRole("SiteTeamUsers-NA")) //site team user non admin my stuff
            {
                if (type == 0)
                    type = 1;
                planSets = POD.Logic.ProgramCourseClassLogic.GetLessonPlansSetsByFilters(progid, type, null, CurrentuserStaffMemberID, true);

                if (IsSearching)
                {
                    planSets = POD.Logic.ProgramCourseClassLogic.GetLessonPlansSetsByFilters(planSets, progid, locID, siteid, instructorID, LessonPlanStatus, assistantID, startDate, endDate, name);
                }

            }
            else if (Security.UserInRole("SiteTeamUsers")) //site team admin all my people
            {
                if (type == 0)
                    type = 1;
                planSets = POD.Logic.ProgramCourseClassLogic.GetLessonPlansSetsByFilters(progid, type, siteid, null, false);

                if (IsSearching)
                {
                    planSets = POD.Logic.ProgramCourseClassLogic.GetLessonPlansSetsByFilters(planSets, progid, locID, siteid, instructorID, LessonPlanStatus, assistantID, startDate, endDate, name);
                }
            }
            else //anyone higher up all my people
            {

                if (type == 0)
                    type = 1;
                planSets = POD.Logic.ProgramCourseClassLogic.GetLessonPlansSetsByFilters(progid, type, siteid, CurrentuserStaffMemberID, false);

                if (IsSearching)
                {
                    planSets = POD.Logic.ProgramCourseClassLogic.GetLessonPlansSetsByFilters(planSets, progid, locID, siteid, CurrentuserStaffMemberID, LessonPlanStatus, assistantID, startDate, endDate, name);
                }

            }


            return planSets;
        }

        [System.Web.Services.WebMethod]
        public static void GetSomeData()
        {

            //Your Logic comes here
        }

        protected void RadGridLessonPlanSet_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            RadGridLessonPlanSet.DataSource = GetData();
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
                if (dataItem.DataItem is POD.Data.Entities.LessonPlan)
                {
                    //then we are binding detail item
                }
                else
                {
                    ImageButton btn = (ImageButton)e.Item.FindControl("Imagebutton");
                    ImageButton btnDelete = (ImageButton)e.Item.FindControl("ImagebuttonDelete");
                    ImageButton btnManage = (ImageButton)e.Item.FindControl("ManageButton");
                    ImageButton btnCopy = (ImageButton)e.Item.FindControl("CopyButton");
                    Label lbl = (Label)e.Item.FindControl("Label");

                    DuplicateLessonPlan(typeID, btnCopy);

                    if (typeID == ApprovedStatusID || typeID == InactiveStatusID)
                    {

                        btnDelete.Visible = false;
                        //RadGridLessonPlanSet.MasterTableView.GetColumn("AssignPeopleColumn").Visible = true;

                        ManageRegistration(typeID, btnManage);

                        if (Security.UserInRole("Administrators"))
                        {
                            btn.Visible = true;
                            lbl.Visible = false;

                        }
                        else
                        {
                            btn.Visible = false;
                            lbl.Visible = true;
                        }
                    }
                    else if ((CurrentuserStaffMemberID != instructorID && !Security.UserInRole("SiteTeamUsers")) || typeID == CompletedStatusID)
                    {
                        ManageRegistration(typeID, btnManage);
                        DuplicateLessonPlan(typeID, btnCopy);

                        if (Security.UserInRole("Administrators"))
                        {
                            btn.Visible = true;
                            lbl.Visible = false;
                        }
                        else
                        {
                            btn.Visible = false;

                            lbl.Visible = true;
                        }
                        if (typeID == ApprovedStatusID || typeID == InactiveStatusID)
                        {
                            btnDelete.Visible = false;
                        }
                        else
                        {
                            btnDelete.Visible = true;
                        }
                    }
                    else
                    {
                        lbl.Visible = false;
                        btnDelete.Visible = true;
                        btn.Visible = true;
                        ManageRegistration(typeID, btnManage);
                    }
                }
            }
        }

        private void ManageRegistration(int typeID, ImageButton btnManage)
        {
            if (typeID == ApprovedStatusID)
            {
                btnManage.Visible = true;
            }
            else
            {
                btnManage.Visible = false;
            }
        }

        private void DuplicateLessonPlan(int typeID, ImageButton btnCopy)
        {
            if (typeID == ApprovedStatusID)
            {
                btnCopy.Visible = true;
            }
            else
            {
                btnCopy.Visible = false;
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


            //if lesson plan set is approved no edit or additions are permitted
            //neither on lesson plans nor on the set
            if (typeID == ApprovedStatusID || typeID == InactiveStatusID)
            {
                e.DetailTableView.Columns[5].Visible = true;
                e.DetailTableView.Columns[6].Visible = true;
                e.DetailTableView.Columns[7].Visible = false;
                e.DetailTableView.Columns[8].Visible = true;
                e.DetailTableView.CommandItemDisplay = GridCommandItemDisplay.None;
            }
            else if ((CurrentuserStaffMemberID != instructorID && !Security.UserInRole("SiteTeamUsers")) || typeID == CompletedStatusID)
            {
                e.DetailTableView.Columns[5].Visible = true;
                e.DetailTableView.Columns[6].Visible = true;
                if (typeID == CompletedStatusID)
                {
                    e.DetailTableView.Columns[7].Visible = false;
                    e.DetailTableView.Columns[10].Visible = true;
                }
                else
                {
                    e.DetailTableView.Columns[7].Visible = true;
                    e.DetailTableView.Columns[10].Visible = false;
                }
                
                e.DetailTableView.Columns[8].Visible = true;
                e.DetailTableView.CommandItemDisplay = GridCommandItemDisplay.None;
            }
            else
            {
                e.DetailTableView.Columns[8].Visible = false;

                if (typeID == CompletedStatusID)
                {
                    
                    e.DetailTableView.Columns[10].Visible = true;
                }
                else
                {
                   ;
                    e.DetailTableView.Columns[10].Visible = false;
                }

            }
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
                        Response.Redirect(string.Format("{0}?ls={1}&lp={2}&tp=lp", url, lpSetID, lpID));
                    }
                    else
                    {
                        lpSetID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["LessonPlanSetID"].ToString();
                        Response.Redirect(string.Format("{0}?ls={1}&tp=ls", url, lpSetID));
                    }
                    break;
                case "InitInsert":
                    if (e.Item.OwnerTableView.Name == "LessonPlanDetail")
                    {
                        lpSetID = e.Item.OwnerTableView.ParentItem.GetDataKeyValue("LessonPlanSetID").ToString();
                        Response.Redirect(string.Format("{0}?ls={1}&tp=lp", url, lpSetID));
                    }
                    else
                    {
                        Response.Redirect(string.Format("{0}?tp=ls", url));
                    }
                    break;
                case "View":
                    if (e.Item.OwnerTableView.Name == "LessonPlanDetail")
                    {
                        lpID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["LessonPlanID"].ToString();
                        lpSetID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["LessonPlanSetID"].ToString();
                        Response.Redirect(string.Format("{0}?ls={1}&lp={2}&tp=lp", url, lpSetID, lpID));
                    }
                    break;
                case "CopyLesson":
                    //if (e.Item.OwnerTableView.Name == "LessonPlanDetail")
                    //{
                        //get the lesson plan set ID
                        var LPSID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["LessonPlanSetID"].ToString();

                        
                        if (LPSID != null)
                        {
                            var dupeResult = DuplicateLessonPlanSet(LPSID);
                        Response.Redirect(string.Format("{0}?ls={1}&tp=ls&c=1", url, dupeResult));

                    }
                    break;
                case "PrintLessonPlanSet":

                    var LPSID2 = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["LessonPlanSetID"].ToString();
                    var _lessonset = POD.Logic.ProgramCourseClassLogic.GetLessonPlanSet(Convert.ToInt32(LPSID2));

                    if (LPSID2 != null)
                    {
                        var lessonPlanList = POD.Logic.ProgramCourseClassLogic.GetLessonPlansBySetID(Convert.ToInt32(LPSID2));
                        
                        foreach (var lp in lessonPlanList)
                        {
                            GeneratePDFdata(Convert.ToInt32(LPSID2), lp.LessonPlanID);
                        }
                    }

                    using (MemoryStream finalStream = new MemoryStream())
                    {
                        //Create our copy object
                        PdfCopyFields copy = new PdfCopyFields(finalStream);

                        //Loop through each MemoryStream
                        foreach (MemoryStream ms in memoryStreams)
                        {
                            MemoryStream ms2 = new MemoryStream(ms.ToArray());
                            //var sr = new StreamReader(ms);
                            //Reset the position back to zero
                            ms2.Position = 0;
                            //Add it to the copy object
                            copy.AddDocument(new PdfReader(ms2));
                            //Clean up
                            ms2.Dispose();
                        }
                        //Close the copy object
                        copy.Close();

                        HttpContext.Current.Response.Buffer = true;
                        //string filename = "LessonPlanSet_TEST.pdf";

                        string filename = "LessonPlanSet_" + _lessonset.Name + "_" + Guid.NewGuid() + ".pdf";

                        HttpContext.Current.Response.ContentType = "application/pdf";
                        HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=\"" + filename + "\"");
                        HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);

                        HttpContext.Current.Response.BinaryWrite(finalStream.ToArray());

                    }


                    //}
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
                case "Class":
                    if (e.Item.OwnerTableView.Name == "LessonPlanDetail")
                    {
                        var classURL = "~/Pages/ManageClasses/ClassDetailpage.aspx";
                       
                        lpSetID = e.Item.OwnerTableView.ParentItem.GetDataKeyValue("LessonPlanSetID").ToString();
                        var ci = POD.Logic.ProgramCourseClassLogic.GetCourseInstancesByLessonPlanSetID(Convert.ToInt32(lpSetID)).OrderByDescending(a => a.CourseID).FirstOrDefault();
                        Response.Redirect(string.Format("{0}?cid={1}", classURL, ci.CourseID));
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
                case "AssignPeople":

                    lpSetID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["LessonPlanSetID"].ToString();
                    var courseInstance = ProgramCourseClassLogic.GetCourseInstancesByLessonPlanSetID(Convert.ToInt32(lpSetID)).OrderByDescending(a => a.CourseID).FirstOrDefault();
                    //string courseKey = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["CourseID"].ToString();
                    Response.Redirect(string.Format("~/Pages/ManageClasses/ClassRegistration.aspx?lps=1&cid={0}&clid={1}", courseInstance.CourseID, courseInstance.CourseInstanceID));
                    break;
            }
        }

        List<MemoryStream> memoryStreams = new List<MemoryStream>();
        

        private void GeneratePDFdata(int lessonplansetid, int lessonplanId)
        {

            try
            {
                var _lessonset = POD.Logic.ProgramCourseClassLogic.GetLessonPlanSet(lessonplansetid);
                var _lessonplan = ProgramCourseClassLogic.GetLessonPlan(lessonplanId);
                var _siteList = POD.Logic.LookUpTypesLogic.GetSites();
                var _personList = POD.Logic.PeopleLogic.GetStaff(_lessonset.SiteLocationID);
                var _locationList = LookUpTypesLogic.GetLocationByID((int)_lessonset.SpecificLocationID);
                var lifeskills = POD.Logic.ProgramCourseClassLogic.GetLifeSkillsByLessonPlanID(lessonplanId);

                if (_lessonset.SiteLocationID != null)
                {
                    var newsitelist = LookUpTypesLogic.GetSiteByID(Convert.ToInt32(_lessonset.SiteLocationID));
                }

                if (_lessonset.SpecificLocationID != null)
                {
                    var locationList = LookUpTypesLogic.GetLocationByID((int)_lessonset.SpecificLocationID);
                }



                var ageGroupList = LookUpTypesLogic.GetAgeGroups();
                var planTypeList = (List<LessonPlanType>)ManageTypesLogic.GetTypesByType(Data.TypesData.Types.LessonPlanType);

                var planSite = _siteList.FirstOrDefault(s => s.LocationID == _lessonset.SiteLocationID);



                MemoryStream ms = new MemoryStream();

                string sTemplate = Path.Combine(HttpContext.Current.Request.PhysicalApplicationPath, @"App_Data\lp.pdf");

                PdfReader pdfReader = new PdfReader(sTemplate);
                PdfStamper pdfStamper = new PdfStamper(pdfReader, ms);

                PdfContentByte cb = pdfStamper.GetOverContent(1);
                AcroFields pdfFormFields = pdfStamper.AcroFields;

                pdfFormFields.SetField("name", _lessonset.Name != null ? _lessonset.Name : "");  //
                //pdfFormFields.SetField("agegroup", _lessonset.AgeGroupID != null ? _lessonset.AgeGroupID.ToString() : "");  //
                //pdfFormFields.SetField("location", _lessonset.Name != null ? _lessonset.Name : "");  //

                if (_lessonplan.InstructorPersonID != null)
                {
                    StaffMember instructor = _personList.FirstOrDefault(p => p.PersonID == _lessonplan.InstructorPersonID);
                    if (instructor != null)
                    {
                        pdfFormFields.SetField("instructor", instructor.FullName != null ? instructor.FullName : "");  //

                    }
                }

                if (_lessonplan.AssistantPersonID != null)
                {
                    StaffMember assistant = _personList.FirstOrDefault(p => p.PersonID == _lessonplan.AssistantPersonID);
                    if (assistant != null)
                    {
                        pdfFormFields.SetField("assistant", assistant.FullName != null ? assistant.FullName : "");  //

                    }
                }

                foreach (var skill in lifeskills)
                {

                    switch (skill.LifeSkillTypeID)
                    {
                        case 1:
                            pdfFormFields.SetField("c1", "Yes");
                            break;
                        case 2:
                            pdfFormFields.SetField("c2", "Yes");
                            break;
                        case 3:
                            pdfFormFields.SetField("c3", "Yes");
                            break;
                    }
                }


                if (planSite != null)
                    pdfFormFields.SetField("sitename", planSite.Name.ToString() != null ? planSite.Name.ToString() : "");  //


                if (planSite != null)
                    pdfFormFields.SetField("location", _locationList.Name != null ? _locationList.Name : "");  //


                var foo = planTypeList.FirstOrDefault(p => p.LessonPlanTypeID == _lessonset.DisciplineTypeID);
                var sLessonPlanTypeName = "";

                var planType = planTypeList.FirstOrDefault();
                if (planType != null)
                    sLessonPlanTypeName = foo != null ? foo.Name : planType.Name;


                //this.lblLessonPlanType.Text = sLessonPlanTypeName;
                pdfFormFields.SetField("classtype", sLessonPlanTypeName != null ? sLessonPlanTypeName : "");  //

                pdfFormFields.SetField("agegroup", ageGroupList.FirstOrDefault(p => p.AgeGroupID == _lessonset.AgeGroupID).Name != null ? ageGroupList.FirstOrDefault(p => p.AgeGroupID == _lessonset.AgeGroupID).Name : "");  //


                var lessonPlanDate = Convert.ToDateTime(_lessonplan.StartDate).ToString("MM/dd/yyyy");
                var dtStartTime = Convert.ToDateTime(_lessonplan.StartDate).ToString("hh:mm:ss tt");
                var dtEndTime = Convert.ToDateTime(_lessonplan.EndDate).ToString("hh:mm:ss tt");

                pdfFormFields.SetField("classnum", _lessonplan.WeekNumber.ToString() != null ? _lessonplan.WeekNumber.ToString() : "");  //
                pdfFormFields.SetField("classname", _lessonset.Name != null ? GetClassName(_lessonset.Name) : "");  //
                pdfFormFields.SetField("lessonplandate", lessonPlanDate != null ? lessonPlanDate : "");
                pdfFormFields.SetField("starttime", dtStartTime != null ? dtStartTime : "");  //
                pdfFormFields.SetField("endtime", dtEndTime != null ? dtEndTime : "");  //

                pdfFormFields.SetField("closing", _lessonplan.WrapUpActivity != null ? StripHTML(_lessonplan.WrapUpActivity) : "");  //
                pdfFormFields.SetField("warmup", _lessonplan.Introduction != null ? StripHTML(_lessonplan.Introduction) : "");
                pdfFormFields.SetField("procedures", _lessonplan.ActivityProcedures != null ? StripHTML(_lessonplan.ActivityProcedures) : "");  //
                pdfFormFields.SetField("artobjective", _lessonplan.Objective != null ? StripHTML(_lessonplan.Objective) : "");  //
                pdfFormFields.SetField("materials", _lessonplan.MaterialsNeeded != null ? StripHTML(_lessonplan.MaterialsNeeded) : "");  //
                pdfFormFields.SetField("ongoing", _lessonplan.Discussion != null ? StripHTML(_lessonplan.Discussion) : "");  //
                pdfFormFields.SetField("artactivity", _lessonplan.Topic != null ? StripHTML(_lessonplan.Topic) : "");  //



                //close up processing
                pdfStamper.FormFlattening = true;
                if (pdfStamper != null)
                { pdfStamper.Close(); }

                pdfReader.Close();

                //HttpContext.Current.Response.Buffer = true;
                //string filename = "LessonPlanSet_" + _lessonplan.LessonPlanID + "_" + Guid.NewGuid() + ".pdf";

                //HttpContext.Current.Response.ContentType = "application/pdf";
                //HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=\"" + filename + "\"");
                //HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);

                //HttpContext.Current.Response.BinaryWrite(ms.ToArray());

                memoryStreams.Add(ms);

                //Document pdfDoc = new Document(PageSize.A4, 10f, 10f, 100f, 0f);
                //HTMLWorker htmlparser = new HTMLWorker(pdfDoc);
                //iTextSharp.text.pdf.PdfWriter.GetInstance(pdfDoc, HttpContext.Current.Response.OutputStream);
                //pdfDoc.Open();

            }
            catch (Exception ex )
            {

                throw;
            }
           

        }




        private static string GetClassName(string strName)
        {
            string result = strName;
            //parse out the 
            try
            {
                result = strName.Substring(strName.IndexOf("[") + 1, (strName.LastIndexOf("]") - strName.IndexOf("[") - 1));

            }
            catch (Exception ex)
            {



            }
            return result;
        }
        public static string StripHTML(string input)
        {
            return Regex.Replace(input, "<.*?>", String.Empty);
        }

        private int DuplicateLessonPlanSet(string lessonPlanSetID)
        {
            int result = 0;
            int LPSID = 0;
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
            IEnumerable<LessonPlan> lpResult = null;

            LPSID = Convert.ToInt32(lessonPlanSetID);

            var lpsResult = POD.Logic.ProgramCourseClassLogic.GetLessonPlanSet(LPSID);

            //Get the lesson plans for the lesson plan set ID
            if (lpsResult != null)
            {
                
                lpResult = ProgramCourseClassLogic.GetLessonPlansBySetID(LPSID);
            }

            set.LessonPlanSetID = 0;
            set.ProgramID = lpsResult.ProgramID;
            set.IsPublic = true;
            set.Name = lpsResult.Name;
            set.StartDate = lpsResult.StartDate;
            set.EndDate = lpsResult.EndDate;
            set.AssistantPersonID = lpsResult.AssistantPersonID;
            set.AgeGroupID = lpsResult.AgeGroupID;
            set.DisciplineTypeID = lpsResult.DisciplineTypeID;
            set.InstructorPersonID = lpsResult.InstructorPersonID;
            set.SpecificLocationID = lpsResult.SpecificLocationID;
            set.SiteLocationID = lpsResult.SiteLocationID;

            int LessonPlanSetIDresult = 0;

            LessonPlanSetIDresult = POD.Logic.ProgramCourseClassLogic.AddUpdateLessonPlanSet(set, 7);

            if (LessonPlanSetIDresult != 0)
            {
                result = LessonPlanSetIDresult;
                if (lpResult != null && lpResult.Any())
                {
                    foreach (var lp in lpResult)
                    {
                        //Create each lesson plan
                        LessonPlan newPlan = new LessonPlan();
                        newPlan.LessonPlanID = 0;

                        newPlan.StartDate = lp.StartDate;
                        newPlan.EndDate = lp.EndDate;
                        //END OF THE EXPERIMENT

                        newPlan.Objective = lp.Objective;
                        newPlan.Topic = lp.Topic;
                        newPlan.MaterialsNeeded = lp.MaterialsNeeded;
                        newPlan.ActivityProcedures = lp.ActivityProcedures;
                        newPlan.WrapUpActivity = lp.WrapUpActivity;
                        newPlan.Discussion = lp.Discussion;
                        newPlan.Introduction = lp.Introduction;
                        newPlan.WeekNumber = lp.WeekNumber;
                        newPlan.Name = lp.Name;
                        newPlan.LessonPlanTypeID = lp.LessonPlanTypeID;
                        newPlan.StatusTypeID = POD.Logic.ManageTypesLogic.GetStatusTypeIDByName("active");
                        newPlan.ProgramID = lp.ProgramID;
                        newPlan.AgeGroupID = lp.AgeGroupID;
                        newPlan.DisciplineTypeID = lp.DisciplineTypeID;
                        newPlan.SiteLocationID = lp.SiteLocationID;
                        newPlan.SpecificLocationID = lp.SpecificLocationID;
                        newPlan.InstructorPersonID = lp.InstructorPersonID;
                        newPlan.AssistantPersonID = lp.AssistantPersonID;
                        newPlan.LessonPlanSetID = LessonPlanSetIDresult;
                        newPlan.LessonPlanTypeID = lp.LessonPlanTypeID;

                        var LessonPlanID = POD.Logic.ProgramCourseClassLogic.AddUpdateLessonPlan(newPlan);
                    }

                }
            }
            

            
            

            //Create a Lesson Plan Set using all the same information
            // - exception add the name "Duplicate -" to the beginning of the name

            //if successful then loop through and create lesson plans for the same number that are in the lesson plan set



            return result;
        }

        protected void RadGridLessonPlanSet_EditCommand(object sender, GridCommandEventArgs e)
        {
            e.Canceled = true;
        }

        protected void RadGridLessonPlanSet_InsertCommand(object sender, GridCommandEventArgs e)
        {
            e.Canceled = true;
        }


        protected void RadGridLessonPlanSet_OnPreRender(object sender, EventArgs e)
        {
            //checking to see if in Approved Status Type.
            //var typeID = int.Parse(Request.QueryString["tp"].ToString());
            //if (typeID != 2)
            //{
            //    RadGridLessonPlanSet.MasterTableView.GetColumn("AssignPeopleColumn").Visible = false;
            //}
        }
    }
}