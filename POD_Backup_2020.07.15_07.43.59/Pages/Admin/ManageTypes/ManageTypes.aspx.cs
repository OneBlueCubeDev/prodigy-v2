using POD.Logic;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace POD.Admin.ManageTypes
{
    public partial class ManageTypes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDropDown();
                RadGridTypes.Rebind();
            }
        }

        public object GetData()
        {
            object list = null;
            Data.TypesData.Types currentType = (Data.TypesData.Types)Enum.Parse(typeof(Data.TypesData.Types), this.ComboBoxType.SelectedItem.Text, true);

            switch (currentType)
            {
                case Data.TypesData.Types.AddressType:
                    list = ((List<Data.Entities.AddressType>)POD.Logic.ManageTypesLogic.GetTypesByType(currentType)).ToList().Select(t => new { ID = t.AddressTypeID, Name = t.Name, IsActive = t.IsActive, Description = t.Description, Category = "" });
                    break;
                case Data.TypesData.Types.ClassType:
                    list = ((List<Data.Entities.ClassType>)POD.Logic.ManageTypesLogic.GetTypesByType(currentType)).ToList().Select(t => new { ID = t.ClassTypeID, Name = t.Name, IsActive = t.IsActive, Description = t.Description, Category = "" });
                    break;
                case Data.TypesData.Types.CourseType:
                    list = ((List<Data.Entities.CourseType>)POD.Logic.ManageTypesLogic.GetTypesByType(currentType)).ToList().Select(t => new { ID = t.CourseTypeID, Name = t.Name, IsActive = t.IsActive, Description = t.Description, Category = "" });
                    break;
                case Data.TypesData.Types.PersonalDevelopmentType:
                    list = ((List<Data.Entities.DisciplineType>)POD.Logic.ManageTypesLogic.GetTypesByType(currentType)).ToList().Select(t => new { ID = t.DisciplineTypeID, Name = t.Name, IsActive = t.IsActive, Description = t.Description, Category = "" });
                    break;
                case Data.TypesData.Types.InventoryItemType:
                    list = ((List<Data.Entities.InventoryItemType>)POD.Logic.ManageTypesLogic.GetTypesByType(currentType)).ToList().Select(t => new { ID = t.InventoryItemTypeID, Name = t.Name, IsActive = t.IsActive, Description = t.Description, Category = "" });
                    break;
                case Data.TypesData.Types.EnrollmentType:
                    list = ((List<Data.Entities.EnrollmentType>)POD.Logic.ManageTypesLogic.GetTypesByType(currentType)).ToList().Select(t => new { ID = t.EnrollmentTypeID, Name = t.Name, IsActive = t.IsActive, Description = t.Description, Category = "" });
                    break;
                case Data.TypesData.Types.EventType:
                    list = ((List<Data.Entities.EventType>)POD.Logic.ManageTypesLogic.GetTypesByType(currentType)).ToList().Select(t => new { ID = t.EventTypeID, Name = t.Name, IsActive = t.IsActive, Description = t.Description, Category = "" });
                    break;
                case Data.TypesData.Types.LessonPlanType:
                    list = ((List<Data.Entities.LessonPlanType>)POD.Logic.ManageTypesLogic.GetTypesByType(currentType)).ToList().Select(t => new { ID = t.LessonPlanTypeID, Name = t.Name, IsActive = t.IsActive, Description = t.Description, Category = "" });
                    break;
                case Data.TypesData.Types.LifeSkillType:
                    list = ((List<Data.Entities.LifeSkillType>)POD.Logic.ManageTypesLogic.GetTypesByType(currentType)).ToList().Select(t => new { ID = t.LifeSkillTypeID, Name = t.Name, IsActive = t.IsActive, Description = t.Description, Category = "" });
                    break;
                case Data.TypesData.Types.LocationType:
                    list = ((List<Data.Entities.LocationType>)POD.Logic.ManageTypesLogic.GetTypesByType(currentType)).ToList().Select(t => new { ID = t.LocationTypeID, Name = t.Name, IsActive = t.IsActive, Description = t.Description, Category = "" });
                    break;
                case Data.TypesData.Types.PersonRelationshipType:
                    list = ((List<Data.Entities.PersonRelationshipType>)POD.Logic.ManageTypesLogic.GetTypesByType(currentType)).ToList().Select(t => new { ID = t.PersonRelationshipTypeID, Name = t.Name, IsActive = t.IsActive, Description = t.Description, Category = "" });
                    break;
                case Data.TypesData.Types.PersonType:
                    list = ((List<Data.Entities.PersonType>)POD.Logic.ManageTypesLogic.GetTypesByType(currentType)).ToList().Select(t => new { ID = t.PersonTypeID, Name = t.Name, IsActive = t.IsActive, Description = t.Description, Category = "" });
                    break;
                case Data.TypesData.Types.PhoneNumberType:
                    list = ((List<Data.Entities.PhoneNumberType>)POD.Logic.ManageTypesLogic.GetTypesByType(currentType)).ToList().Select(t => new { ID = t.PhoneNumberTypeID, Name = t.Name, IsActive = t.IsActive, Description = t.Description, Category = "" });
                    break;
                case Data.TypesData.Types.ProgramType:
                    list = ((List<Data.Entities.ProgramType>)POD.Logic.ManageTypesLogic.GetTypesByType(currentType)).ToList().Select(t => new { ID = t.ProgramTypeID, Name = t.Name, IsActive = t.IsActive, Description = t.Description, Category = "" });
                    break;
                case Data.TypesData.Types.ReferralType:
                    list = ((List<Data.Entities.ReferralType>)POD.Logic.ManageTypesLogic.GetTypesByType(currentType)).ToList().Select(t => new { ID = t.ReferralTypeID, Name = t.Name, IsActive = t.IsActive, Description = t.Description, Category = "" });
                    break;
                case Data.TypesData.Types.ReferringAgencyType:
                    list = ((List<Data.Entities.ReferringAgencyType>)POD.Logic.ManageTypesLogic.GetTypesByType(currentType)).ToList().Select(t => new { ID = t.ReferringAgencyTypeID, Name = t.Name, IsActive = t.IsActive, Description = t.Description, Category = "" });
                    break;
                case Data.TypesData.Types.StatusType:
                    list = ((List<Data.Entities.StatusType>)POD.Logic.ManageTypesLogic.GetTypesByType(currentType)).ToList().Select(t => new { ID = t.StatusTypeID, Name = t.Name, IsActive = t.IsActive, Description = t.Description, Category = t.Category });
                    break;
                case Data.TypesData.Types.TimePeriodType:
                    list = ((List<Data.Entities.TimePeriodType>)POD.Logic.ManageTypesLogic.GetTypesByType(currentType)).ToList().Select(t => new { ID = t.TimePeriodTypeID, Name = t.Name, IsActive = t.IsActive, Description = t.Description, Category = "" });
                    break;
                case Data.TypesData.Types.NoteContactType:
                    list = ((List<Data.Entities.NoteContactType>)POD.Logic.ManageTypesLogic.GetTypesByType(currentType)).ToList().Select(t => new { ID = t.NoteContactTypeID, Name = t.Name, IsActive = t.IsActive, Description = t.Description, Category = "" });
                    break;
            }
            return list;
        }

        private void LoadDropDown()
        {                     
            this.ComboBoxType.DataSource = POD.Logic.ManageTypesLogic.GetTypesTypes();
            this.ComboBoxType.DataBind();
        }

        protected void RadGridTypes_InsertCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            Data.TypesData.Types currentType = (Data.TypesData.Types)Enum.Parse(typeof(Data.TypesData.Types), this.ComboBoxType.SelectedItem.Text, true);

            var item = e.Item as GridEditableItem;
            //Set new values
            var newValues = new Hashtable();
            //The GridTableView will fill the values from all editable columns in the hash
            e.Item.OwnerTableView.ExtractValuesFromItem(newValues, item);
            var list = (RadioButtonList)item.FindControl("RadiobuttonList");
            var nameBox = (TextBox)item.FindControl("TextBoxName");
            var editor = (TextBox)item.FindControl("RadEditoDesc");
            var isactive = false;
            bool.TryParse(list.SelectedValue, out isactive);
            var category = string.Empty;
            if (currentType == Data.TypesData.Types.StatusType)
            {
                var ddl = (DropDownList)item.FindControl("DropdownListCategory");
                if (ddl != null)
                {
                    category = ddl.SelectedValue;
                }
            }
            POD.Logic.ManageTypesLogic.AddUpdateType(currentType, nameBox.Text.Trim(), editor.Text, isactive, 0, category);
        }

        protected void RadGridTypes_UpdateCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            Data.TypesData.Types currentType = (Data.TypesData.Types)Enum.Parse(typeof(Data.TypesData.Types), this.ComboBoxType.SelectedItem.Text, true);

            var item = e.Item as GridEditableItem;
            var id = item.GetDataKeyValue("ID").ToString();
            //Set new values
            var newValues = new Hashtable();
            //The GridTableView will fill the values from all editable columns in the hash
            e.Item.OwnerTableView.ExtractValuesFromItem(newValues, item);
            var list = (RadioButtonList)item.FindControl("RadiobuttonList");
            var nameBox = (TextBox)item.FindControl("TextBoxName");
            var editor = (TextBox)item.FindControl("RadEditoDesc");
            var category = string.Empty;
            if (currentType == Data.TypesData.Types.StatusType)
            {
                var ddl = (DropDownList)item.FindControl("DropdownListCategory");
                if (ddl != null)
                {
                    category = ddl.SelectedValue.ToString();
                }
            }
            var isactive = false;
            bool.TryParse(list.SelectedValue, out isactive);
            var currentID = 0;
            int.TryParse(id, out currentID);
            POD.Logic.ManageTypesLogic.AddUpdateType(currentType, nameBox.Text.Trim(), editor.Text, isactive, currentID, category);

        }

        protected void RadGridTypes_Delete(object sender, GridCommandEventArgs e)
        {
            Data.TypesData.Types currentType = (Data.TypesData.Types)Enum.Parse(typeof(Data.TypesData.Types), this.ComboBoxType.SelectedItem.Text, true);
            var ID = (e.Item as GridDataItem).OwnerTableView.DataKeyValues[e.Item.ItemIndex]["ID"].ToString();
            var currentID = 0;
            int.TryParse(ID, out currentID);
            POD.Logic.ManageTypesLogic.DeleteType(currentType, currentID);

        }

        protected void RadGridTypes_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            var types = (RadGrid)sender;
            types.DataSource = GetData();
        }

        protected void ComboBoxType_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            switch (e.Text)
            {
                case "AgeGroup":
                    this.PanelTypes.Visible = false;
                    this.PanelAgeGroups.Visible = true;
                    this.PanelTimePeriods.Visible = false;
                    this.RadGridAgeGroup.Rebind();
                    break;
                case "TimePeriod":
                    this.PanelTypes.Visible = false;
                    this.PanelAgeGroups.Visible = false;
                    this.PanelTimePeriods.Visible = true;
                    this.RadGridTimePeriods.Rebind();
                    break;
                default:
                    this.PanelTypes.Visible = true;
                    this.PanelAgeGroups.Visible = false;
                    this.PanelTimePeriods.Visible = false;
                    RadGridTypes.Rebind();
                    break;
            }
        }

        protected void RadGridTypes_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridEditFormItem && e.Item.IsInEditMode)
            {
                var editItem = (GridEditFormItem)e.Item;

                if (editItem != null)
                {
                    Data.TypesData.Types currentType = (Data.TypesData.Types)Enum.Parse(typeof(Data.TypesData.Types), this.ComboBoxType.SelectedItem.Text, true);
                    if (editItem.DataItem is GridInsertionObject)
                    {
                        if (currentType == Data.TypesData.Types.StatusType)
                        {
                            var statusCatPanel = (Panel)editItem.FindControl("PanelStatusCategory");
                            var validator = (RequiredFieldValidator)editItem.FindControl("RequiredFieldValidatorStatusCategory");

                            validator.Enabled = true;
                            statusCatPanel.Visible = true;
                        }
                    }
                    else
                    {
                        var value = POD.Logic.Utilities.GetValueFromAnonymousType<bool>(editItem.DataItem, "IsActive");
                        var name = POD.Logic.Utilities.GetValueFromAnonymousType<string>(editItem.DataItem, "Name");
                        var desc = POD.Logic.Utilities.GetValueFromAnonymousType<string>(editItem.DataItem, "Description");
                        var nameBox = (TextBox)editItem.FindControl("TextBoxName");
                        var editor = (TextBox)editItem.FindControl("RadEditoDesc");
                        var list = (RadioButtonList)editItem.FindControl("RadiobuttonList");
                        if (nameBox != null)
                        {
                            nameBox.Text = name;
                        }
                        if (editor != null)
                        {
                            editor.Text = desc;
                        }
                        if (list != null)
                        {
                            var listItem = list.Items.FindByValue(value.ToString());
                            if (listItem != null)
                            {
                                listItem.Selected = true;
                            }
                        }
                        if (currentType == Data.TypesData.Types.StatusType)
                        {
                            var statusCatPanel = (Panel)editItem.FindControl("PanelStatusCategory");
                            var validator = (RequiredFieldValidator)editItem.FindControl("RequiredFieldValidatorStatusCategory");
                            var ddl = (DropDownList)editItem.FindControl("DropdownListCategory");

                            var category = POD.Logic.Utilities.GetValueFromAnonymousType<string>(editItem.DataItem, "Category");
                            if (ddl != null)
                            {
                                var item = ddl.Items.FindByValue(category);
                                if (item != null)
                                {
                                    item.Selected = true;
                                }
                            }
                            validator.Enabled = true;
                            statusCatPanel.Visible = true;
                        }
                    }
                }
            }
        }

        #region Age Groups
        protected void RadGridAgeGroup_InsertCommand(object sender, GridCommandEventArgs e)
        {
            var item = e.Item as GridEditableItem;
            //Set new values
            var newValues = new Hashtable();
            //The GridTableView will fill the values from all editable columns in the hash
            e.Item.OwnerTableView.ExtractValuesFromItem(newValues, item);

            var result = ManageTypesLogic.AddUpdateAgeGroup(newValues["Name"].ToString(), int.Parse(newValues["AgeMinimum"].ToString()), int.Parse(newValues["AgeMaximum"].ToString()), 0);
            if (!string.IsNullOrEmpty(result))
            {

            }
        }

        protected void RadGridAgeGroup_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            var grid = (RadGrid)sender;
            grid.DataSource = ManageTypesLogic.GetAgeGroups();
        }

        protected void RadGridAgeGroup_ItemCommand(object sender, GridCommandEventArgs e)
        {

        }

        protected void RadGridAgeGroup_UpdateCommand(object sender, GridCommandEventArgs e)
        {
            var item = e.Item as GridEditableItem;
            var id = item.GetDataKeyValue("AgeGroupID").ToString();
            //Set new values
            var newValues = new Hashtable();
            //The GridTableView will fill the values from all editable columns in the hash
            e.Item.OwnerTableView.ExtractValuesFromItem(newValues, item);

            ManageTypesLogic.AddUpdateAgeGroup(newValues["Name"].ToString(), int.Parse(newValues["AgeMinimum"].ToString()), int.Parse(newValues["AgeMaximum"].ToString()), int.Parse(id));

        }

        protected void RadGridAgeGroup_DeleteCommand(object sender, GridCommandEventArgs e)
        {
            var id = (e.Item as GridDataItem).OwnerTableView.DataKeyValues[e.Item.ItemIndex]["AgeGroupID"].ToString();
            var currentId = 0;
            int.TryParse(id, out currentId);
            ManageTypesLogic.DeleteAgeGroup(currentId);

        }

        #endregion

        #region Time Periods
        protected void RadGridTimePeriods_InsertCommand(object sender, GridCommandEventArgs e)
        {
            var item = e.Item as GridEditableItem;
            //Set new values
            var newValues = new Hashtable();
            //The GridTableView will fill the values from all editable columns in the hash
            e.Item.OwnerTableView.ExtractValuesFromItem(newValues, item);
            var timePeriodTypeId = 0;
            int.TryParse(newValues["TimePeriodTypeID"].ToString(), out timePeriodTypeId);
            var startPicker = (RadDatePicker)item.FindControl("RadDatePickerStartDate");
            var endPicker = (RadDatePicker)item.FindControl("RadDatePickerEndDate");
            ManageTypesLogic.AddUpdateTimePeriod(timePeriodTypeId, startPicker.SelectedDate, endPicker.SelectedDate, 0);
        }

        protected void RadGridTimePeriods_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridEditFormItem && e.Item.IsInEditMode)
            {
                var editItem = (GridEditFormItem)e.Item;

                if (editItem != null)
                {
                    if (editItem.DataItem is GridInsertionObject)
                    {
                    }
                    else
                    {
                        DateTime? startDate = null;
                        var stDate = Utilities.GetValueFromAnonymousType<DateTime>(editItem.DataItem, "StartDate").ToShortDateString();
                        if (stDate != "1/1/0001")
                        {
                            startDate = DateTime.Parse(stDate);
                        }
                        DateTime? endDate = null;
                        var enDate = Utilities.GetValueFromAnonymousType<DateTime>(editItem.DataItem, "EndDate").ToShortDateString();
                        if (enDate != "1/1/0001")
                        {
                            endDate = DateTime.Parse(enDate);
                        }
                        var startPicker = (RadDatePicker)editItem.FindControl("RadDatePickerStartDate");
                        var endPicker = (RadDatePicker)editItem.FindControl("RadDatePickerEndDate");
                        if (startPicker != null)
                        {
                            startPicker.SelectedDate = startDate;
                        }
                        if (endPicker != null)
                        {
                            endPicker.SelectedDate = endDate;
                        }
                    }
                }
            }
        }

        protected void RadGridTimePeriods_ItemCommand(object sender, GridCommandEventArgs e)
        {

        }

        protected void RadGridTimePeriods_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            var grid = (RadGrid)sender;
            grid.DataSource = ManageTypesLogic.GetTimePeriods();
        }

        protected void RadGridTimePeriods_UpdateCommand(object sender, GridCommandEventArgs e)
        {
            var item = e.Item as GridEditableItem;
            var id = item.GetDataKeyValue("TimePeriodID").ToString();
            //Set new values
            var newValues = new Hashtable();
            //The GridTableView will fill the values from all editable columns in the hash
            e.Item.OwnerTableView.ExtractValuesFromItem(newValues, item);
            var timePeriodTypeId = 0;
            int.TryParse(newValues["TimePeriodTypeID"].ToString(), out timePeriodTypeId);
            var startPicker = (RadDatePicker)item.FindControl("RadDatePickerStartDate");
            var endPicker = (RadDatePicker)item.FindControl("RadDatePickerEndDate");
            ManageTypesLogic.AddUpdateTimePeriod(timePeriodTypeId, startPicker.SelectedDate, endPicker.SelectedDate, int.Parse(id));

        }

        protected void RadGridTimePeriods_DeleteCommand(object sender, GridCommandEventArgs e)
        {
            var gridDataItem = e.Item as GridDataItem;
            if (gridDataItem == null) return;
            var id = gridDataItem.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["TimePeriodID"].ToString();
            var currentId = 0;
            int.TryParse(id, out currentId);
            ManageTypesLogic.DeleteAgeGroup(currentId);
        }

        #endregion
    }
}