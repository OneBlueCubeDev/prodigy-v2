using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using POD.Data.Entities;
using Telerik.Web.UI;
using POD.Logic;

namespace POD.Pages
{
    public partial class AttendancePage : System.Web.UI.Page
    {
        private int classID = 0;
        private int eventid = 0;
        string typeOfAttendance = string.Empty;
        private int EventID
        {
            get
            {
                if (ViewState["EventID"] != null)
                {
                    int.TryParse(ViewState["EventID"].ToString(), out eventid);
                }
                return eventid;
            }
            set
            {
                ViewState["EventID"] = value;
            }
        }

        private int ClassID
        {
            get
            {
                if (ViewState["ClassID"] != null)
                {
                    int.TryParse(ViewState["ClassID"].ToString(), out classID);
                }
                return classID;
            }
            set
            {
                ViewState["ClassID"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!string.IsNullOrEmpty(Request.QueryString["type"]))
                {
                    typeOfAttendance = Request.QueryString["type"].ToString();

                }
                if (typeOfAttendance == "Class")
                {
                    this.PanelClassRecord.Visible = true;
                    this.PanelEventRecord.Visible = false;
                    if (!string.IsNullOrEmpty(Request.QueryString["cid"]))
                    {
                        int.TryParse(Request.QueryString["cid"].ToString(), out classID);
                        ClassID = classID;
                       Class currentCass= POD.Logic.ProgramCourseClassLogic.GetClassByID(ClassID);
                        if (currentCass != null)
                        {
                            if (currentCass.Site.AttendanceLockedDate.HasValue)
                            {
                                if (currentCass.DateStart.HasValue &&
                                    currentCass.DateStart.Value.Date <= currentCass.Site.AttendanceLockedDate.Value.Date)
                                {
                                    this.PanelClassNewAttendance.Visible = false;
                                    this.PanelClassAttendanceLocked.Visible = true;
                                }
                            }
                        }
                    }
                }
                else if (typeOfAttendance == "Event")
                {
                    this.PanelClassRecord.Visible = false;
                    this.PanelEventRecord.Visible = true;
                    if (!string.IsNullOrEmpty(Request.QueryString["cid"]))
                    {
                        int.TryParse(Request.QueryString["cid"].ToString(), out eventid);
                        EventID = eventid;
                        Event currentEvent = POD.Logic.ProgramCourseClassLogic.GetEvent(EventID);
                        if (currentEvent != null)
                        {
                            if (currentEvent.Site.AttendanceLockedDate.HasValue)
                            {
                                if (currentEvent.DateStart.HasValue &&
                                    currentEvent.DateStart.Value.Date <= currentEvent.Site.AttendanceLockedDate.Value.Date)
                                {
                                    this.PanelNewEventAttendance.Visible = false;
                                    this.PanelEventAttendanceLocked.Visible = true;
                                }
                            }
                        }
                    }
                }
                //only admin and central admins can delete
                if (!Security.UserInRole("Administrators") && 
                    !Security.UserInRole("CentralTeamUsers") && !Security.UserInRole("SiteTeamUsers"))
                {
                    this.RadMenuOptions.Visible = false;
                    this.RadContextMenuEA.Visible = false;
                }
                LoadDropdowns();
            }
        }



        bool isExport = false;

        protected void ImageButton3_Click(object sender, System.Web.UI.ImageClickEventArgs e)
        {
            
            RadGriAttendancesEvent.MasterTableView.ExportToWord();
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            var x = eventid;
            isExport = true;
            Event currentEvent = POD.Logic.ProgramCourseClassLogic.GetEvent(EventID);
            RadGriAttendancesEvent.ExportSettings.FileName = "Event : " + currentEvent.Name;
            RadGriAttendancesEvent.MasterTableView.ExportToWord();
        }

        protected void RadGriAttendancesEvent_ExportCellFormatting(object source, ExportCellFormattingEventArgs e)
        {
            
            GridDataItem item = e.Cell.Parent as GridDataItem;
           
            
            if (item.ItemType == GridItemType.AlternatingItem)
                item.Style["background-color"] = "#ffffff";
            else
                item.Style["background-color"] = "#eaeaea";
        }
        protected void RadGriAttendancesEvent_ItemCreated(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridHeaderItem && isExport)
            {
                foreach (TableCell cell in e.Item.Cells)
                    cell.Style["width"] = "20px";
            }
        }

        protected void RadGriAttendancesEvent_GridExporting(object sender, GridExportingArgs e)
        {
            var x = eventid;

            Event currentEvent = POD.Logic.ProgramCourseClassLogic.GetEvent(EventID);

            string imageURL = @"<div><img src='https://pod.uacdc.org/Templates/Images/prodigy_logo.png' alt='prodigy_logo' height='65' width='100'></div><br>";

            string customHTML = imageURL + "<div width=\"100%\" style=\"clear:both;text-align:left;font-size:16px; font-weight: bold; font-family:Verdana;\"> Attendance Report</div><div style='font-size:14px; font-family:Verdana; text-align:left'>" + currentEvent.Name + "</div><hr/><br>";

            e.ExportOutput = e.ExportOutput.Replace("<body>", String.Format("<body>{0}", customHTML));
        }

        private void LoadDropdowns()
        {
            if (Security.UserInRole("Administrators"))
            {
                this.ComboBoxYouth.DataSource = POD.Logic.PeopleLogic.GetStudents();
                this.RadComboBoxStudent.DataSource = POD.Logic.PeopleLogic.GetStudents();
            }
            else
            {
                int siteid = 0;
                int.TryParse(Session["UsersSiteID"].ToString(), out siteid);
                this.ComboBoxYouth.DataSource = POD.Logic.PeopleLogic.GetStudents(siteid);
                this.RadComboBoxStudent.DataSource = POD.Logic.PeopleLogic.GetStudents(siteid);

            }
            this.RadComboBoxStudent.DataBind();
            this.ComboBoxYouth.DataBind();
            if (ClassID != 0)
            {
                Class currentClass = POD.Logic.ProgramCourseClassLogic.GetClassByID(ClassID);
                if (currentClass != null)
                {
                    RadComboBoxStudentClass.DataSource = POD.Logic.PersonRelatedLogic.GetStudentsByCourseInstanceID(currentClass.CourseInstanceID).OrderBy(c => c.LastName).ThenBy(c => c.FirstName).ToList();
                    RadComboBoxStudentClass.DataBind();
                }
            }
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                int personid = 0;
                if (ClassID != 0)
                {

                    int.TryParse(RadComboBoxStudentClass.SelectedValue.ToString(), out personid);
                    bool isTardy = this.RadiobuttonListTardy.SelectedIndex != -1 ? Convert.ToBoolean(this.RadiobuttonListTardy.SelectedValue) : false;
                    bool leftEarly = this.RadiobuttonListEarly.SelectedIndex != -1 ? Convert.ToBoolean(this.RadiobuttonListEarly.SelectedValue) : false;

                    POD.Logic.PersonRelatedLogic.AddUpdateClassAttendance(0, personid, ClassID, leftEarly, isTardy, this.TextBoxNotes.Text.Trim());
                    this.RadGriAttendancesClass.Rebind();
                }
                else if (EventID != 0)
                {

                    if (!string.IsNullOrEmpty(RadComboBoxStudent.SelectedValue))
                    {
                        int.TryParse(RadComboBoxStudent.SelectedValue.ToString(), out personid);
                    }
                    else if (!string.IsNullOrEmpty(RadComboBoxNonStudent.SelectedValue))
                    {
                        int.TryParse(RadComboBoxNonStudent.SelectedValue.ToString(), out personid);
                        int relatedPersonid = 0;
                        int relationShipID = 0;
                        int.TryParse(ComboBoxYouth.SelectedValue.ToString(), out relatedPersonid);
                        int.TryParse(ComboBoxRelationShip.SelectedValue.ToString(), out relationShipID);
                        POD.Logic.PeopleLogic.AddPersonRelationShip(relatedPersonid, personid, relationShipID, string.Empty, false, false, false, false);

                    }
                    else
                    {

                        int relatedPersonid = 0;
                        int relationShipID = 0;
                        int.TryParse(ComboBoxYouth.SelectedValue.ToString(), out relatedPersonid);
                        int.TryParse(ComboBoxRelationShip.SelectedValue.ToString(), out relationShipID);

                        int statusID = POD.Logic.ManageTypesLogic.GetStatusTypeByCategoryAndName("common", "active").StatusTypeID;
                        int typeid = POD.Logic.ManageTypesLogic.GetPersonTypeIDByName("non-student");
                        Person newPerson = POD.Logic.PeopleLogic.AddUpdatePerson(0, this.TextBoxFirstName.Text, this.TextBoxLastName.Text.Trim(), string.Empty, this.RadDatePickerDOB.SelectedDate, string.Empty, statusID, typeid);
                        personid = newPerson.PersonID;
                        POD.Logic.PeopleLogic.AddPersonRelationShip(relatedPersonid, personid, relationShipID, string.Empty, false, false, false, false);

                    }
                    POD.Logic.PersonRelatedLogic.AddUpdateEventAttendance(0, personid, EventID);
                    this.RadGriAttendancesEvent.Rebind();
                }
            }
        }

        protected void CustomValYouthRelation_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = true;
            if (!string.IsNullOrEmpty(RadComboBoxNonStudent.SelectedValue))
            {
                if (!string.IsNullOrEmpty(ComboBoxYouth.SelectedValue))
                {
                    if (string.IsNullOrEmpty(ComboBoxRelationShip.SelectedValue))
                    {
                        args.IsValid = false;
                    }
                }
                else
                {
                    args.IsValid = false;
                }
            }
            else if (!string.IsNullOrEmpty(this.TextBoxFirstName.Text) && !string.IsNullOrEmpty(this.TextBoxLastName.Text))
            {
                if (!string.IsNullOrEmpty(ComboBoxYouth.SelectedValue))
                {
                    if (string.IsNullOrEmpty(ComboBoxRelationShip.SelectedValue))
                    {
                        args.IsValid = false;
                    }
                }
                else
                {
                    args.IsValid = false;
                }
            }
        }

        private IEnumerable<EventAttendance> GetData()
        {

            IList<EventAttendance> list = new List<EventAttendance>();
            if (EventID != 0)
            {
                list = POD.Logic.ProgramCourseClassLogic.GetEventAttendanceList(EventID);
            }
            if (list.Count > 0)
            {
                this.EventAttendanceHeader.Text = string.Format("{0}", list.First().Event.Name);
            }
            return list;

        }

        protected void RadGriAttendancesEvent_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            RadGrid evGrid = (RadGrid)sender;
            evGrid.DataSource = GetData();
        }

        protected void RadContextMenuEA_ItemClick(object sender, Telerik.Web.UI.RadMenuEventArgs e)
        {
            int radGridClickedRowIndex;
            radGridClickedRowIndex = Convert.ToInt32(Request.Form["radGridClickedRowIndexEA"]);
            string recID = RadGriAttendancesEvent.MasterTableView.DataKeyValues[radGridClickedRowIndex]["EventAttendanceID"].ToString();
            switch (e.Item.Value)
            {
                case "Delete":
                    if (!string.IsNullOrEmpty(recID))
                    {
                        POD.Logic.ProgramCourseClassLogic.DeleteAttendanceRecord("Event", int.Parse(recID));
                        RadGriAttendancesEvent.Rebind();
                    }
                    break;
            }

        }

        private List<ClassAttendance> GetClassData()
        {
            List<ClassAttendance> list = new List<ClassAttendance>();
            if (ClassID != 0)
            {
                list = POD.Logic.ProgramCourseClassLogic.GetClassAttendances(ClassID);
            }
            if (list.Count > 0)
            {
                this.LiteralClassAttendanceHeader.Text = string.Format("{0}", list.First().Class.Name);
            }
            return list;

        }

        protected void RadGriAttendancesClass_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            RadGrid evGrid = (RadGrid)sender;
            evGrid.DataSource = GetClassData();
        }

        protected void RadMenu1_ItemClick(object sender, Telerik.Web.UI.RadMenuEventArgs e)
        {
            int radGridClickedRowIndex;
            radGridClickedRowIndex = Convert.ToInt32(Request.Form["radGridClickedRowIndex"]);

            string recID = RadGriAttendancesClass.MasterTableView.DataKeyValues[radGridClickedRowIndex]["ClassAttendanceID"].ToString();
            switch (e.Item.Value)
            {
                case "Delete":
                    if (!string.IsNullOrEmpty(recID))
                    {
                        POD.Logic.ProgramCourseClassLogic.DeleteAttendanceRecord("Class", int.Parse(recID));
                        RadGriAttendancesClass.Rebind();
                    }
                    break;
            }
        }

        /// <summary>
        /// if neither or both are filled the validation suceeds
        /// </summary>
        /// <param name="source"></param>
        /// <param name="args"></param>
        protected void customVal_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = false;
            if (!string.IsNullOrEmpty(this.TextBoxFirstName.Text) && !string.IsNullOrEmpty(this.TextBoxLastName.Text))
            {
                args.IsValid = true;
            }
            else if (string.IsNullOrEmpty(this.TextBoxFirstName.Text) && string.IsNullOrEmpty(this.TextBoxLastName.Text))
            {
                args.IsValid = true;
            }
        }

        protected void RadGriAttendancesEvent_HTMLExporting(object sender, GridHTMLExportingEventArgs e)
        {
            e.Styles.Append("td { border:solid 0.1pt #CCCCCC; }");
            e.Styles.Append("th { border:solid 0.1pt #CCCCCC; }");
        }
    }
}