using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using POD.Data.Entities;
using Telerik.Web.UI;
using POD.Logic;

namespace POD.Pages
{
    public partial class EventPage : System.Web.UI.Page
    {
        private int evID = 0;
        public int EventID
        {
            get
            {
                if (ViewState["EventID"] != null)
                {
                    int.TryParse(ViewState["EventID"].ToString(), out evID);
                }
                return evID;
            }
            set
            {
                ViewState["EventID"] = value;
            }
        }

        protected string GetEventCategoryString()
        {
            if (rcbCategory1.Visible == false)
            {
                return TextBoxEventCategory.Text;
            }

            var items = new List<string>();
            if (rcbCategory1.SelectedItem != null)
            {
                items.Add(rcbCategory1.SelectedItem.Text);
                items.AddRange(rlvFields1.Items
                    .Select(item => new { item, name = item.GetDataKeyValue("Name") as string })
                    .Select(@t => new { @t, value = ((TextBox)@t.item.FindControl("tbField")).Text })
                    .Select(@t => string.Format("{0}: {1}", @t.@t.name, @t.value)));
                if (rcbCategory2.SelectedItem != null)
                {
                    items.Add(rcbCategory2.SelectedItem.Text);
                    items.AddRange(rlvFields2.Items
                        .Select(item => new { item, name = item.GetDataKeyValue("Name") as string })
                        .Select(@t => new { @t, value = ((TextBox)@t.item.FindControl("tbField")).Text })
                        .Select(@t => string.Format("{0}: {1}", @t.@t.name, @t.value)));
                }
            }

            return string.Join("; ", items);
        }

        protected void ParseEventCategoryString(string value)
        {
            if (string.IsNullOrEmpty(value) == false)
            {
                TextBoxEventCategory.Text = value;
                var items = value.Split(";".ToCharArray())
                    .Select(x => x.Split(":".ToCharArray()))
                    .ToDictionary(x => x.First().Trim(), x => string.Join(string.Empty, x.Skip(1)).Trim());

                if (items.Count > 0)
                {
                    foreach (RadComboBoxItem item in rcbCategory1.Items)
                    {
                        if (string.IsNullOrEmpty(item.Text) == false
                            && items.Keys.Contains(item.Text))
                        {
                            item.Selected = true;
                            break;
                        }
                    }
                    rcbCategory1_OnSelectedIndexChanged(this, null);

                    foreach (RadListViewDataItem item in rlvFields1.Items)
                    {
                        var name = item.GetDataKeyValue("Name") as string;
                        var tbField = (TextBox)item.FindControl("tbField");
                        if (string.IsNullOrEmpty(name) == false
                            && items.ContainsKey(name))
                        {
                            tbField.Text = items[name];
                        }
                    }

                    foreach (RadComboBoxItem item in rcbCategory2.Items)
                    {
                        if (string.IsNullOrEmpty(item.Text) == false
                            && items.Keys.Contains(item.Text))
                        {
                            item.Selected = true;
                            break;
                        }
                    }
                    rcbCategory2_OnSelectedIndexChanged(this, null);

                    foreach (RadListViewDataItem item in rlvFields2.Items)
                    {
                        var name = item.GetDataKeyValue("Name") as string;
                        var tbField = (TextBox)item.FindControl("tbField");
                        if (string.IsNullOrEmpty(name) == false
                            && items.ContainsKey(name))
                        {
                            tbField.Text = items[name];
                        }
                    }
                }
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            LiteralError.Text = string.Empty;
            if (!IsPostBack)
            {
                POD.MasterPages.Admin mtPage = (POD.MasterPages.Admin)this.Master;
                if (mtPage != null)
                {
                    mtPage.SetSearch("Event");
                    mtPage.SetNavigation("Event");
                }

                if (!string.IsNullOrEmpty(Request.QueryString["evid"]))
                {
                    int.TryParse(Request.QueryString["evid"].ToString(), out evID);
                    EventID = evID;
                }

                if (EventID != 0)
                {
                    this.SaveButton.CommandArgument = EventID.ToString();

                }
                if (Security.UserInRole("Administrators"))
                {
                    this.RadComboBoxSite.DataSource = POD.Logic.LookUpTypesLogic.GetSites();
                    this.RadComboBoxLocation.DataSource = POD.Logic.LookUpTypesLogic.GetLocations();
                }
                else
                {
                    int siteid = 0;
                    int.TryParse(Session["UsersSiteID"].ToString(), out siteid);
                    this.RadComboBoxSite.DataSource = POD.Logic.LookUpTypesLogic.GetSites().Where(s => s.LocationID == siteid);
                    this.RadComboBoxLocation.DataSource = POD.Logic.LookUpTypesLogic.GetLocationsBySite(siteid);
                }
                this.RadComboBoxSite.DataBind();
                this.RadComboBoxLocation.DataBind();
                this.RadComboBoxLocation.Enabled = false;
                LoadEvent();
            }
        }

        private void LoadEvent()
        {
            this.LiteralHeader.Text = "Add Event";
            if (EventID != 0)
            {
                Event currentItem = POD.Logic.ProgramCourseClassLogic.GetEvent(EventID);

                if (currentItem != null)
                {
                    this.LiteralHeader.Text = string.Format("Edit {0}", currentItem.Name);
                    this.TextBoxName.Text = currentItem.Name;
                    this.TextBoxNotes.Text = currentItem.Notes;
                    this.RadEditoDesc.Content = currentItem.Description;
                    this.RadDatePickerEnd.SelectedDate = currentItem.DateEnd;
                    this.RadDatePickerStart.SelectedDate = currentItem.DateStart;
                    if (currentItem.LocationID.HasValue)
                    {
                        this.RadComboBoxLocation.DataBind();
                        RadComboBoxItem locItem = this.RadComboBoxLocation.Items.FindItemByValue(currentItem.LocationID.Value.ToString());
                        if (locItem != null)
                        {
                            locItem.Selected = true;
                        }
                    }

                    RadComboBoxItem site = RadComboBoxSite.FindItemByValue(currentItem.SiteLocationID.ToString());
                    if (site != null)
                    {
                        site.Selected = true;
                    }
                    this.RadComboBoxTypes.DataBind();
                    RadComboBoxItem typeItem = this.RadComboBoxTypes.Items.FindItemByValue(currentItem.EventTypeID.ToString());
                    if (typeItem != null)
                    {
                        typeItem.Selected = true;
                        RadComboBoxTypes_OnSelectedIndexChanged(this, null);
                    }

                    TextBoxEventLocation.Text = currentItem.EventLocation;
                    ParseEventCategoryString(currentItem.Category);

                    if (currentItem.YouthAttendanceCount != null)
                    {
                        TextBoxYouthAttendanceCount.Text = currentItem.YouthAttendanceCount.Value.ToString();
                    }
                    if (currentItem.StaffAttendanceCount != null)
                    {
                        TextBoxStaffAttendanceCount.Text = currentItem.StaffAttendanceCount.Value.ToString();
                    }
                    if (currentItem.FamilyAttendanceCount != null)
                    {
                        TextBoxFamilyAttendanceCount.Text = currentItem.FamilyAttendanceCount.Value.ToString();
                    }
                }
            }
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                Button btn = (Button)sender;
                Save();
            }
        }

        private void Save()
        {
            if (Page.IsValid)
            {
                Event newItem = new Event();
                newItem.EventID = EventID;
                string eventName = this.TextBoxName.Text.Trim();
                newItem.Name = eventName.Substring(0, 1).ToUpper() + eventName.Substring(1);
                newItem.Notes = this.TextBoxNotes.Text.Trim();

                newItem.StatusTypeID = POD.Logic.ManageTypesLogic.GetStatusTypeIDByName("active");
                newItem.Description = this.RadEditoDesc.Content.ToString();

                newItem.DateStart = this.RadDatePickerStart.SelectedDate;
                newItem.DateEnd = this.RadDatePickerEnd.SelectedDate;
                if (!string.IsNullOrEmpty(this.RadComboBoxLocation.SelectedValue))
                {
                    int locid = 0;
                    if (int.TryParse(this.RadComboBoxLocation.SelectedValue, out locid))
                        newItem.LocationID = locid;
                }
                if (!string.IsNullOrEmpty(this.RadComboBoxSite.SelectedValue))
                {
                    int siteid = 0;
                    if (int.TryParse(this.RadComboBoxSite.SelectedValue, out siteid))
                        newItem.SiteLocationID = siteid;
                }
                if (!string.IsNullOrEmpty(this.RadComboBoxTypes.SelectedValue))
                {
                    int typeid = 0;
                    if (int.TryParse(this.RadComboBoxTypes.SelectedValue, out typeid))
                        newItem.EventTypeID = typeid;
                }
                int progID = 0;
                if (Session["ProgramID"] != null)
                {
                    int.TryParse(Session["ProgramID"].ToString(), out progID);
                }
                if (string.IsNullOrEmpty(TextBoxEventLocation.Text) == false)
                {              
                    newItem.EventLocation = TextBoxEventLocation.Text;
                }

                newItem.Category = GetEventCategoryString();

                int youthCount;
                newItem.YouthAttendanceCount = string.IsNullOrEmpty(TextBoxYouthAttendanceCount.Text) == false && int.TryParse(TextBoxYouthAttendanceCount.Text, out youthCount)
                                                   ? youthCount
                                                   : (int?)null;
                int staffCount;
                newItem.StaffAttendanceCount = string.IsNullOrEmpty(TextBoxStaffAttendanceCount.Text) == false && int.TryParse(TextBoxStaffAttendanceCount.Text, out staffCount)
                                                   ? staffCount
                                                   : (int?)null;
                int familyCount;
                newItem.FamilyAttendanceCount = string.IsNullOrEmpty(TextBoxFamilyAttendanceCount.Text) == false && int.TryParse(TextBoxFamilyAttendanceCount.Text, out familyCount)
                                                    ? familyCount
                                                    : (int?)null;
                EventID = POD.Logic.ProgramCourseClassLogic.AddUpdateEvent(newItem, progID);
                if (EventID == 0)
                {
                    LiteralError.Text = "<p>An error occurred, please contact your System Administrator</p>";
                }
                else
                {
                    Response.Redirect("~/Pages/Events.aspx");
                }
            }
        }

        protected void DeleteButton_Click(object sender, EventArgs e)
        {
            string result = POD.Logic.ProgramCourseClassLogic.DeleteEvent(EventID);
            if (!string.IsNullOrEmpty(result))
            {
                LiteralError.Text = string.Format("<p>An error occurred: {0}</p>", result);
            }
            else
            {
                Response.Redirect("~/Pages/Events.aspx");
            }

        }

        protected void RadComboBoxSite_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            this.RadComboBoxLocation.Items.Clear();

            if (!string.IsNullOrEmpty(e.Value))
            {
                int siteid = 0;
                int.TryParse(e.Value, out siteid);
                this.RadComboBoxLocation.DataSource = POD.Logic.LookUpTypesLogic.GetLocationsBySite(siteid);
                this.RadComboBoxLocation.Enabled = true;
                this.RadComboBoxLocation.DataBind();
            }
            else
            {
                this.RadComboBoxLocation.Enabled = false;
            }

        }

        protected void rlvFields1_OnNeedDataSource(object sender, RadListViewNeedDataSourceEventArgs e)
        {
            int eventCategoryId;
            if (int.TryParse(rcbCategory1.SelectedValue, out eventCategoryId))
            {
                var category = LookUpTypesLogic.GetEventCategoryByID(eventCategoryId);
                rlvFields1.DataSource = category.EventCategoryFields;
            }
            else
            {
                rlvFields1.DataSource = Enumerable.Empty<EventCategoryField>();
            }
        }

        protected void rlvFields2_OnNeedDataSource(object sender, RadListViewNeedDataSourceEventArgs e)
        {
            int eventCategoryId;
            if (int.TryParse(rcbCategory2.SelectedValue, out eventCategoryId))
            {
                var category = LookUpTypesLogic.GetEventCategoryByID(eventCategoryId);
                rlvFields2.DataSource = category.EventCategoryFields;
            }
            else
            {
                rlvFields2.DataSource = Enumerable.Empty<EventCategoryField>();
            }
        }

        protected void RadComboBoxTypes_OnSelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            int eventTypeId;
            if (int.TryParse(RadComboBoxTypes.SelectedValue, out eventTypeId))
            {
                var categories = LookUpTypesLogic.GetEventCategoriesByEventType(eventTypeId);
                rcbCategory1.DataSource = categories.Where(x => x.ParentCategoryID == null);
            }
            else
            {
                rcbCategory1.DataSource = Enumerable.Empty<EventCategory>();
            }
            rcbCategory1.DataBind();
        }

        protected void RadComboBoxTypes_OnDataBound(object sender, EventArgs e)
        {
            RadComboBoxTypes_OnSelectedIndexChanged(sender, null);
        }

        protected void rcbCategory1_OnDataBound(object sender, EventArgs e)
        {
            if (rcbCategory1.Items.Count == 0)
            {
                rcbCategory1.Visible = false;
                TextBoxEventCategory.Visible = true;
            }
            else
            {
                rcbCategory1.Visible = true;
                TextBoxEventCategory.Visible = false;
            }
            rcbCategory1_OnSelectedIndexChanged(sender, null);
        }

        protected void rcbCategory2_OnDataBound(object sender, EventArgs e)
        {
            if (rcbCategory2.Items.Count == 0)
            {
                rcbCategory2.Visible = false;
            }
            else
            {
                rcbCategory2.Visible = true;
            }
            rcbCategory2_OnSelectedIndexChanged(sender, null);
        }

        protected void rcbCategory1_OnSelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            int eventTypeId;
            int eventCategoryId;
            if (int.TryParse(RadComboBoxTypes.SelectedValue, out eventTypeId)
                && int.TryParse(rcbCategory1.SelectedValue, out eventCategoryId))
            {
                var categories = LookUpTypesLogic.GetEventCategoriesByEventType(eventTypeId);
                rcbCategory2.DataSource = categories.Where(x => x.ParentCategoryID == eventCategoryId);
            }
            else
            {
                rcbCategory2.DataSource = Enumerable.Empty<EventCategory>();
            }
            rlvFields1.Rebind();
            rcbCategory2.DataBind();
        }

        protected void rcbCategory2_OnSelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            rlvFields2.Rebind();
        }

        protected void rlvFields2_OnDataBound(object sender, EventArgs e)
        {
            if (rlvFields2.Items.Count == 0)
            {
                rlvFields2.Visible = false;
            }
            else
            {
                rlvFields2.Visible = true;
            }
        }

        protected void rlvFields1_OnDataBound(object sender, EventArgs e)
        {
            if (rlvFields1.Items.Count == 0)
            {
                rlvFields1.Visible = false;
            }
            else
            {
                rlvFields1.Visible = true;
            }
        }
    }
}