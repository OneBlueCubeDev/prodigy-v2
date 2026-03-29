using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using POD.Data.Entities;

namespace POD.UserControls
{
    public partial class ReleaseForm : System.Web.UI.UserControl
    {
        private int personid = 0;
        private int enrollID = 0;
        private string releaseType = string.Empty;

        public bool AutoSelectReleased { get; set; }
       
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
        public int EnrollmentID
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
        public string ReleaseType
        {
            get
            {
                if (ViewState["ReleaseType"] != null)
                {
                    releaseType = ViewState["ReleaseType"].ToString();
                }
                return releaseType;
            }
            set
            {
                ViewState["ReleaseType"] = value;
            }
        }
        Enrollment currentEnrollment = null;
        RiskAssessment currentRA = null;

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!string.IsNullOrEmpty(Request.QueryString["type"]))
            {
                ReleaseType = Request.QueryString["type"];
            }
            if (!string.IsNullOrEmpty(Request.QueryString["pid"]))
            {
                int.TryParse(Request.QueryString["pid"].ToString(), out personid);
                PersonID = personid;
            }
            if (!string.IsNullOrEmpty(Request.QueryString["eid"]))
            {
                int.TryParse(Request.QueryString["eid"].ToString(), out enrollID);
                EnrollmentID = enrollID;
            }

            if (!string.IsNullOrEmpty(ReleaseType))
            {
                if (ReleaseType == "RA")
                {
                    if (EnrollmentID != 0)
                    {
                        currentRA = POD.Logic.PersonRelatedLogic.GetRiskAssessmentByID(enrollID);
                        if (currentRA != null && currentRA.Enrollments.Count > 0)
                        {
                            currentEnrollment = currentRA.Enrollments.OrderByDescending(en => en.DateApplied).FirstOrDefault();
                        }
                    }
                }
                else
                {
                    if (EnrollmentID != 0)
                    {
                        currentEnrollment = POD.Logic.PersonRelatedLogic.GetEnrollmentByID(enrollID);
                    }
                }
            }
            if (!IsPostBack)
            {
                LoadData();
            }
        }
        private void LoadData()
        {
            var list = (List<StatusType>)POD.Logic.ManageTypesLogic.GetTypesByType(Data.TypesData.Types.StatusType);
            RadComboBoxStatus.DataSource = list.Where(st => st.Category == "Enrollment");
            RadComboBoxStatus.DataBind();
            
            if (currentEnrollment != null)
            {
                this.RadDatePickerReleaseDate.SelectedDate = currentEnrollment.RelDate;

                ListItem relReason = this.RadioButtonListRelReason.Items.FindByValue(currentEnrollment.RelReasonForLeaving);
                if (relReason != null)
                {
                    relReason.Selected = true;
                }
                ListItem relAgency = this.RadioButtonListReleaseAgency.Items.FindByValue(currentEnrollment.RelAgency);
                if (relAgency != null)
                {
                    relAgency.Selected = true;
                }
                if (AutoSelectReleased
                    && currentEnrollment.RelDate == null)
                {
                    RadComboBoxItem item =
                        this.RadComboBoxStatus.Items.FindItemByText("Released");
                    if (item != null)
                    {
                        item.Selected = true;
                    }
                }
                else
                {
                    RadComboBoxItem item = this.RadComboBoxStatus.Items.FindItemByValue(currentEnrollment.StatusTypeID.ToString());
                    if (item != null)
                    {
                        item.Selected = true;
                    }
                }
            }
            else if (currentRA != null)
            {
                this.RadDatePickerReleaseDate.SelectedDate = currentRA.RelDate;
                ListItem relReason = this.RadioButtonListRelReason.Items.FindByValue(currentRA.RelReasonForLeaving);
                if (relReason != null)
                {
                    relReason.Selected = true;
                }
                ListItem relAgency = this.RadioButtonListReleaseAgency.Items.FindByValue(currentRA.RelAgency);
                if (relAgency != null)
                {
                    relAgency.Selected = true;
                }
                if (currentRA.RelDate == null)
                {
                    RadComboBoxItem item =
                        this.RadComboBoxStatus.Items.FindItemByText("Released");
                    if (item != null)
                    {
                        item.Selected = true;
                    }
                }
                else
                {
                    RadComboBoxItem item =
                        this.RadComboBoxStatus.Items.FindItemByValue(currentRA.StatusTypeID.ToString());
                    if (item != null)
                    {
                        item.Selected = true;
                    }
                }
            }
        }

        /// <summary>
        /// saves release data and update enrollment status
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                int statusid = 0;
                int riskID = 0;
                int.TryParse(this.RadComboBoxStatus.SelectedValue, out statusid);
                if (currentRA != null)
                {
                    currentRA.RelAgency = this.RadioButtonListReleaseAgency.SelectedIndex != -1 ? this.RadioButtonListReleaseAgency.SelectedValue : string.Empty;
                    currentRA.RelReasonForLeaving = this.RadioButtonListRelReason.SelectedIndex != -1 ? this.RadioButtonListRelReason.SelectedValue : string.Empty;
                    currentRA.RelDate = this.RadDatePickerReleaseDate.SelectedDate;
                    currentRA.StatusTypeID = statusid;
                    riskID = POD.Logic.PersonRelatedLogic.AddUpdateRiskAssessment(currentRA);
                }

                if (EnrollmentID != 0)
                {
                    POD.Logic.PersonRelatedLogic.ReleaseEnrollment(EnrollmentID, statusid, this.RadDatePickerReleaseDate.SelectedDate.HasValue ? this.RadDatePickerReleaseDate.SelectedDate.Value : DateTime.Now,
                                        this.RadioButtonListReleaseAgency.SelectedIndex != -1 ? this.RadioButtonListReleaseAgency.SelectedValue : string.Empty,
                                                                 this.RadioButtonListRelReason.SelectedIndex != -1 ? this.RadioButtonListRelReason.SelectedValue : string.Empty);
                }
                if (EnrollmentID != 0 )
                {
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "CallPArentFunc", "returnToParent();", true);
                }
                else
                {
                    LiteralErrorMsg.Visible = true;
                    LiteralErrorMsg.Text = "<p>An error occured, please contact your System Administrator</p>";
                }
            }
            else
            {
                LiteralErrorMsg.Visible = true;
                LiteralErrorMsg.Text = "<p>An error occured, please contact your System Administrator</p>";
            }

        }
    }
}