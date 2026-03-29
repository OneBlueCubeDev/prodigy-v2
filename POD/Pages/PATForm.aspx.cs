using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using iTextSharp.text.pdf;
using POD.Data.Entities;
using POD.Logging;
using POD.Logic;
using Telerik.Web.UI;

namespace POD.Pages
{
    public partial class PATForm : System.Web.UI.Page
    {
        //private int _personId = 48695;

        private int _personId
        {
            get { return Session["personId"] == null ? 0 : Convert.ToInt32(Session["personId"]); }
            set { Session["personId"] = value; }
        }

        private int _personFormId
        {
            get { return Session["personFormId"] == null ? 0 : Convert.ToInt32(Session["personFormId"]); }
            set { Session["personFormId"] = value; }
        }


        private int _formId = 1;

        private PersonForm _personForm;

        protected void Page_Init(object sender, EventArgs e)
        {

            //var sectionId = getPersonSectionId();
            //if (sectionId != 0)
            //{
            //    sectionsTab.SelectedIndex = sectionId - 1;
            //}

            getQuestions();
        }

        /// <summary>
        /// Load the sections for the form
        /// </summary>
        protected void LoadSectionsByFormId()
        {

        }

        private List<TabData> GetTabData()
        {
            var sections = PATFormLogic.GetFormSections(1);
            // Replace this with your actual data retrieval logic
            List<TabData> tabDataList = new List<TabData>();

            foreach (var section in sections)
            {

                tabDataList.Add(new TabData(section.SectionName, section.SectionId.ToString()));
            }

            return tabDataList;
        }

        public class TabData
        {
            public string SectionText { get; set; }
            public string SectionId { get; set; }

            public TabData(string sectionText, string sectionId)
            {
                SectionText = sectionText;
                SectionId = sectionId;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "DisableCheckBoxes", "disablebox1()", true);

                List<TabData> tabDataList = GetTabData();
                foreach (TabData tabData in tabDataList)
                {
                    RadTab tab = new RadTab();
                    tab.Text = tabData.SectionText;
                    tab.Value = tabData.SectionId;
                    tab.NavigateUrl = "#ctl00_MainContentPlaceholder_sec" + tabData.SectionId; // Set NavigateUrl with fragment identifier
                    sectionsTab.Tabs.Add(tab);

                    
                }

                
                


                //var sections = PATFormLogic.GetFormSections(1);                
                //sectionsTab.DataValueField = "SectionId";
                //sectionsTab.DataTextField = "SectionName";
                //sectionsTab.DataSource = sections;
                //sectionsTab.DataBind();

                POD.MasterPages.Admin mtPage = (POD.MasterPages.Admin)this.Master;
                if (mtPage != null)
                {
                    mtPage.SetSearch("Enrollment");
                    mtPage.SetNavigation("Youth");
                }

                _personFormId = Convert.ToInt32(Request["personFormId"]);
                _personId = Convert.ToInt32(Request["personId"]);
                getQuestions();

                var p = PeopleLogic.GetPersonByID(_personId);
                if (p != null)
                {
                    lblPersonName.Text = p.FullName;
                    if (p.DateOfBirth.HasValue)
                    {
                        lblDOB.Text = p.DateOfBirth.Value.ToShortDateString();
                    }
                }
            }

            _personForm = PATFormLogic.GetPersonForm(_personFormId);
            if (_personForm != null)
            {
                lblLastUpdated.Text = _personForm.DateUpdated.ToShortDateString();

                RadDatePickerPATCompletedDate.SelectedDate = _personForm.DateCompleted;

                if (!IsPostBack)
                {
                    this.txtpatenteredby.Text = _personForm.PATEnteredBy;
                    RadDatePickerPATCompletedDate.SelectedDate = _personForm.DateCompleted;

                }
                this.lblcreatedby.Text = _personForm.CreateUserName.ToString();
                this.lblcreateddate.Text = _personForm.DateCreated.ToShortDateString();
                this.lblmodifiedby.Text = _personForm.UpdateUserName.ToString();
                this.lblmodifieddate.Text = _personForm.DateUpdated.ToShortDateString();

                if (_personForm.isInitialPAT.HasValue)
                {
                    if (_personForm.isInitialPAT.Value)
                    {
                        this.rbisInitialPAT.SelectedIndex = 0;
                    }
                    else
                    {
                        this.rbisInitialPAT.SelectedIndex = 1;
                    }
                }


                if (_personForm.IsComplete)
                {
                    txtComplete.Text = "1";
                    validateForm();
                    //validateSection();

                    //only enable the Completed date
                    if (Security.UserInRole("Administrators") || Security.UserInRole("CentralTeamUsers"))
                    {
                        this.RadDatePickerPATCompletedDate.Enabled = true;
                        this.SaveButton.Enabled = true;
                        this.CompleteButton.Enabled = true;
                    }
                    else
                    {
                        this.RadDatePickerPATCompletedDate.Enabled = false;
                        this.SaveButton.Enabled = false;
                        this.CompleteButton.Enabled = false;
                    }
                }
                else
                {
                    this.RadDatePickerPATCompletedDate.Enabled = true;

                    //lock down the date fields
                    
                }
                lblisReportable.Visible = _personForm.isReportable;
            }

        }


        protected void PrintButton_Click(object sender, EventArgs e)
        {
            if (_personFormId != 0)
            {
                GeneratePDFdata(_personFormId, _personId);
            }
        }

        private void GeneratePDFdata(int personFormId, int personId)
        {
            try
            {
                //get the data for the form

                var answers = PATFormLogic.GetPersonQuestionChoices(_personFormId);
                var personForms = PATFormLogic.GetPersonForms(_personId);
                var person = POD.Logic.PeopleLogic.GetPersonByID(_personId);
                //var currentPerson = POD.Logic.PeopleLogic.GetStaffByID(personForms.FirstOrDefault().UpdateUserName);

                MemoryStream ms = new MemoryStream();

                string sTemplate = Path.Combine(HttpContext.Current.Request.PhysicalApplicationPath, @"App_Data\pat1.pdf");

                PdfReader pdfReader = new PdfReader(sTemplate);
                PdfStamper pdfStamper = new PdfStamper(pdfReader, ms);

                PdfContentByte cb = pdfStamper.GetOverContent(1);
                AcroFields pdfFormFields = pdfStamper.AcroFields;

                //personal information == true ? "Yes" : "No"

                if (personForms.Where(x => x.PersonFormId == _personFormId).FirstOrDefault().isInitialPAT != null)
                {
                    pdfFormFields.SetField("initpat", personForms.Where(x => x.PersonFormId == _personFormId).FirstOrDefault().isInitialPAT == true ? "Yes" : "No");
                }

                if (personForms.Where(x => x.PersonFormId == _personFormId).FirstOrDefault().isInitialPAT != null)
                {
                    pdfFormFields.SetField("exitpat", personForms.Where(x => x.PersonFormId == _personFormId).FirstOrDefault().isInitialPAT == false ? "Yes" : "No");
                }


                //var test = LookUpTypesLogic.GetSiteByStaffMemberUserID(new Guid("B2DE3A76-3E63-4851-966B-DAF7E916E6E9"));

                //pdfFormFields.SetField("exitpat", personForms.Where(x => x.PersonFormId == _personFormId).FirstOrDefault().is != null ? Convert.ToDateTime(personForms.Where(x => x.PersonFormId == _personFormId).FirstOrDefault().DateCompleted).ToString("MM/dd/yyyy") : "");


                pdfFormFields.SetField("lname", person.FirstName != null ? person.LastName : "");  //
                pdfFormFields.SetField("fname", person.FirstName != null ? person.FirstName : "");  //)
                pdfFormFields.SetField("mname", person.FirstName != null ? person.MiddleName : "");  //
                pdfFormFields.SetField("dob", Convert.ToDateTime(person.DateOfBirth).ToString("MM/dd/yyyy"));



                var staffPerson = POD.Logic.PeopleLogic.GetStaffByUserName(personForms.FirstOrDefault().CreateUserName);

                if (staffPerson != null)
                {
                    var staffsite = LookUpTypesLogic.GetSiteByStaffMemberUserName(personForms.FirstOrDefault().CreateUserName.Trim());
                    //sitename
                    if (staffsite != null)
                    {
                        pdfFormFields.SetField("sitename", staffsite.SiteName != null ? staffsite.SiteName : "");
                    }

                    var s = personForms.Where(x => x.PersonFormId == _personFormId).FirstOrDefault().PATEnteredBy;

                    //pdfFormFields.SetField("completedby", staffPerson.FirstName != null ? staffPerson.FirstName + " " + staffPerson.LastName : "");
                    pdfFormFields.SetField("completedby", personForms.Where(x => x.PersonFormId == _personFormId).FirstOrDefault().PATEnteredBy != null ? personForms.Where(x => x.PersonFormId == _personFormId).FirstOrDefault().PATEnteredBy : "");

                }

                pdfFormFields.SetField("datecompleted", personForms.Where(x => x.PersonFormId == _personFormId).FirstOrDefault().DateCompleted != null ? Convert.ToDateTime(personForms.Where(x => x.PersonFormId == _personFormId).FirstOrDefault().DateCompleted).ToString("MM/dd/yyyy") : "");

                foreach (var answer in answers)
                {

                    switch (answer.ChoiceId)
                    {
                        case 247:
                        case 250:
                        case 255:
                        case 256:
                        case 257:
                        case 258:
                        case 259:
                        case 260:
                        case 261:
                        case 262:
                        case 263:
                            pdfFormFields.SetField("c" + answer.ChoiceId, answer.OtherText != null ? answer.OtherText : "");
                            break;
                        default:
                            pdfFormFields.SetField("c" + answer.ChoiceId, "Yes");
                            break;
                    }



                    //notes area & additional comments
                }




                //close up processing
                pdfStamper.FormFlattening = true;
                if (pdfStamper != null)
                { pdfStamper.Close(); }

                pdfReader.Close();

                HttpContext.Current.Response.ContentType = "application/pdf";
                HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=PODApplication_" + Guid.NewGuid() + ".pdf");
                HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);

                HttpContext.Current.Response.BinaryWrite(ms.ToArray());
            }
            catch (Exception ex)
            {
                ex.Log();
                throw;
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            _personForm = PATFormLogic.GetPersonForm(_personFormId);
            if (_personForm != null)
            {
                lblisReportable.Visible = _personForm.isReportable;
                if (!_personForm.IsComplete)
                {
                    CompleteButton.Enabled = _personForm.IsValid;
                }
                
                RadDatePickerPATCompletedDate.SelectedDate = _personForm.DateCompleted;
            }
            else
            {
                CompleteButton.Enabled = false;

            }

        }



        protected void sectionsTab_TabClick(object sender, RadTabStripEventArgs e)
        {
            // first save questions
            saveForm();

            POD.Data.PATFormData.SetCurrentSection(_personFormId, _personId, _formId, Convert.ToInt32(sectionsTab.SelectedTab.Value), HttpContext.Current.User.Identity.Name);
            getQuestions();
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            //validateSection();
            saveForm();
            validateForm();
        }

        protected void Checkbox_Click(object sender, EventArgs e)
        {
            string s = "<script language=JavaScript>alert('Hello');</script>";
            Page.ClientScript.RegisterStartupScript(this.GetType(), "test", s);
        }

        protected void CompleteButton_Click(object sender, EventArgs e)
        {
            saveForm();

            //DateTime completedDate;
            //DateTime? nullableCompletedDate = null;
            //try
            //{
            //    DateTime.TryParse(PATCompletedDate.Text, out completedDate);
            //    nullableCompletedDate = completedDate;
            //}
            //catch (Exception ex)
            //{
            //    String dummy = ex.Message;

            //}

            PATFormLogic.CompleteForm(_personFormId, HttpContext.Current.User.Identity.Name, RadDatePickerPATCompletedDate.SelectedDate);

            if (_personForm.isInitialPAT == true)
            {
                var completedDate = DateTime.Now;

                if (RadDatePickerPATCompletedDate.SelectedDate != null)
                {
                    completedDate = (DateTime)RadDatePickerPATCompletedDate.SelectedDate;
                }

                PATFormLogic.UpdateAppliedDateForEnrollment(_personId, completedDate);
            }


            validateSection();
            validateForm();
            //reqValPATCompletedDate.Enabled = true;
            //reqValPATCompletedDate.Validate();
        }

        private int getPersonSectionId()
        {
            int sectionId = 0;
            var pf = PATFormLogic.GetPersonForm(_personFormId);
            if (pf != null && pf.CurrentSectionId.HasValue)
            {
                sectionId = pf.CurrentSectionId.Value;
            }
            else
            {
                var sections = PATFormLogic.GetFormSections(_formId);
                sectionId = sections.FirstOrDefault().SectionId;
            }

            if (sectionId != 0)
            {
                sectionsTab.SelectedIndex = sectionId - 1;
            }

            return sectionId;
        }


        /// <summary>
        ///     Used to lock out fields if the click all that apply is selected
        /// </summary>
        /// <param name="_choiceId"></param>
        /// <returns></returns>
        public bool determineLockSettings(int _choiceId, int _personFormId, int _questionId)
        {
            var result = false;

            switch (_choiceId)
            {
                //handler for question #1
                case 2:
                case 3:
                case 4:
                case 5:
                    result = PATFormLogic.IsFormQuestionChoiceClickAllChecked(_personFormId, _questionId, 1);
                    break;
                case 32:
                case 33:
                case 34:
                case 35:
                case 36:
                case 268:
                    result = PATFormLogic.IsFormQuestionChoiceClickAllChecked(_personFormId, _questionId, 31);
                    break;
                case 38:
                case 39:
                case 40:
                case 41:
                case 42:
                case 43:
                case 269:
                    result = PATFormLogic.IsFormQuestionChoiceClickAllChecked(_personFormId, _questionId, 37);
                    break;
                case 206:
                case 207:
                case 208:
                case 209:
                case 210:
                case 211:
                case 212:
                    result = PATFormLogic.IsFormQuestionChoiceClickAllChecked(_personFormId, _questionId, 205);
                    break;
                case 161:
                case 162:
                    result = PATFormLogic.IsFormQuestionChoiceClickAllChecked(_personFormId, _questionId, 160);
                    break;
                case 56:
                case 57:
                case 58:
                    result = PATFormLogic.IsFormQuestionChoiceClickAllChecked(_personFormId, _questionId, 55);
                    break;
                case 67:
                case 68:
                case 69:
                case 70:
                case 71:
                    result = PATFormLogic.IsFormQuestionChoiceClickAllChecked(_personFormId, _questionId, 66);
                    break;
                case 73:
                case 74:
                case 75:
                case 76:
                case 77:
                    result = PATFormLogic.IsFormQuestionChoiceClickAllChecked(_personFormId, _questionId, 72);
                    break;
                case 79:
                case 80:
                case 81:
                case 82:
                case 83:
                case 84:
                    result = PATFormLogic.IsFormQuestionChoiceClickAllChecked(_personFormId, _questionId, 78);
                    break;
                case 156:
                case 157:
                case 158:
                case 159:
                case 266:
                    result = PATFormLogic.IsFormQuestionChoiceClickAllChecked(_personFormId, _questionId, 155);
                    break;
                case 132:
                case 133:
                case 134:
                case 135:
                case 136:
                case 137:
                case 138:
                case 139:
                case 140:
                case 141:
                case 142:
                case 143:
                case 144:
                case 145:
                    result = PATFormLogic.IsFormQuestionChoiceClickAllChecked(_personFormId, _questionId, 131);
                    break;
                case 112:
                case 113:
                case 114:
                case 115:
                case 116:
                case 117:
                case 118:
                case 119:
                case 120:
                case 264:
                    result = PATFormLogic.IsFormQuestionChoiceClickAllChecked(_personFormId, _questionId, 111);
                    break;
                case 122:
                case 123:
                case 124:
                case 125:
                case 126:
                case 127:
                case 128:
                case 129:
                case 130:
                case 270:
                case 265:
                    result = PATFormLogic.IsFormQuestionChoiceClickAllChecked(_personFormId, _questionId, 121);
                    break;
                case 170:
                case 171:
                case 172:

                    result = PATFormLogic.IsFormQuestionChoiceClickAllChecked(_personFormId, _questionId, 169);
                    break;
                default:
                    break;
            }
            return result;
        }

        private void getQuestions()
        {
            formPlaceHolder.Controls.Clear();

           
            int sectionId = getPersonSectionId();

            //get the total number of form sections.
            var sections = PATFormLogic.GetFormSections(_formId);

            //foreach loop for each section to 
            foreach (var section in sections)
            {
                

                var sectionLabel = new Label();
                sectionLabel.Text = section.SectionDescription;
                sectionLabel.Style["color"] = "black";
                sectionLabel.Font.Bold = true;
                sectionLabel.Style["font-size"] = "12pt";
                sectionLabel.ID = "sl" + section.SectionId.ToString();

                var sectionph = new PlaceHolder();
                sectionph.ID = "sec" + section.SectionId.ToString();

                sectionph.Controls.Add(sectionLabel);

                var sectionLink = new HyperLink();
                sectionLink.NavigateUrl = "#home";
                sectionLink.Text = " (Return to top)";
                sectionLink.ID = "hl" + section.SectionId.ToString();
                sectionph.Controls.Add(sectionLink);



                formPlaceHolder.Controls.Add(sectionph);
                formPlaceHolder.Controls.Add(new HtmlGenericControl("br"));

                var sectionquestions = PATFormLogic.GetFormSectionQuestions(section.SectionId);

                foreach (var question in sectionquestions)
                {
                    var lbl = new Label();
                    lbl.Text = question.QuestionText;
                    lbl.Font.Bold = true;


                    var ph = new PlaceHolder();
                    ph.ID = "questionDiv_" + question.QuestionId.ToString();
                    
                    //ph.Style.Add("padding-top", "10px");
                    ph.Controls.Add(lbl);

                    var err = new Label();
                    err.ID = "error_" + question.QuestionId.ToString();
                    err.Text = " Required";
                    err.ForeColor = System.Drawing.Color.Red;
                    err.Font.Bold = true;
                    err.Visible = false;
                    ph.Controls.Add(err);


                    //Get the formQuestion Choices
                    var choices = PATFormLogic.GetFormQuestionChoices(_personFormId, question.QuestionId);
                    foreach (var c in choices)
                    {


                        if (question.FormQuestionType.Name.ToLower() == "checkbox")
                        {


                            var chk = new CheckBox();

                            chk.ID = c.ChoiceId.ToString();
                            chk.Text = c.ChoiceText;
                            chk.Attributes.Add("name", "checkbox[]");
                            chk.EnableViewState = true;


                            //hack this has to be the first option in the group
                            //if (c.IsLockable == 1)
                            //{                                                  
                            chk.Attributes.Add("onclick", "Javascript:disablecheckboxes(this);");

                            var tmpdisabled = determineLockSettings(c.ChoiceId, _personFormId, question.QuestionId);

                            if (tmpdisabled)
                            {
                                chk.Enabled = false;
                                chk.Checked = false;
                            }
                            else
                            {
                                chk.Checked = c.IsChecked;
                            }


                            //}

                            var divC = new HtmlGenericControl("div");
                            divC.Style.Add("padding-top", "2px");
                   
                            divC.Style["margin-left"] = "15px";
                            divC.Controls.Add(chk);
                            if (c.IsRisk)
                            {
                                var span = new HtmlGenericControl("span");
                                span.Style.Add("margin-left", "5px;");
                                //span.Style.Add("back-color", "#FFE20C;");
                                //span.Style.Add("background-color", "#FFE20C;");
                                span.Style.Add("font-weight", "bold");
                                span.Style.Add("color", "black");
                                span.InnerHtml = "*";
                                divC.Controls.Add(span);
                            }

                            ph.Controls.Add(divC);
                        }
                        else if (question.FormQuestionType.Name.ToLower() == "textarea")
                        {
                            var rdo = new RadioButton();
                            rdo.ID = c.ChoiceId.ToString();
                            rdo.Text = c.ChoiceText;
                            rdo.GroupName = "Question_" + question.QuestionId.ToString();
                            rdo.EnableViewState = true;
                            rdo.Checked = true;
                            rdo.Visible = false;
                            var divC = new HtmlGenericControl("div");
                            divC.Style.Add("padding-top", "2px");
                            divC.Style.Add("margin-left", "15px");
                            divC.Controls.Add(rdo);
                            ph.Controls.Add(divC);

                        }
                        else
                        {
                            var rdo = new RadioButton();
                            rdo.ID = c.ChoiceId.ToString();
                            rdo.Text = c.ChoiceText;
                            rdo.GroupName = "Question_" + question.QuestionId.ToString();
                            rdo.EnableViewState = true;
                            rdo.Checked = c.IsChecked;

                            var divC = new HtmlGenericControl("div");
                            divC.Style.Add("padding-top", "2px");
                            divC.Style.Add("margin-left", "15px");
                            divC.Controls.Add(rdo);
                            if (c.IsRisk)
                            {
                                var span = new HtmlGenericControl("span");
                                span.Style.Add("margin-left", "5px;");
                                //span.Style.Add("back-color", "#FFE20C;");
                                //span.Style.Add("background-color", "#FFE20C;");
                                span.Style.Add("font-weight", "bold");
                                span.Style.Add("color", "black");
                                span.InnerHtml = "*";
                                divC.Controls.Add(span);
                            }
                            ph.Controls.Add(divC);

                        }

                        if (c.IsOther)
                        {
                            TextBox textbox = new TextBox();
                            RequiredFieldValidator requiredFieldValidator = new RequiredFieldValidator();
                            textbox.ID = requiredFieldValidator.ControlToValidate = c.ChoiceId.ToString() + "textOther";
                            requiredFieldValidator.SetFocusOnError = true;
                            requiredFieldValidator.Display = ValidatorDisplay.Dynamic;
                            requiredFieldValidator.CssClass = "ErrorMessage";
                            requiredFieldValidator.Text = "* Required";
                            requiredFieldValidator.Enabled = false;
                            // TODO:  need dynamic script to enable validator when button/box is checked.

                            if (question.FormQuestionType.Name.ToLower() == "textarea")
                            {

                                textbox.CausesValidation = false;
                                textbox.TextMode = TextBoxMode.MultiLine;
                                textbox.Rows = 6;
                                ph.Controls.Add(textbox);
                            }
                            else
                            {
                                textbox.CausesValidation = true;
                                textbox.Style["margin-left"] = "35px";
                                ph.Controls.Add(requiredFieldValidator);
                            }

                            textbox.MaxLength = 100;
                            textbox.Columns = 100;
                            textbox.Text = c.OtherText;
                            ph.Controls.Add(textbox);



                        }

                    }  // foreach



                    formPlaceHolder.Controls.Add(ph);
                    formPlaceHolder.Controls.Add(new HtmlGenericControl("br"));

                }

               

            }

            //########################## end of new personform section SKB ##########################


            //var s = PATFormLogic.GetFormSections(_formId).FirstOrDefault(x => x.SectionId == sectionId);
            //if (s != null)
            //{
            //    sectionHead.Text = s.SectionDescription;

            //}

            //var questions = PATFormLogic.GetFormSectionQuestions(sectionId);
            //foreach (var q in questions)
            //{
            //    var lbl = new Label();
            //    lbl.Text = q.QuestionText;

            //    var ph = new PlaceHolder();
            //    ph.ID = "questionDiv_" + q.QuestionId.ToString();

            //    //ph.Style.Add("padding-top", "10px");
            //    ph.Controls.Add(lbl);

            //    var err = new Label();
            //    err.ID = "error_" + q.QuestionId.ToString();
            //    err.Text = " Required";
            //    err.ForeColor = System.Drawing.Color.Red;
            //    err.Font.Bold = true;
            //    err.Visible = false;
            //    ph.Controls.Add(err);

            //    var choices = PATFormLogic.GetFormQuestionChoices(_personFormId, q.QuestionId);
            //    foreach (var c in choices)
            //    {


            //        if (q.FormQuestionType.Name.ToLower() == "checkbox")
            //        {


            //            var chk = new CheckBox();

            //            chk.ID = c.ChoiceId.ToString();
            //            chk.Text = c.ChoiceText;
            //            chk.Attributes.Add("name", "checkbox[]");
            //            chk.EnableViewState = true;


            //            //hack this has to be the first option in the group
            //            //if (c.IsLockable == 1)
            //            //{                                                  
            //            chk.Attributes.Add("onclick", "Javascript:disablecheckboxes(this);");

            //            var tmpdisabled = determineLockSettings(c.ChoiceId, _personFormId, q.QuestionId);

            //            if (tmpdisabled)
            //            {
            //                chk.Enabled = false;
            //                chk.Checked = false;
            //            }
            //            else
            //            {
            //                chk.Checked = c.IsChecked;
            //            }


            //            //}

            //            var divC = new HtmlGenericControl("div");
            //            divC.Style.Add("padding-top", "2px");
            //            divC.Controls.Add(chk);
            //            if (c.IsRisk)
            //            {
            //                var span = new HtmlGenericControl("span");
            //                span.Style.Add("margin-left", "5px;");
            //                //span.Style.Add("back-color", "#FFE20C;");
            //                //span.Style.Add("background-color", "#FFE20C;");
            //                span.Style.Add("font-weight", "bold");
            //                span.Style.Add("color", "black");
            //                span.InnerHtml = "*";
            //                divC.Controls.Add(span);
            //            }

            //            ph.Controls.Add(divC);
            //        }
            //        else if (q.FormQuestionType.Name.ToLower() == "textarea")
            //        {
            //            var rdo = new RadioButton();
            //            rdo.ID = c.ChoiceId.ToString();
            //            rdo.Text = c.ChoiceText;
            //            rdo.GroupName = "Question_" + q.QuestionId.ToString();
            //            rdo.EnableViewState = true;
            //            rdo.Checked = true;
            //            rdo.Visible = false;
            //            var divC = new HtmlGenericControl("div");
            //            divC.Style.Add("padding-top", "2px");
            //            divC.Controls.Add(rdo);
            //            ph.Controls.Add(divC);

            //        }
            //        else
            //        {
            //            var rdo = new RadioButton();
            //            rdo.ID = c.ChoiceId.ToString();
            //            rdo.Text = c.ChoiceText;
            //            rdo.GroupName = "Question_" + q.QuestionId.ToString();
            //            rdo.EnableViewState = true;
            //            rdo.Checked = c.IsChecked;

            //            var divC = new HtmlGenericControl("div");
            //            divC.Style.Add("padding-top", "2px");
            //            divC.Controls.Add(rdo);
            //            if (c.IsRisk)
            //            {
            //                var span = new HtmlGenericControl("span");
            //                span.Style.Add("margin-left", "5px;");
            //                //span.Style.Add("back-color", "#FFE20C;");
            //                //span.Style.Add("background-color", "#FFE20C;");
            //                span.Style.Add("font-weight", "bold");
            //                span.Style.Add("color", "black");
            //                span.InnerHtml = "*";
            //                divC.Controls.Add(span);
            //            }
            //            ph.Controls.Add(divC);

            //        }

            //        if (c.IsOther)
            //        {
            //            TextBox textbox = new TextBox();
            //            RequiredFieldValidator requiredFieldValidator = new RequiredFieldValidator();
            //            textbox.ID = requiredFieldValidator.ControlToValidate = c.ChoiceId.ToString() + "textOther";
            //            requiredFieldValidator.SetFocusOnError = true;
            //            requiredFieldValidator.Display = ValidatorDisplay.Dynamic;
            //            requiredFieldValidator.CssClass = "ErrorMessage";
            //            requiredFieldValidator.Text = "* Required";
            //            requiredFieldValidator.Enabled = false;
            //            // TODO:  need dynamic script to enable validator when button/box is checked.

            //            if (q.FormQuestionType.Name.ToLower() == "textarea")
            //            {

            //                textbox.CausesValidation = false;
            //                textbox.TextMode = TextBoxMode.MultiLine;
            //                textbox.Rows = 6;
            //                ph.Controls.Add(textbox);
            //            }
            //            else
            //            {
            //                textbox.CausesValidation = true;
            //                ph.Controls.Add(requiredFieldValidator);
            //            }

            //            textbox.MaxLength = 100;
            //            textbox.Columns = 60;
            //            textbox.Text = c.OtherText;
            //            ph.Controls.Add(textbox);



            //        }

            //    }  // foreach



            //    formPlaceHolder.Controls.Add(ph);
            //    formPlaceHolder.Controls.Add(new HtmlGenericControl("br"));

            //}

            // we are trying to complete
            if (txtComplete.Text == "1")
            {
                validateForm();
            }

        }

        //private void FindPlaceholdersRecursive(Control control, List<PlaceHolder> placeholderList)
        //{
        //    foreach (var ph in formPlaceHolder.Controls.OfType<PlaceHolder>())
        //    {
        //        if (ph is PlaceHolder)
        //        {
        //            // If the control is a Placeholder, add it to the list
        //            PlaceHolder placeholder = (PlaceHolder)ph;
        //            placeholderList.Add(placeholder);
        //        }
        //        else
        //        {
        //            // If the control is not a Placeholder, recursively search its children
        //            FindPlaceholdersRecursive(ph, placeholderList);
        //        }
        //    }
        //}

        private void saveForm()
        {
            //List<PlaceHolder> placeholderList = new List<PlaceHolder>();

            //FindPlaceholdersRecursive(this, placeholderList);

            foreach (var ph in formPlaceHolder.Controls.OfType<PlaceHolder>())
            {
                
                if (ph.ID.StartsWith("questionDiv"))
                {
               
                    var questionId = Convert.ToInt32(ph.ID.Replace("questionDiv_", ""));
                    var choiceIds = new List<int>();
                    var choices = PATFormLogic.GetFormQuestionChoices(_personFormId, questionId);

                    foreach (var choice in choices)
                    {
                        var ctl = ph.FindControl(choice.ChoiceId.ToString());
                        if (ctl.GetType().Name == "CheckBox")
                        {
                            var chk = (CheckBox)ctl;
                            if (chk.Checked)
                            {
                                choiceIds.Add(Convert.ToInt32(chk.ID));
                                if (choice.IsOther)
                                {
                                    TextBox textbox = (TextBox)ph.FindControl(chk.ID + "textOther");
                                    choice.OtherText = textbox.Text;
                                }

                            }

                        }
                        else
                        {
                            var rdo = (RadioButton)ctl;
                            if (rdo.Checked)
                            {
                                choiceIds.Add(Convert.ToInt32(rdo.ID));
                                if (choice.IsOther)
                                {
                                    TextBox textbox = (TextBox)ph.FindControl(rdo.ID + "textOther");
                                    choice.OtherText = textbox.Text;

                                }
                            }

                        }
                    }                

                    var pfId = PATFormLogic.SaveQuestion(_personFormId, _personId, _formId, questionId, choiceIds, choices, HttpContext.Current.User.Identity.Name);
                    _personFormId = pfId;
                }
            }

            // The questions are saved.  Now save the form.
            _personForm = PATFormLogic.GetPersonForm(_personFormId);
            _personForm.DateCompleted = RadDatePickerPATCompletedDate.SelectedDate;

            var test = this.txtpatenteredby.Text;

            bool tmpValue = false;
            bool? _isInitialPAT = null;

            if (this.rbisInitialPAT.SelectedIndex != -1)
            {
                bool.TryParse(this.rbisInitialPAT.SelectedValue, out tmpValue);
                _isInitialPAT = tmpValue;
            }
            _personForm.isInitialPAT = _isInitialPAT;

            _personForm.PATEnteredBy = this.txtpatenteredby.Text;


            PATFormLogic.SavePersonForm(_personForm, HttpContext.Current.User.Identity.Name);

            if (_personForm.isInitialPAT == true && _personForm.DateCompleted != null)
            {

                PATFormLogic.UpdateAppliedDateForEnrollment(_personId, (DateTime)_personForm.DateCompleted);
            }

        }

        private void validateSection()
        {
            foreach (var ph in formPlaceHolder.Controls.OfType<PlaceHolder>())
            {
                if (ph.ID.StartsWith("questionDiv"))
                {
                    var questionId = Convert.ToInt32(ph.ID.Replace("questionDiv_", ""));
                    var choices = PATFormLogic.GetFormQuestionChoices(_personFormId, questionId);
                    var hasOneChecked = false;

                    foreach (var choice in choices)
                    {
                        var ctl = ph.FindControl(choice.ChoiceId.ToString());
                        if (ctl.GetType().Name == "CheckBox" && ((CheckBox)ctl).Checked)
                        {
                            hasOneChecked = true;
                        }
                        else if (ctl.GetType().Name == "RadioButton" && ((RadioButton)ctl).Checked)
                        {
                            hasOneChecked = true;
                        }
                    }

                    var err = ph.FindControl("error_" + questionId.ToString());
                    err.Visible = !hasOneChecked;
                }

            }
        }

        private void validateForm()
        {
            var questions = PATFormLogic.GetFormQuestions(_formId);
            var answers = PATFormLogic.GetPersonQuestionChoices(_personFormId);
            var invalidTabIds = new List<int>();
            var isValid = true;
            lblErrors.Visible = false;

            var riskTabs = new List<int>();

            foreach (var q in questions)
            {
                var qAnswers = answers.Where(x => x.FormQuestionChoice.QuestionId == q.QuestionId).Select(x => x).ToList();

                if (!answers.Any(x => x.FormQuestionChoice.QuestionId == q.QuestionId) && q.FormQuestionType.Name.ToLower() != "textarea")
                {
                    invalidTabIds.Add(q.SectionId);
                    isValid = false;
                    lblErrors.Visible = true;
                }
                else
                {
                    // for a question that has been answered...
                    if (qAnswers.Any(x => x.FormQuestionChoice.IsRisk == true))
                    {
                        // if any of the answers are risk factors, then add the sectionId to a list
                        riskTabs.Add(q.SectionId);
                    }
                }
            }

            // only turn on the Completed Date validator when the rest of the form is valid
            if (isValid)
            {
                reqValPATCompletedDate.Enabled = true;
                reqValPATCompletedDate.Validate();
            }

            isValid &= (RadDatePickerPATCompletedDate.SelectedDate != null);

            if (_personForm.IsComplete)
            {
                txtComplete.Text = "1";
                //validateForm();
                //validateSection();

                //only enable the Completed date
                if (Security.UserInRole("Administrators") || Security.UserInRole("CentralTeamUsers"))
                {
                    this.RadDatePickerPATCompletedDate.Enabled = true;
                    this.SaveButton.Enabled = true;
                    this.CompleteButton.Enabled = true;
                }
                else
                {
                    this.RadDatePickerPATCompletedDate.Enabled = false;
                    this.SaveButton.Enabled = false;
                    this.CompleteButton.Enabled = false;
                }
            }
            else
            {
                this.RadDatePickerPATCompletedDate.Enabled = true;

                //lock down the date fields

            }
            // business rule:  if risk factors are present on 3 or more sections ("domains" to the business owner),
            // then this PAT is reportable.
            bool isReportable = ((from x in riskTabs select x).Distinct().Count() >= 3);
            //lblisReportable.Visible = isReportable;

            foreach (RadTab tab in sectionsTab.Tabs)
            {
                if (invalidTabIds.Contains(Convert.ToInt32(tab.Value)))
                {
                    tab.BackColor = System.Drawing.Color.Red;
                    tab.ForeColor = System.Drawing.Color.White;
                }
                else
                {
                    tab.BackColor = System.Drawing.Color.Empty;
                    tab.ForeColor = System.Drawing.Color.Empty;
                }
            }

            PATFormLogic.MarkFormAsValidOrInvalid(_personFormId, HttpContext.Current.User.Identity.Name, isValid, isReportable);

        }
    }

}