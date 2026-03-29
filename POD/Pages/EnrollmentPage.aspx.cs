using iTextSharp.text.pdf;
using POD.Data.Entities;
using POD.Logging;
using POD.Logic;
using POD.UserControls.Shared;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace POD.Pages
{
    public partial class EnrollmentPage : System.Web.UI.Page
    {
        private int personid = 0;
        private int raID = 0;
        private int enrollID = 0;
        private int rolloverID = 0;
        string riskAssessmentURL = string.Empty;
        private bool isRollOver = false;
        private int tempPersonId = 0;


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

        private int TempPersonID
        {
            get
            {
                if (ViewState["TempPersonID"] != null)
                {
                    int.TryParse(ViewState["TempPersonID"].ToString(), out tempPersonId);
                }
                return tempPersonId;
            }
            set
            {
                ViewState["TempPersonID"] = value;
            }
        }
        int phoneTypeKey;
        int cellPhoneTypeID;
        int homephonetype;
        int addressTypeid;
        int activeStatusID;
        int oldEnrollmentID;

        enum EnrollmentUsageType { isNewDiversion, isNewPrevention, isEditExisting }
        EnrollmentUsageType enrollmentUsage;

        private int RolloverID
        {
            get
            {
                if (ViewState["RolloverID"] != null)
                {
                    int.TryParse(ViewState["RolloverID"].ToString(), out rolloverID);
                }
                return rolloverID;
            }
            set
            {
                ViewState["RolloverID"] = value;
            }
        }

        private bool IsRollOver
        {
            get
            {
                if (ViewState["IsRollOver"] != null)
                {
                    bool.TryParse(ViewState["IsRollOver"].ToString(), out isRollOver);
                }
                return isRollOver;
            }
            set
            {
                ViewState["IsRollOver"] = value;
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

        private int RiskAssessmentID
        {
            get
            {
                if (ViewState["RiskAssessmentID"] != null)
                {
                    int.TryParse(ViewState["RiskAssessmentID"].ToString(), out raID);
                }
                return raID;
            }
            set
            {
                ViewState["RiskAssessmentID"] = value;
            }
        }



        private int OldEnrollmentID
        {
            get
            {
                if (ViewState["OldEnrollmentID"] != null)
                {
                    int.TryParse(ViewState["OldEnrollmentID"].ToString(), out oldEnrollmentID);
                }
                return oldEnrollmentID;
            }
            set
            {
                ViewState["OldEnrollmentID"] = value;
            }
        }


        protected void Page_Load(object sender, EventArgs e)
        {

            phoneTypeKey = POD.Logic.ManageTypesLogic.GetPhoneNumberTypeIDByName("work");
            cellPhoneTypeID = POD.Logic.ManageTypesLogic.GetPhoneNumberTypeIDByName("cell");
            homephonetype = POD.Logic.ManageTypesLogic.GetPhoneNumberTypeIDByName("home");
            addressTypeid = POD.Logic.ManageTypesLogic.GetAddressTypeIDByName("mailing");
            activeStatusID = POD.Logic.ManageTypesLogic.GetStatusTypeIDByName("active");



            if (Security.UserInRole("Administrators") || Security.UserInRole("CentralTeamUsers"))
            {
                this.RadDatePickerEnrollmentDate.Enabled = true;
            }

            if (!IsPostBack)
            {
                this.EnrollmentLinks1.ShowButtons(1);
                POD.MasterPages.Admin mtPage = (POD.MasterPages.Admin)this.Master;
                if (mtPage != null)
                {
                    mtPage.SetSearch("Enrollment");
                    mtPage.SetNavigation("Youth");
                    mtPage.CheckSession();
                }
                if (!string.IsNullOrEmpty(Request.QueryString["ro"]))
                {
                    int.TryParse(Request.QueryString["ro"].ToString(), out rolloverID);

                    RolloverID = rolloverID;
                    isRollOver = true;
                    //this.reqValEnrollmentDate.Enabled = false;
                }
                if (!string.IsNullOrEmpty(Request.QueryString["id"]))
                {
                    int.TryParse(Request.QueryString["id"].ToString(), out personid);
                    PersonID = personid;
                }
                if (!string.IsNullOrEmpty(Request.QueryString["eid"]))
                {

                    if (isRollOver)
                    {
                        int.TryParse(Request.QueryString["eid"].ToString(), out oldEnrollmentID);
                        OldEnrollmentID = oldEnrollmentID;
                    }
                    else
                    {
                        int.TryParse(Request.QueryString["eid"].ToString(), out enrollID);
                        EnrollmentID = enrollID;
                    }

                    this.rfvlunch.Enabled = false;
                    this.rfvfoster.Enabled = false;
                    this.rfvmedicaid.Enabled = false;

                }
                if (!string.IsNullOrEmpty(Request.QueryString["rid"]))
                {
                    int.TryParse(Request.QueryString["rid"].ToString(), out raID);
                    RiskAssessmentID = raID;
                }
                if (!string.IsNullOrEmpty(Request.QueryString["d"]))
                {
                    if (Request.QueryString["d"].ToString() == "1")
                    {
                        // NEW diversion enrollment
                        enrollmentUsage = EnrollmentUsageType.isNewDiversion;
                    }
                    else if (Request.QueryString["d"].ToString() == "0")
                    {
                        // NEW prevention enrollment
                        enrollmentUsage = EnrollmentUsageType.isNewPrevention;
                    }
                }
                else
                {
                    enrollmentUsage = EnrollmentUsageType.isEditExisting;
                }// ["d"]

                if (isRollOver)
                {
                    tempPersonId = personid;
                    //CustomValidator1.Enabled 
                }
                LoadLists();
                LoadPerson();
            }
            else
            {
                if (!string.IsNullOrEmpty(Request.QueryString["ro"]))
                {
                    int.TryParse(Request.QueryString["ro"].ToString(), out rolloverID);
                    int.TryParse(Request.QueryString["eid"].ToString(), out oldEnrollmentID);
                    OldEnrollmentID = oldEnrollmentID;
                    RolloverID = rolloverID;
                    isRollOver = true;
                    //this.reqValEnrollmentDate.Enabled = false;

                    if (!string.IsNullOrEmpty(Request.QueryString["id"]))
                    {
                        int.TryParse(Request.QueryString["id"].ToString(), out tempPersonId);
                        TempPersonID = tempPersonId;
                    }
                }
            }

        }

        private void LoadLists()
        {
            //races
            CheckBoxListRaces.DataSource = POD.Logic.LookUpTypesLogic.GetRaces();
            CheckBoxListRaces.DataBind();
            //ethnicities
            CheckBoxListEthnicity.DataSource = POD.Logic.LookUpTypesLogic.GetEthnicities();
            CheckBoxListEthnicity.DataBind();

            //gender
            RadioListGender.DataSource = POD.Logic.LookUpTypesLogic.GetGenders();
            RadioListGender.DataBind();

            //person relation 
            RadiobuttonListRelation2.DataSource = POD.Logic.ManageTypesLogic.GetTypesByType(POD.Data.TypesData.Types.PersonRelationshipType);
            RadiobuttonListRelation2.DataBind();

            RadiobuttonListRelation1.DataSource = POD.Logic.ManageTypesLogic.GetTypesByType(POD.Data.TypesData.Types.PersonRelationshipType);
            RadiobuttonListRelation1.DataBind();

            RadiobuttonListAuthorizedPersonRelationship.DataSource = POD.Logic.ManageTypesLogic.GetTransportationPersonRelationshipType();
            RadiobuttonListAuthorizedPersonRelationship.DataBind();



            RadComboBoxType.DataSource = POD.Logic.ManageTypesLogic.GetTypesByType(Data.TypesData.Types.EnrollmentType);



            //rcbnotecontacttype.DataSource = POD.Logic.ManageTypesLogic.GetTypesByType(Data.TypesData.Types.NoteContactType);

            RadComboBoxType.DataBind();

            //rcbnotecontacttype.DataBind();

            switch (enrollmentUsage)
            {
                case EnrollmentUsageType.isNewDiversion:
                    RadComboBoxItem diver = RadComboBoxType.Items.FindItemByText("Diversion Youth");
                    if (diver != null)
                    {
                        diver.Selected = true;
                        RadComboBoxType.Enabled = false;
                    }
                    break;

                case EnrollmentUsageType.isNewPrevention:
                    RadComboBoxItem prevention = RadComboBoxType.Items.FindItemByText("Prevention Youth");
                    if (prevention != null)
                    {
                        prevention.Selected = true;
                        RadComboBoxType.Enabled = false;
                        if ((Security.UserInRole("Administrators") || Security.UserInRole("CentralTeamUsers")
                                || Security.UserInRole("Administrators-NA") || Security.UserInRole("CentralTeamUsers-NA")))
                        {
                            LabelWrapAroundServices.Visible = true;
                            RadioButtonListWrapAroundServices.Visible = true;
                        }
                    }
                    break;

                case EnrollmentUsageType.isEditExisting:
                    RadComboBoxType.Enabled = false;
                    break;

            }  //switch



            IList<StatusType> statusTypeList = (IList<StatusType>)POD.Logic.ManageTypesLogic.GetTypesByType(Data.TypesData.Types.StatusType);

            //rollover assistance
            if (isRollOver)
            {
                statusTypeList = statusTypeList.Where(x => x.Category == "Enrollment" & x.Description.ToLower() == "rollover").ToList();
            }
            else
            {

                var doesInitPATExist = POD.Logic.PATFormLogic.DoesInitialPATExist(personid);


                if (!doesInitPATExist)
                {
                    statusTypeList = statusTypeList.Where(x => x.Category == "Enrollment" & x.Description.ToLower() == "rollover").ToList();
                }
                else
                {
                    statusTypeList = statusTypeList.Where(x => x.Category == "Enrollment" & x.Description.ToLower() != "rollover").ToList();
                }
                //need to check the status. If the status is rollover then I need to check to see if InitPAT is completed. Otherwise no other statuses


            }


            RadComboBoxStatus.DataSource = statusTypeList;
            RadComboBoxStatus.DataBind();

            if (Security.AuthorizeRoles("Administrators,CentralTeamUsers"))
            {
                if (IsRollOver)
                {
                    var currentEnrollment = POD.Logic.PersonRelatedLogic.GetEnrollmentByID(OldEnrollmentID);
                    LoadSiteList(currentEnrollment.SiteLocationID);
                }
                else
                {
                    var currentEnrollment = POD.Logic.PersonRelatedLogic.GetEnrollmentByID(EnrollmentID);
                    LoadSiteList();
                }

                LoadLocationList();
            }
            else
            {
                int siteid = 0;
                int.TryParse(Session["UsersSiteID"].ToString(), out siteid);
                LoadSiteList(siteid);
                LoadLocationList(siteid);
                RadComboBoxSites.Enabled = false;
            }
        }

        private void LoadPerson()
        {
            this.ParticipantAddress.SetValidation(true, "Save");
            this.AuthorizedCellPhone.PhoneTypeID = cellPhoneTypeID;
            this.AuthorizedHomePhone.PhoneTypeID = homephonetype;
            this.AuthorizedWorkPhone.PhoneTypeID = phoneTypeKey;
            this.AuthorizedCellPhone.SetValidation(false, "");
            this.AuthorizedHomePhone.SetValidation(false, "Save");
            this.AuthorizedWorkPhone.SetValidation(false, "");
            //this.DocPhone.PhoneTypeID = phoneTypeKey;
            //this.DocAddress.AddressTypeID = addressTypeid;
            this.GuardianHomePhone.SetValidation(false, "");
            this.GuardianWorkPhone.SetValidation(false, "");
            this.GuardianCellPhone.SetValidation(false, "");
            this.GuardianHomePhone.PhoneTypeID = homephonetype;
            this.GuardianCellPhone.PhoneTypeID = cellPhoneTypeID;
            this.GuardianWorkPhone.PhoneTypeID = phoneTypeKey;
            this.Guardian2HomePhone.SetValidation(false, "");
            this.Guardian2HomePhone.PhoneTypeID = homephonetype;
            this.Guardian2CellPhone.SetValidation(false, "");
            this.Guardian2CellPhone.PhoneTypeID = cellPhoneTypeID;
            this.Guardian2WorkPhone.SetValidation(false, "");
            this.Guardian2WorkPhone.PhoneTypeID = phoneTypeKey;

            //this.DocAddress.SetValidation(false, "");
            //this.DocPhone.SetValidation(false, "");
            this.AddEditAddressSchool.SetValidation(false, "");
            this.AddEditPhoneNumberSchool.SetValidation(false, "");
            this.AddEditPhoneNumberSchool.PhoneTypeID = 6;

            if (PersonID > 0)
            {
                Student currentPerson = POD.Logic.PeopleLogic.GetStudentAndRelatedInfoByID(PersonID);

                TransferClient.Attributes["onclick"] = "ShowTransfer('" + PersonID.ToString() + "');return false;";
                string enId = EnrollmentID != 0 ? EnrollmentID.ToString() : RiskAssessmentID.ToString();
                string tp = EnrollmentID != 0 ? "en" : "ra";
                //CertificateLink.Attributes["onclick"] = "DownLoadCertificate('" + PersonID.ToString() + "','" + enId + "','" + tp + "');return false;";

                LoadRegistrationTab(currentPerson);
                LoadTransportationTab(currentPerson);

                LoadMedicalTab(currentPerson);

                //skb changes for the enrollment notes - 03312020
                LoadNotesTab(currentPerson);

                //skb ROllover experiment 05/29/2017
                if (IsRollOver)
                {
                    PersonID = 0;
                }
            }
            //else
            //{
            //    this.EnrollmentIDTextBox.Visible = false;
            //    this.LabelEnrollmentID.Visible = false;
            //}
        }
        protected void Update_Click(object sender, EventArgs e)
        {
            var enrollment = POD.Logic.PersonRelatedLogic.GetEnrollmentByID(EnrollmentID);
            GeneratePDFdata(EnrollmentID, (DateTime)enrollment.RelDate, enrollment.RelReasonForLeaving, 0);


        }

        protected void Transfer_Click(object sender, EventArgs e)
        {
            var enrollment = POD.Logic.PersonRelatedLogic.GetEnrollmentByID(EnrollmentID);
            GeneratePDFdata(EnrollmentID, (DateTime)enrollment.RelDate, enrollment.RelReasonForLeaving, 0);


        }

        protected void Release_Click(object sender, EventArgs e)
        {
            var enrollment = POD.Logic.PersonRelatedLogic.GetEnrollmentByID(EnrollmentID);
            GeneratePDFdata(EnrollmentID, (DateTime)enrollment.RelDate, enrollment.RelReasonForLeaving, 0);


        }
        public static void GeneratePDFdata(int id, DateTime releasedate, string releasereason, int releasevalue)
        {


            try
            {
                var enrollment = POD.Logic.PersonRelatedLogic.GetEnrollmentByID(id);
                var person = POD.Logic.PeopleLogic.GetPersonByID(enrollment.PersonID);

                var studentInfo = POD.Logic.PeopleLogic.GetStudentAndRelatedInfoByID(enrollment.PersonID);
                var enrollmentDOC = POD.Logic.PeopleLogic.GetDoctorsByID(enrollment.PersonID);
                var siteInfo = LookUpTypesLogic.GetSiteByID((int)enrollment.SiteLocationID);
                var doesExitPATExist = POD.Logic.PATFormLogic.DoesExitPATExist(enrollment.PersonID);

                PersonForm exitPersonform;



                MemoryStream ms = new MemoryStream();

                string sTemplate = Path.Combine(HttpContext.Current.Request.PhysicalApplicationPath, @"App_Data\ydf_2022.pdf");

                PdfReader pdfReader = new PdfReader(sTemplate);
                PdfStamper pdfStamper = new PdfStamper(pdfReader, ms);

                PdfContentByte cb = pdfStamper.GetOverContent(1);
                AcroFields pdfFormFields = pdfStamper.AcroFields;

                var location = LookUpTypesLogic.GetLocationByID(enrollment.SiteLocationID.Value);

                //configure the fields
                pdfFormFields.SetField("site", location.Name);
                pdfFormFields.SetField("name", person.FirstName + " " + person.LastName);
                pdfFormFields.SetField("djjid", person.DJJIDNum != null ? person.DJJIDNum : "");
                pdfFormFields.SetField("disdate", releasedate.ToString("MM/dd/yyyy"));
                pdfFormFields.SetField("admitdate", Convert.ToDateTime(enrollment.DateApplied).ToString("MM/dd/yyyy"));
                //Exit PAT - ep

                if (doesExitPATExist)
                {
                    //get the date of the person form
                    exitPersonform = POD.Logic.PATFormLogic.GetExitPersonFormByPersonid(enrollment.PersonID);

                    pdfFormFields.SetField("exitdate", exitPersonform.DateCompleted != null ? Convert.ToDateTime(exitPersonform.DateCompleted).ToString("MM/dd/yyyy") : "");
                }
                else
                {
                    pdfFormFields.SetField("exitdate", "N/A");
                    pdfFormFields.SetField("ep3", "Yes");
                }



                //release reason - rr
                var result = releasevalue + 1;
                pdfFormFields.SetField("rr" + result, "Yes");

                //close up the platform
                pdfStamper.FormFlattening = true;
                if (pdfStamper != null)
                { pdfStamper.Close(); }

                pdfReader.Close();

                HttpContext.Current.Response.ContentType = "application/pdf";
                HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=" + person.FirstName.Substring(0, 1) + person.LastName + "_DJJID_" + person.DJJIDNum + "_" + releasedate.ToString("MM/dd/yyyy") + ".pdf");
                HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);

                HttpContext.Current.Response.BinaryWrite(ms.ToArray());
            }
            catch (Exception ex)
            {
                ex.Log();
                throw;
            }



        }

        private void LoadDateLabels(int personid, int? enrollmentid)
        {
            if (enrollmentid.HasValue)
            {
                Enrollments_Audit audit = POD.Logic.PersonRelatedLogic.GetEnrollmentAudit(enrollmentid.Value);
                if (audit != null)
                {
                    this.LabelCreated.Text = audit.DateTimeStamp.HasValue ? audit.DateTimeStamp.Value.ToShortDateString() : "N/A";
                    this.LabelEdited.Text = audit.AuditDateTime.HasValue ? audit.AuditDateTime.Value.ToShortDateString() : "N/A";
                }
                else
                {
                    Persons_Audit pAudit = POD.Logic.PeopleLogic.GetPersonAudit(PersonID);
                    if (pAudit != null)
                    {

                        this.LabelCreated.Text = pAudit.DateTimeStamp.HasValue ? pAudit.DateTimeStamp.Value.ToShortDateString() : "N/A";
                        this.LabelEdited.Text = pAudit.AuditDateTime.HasValue ? pAudit.AuditDateTime.Value.ToShortDateString() : "N/A";
                    }
                }
            }
            else
            {
                Persons_Audit pAudit = POD.Logic.PeopleLogic.GetPersonAudit(PersonID);
                if (pAudit != null)
                {

                    this.LabelCreated.Text = pAudit.DateTimeStamp.HasValue ? pAudit.DateTimeStamp.Value.ToShortDateString() : "N/A";
                    this.LabelEdited.Text = pAudit.AuditDateTime.HasValue ? pAudit.AuditDateTime.Value.ToShortDateString() : "N/A";
                }
            }

        }

        private void LoadRegistrationTab(Student currentPerson)
        {
            //grab enrollment by id or first
            DateTime? applyDate = null;
            List<Enrollment> personEnrollments = POD.Logic.PersonRelatedLogic.GetEnrollmentsByPersonID(currentPerson.PersonID);
            

            if (personEnrollments != null && personEnrollments.Count > 0)
            {
                Enrollment currentEnrollment = null;
                if (EnrollmentID != 0)
                {
                    currentEnrollment = personEnrollments.FirstOrDefault(en => en.EnrollmentID == EnrollmentID);
                    this.hfenrollmentId.Value = currentEnrollment.EnrollmentID.ToString();
                    this.hfpersonId.Value = currentEnrollment.PersonID.ToString();
                }
                //else
                //{
                //    this.EnrollmentIDTextBox.Visible = false;
                //    this.LabelEnrollmentID.Visible = false;
                //}

                if (currentEnrollment != null)
                {
                    if (PersonRelatedLogic.IsDateAHoliday() == true)
                    {
                        HyperLinkRelease.Visible = false;
                    }
                    else
                    {
                        HyperLinkRelease.Attributes["href"] = "#";
                        HyperLinkRelease.Attributes["onclick"] = "ShowRelease('" + PersonID.ToString() + "','" + currentEnrollment.EnrollmentID.ToString() + "');return false;";

  
                    }

                    LoadDateLabels(PersonID, currentEnrollment.EnrollmentID);
                    applyDate = currentEnrollment.DateApplied;
                    if (!isRollOver)
                    {
                        this.RadDatePickerEnrollmentDate.SelectedDate = currentEnrollment.DateApplied;
                    }

                    //PreWeb Date Admitted - skb 11022021
                    this.rdpprewebdateadmitted.SelectedDate = currentEnrollment.PreWebDateAdmitted;

                    this.LabelCreated.Text = currentEnrollment.DateApplied.HasValue ? currentEnrollment.DateApplied.Value.ToShortDateString() : string.Empty;
                    RadComboBoxItem enrollTypeItem = RadComboBoxType.Items.FindItemByValue(currentEnrollment.EnrollmentTypeID.ToString());
                    if (enrollTypeItem != null)
                    {
                        enrollTypeItem.Selected = true;
                        RadioButtonListWrapAroundServices.SelectedValue = currentEnrollment.isWrapAroundServices.ToString();

                        if ((currentEnrollment.EnrollmentTypeID == ManageTypesLogic.GetEnrollmentTypeIDByName("Prevention"))
                            && (Security.UserInRole("Administrators") || Security.UserInRole("CentralTeamUsers")
                            || Security.UserInRole("Administrators-NA") || Security.UserInRole("CentralTeamUsers-NA")))
                        {
                            LabelWrapAroundServices.Visible = true;
                            RadioButtonListWrapAroundServices.Visible = true;
                        }
                    }

                    RadComboBoxItem statusType = RadComboBoxStatus.Items.FindItemByValue(currentEnrollment.StatusTypeID.ToString());
                    if (statusType != null)
                    {
                        var doesInitPATExist = POD.Logic.PATFormLogic.DoesInitialPATExist(personid);

                        statusType.Selected = true;

                        RadComboBoxStatus.SelectedValue = statusType.Value;
                        if (statusType.Text != "Released" && doesInitPATExist)
                        {
                            int index = this.RadComboBoxStatus.FindItemIndexByText("Released");
                            RadComboBoxItem item = this.RadComboBoxStatus.FindItemByText("Released");
                            this.RadComboBoxStatus.Items.Remove(index);
                        }
                        else
                        {
                           
                            if(statusType.Text.ToUpper() == "RELEASED" || PersonRelatedLogic.IsDateAHoliday())
                            {
                                this.btndischargeform.Visible = true;
                                HyperLinkRelease.Visible = false;
                            }
                            
                        }
                       
                    }

                    if (currentEnrollment.SiteLocationID != null)
                    {
                        RadComboBoxItem selSiteItem = RadComboBoxSites.Items.FindItemByValue(currentEnrollment.SiteLocationID.ToString());
                        if (selSiteItem != null)
                        {
                            selSiteItem.Selected = true;
                        }
                    }
                    //if (currentEnrollment.LocationID != null)
                    //{
                    //    LoadLocationList(currentEnrollment.SiteLocationID);
                    //    RadComboBoxItem selLocItem = RadComboBoxLocations.Items.FindItemByValue(currentEnrollment.LocationID.ToString());
                    //    if (selLocItem != null)
                    //    {
                    //        selLocItem.Selected = true;
                    //    }
                    //}


                    if (currentEnrollment.RiskAssessmentID.HasValue)
                    {
                        //    RadComboBoxItem divItem = this.RadComboBoxType.FindItemByText("Diversion Youth");
                        //    if (divItem != null)
                        //    {
                        //        this.RadComboBoxType.Items.Remove(divItem.Index);
                        //    }
                        riskAssessmentURL = string.Format("~/Pages/RiskAssessmentPage.aspx?rid={0}", currentEnrollment.RiskAssessmentID.Value.ToString());
                    }
                    //else //hide risk assessment
                    //{
                    //    PanelYouthType.Visible = false;
                    //    //HyperLinkRiskAssessment.Visible = false;
                    //}

                }
                else
                {
                    LoadDateLabels(PersonID, null);
                    riskAssessmentURL = string.Format("~/Pages/RiskAssessmentPage.aspx?pid={0}", PersonID);
                    this.HyperLinkRelease.Enabled = false;
                }

                //this.HyperLinkRiskAssessment.NavigateUrl = riskAssessmentURL;
            }
            //else //no enrollment check risk assessment
            //{
            //    RiskAssessment personRiskAssessment = POD.Logic.PersonRelatedLogic.GetRiskAssessmentByPersonID(currentPerson.PersonID);
            //    if (personRiskAssessment != null)
            //    {
            //        //no diversion youth
            //        RadComboBoxItem divItem = this.RadComboBoxType.FindItemByText("Diversion Youth");
            //        if (divItem != null)
            //        {
            //            this.RadComboBoxType.Items.Remove(divItem.Index);
            //        }

            //        if (personRiskAssessment.LocationID != null)
            //        {
            //            LoadLocationList(personRiskAssessment.SiteLocationID);
            //            RadComboBoxItem selLocItem = RadComboBoxLocations.Items.FindItemByValue(personRiskAssessment.LocationID.ToString());
            //            if (selLocItem != null)
            //            {
            //                selLocItem.Selected = true;sta
            //            }
            //        }
            //    }
            //    else//diversion youth no risk assessment
            //    {
            //        PanelYouthType.Visible = false;
            //        //HyperLinkRiskAssessment.Visible = false;
            //    }

            //}
            if (currentPerson.DateOfBirth.HasValue)
            {
                this.RadNumericTextBoxAge.Text = POD.Logic.Utilities.GetAge(currentPerson.DateOfBirth.Value, applyDate).ToString();
            }

            if (currentPerson.isDJJYouth.HasValue)
            {
                if (currentPerson.isDJJYouth.Value)
                {
                    this.rbisdjjyouth.SelectedIndex = 0;


                    IList<StatusType> statusTypeList = (IList<StatusType>)POD.Logic.ManageTypesLogic.GetTypesByType(Data.TypesData.Types.StatusType);

                    //rollover assistance
                    if (isRollOver)
                    {
                        statusTypeList = statusTypeList.Where(x => x.Category == "Enrollment" & x.Description.ToLower() == "rollover").ToList();
                    }
                    else
                    {

                        var doesInitPATExist = POD.Logic.PATFormLogic.DoesInitialPATExist(personid);
                        var currEnrollment = POD.Logic.PersonRelatedLogic.GetEnrollmentByID(EnrollmentID);


                        if (!doesInitPATExist)
                        {

                            RadComboBoxItem statusType = RadComboBoxStatus.Items.FindItemByValue(currEnrollment.StatusTypeID.ToString());
                                                      
                           if(currEnrollment.StatusTypeID == 5)
                            {
                                statusTypeList = statusTypeList.Where(x => x.Category == "Enrollment" & x.Description.ToLower() == "rollover").ToList();

                            }
                            else
                            {
                                statusTypeList = statusTypeList.Where(x => x.Category == "Enrollment" & x.Description.ToLower() != "rollover").ToList();

                            }
                        }
                        else
                        {
                            statusTypeList = statusTypeList.Where(x => x.Category == "Enrollment" & x.Description.ToLower() != "rollover").ToList();
                        }
                        //need to check the status. If the status is rollover then I need to check to see if InitPAT is completed. Otherwise no other statuses


                    }


                    RadComboBoxStatus.DataSource = statusTypeList;
                    RadComboBoxStatus.DataBind();
                }
                else
                {
                    //HC Site Youth
                    this.rbisdjjyouth.SelectedIndex = 1;

                    IList<StatusType> statusTypeList = (IList<StatusType>)POD.Logic.ManageTypesLogic.GetTypesByType(Data.TypesData.Types.StatusType);
                    statusTypeList = statusTypeList.Where(x => x.Category == "Enrollment" & x.Description.ToLower() != "rollover").ToList();
                    RadComboBoxStatus.DataSource = statusTypeList;
                    RadComboBoxStatus.DataBind();

                    RadDatePickerEnrollmentDate.Enabled = true;
                }
            }

            //set ethnicity
            foreach (Ethnicity eth in currentPerson.Ethnicities)
            {
                System.Web.UI.WebControls.ListItem item = this.CheckBoxListEthnicity.Items.FindByValue(eth.EthnicityID.ToString());
                if (item != null)
                {
                    item.Selected = true;
                }
            }
            //set race
            foreach (Race rac in currentPerson.Races)
            {
                System.Web.UI.WebControls.ListItem item = this.CheckBoxListRaces.Items.FindByValue(rac.RaceID.ToString());
                if (item != null)
                {
                    item.Selected = true;
                }
            }
            if (currentPerson.GenderID.HasValue)
            {
                //set gender
                System.Web.UI.WebControls.ListItem gender = this.RadioListGender.Items.FindByValue(currentPerson.GenderID.Value.ToString());
                if (gender != null)
                {
                    gender.Selected = true;
                }
            }

            //if (currentPerson.ProgramEligibilityToolCompleted.HasValue)
            //{
            //    CheckboxProgramElibilityToolYes.Checked = (bool)currentPerson.ProgramEligibilityToolCompleted;
            //}

            //person related information
            this.EnrollmentLastNameTextBox.Text = currentPerson.LastName;
            if (!IsRollOver)
            {
                //this.EnrollmentIDTextBox.Enabled = false;
                this.EnrollmentIDTextBox.Text = currentPerson.DJJIDNum;
            }
            //else
            //{
            //    this.EnrollmentIDTextBox.Visible = false;
            //    this.LabelEnrollmentID.Visible = false;
            //}
            this.EnrollmentFirstNameTextBox.Text = currentPerson.FirstName;
            this.EnrollmentMITextBox.Text = currentPerson.MiddleName;
            //added the new Student ID attribute and last 4 of ssn
            this.EnrollmentSSNTextBox.Text = currentPerson.Last4SSN != null ? currentPerson.Last4SSN : "";
            this.EnrollmentStudentIDTextBox.Text = currentPerson.StudentID != null ? currentPerson.StudentID : "";
            this.RadDatePickerDOB.SelectedDate = currentPerson.DateOfBirth;
            this.EnrollmentLanguageTextBox.Text = currentPerson.PrimaryLanguageSpoken;
            //student related info
            //this.EnrollmentCaseEmergencyChilNameTextBox.Text = string.IsNullOrEmpty(currentPerson.MiddleName) 
            //? string.Format("{0} {1}", currentPerson.FirstName,
            //                currentPerson.LastName)
            //: string.Format("{0} {1} {2}", currentPerson.FirstName,
            //                currentPerson.MiddleName,
            //                currentPerson.LastName);
            System.Web.UI.WebControls.ListItem partProgram = this.RadiobuttonListProgramParticipation.Items.FindByValue(currentPerson.PartOtherProgSchool.HasValue ? currentPerson.PartOtherProgSchool.Value.ToString() : "No");

            if (partProgram != null)
            {

                if (partProgram.ToString().ToUpper() == "NO")
                {
                    partProgram.Selected = true;
                    this.EnrollmentGradeLevelValidator.Enabled = false;
                }
                else
                {
                    partProgram.Selected = true;
                    this.EnrollmentGradeLevelValidator.Enabled = true;
                }

            }



            //school
            if (currentPerson.SchoolAddressID.HasValue)
            {
                Address schoolAddress = POD.Logic.AddressPhoneNumerLogic.GetSchoolAddressPersonID(currentPerson.PersonID);
                if (schoolAddress != null)
                {
                    int schoolAddressType = POD.Logic.ManageTypesLogic.GetAddressTypeIDByName("school");
                    this.AddEditAddressSchool.ShowAddress(true);
                    this.AddEditAddressSchool.AddressID = schoolAddress.AddressID;
                    this.AddEditAddressSchool.AddressTypeID = schoolAddressType;
                    this.AddEditAddressSchool.LoadAddress(currentPerson.PersonID, schoolAddressType);
                }
            }
            this.EnrollmentCurrentSchoolTextBox.Text = currentPerson.SchoolAttending;
            this.EnrollmentGradeLevelTextBox.Text = currentPerson.GradeLevel;

            //release signatures
            if (currentPerson.SignatureRelease.HasValue)
            {
                if (currentPerson.SignatureRelease.Value)
                {
                    this.EnrollmentParentSignatureVerification1.SelectedIndex = 0;
                }
                else
                {
                    this.EnrollmentParentSignatureVerification1.SelectedIndex = 1;
                }
            }
            if (currentPerson.SignatureMedical.HasValue)
            {
                if (currentPerson.SignatureMedical.Value)
                {
                    this.EnrollmentParentSignatureVerification2.SelectedIndex = 0;
                }
                else
                {
                    this.EnrollmentParentSignatureVerification2.SelectedIndex = 1;
                }
            }


            this.EnrollmentParentSignatureDate1Picker.SelectedDate = currentPerson.SignatureReleaseDate;
            this.EnrollmentParentSigntureDate2Picker.SelectedDate = currentPerson.SignatureMedicalDate;


            //set address possibly mailing
            if (currentPerson.MailingAddress != null)
            {
                this.ParticipantAddress.ShowAddress(true);
                this.ParticipantAddress.AddressID = currentPerson.MailingAddress.AddressID;
                this.ParticipantAddress.AddressTypeID = addressTypeid;
                this.ParticipantAddress.LoadAddress(currentPerson.PersonID, addressTypeid);

            }

            if (!String.IsNullOrEmpty(currentPerson.YouthParentalStatus))
            {
                this.RadioButtonListRiskAssessmentYouthParentalStatus.SelectedValue = currentPerson.YouthParentalStatus;
            }

            if (String.IsNullOrEmpty(currentPerson.FamilyStatus))
            {
                currentPerson.FamilyStatus = String.Empty;
            }

            if (currentPerson.FamilyStatus.StartsWith("Other:"))
            {
                this.RadioButtonListRiskAssessmentFamilyStatus.SelectedValue = "Other";
                this.TextBoxFamilyStatusOther.Text = currentPerson.FamilyStatus.Substring(6);
            }
            else
            {
                this.RadioButtonListRiskAssessmentFamilyStatus.SelectedValue = currentPerson.FamilyStatus;
            }

            this.RadioButtonListRiskAssessmentReferral.SelectedValue = currentPerson.ReferredBy;
            if (!String.IsNullOrEmpty(currentPerson.ReferredBy) && currentPerson.ReferredBy.StartsWith("Other"))
            {
                this.RiskAssessmentReferralOtherTextBox.Text = currentPerson.ReferredByOther.Trim();
            }

            this.rblfoster.SelectedValue = currentPerson.isFosterCare.ToString();
            this.rbllunch.SelectedValue = currentPerson.IsLunchReduced.ToString();
            this.rblmedicaid.SelectedValue = currentPerson.IsMedicaid.ToString();

            IList<Person> relatedPeople = POD.Logic.PeopleLogic.GetGuardiansByID(currentPerson.PersonID);

            if (relatedPeople != null && relatedPeople.Count > 0)//first guardian
            {
                Person relatedPerson = relatedPeople.First();
                //phone
                this.GuardianHomePhone.LoadPhoneNumber(relatedPerson.PersonID, homephonetype);
                this.GuardianCellPhone.LoadPhoneNumber(relatedPerson.PersonID, cellPhoneTypeID);
                this.GuardianWorkPhone.LoadPhoneNumber(relatedPerson.PersonID, phoneTypeKey);

                this.EnrollmentParentLastNameTextBox.Text = relatedPerson.LastName;
                this.EnrollmentParent1FirstNameTextBox.Text = relatedPerson.FirstName;
                this.EnrollmentParent1MITextBox.Text = relatedPerson.MiddleName;
                this.EnrollmentParentEmail1TextBox.Text = relatedPerson.Email;
                System.Web.UI.WebControls.ListItem relatedItem = RadiobuttonListRelation1.Items.FindByText(relatedPerson.RelationshipTypeName);
                //this.EnrollmentParent1EmergencyContactCheckBox.Checked = Convert.ToBoolean(relatedPerson.IsER);
                this.EnrollmentParent1RelationshipOther.Text = relatedPerson.RelationshipOther;
                if (relatedItem != null)
                {
                    relatedItem.Selected = true;
                }

                if (relatedPeople != null && relatedPeople.Count > 1)//second guardian
                {
                    Person secRelatedPerson = relatedPeople.Skip(1).First();

                    this.EnrollmentParent2LastNameTextBox.Text = secRelatedPerson.LastName;
                    this.EnrollmentParent2FirstNameTextBox.Text = secRelatedPerson.FirstName;
                    this.EnrollmentParent2MITextBox.Text = secRelatedPerson.MiddleName;
                    this.EnrollmentParent2EmailTextBox.Text = secRelatedPerson.Email;

                    this.Guardian2HomePhone.LoadPhoneNumber(secRelatedPerson.PersonID, homephonetype);
                    this.Guardian2CellPhone.LoadPhoneNumber(secRelatedPerson.PersonID, cellPhoneTypeID);
                    this.Guardian2WorkPhone.LoadPhoneNumber(secRelatedPerson.PersonID, phoneTypeKey);

                    System.Web.UI.WebControls.ListItem relatedItem2 = RadiobuttonListRelation2.Items.FindByText(secRelatedPerson.RelationshipTypeName);
                    //this.EnrollmentParent2EmergencyContactCheckBox.Checked = false;
                    this.EnrollmentParent2RelationshipOther.Text = secRelatedPerson.RelationshipOther;
                    if (relatedItem2 != null)
                    {
                        relatedItem2.Selected = true;
                    }
                }

                this.AddEditPhoneNumberSchool.LoadPhoneNumber(PersonID, 6);
            }
        }

        private void LoadSiteList(int? siteid = null)
        {

            if (siteid != null && siteid > 0)
            {
                //check to see if the site is active? 
                var sites = POD.Logic.LookUpTypesLogic.GetSites().Where(x => x.SiteLocationID == siteid || x.LocationID == siteid);
                this.RadComboBoxSites.DataSource = sites.Count() > 1 ? sites : POD.Logic.LookUpTypesLogic.GetSites();
                this.RadComboBoxSites.DataBind();
            }
            else
            {
                this.RadComboBoxSites.DataSource = POD.Logic.LookUpTypesLogic.GetSites();
                this.RadComboBoxSites.DataBind();
            }


            this.RadComboBoxSites.Items.Insert(0, new RadComboBoxItem("All", "0"));
            if (siteid != null && siteid > 0)
            {
                var item = this.RadComboBoxSites.Items.FindItemByValue(siteid.ToString());
                if (item != null)
                {
                    item.Selected = true;
                }
            }
        }

        private void LoadLocationList(int? siteID = null)
        {
            //if (siteID != null && siteID > 0)
            //{
            //    this.RadComboBoxLocations.DataSource = POD.Logic.LookUpTypesLogic.GetLocations().Where(x => x.SiteLocationID == siteID || x.LocationID == siteID);
            //    this.RadComboBoxLocations.DataBind();
            //}
            //else
            //{
            //    this.RadComboBoxLocations.DataSource = POD.Logic.LookUpTypesLogic.GetLocations();
            //    this.RadComboBoxLocations.DataBind();
            //}
        }

        private void LoadTransportationTab(Student currentPerson)
        {
            //bind uathorized people
            EnrollmentPickUpAuthorizationList.Rebind();
            //set transportion needs
            foreach (System.Web.UI.WebControls.ListItem checkBoxTransportation in this.CheckBoxTransportationList.Items)
            {
                switch (checkBoxTransportation.Value)
                {
                    case "RideBusAlone":
                        checkBoxTransportation.Selected = currentPerson.RideBusAlone;
                        break;
                    case "SignInOut":
                        checkBoxTransportation.Selected = currentPerson.SignInOut;
                        break;
                    case "WalkHomeAlone":
                        checkBoxTransportation.Selected = currentPerson.WalkHomeAlone;
                        break;
                    case "RideBikeHomeAlone":
                        checkBoxTransportation.Selected = currentPerson.RideBikeHomeAlone;
                        break;
                    case "SignedInOutGuardOnly":
                        checkBoxTransportation.Selected = currentPerson.SignedInOutGuardOnly;
                        break;
                        //case "ReleaseOther":
                        //    checkBoxTransportation.Selected = currentPerson.ReleaseOther;
                        //    this.TextBoxOtherRelease.Text = currentPerson.ReleaseOtherText;
                        //    break;
                }
            }
            //set notes
            //EnrollmentFollowUpNotesTextBox.Text = currentPerson.Notes;


        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="currentPerson"></param>
        private void LoadNotesTab(Student currentPerson)
        {

        }

        private void LoadMedicalTab(Student currentPerson)
        {
            EnrollmentMedicalConditionsTextBox.Text = currentPerson.MedicalConditions;
            EnrollmentMedicationsTextBox.Text = currentPerson.Medications;
            EnrollmentSpecialNeedsTextBox.Text = currentPerson.MedicalSpecialNeeds;
            //EnrollmentPolicyNumberTextBox.Text = currentPerson.InsurancePolicyNum;
            //EnrollmentGroupNumberTextBox.Text = currentPerson.InsurancePolicyGroupNum;
            //EnrollmentInsuranceCompanyTextBox.Text = currentPerson.InsuranceCompany;

            if (currentPerson.liabilityconsent.HasValue)
            {
                if (currentPerson.liabilityconsent.Value)
                {
                    this.chkliability.Checked = true;
                }

            }

            if (currentPerson.grievanceconsent.HasValue)
            {
                if (currentPerson.grievanceconsent.Value)
                {
                    this.chkgrievanceconsent.Checked = true;
                }

            }

            if (currentPerson.emergencyconsent.HasValue)
            {
                if (currentPerson.emergencyconsent.Value)
                {
                    this.chkemergencyconsent.Checked = true;
                }

            }


            if (currentPerson.isAuthorizedStaffOk.HasValue)
            {
                if (currentPerson.isAuthorizedStaffOk.Value)
                {
                    this.rbauthorizedstaffok.SelectedIndex = 0;
                }
                else
                {
                    this.rbauthorizedstaffok.SelectedIndex = 1;
                }
            }

            if (currentPerson.isAssessmentOk.HasValue)
            {
                if (currentPerson.isAssessmentOk.Value)
                {
                    this.rbassessmentok.SelectedIndex = 0;
                }
                else
                {
                    this.rbassessmentok.SelectedIndex = 1;
                }
            }

            if (currentPerson.isMediaCaptureOk.HasValue)
            {
                if (currentPerson.isMediaCaptureOk.Value)
                {
                    this.rbmediacapture.SelectedIndex = 0;
                }
                else
                {
                    this.rbmediacapture.SelectedIndex = 1;
                }
            }
            //this.RadGridDoctors.Rebind();
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            Page.Validate("Save");
            if (Page.IsValid)
            {

                if (isRollOver)
                {

                    //skb - Rollover Experiement 60/19/2017
                    //add authorized user
                    AddAuthorizedPerson();
                    //add doctor
                    //AddDoctor();
                }

                //check if we find any matches based on name and dob
                //if (PersonID == 0 && FoundPersonMatches())//if so let user pick an option before save
                //{
                //    string personInfo = string.Empty;
                //    personInfo += this.EnrollmentFirstNameTextBox.Text.Trim() + "|";
                //    personInfo += this.EnrollmentLastNameTextBox.Text.Trim() + "|";
                //    personInfo += this.EnrollmentMITextBox.Text.Trim() + "|";
                //    if (this.RadDatePickerDOB.SelectedDate.HasValue)
                //    {
                //        personInfo += this.RadDatePickerDOB.SelectedDate.Value.ToShortDateString() + "|";
                //    }
                //    POD.MasterPages.Admin mtPage = (POD.MasterPages.Admin)this.Master;
                //    if (mtPage != null)
                //    {
                //        mtPage.ShowWindow(personInfo);
                //    }

                //}
                //else //else move on to the save
                //{
                    SavePerson();
                    Response.Redirect("~/Pages/Enrollments.aspx");
                //}
            }
        }

        private void SavePerson()
        {
            int statusid = 0;
            int.TryParse(this.RadComboBoxStatus.SelectedValue, out statusid);

            int? countyId = null;
            int? genderID = null;
            int Id = 0;
            if (this.RadioListGender.SelectedIndex != -1)
            {
                int.TryParse(this.RadioListGender.SelectedValue, out Id);
                if (Id != 0)
                {
                    genderID = Id;
                }
            }

            string youthParentalStatus = RadioButtonListRiskAssessmentYouthParentalStatus.SelectedItem.Value;

            string familyStatus = String.Empty;
            if (RadioButtonListRiskAssessmentFamilyStatus.SelectedItem.Value.Equals("Other"))
            {
                familyStatus = "Other:" + TextBoxFamilyStatusOther.Text;
            }
            else
            {
                familyStatus = RadioButtonListRiskAssessmentFamilyStatus.SelectedItem.Value;
            }

            string referredByOther = String.Empty;
            string referredByList = RadioButtonListRiskAssessmentReferral.SelectedValue;
            if (referredByList.StartsWith("Other"))
            {
                referredByOther = RiskAssessmentReferralOtherTextBox.Text.Trim();
            }

            bool rideBusAlone = false;
            bool signOut = false;
            bool walkHomeAlone = false;
            bool rideBikeAlone = false;
            bool signOuByGuardOnly = false;
            bool releaseOther = false;

            //<!-- New form fields for transportation on 2rd tab -->

            //<!-- -->

            //<!-- New form fields for consent on 3rd tab -->
            bool? isAssessmentok = null;
            bool? isMediaCaptureOk = null;
            bool? isAuthorizedStaffOk = null;
            bool? liabilityConsent = null;
            bool? grievanceConsent = null;
            bool? emergencyConsent = null;
            bool? isDJJYouth = null;

            bool tmpValue = false;
            if (chkgrievanceconsent.Checked)
            {
                grievanceConsent = true;
            }

            if (chkemergencyconsent.Checked)
            {
                emergencyConsent = true;
            }

            if (chkliability.Checked)
            {
                liabilityConsent = true;
            }

            if (this.rbisdjjyouth.SelectedIndex != -1)
            {
                bool.TryParse(this.rbisdjjyouth.SelectedValue, out tmpValue);
                isDJJYouth = tmpValue;
            }

            if (this.rbassessmentok.SelectedIndex != -1)
            {
                bool.TryParse(this.rbassessmentok.SelectedValue, out tmpValue);
                isAssessmentok = tmpValue;
            }

            if (this.rbmediacapture.SelectedIndex != -1)
            {
                bool.TryParse(this.rbmediacapture.SelectedValue, out tmpValue);
                isMediaCaptureOk = tmpValue;
            }

            if (this.rbauthorizedstaffok.SelectedIndex != -1)
            {
                bool.TryParse(this.rbauthorizedstaffok.SelectedValue, out tmpValue);
                isAuthorizedStaffOk = tmpValue;
            }
            //<!-- -->

            foreach (System.Web.UI.WebControls.ListItem transItem in CheckBoxTransportationList.Items)
            {
                if (transItem.Selected)
                {
                    switch (transItem.Value)
                    {
                        case "RideBusAlone":
                            rideBusAlone = true;
                            break;
                        case "SignInOut":
                            signOut = true;
                            break;
                        case "WalkHomeAlone":
                            walkHomeAlone = true;
                            break;
                        case "RideBikeHomeAlone":
                            rideBikeAlone = true;
                            break;
                        case "SignedInOutGuardOnly":
                            signOuByGuardOnly = true;
                            break;
                        case "ReleaseOther":
                            releaseOther = true;
                            break;
                    }
                }
            }

            bool? releaseSignature = null;
            bool? medReleaseSignature = null;
            bool? prodigyRelease = null;
            bool? grievanceRelease = null;
            bool value = false;
            if (this.EnrollmentParentSignatureVerification1.SelectedIndex != -1)
            {
                bool.TryParse(this.EnrollmentParentSignatureVerification1.SelectedValue, out value);
                releaseSignature = value;
            }
            if (this.EnrollmentParentSignatureVerification2.SelectedIndex != -1)
            {
                bool.TryParse(this.EnrollmentParentSignatureVerification2.SelectedValue, out value);
                medReleaseSignature = value;
            }





            int? locationID = null;
            int? siteLocationID = null;

            siteLocationID = int.Parse(RadComboBoxSites.SelectedValue);
            //if (locationID > 0)
            //{
            //    var location = LookUpTypesLogic.GetLocationByID(locationID.Value);
            //    if (location != null)
            //    {
            //        siteLocationID = location.IsSite ? location.LocationID : location.SiteLocationID;
            //    }
            //}

            bool? isLunchReduced = null;

            if (this.rbllunch.SelectedIndex != -1)
            {
                isLunchReduced = this.rbllunch.SelectedIndex == 1 ? false : true;
            }

            bool? isFoster = null;
            if (this.rblfoster.SelectedIndex != -1)
            {
                isFoster = this.rblfoster.SelectedIndex == 1 ? false : true;
            }




            bool? IsMedicaid = null;
            if (this.rblmedicaid.SelectedIndex != -1)
            {
                IsMedicaid = this.rblmedicaid.SelectedIndex == 1 ? false : true;
            }

            //bool programEligibiltyToolCompleted = CheckboxProgramElibilityToolYes.Checked;
            bool isWrapAroundServices;
            Boolean.TryParse(RadioButtonListWrapAroundServices.SelectedValue, out isWrapAroundServices);

            int studentTypeId = POD.Logic.ManageTypesLogic.GetPersonTypeIDByName("student");
            bool partProg = this.RadiobuttonListProgramParticipation.SelectedIndex != -1 ? bool.Parse(this.RadiobuttonListProgramParticipation.SelectedValue) : false;
            PersonID = POD.Logic.PeopleLogic.AddUpdateStudentInfo(PersonID, locationID, null, activeStatusID, countyId, this.EnrollmentIDTextBox.Text.Trim(), this.EnrollmentFirstNameTextBox.Text.Trim(), this.EnrollmentLastNameTextBox.Text.Trim(), this.EnrollmentMITextBox.Text.Trim(),
                                                      null, null, null, null, null, genderID, this.RadDatePickerDOB.SelectedDate, this.EnrollmentLanguageTextBox.Text.Trim(), null, string.Empty, this.EnrollmentCurrentSchoolTextBox.Text, this.EnrollmentGradeLevelTextBox.Text, partProg, studentTypeId, "", this.EnrollmentMedicationsTextBox.Text,
                                                        this.EnrollmentMedicalConditionsTextBox.Text, this.EnrollmentSpecialNeedsTextBox.Text.Trim(),
                                                        rideBusAlone, signOut, walkHomeAlone, rideBikeAlone, signOuByGuardOnly, null, releaseSignature, this.EnrollmentParentSignatureDate1Picker.SelectedDate, medReleaseSignature,
                                                        this.EnrollmentParentSigntureDate2Picker.SelectedDate, prodigyRelease, System.DateTime.Now, grievanceRelease, System.DateTime.Now, false,
                                                        youthParentalStatus, familyStatus, referredByList, referredByOther, this.EnrollmentStudentIDTextBox.Text.Trim(), this.EnrollmentSSNTextBox.Text.Trim(), isLunchReduced, isFoster, IsMedicaid, liabilityConsent, grievanceConsent, emergencyConsent, isAssessmentok, isMediaCaptureOk, isAuthorizedStaffOk, isDJJYouth);

            //enable transfer link
            TransferClient.Attributes["onclick"] = "ShowTransfer('" + PersonID.ToString() + "');return false;";
            //if (this.RadDatePickerEnrollmentDate.SelectedDate.HasValue || RolloverID == 1)
            //{
            int enrollTypeid = 0;
            DateTime? enrollmentDate = RolloverID == 1 ? null : (DateTime?)RadDatePickerEnrollmentDate.SelectedDate;


            //This is a test for HC YOUTH --skb 08102020
            if(!isDJJYouth.Value && RolloverID == 1 )
            {
                if(RadDatePickerEnrollmentDate.SelectedDate == null)
                {
                    enrollmentDate = Convert.ToDateTime(System.Configuration.ConfigurationManager.AppSettings["rolloverstartdate"].ToString());
                }
                else
                {
                    enrollmentDate = RadDatePickerEnrollmentDate.SelectedDate;
                }
                
            }

            DateTime? preWebDateAdmitted = (DateTime?)this.rdpprewebdateadmitted.SelectedDate;
           

            //if (!this.PanelYouthType.Visible)
            //{
            //    enrollTypeid = POD.Logic.ManageTypesLogic.GetEnrollmentTypeIDByName("diversion youth");
            //}
            //else
            //{
            int.TryParse(this.RadComboBoxType.SelectedValue, out enrollTypeid);
            //}
            int progId = 0;
            int.TryParse(Session["ProgramID"].ToString(), out progId);
            string recommendedBy = string.Empty;
            //if (this.RadioButtonListRecommendedBy.SelectedIndex != -1)
            //{
            //    recommendedBy = this.RadioButtonListRecommendedBy.SelectedValue;
            //    if (recommendedBy.StartsWith("Other"))
            //    {
            //        recommendedBy += ":" + this.TextBoxRecommendedByOther.Text;
            //    }
            //}
            //else if (!string.IsNullOrEmpty(this.TextBoxRecommendedByOther.Text))
            //{
            //    recommendedBy = "Other:" + this.TextBoxRecommendedByOther.Text;
            //}
            EnrollmentID = POD.Logic.PersonRelatedLogic.AddUpdateEnrollment(progId, EnrollmentID, siteLocationID, locationID, PersonID, enrollTypeid, statusid, enrollmentDate, recommendedBy, isWrapAroundServices, preWebDateAdmitted);
            if (EnrollmentID != 0)
            {
                if (!this.HyperLinkRelease.Enabled)
                {
                    HyperLinkRelease.Attributes["href"] = "#";
                    HyperLinkRelease.Attributes["onclick"] = "ShowRelease('" + PersonID.ToString() + "','" + EnrollmentID.ToString() + "');return false;";
                    this.HyperLinkRelease.Enabled = true;
                }
                string enId = EnrollmentID != 0 ? EnrollmentID.ToString() : RiskAssessmentID.ToString();
                string tp = EnrollmentID != 0 ? "en" : "ra";
                //CertificateLink.Attributes["onclick"] = "DownLoadCertificate('" + PersonID.ToString() + "','" + enId + "','" + tp + "');return false;";

                //riskAssessmentURL = string.Format("~/Pages/RiskAssessmentPage.aspx?pid={0}&eid={1}", PersonID, EnrollmentID);
                //this.HyperLinkRiskAssessment.NavigateUrl = riskAssessmentURL;

                if (RiskAssessmentID != 0)//in case this is a new enrollment and we have a riskassessment id
                {
                    POD.Logic.PersonRelatedLogic.UpdateEnrollment(EnrollmentID, RiskAssessmentID);
                }
                else
                {
                    PanelYouthType.Visible = false;
                    //this.HyperLinkRiskAssessment.Visible = false;
                }
            }
            // }

            List<int> ethnicityList = new List<int>();
            foreach (System.Web.UI.WebControls.ListItem item in CheckBoxListEthnicity.Items)
            {
                if (item.Selected == true)
                {
                    ethnicityList.Add(int.Parse(item.Value));
                }
            }
            if (ethnicityList.Count > 0)
            {
                POD.Logic.PeopleLogic.AddEthnicityToPerson(PersonID, ethnicityList);
            }

            List<int> raceList = new List<int>();
            foreach (System.Web.UI.WebControls.ListItem item in CheckBoxListRaces.Items)
            {
                if (item.Selected == true)
                {
                    raceList.Add(int.Parse(item.Value));
                }
            }
            if (raceList.Count > 0)
            {
                POD.Logic.PeopleLogic.AddRacesToPerson(PersonID, raceList);
            }
            //school address
            int schoolAddressType = POD.Logic.ManageTypesLogic.GetAddressTypeIDByName("school");
            Address schoolAddress = POD.Logic.AddressPhoneNumerLogic.GetSchoolAddressPersonID(PersonID);
            
            this.AddEditAddressSchool.AddressTypeID = schoolAddressType;
            if (schoolAddress != null)
            {
                this.AddEditAddressSchool.AddressID = schoolAddress.AddressID;
            }
            this.AddEditAddressSchool.SaveAndAssignSchoolAddress(PersonID);

            this.AddEditPhoneNumberSchool.PhoneTypeID = 6;
            PhoneNumber schoolPhone = POD.Logic.AddressPhoneNumerLogic.GetPhoneNumberByTypeAndPersonID(this.AddEditPhoneNumberSchool.PhoneTypeID, PersonID);

           
            if (AddEditPhoneNumberSchool.HasPhoneNumber())
            {
                if(schoolPhone != null) { 
                    this.AddEditPhoneNumberSchool.PhoneID = schoolPhone.PhoneNumberID;
                }
                

                this.AddEditPhoneNumberSchool.SaveAndAssignPhone(PersonID);
            }
            

            //main address 
            int addressTypeId = POD.Logic.ManageTypesLogic.GetAddressTypeIDByName("mailing");
            Address primAddress = POD.Logic.AddressPhoneNumerLogic.GetAddressByTypeAndPersonID(addressTypeId, PersonID);
            this.ParticipantAddress.AddressTypeID = addressTypeId;
            if (primAddress != null)
            {
                this.ParticipantAddress.AddressID = primAddress.AddressID;
            }
            this.ParticipantAddress.SaveAndAssignAddress(PersonID);

            IList<Person> relatedPeople = POD.Logic.PeopleLogic.GetGuardiansByID(PersonID);
            if (!string.IsNullOrEmpty(this.EnrollmentParent1FirstNameTextBox.Text) && !string.IsNullOrEmpty(this.EnrollmentParentLastNameTextBox.Text.Trim()))
            {
                int relationType = 0;
                int.TryParse(this.RadiobuttonListRelation1.SelectedValue, out relationType);
                 //test
                Person relatedPerson = null;
                int? pid = null;
                if (relatedPeople.Count > 0)
                {
                    relatedPerson = relatedPeople.First();
                    pid = relatedPerson.PersonID;
                }
                //add update person record
                relatedPerson = POD.Logic.PeopleLogic.AddUpdatePerson(pid, this.EnrollmentParent1FirstNameTextBox.Text.Trim(), this.EnrollmentParentLastNameTextBox.Text.Trim()
                                                          , this.EnrollmentParent1MITextBox.Text.Trim(), this.EnrollmentParentEmail1TextBox.Text.Trim());

                //handle phone numbers
                if (relatedPerson != null)//f person was found or created try adding numbers
                {
                    if (relationType != 0)
                    {
                        //add relationship

                        POD.Logic.PeopleLogic.AddGuardianRelationShip(PersonID, relatedPerson.PersonID, relationType, EnrollmentParent1RelationshipOther.Text, false); //skb relationship default
                    }
                    if (relatedPerson.HomePhone != null)
                    {
                        this.GuardianHomePhone.PhoneID = relatedPerson.HomePhone.PhoneNumberID;
                    }
                    if (relatedPerson.WorkPhone != null)
                    {
                        this.GuardianWorkPhone.PhoneID = relatedPerson.WorkPhone.PhoneNumberID;
                    }
                    if (relatedPerson.CellPhone != null)
                    {
                        this.GuardianCellPhone.PhoneID = relatedPerson.CellPhone.PhoneNumberID;
                    }
                    this.GuardianHomePhone.PhoneTypeID = homephonetype;
                    this.GuardianCellPhone.PhoneTypeID = cellPhoneTypeID;
                    this.GuardianWorkPhone.PhoneTypeID = phoneTypeKey;

                    this.GuardianHomePhone.SaveAndAssignPhone(relatedPerson.PersonID);
                    this.GuardianCellPhone.SaveAndAssignPhone(relatedPerson.PersonID);
                    this.GuardianWorkPhone.SaveAndAssignPhone(relatedPerson.PersonID);

                }
            }
            else
            {

                Person relatedPerson = null;
                int? pid = null;
                if (relatedPeople.Count > 0)
                {
                    relatedPerson = relatedPeople.First();
                    pid = relatedPerson.PersonID;

                    POD.Logic.PeopleLogic.DeleteGuardianRelationShip((int)pid);
                }


            }



            if (!string.IsNullOrEmpty(this.EnrollmentParent2FirstNameTextBox.Text.Trim()) && !string.IsNullOrEmpty(this.EnrollmentParent2LastNameTextBox.Text.Trim()))
            { //TODO: handle if other was checked
                int relationType = 0;
                int.TryParse(this.RadiobuttonListRelation2.SelectedValue, out relationType);

                Person relatedPerson = null;
                int? pid = null;
                if (relatedPeople.Count > 1)
                {
                    relatedPerson = relatedPeople.Skip(1).First();
                    pid = relatedPerson.PersonID;
                }

                //add update person record
                relatedPerson = POD.Logic.PeopleLogic.AddUpdatePerson(pid, this.EnrollmentParent2FirstNameTextBox.Text.Trim(), this.EnrollmentParent2LastNameTextBox.Text.Trim()
                                                          , this.EnrollmentParent2MITextBox.Text.Trim(), this.EnrollmentParent2EmailTextBox.Text.Trim());

                if (relatedPerson != null)
                {
                    if (relationType != 0)
                    {
                        //add relationship
                        POD.Logic.PeopleLogic.AddGuardianRelationShip(PersonID, relatedPerson.PersonID, relationType, EnrollmentParent2RelationshipOther.Text, false);
                    }

                    if (relatedPerson.HomePhone != null)
                    {
                        this.Guardian2HomePhone.PhoneID = relatedPerson.HomePhone.PhoneNumberID;
                    }
                    if (relatedPerson.WorkPhone != null)
                    {
                        this.Guardian2WorkPhone.PhoneID = relatedPerson.WorkPhone.PhoneNumberID;
                    }
                    if (relatedPerson.CellPhone != null)
                    {
                        this.Guardian2CellPhone.PhoneID = relatedPerson.CellPhone.PhoneNumberID;
                    }
                    this.Guardian2HomePhone.PhoneTypeID = homephonetype;
                    this.Guardian2CellPhone.PhoneTypeID = cellPhoneTypeID;
                    this.Guardian2WorkPhone.PhoneTypeID = phoneTypeKey;

                    this.Guardian2HomePhone.SaveAndAssignPhone(relatedPerson.PersonID);
                    this.Guardian2CellPhone.SaveAndAssignPhone(relatedPerson.PersonID);
                    this.Guardian2WorkPhone.SaveAndAssignPhone(relatedPerson.PersonID);
                }
            }
            else
            {

                Person relatedPerson = null;
                int? pid = null;
                if (relatedPeople.Count > 1)
                {
                    relatedPerson = relatedPeople.Skip(1).First();
                    pid = relatedPerson.PersonID;

                    POD.Logic.PeopleLogic.DeleteGuardianRelationShip((int)pid);
                }

                
            }
        }

        private bool FoundPersonMatches()
        {
            bool hasMatches = false;

            int count = POD.Logic.PeopleLogic.GetPeopleByNameMatchCount(this.EnrollmentFirstNameTextBox.Text.Trim(), this.EnrollmentLastNameTextBox.Text.Trim(), this.RadDatePickerDOB.SelectedDate);
            if (count != 0)
            {
                hasMatches = true;
            }
            return hasMatches;
        }

        public void SavePersonMatch(int personid)
        {
            PersonID = personid;
            SavePerson();
        }


        /// <summary>
        /// at least 1 emergency contact must be entered
        /// </summary>
        /// <param name="source"></param>
        /// <param name="args"></param>
        protected void CustomValidatorERPeopleAssigned_ServerValidate(object source, ServerValidateEventArgs args)
        {
            //args.IsValid = false;

            //IList<Person> erPeople = POD.Logic.PeopleLogic.GetEmergencyContactsByID(PersonID);
            //if (erPeople != null && erPeople.Count > 0
            //    || EnrollmentParent1EmergencyContactCheckBox.Checked
            //    || EnrollmentParent2EmergencyContactCheckBox.Checked)
            //{
            args.IsValid = true;
            //}
        }

        /// <summary>
        /// at least 1 emergency contact must be entered
        /// </summary>
        /// <param name="source"></param>
        /// <param name="args"></param>
        protected void SSN_StudentID_ServerValidate(object source, ServerValidateEventArgs args)
        {

            args.IsValid = EnrollmentSSNTextBox.Text.Trim().Length > 0 || EnrollmentStudentIDTextBox.Text.Trim().Length > 0;
            //args.IsValid = false;

            //IList<Person> erPeople = POD.Logic.PeopleLogic.GetEmergencyContactsByID(PersonID);
            //if (erPeople != null && erPeople.Count > 0
            //    || EnrollmentParent1EmergencyContactCheckBox.Checked
            //    || EnrollmentParent2EmergencyContactCheckBox.Checked)
            //{
            //    args.IsValid = true;
            //}
        }

        /// <summary>
        /// at least 1 number must be entered
        /// </summary>
        /// <param name="source"></param>
        /// <param name="args"></param>
        protected void CustomParentPhone_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = false;
            if (this.GuardianHomePhone.HasPhoneNumber() || this.GuardianWorkPhone.HasPhoneNumber() || this.GuardianCellPhone.HasPhoneNumber())
            {
                args.IsValid = true;
            }

            return;
        }

        /// <summary>
        /// if first and last name was entered
        /// then we must have a phone number
        /// </summary>
        /// <param name="source"></param>
        /// <param name="args"></param>
        protected void CustomValidatorParent2Phone_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = false;
            if (string.IsNullOrEmpty(this.EnrollmentParent2FirstNameTextBox.Text) && string.IsNullOrEmpty(this.EnrollmentParent2LastNameTextBox.Text))
            {
                args.IsValid = true;
                return;
            }
            if (this.Guardian2HomePhone.HasPhoneNumber() || this.Guardian2WorkPhone.HasPhoneNumber() || this.Guardian2CellPhone.HasPhoneNumber())
            {
                args.IsValid = true;
            }

            return;
        }

        /// <summary>
        /// if 2nd guardian is selected than make relationship required
        /// </summary>
        /// <param name="source"></param>
        /// <param name="args"></param>
        protected void CustomValidatorParent2Relationship_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = false;
            if (string.IsNullOrEmpty(this.EnrollmentParent2FirstNameTextBox.Text) && string.IsNullOrEmpty(this.EnrollmentParent2LastNameTextBox.Text))
            {
                args.IsValid = true;
                return;
            }
            if (this.RadiobuttonListRelation2.SelectedIndex != -1)
            {
                args.IsValid = true;
            }

            return;
        }

        #region Authorized People Add/ Delete
        protected void customvalidatorRelationship_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = true;
            if (this.RadiobuttonListAuthorizedPersonRelationship.SelectedIndex == -1 && string.IsNullOrEmpty(this.TextBoxOtherRelationship.Text))
            {
                args.IsValid = false;
            }
        }

        protected void EnrollmentPickUpAuthorizationList_NeedsDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            this.EnrollmentPickUpAuthorizationList.DataSource = POD.Logic.PeopleLogic.GetAuthorizedPeopleByID(PersonID);
        }

        protected void Enrollmentnotes_NeedsDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            var notes = POD.Logic.PersonRelatedLogic.GetEnrollmentNotesByEnrollmentID(EnrollmentID);
            var types = (RadGrid)sender;
            types.DataSource = POD.Logic.PersonRelatedLogic.GetEnrollmentNotesByEnrollmentID(enrollID);
        }

        protected void NotesGrid_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridEditFormItem && e.Item.IsInEditMode)
            {
                var editItem = (GridEditFormItem)e.Item;

                if (editItem != null)
                {
                    IList<NoteContactType> contactTypeList = null;

                    contactTypeList = (List<Data.Entities.NoteContactType>)POD.Logic.ManageTypesLogic.GetTypesByType(Data.TypesData.Types.NoteContactType);

                    if (editItem.DataItem is GridInsertionObject)
                    {
                        //var validator = (RequiredFieldValidator)editItem.FindControl("RequiredFieldValidatorStatusCategory");
                        //validator.Enabled = true;

                        var contactTypeDropdown = (RadComboBox)editItem.FindControl("rcbnotecontacttype");

                        if (contactTypeDropdown != null)
                        {
                            contactTypeDropdown.DataSource = contactTypeList;
                            contactTypeDropdown.DataBind();
                        }
                    }
                    else
                    {
                        var note = POD.Logic.Utilities.GetValueFromAnonymousType<string>(editItem.DataItem, "Note");
                        var followup = POD.Logic.Utilities.GetValueFromAnonymousType<string>(editItem.DataItem, "Followup");

                        var contactPerson = POD.Logic.Utilities.GetValueFromAnonymousType<string>(editItem.DataItem, "ContactPerson");
                        var contactPersonBox = (TextBox)editItem.FindControl("txtnotecontactperson");
                        var contactTypeDropdown = (RadComboBox)editItem.FindControl("rcbnotecontacttype");
                        //var noteBox = (TextBox)editItem.FindControl("txtenrollmentnote");
                        var enrollnotebox = (RadEditor)editItem.FindControl("reenrollmentnote");
                        var enrollfollowupbox = (RadEditor)editItem.FindControl("reenrollmentfollowup");
                        
                        //var followupBox = (TextBox)editItem.FindControl("txtenrollmentfollowup");

                        if (contactTypeDropdown != null)
                        {
                            contactTypeDropdown.DataSource = contactTypeList;
                            contactTypeDropdown.DataBind();
                        }

                        if (contactPersonBox != null)
                        {
                            contactPersonBox.Text = contactPerson;
                        }

                        //if (noteBox != null)
                        //{
                        //    noteBox.Text = note;
                        //}

                        if (enrollnotebox != null)
                        {
                            enrollnotebox.Content = note;
                        }

                        if (enrollfollowupbox != null)
                        {
                            enrollfollowupbox.Content = followup;
                        }
                        

                        //if (followupBox != null)
                        //{
                        //    followupBox.Text = followup;
                        //}

                    }
                }
            }
            else
            {
                if (e.Item is GridDataItem)
                {
                    var editItem = (GridDataItem)e.Item;

                    
                        GridDataItem item = e.Item as GridDataItem;
                        if (item["Note"].Text.Length > 120)
                        {
                            item["Note"].Text = item["Note"].Text.Substring(0, 120) ;
                    }

                    if (item["followup"].Text.Length > 120)
                    {
                        item["followup"].Text = item["followup"].Text.Substring(0, 120)  ;
                    }

                    if (item["followupfull"].Text.Length > 120)
                    {
                        item["followup"].Text = item["followup"].Text;
                    }

                }

            }




            if (e.Item.ItemType == GridItemType.Item || e.Item.ItemType == GridItemType.AlternatingItem)
            {
                //if not admin then no editing/deleting or adding new classess
                if (!Security.UserInRole("Administrators") && !Security.UserInRole("CentralTeamUsers") && !Security.UserInRole("SiteTeamUsers"))
                {
                    e.Item.OwnerTableView.Columns.FindByUniqueName("DeleteColumn").Visible = false;
                }
            }
        }

        protected void notesgrid_InsertCommand(object sender, GridCommandEventArgs e)
        {
            if (e.Item is GridEditFormItem && e.Item.IsInEditMode)
            {
                GridEditFormItem editItem = (GridEditFormItem)e.Item;

                int enrollmentNoteID = 0;
                var newValues = new Hashtable();
                e.Item.OwnerTableView.ExtractValuesFromItem(newValues, editItem);

                var contactPersonBox = (TextBox)editItem.FindControl("txtnotecontactperson");
                var contactTypeDropdown = (RadComboBox)editItem.FindControl("rcbnotecontacttype");
                //var noteBox = (TextBox)editItem.FindControl("txtenrollmentnote");
                var enrollnotebox = (RadEditor)editItem.FindControl("reenrollmentnote");
                var enrollfollowupbox = (RadEditor)editItem.FindControl("reenrollmentfollowup");
                //var followupBox = (TextBox)editItem.FindControl("txtenrollmentfollowup");
                int noteContactTypeValue = 0;
                string selectContactType = string.Empty;

                int.TryParse(contactTypeDropdown.SelectedValue, out noteContactTypeValue);

                if (contactTypeDropdown != null)
                {
                    selectContactType = contactTypeDropdown.SelectedValue;
                }

                var result = POD.Logic.PersonRelatedLogic.AddUpdateEnrollmentNoteById(enrollmentNoteID, noteContactTypeValue, EnrollmentID, enrollfollowupbox.Content, enrollnotebox.Content, string.Empty, DateTime.Now, contactPersonBox.Text);


            }
        }

        protected void notesgrid_UpdateCommand(object sender, GridCommandEventArgs e)
        {
            if (e.Item is GridEditFormItem && e.Item.IsInEditMode)
            {
                GridEditFormItem editItem = (GridEditFormItem)e.Item;

                string enrollmentNoteID = editItem.GetDataKeyValue("EnrollmentNoteId").ToString();
                var newValues = new Hashtable();
                e.Item.OwnerTableView.ExtractValuesFromItem(newValues, editItem);

                var contactPersonBox = (TextBox)editItem.FindControl("txtnotecontactperson");
                var contactTypeDropdown = (RadComboBox)editItem.FindControl("rcbnotecontacttype");
                //var noteBox = (TextBox)editItem.FindControl("txtenrollmentnote");
                var enrollnotebox = (RadEditor)editItem.FindControl("reenrollmentnote");
                var enrollfollowupbox = (RadEditor)editItem.FindControl("reenrollmentfollowup");
                //var followupBox = (TextBox)editItem.FindControl("txtenrollmentfollowup");
                int noteContactTypeValue = 0;
                string selectContactType = string.Empty;

                int.TryParse(contactTypeDropdown.SelectedValue, out noteContactTypeValue);

                if (contactTypeDropdown != null)
                {
                    selectContactType = contactTypeDropdown.SelectedValue;
                }

                var currentEnrollmentID = 0;
                int.TryParse(enrollmentNoteID, out currentEnrollmentID);
                var result = POD.Logic.PersonRelatedLogic.AddUpdateEnrollmentNoteById(currentEnrollmentID, noteContactTypeValue, EnrollmentID, enrollfollowupbox.Content, enrollnotebox.Content, string.Empty, DateTime.Now, contactPersonBox.Text);


            }
        }

        protected void NotesGrid_DeleteCommand(object sender, GridCommandEventArgs e)
        {
            string enrollmentNoteId = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["EnrollmentNoteId"].ToString();
            if (!string.IsNullOrEmpty(enrollmentNoteId))
            {
                POD.Logic.PeopleLogic.DeleteEnrollmentNote(Convert.ToInt32(enrollmentNoteId));
                //notesgrid.Rebind();
                // this.notesgrid.Rebind();
            }
        }


        protected void EnrollmentPickUpAuthorizationList_DeleteCommand(object sender, GridCommandEventArgs e)
        {
            string authorizedPersonID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PersonID"].ToString();
            if (!string.IsNullOrEmpty(authorizedPersonID))
            {
                POD.Logic.PeopleLogic.DeleteContacts(PersonID, int.Parse(authorizedPersonID), "AU");
                EnrollmentPickUpAuthorizationList.Rebind();
            }
        }

        protected void EnrollmentPickUpAuthorizationAdd_Click(object sender, EventArgs e)
        {
            AddAuthorizedPerson();
        }

        protected void EnrollmentNotesAdd_Click(object sender, EventArgs e)
        {
            AddEnrollmentNote();
        }

        private void AddEnrollmentNote()
        {
            //try
            //{
            //    string contactPerson = this.txtnotecontactperson.Text;
            //    string enrollmentNote = this.txtenrollmentnote.Text;
            //    string followupNote = this.txtenrollmentfollowup.Text;

            //    int enrollmentNoteContactType = Convert.ToInt32(rcbnotecontacttype.SelectedItem.Value);

            //    var result = POD.Logic.PersonRelatedLogic.AddUpdateEnrollmentNoteById(0, enrollmentNoteContactType, EnrollmentID, followupNote, enrollmentNote, string.Empty, DateTime.Now, contactPerson);
            //}
            //catch (Exception ex)
            //{
            //    ex.Log();

            //}

            ////clear add screen
            //this.txtnotecontactperson.Text = string.Empty;
            //this.txtenrollmentnote.Text = string.Empty;
            //this.txtenrollmentfollowup.Text = string.Empty;
            //this.rcbnotecontacttype.ClearSelection();

            ////refresh grid
            //this.notesgrid.Rebind();
        }

        protected void PickupGrid_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item.ItemType == GridItemType.Item || e.Item.ItemType == GridItemType.AlternatingItem)
            {
                //if not admin then no editing/deleting or adding new classess
                if (!Security.UserInRole("Administrators") && !Security.UserInRole("CentralTeamUsers") && !Security.UserInRole("SiteTeamUsers"))
                {
                    e.Item.OwnerTableView.Columns.FindByUniqueName("DeleteColumn").Visible = false;
                }
            }
        }

        private void AddAuthorizedPerson()
        {
            try
            {
                if (PersonID == 0)
                {
                    SavePerson();
                }

                IEnumerable<Person> authorizedPeople;
                Person authorizedPerson;
                string firstName = this.EnrollmentPickUpAuthorizationFirstNameTextBox.Text;
                string lastName = this.EnrollmentPickUpAuthorizationLastNameTextBox.Text;


                if (isRollOver)
                {

                    authorizedPeople = POD.Logic.PeopleLogic.GetAuthorizedWithoutGuardiansToPickupPeopleByID(tempPersonId);

                    foreach (var p in authorizedPeople)
                    {
                        int tmpRelationshipTypeId = POD.Logic.ManageTypesLogic.GetPersonRelationshipTypeIDByName(p.RelationshipTypeName);
                        //POD.Logic.PeopleLogic.AddUpdatePerson(null, p.FirstName, p.LastName, string.Empty, string.Empty);
                        //add relationship
                        POD.Logic.PeopleLogic.AddPersonRelationShip(PersonID, p.PersonID, tmpRelationshipTypeId, p.RelationshipTypeName, false, p.IsER.ToUpper().Trim() == "YES" ? true : false, true, false);
                        ////add phone numbers
                        //this.AuthorizedCellPhone.PhoneTypeID = cellPhoneTypeID;
                        //this.AuthorizedCellPhone.SaveAndAssignPhone(p.PersonID);

                        //this.AuthorizedHomePhone.PhoneTypeID = homephonetype;
                        //this.AuthorizedHomePhone.SaveAndAssignPhone(p.PersonID);

                        //this.AuthorizedWorkPhone.PhoneTypeID = phoneTypeKey;
                        //this.AuthorizedWorkPhone.SaveAndAssignPhone(p.PersonID);
                    }
                }
                else
                {
                    int relationshipTypeId = POD.Logic.ManageTypesLogic.GetPersonRelationshipTypeIDByName("other");
                    authorizedPeople = POD.Logic.PeopleLogic.GetAuthorizedPeopleByID(PersonID);
                    authorizedPerson = authorizedPeople.FirstOrDefault(p => p.FirstName.ToLower().Contains(firstName) && p.LastName.ToLower().Contains(lastName));

                    if (this.RadiobuttonListAuthorizedPersonRelationship.SelectedIndex != -1)
                    {
                        int.TryParse(this.RadiobuttonListAuthorizedPersonRelationship.SelectedValue, out relationshipTypeId);
                    }

                    int authorizedPersonID = -1;
                    if (authorizedPerson != null)
                    {
                        authorizedPersonID = authorizedPerson.PersonID;
                    }
                    else
                    {
                        authorizedPerson = POD.Logic.PeopleLogic.AddUpdatePerson(null, firstName, lastName, string.Empty, string.Empty);

                    }
                    if (authorizedPerson != null)
                    {
                        //add relationship
                        POD.Logic.PeopleLogic.AddPersonRelationShip(PersonID, authorizedPerson.PersonID, relationshipTypeId, this.TextBoxOtherRelationship.Text, false, this.CheckBoxER.Checked, true, false);
                        //add phone numbers
                        this.AuthorizedCellPhone.PhoneTypeID = cellPhoneTypeID;
                        this.AuthorizedCellPhone.SaveAndAssignPhone(authorizedPerson.PersonID);

                        this.AuthorizedHomePhone.PhoneTypeID = homephonetype;
                        this.AuthorizedHomePhone.SaveAndAssignPhone(authorizedPerson.PersonID);

                        this.AuthorizedWorkPhone.PhoneTypeID = phoneTypeKey;
                        this.AuthorizedWorkPhone.SaveAndAssignPhone(authorizedPerson.PersonID);
                    }

                }








            }
            catch (Exception ex)
            {
                ex.Log();
            }
            //clear add screen
            this.EnrollmentPickUpAuthorizationFirstNameTextBox.Text = string.Empty;
            this.EnrollmentPickUpAuthorizationLastNameTextBox.Text = string.Empty;
            this.TextBoxOtherRelationship.Text = string.Empty;
            this.CheckBoxER.Checked = false;
            this.RadiobuttonListAuthorizedPersonRelationship.ClearSelection();
            this.AuthorizedCellPhone.ClearPhoneNumber();
            this.AuthorizedHomePhone.ClearPhoneNumber();
            this.AuthorizedWorkPhone.ClearPhoneNumber();
            //refresh grid
            this.EnrollmentPickUpAuthorizationList.Rebind();
        }
        /// <summary>
        /// at least one phone number must be specified
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void customPhoneAuthVal_ServerValidate(object sender, ServerValidateEventArgs e)
        {
            e.IsValid = false;
            if (this.AuthorizedWorkPhone.HasPhoneNumber() || this.AuthorizedHomePhone.HasPhoneNumber() ||
              this.AuthorizedCellPhone.HasPhoneNumber())
            {
                e.IsValid = true;
            }
            return;
        }
        #endregion

        #region Physicians Add/ Delete

        protected void CustomValidatorPhysicianAssigned_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if (!args.IsValid)
            {
                args.IsValid = false;


                IList<Person> docList = POD.Logic.PeopleLogic.GetDoctorsByID(PersonID);
                if (docList != null && docList.Count > 0)
                {
                    args.IsValid = true;
                }
            }
            else
            {
                args.IsValid = true;
            }

        }

        protected void cvemergencyconsent_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if (!args.IsValid)
            {
                args.IsValid = false;

                if (this.chkemergencyconsent.Checked)
                {
                    args.IsValid = true;
                }

            }
            else
            {
                args.IsValid = true;
            }

        }

        protected void cvliability_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if (!args.IsValid)
            {
                args.IsValid = false;

                if (this.chkliability.Checked)
                {
                    args.IsValid = true;
                }

            }
            else
            {
                args.IsValid = true;
            }

        }

        protected void cvgrievanceconsent_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if (!args.IsValid)
            {
                args.IsValid = false;

                if (this.chkgrievanceconsent.Checked)
                {
                    args.IsValid = true;
                }

            }
            else
            {
                args.IsValid = true;
            }

        }


        //protected void RadGridDoctors_NeedsDataSource(object sender, GridNeedDataSourceEventArgs e)
        //{
        //    this.RadGridDoctors.DataSource = POD.Logic.PeopleLogic.GetDoctorsByID(PersonID);
        //}

        //protected void RadGridDoctors_DeleteCommand(object sender, GridCommandEventArgs e)
        //{
        //    string authorizedPersonID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PersonID"].ToString();
        //    if (!string.IsNullOrEmpty(authorizedPersonID))
        //    {
        //        POD.Logic.PeopleLogic.DeleteContacts(PersonID, int.Parse(authorizedPersonID), "Doc");
        //        RadGridDoctors.Rebind();
        //    }
        //}

        protected void RadGridDoctors_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem dtItem = (GridDataItem)e.Item;
                Person per = (Person)dtItem.DataItem;
                Literal address = (Literal)e.Item.FindControl("LiteralAddress");
                if (per.MailingAddress != null)
                {
                    address.Text = string.Format("{0} {1} {2}, {3}", per.MailingAddress.AddressLine1, per.MailingAddress.City, per.MailingAddress.Zip, per.MailingAddress.State);
                }
            }
            if (e.Item.ItemType == GridItemType.Item || e.Item.ItemType == GridItemType.AlternatingItem)
            {
                //if not admin then no editing/deleting or adding new classess
                if (!Security.UserInRole("Administrators") && !Security.UserInRole("CentralTeamUsers") &&
                    !Security.UserInRole("SiteTeamUsers"))
                {
                    e.Item.OwnerTableView.Columns.FindByUniqueName("DeleteColumn").Visible = false;
                }
            }
        }

        //protected void ButtonAddDoctor_Click(object sender, EventArgs e)
        //{
        //    AddDoctor();
        //}

        //private void AddDoctor()
        //{
        //    try
        //    {
        //        if (PersonID == 0)
        //        {
        //            SavePerson();
        //        }

        //        IEnumerable<Person> authorizedPeople  = null;
        //        Person doc = null;
        //        int relationshipTypeid = POD.Logic.ManageTypesLogic.GetPersonRelationshipTypeIDByName("other");
        //        string firstName = this.DocFirstNameTextBox.Text;
        //        string lastName = this.DocLastNameTextBox.Text;

        //        if (isRollOver)
        //        {
        //            authorizedPeople = POD.Logic.PeopleLogic.GetDoctorsByID(tempPersonId);
        //            doc = authorizedPeople.FirstOrDefault();
        //        }
        //        else
        //        {
        //           authorizedPeople = POD.Logic.PeopleLogic.GetDoctorsByID(PersonID);
        //            doc = authorizedPeople.FirstOrDefault(p => p.FirstName.ToLower() == firstName.ToLower() && p.LastName.ToLower() == lastName.ToLower());
        //        }


        //        int authorizedPersonID = -1;
        //        if (doc != null)
        //        {
        //            authorizedPersonID = doc.PersonID;
        //        }
        //        else
        //        {
        //            doc = POD.Logic.PeopleLogic.AddUpdatePerson(null, firstName, lastName, string.Empty, string.Empty);

        //        }
        //        if (doc != null)
        //        {
        //            //add relationship
        //            POD.Logic.PeopleLogic.AddPersonRelationShip(PersonID, doc.PersonID, relationshipTypeid, string.Empty, false, false, false, true);
        //            //add phone number
        //            this.DocPhone.PhoneTypeID = phoneTypeKey;
        //            this.DocPhone.SaveAndAssignPhone(doc.PersonID);
        //            this.DocAddress.AddressTypeID = addressTypeid;
        //            this.DocAddress.SaveAndAssignAddress(doc.PersonID);

        //        }

        //    }
        //    catch (Exception ex)
        //    {
        //        ex.Log();
        //    }
        //    //clear add screen
        //    this.DocAddress.ClearAddress();
        //    this.DocPhone.ClearPhoneNumber();
        //    this.DocFirstNameTextBox.Text = string.Empty;
        //    this.DocLastNameTextBox.Text = string.Empty;

        //    //refresh grid
        //    this.RadGridDoctors.Rebind();
        //}
        #endregion

        #region Delete
        protected void DeleteButton_Click(object sender, EventArgs e)
        {
            if (EnrollmentID != 0)
            {
                string result = POD.Logic.PersonRelatedLogic.DeleteEnrollment(EnrollmentID);
                if (string.IsNullOrEmpty(result))
                {
                    Response.Redirect("~/Pages/Enrollments.aspx");
                }
            }
        }

        protected void PrintButton_Click(object sender, EventArgs e)
        {
            if (EnrollmentID != 0)
            {
                GeneratePDFdata(EnrollmentID);
            }
        }

        public static void GeneratePDFdata(int id)
        {
            try
            {



                var enrollment = POD.Logic.PersonRelatedLogic.GetEnrollmentByID(id);
                var person = POD.Logic.PeopleLogic.GetPersonByID(enrollment.PersonID);
                var schoolAddress = POD.Logic.AddressPhoneNumerLogic.GetSchoolAddressPersonID(enrollment.PersonID);

                var studentInfo = POD.Logic.PeopleLogic.GetStudentAndRelatedInfoByID(enrollment.PersonID);
                IList<Person> relatedPeople = POD.Logic.PeopleLogic.GetGuardiansByID(enrollment.PersonID);
                IList<Person> emergencyContacts = POD.Logic.PeopleLogic.GetAuthorizedPeopleByID_New(enrollment.PersonID);
                //IList<Person> emergencyContacts = POD.Logic.PeopleLogic.GetEmergencyContactsByID(enrollment.PersonID);
                var enrollmentDOC = POD.Logic.PeopleLogic.GetDoctorsByID(enrollment.PersonID);
                var siteInfo = LookUpTypesLogic.GetSiteByID((int)enrollment.SiteLocationID);


                var relatedPeopleCount = relatedPeople.Count();
                var OtherRelatedPeople = POD.Logic.PeopleLogic.GetRelatedPersonsByID(enrollment.PersonID).Skip(relatedPeopleCount).ToList();


                MemoryStream ms = new MemoryStream();

                string sTemplate = Path.Combine(HttpContext.Current.Request.PhysicalApplicationPath, @"App_Data\pod_2019.pdf");

                PdfReader pdfReader = new PdfReader(sTemplate);
                PdfStamper pdfStamper = new PdfStamper(pdfReader, ms);

                PdfContentByte cb = pdfStamper.GetOverContent(1);
                AcroFields pdfFormFields = pdfStamper.AcroFields;

                // Section 1

                pdfFormFields.SetField("s1_prevention", enrollment.EnrollmentTypeID == 1 ? "Yes" : "No");  //
                pdfFormFields.SetField("s1_diversion", enrollment.EnrollmentTypeID == 3 ? "Yes" : "No");  //
                pdfFormFields.SetField("s1_other", enrollment.EnrollmentTypeID == 2 ? "Yes" : "No");  //

                //

                var location = LookUpTypesLogic.GetLocationByID(enrollment.SiteLocationID.Value);

                pdfFormFields.SetField("s1_programlocation", location.Name);





                pdfFormFields.SetField("appdate", enrollment.DateApplied != null ? Convert.ToDateTime(enrollment.DateApplied).ToString("MM/dd/yyyy") : "");

                pdfFormFields.SetField("s1_race_black", studentInfo.Races.FirstOrDefault().RaceID == 3 ? "Yes" : "No");  //person.races 3
                pdfFormFields.SetField("s1_race_white", studentInfo.Races.FirstOrDefault().RaceID == 4 ? "Yes" : "No"); //person.races 4
                pdfFormFields.SetField("s1_race_asian", studentInfo.Races.FirstOrDefault().RaceID == 1 ? "Yes" : "No"); //person.races 1
                pdfFormFields.SetField("s1_race_american", studentInfo.Races.FirstOrDefault().RaceID == 2 ? "Yes" : "No"); //person.races 2
                pdfFormFields.SetField("s1_race_pacisland", studentInfo.Races.FirstOrDefault().RaceID == 6 ? "Yes" : "No"); //person.races 5
                                                                                                                            //pdfFormFields.SetField("s1_race_biracial", studentInfo.Races.FirstOrDefault().RaceID == 7 ? "Yes" : "No"); //person.races 5


                pdfFormFields.SetField("s1_haitian", studentInfo.Ethnicities.FirstOrDefault().EthnicityID == 1 ? "Yes" : "No");
                pdfFormFields.SetField("s1_hispanic", studentInfo.Ethnicities.FirstOrDefault().EthnicityID == 2 ? "Yes" : "No");
                pdfFormFields.SetField("s1_jamaican", studentInfo.Ethnicities.FirstOrDefault().EthnicityID == 3 ? "Yes" : "No");
                pdfFormFields.SetField("s1_non_hispanic", studentInfo.Ethnicities.FirstOrDefault().EthnicityID == 4 ? "Yes" : "No");

                if (studentInfo.IsLunchReduced != null)
                {
                    pdfFormFields.SetField("s1_lunch_yes", studentInfo.IsLunchReduced == true ? "Yes" : "No");
                    pdfFormFields.SetField("s1_lunch_no", studentInfo.IsLunchReduced == true ? "No" : "Yes");
                }

                if (studentInfo.isFosterCare != null)
                {
                    pdfFormFields.SetField("s1_foster_yes", studentInfo.isFosterCare == true ? "Yes" : "No");
                    pdfFormFields.SetField("s1_foster_no", studentInfo.isFosterCare == false ? "Yes" : "No");
                }

                if (studentInfo.IsMedicaid != null)
                {
                    pdfFormFields.SetField("s1_medicaid_yes", studentInfo.IsMedicaid == true ? "Yes" : "No");
                    pdfFormFields.SetField("s1_medicaid_no", studentInfo.IsMedicaid == false ? "Yes" : "No");
                }


                pdfFormFields.SetField("s1_multi_ethic", studentInfo.Ethnicities.FirstOrDefault().EthnicityID == 5 ? "Yes" : "No");
                pdfFormFields.SetField("s1_multi_ethic", studentInfo.Ethnicities.FirstOrDefault().EthnicityID == 5 ? "Yes" : "No");


                pdfFormFields.SetField("s1_gender_f", person.GenderID == 2 ? "Yes" : ""); //person.Gender 1
                pdfFormFields.SetField("s1_gender_m", person.GenderID == 1 ? "Yes" : "");
                pdfFormFields.SetField("s1_fname", person.FirstName != null ? person.FirstName : "");
                pdfFormFields.SetField("school_student_id", person.Student.DJJIDNum != null ? person.Student.DJJIDNum : "");
                pdfFormFields.SetField("last4ssn", person.Student.Last4SSN != null ? person.Student.Last4SSN : "");
                pdfFormFields.SetField("s1_lname", person.LastName != null ? person.LastName : "");
                pdfFormFields.SetField("s1_mname", person.MiddleName != null ? person.MiddleName : "");
                pdfFormFields.SetField("s1_address", person.Addresses.FirstOrDefault().AddressLine1 != null ? person.Addresses.FirstOrDefault().AddressLine1 : "");


                if (studentInfo.isDJJYouth == true)
                {
                    pdfFormFields.SetField("s1_age_djj", person.Age != null ? person.Age.ToString() : "");
                }
                else
                {
                    pdfFormFields.SetField("s1_age_hc", person.Age != null ? person.Age.ToString() : "");
                }


                pdfFormFields.SetField("s1_dob", person.DateOfBirth != null ? Convert.ToDateTime(person.DateOfBirth).ToString("d") : "");
                pdfFormFields.SetField("s1_address2", person.Addresses.FirstOrDefault().AddressLine2 != null ? person.Addresses.FirstOrDefault().AddressLine2 : "");
                pdfFormFields.SetField("s1_apt", person.Addresses.FirstOrDefault().AptNum != null ? person.Addresses.FirstOrDefault().AptNum : "");
                pdfFormFields.SetField("s1_state", person.Addresses.FirstOrDefault().State != null ? person.Addresses.FirstOrDefault().State : "");
                pdfFormFields.SetField("s1_city", person.Addresses.FirstOrDefault().City != null ? person.Addresses.FirstOrDefault().City : "");
                pdfFormFields.SetField("s1_language", person.PrimaryLanguageSpoken != null ? person.PrimaryLanguageSpoken : "");
                pdfFormFields.SetField("s1_zip", person.Addresses.FirstOrDefault().Zip != null ? person.Addresses.FirstOrDefault().Zip : "");

                pdfFormFields.SetField("s1_refer_other", studentInfo.ReferredByOther != null ? studentInfo.ReferredByOther : "");
                pdfFormFields.SetField("s1_hillsborough", person.Addresses.FirstOrDefault().CountyID.Value == 1 ? "Yes" : "No");
                pdfFormFields.SetField("s1_pinellas", person.Addresses.FirstOrDefault().CountyID.Value == 52 ? "Yes" : "No");
                pdfFormFields.SetField("s1_pasco", person.Addresses.FirstOrDefault().CountyID.Value == 51 ? "Yes" : "No");
                pdfFormFields.SetField("s1_polk", person.Addresses.FirstOrDefault().CountyID.Value == 53 ? "Yes" : "No");
                pdfFormFields.SetField("s1_manatee", person.Addresses.FirstOrDefault().CountyID.Value == 40 ? "Yes" : "No");
                pdfFormFields.SetField("s1_sarasota", person.Addresses.FirstOrDefault().CountyID.Value == 58 ? "Yes" : "No");
                pdfFormFields.SetField("s1_orange", person.Addresses.FirstOrDefault().CountyID.Value == 48 ? "Yes" : "No");
                pdfFormFields.SetField("s1_osceola", person.Addresses.FirstOrDefault().CountyID.Value == 49 ? "Yes" : "No");
                pdfFormFields.SetField("s1_hardee", person.Addresses.FirstOrDefault().CountyID.Value == 26 ? "Yes" : "No");
                pdfFormFields.SetField("s1_highlands", person.Addresses.FirstOrDefault().CountyID.Value == 29 ? "Yes" : "No");


                pdfFormFields.SetField("s1_grade", studentInfo.GradeLevel != null ? studentInfo.GradeLevel : "");
                pdfFormFields.SetField("s1_school_address", schoolAddress.AddressLine1 != null ? schoolAddress.AddressLine1 : "");
                pdfFormFields.SetField("s1_school_address2", schoolAddress.AddressLine2 != null ? schoolAddress.AddressLine2 : "");
                pdfFormFields.SetField("s1_school_name", studentInfo.SchoolAttending != null ? studentInfo.SchoolAttending : "");
                pdfFormFields.SetField("s1_school_city", schoolAddress.City != null ? schoolAddress.City : "");
                pdfFormFields.SetField("s1_school_apt", schoolAddress.AptNum != null ? schoolAddress.AptNum : "");
                pdfFormFields.SetField("s1_school_zip", schoolAddress.Zip != null ? schoolAddress.Zip : "");

                var schoolPhone = POD.Logic.AddressPhoneNumerLogic.GetPhoneNumberByTypeAndPersonID(6, enrollment.PersonID);
                if (schoolPhone != null)
                {
                    pdfFormFields.SetField("s1_school_phone", schoolPhone.Phone.ToString());

                }

                if (studentInfo.PartOtherProgSchool == true)
                {
                    pdfFormFields.SetField("s1_school_state", schoolAddress.State != null ? schoolAddress.State : "");
                }

                pdfFormFields.SetField("s1_school_yes", studentInfo.PartOtherProgSchool.HasValue && studentInfo.PartOtherProgSchool == true ? "Yes" : "No");
                pdfFormFields.SetField("s1_school_no", studentInfo.PartOtherProgSchool.HasValue && studentInfo.PartOtherProgSchool == false ? "Yes" : "No");

                var legalguardianinitials = (relatedPeople.FirstOrDefault().FirstName != null ? relatedPeople.FirstOrDefault().FirstName.FirstOrDefault().ToString().Substring(0, 1) : "") + (relatedPeople.FirstOrDefault().LastName != null ? relatedPeople.FirstOrDefault().LastName.FirstOrDefault().ToString().Substring(0, 1) : "");


                pdfFormFields.SetField("s1_lg1_fname", relatedPeople.FirstOrDefault().FirstName != null ? relatedPeople.FirstOrDefault().FirstName : "");
                pdfFormFields.SetField("s1_lg1_lname", relatedPeople.FirstOrDefault().LastName != null ? relatedPeople.FirstOrDefault().LastName : "");
                pdfFormFields.SetField("s1_lg1_mname", relatedPeople.FirstOrDefault().MiddleName != null ? relatedPeople.FirstOrDefault().MiddleName : "");
                pdfFormFields.SetField("s1_lg1_hphone", relatedPeople.FirstOrDefault().HomePhone != null ? relatedPeople.FirstOrDefault().HomePhone.Phone.ToString() : "");
                pdfFormFields.SetField("s1_lg1_wphone", relatedPeople.FirstOrDefault().WorkPhone != null ? relatedPeople.FirstOrDefault().WorkPhone.Phone.ToString() : "");
                pdfFormFields.SetField("s1_lg1_cphone", relatedPeople.FirstOrDefault().CellPhone != null ? relatedPeople.FirstOrDefault().CellPhone.Phone.ToString() : "");
                pdfFormFields.SetField("s1_lg1_rel_m", DetermineLegalStatus(relatedPeople.FirstOrDefault().RelationshipTypeName) == 1 ? "Yes" : "No");
                pdfFormFields.SetField("s1_lg1_rel_f", DetermineLegalStatus(relatedPeople.FirstOrDefault().RelationshipTypeName) == 2 ? "Yes" : "No");
                pdfFormFields.SetField("s1_lg1_rel_lg", DetermineLegalStatus(relatedPeople.FirstOrDefault().RelationshipTypeName) == 3 ? "Yes" : "No");
                pdfFormFields.SetField("s1_lg1_rel_o", DetermineLegalStatus(relatedPeople.FirstOrDefault().RelationshipTypeName) == 4 ? "Yes" : "No"); //DetermineLegalStatus(relatedPeople.FirstOrDefault().RelationshipTypeName)
                pdfFormFields.SetField("s1_lg1_rel_o_desc", relatedPeople.FirstOrDefault().RelationshipOther);
                pdfFormFields.SetField("s1_lg1_emergency", relatedPeople.FirstOrDefault().IsER != null && relatedPeople.FirstOrDefault().IsER.ToLower() == "true" ? "Yes" : "");

                pdfFormFields.SetField("s1_lg1_email", relatedPeople.FirstOrDefault().Email != null ? relatedPeople.FirstOrDefault().Email : "");

                if (relatedPeople.Count > 1)
                {
                    pdfFormFields.SetField("s1_lg2_fname", relatedPeople.Skip(1).First().FirstName != null ? relatedPeople.Skip(1).First().FirstName : "");
                    pdfFormFields.SetField("s1_lg2_lname", relatedPeople.Skip(1).First().LastName != null ? relatedPeople.Skip(1).First().LastName : "");
                    pdfFormFields.SetField("s1_lg2_mname", relatedPeople.Skip(1).First().MiddleName != null ? relatedPeople.Skip(1).First().MiddleName : "");
                    pdfFormFields.SetField("s1_lg2_hphone", relatedPeople.Skip(1).First().HomePhone != null ? relatedPeople.Skip(1).First().HomePhone.Phone.ToString() : "");
                    pdfFormFields.SetField("s1_lg2_wphone", relatedPeople.Skip(1).First().WorkPhone != null ? relatedPeople.Skip(1).First().WorkPhone.Phone.ToString() : "");
                    pdfFormFields.SetField("s1_lg2_cphone", relatedPeople.Skip(1).First().CellPhone != null ? relatedPeople.Skip(1).First().CellPhone.Phone.ToString() : "");
                    pdfFormFields.SetField("s1_lg2_rel_m", DetermineLegalStatus(relatedPeople.Skip(1).FirstOrDefault().RelationshipTypeName) == 1 ? "Yes" : "No");
                    pdfFormFields.SetField("s1_lg2_rel_f", DetermineLegalStatus(relatedPeople.Skip(1).FirstOrDefault().RelationshipTypeName) == 2 ? "Yes" : "No");
                    pdfFormFields.SetField("s1_lg2_rel_lg", DetermineLegalStatus(relatedPeople.Skip(1).FirstOrDefault().RelationshipTypeName) == 3 ? "Yes" : "No");
                    pdfFormFields.SetField("s1_lg2_rel_o", DetermineLegalStatus(relatedPeople.Skip(1).FirstOrDefault().RelationshipTypeName) == 4 ? "Yes" : "No");
                    pdfFormFields.SetField("s1_lg2_emergency", relatedPeople.Skip(1).First().IsER != null && relatedPeople.Skip(1).First().IsER.ToLower() == "true" ? "Yes" : "");
                    pdfFormFields.SetField("s1_lg2_email", relatedPeople.Skip(1).First().Email != null ? relatedPeople.Skip(1).First().Email : "");
                    pdfFormFields.SetField("s1_lg2_rel_o_desc", relatedPeople.Skip(1).FirstOrDefault().RelationshipOther);
                }

                //need to add these to the pdf
                pdfFormFields.SetField("s1_familystatus_two", DetermineFamilyStatusStatus(person.FamilyStatus.Trim()) == 1 ? "Yes" : "No");
                pdfFormFields.SetField("s1_familystatus_mother", DetermineFamilyStatusStatus(person.FamilyStatus.Trim()) == 2 ? "Yes" : "No");
                pdfFormFields.SetField("s1_familystatus_father", DetermineFamilyStatusStatus(person.FamilyStatus.Trim()) == 3 ? "Yes" : "No");
                pdfFormFields.SetField("s1_familystatus_relatives", DetermineFamilyStatusStatus(person.FamilyStatus.Trim()) == 4 ? "Yes" : "No");
                pdfFormFields.SetField("s1_familystatus_nonrelatives", DetermineFamilyStatusStatus(person.FamilyStatus.Trim()) == 5 ? "Yes" : "No");
                pdfFormFields.SetField("s1_familystatus_foster", DetermineFamilyStatusStatus(person.FamilyStatus.Trim()) == 6 ? "Yes" : "No");
                pdfFormFields.SetField("s1_familystatus_other", DetermineFamilyStatusStatus(person.FamilyStatus.Trim()) == 7 ? "Yes" : "No");

                if (DetermineFamilyStatusStatus(person.FamilyStatus.Trim()) == 7)
                {
                    pdfFormFields.SetField("s1_familystatus_other_description", person.FamilyStatus != null ? person.FamilyStatus.Trim() : "");
                }



                pdfFormFields.SetField("s1_youthparentalstatus_none", DetermineYouthParentalStatus(person.YouthParentalStatus) == 1 ? "Yes" : "No"); //person.YouthParentalStatus //DetermineYouthParentalStatus(person.YouthParentalStatus)
                pdfFormFields.SetField("s1_youthparentalstatus_preg", DetermineYouthParentalStatus(person.YouthParentalStatus) == 2 ? "Yes" : "No");
                pdfFormFields.SetField("s1_youthparentalstatus_mother", DetermineYouthParentalStatus(person.YouthParentalStatus) == 3 ? "Yes" : "No");
                pdfFormFields.SetField("s1_youthparentalstatus_father", DetermineYouthParentalStatus(person.YouthParentalStatus) == 4 ? "Yes" : "No");

                //build routin to determine
                pdfFormFields.SetField("s1_youthreferredby_self", DetermineReferredByStatus(person.ReferredBy) == 1 ? "Yes" : "No");
                pdfFormFields.SetField("s1_youthreferredby_school", DetermineReferredByStatus(person.ReferredBy) == 2 ? "Yes" : "No");
                //pdfFormFields.SetField("s1_youthreferredby_djj", DetermineReferredByStatus(person.ReferredBy) == 3 ? "Yes" : "No");
                pdfFormFields.SetField("s1_youthreferredby_dcf", DetermineReferredByStatus(person.ReferredBy) == 4 ? "Yes" : "No");
                //pdfFormFields.SetField("s1_youthreferredby_SA", DetermineReferredByStatus(person.ReferredBy) == 5 ? "Yes" : "No");
                //pdfFormFields.SetField("s1_youthreferredby_OCJ", DetermineReferredByStatus(person.ReferredBy) == 6 ? "Yes" : "No");
                //pdfFormFields.SetField("s1_youthreferredby_socialservices", DetermineReferredByStatus(person.ReferredBy) == 7 ? "Yes" : "No");
                pdfFormFields.SetField("s1_youthreferredby_other", DetermineReferredByStatus(person.ReferredBy) == 8 ? "Yes" : "No");

                if (emergencyContacts.Count > 0)
                {
                    //Section 2
                    pdfFormFields.SetField("s2_lg1_fname", emergencyContacts.FirstOrDefault().FirstName != null ? emergencyContacts.FirstOrDefault().FirstName : "");
                    pdfFormFields.SetField("s2_lg1_lname", emergencyContacts.FirstOrDefault().LastName != null ? emergencyContacts.FirstOrDefault().LastName : "");
                    pdfFormFields.SetField("s2_lg1_mname", emergencyContacts.FirstOrDefault().MiddleName != null ? emergencyContacts.FirstOrDefault().MiddleName : "");
                    pdfFormFields.SetField("s2_lg1_hphone", emergencyContacts.FirstOrDefault().HomePhone != null ? emergencyContacts.FirstOrDefault().HomePhone.Phone.ToString() : "");
                    pdfFormFields.SetField("s2_lg1_wphone", emergencyContacts.FirstOrDefault().WorkPhone != null ? emergencyContacts.FirstOrDefault().WorkPhone.Phone.ToString() : "");
                    pdfFormFields.SetField("s2_lg1_cphone", emergencyContacts.FirstOrDefault().CellPhone != null ? emergencyContacts.FirstOrDefault().CellPhone.Phone.ToString() : "");
                    pdfFormFields.SetField("s2_lg1_rel_relative", DetermineLegalStatus(emergencyContacts.FirstOrDefault().RelationshipTypeName) == 7 ? "Yes" : "No");
                    pdfFormFields.SetField("s2_lg1_rel_sibling", DetermineLegalStatus(emergencyContacts.FirstOrDefault().RelationshipTypeName) == 6 ? "Yes" : "No");
                    pdfFormFields.SetField("s2_lg1_rel_friend", DetermineLegalStatus(emergencyContacts.FirstOrDefault().RelationshipTypeName) == 5 ? "Yes" : "No");
                    pdfFormFields.SetField("s2_lg1_rel_o", DetermineLegalStatus(emergencyContacts.FirstOrDefault().RelationshipTypeName) == 4 ? "Yes" : "No");
                    pdfFormFields.SetField("s2_lg1_rel_o_desc", emergencyContacts.FirstOrDefault().RelationshipOther);

                    pdfFormFields.SetField("EC", !string.IsNullOrEmpty(emergencyContacts.FirstOrDefault().IsER) && emergencyContacts.FirstOrDefault().IsER == "True" ? "Yes" : "No");

                    if (emergencyContacts.Count > 1)
                    {
                        pdfFormFields.SetField("s2_lg2_fname", emergencyContacts.Skip(1).First().FirstName != null ? emergencyContacts.Skip(1).First().FirstName : "");
                        pdfFormFields.SetField("s2_lg2_lname", emergencyContacts.Skip(1).First().LastName != null ? emergencyContacts.Skip(1).First().LastName : "");
                        pdfFormFields.SetField("s2_lg2_mname", emergencyContacts.Skip(1).First().MiddleName != null ? emergencyContacts.Skip(1).First().MiddleName : "");
                        pdfFormFields.SetField("s2_lg2_hphone", emergencyContacts.Skip(1).First().HomePhone != null ? emergencyContacts.Skip(1).First().HomePhone.Phone.ToString() : "");
                        pdfFormFields.SetField("s2_lg2_wphone", emergencyContacts.Skip(1).First().WorkPhone != null ? emergencyContacts.Skip(1).First().WorkPhone.Phone.ToString() : "");
                        pdfFormFields.SetField("s2_lg2_cphone", emergencyContacts.Skip(1).First().CellPhone != null ? emergencyContacts.Skip(1).First().CellPhone.Phone.ToString() : "");
                        pdfFormFields.SetField("s2_lg2_rel_relative", DetermineLegalStatus(emergencyContacts.Skip(1).FirstOrDefault().RelationshipTypeName) == 7 ? "Yes" : "No");
                        pdfFormFields.SetField("s2_lg2_rel_sibling", DetermineLegalStatus(emergencyContacts.Skip(1).FirstOrDefault().RelationshipTypeName) == 6 ? "Yes" : "No");
                        pdfFormFields.SetField("s2_lg2_rel_friend", DetermineLegalStatus(emergencyContacts.Skip(1).FirstOrDefault().RelationshipTypeName) == 5 ? "Yes" : "No");
                        pdfFormFields.SetField("s2_lg2_rel_o", DetermineLegalStatus(emergencyContacts.Skip(1).FirstOrDefault().RelationshipTypeName) == 4 ? "Yes" : "No");
                        pdfFormFields.SetField("EC_2", !string.IsNullOrEmpty(emergencyContacts.Skip(1).FirstOrDefault().IsER) && emergencyContacts.FirstOrDefault().IsER == "True" ? "Yes" : "No");
                        pdfFormFields.SetField("s2_lg2_rel_o_desc", emergencyContacts.Skip(1).FirstOrDefault().RelationshipOther);
                    }

}
                    pdfFormFields.SetField("s2_selfsignin", studentInfo.SignInOut == true ? "Yes" : "No");
                    pdfFormFields.SetField("s2_signinandout", studentInfo.SignedInOutGuardOnly == true ? "Yes" : "No");
                    pdfFormFields.SetField("s2_signin_other", studentInfo.ReleaseOther == true ? "Yes" : "No");
                    pdfFormFields.SetField("s2_selfsignin_desc", studentInfo.ReleaseOtherText != null ? studentInfo.ReleaseOtherText : "");
                

                var fullYouthName = (person.FirstName != null ? person.FirstName : "") + " " + (person.MiddleName != null ? person.MiddleName : "") + " " + (person.LastName != null ? person.LastName : "");

                var initialsPerson = (person.FirstName != null ? person.FirstName.FirstOrDefault().ToString().Substring(0, 1) : "") + (person.LastName != null ? person.LastName.FirstOrDefault().ToString().Substring(0, 1) : "");



                pdfFormFields.SetField("s2_authorized_yes", studentInfo.isAuthorizedStaffOk == true ? "Yes" : "No");
                pdfFormFields.SetField("s2_authorized_no", studentInfo.isAuthorizedStaffOk == false ? "Yes" : "No");
                //Section 3
                if (enrollmentDOC != null && enrollmentDOC.Count > 0)
                {

                    pdfFormFields.SetField("s3_doc_name", enrollmentDOC.FirstOrDefault().FullName != null ? enrollmentDOC.FirstOrDefault().FullName : "");
                    pdfFormFields.SetField("s3_doc_address", enrollmentDOC.FirstOrDefault().Addresses.Count > 0 ? enrollmentDOC.FirstOrDefault().Addresses.FirstOrDefault().AddressLine1 : "");
                    pdfFormFields.SetField("s3_ins_name", studentInfo.InsuranceCompany != null ? studentInfo.InsuranceCompany : "");
                    pdfFormFields.SetField("s3_ins_polnumber", studentInfo.InsurancePolicyNum != null ? studentInfo.InsurancePolicyNum : "");
                    pdfFormFields.SetField("s3_doc_phone", enrollmentDOC.FirstOrDefault().WorkPhone != null ? enrollmentDOC.FirstOrDefault().WorkPhone.Phone.ToString() : "");
                }
                pdfFormFields.SetField("s3_ins_group_no", studentInfo.InsurancePolicyGroupNum != null ? studentInfo.InsurancePolicyGroupNum : "");
                pdfFormFields.SetField("s3_youthname", fullYouthName);
                pdfFormFields.SetField("s3_medications", studentInfo.Medications != null ? studentInfo.Medications : "");
                pdfFormFields.SetField("s3_med_conditions", studentInfo.MedicalConditions != null ? studentInfo.MedicalConditions : "");
                pdfFormFields.SetField("s3_special_other", studentInfo.MedicalSpecialNeeds != null ? studentInfo.MedicalSpecialNeeds : "");
                pdfFormFields.SetField("s3_emergency_consent", studentInfo.emergencyconsent != null ? legalguardianinitials : "");


                //Section 4
                pdfFormFields.SetField("s4_sitename", siteInfo.SiteName != null ? "" : "");
                pdfFormFields.SetField("s4_liability_consent", studentInfo.liabilityconsent != null ? legalguardianinitials : "");
                pdfFormFields.SetField("s4_grievance_consent", studentInfo.grievanceconsent != null ? legalguardianinitials : "");
                pdfFormFields.SetField("s4_assessment_yes", studentInfo.isAssessmentOk == true ? "Yes" : "No");
                pdfFormFields.SetField("s4_assessment_no", studentInfo.isAssessmentOk == false ? "Yes" : "No");

                //Section 5
                pdfFormFields.SetField("s5_media_yes", studentInfo.isMediaCaptureOk == true ? "Yes" : "No");
                pdfFormFields.SetField("s5_media_no", studentInfo.isMediaCaptureOk == false ? "Yes" : "No");
                pdfFormFields.SetField("s6_media_consent", studentInfo.isMediaCaptureOk == true ? legalguardianinitials : "");

                //var initialsPerson = (person.FirstName != null ? person.FirstName.FirstOrDefault().ToString().Substring(0, 1) : "") + (person.MiddleName != null ? person.MiddleName.FirstOrDefault().ToString().Substring(0, 1) : "") + (person.LastName != null ? person.LastName.FirstOrDefault().ToString().Substring(0,1) : "");
                //Section 5
                //pdfFormFields.SetField("s5_initials", initialsPerson.ToUpper());
                ////Section 6
                //pdfFormFields.SetField("s6_initials", initialsPerson.ToUpper());
                //    pdfFormFields.SetField("s7_initials", initialsPerson.ToUpper());
                //    pdfFormFields.SetField("s8_initials", initialsPerson.ToUpper());
                //    pdfFormFields.SetField("s9_initials", initialsPerson.ToUpper());
                //    pdfFormFields.SetField("s10_initials", initialsPerson.ToUpper());
                //    pdfFormFields.SetField("s11_initials", initialsPerson.ToUpper());


                // flatten the form to remove editting options, set it to false
                // to leave the form open to subsequent manual edits
                pdfStamper.FormFlattening = true;


                /// experiment 
                /// 
                //var writer = pdfStamper.Writer;

                //writer.AddJavaScript(GetAutoPrintJs());
                //pdfStamper.Close();
                //var content = ms.ToArray();
                //ms.Close();
                //HttpContext.Current.Response.ContentType = "application/pdf";
                //HttpContext.Current.Response.BinaryWrite(content);
                //HttpContext.Current.Response.End();
                //pdfStamper.Close();
                //ms.Close();
                //ms.Dispose();




                //// end experiment
                if (pdfStamper != null)
                { pdfStamper.Close(); }

                pdfReader.Close();

                HttpContext.Current.Response.ContentType = "application/pdf";
                HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=PODApplication_" + enrollment.EnrollmentID + ".pdf");
                HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);

                HttpContext.Current.Response.BinaryWrite(ms.ToArray());
                // HttpContext.Current.Response.End();

            }
            catch (Exception ex)
            {
                ex.Log();
            }

        }


        public static int DetermineLegalStatus(string status)
        {
            int result = 0;
            if (status.ToLower() != null)
            {
                switch (status.ToLower().Trim())
                {
                    case "mother":
                        result = 1;
                        break;
                    case "father":
                        result = 2;
                        break;
                    case "legal guardian":
                        result = 3;
                        break;
                    case "other":
                        result = 4;
                        break;
                    case "friend":
                        result = 5;
                        break;
                    case "sibling":
                        result = 6;
                        break;
                    case "relative":
                        result = 7;
                        break;

                    default:
                        break;
                }
            }

            return result;
        }

        public static int DetermineYouthParentalStatus(string status)
        {
            int result = 0;
            if (status != null)
            {
                switch (status.ToLower().Trim())
                {
                    case "none":
                        result = 1;
                        break;
                    case "youth is pregnant":
                        result = 2;
                        break;
                    case "youth is a mother":
                        result = 3;
                        break;
                    case "youth is a father":
                        result = 4;
                        break;

                    default:
                        break;
                }
            }

            return result;

        }

        public static int DetermineFamilyStatusStatus(string status)
        {
            int result = 0;
            if (status != null)
            {
                switch (status.ToLower().Trim())
                {
                    case "lives with two parents":
                        result = 1;
                        break;
                    case "lives with single mother":
                        result = 2;
                        break;
                    case "lives with single father":
                        result = 3;
                        break;

                    case "lives with relative(s)":
                        result = 4;
                        break;
                    case "lives with non-relative(s)":
                        result = 5;
                        break;
                    case "foster care":
                        result = 6;
                        break;
                    default:
                        result = 7;
                        break;
                }
            }

            return result;

        }

        public static int DetermineReferredByStatus(string status)
        {
            int result = 0;
            if (status != null)
            {
                switch (status.ToLower().Trim())
                {
                    case "self or family":
                        result = 1;
                        break;
                    case "school":
                        result = 2;
                        break;
                    case "djj":
                        result = 3;
                        break;
                    case "dcf":
                        result = 4;
                        break;
                    case "judiciary or state attorney":
                        result = 5;
                        break;
                    case "other criminal justice (not djj)":
                        result = 6;
                        break;
                    case "other social services":
                        result = 7;
                        break;
                    case "other":
                        result = 8;
                        break;
                    default:
                        break;
                }
            }

            return result;

        }

        protected static string GetAutoPrintJs()
        {
            var script = new StringBuilder();
            script.Append("var pp = getPrintParams();");
            script.Append("pp.interactive= pp.constants.interactionLevel.full;");
            script.Append("print(pp);"); return script.ToString();
        }



        #endregion

        protected void secureLocation_OnAuthorize(object sender, AuthorizeEventArgs e)
        {
            e.Authorized = Security.AuthorizeRoles("Administrators,CentralTeamUsers") || (enrollmentUsage.CompareTo(EnrollmentUsageType.isNewDiversion) == 0);
        }

        protected void RadComboBoxSites_OnSelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            // this.RadComboBoxLocations.ClearSelection();

            if (!string.IsNullOrEmpty(e.Value))
            {
                int siteID = 0;
                if (int.TryParse(e.Value, out siteID))
                {
                    LoadLocationList(siteID);
                }
            }
            else
            {
                // this.RadComboBoxLocations.Enabled = false;
            }
        }


        //
        //
        //
        protected void CustomValidatorRace_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = false;
            foreach (System.Web.UI.WebControls.ListItem item in CheckBoxListRaces.Items)
            {
                if (item.Selected)
                {
                    args.IsValid = true;
                    break;
                }
            }

        }


        //
        //
        //
        protected void CustomValidatorEthnicity_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = false;
            foreach (System.Web.UI.WebControls.ListItem item in CheckBoxListEthnicity.Items)
            {
                if (item.Selected)
                {
                    args.IsValid = true;
                    break;
                }
            }

        }


        //RadNumericTextBoxAge
        //
        //
        protected void CustomValidatorFamilyStatusValidator_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = false;
            if (RadioButtonListRiskAssessmentFamilyStatus.SelectedIndex == -1)
                return;

            if (RadioButtonListRiskAssessmentFamilyStatus.SelectedItem.Value.Equals("Other") &&
                TextBoxFamilyStatusOther.Text.Equals(String.Empty))
            {
                CustomValidatorFamilyStatus.Text = "* Description of Other is required";
                return;
            }

            args.IsValid = true;


        }  //CustomValidatorFamilyStatusValidator_ServerValidate

        //
        //
        //
        protected void CustomValidatorCheckBoxTransportationList_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = false;

            foreach (System.Web.UI.WebControls.ListItem item in CheckBoxTransportationList.Items)
            {
                if (item.Selected)
                {
                    args.IsValid = true;
                    break;
                }
            }


        }  //CustomValidatorCheckBoxTransportationList_ServerValidate

        protected void reqAgeRangeValidate_OnServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = false;
            if (Convert.ToInt32(RadNumericTextBoxAge.Text) < 5 || Convert.ToInt32(RadNumericTextBoxAge.Text) > 17)
            {
                return;
            }

            args.IsValid = true;
        }

        bool isExport = false;

        protected void EnrollmentNotesPrint_Click(object sender, EventArgs e)
        {
            isExport = true;
            notesgrid.MasterTableView.GetColumn("DeleteColumn").Visible = false;
            notesgrid.MasterTableView.GetColumn("notefull").Display = true;
            notesgrid.MasterTableView.GetColumn("notefull").Visible = true;
            notesgrid.MasterTableView.GetColumn("note").Visible = false;
            notesgrid.MasterTableView.GetColumn("followupfull").Display = true;
            notesgrid.MasterTableView.GetColumn("followupfull").Visible = true;
            notesgrid.MasterTableView.GetColumn("followup").Visible = false;
            notesgrid.MasterTableView.GetColumn("EditColumn").Display = false;
            var dt = DateTime.Now;
            notesgrid.ExportSettings.FileName = "Enrollment Notes_" + String.Format("{0:MMddyyyy}", dt);
            //notesgrid.MasterTableView.ExportToWord();
            //notesgrid.ExportSettings.Excel.FileExtension = "xls";
            notesgrid.ExportSettings.Excel.Format = GridExcelExportFormat.Html;
           
            notesgrid.MasterTableView.ExportToExcel();
        }

        protected void notesgrid_GridExporting(object sender, GridExportingArgs e)
        {

            string customCSS = @"<style type='text / css'> 
                                    #wrap { width: 600px; margin: 0 auto; } 
                                    #left_col { float:left; width:30%; text-align: left; } 
                                    #right_col { float:right; width:70%; text-align: left; }
                                    </style>";

            string imageURL = @"<div><img src='https://pod.uacdc.org/Templates/Images/prodigy_logo.png' alt='prodigy_logo' height='65' width='100'></div><br>";
            
            var dt = DateTime.Now;
            notesgrid.ExportSettings.FileName = "Enrollment Notes_" + String.Format("{0:MMddyyyy}", dt);

            e.ExportOutput = e.ExportOutput.Replace("<body>", String.Format("<body syle='border:solid 0.1pt #CCCCCC;'>{0}", imageURL));
        }

        protected void notesgrid_ExportCellFormatting(object sender, ExportCellFormattingEventArgs e)
        {
            isExport = true;
            GridDataItem item = e.Cell.Parent as GridDataItem;
            if (item.ItemType == GridItemType.AlternatingItem)
                item.Style["background-color"] = "#ffffff";
            else
                item.Style["background-color"] = "#eaeaea";
        }

        protected void notesgrid_ItemCreated(object sender, GridItemEventArgs e)
        {
            /*if (e.Item is GridHeaderItem && isExport)
            {
                foreach (TableCell cell in e.Item.Cells)
                    cell.Style["width"] = "20px";
            }*/
        }

        protected void notesgrid_HTMLExporting(object sender, GridHTMLExportingEventArgs e)
        {
            //e.Styles.Append("body { border:solid 0.1pt #CCCCCC; }");
            //e.Styles.Append("table { border:solid 0.1pt #CCCCCC; }");
            e.Styles.Append("td { border:solid 0.1pt #CCCCCC; }");
            e.Styles.Append("th { border:solid 0.1pt #CCCCCC; }");
        }


    }
}
