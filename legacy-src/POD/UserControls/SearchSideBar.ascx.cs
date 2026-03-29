using POD.Data.Entities;
using POD.Logic;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace POD.UserControls
{
    public partial class SearchSideBar : System.Web.UI.UserControl
    {
        public event EventHandler OnSearchButtonClicked;

        private Dictionary<string, string> searchFilters;

        public Dictionary<string, string> SearchParameters
        {
            get
            {
                return searchFilters;
            }
            set
            {
                searchFilters = value;
            }
        }

        public void SetSearch(string type)
        {
            switch (type)
            {
                case "Enrollment":
                    this.LiteralHeader.Text = "Youth Search";
                    this.SearchButton.CommandName = "Enrollment";
                    this.PanelEnrollment.Visible = true;
                    this.PanelClass.Visible = false;
                    this.PanelAttendance.Visible = false;
                    this.PanelEvent.Visible = false;
                    this.PanelInventory.Visible = false;
                    this.PanelLessonPlan.Visible = false;
                    break;
                case "Attendance":
                    this.LiteralHeader.Text = "Attendance Search";
                    this.SearchButton.CommandName = "Attendance";
                    this.PanelEnrollment.Visible = false;
                    this.PanelClass.Visible = false;
                    this.PanelAttendance.Visible = true;
                    this.PanelEvent.Visible = false;
                    this.PanelInventory.Visible = false;
                    this.PanelLessonPlan.Visible = false;
                    break;
                case "Class":
                    this.LiteralHeader.Text = "Class Search";
                    this.SearchButton.CommandName = "Class";
                    this.SearchButton.CommandName = "Attendance";
                    this.PanelEnrollment.Visible = false;
                    this.PanelClass.Visible = true;
                    this.PanelAttendance.Visible = false;
                    this.PanelEvent.Visible = false;
                    this.PanelInventory.Visible = false;
                    this.PanelLessonPlan.Visible = false;
                    break;
                case "Event":
                    this.LiteralHeader.Text = "Event Search";
                    this.SearchButton.CommandName = "Event";
                    this.SearchButton.CommandName = "Attendance";
                    this.PanelEnrollment.Visible = false;
                    this.PanelClass.Visible = false;
                    this.PanelAttendance.Visible = false;
                    this.PanelEvent.Visible = true;
                    this.PanelInventory.Visible = false;
                    this.PanelLessonPlan.Visible = false;
                    break;
                case "Inventory":
                    this.LiteralHeader.Text = "Inventory Search";
                    this.SearchButton.CommandName = "Inventory";
                    this.SearchButton.CommandName = "Attendance";
                    this.PanelEnrollment.Visible = false;
                    this.PanelClass.Visible = false;
                    this.PanelAttendance.Visible = false;
                    this.PanelEvent.Visible = false;
                    this.PanelInventory.Visible = true;
                    this.PanelLessonPlan.Visible = false;
                    break;
                case "LessonPlan":
                    this.LiteralHeader.Text = "Lesson Plan Search";
                    this.SearchButton.CommandName = "LessonPlan";
                    this.PanelEnrollment.Visible = false;
                    this.PanelClass.Visible = false;
                    this.PanelAttendance.Visible = false;
                    this.PanelEvent.Visible = false;
                    this.PanelInventory.Visible = false;
                    this.PanelLessonPlan.Visible = true;
                    break;
                default:
                    this.PanelEnrollment.Visible = false;
                    this.PanelClass.Visible = false;
                    this.PanelAttendance.Visible = false;
                    this.PanelEvent.Visible = false;
                    this.PanelInventory.Visible = false;
                    this.PanelLessonPlan.Visible = false;

                    break;

            }
        }

        private int ProgramID
        {
            get
            {
                if (Session["ProgramID"] != null)
                {
                    return int.Parse(Session["ProgramID"].ToString());
                }
                return 0;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadLists();

                if (PanelEnrollment.Visible)
                {
                    if (!string.IsNullOrEmpty(Request.QueryString["sc"]))
                    {
                        searchFilters = POD.Logic.Utilities.GetSearchFilters(Request.QueryString["sc"].ToString(), "Enrollment");
                        PreSetFilters("Enrollment");
                    }
                }
                if (PanelAttendance.Visible)
                {
                    if (!string.IsNullOrEmpty(Request.QueryString["sc"]))
                    {
                        searchFilters = POD.Logic.Utilities.GetSearchFilters(Request.QueryString["sc"].ToString(), "Attendance");
                        PreSetFilters("Attendance");
                    }
                }
                if (PanelClass.Visible)
                {
                    if (!string.IsNullOrEmpty(Request.QueryString["sc"]))
                    {
                        searchFilters = POD.Logic.Utilities.GetSearchFilters(Request.QueryString["sc"].ToString(), "Class");
                        PreSetFilters("Class");
                    }
                }
                if (PanelEvent.Visible)
                {
                    if (!string.IsNullOrEmpty(Request.QueryString["sc"]))
                    {
                        searchFilters = POD.Logic.Utilities.GetSearchFilters(Request.QueryString["sc"].ToString(), "Event");
                        PreSetFilters("Event");
                    }
                }
                if (PanelInventory.Visible)
                {
                    if (!string.IsNullOrEmpty(Request.QueryString["sc"]))
                    {
                        searchFilters = POD.Logic.Utilities.GetSearchFilters(Request.QueryString["sc"].ToString(), "Inventory");
                        PreSetFilters("Inventory");
                    }
                }
                if (PanelLessonPlan.Visible)
                {
                    if (!string.IsNullOrEmpty(Request.QueryString["sc"]))
                    {
                        searchFilters = POD.Logic.Utilities.GetSearchFilters(Request.QueryString["sc"].ToString(), "lessonplan");
                        PreSetFilters("lessonplan");
                    }
                }
            }
        }

        private void LoadLists()
        {
            //enrollment
            //races
            CheckBoxListRaces.DataSource = POD.Logic.LookUpTypesLogic.GetRaces();
            CheckBoxListRaces.DataBind();
            //status
            List<StatusType> statusList = (List<StatusType>)POD.Logic.ManageTypesLogic.GetTypesByType(Data.TypesData.Types.StatusType);
            if (PanelEnrollment.Visible)
            {
                statusList = statusList.Where(st => st.Category == "Enrollment").ToList();
            }
            else
            {
                statusList = statusList.Where(st => st.Category == "Common").ToList();
            }
            this.RadComboBoxStatus.DataSource = statusList;
            this.RadComboBoxStatus.DataBind();



            this.RadComboBoxStatusLesson.DataSource = POD.Logic.LookUpTypesLogic.GetLessonPlanStatusType().Where(x => x.Category.ToLower() == "lessonplanset").OrderBy(x => x.Name).ToList();
            this.RadComboBoxStatusLesson.DataBind();

            this.RadComboBoxStatus.ClearSelection();
            RadComboBoxItem item = null;
            if (PanelEnrollment.Visible)//enrolled is the default
            {
                item = this.RadComboBoxStatus.Items.FindItemByText("Enrolled");
            }
            else //active is the default
            {
                item = this.RadComboBoxStatus.FindItemByValue("1");
            }

            if (item != null)
            {
                item.Selected = true;
            }

            //Youth Type - skb 07/02/2021
            this.RadcbYouthtype.DataSource = POD.Logic.ManageTypesLogic.GetYouthTypes();
            this.RadcbYouthtype.DataBind();

            //RadComboBoxItem currentYouthType = RadcbYouthtype.Items.FindItemByText(POD.Logic.ManageTypesLogic.GetCurrentGrantYear());
            //if (currentYouthType != null)
            //{
            //    currentYouthType.Selected = true;
            //}

            //grant year
            this.RadComboBoxGrantYear.DataSource = POD.Logic.ManageTypesLogic.GetGrantYears(Convert.ToInt32(RadcbYouthtype.SelectedItem.Value));
            this.RadComboBoxGrantYear.DataBind();

            RadComboBoxItem currentYear = RadComboBoxGrantYear.Items.FindItemByText(POD.Logic.ManageTypesLogic.GetCurrentGrantYear(Convert.ToInt32(RadcbYouthtype.SelectedItem.Value)));
            if (currentYear != null)
            {
                currentYear.Selected = true;
            }

            this.RadComboBoxType.DataSource = POD.Logic.ManageTypesLogic.GetTypesByType(Data.TypesData.Types.EnrollmentType);
            this.RadComboBoxType.DataBind();

            if (PanelEnrollment.Visible)//enrolled is the default
            {
                item = this.RadComboBoxType.FindItemByValue("1"); 
            }
            
            if (item != null)
            {
                item.Selected = true;
            }

            //event
            this.RadComboBoxEventType.DataSource = POD.Logic.ManageTypesLogic.GetTypesByType(Data.TypesData.Types.EventType);
            this.RadComboBoxEventType.DataBind();

            this.RadComboBoxEventStatus.DataSource = statusList;
            this.RadComboBoxEventStatus.DataBind();

            this.RadComboBoxClassAgeGroup.DataSource = POD.Logic.LookUpTypesLogic.GetAgeGroups();
            this.RadComboBoxClassAgeGroup.DataBind();

            //attendance
            if (Security.UserInRole("Administrators")) //can see all sites
            {
                this.RadComboBoxEventLocation.DataSource = POD.Logic.LookUpTypesLogic.GetLocations();
                this.RadComboBoxAttendanceSite.DataSource = POD.Logic.LookUpTypesLogic.GetSites();
                PanelSite.Visible = true;
                this.RadComboBoxAttendanceLocation.DataSource = POD.Logic.LookUpTypesLogic.GetLocations();
                this.RadComboBoxAttClass.DataSource = POD.Logic.ProgramCourseClassLogic.GetClassessByProgramID(ProgramID);
                // this.RadComboBoxAttEvent.DataSource = POD.Logic.ProgramCourseClassLogic.GetAllEvents(ProgramID);
                this.RadComboBoxClassLocation.DataSource = POD.Logic.LookUpTypesLogic.GetSites();
                this.RadComboBoxInvLocation.DataSource = POD.Logic.LookUpTypesLogic.GetLocations();
                this.RadComboBoxClassLocationLesson.DataSource = POD.Logic.LookUpTypesLogic.GetLocations();
                this.RadComboBoxClassAssistant.DataSource = POD.Logic.PeopleLogic.GetStaff();
                this.RadComboBoxClassAssistantLesson.DataSource = POD.Logic.PeopleLogic.GetStaff();
                this.RadComboBoxClassInstructor.DataSource = POD.Logic.PeopleLogic.GetStaff();
                this.RadComboBoxClassInstructorLesson.DataSource = POD.Logic.PeopleLogic.GetStaff();
            }
            else //filter by users site and hide any site drop downs
            {
                int siteid = 0;
                int.TryParse(Session["UsersSiteID"].ToString(), out siteid);
                this.RadComboBoxEventLocation.DataSource = POD.Logic.LookUpTypesLogic.GetLocationsBySite(siteid);
                PanelSite.Visible = false;
                this.RadComboBoxAttendanceLocation.DataSource = POD.Logic.LookUpTypesLogic.GetLocationsBySite(siteid);
                this.RadComboBoxAttClass.DataSource = POD.Logic.ProgramCourseClassLogic.GetClassessByProgramAndSite(ProgramID, siteid);
                // this.RadComboBoxAttEvent.DataSource = POD.Logic.ProgramCourseClassLogic.GetAllEvents(ProgramID, siteid);

                var s = POD.Logic.LookUpTypesLogic.GetSiteByID(siteid);
                var sitelist = new List<Site>() { s };
                this.RadComboBoxClassLocation.DataSource = sitelist;
                this.RadComboBoxClassLocationLesson.DataSource = POD.Logic.LookUpTypesLogic.GetLocationsBySite(siteid);
                this.RadComboBoxInvLocation.DataSource = POD.Logic.LookUpTypesLogic.GetLocationsBySite(siteid);
                this.RadComboBoxClassAssistant.DataSource = POD.Logic.PeopleLogic.GetStaff(siteid);
                this.RadComboBoxClassAssistantLesson.DataSource = POD.Logic.PeopleLogic.GetStaff(siteid);
                this.RadComboBoxClassInstructor.DataSource = POD.Logic.PeopleLogic.GetStaff(siteid);


                this.RadComboBoxClassInstructorLesson.DataSource = POD.Logic.PeopleLogic.GetStaff(siteid);

            }
            this.RadComboBoxEventLocation.DataBind();
            this.RadComboBoxAttendanceSite.DataBind();
            this.RadComboBoxAttendanceLocation.DataBind();
            this.RadComboBoxClassAgeGroup.Items.Insert(0, new RadComboBoxItem("All", ""));
            this.RadComboBoxAttendanceLocation.Items.Insert(0, new RadComboBoxItem("All", ""));
            this.RadComboBoxAttClass.DataBind();
            // this.RadComboBoxAttClass.Filter = RadComboBoxFilter.Contains;
            this.RadComboBoxAttClass.Items.Insert(0, new RadComboBoxItem("All", ""));
            //this.RadComboBoxAttEvent.DataBind();
            //class
            this.RadComboBoxClassLocation.DataBind();
            this.RadComboBoxClassLocation.Filter = RadComboBoxFilter.Contains;
            this.RadComboBoxClassLocationLesson.DataBind();
            this.RadComboBoxClassAssistantLesson.Filter = RadComboBoxFilter.Contains;
            this.RadComboBoxClassInstructorLesson.Filter = RadComboBoxFilter.Contains;
            this.RadComboBoxClassLocationLesson.Filter = RadComboBoxFilter.Contains;
            this.RadComboBoxClassInstructor.Filter = RadComboBoxFilter.Contains;
            this.RadComboBoxClassAssistant.Filter = RadComboBoxFilter.Contains;
            this.RadComboBoxClassLocation.Filter = RadComboBoxFilter.Contains;
            this.RadComboBoxClassInstructor.DataBind();
            this.RadComboBoxClassInstructor.Filter = RadComboBoxFilter.Contains;
            this.RadComboBoxClassInstructorLesson.DataBind();
            this.RadComboBoxClassAssistant.DataBind();
            this.RadComboBoxClassAssistant.Filter = RadComboBoxFilter.Contains;
            this.RadComboBoxClassAssistantLesson.DataBind();
            this.RadComboBoxClassInstructor.Items.Insert(0, new RadComboBoxItem("All", ""));
            this.RadComboBoxClassInstructorLesson.Items.Insert(0, new RadComboBoxItem("All", ""));
            this.RadComboBoxClassAssistant.Items.Insert(0, new RadComboBoxItem("All", ""));
            this.RadComboBoxClassAssistantLesson.Items.Insert(0, new RadComboBoxItem("All", ""));
            //Inventory
            this.RadComboBoxInvLocation.DataBind();

            this.RadComboBoxInvType.DataSource = POD.Logic.ManageTypesLogic.GetTypesByType(Data.TypesData.Types.InventoryItemType);
            this.RadComboBoxInvType.DataBind();

        }


        private void PreSetFilters(string type)
        {
            if (!IsPostBack)
            {
                switch (type)
                {
                    case "Enrollment":
                        this.NameBox.Text = searchFilters["Name"] != "-1" ? searchFilters["Name"].ToString() : string.Empty;
                        this.GuardianBox.Text = searchFilters["Guardian"] != "-1" ? searchFilters["Guardian"].ToString() : string.Empty;
                        this.TextBoxDJJNum.Text = searchFilters["DJJ"] != "-1" ? searchFilters["DJJ"].ToString() : string.Empty;
                        this.ZipBox.Text = searchFilters["Zip"] != "-1" ? searchFilters["Zip"].ToString() : string.Empty;
                        this.SchoolBox.Text = searchFilters["School"] != "-1" ? searchFilters["School"].ToString() : string.Empty;
                        if (searchFilters["Type"] != "-1")
                        {
                            this.RadComboBoxType.ClearSelection();
                            RadComboBoxItem typeItem = this.RadComboBoxType.Items.FindItemByValue(searchFilters["Type"].ToString());
                            if (typeItem != null)
                            {
                                typeItem.Selected = true;
                            }
                            else
                            {

                            }
                        }
                        if (searchFilters["Status"] != "-1")
                        {
                            this.RadComboBoxStatus.ClearSelection();
                            RadComboBoxItem stItem = this.RadComboBoxStatus.Items.FindItemByValue(searchFilters["Status"].ToString());
                            if (stItem != null)
                            {
                                stItem.Selected = true;
                            }
                        }
                        if (searchFilters["youthtype"] != "-1")
                        {
                            this.RadcbYouthtype.ClearSelection();
                            RadComboBoxItem stItem = this.RadcbYouthtype.Items.FindItemByValue(searchFilters["youthtype"].ToString());
                            if (stItem != null)
                            {
                                stItem.Selected = true;
                            }

                            //present the proper

                            this.RadComboBoxGrantYear.DataSource = POD.Logic.ManageTypesLogic.GetGrantYears(Convert.ToInt32(RadcbYouthtype.SelectedItem.Value));
                            this.RadComboBoxGrantYear.DataBind();
                        }

                        if (searchFilters["Year"] != "-1")
                        {
                            this.RadComboBoxGrantYear.ClearSelection();
                            RadComboBoxItem stItem = this.RadComboBoxGrantYear.Items.FindItemByValue(searchFilters["Year"].ToString());
                            if (stItem != null)
                            {
                                stItem.Selected = true;
                            }
                        }
                       
                        if (searchFilters["RegStartDate"] != "-1")
                        {
                            this.RadDatePickerStartDate.SelectedDate = Convert.ToDateTime(searchFilters["RegStartDate"].ToString());
                        }
                        if (searchFilters["RegEndDate"] != "-1")
                        {
                            this.RadDatePickerEndDate.SelectedDate = Convert.ToDateTime(searchFilters["RegEndDate"].ToString());
                        }

                        if (searchFilters["Race"] != "-1")
                        {
                            string[] raceList = searchFilters["Race"].Split('+', ' ');
                            foreach (string str in raceList)
                            {
                                ListItem item = this.CheckBoxListRaces.Items.FindByValue(str);
                                if (item != null)
                                {
                                    item.Selected = true;
                                }
                            }
                        }

                        break;
                    case "Attendance":
                        this.TextBoxAttName.Text = searchFilters["Name"] != "-1" ? searchFilters["Name"].ToString() : string.Empty;
                        if (searchFilters["Site"] != "-1")
                        {
                            this.RadComboBoxAttendanceSite.ClearSelection();
                            RadComboBoxItem typeItem = this.RadComboBoxAttendanceSite.Items.FindItemByValue(searchFilters["Site"].ToString());
                            if (typeItem != null)
                            {
                                typeItem.Selected = true;
                            }
                            int siteid = 0;
                            int.TryParse(searchFilters["Site"].ToString(), out siteid);
                            this.RadComboBoxAttendanceLocation.Items.Clear();
                            this.RadComboBoxAttendanceLocation.DataSource = POD.Logic.LookUpTypesLogic.GetLocationsBySite(siteid);
                            this.RadComboBoxAttendanceLocation.DataBind();
                            this.RadComboBoxAttendanceLocation.Items.Insert(0, new RadComboBoxItem("All", ""));
                            this.RadComboBoxAttClass.Items.Clear();
                            this.RadComboBoxAttClass.DataSource = POD.Logic.ProgramCourseClassLogic.GetClassessByProgramAndSite(ProgramID, siteid);
                            this.RadComboBoxAttClass.DataBind();
                            this.RadComboBoxAttClass.Items.Insert(0, new RadComboBoxItem("All", ""));


                        }
                        if (searchFilters["Loc"] != "-1")
                        {
                            this.RadComboBoxAttendanceLocation.ClearSelection();
                            RadComboBoxItem stItem = this.RadComboBoxAttendanceLocation.Items.FindItemByValue(searchFilters["Loc"].ToString());
                            if (stItem != null)
                            {
                                stItem.Selected = true;
                            }
                            int locid = 0;
                            int.TryParse(searchFilters["Loc"].ToString(), out locid);
                            this.RadComboBoxAttClass.Items.Clear();
                            this.RadComboBoxAttClass.DataSource = POD.Logic.ProgramCourseClassLogic.GetClassessByProgramAndSite(ProgramID, locid);
                            this.RadComboBoxAttClass.DataBind();
                            this.RadComboBoxAttClass.Items.Insert(0, new RadComboBoxItem("All", ""));

                        }
                        if (searchFilters["Class"] != "-1")
                        {
                            this.RadComboBoxAttClass.ClearSelection();
                            RadComboBoxItem locItem = this.RadComboBoxAttClass.Items.FindItemByValue(searchFilters["Class"].ToString());
                            if (locItem != null)
                            {
                                locItem.Selected = true;
                            }
                        }
                        //if (searchFilters["Event"] != "-1")
                        //{
                        //    this.RadComboBoxAttEvent.ClearSelection();
                        //    RadComboBoxItem locItem = this.RadComboBoxAttEvent.Items.FindItemByValue(searchFilters["Event"].ToString());
                        //    if (locItem != null)
                        //    {
                        //        locItem.Selected = true;
                        //    }
                        //}
                        if (searchFilters["RegStartDate"] != "-1")
                        {
                            this.RadDatePickerAttStart.SelectedDate = Convert.ToDateTime(searchFilters["RegStartDate"].ToString());
                        }

                        //if (searchFilters["RegEndDate"] != "11")
                        //{
                        //    if (searchFilters["RegEndDate"] != "-1")
                        //    {
                        //        this.RadDatePickerAttEnd.SelectedDate = Convert.ToDateTime(searchFilters["RegEndDate"].ToString());
                        //    }
                        //}
                        break;
                    case "Class":
                        this.TextBoxCourseName.Text = searchFilters["Name"] != "-1" ? searchFilters["Name"].ToString() : string.Empty;
                        if (searchFilters["Loc"] != "-1")
                        {
                            this.RadComboBoxClassLocation.ClearSelection();
                            RadComboBoxItem locItem = this.RadComboBoxClassLocation.Items.FindItemByValue(searchFilters["Loc"].ToString());
                            if (locItem != null)
                            {
                                locItem.Selected = true;
                            }
                            int siteLocid = 0;
                            int.TryParse(searchFilters["Loc"].ToString(), out siteLocid);
                            this.RadComboBoxClassAssistant.DataSource = POD.Logic.PeopleLogic.GetStaff(siteLocid);
                            this.RadComboBoxClassInstructor.DataSource = POD.Logic.PeopleLogic.GetStaff(siteLocid);
                            this.RadComboBoxClassAssistant.DataBind();
                            this.RadComboBoxClassInstructor.DataBind();
                            this.RadComboBoxClassInstructor.Items.Insert(0, new RadComboBoxItem("All", ""));
                            this.RadComboBoxClassAssistant.Items.Insert(0, new RadComboBoxItem("All", ""));
                        }
                        if (searchFilters["Instructor"] != "-1")
                        {
                            this.RadComboBoxClassInstructor.ClearSelection();
                            RadComboBoxItem typeItem = this.RadComboBoxClassInstructor.Items.FindItemByValue(searchFilters["Instructor"].ToString());
                            if (typeItem != null)
                            {
                                typeItem.Selected = true;
                            }
                        }
                        if (searchFilters["Assistant"] != "-1")
                        {
                            this.RadComboBoxClassAssistant.ClearSelection();
                            RadComboBoxItem stItem = this.RadComboBoxClassAssistant.Items.FindItemByValue(searchFilters["Assistant"].ToString());
                            if (stItem != null)
                            {
                                stItem.Selected = true;
                            }

                        }
                        if (searchFilters["RegStartDate"] != "-1")
                        {
                            this.RadDatePickerClassStart.SelectedDate = Convert.ToDateTime(searchFilters["RegStartDate"].ToString());
                        }
                        if (searchFilters["RegStartDate2"] != "-1")
                        {
                            this.RadDatePickerClassStart2.SelectedDate = Convert.ToDateTime(searchFilters["RegStartDate2"].ToString());
                        }
                        if (searchFilters["RegEndDate"] != "-1")
                        {
                            this.RadDatePickerClassEnd.SelectedDate = Convert.ToDateTime(searchFilters["RegEndDate"].ToString());
                        }
                        if (searchFilters["RegEndDate2"] != "-1")
                        {
                            this.RadDatePickerClassEnd2.SelectedDate = Convert.ToDateTime(searchFilters["RegEndDate2"].ToString());
                        }
                        break;
                    case "Event":
                        this.TextBoxEventName.Text = searchFilters["Name"] != "-1" ? searchFilters["Name"].ToString() : string.Empty;
                        if (searchFilters["Type"] != "-1")
                        {
                            this.RadComboBoxEventType.ClearSelection();
                            RadComboBoxItem typeItem = this.RadComboBoxEventType.Items.FindItemByValue(searchFilters["Type"].ToString());
                            if (typeItem != null)
                            {
                                typeItem.Selected = true;
                            }
                        }
                        if (searchFilters["Status"] != "-1")
                        {
                            this.RadComboBoxEventStatus.ClearSelection();
                            RadComboBoxItem stItem = this.RadComboBoxEventStatus.Items.FindItemByValue(searchFilters["Status"].ToString());
                            if (stItem != null)
                            {
                                stItem.Selected = true;
                            }

                        }
                        if (searchFilters["Loc"] != "-1")
                        {
                            this.RadComboBoxEventLocation.ClearSelection();
                            RadComboBoxItem locItem = this.RadComboBoxEventLocation.Items.FindItemByValue(searchFilters["Loc"].ToString());
                            if (locItem != null)
                            {
                                locItem.Selected = true;
                            }
                        }
                        if (searchFilters["RegStartDate"] != "-1")
                        {
                            this.RadDatePickerEventStart.SelectedDate = Convert.ToDateTime(searchFilters["RegStartDate"].ToString());
                        }
                        if (searchFilters["RegStartDate2"] != "-1")
                        {
                            this.RadDatePickerEventStart2.SelectedDate = Convert.ToDateTime(searchFilters["RegStartDate2"].ToString());
                        }
                        if (searchFilters["RegEndDate"] != "-1")
                        {
                            this.RadDatePickerEndDate.SelectedDate = Convert.ToDateTime(searchFilters["RegEndDate"].ToString());
                        }
                        if (searchFilters["RegEndDate2"] != "-1")
                        {
                            this.RadDatePickerEventEnd2.SelectedDate = Convert.ToDateTime(searchFilters["RegEndDate2"].ToString());
                        }
                        break;
                    case "Inventory":
                        this.TextBoxInvName.Text = searchFilters["Name"] != "-1" ? searchFilters["Name"].ToString() : string.Empty;
                        if (searchFilters["Type"] != "-1")
                        {
                            this.RadComboBoxInvType.ClearSelection();
                            RadComboBoxItem typeItem = this.RadComboBoxInvType.Items.FindItemByValue(searchFilters["Type"].ToString());
                            if (typeItem != null)
                            {
                                typeItem.Selected = true;
                            }
                        }
                        if (searchFilters["Loc"] != "-1")
                        {
                            this.RadComboBoxInvLocation.ClearSelection();
                            RadComboBoxItem locItem = this.RadComboBoxInvLocation.Items.FindItemByValue(searchFilters["Loc"].ToString());
                            if (locItem != null)
                            {
                                locItem.Selected = true;
                            }
                        }
                        this.TextBoxInvManufacturer.Text = searchFilters["Man"] != "-1" ? searchFilters["Man"].ToString() : string.Empty;
                        this.TextBoxInvSerial.Text = searchFilters["Serial"] != "-1" ? searchFilters["Serial"].ToString() : string.Empty;
                        this.TextBoxInvOrganization.Text = searchFilters["Org"] != "-1" ? searchFilters["Org"].ToString() : string.Empty;
                        this.TextBoxInvUACDCTag.Text = searchFilters["Tag"] != "-1" ? searchFilters["Tag"].ToString() : string.Empty;
                        this.TextBoxInvDJJTag.Text = searchFilters["DJJTag"] != "-1" ? searchFilters["DJJTag"].ToString() : string.Empty;
                        break;
                    case "LessonPlan":
                        break;
                }
            }
        }

        protected void Searchbutton_Click(object sender, EventArgs e)
        {
            #region Enrollment
            if (PanelEnrollment.Visible)
            {
                searchFilters = POD.Logic.Utilities.SetDefaultSearchFilters("Enrollment");
                if (!string.IsNullOrEmpty(this.NameBox.Text))
                {
                    SearchParameters["Name"] = this.NameBox.Text.Trim();
                }
                if (!string.IsNullOrEmpty(this.GuardianBox.Text))
                {
                    SearchParameters["Guardian"] = this.GuardianBox.Text.Trim();
                }
                if (!string.IsNullOrEmpty(this.TextBoxDJJNum.Text))
                {
                    SearchParameters["DJJ"] = this.TextBoxDJJNum.Text.Trim();
                }
                if (!string.IsNullOrEmpty(this.ZipBox.Text))
                {
                    SearchParameters["Zip"] = this.ZipBox.Text.Trim();
                }
                if (!string.IsNullOrEmpty(this.SchoolBox.Text))
                {
                    SearchParameters["School"] = this.SchoolBox.Text.Trim();
                }
                if (!string.IsNullOrEmpty(RadComboBoxType.SelectedValue) && RadComboBoxType.SelectedValue != "All")
                {
                    SearchParameters["Type"] = RadComboBoxType.SelectedValue;
                }
                if (RadComboBoxStatus.SelectedValue != "")
                {
                    SearchParameters["Status"] = RadComboBoxStatus.SelectedValue;
                }
                if (RadComboBoxGrantYear.SelectedValue != "")
                {
                    SearchParameters["Year"] = RadComboBoxGrantYear.SelectedValue;
                }
                if (RadcbYouthtype.SelectedValue != "")
                {
                    SearchParameters["youthtype"] = RadcbYouthtype.SelectedValue;
                }
                if (RadDatePickerStartDate.SelectedDate.HasValue)
                {
                    SearchParameters["RegStartDate"] = RadDatePickerStartDate.SelectedDate.Value.ToShortDateString();
                }
                if (RadDatePickerEndDate.SelectedDate.HasValue)
                {
                    SearchParameters["RegEndDate"] = RadDatePickerEndDate.SelectedDate.Value.ToShortDateString();
                }
                string selRaces = string.Empty;
                foreach (ListItem item in CheckBoxListRaces.Items)
                {
                    if (item.Selected)
                    {
                        selRaces += item.Value + "+";
                    }
                }
                selRaces = selRaces.TrimEnd('+');
                if (!string.IsNullOrEmpty(selRaces))
                {
                    SearchParameters["Race"] = selRaces;
                }
            }
            #endregion
            #region Event
            if (PanelEvent.Visible)
            {
                searchFilters = POD.Logic.Utilities.SetDefaultSearchFilters("Event");
                if (!string.IsNullOrEmpty(this.TextBoxEventName.Text))
                {
                    SearchParameters["Name"] = this.TextBoxEventName.Text.Trim();
                }
                if (!string.IsNullOrEmpty(RadComboBoxEventType.SelectedValue) && RadComboBoxEventType.SelectedValue != "All")
                {
                    SearchParameters["Type"] = RadComboBoxEventType.SelectedValue;
                }
                if (!string.IsNullOrEmpty(RadComboBoxEventLocation.SelectedValue) && RadComboBoxEventLocation.SelectedValue != "All")
                {
                    SearchParameters["Loc"] = RadComboBoxEventLocation.SelectedValue;
                }
                if (!string.IsNullOrEmpty(RadComboBoxEventStatus.SelectedValue))
                {
                    SearchParameters["Status"] = RadComboBoxEventStatus.SelectedValue;
                }
                if (RadDatePickerEventStart.SelectedDate.HasValue)
                {
                    SearchParameters["RegStartDate"] = RadDatePickerEventStart.SelectedDate.Value.ToShortDateString();
                }
                if (RadDatePickerEventEnd.SelectedDate.HasValue)
                {
                    SearchParameters["RegEndDate"] = RadDatePickerEventEnd.SelectedDate.Value.ToShortDateString();
                }
                if (RadDatePickerEventStart2.SelectedDate.HasValue)
                {
                    SearchParameters["RegStartDate2"] = RadDatePickerEventStart2.SelectedDate.Value.ToShortDateString();
                }
                if (RadDatePickerEventEnd2.SelectedDate.HasValue)
                {
                    SearchParameters["RegEndDate2"] = RadDatePickerEventEnd2.SelectedDate.Value.ToShortDateString();
                }
            }
            #endregion
            #region Attendance
            if (PanelAttendance.Visible)
            {
                searchFilters = POD.Logic.Utilities.SetDefaultSearchFilters("Attendance");
                if (!string.IsNullOrEmpty(this.TextBoxAttName.Text))
                {
                    SearchParameters["Name"] = this.TextBoxAttName.Text.Trim();
                }
                if (!string.IsNullOrEmpty(RadComboBoxAttClass.SelectedValue) && RadComboBoxAttClass.SelectedValue != "All")
                {
                    SearchParameters["Class"] = RadComboBoxAttClass.SelectedValue;
                }
                if (!string.IsNullOrEmpty(RadComboBoxAttendanceLocation.SelectedValue) && RadComboBoxAttendanceLocation.SelectedValue != "All")
                {
                    SearchParameters["Loc"] = RadComboBoxAttendanceLocation.SelectedValue;
                }
                if (!Security.UserInRole("Administrators"))//if not admin always filter by site
                {
                    SearchParameters["Site"] = Session["UsersSiteID"].ToString();
                }
                else if (!string.IsNullOrEmpty(RadComboBoxAttendanceSite.SelectedValue) && RadComboBoxAttendanceSite.SelectedValue != "All")
                {
                    SearchParameters["Site"] = RadComboBoxAttendanceSite.SelectedValue;
                }
                //if (!string.IsNullOrEmpty(RadComboBoxAttEvent.SelectedValue))
                //{
                //    SearchParameters["Event"] = RadComboBoxAttEvent.SelectedValue;
                //}
                if (RadDatePickerAttStart.SelectedDate.HasValue)
                {
                    SearchParameters["RegStartDate"] = RadDatePickerAttStart.SelectedDate.Value.ToShortDateString();
                }
                if (RadDatePickerAttEnd.SelectedDate.HasValue)
                {
                    SearchParameters["RegEndDate"] = RadDatePickerAttEnd.SelectedDate.Value.ToShortDateString();
                }

            }
            #endregion
            #region Class
            if (PanelClass.Visible)
            {
                searchFilters = POD.Logic.Utilities.SetDefaultSearchFilters("Class");
                if (!string.IsNullOrEmpty(this.TextBoxCourseName.Text))
                {
                    SearchParameters["Name"] = this.TextBoxCourseName.Text.Trim();
                }
                if (!string.IsNullOrEmpty(RadComboBoxClassInstructor.SelectedValue) && RadComboBoxClassInstructor.SelectedValue != "All")
                {
                    SearchParameters["Instructor"] = RadComboBoxClassInstructor.SelectedValue;
                }
                if (!string.IsNullOrEmpty(RadComboBoxClassAssistant.SelectedValue) && RadComboBoxClassAssistant.SelectedValue != "All")
                {
                    SearchParameters["Assistant"] = RadComboBoxClassAssistant.SelectedValue;
                }
                if (!string.IsNullOrEmpty(RadComboBoxClassLocation.SelectedValue) && RadComboBoxClassLocation.SelectedValue != "All")
                {
                    SearchParameters["Loc"] = RadComboBoxClassLocation.SelectedValue;
                }
                if (RadDatePickerClassStart.SelectedDate.HasValue)
                {
                    SearchParameters["RegStartDate"] = RadDatePickerClassStart.SelectedDate.Value.ToShortDateString();
                }
                if (RadDatePickerClassEnd.SelectedDate.HasValue)
                {
                    SearchParameters["RegEndDate"] = RadDatePickerClassEnd.SelectedDate.Value.ToShortDateString();
                }
                if (RadDatePickerClassStart2.SelectedDate.HasValue)
                {
                    SearchParameters["RegStartDate2"] = RadDatePickerClassStart2.SelectedDate.Value.ToShortDateString();
                }
                if (RadDatePickerClassEnd2.SelectedDate.HasValue)
                {
                    SearchParameters["RegEndDate2"] = RadDatePickerClassEnd2.SelectedDate.Value.ToShortDateString();
                }
            }
            #endregion
            #region Inventory
            if (PanelInventory.Visible)
            {
                searchFilters = POD.Logic.Utilities.SetDefaultSearchFilters("Inventory");
                if (!string.IsNullOrEmpty(this.TextBoxInvName.Text))
                {
                    SearchParameters["Name"] = this.TextBoxInvName.Text.Trim();
                }
                if (!string.IsNullOrEmpty(RadComboBoxInvType.SelectedValue) && RadComboBoxInvType.SelectedValue != "All")
                {
                    SearchParameters["Type"] = RadComboBoxInvType.SelectedValue;
                }
                if (!string.IsNullOrEmpty(RadComboBoxInvLocation.SelectedValue) && RadComboBoxInvLocation.SelectedValue != "All")
                {
                    SearchParameters["Loc"] = RadComboBoxInvLocation.SelectedValue;
                }
                if (!string.IsNullOrEmpty(this.TextBoxInvManufacturer.Text))
                {
                    SearchParameters["Man"] = this.TextBoxInvManufacturer.Text.Trim();
                }
                if (!string.IsNullOrEmpty(this.TextBoxInvSerial.Text))
                {
                    SearchParameters["Serial"] = this.TextBoxInvSerial.Text.Trim();
                }
                if (!string.IsNullOrEmpty(this.TextBoxInvOrganization.Text))
                {
                    SearchParameters["Org"] = this.TextBoxInvOrganization.Text.Trim();
                }
                if (!string.IsNullOrEmpty(this.TextBoxInvUACDCTag.Text))
                {
                    SearchParameters["Tag"] = this.TextBoxInvUACDCTag.Text.Trim();
                }
                if (!string.IsNullOrEmpty(this.TextBoxInvDJJTag.Text))
                {
                    SearchParameters["DJJTag"] = this.TextBoxInvDJJTag.Text.Trim();
                }
            }
            #endregion
            #region LessonPlan
            if (PanelLessonPlan.Visible)
            {
                searchFilters = POD.Logic.Utilities.SetDefaultSearchFilters("LessonPlan");
                if (!string.IsNullOrEmpty(this.LessonNameBox.Text))
                {
                    SearchParameters["Name"] = this.LessonNameBox.Text.Trim();
                }
                if (!string.IsNullOrEmpty(RadComboBoxClassInstructorLesson.SelectedValue) && RadComboBoxClassInstructorLesson.SelectedValue != "All")
                {
                    SearchParameters["Instructor"] = RadComboBoxClassInstructorLesson.SelectedValue;
                }
                if (!string.IsNullOrEmpty(RadComboBoxClassAssistantLesson.SelectedValue) && RadComboBoxClassAssistantLesson.SelectedValue != "All")
                {
                    SearchParameters["Assistant"] = RadComboBoxClassAssistantLesson.SelectedValue;
                }
                if (!string.IsNullOrEmpty(RadComboBoxClassLocationLesson.SelectedValue) && RadComboBoxClassLocationLesson.SelectedValue != "All")
                {
                    SearchParameters["Loc"] = RadComboBoxClassLocationLesson.SelectedValue;
                }
                //age group
                if (!string.IsNullOrEmpty(RadComboBoxClassAgeGroup.SelectedValue) && RadComboBoxClassAgeGroup.SelectedValue != "All")
                {
                    SearchParameters["AgeGroup"] = RadComboBoxClassAgeGroup.SelectedValue;
                }
                if (!string.IsNullOrEmpty(RadComboBoxStatusLesson.SelectedValue) && RadComboBoxStatusLesson.SelectedValue != "All")
                {
                    SearchParameters["LessonPlanStatus"] = RadComboBoxStatusLesson.SelectedValue;
                }

            }
            #endregion

            if (OnSearchButtonClicked != null)
                OnSearchButtonClicked(this, e);

        }

        #region Related DropDowns

        protected void RadComboBoxAttendanceSite_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            if (!string.IsNullOrEmpty(e.Value))
            {
                int siteid = 0;
                int.TryParse(e.Value, out siteid);
                this.RadComboBoxAttendanceLocation.Items.Clear();
                this.RadComboBoxAttendanceLocation.DataSource = POD.Logic.LookUpTypesLogic.GetLocationsBySite(siteid);
                this.RadComboBoxAttendanceLocation.DataBind();
                this.RadComboBoxAttendanceLocation.Items.Insert(0, new RadComboBoxItem("All", ""));
                this.RadComboBoxAttClass.Items.Clear();
                this.RadComboBoxAttClass.DataSource = POD.Logic.ProgramCourseClassLogic.GetClassessByProgramAndSite(ProgramID, siteid);
                this.RadComboBoxAttClass.DataBind();
                this.RadComboBoxAttClass.Items.Insert(0, new RadComboBoxItem("All", ""));
            }
        }

        protected void RadComboBoxAttendanceLocation_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            if (!string.IsNullOrEmpty(e.Value))
            {
                int locID = 0;
                int.TryParse(e.Value, out locID);
                this.RadComboBoxAttClass.Items.Clear();
                this.RadComboBoxAttClass.DataSource = POD.Logic.ProgramCourseClassLogic.GetClassessByProgramAndSite(ProgramID, locID);
                this.RadComboBoxAttClass.DataBind();
                this.RadComboBoxAttClass.Items.Insert(0, new RadComboBoxItem("All", ""));
            }
        }

        protected void RadComboBoxClassLocation_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            if (!string.IsNullOrEmpty(e.Value))
            {
                int siteid = 0;
                int.TryParse(e.Value, out siteid);
                this.RadComboBoxClassAssistant.DataSource = POD.Logic.PeopleLogic.GetStaff(siteid);
                this.RadComboBoxClassInstructor.DataSource = POD.Logic.PeopleLogic.GetStaff(siteid);
                this.RadComboBoxClassAssistant.DataBind();
                this.RadComboBoxClassInstructor.DataBind();
                this.RadComboBoxClassInstructor.Items.Insert(0, new RadComboBoxItem("All", ""));
                this.RadComboBoxClassAssistant.Items.Insert(0, new RadComboBoxItem("All", ""));
            }
        }

        protected void RadcbYouthtype_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            if (!string.IsNullOrEmpty(e.Value))
            {
                int youthtypeid = 0;
                int.TryParse(e.Value, out youthtypeid);
                this.RadComboBoxGrantYear.DataSource = POD.Logic.ManageTypesLogic.GetGrantYears(Convert.ToInt32(youthtypeid));
                this.RadComboBoxGrantYear.DataBind();

                RadComboBoxItem currentYear = RadComboBoxGrantYear.Items.FindItemByText(POD.Logic.ManageTypesLogic.GetCurrentGrantYear(Convert.ToInt32(youthtypeid)));
                if (currentYear != null)
                {
                    currentYear.Selected = true;
                }
            }
        }
        #endregion


    }
}