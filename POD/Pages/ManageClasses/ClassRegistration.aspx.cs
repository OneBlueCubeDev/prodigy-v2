using iTextSharp.text.pdf;
using POD.Data.Entities;
using POD.Logic;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace POD.Pages.ManageClasses
{
    public partial class ClassRegistration : System.Web.UI.Page
    {
        private int courseInstId = 0;
        private int lpsId = 0;

        public int CourseInstanceID
        {
            get
            {
                if (ViewState["CourseInstanceID"] != null)
                {
                    int.TryParse(ViewState["CourseInstanceID"].ToString(), out courseInstId);
                }
                return courseInstId;
            }
            set
            {
                ViewState["CourseInstanceID"] = value;
            }
        }
        private int courseId = 0;
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
        public int LpsId
        {
            get
            {
                if (ViewState["lpsId"] != null)
                {
                    int.TryParse(ViewState["lpsId"].ToString(), out lpsId);
                }
                return lpsId;
            }
            set
            {
                ViewState["lpsId"] = value;
            }
        }

        private IEnumerable<CourseInstance> courseInstance = null;

        private void LoadCourse()
        {
            //Get the Lesson PLan Set information to Prefil
            LessonPlanSet LPset = POD.Logic.ProgramCourseClassLogic.GetLessonPlanSet(LpsId);


            if (CourseID != 0)
            {
                Course currentcourse = POD.Logic.ProgramCourseClassLogic.GetCourseByID(CourseID);


                if (currentcourse != null)
                {
                    
                        
                        DataSourceCourseInstance.Where += " && it.[SiteLocationID] ==" + int.Parse(Session["UsersSiteID"].ToString());
                        this.RadGridCourseInstance.Rebind();
                   

                }
            }
            
        }

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
                        //e.Item.OwnerTableView.Columns.FindByUniqueName("EditColumn").Visible = false;
                        // e.Item.OwnerTableView.Columns.FindByUniqueName("DeleteColumn").Visible = false;

                    }
                    else
                    {
                        e.Item.OwnerTableView.CommandItemSettings.ShowAddNewRecordButton = false;
                        //e.Item.OwnerTableView.Columns.FindByUniqueName("EditColumn").Visible = false;
                        //e.Item.OwnerTableView.Columns.FindByUniqueName("DeleteColumn").Visible = false;
                    }
                }

            }
        }
        protected void RadGridCourseInstance_DetailTableBind(object sender, GridDetailTableDataBindEventArgs e)
        {
            
        }

        protected void RadGridCourseInstance_ItemCommand(object sender, GridCommandEventArgs e)
        {
            

            if (e.CommandName == "print")
            {
                string lpID = string.Empty;
                string lpSetID = string.Empty;
                string CourseInstanceID = string.Empty;
                string classId = string.Empty;



                //generateSecondPDF();
                CourseInstanceID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["CourseInstanceID"].ToString();
                classId = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["ClassID"].ToString();
                if (CourseInstanceID != null && classId != null)
                {

                    GeneratePDFdata(Convert.ToInt32(CourseInstanceID), Convert.ToInt32(classId));
                }
            }

        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                
                POD.MasterPages.Admin mtPage = (POD.MasterPages.Admin)this.Master;
                if (mtPage != null)
                {
                    mtPage.SetSearch("Class");
                    mtPage.SetNavigation("Class");
                }
                if (!string.IsNullOrEmpty(Request.QueryString["clid"]))
                {
                    int.TryParse(Request.QueryString["clid"].ToString(), out courseInstId);
                    CourseInstanceID = courseInstId;
                }
                if (!string.IsNullOrEmpty(Request.QueryString["lps"]))
                {
                    int.TryParse(Request.QueryString["lps"].ToString(), out lpsId);
                    LpsId = lpsId;

                }
                if (!string.IsNullOrEmpty(Request.QueryString["cid"]))
                {
                    int.TryParse(Request.QueryString["cid"].ToString(), out courseId);
                    CourseID = courseId;
                    LoadData();
                }

                
                if (CourseID != 0)
                {


                    courseInstance = ProgramCourseClassLogic.GetCourseInstancesByCourseID(CourseID);

                    //load up the Lesson Plan Set Information
                    if (courseInstance.FirstOrDefault().LessonPlanSetID != null)
                    {
                        LpsId = (int)courseInstance.FirstOrDefault().LessonPlanSetID;
                    }

                    HiddenFieldCourseID.Value = CourseID.ToString();

                    LoadCourse();

                }

                this.ClassesLinks1.SetVisibility(true, true);
            }

        }

        private void LoadData()
        {
            if (CourseInstanceID != 0)
            {
                CourseInstance instance = POD.Logic.ProgramCourseClassLogic.GetCoursesInstanceByID(CourseInstanceID);
                if (instance != null)
                {
                    this.LiteralCourseHeader.Text = String.Format("Manage Youth registered for {0}", instance.Course.Name);
                    this.LiteralDates.Text = string.Format("{0} - {1}", instance.StartDate.HasValue ? instance.StartDate.Value.ToShortDateString() : "n/a", instance.EndDate.HasValue ? instance.EndDate.Value.ToShortDateString() : "n/a");
                    this.LiteralDesc.Text = instance.Course.Description;
                    this.LiteralInstructor.Text = instance.InstructorPersonID.HasValue ? instance.Instructor.FullName : "n/a";
                    this.LiteralAssistant.Text = instance.AssistantPersonID.HasValue ? instance.Assistant.FullName : "n/a";
                    this.LiteralLocation.Text = instance.Site.Name;

                    DateTime registrationStartDate = instance.StartDate.HasValue
                        ? instance.StartDate.Value
                        : DateTime.Now.Date;
                    IEnumerable<Student> students = POD.Logic.PersonRelatedLogic.GetStudentsByCourseInstanceID(instance.CourseInstanceID);
                    this.DataListPeople.DataSource = students.OrderBy(x => x.LastName).ThenBy(x => x.FirstName);
                    this.DataListPeople.DataBind();

                    var possibleStudentList = POD.Logic.PersonRelatedLogic.GetStudentsForCourseRegistration(instance.SiteLocationID, registrationStartDate);
                    possibleStudentList.RemoveAll(p => students.Contains(p));
                    
                    RadComboBoxPerson.Items.Clear();
                    RadComboBoxPerson.Items.Add(new RadComboBoxItem("Select Youth", ""));
                    RadComboBoxPerson.DataSource = possibleStudentList.OrderBy(x => x.LastName).ThenBy(x => x.FirstName);
                    RadComboBoxPerson.DataBind();
                }
            }
        }

        protected void ButtonPrint_Click(object sender, EventArgs e)
        {

            //GeneratePDFdata(CourseInstanceID);

        }

        private void GeneratePDFdata(int courseInstanceId , int classid)
        {
            try
            {
                CourseInstance instance = POD.Logic.ProgramCourseClassLogic.GetCoursesInstanceByID(CourseInstanceID);
                Class currentCass = POD.Logic.ProgramCourseClassLogic.GetClassByID(classid);
                IEnumerable<Student> students = POD.Logic.PersonRelatedLogic.GetStudentsByCourseInstanceID(instance.CourseInstanceID);
                var _lessonset = POD.Logic.ProgramCourseClassLogic.GetLessonPlanSet((int)instance.LessonPlanSetID);
                var _personList = POD.Logic.PeopleLogic.GetStaff(_lessonset.SiteLocationID);




                if (instance != null)
                {
                    DateTime registrationStartDate = currentCass.DateStart.HasValue
                        ? currentCass.DateStart.Value
                        : DateTime.Now.Date;

                    DateTime registrationEndDate = currentCass.DateEnd.HasValue
                        ? currentCass.DateEnd.Value
                        : DateTime.Now.Date;

                    MemoryStream ms = new MemoryStream();

                    string sTemplate = string.Empty;

                    if(students.Count() < 11)
                    {
                        sTemplate = Path.Combine(HttpContext.Current.Request.PhysicalApplicationPath, @"App_Data\signin-1.pdf");
                    }
                    else if (students.Count() > 10 && students.Count() <= 25)
                    {
                        sTemplate = Path.Combine(HttpContext.Current.Request.PhysicalApplicationPath, @"App_Data\signin-2.pdf");
                    }
                    else if (students.Count() > 25 && students.Count() <= 40)
                    {
                        sTemplate = Path.Combine(HttpContext.Current.Request.PhysicalApplicationPath, @"App_Data\signin-3.pdf");
                    }
                    else if (students.Count() > 40 )
                    {
                        sTemplate = Path.Combine(HttpContext.Current.Request.PhysicalApplicationPath, @"App_Data\signin-4.pdf");
                    }

                    

                    PdfReader pdfReader = new PdfReader(sTemplate);
                    PdfStamper pdfStamper = new PdfStamper(pdfReader, ms);

                    PdfContentByte cb = pdfStamper.GetOverContent(1);
                    AcroFields pdfFormFields = pdfStamper.AcroFields;

                    //fields

                    if (instance.AssistantPersonID != null)
                    {
                        StaffMember assistant = _personList.FirstOrDefault(p => p.PersonID == instance.AssistantPersonID);
                        if (assistant != null)
                        {
                            pdfFormFields.SetField("assistant", assistant.FullName != null ? assistant.FullName : "");  //

                        }
                    }

                    switch (registrationStartDate.DayOfWeek)
                    {

                        case DayOfWeek.Monday:
                            pdfFormFields.SetField("monday", "Yes");
                            break;
                        case DayOfWeek.Tuesday:
                            pdfFormFields.SetField("tuesday", "Yes");
                            break;
                        case DayOfWeek.Wednesday:
                            pdfFormFields.SetField("wednesday", "Yes");
                            break;
                        case DayOfWeek.Thursday:
                            pdfFormFields.SetField("thursday", "Yes");
                            break;
                        case DayOfWeek.Friday:
                            pdfFormFields.SetField("friday", "Yes");
                            break;

                        default:
                            break;
                    }

                    var lessonPlanDate = Convert.ToDateTime(registrationStartDate).ToString("MM/dd/yyyy");
                    var dtStartTime = Convert.ToDateTime(registrationStartDate).ToString("hh:mm tt");
                    var dtEndTime = Convert.ToDateTime(registrationEndDate).ToString("hh:mm tt");

                    var sStartTime = dtStartTime + "-" + dtEndTime;

                    pdfFormFields.SetField("setname", _lessonset.Name != null ? _lessonset.Name : "");
                    pdfFormFields.SetField("classdate", lessonPlanDate != null ? lessonPlanDate : "");
                    pdfFormFields.SetField("classtime", sStartTime != null ? sStartTime : "");  //


                    int studentcounter = 1;



                    if (students.Count() > 0)
                    {
                        foreach (var student in students)
                        {
                            pdfFormFields.SetField("yn" + studentcounter, student.FirstName != null ? student.FirstName + ' ' + student.LastName : "");
                            pdfFormFields.SetField("ai" + studentcounter, student.isAuthorizedStaffOk == true ? "Yes" : "No");
                            pdfFormFields.SetField("s" + studentcounter, student.SignInOut == true ? "Yes" : "No");

                            studentcounter++;
                        }

                    }


                    //close up processing
                    pdfStamper.FormFlattening = true;
                    if (pdfStamper != null)
                    { pdfStamper.Close(); }

                    pdfReader.Close();

                    HttpContext.Current.Response.ContentType = "application/pdf";
                    HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=SignIn Sheet - LPSet " + _lessonset.Name + " - " + lessonPlanDate + ".pdf");
                    HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);

                    HttpContext.Current.Response.BinaryWrite(ms.ToArray());

                    ms.Close();
                }


            }
            catch (Exception ex)
            {

                throw;
            }
            finally
            {
                
            }


        }

        protected void DataListPeople_ItemCommand(object source, DataListCommandEventArgs e)
        {
            int personid = 0;
            if (e.CommandName == "Remove")
            {
                string key = DataListPeople.DataKeys[e.Item.ItemIndex].ToString();
                int.TryParse(key, out personid);
                POD.Logic.ProgramCourseClassLogic.RemovePersonToCourseInstance(personid, CourseInstanceID);
            }
            LoadData();
        }

        protected void ButtonAddPerson_Click(object sender, EventArgs e)
        {
            int personid = 0;
            int.TryParse(this.RadComboBoxPerson.SelectedValue, out personid);
            if (personid != 0)
            {
                POD.Logic.ProgramCourseClassLogic.AddPersonToCourseInstance(personid, CourseInstanceID);
            }
            LoadData();
        }

        protected void ButtonCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect(LpsId == 1
                ? "~/Pages/LessonPlans/LessonPlans.aspx?tp=2"
                : $"~/Pages/ManageClasses/ClassDetailPage.aspx?cid={CourseID}");
        }
    }
}