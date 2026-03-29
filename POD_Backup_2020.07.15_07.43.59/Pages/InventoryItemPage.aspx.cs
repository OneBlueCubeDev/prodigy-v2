using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using POD.Data.Entities;
using System.Collections;

namespace POD.Pages
{
    public partial class InventoryItemPage : System.Web.UI.Page
    {
        private int invID = 0;
        public int InventoryItemID
        {
            get
            {
                if (ViewState["InventoryItemID"] != null)
                {
                    int.TryParse(ViewState["InventoryItemID"].ToString(), out invID);
                }
                return invID;
            }
            set
            {
                ViewState["InventoryItemID"] = value;
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
                    mtPage.SetSearch("Inventory");
                    mtPage.SetNavigation("Inventory");
                }

                if (!string.IsNullOrEmpty(Request.QueryString["id"]))
                {
                    int.TryParse(Request.QueryString["id"].ToString(), out invID);
                    InventoryItemID = invID;
                }

                if (InventoryItemID != 0)
                {
                    this.SaveButton.CommandArgument = InventoryItemID.ToString();

                }

                if (POD.Logic.Security.UserInRole("Administrators")) //can see all sites
                {

                    RadComboBoxLocation.DataSource = POD.Logic.LookUpTypesLogic.GetLocations();
                    RadComboBoxLocation.DataBind();
                }
                else
                {
                    int siteid = 0;
                    int.TryParse(Session["UsersSiteID"].ToString(), out siteid);
                    RadComboBoxLocation.DataSource = POD.Logic.LookUpTypesLogic.GetLocationsBySite(siteid);
                    RadComboBoxLocation.DataBind();
                }
                LoadInventoryItem();
            }
        }

        private void LoadInventoryItem()
        {
            this.LiteralHeader.Text = "Add Inventory Item";
            if (InventoryItemID != 0)
            {
                InventoryItem currentItem = POD.Logic.InventoryLogic.GetInventoryitemByID(InventoryItemID);

                if (currentItem != null)
                {
                    this.LiteralHeader.Text = string.Format("Edit {0}", currentItem.Name);
                    this.TextBoxName.Text = currentItem.Name;
                    this.TextBoxOrganization.Text = currentItem.Organization;
                    this.TextBoxModel.Text = currentItem.Model;
                    this.TextBoxManufacturer.Text = currentItem.Manufacturer;
                    RadComboBoxItem item = RadComboBoxConditions.FindItemByValue(currentItem.Condition);
                    if (item != null)
                    {
                        item.Selected = true;
                    }
                     this.TextBoxDesc.Text = currentItem.Description;
                    this.TextBoxDJJTagNum.Text = currentItem.DJJTagNum;
                    this.TextBoxComments.Text = currentItem.Comments;
                    this.TextBoxSerialNum.Text = currentItem.SerialNum;
                    this.TextBoxUACDCTagNum.Text = currentItem.UACDCTagNum;
                    this.TextBoxAcquisition.Text = currentItem.AcquisitionCost.ToString();
                    this.AcquisitionDatePicker.SelectedDate = currentItem.AcquisitionDate;
                    if (currentItem.LocationID.HasValue)
                    {
                        this.RadComboBoxLocation.DataBind();
                        RadComboBoxItem locItem = this.RadComboBoxLocation.Items.FindItemByValue(currentItem.LocationID.Value.ToString());
                        if (locItem != null)
                        {
                            locItem.Selected = true;
                        }
                    }
                    //if (currentItem.InventoryItemTypeID.HasValue)
                    //{
                    //    this.RadComboBoxTypes.DataBind();
                    //    RadComboBoxItem typeItem = this.RadComboBoxTypes.Items.FindItemByValue(currentItem.InventoryItemTypeID.Value.ToString());
                    //    if (typeItem != null)
                    //    {
                    //        typeItem.Selected = true;
                    //    }
                    //}
                }
            }
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            Save();
        }

        private void Save()
        {
            if (Page.IsValid)
            {
                InventoryItem newItem = new InventoryItem();
                newItem.InventoryItemID = InventoryItemID;
                newItem.Name = this.TextBoxName.Text.Trim();
                newItem.Model = this.TextBoxModel.Text.Trim();
                newItem.Organization = this.TextBoxOrganization.Text.Trim();
                newItem.Manufacturer = this.TextBoxManufacturer.Text.Trim();
                newItem.Condition = this.RadComboBoxConditions.SelectedValue.ToString();
                newItem.Description = this.TextBoxDesc.Text.Trim();
                newItem.DJJTagNum = this.TextBoxDJJTagNum.Text.Trim();
                newItem.Comments = this.TextBoxComments.Text.Trim();
                newItem.SerialNum = this.TextBoxSerialNum.Text.Trim();
                newItem.UACDCTagNum = this.TextBoxUACDCTagNum.Text.Trim();
                newItem.AcquisitionCost = string.IsNullOrEmpty(this.TextBoxAcquisition.Text) ? 0 : Convert.ToDecimal(this.TextBoxAcquisition.Text.Trim());
                newItem.AcquisitionDate = this.AcquisitionDatePicker.SelectedDate;

                if (!string.IsNullOrEmpty(this.RadComboBoxLocation.SelectedValue))
                {
                    int locid = 0;
                    if (int.TryParse(this.RadComboBoxLocation.SelectedValue, out locid))
                        newItem.LocationID = locid;
                }
                //if (!string.IsNullOrEmpty(this.RadComboBoxTypes.SelectedValue))
                //{
                //    int typeid = 0;
                //    if (int.TryParse(this.RadComboBoxTypes.SelectedValue, out typeid))
                //        newItem.InventoryItemTypeID = typeid;
                //}
                //newItem.InventoryItemID = 0;
                InventoryItemID = POD.Logic.InventoryLogic.AddUpdateInventoryItem(newItem);
                if (InventoryItemID == 0)
                {
                    LiteralError.Text = "<p>An error occurred, please contact your System Administrator</p>";
                }
                else
                {
                    Response.Redirect("~/Pages/Inventory.aspx");
                }
            }
        }

        protected void DeleteButton_Click(object sender, EventArgs e)
        {
            string result = POD.Logic.InventoryLogic.DeleteInventoryItem(InventoryItemID);
            if (!string.IsNullOrEmpty(result))
            {
                LiteralError.Text = string.Format("<p>An error occurred: {0}</p>", result);
            }
            else
            {
                Response.Redirect("~/Pages/Inventory.aspx");
            }

        }

    }
}