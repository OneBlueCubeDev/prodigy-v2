using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Omu.ValueInjecter;
using POD.Data.Entities;
using Telerik.Web.UI;
using System.Web.Security;
using POD.Logic;

namespace POD.Pages
{
    public partial class RiskAssessmentPage : System.Web.UI.Page, IRiskAssessmentCriteria
    {
        private int personid = 0;
        private int enrollID = 0;
        RiskAssessment currentRA = null;
        Person student = null;
        Enrollment currentEnrollment = null;
        int riskID = 0;
        private int PersonID
        {
            get
            {
                if (ViewState["PersonID"] != null)
                {
                    int.TryParse(ViewState["PersonID"].ToString(), out personid);
                }
                return personid;
            }
            set
            {
                ViewState["PersonID"] = value;
            }
        }
        private int RiskID
        {
            get
            {
                if (ViewState["RiskID"] != null)
                {
                    int.TryParse(ViewState["RiskID"].ToString(), out riskID);
                }
                return riskID;
            }
            set
            {
                ViewState["RiskID"] = value;
            }
        }

        private int EnrollmentID
        {
            get
            {
                if (ViewState["EnrollmentID"] != null)
                {
                    int.TryParse(ViewState["EnrollmentID"].ToString(), out enrollID);
                }
                return enrollID;
            }
            set
            {
                ViewState["EnrollmentID"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                PanelActions.Visible = false;
                POD.MasterPages.Admin mtPage = (POD.MasterPages.Admin)this.Master;
                if (mtPage != null)
                {
                    mtPage.SetSearch("Enrollment");
                    mtPage.SetNavigation("Youth");
                }
                this.EnrollmentLinks1.ShowButtons(1);

                int id = 0;
                if (!string.IsNullOrEmpty(Request.QueryString["rid"]))
                {
                    if (int.TryParse(Request.QueryString["rid"], out id))
                    {
                        RiskID = id;
                        id = 0;
                    }
                }
                if (!string.IsNullOrEmpty(Request.QueryString["eid"]))
                {
                    if (int.TryParse(Request.QueryString["eid"], out id))
                    {
                        EnrollmentID = id;
                        id = 0;
                    }
                }
                if (!string.IsNullOrEmpty(Request.QueryString["pid"]))
                {
                    if (int.TryParse(Request.QueryString["pid"], out id))
                    {
                        PersonID = id;
                        id = 0;
                    }
                }
                LoadLists();
                LoadRiskAssessment();
            }
        }

        private void LoadLists()
        {
            if (Security.AuthorizeRoles("Administrators,CentralTeamUsers"))
            {
                LoadSiteList();
                LoadLocationList();
            }
            else
            {
                int siteid = 0;
                int.TryParse(Session["UsersSiteID"].ToString(), out siteid);
                LoadSiteList(siteid);
                LoadLocationList(siteid);
                LoadStaffList(siteid);
                this.RadComboBoxStaff.Enabled = true;
                this.RadComboBoxProdigySite.Enabled = false;
            }
        }

        private void LoadLocationList(int? siteID = null)
        {
            if (siteID != null && siteID > 0)
            {
                this.RadComboBoxProdigyLocation.DataSource = POD.Logic.LookUpTypesLogic.GetLocations().Where(x => x.SiteLocationID == siteID || x.LocationID == siteID);
                this.RadComboBoxProdigyLocation.DataBind();
            }
            else
            {
                this.RadComboBoxProdigyLocation.DataSource = POD.Logic.LookUpTypesLogic.GetLocations();
                this.RadComboBoxProdigyLocation.DataBind();
            }
        }

        private void LoadSiteList(int? siteid = null)
        {
            this.RadComboBoxProdigySite.DataSource = POD.Logic.LookUpTypesLogic.GetSites();
            this.RadComboBoxProdigySite.DataBind();
            this.RadComboBoxProdigySite.Items.Insert(0, new RadComboBoxItem("All", "0"));
            if (siteid != null && siteid > 0)
            {
                var item = this.RadComboBoxProdigySite.Items.FindItemByValue(siteid.ToString());
                if (item != null)
                {
                    item.Selected = true;
                }
            }
        }

        private void LoadStaffList(int siteID)
        {
            this.RadComboBoxStaff.DataSource = POD.Logic.PeopleLogic.GetStaff(siteID).Select(p => new { p.UserID, Name = p.FirstName + " " + p.LastName });
            this.RadComboBoxStaff.DataBind();
        }

        private void LoadRiskAssessment()
        {
            if (RiskID != 0)
            {
                currentRA = POD.Logic.PersonRelatedLogic.GetRiskAssessmentByID(RiskID);
            }
            else if (EnrollmentID != 0)
            {
                currentRA = POD.Logic.PersonRelatedLogic.GetRiskAssessmentByEnrollmentID(EnrollmentID);
                if (currentRA != null)
                {
                    currentEnrollment = currentRA.Enrollments != null ? currentRA.Enrollments.OrderByDescending(e => e.DateTimeStamp).FirstOrDefault(en => en.EnrollmentID == EnrollmentID) : null;
                }
            }
            if (currentRA != null && currentRA.Enrollments.Count > 0)
            {
                student = currentRA.Person;
                PersonID = student.PersonID;
                EnrollmentID = currentRA.Enrollments.OrderByDescending(e => e.DateTimeStamp).FirstOrDefault().EnrollmentID;
            }
            else if (PersonID != 0)
            {
                student = POD.Logic.PeopleLogic.GetPersonByID(PersonID);
                PanelActions.Visible = true;
            }

            if (student != null)
            {
                this.RiskAssessmentYouthFirstNameTextBox.Text = student.FirstName;
                this.RiskAssessmentYouthLastNameTextBox.Text = student.LastName;
                this.RiskAssessmentYouthMiddleNameTextBox.Text = student.MiddleName;
                this.RadDatePickerRiskAssessmentDOB.SelectedDate = student.DateOfBirth;
                this.EnrollmentIDTextBox.Text = student.DJJIDNum;
                TransferClient.Attributes["onclick"] = "ShowTransfer('" + PersonID.ToString() + "');return false;";
                CertificateLink.Attributes["onclick"] = "DownLoadCertificate('" + PersonID.ToString() + "');return false;";
                PanelActions.Visible = true;
            }
            if (currentRA != null)
            {
                HyperLinkRelease.Attributes["href"] = "#";
                HyperLinkRelease.Attributes["onclick"] = "ShowRelease('" + PersonID.ToString() + "','" + currentRA.RiskAssessmentID.ToString() + "','RA');return false;";

                RiskID = currentRA.RiskAssessmentID;

                LabelCreated.Text = currentRA.DateCreated.HasValue ? currentRA.DateCreated.Value.ToShortDateString() : "N/A";
                LabelEdited.Text = currentRA.DateModified.HasValue ? currentRA.DateModified.Value.ToShortDateString() : "N/A";
                if (currentRA.SiteMgrInitials.HasValue)
                {
                    ListItem mgrItem = RadioButtonListMgrInitials.Items.FindByValue(currentRA.SiteMgrInitials.Value.ToString());
                    if (mgrItem != null)
                    {
                        mgrItem.Selected = true;
                    }
                }

                //release form for print
                this.ReleaseForm1.ReleaseType = "Enrollment";


                this.RadDatePickerRiskAssessmentDate.SelectedDate = currentRA.DateApplied;
                int? siteLocationID = currentRA.SiteLocationID;
                int? locationID = currentRA.LocationID;
                if (siteLocationID != null)
                {
                    var siteItem = this.RadComboBoxProdigySite.Items.FindItemByValue(siteLocationID.ToString());
                    if (siteItem != null)
                    {
                        siteItem.Selected = true;
                    }
                    LoadLocationList(siteLocationID);
                }
                if (locationID != null)
                {
                    RadComboBoxItem locItem = this.RadComboBoxProdigyLocation.Items.FindItemByValue(locationID.ToString());
                    if (locItem != null)
                    {
                        locItem.Selected = true;
                    }

                    //enable staff
                    LoadStaffList(locationID.Value);
                    this.RadComboBoxStaff.Enabled = true;

                    if (!string.IsNullOrEmpty(currentRA.CreatedByPersonID))
                    {
                        MembershipUser user = POD.Logic.Security.GetUserByUserName(currentRA.CreatedByPersonID);
                        if (user != null && user.ProviderUserKey != null)
                        {
                            RadComboBoxItem itemStaff = this.RadComboBoxStaff.Items.FindItemByValue(user.ProviderUserKey.ToString());
                            if (itemStaff != null)
                            {
                                itemStaff.Selected = true;
                            }
                        }
                    }

                }
                if (!string.IsNullOrEmpty(currentRA.ParentStatus))
                {
                    foreach (string str in currentRA.ParentStatus.Split(','))
                    {
                        ListItem parentStatus = this.CheckBoxListRiskAssessmentParentStatus.Items.FindByValue(str);
                        if (parentStatus != null)
                        {
                            parentStatus.Selected = true;
                        }
                    }
                }
                if (!string.IsNullOrEmpty(currentRA.FamilyStatus))
                {
                    foreach (string str in currentRA.FamilyStatus.Split(','))
                    {
                        ListItem famStatus = this.CheckBoxListRiskAssessmentFamilyStucture.Items.FindByValue(str);
                        if (famStatus != null)
                        {
                            famStatus.Selected = true;
                        }
                    }
                }
                //referred by
                if (!string.IsNullOrEmpty(currentRA.ReferredBy))
                {
                    foreach (string str in currentRA.ReferredBy.Split(','))
                    {
                        ListItem referredBy = this.CheckBoxListRiskAssessmentReferral.Items.FindByValue(str);
                        if (referredBy != null)
                        {
                            referredBy.Selected = true;
                            if (referredBy.Value == "Other")
                            {
                                this.RiskAssessmentReferralOtherTextBox.Text = currentRA.RefByOther;
                            }
                        }
                    }
                }

                IRiskAssessmentCriteria riskAssessmentCriteria = this;
                riskAssessmentCriteria.InjectFrom(currentRA);
            }
            else
            {
                LiRelease.Visible = false;
                LabelCreated.Text = "N/A";
                LabelEdited.Text = "N/A";
            }
        }

        protected void DeleteButton_Click(object sender, EventArgs e)
        {
            if (RiskID != 0)
            {
                string result = POD.Logic.PersonRelatedLogic.DeleteRiskAssessment(RiskID);
                if (string.IsNullOrEmpty(result))
                {
                    Response.Redirect("~/Pages/Enrollments.aspx");
                }
            }
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                LabelCriteriaNotMet.Visible = false;
                //check if we find any matches based on name and dob
                if (PersonID == 0 && FoundPersonMatches())//if so let user pick an option before save
                {
                    string personInfo = string.Empty;
                    personInfo += this.RiskAssessmentYouthFirstNameTextBox.Text.Trim() + "|";
                    personInfo += this.RiskAssessmentYouthLastNameTextBox.Text.Trim() + "|";
                    personInfo += this.RiskAssessmentYouthMiddleNameTextBox.Text.Trim() + "|";
                    if (this.RadDatePickerRiskAssessmentDOB.SelectedDate.HasValue)
                    {
                        personInfo += this.RadDatePickerRiskAssessmentDOB.SelectedDate.Value.ToShortDateString() + "|";
                    }
                    POD.MasterPages.Admin mtPage = (POD.MasterPages.Admin)this.Master;
                    if (mtPage != null)
                    {
                        mtPage.ShowWindow(personInfo);
                    }

                }
                else //else move on to the save
                {
                    Save();
                }
            }
        }

        private bool FoundPersonMatches()
        {
            bool hasMatches = false;

            int count = POD.Logic.PeopleLogic.GetPeopleByNameMatchCount(this.RiskAssessmentYouthFirstNameTextBox.Text.Trim(), this.RiskAssessmentYouthLastNameTextBox.Text.Trim(),  this.RadDatePickerRiskAssessmentDOB.SelectedDate);
            if (count != 0)
            {
                hasMatches = true;
            }
            return hasMatches;
        }

        public void SavePersonMatch(int personid)
        {
            PersonID = personid;
            Save();
        }

        private void Save()
        {
            bool attendance = false;
            bool family = false;
            bool substance = false;
            bool individual = false;
            currentRA = new RiskAssessment();

            if (RiskID != 0)
            {
                currentRA.RiskAssessmentID = RiskID;
            }
           
            currentRA.SiteMgrInitials = bool.Parse(this.RadioButtonListMgrInitials.SelectedValue);
            if (currentRA.SiteMgrInitials.Value)
            {
                IRiskAssessmentCriteria riskAssessmentCriteria = this;
                currentRA.InjectFrom(riskAssessmentCriteria);
                attendance = EvaluateRiskAssessmentAttendanceCriteria(currentRA);
                individual = EvaluateRiskAssessmentIndividualCriteria(currentRA);
                family = EvaluateRiskAssessmentFamilyCriteria(currentRA);
                substance = EvaluateRiskAssessmentSubstanceCriteria(currentRA);

                int counterCriteriaMet = 0;
                if (substance)
                {
                    counterCriteriaMet += 1;
                }
                if (family)
                {
                    counterCriteriaMet += 1;
                }
                if (individual)
                {
                    counterCriteriaMet += 1;
                }
                if (attendance)
                {
                    counterCriteriaMet += 1;
                }
                if (counterCriteriaMet >= 2)  //did the youth fill 2 out of 4 criteria save the data 
                {
                    bool locationChanged = false;
                    if (this.RadComboBoxProdigyLocation.SelectedIndex != -1 && !string.IsNullOrEmpty(this.RadComboBoxProdigyLocation.SelectedValue))
                    {
                        int locationID = int.Parse(RadComboBoxProdigyLocation.SelectedValue);
                        locationChanged = currentRA.LocationID != locationID;
                        if (locationChanged)
                        {
                            currentRA.LocationID = locationID;

                            var location = LookUpTypesLogic.GetLocationByID(locationID);
                            if (location != null)
                            {
                                currentRA.SiteLocationID = location.IsSite ? location.LocationID : location.SiteLocationID;
                            }
                        }
                    }
                    Person currentPerson = POD.Logic.PeopleLogic.AddUpdatePerson(PersonID, this.RiskAssessmentYouthFirstNameTextBox.Text.Trim(), this.RiskAssessmentYouthLastNameTextBox.Text.Trim(), this.RiskAssessmentYouthMiddleNameTextBox.Text.Trim(), this.RadDatePickerRiskAssessmentDOB.SelectedDate, 1, this.EnrollmentIDTextBox.Text.Trim(), currentRA.SiteLocationID);
                    currentRA.PersonID = currentPerson.PersonID;
                    //family status
                    string familyStatus = string.Empty;
                    foreach (ListItem it in this.CheckBoxListRiskAssessmentFamilyStucture.Items)
                    {
                        if (it.Selected)
                        {
                            familyStatus += it.Value + ",";
                        }
                    }
                    familyStatus = familyStatus.TrimEnd(',');
                    currentRA.FamilyStatus = familyStatus;
                    //youth's parent status
                    string parentStatus = string.Empty;
                    foreach (ListItem it in this.CheckBoxListRiskAssessmentParentStatus.Items)
                    {
                        if (it.Selected)
                        {
                            parentStatus += it.Value + ",";
                        }
                    }
                    parentStatus = parentStatus.TrimEnd(',');
                    currentRA.ParentStatus = parentStatus;
                    currentRA.DateApplied = this.RadDatePickerRiskAssessmentDate.SelectedDate;
                   


                    //referral
                    string referredBy = string.Empty;
                    foreach (ListItem it in this.CheckBoxListRiskAssessmentReferral.Items)
                    {
                        if (it.Selected)
                        {
                            referredBy += it.Value + ",";
                        }

                    }
                    referredBy = referredBy.TrimEnd(',');
                    currentRA.ReferredBy = referredBy;
                    currentRA.RefByOther = this.RiskAssessmentReferralOtherTextBox.Text.Trim();

                    if (!string.IsNullOrEmpty(this.RadComboBoxStaff.SelectedValue))
                    {
                        Guid userid = new Guid(this.RadComboBoxStaff.SelectedValue);
                        currentRA.CreatedByPersonID = POD.Logic.Security.GetUserByUserID(userid).UserName;
                    }
                    int progId = 0;
                    int.TryParse(Session["ProgramID"].ToString(), out progId);
                    currentRA.ProgramID = progId;

                    currentRA.StatusTypeID = POD.Logic.ManageTypesLogic.GetStatusTypeIDByName("rollover");
                    RiskID = POD.Logic.PersonRelatedLogic.AddUpdateRiskAssessment(currentRA);
                    Enrollment currentEnroll = POD.Logic.PersonRelatedLogic.GetEnrollmentsByGrantYearByPersonID(currentRA.PersonID, currentRA.DateApplied.Value).FirstOrDefault();

                    if (locationChanged && currentEnroll != null
                        && (currentEnroll.LocationID != currentRA.LocationID || currentEnroll.SiteLocationID != currentRA.SiteLocationID))
                    {
                        POD.Logic.PersonRelatedLogic.UpdateEnrollmentLocation(currentEnroll.EnrollmentID,
                                                                              currentRA.LocationID,
                                                                              currentRA.SiteLocationID);
                    }
                  
                    int diversionErollmentTypeId = POD.Logic.ManageTypesLogic.GetEnrollmentTypeIDByName("diversion youth");
                    string url = "~/Pages/Enrollments.aspx";
                    //there should not be a non diversion enrollment witout an risk assessment
                    if (currentEnroll == null) //user needs to fill out an enrollment form
                    {
                        url = string.Format("~/Pages/EnrollmentPage.aspx?id={0}&rid={1}", currentRA.PersonID, RiskID);
                    }
                    else if (!currentEnroll.RiskAssessmentID.HasValue && currentEnroll.EnrollmentTypeID != diversionErollmentTypeId)
                    {
                        POD.Logic.PersonRelatedLogic.UpdateEnrollment(currentEnroll.EnrollmentID, RiskID);
                    }
                    Response.Redirect(url);

                }
                else
                {
                    LabelCriteriaNotMet.Visible = true;
                    LabelCriteriaNotMet.Text = "Youth did not meet the required criteria, you can't enter him/her into the system. If you have any questions please contact UACDC.";
                }
            }
            else
            {
                LabelCriteriaNotMet.Visible = true;
                LabelCriteriaNotMet.Text = "Site Manager's Initials are required to enter the Youth into the system.";
            }
        }

        private bool EvaluateRiskAssessmentSubstanceCriteria(IRiskAssessmentCriteria criteria)
        {
            //substance
            if (currentRA.SACharged)
            {
                return true;
            }
            if (currentRA.SADrugs)
            {
                return true;
            }
            if (currentRA.SATobacco)
            {
                return true;
            }
            return false;
        }

        private bool EvaluateRiskAssessmentFamilyCriteria(IRiskAssessmentCriteria criteria)
        {
            //family            
            if (currentRA.HistChildAbuse)
            {
                return true;
            }
            if (currentRA.HistDCF)
            {
                return true;
            }
            if (currentRA.HistNeglect)
            {
                return true;
            }
            if (currentRA.InfCriminalRecord)
            {
                return true;
            }
            if (currentRA.InfPrisonTime)
            {
                return true;
            }
            if (currentRA.InfProbation)
            {
                return true;
            }
            if (currentRA.ParControl)
            {
                return true;
            }
            if (currentRA.ParFreeTimeWhere)
            {
                return true;
            }

            if (currentRA.ParFreeTimeWithWhom)
            {
                return true;
            }
            if (currentRA.ParProbinSchool)
            {
                return true;
            }
            if (currentRA.ParUnclear)
            {
                return true;
            }
            return false;
        }

        private bool EvaluateRiskAssessmentIndividualCriteria(IRiskAssessmentCriteria criteria)
        {
            //individual
            if (currentRA.GangAssociated)
            {
                return true;
            }
            if (currentRA.GangAssocRecord)
            {
                return true;
            }
            if (currentRA.GangLaw)
            {
                return true;
            }
            if (currentRA.GangMember)
            {
                return true;
            }
            if (currentRA.GangRecord)
            {
                return true;
            }
            if (currentRA.GangReported)
            {
                return true;
            }
            if (currentRA.StealCharged)
            {
                return true;
            }
            if (currentRA.StealFamily)
            {
                return true;
            }
            if (currentRA.RunCurrent)
            {
                return true;
            }
            if (currentRA.RunOnce)
            {
                return true;
            }
            if (currentRA.RunThree)
            {
                return true;
            }
            return false;
        }

        private bool EvaluateRiskAssessmentAttendanceCriteria(IRiskAssessmentCriteria criteria)
        {
            if (currentRA.AcFailingMoreThanOnce)
            {
                return true;
            }
            if (currentRA.AcFailingOnce)
            {
                return true;
            }
            if (currentRA.AcFailingSixMos)
            {
                return true;
            }
            if (currentRA.AcLearningDisabilities)
            {
                return true;
            }
            if (currentRA.AttNotEnrolled)
            {
                return true;
            }
            if (currentRA.AttSkipClass)
            {
                return true;
            }
            if (currentRA.AttSkipSchool)
            {
                return true;
            }
            if (currentRA.AttTruant)
            {
                return true;
            }
            if (currentRA.BehExpelledPrev)
            {
                return true;
            }
            if (currentRA.BehSuspended)
            {
                return true;
            }
            if (currentRA.BehSuspendedPrev)
            {
                return true;
            }
            return false;
        }

        protected void RadComboBoxProdigyLocation_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            this.RadComboBoxStaff.ClearSelection();

            if (!string.IsNullOrEmpty(e.Value))
            {
                int locid = 0;
                int.TryParse(e.Value, out locid);
                this.RadComboBoxStaff.DataSource = POD.Logic.PeopleLogic.GetStaff(locid).Select(p => new { p.UserID, Name = p.FirstName + " " + p.LastName });
                this.RadComboBoxStaff.DataBind();
                this.RadComboBoxStaff.Enabled = true;

            }
            else
            {
                this.RadComboBoxStaff.Enabled = false;
            }
        }

        protected void RadComboBoxProdigySite_OnSelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            this.RadComboBoxStaff.ClearSelection();
            this.RadComboBoxProdigyLocation.ClearSelection();

            if (!string.IsNullOrEmpty(e.Value))
            {
                int siteID = 0;
                if (int.TryParse(e.Value, out siteID))
                {
                    LoadLocationList(siteID);
                    LoadStaffList(siteID);
                    this.RadComboBoxStaff.Enabled = true;
                    this.RadComboBoxProdigyLocation.Enabled = true;
                }
            }
            else
            {
                this.RadComboBoxStaff.Enabled = false;
                this.RadComboBoxProdigyLocation.Enabled = false;
            }
        }

        #region Risk Assessment Criteria

        public bool AttSkipClass
        {
            get
            {
                bool value;
                return bool.TryParse(this.RadioListRAAttendanceSkippingClass.SelectedValue, out value) && value;
            }
            set { this.RadioListRAAttendanceSkippingClass.SelectedValue = value.ToString(); }
        }

        public bool AttSkipSchool
        {
            get
            {
                bool value;
                return bool.TryParse(this.RadioListRAAttendanceSkippingSchool.SelectedValue, out value) && value;
            }
            set { this.RadioListRAAttendanceSkippingSchool.SelectedValue = value.ToString(); }
        }

        public bool AttTruant
        {
            get
            {
                bool value;
                return bool.TryParse(this.RadioListRAAttendanceHabitualTruant.SelectedValue, out value) && value;
            }
            set { this.RadioListRAAttendanceHabitualTruant.SelectedValue = value.ToString(); }
        }

        public bool AttNotEnrolled
        {
            get
            {
                bool value;
                return bool.TryParse(this.RadioListRAAttendanceNotEnrolled.SelectedValue, out value) && value;
            }
            set { this.RadioListRAAttendanceNotEnrolled.SelectedValue = value.ToString(); }
        }

        public bool BehSuspended
        {
            get
            {
                bool value;
                return bool.TryParse(this.RadioListRABehaviorCurrentSuspension.SelectedValue, out value) && value;
            }
            set
            {
                this.RadioListRABehaviorCurrentSuspension.SelectedValue = value.ToString();
            }
        }

        public bool BehExpelled
        {
            get
            {
                bool value;
                return bool.TryParse(this.RadioListRABehaviorCurrentExpelled.SelectedValue, out value) && value;
            }
            set
            {
                this.RadioListRABehaviorCurrentExpelled.SelectedValue = value.ToString();
            }
        }

        public bool BehSuspendedPrev
        {
            get
            {
                bool value;
                return bool.TryParse(this.RadioListRABehaviorSuspended.SelectedValue, out value) && value;
            }
            set
            {
                this.RadioListRABehaviorSuspended.SelectedValue = value.ToString();
            }
        }

        public bool BehExpelledPrev
        {
            get
            {
                bool value;
                return bool.TryParse(this.RadioListRABehaviorExpelled.SelectedValue, out value) && value;
            }
            set
            {
                this.RadioListRABehaviorExpelled.SelectedValue = value.ToString();
            }
        }

        public bool AcFailingSixMos
        {
            get
            {
                bool value;
                return bool.TryParse(this.RadioListRAAcademicFailingClasses.SelectedValue, out value) && value;
            }
            set
            {
                this.RadioListRAAcademicFailingClasses.SelectedValue = value.ToString();
            }
        }

        public bool AcFailingOnce
        {
            get
            {
                bool value;
                return bool.TryParse(this.RadioListRAAcademicHeldBack.SelectedValue, out value) && value;
            }
            set
            {
                this.RadioListRAAcademicHeldBack.SelectedValue = value.ToString();
            }
        }

        public bool AcFailingMoreThanOnce
        {
            get
            {
                bool value;
                return bool.TryParse(this.RadioListRAAcademicHeldBackMoreThanOnce.SelectedValue, out value) && value;
            }
            set
            {
                this.RadioListRAAcademicHeldBackMoreThanOnce.SelectedValue = value.ToString();
            }
        }

        public bool AcLearningDisabilities
        {
            get
            {
                bool value;
                return bool.TryParse(this.RadioListRAAcademicDisability.SelectedValue, out value) && value;
            }
            set
            {
                this.RadioListRAAcademicDisability.SelectedValue = value.ToString();
            }
        }

        public bool ParControl
        {
            get
            {
                bool value;
                return bool.TryParse(this.RadioListRAParentsNoControl.SelectedValue, out value) && value;
            }
            set
            {
                this.RadioListRAParentsNoControl.SelectedValue = value.ToString();
            }
        }

        public bool ParUnclear
        {
            get
            {
                bool value;
                return bool.TryParse(this.RadioListRAParentsNoRules.SelectedValue, out value) && value;
            }
            set
            {
                this.RadioListRAParentsNoRules.SelectedValue = value.ToString();
            }
        }

        public bool ParFreeTimeWhere
        {
            get
            {
                bool value;
                return bool.TryParse(this.RadioListRAParentsHangoutUnknown.SelectedValue, out value) && value;
            }
            set
            {
                this.RadioListRAParentsHangoutUnknown.SelectedValue = value.ToString();
            }
        }

        public bool ParFreeTimeWithWhom
        {
            get
            {
                bool value;
                return bool.TryParse(this.RadioListRAParentsFriendsUnknown.SelectedValue, out value) && value;
            }
            set
            {
                this.RadioListRAParentsFriendsUnknown.SelectedValue = value.ToString();
            }
        }

        public bool ParProbinSchool
        {
            get
            {
                bool value;
                return bool.TryParse(this.RadioListRAParentsNoSchoolProblems.SelectedValue, out value) && value;
            }
            set
            {
                this.RadioListRAParentsNoSchoolProblems.SelectedValue = value.ToString();
            }
        }

        public bool HistChildAbuse
        {
            get
            {
                bool value;
                return bool.TryParse(this.RadioListRAHistoryDocumentedAbuse.SelectedValue, out value) && value;
            }
            set
            {
                this.RadioListRAHistoryDocumentedAbuse.SelectedValue = value.ToString();
            }
        }

        public bool HistNeglect
        {
            get
            {
                bool value;
                return bool.TryParse(this.RadioListRAHistoryEvidenceAbuse.SelectedValue, out value) && value;
            }
            set
            {
                this.RadioListRAHistoryEvidenceAbuse.SelectedValue = value.ToString();
            }
        }

        public bool HistDCF
        {
            get
            {
                bool value;
                return bool.TryParse(this.RadioListRAHistoryDCFInvolvement.SelectedValue, out value) && value;
            }
            set
            {
                this.RadioListRAHistoryDCFInvolvement.SelectedValue = value.ToString();
            }
        }

        public bool InfCriminalRecord
        {
            get
            {
                bool value;
                return bool.TryParse(this.RadioListRAInfluenceFamilyCrimRecord.SelectedValue, out value) && value;
            }
            set
            {
                this.RadioListRAInfluenceFamilyCrimRecord.SelectedValue = value.ToString();
            }
        }

        public bool InfPrisonTime
        {
            get
            {
                bool value;
                return bool.TryParse(this.RadioListRAInfluenceFamilyPrison.SelectedValue, out value) && value;
            }
            set
            {
                this.RadioListRAInfluenceFamilyPrison.SelectedValue = value.ToString();
            }
        }

        public bool InfProbation
        {
            get
            {
                bool value;
                return bool.TryParse(this.RadioListRAInfluenceFamilyParole.SelectedValue, out value) && value;
            }
            set
            {
                this.RadioListRAInfluenceFamilyParole.SelectedValue = value.ToString();
            }
        }

        public bool SATobacco
        {
            get
            {
                bool value;
                return bool.TryParse(this.RadioListRAAbuseTobacco.SelectedValue, out value) && value;
            }
            set
            {
                this.RadioListRAAbuseTobacco.SelectedValue = value.ToString();
            }
        }

        public bool SADrugs
        {
            get
            {
                bool value;
                return bool.TryParse(this.RadioListRASubstanceAbuse3OrMore.SelectedValue, out value) && value;
            }
            set
            {
                this.RadioListRASubstanceAbuse3OrMore.SelectedValue = value.ToString();
            }
        }

        public bool SACharged
        {
            get
            {
                bool value;
                return bool.TryParse(this.RadioListRASubstanceAbuseCharged.SelectedValue, out value) && value;
            }
            set
            {
                this.RadioListRASubstanceAbuseCharged.SelectedValue = value.ToString();
            }
        }

        public bool StealFamily
        {
            get
            {
                bool value;
                return bool.TryParse(this.ListStealingRepeatedly.SelectedValue, out value) && value;
            }
            set
            {
                this.ListStealingRepeatedly.SelectedValue = value.ToString();
            }
        }

        public bool StealCharged
        {
            get
            {
                bool value;
                return bool.TryParse(this.ListStealingBurglary.SelectedValue, out value) && value;
            }
            set
            {
                this.ListStealingBurglary.SelectedValue = value.ToString();
            }
        }

        public bool RunOnce
        {
            get
            {
                bool value;
                return bool.TryParse(this.ListRunAwayOnce.SelectedValue, out value) && value;
            }
            set
            {
                this.ListRunAwayOnce.SelectedValue = value.ToString();
            }
        }

        public bool RunThree
        {
            get
            {
                bool value;
                return bool.TryParse(this.ListRunAway3Plus.SelectedValue, out value) && value;
            }
            set
            {
                this.ListRunAway3Plus.SelectedValue = value.ToString();
            }
        }

        public bool RunCurrent
        {
            get
            {
                bool value;
                return bool.TryParse(this.ListRunAwayCurrent.SelectedValue, out value) && value;
            }
            set
            {
                this.ListRunAwayCurrent.SelectedValue = value.ToString();
            }
        }

        public bool GangMember
        {
            get
            {
                bool value;
                return bool.TryParse(this.ListGangAdmitted.SelectedValue, out value) && value;
            }
            set
            {
                this.ListGangAdmitted.SelectedValue = value.ToString();
            }
        }

        public bool GangReported
        {
            get
            {
                bool value;
                return bool.TryParse(this.ListGangInvolvedWithDelinquencyYouth.SelectedValue, out value) && value;
            }
            set
            {
                this.ListGangInvolvedWithDelinquencyYouth.SelectedValue = value.ToString();
            }
        }

        public bool GangLaw
        {
            get
            {
                bool value;
                return bool.TryParse(this.ListGangIsMember.SelectedValue, out value) && value;
            }
            set
            {
                this.ListGangIsMember.SelectedValue = value.ToString();
            }
        }

        public bool GangAssociated
        {
            get
            {
                bool value;
                return bool.TryParse(this.ListGangInvolvedWith.SelectedValue, out value) && value;
            }
            set
            {
                this.ListGangInvolvedWith.SelectedValue = value.ToString();
            }
        }

        public bool GangAssocRecord
        {
            get
            {
                bool value;
                return bool.TryParse(this.ListGangAssociateWithDelinquencyRecordYouth.SelectedValue, out value) && value;
            }
            set
            {
                this.ListGangAssociateWithDelinquencyRecordYouth.SelectedValue = value.ToString();
            }
        }

        public bool GangRecord
        {
            get
            {
                bool value;
                return bool.TryParse(this.ListGangDelinquencyRecord.SelectedValue, out value) && value;
            }
            set
            {
                this.ListGangDelinquencyRecord.SelectedValue = value.ToString();
            }
        }

        #endregion
    }
}