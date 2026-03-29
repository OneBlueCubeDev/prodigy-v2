using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using POD.Data;
using POD.Data.Entities;
using POD.Logic;
using Telerik.Web.UI;

namespace POD.Pages.Admin.ManageContracts
{
    public partial class ContractPage : Page
    {
        protected int ContractID
        {
            get { return Convert.ToInt32(Request.QueryString["id"] ?? "0"); }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Page.IsPostBack == false)
            {
                Bind();
            }
            RadGridQuotas.Visible = ContractID > 0;
            LiteralError.Visible = false;
            LabelFeedback.Visible = false;
        }

        private void Bind()
        {
            if (ContractID > 0)
            {
                Contract contract = ContractLogic.GetContractByID(ContractID);
                if (contract != null)
                {
                    TextBoxContractNumber.Text = contract.ContractNumber;
                    RadComboLocation.SelectedValue = contract.Site != null
                                                         ? contract.Site.SiteLocationID.ToString()
                                                         : string.Empty;
                    RadComboProgram.SelectedValue = contract.Program != null
                                                        ? contract.Program.ProgramID.ToString()
                                                        : string.Empty;
                    RadComboLocation.SelectedValue = contract.Site != null
                                                         ? contract.Site.LocationID.ToString()
                                                         : string.Empty;
                    RadComboStatus.SelectedValue = contract.StatusTypeID.ToString();
                    RadStartDatePicker.SelectedDate = contract.DateStart;
                    RadEndDatePicker.SelectedDate = contract.DateEnd;
                }
            }
        }

        protected void ButtonSave_OnClick(object sender, EventArgs e)
        {
            int? locationId = string.IsNullOrEmpty(RadComboLocation.SelectedValue)
                                  ? (int?) null
                                  : Convert.ToInt32(RadComboLocation.SelectedValue);
            int? programId = string.IsNullOrEmpty(RadComboProgram.SelectedValue)
                                 ? (int?) null
                                 : Convert.ToInt32(RadComboProgram.SelectedValue);
            int statusId = Convert.ToInt32(RadComboStatus.SelectedValue);


            if (Page.IsValid)
            {
                int id;

                if (locationId != null)
                {
                    id = ContractLogic.AddUpdateContractForSite(
                        ContractID,
                        statusId,
                        TextBoxContractNumber.Text,
                        RadStartDatePicker.SelectedDate,
                        RadEndDatePicker.SelectedDate,
                        locationId.Value);
                }
                else if (programId != null)
                {
                    id = ContractLogic.AddUpdateContractForProgram(
                        ContractID,
                        statusId,
                        TextBoxContractNumber.Text,
                        RadStartDatePicker.SelectedDate,
                        RadEndDatePicker.SelectedDate,
                        programId.Value);
                }
                else
                {
                    id = ContractLogic.AddUpdateContract(
                        ContractID,
                        statusId,
                        TextBoxContractNumber.Text,
                        RadStartDatePicker.SelectedDate,
                        RadEndDatePicker.SelectedDate);
                }

                if (id == 0)
                {
                    LiteralError.Visible = true;
                    LiteralError.Text =
                        string.Format("<b style='color:red;'>An error occured trying to save the contract:{0}</b>",
                                      TextBoxContractNumber.Text);
                }
                else if (!(ContractID > 0))
                {
                    Response.Redirect(string.Format("ContractPage.aspx?id={0}", id));
                }
                else
                {
                    Response.Redirect("ContractManagement.aspx");
                }
            }
        }

        protected void RadGridQuotas_OnNeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            var grid = (RadGrid) sender;
            grid.DataSource = ContractLogic.GetContractEnrollmentQuotaBySearch(ContractID);
        }

        protected void RadGridQuotas_OnDeleteCommand(object sender, GridCommandEventArgs e)
        {
            var item = (GridDataItem)e.Item;
            int contractId = Convert.ToInt32(item.GetDataKeyValue("ContractID"));
            int enrollmentTypeId = Convert.ToInt32(item.GetDataKeyValue("EnrollmentTypeID"));
            string name = item["EnrollmentTypeColumn"].Text;

            string message;
            if (ContractLogic.DeleteContractEnrollmentQuota(contractId, enrollmentTypeId, out message) == false)
            {
                LabelFeedback.Visible = true;
                LabelFeedback.Text =
                    string.Format(
                        "<b style='color:red;'>An error occured trying to delete the enrollment quota:{0}</b><br/>Message:{1}", name, message);
            }
        }

        protected void RadGridQuotas_OnUpdateCommand(object sender, GridCommandEventArgs e)
        {
            var item = e.Item as GridEditableItem;
            if (item != null)
            {
                int enrollmentTypeId = Convert.ToInt32(item.GetDataKeyValue("EnrollmentTypeID"));
                int contractId = Convert.ToInt32(item.GetDataKeyValue("ContractID"));
                var newValues = new Dictionary<string, string>();
                item.OwnerTableView.ExtractValuesFromItem(newValues, item);

                int oldAmount;
                int oldLength;
                int oldHours;
                int.TryParse(item.SavedOldValues["Amount"].ToString(), out oldAmount);
                int.TryParse(item.SavedOldValues["ExpectedLengthInDays"].ToString(), out oldLength);
                int.TryParse(item.SavedOldValues["RequiredProgrammingHours"].ToString(), out oldHours);

                int newAmount;
                int newLength;
                int newHours;
                if (int.TryParse(newValues["Amount"], out newAmount)
                    && int.TryParse(newValues["ExpectedLengthInDays"], out newLength)
                    && int.TryParse(newValues["RequiredProgrammingHours"], out newHours))
                {
                    if (oldAmount != newAmount
                        || oldLength != newLength
                        || oldHours != newHours)
                    {
                        if (ContractLogic.AddUpdateContractEnrollmentQuota(
                            contractId,
                            enrollmentTypeId,
                            newAmount,
                            newLength,
                            newHours) == false)
                        {
                            LabelFeedback.Visible = true;
                            LabelFeedback.Text = "There was an error saving the Contract Enrollment Quota.";
                        }
                    }
                }
            }
        }

        protected void EntityEnrollmentTypeDataSource_OnSelecting(object sender, LinqDataSourceSelectEventArgs e)
        {
            var result = ManageTypesLogic.GetTypesByType(TypesData.Types.EnrollmentType) as List<EnrollmentType>;

            List<int> ids = RadGridQuotas.MasterTableView.Items.Cast<GridDataItem>()
                .Select(item => Convert.ToInt32(item.GetDataKeyValue("EnrollmentTypeID"))).ToList();
            if (result != null)
            {
                e.Result = result.Where(x => ids.Any(id => id == x.EnrollmentTypeID) == false).ToList();
            }
        }

        protected void RadGridQuotas_OnInsertCommand(object sender, GridCommandEventArgs e)
        {
            var item = e.Item as GridEditableItem;
            if (item != null)
            {
                int contractId = ContractID;
                var values = new Dictionary<string, string>();
                item.ExtractValues(values);

                int amount;
                int length;
                int hours;
                int enrollmentTypeId;
                if (int.TryParse(values["Amount"], out amount)
                    && int.TryParse(values["ExpectedLengthInDays"], out length)
                    && int.TryParse(values["RequiredProgrammingHours"], out hours)
                    && int.TryParse(values["EnrollmentTypeID"], out enrollmentTypeId))
                {
                    if (ContractLogic.AddUpdateContractEnrollmentQuota(
                        contractId,
                        enrollmentTypeId,
                        amount,
                        length,
                        hours) == false)
                    {
                        LabelFeedback.Visible = true;
                        LabelFeedback.Text = "There was an error saving the Contract Enrollment Quota.";
                    }
                }
            }
        }

        protected void RadgridQuotas_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item.ItemType == GridItemType.Item || e.Item.ItemType == GridItemType.AlternatingItem)
            {
                //if not admin then no deleting, eidting or adding quotas
                if (!Security.UserInRole("Administrators"))
                {
                    e.Item.OwnerTableView.Columns.FindByUniqueName("EditColumn").Visible = false;
                    e.Item.OwnerTableView.Columns.FindByUniqueName("DeleteColumn").Visible = false;

                }
            }
        }
    }
}