using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using POD.Data.Entities;
using POD.Logic;
using Telerik.Web.UI;

namespace POD.Pages.Admin.ManageCommunities
{
    public partial class CommunityPage : System.Web.UI.Page
    {
        private int id;
        private string Type
        {
            get
            {
                if (ViewState["Type"] != null)
                {
                    return ViewState["Type"].ToString();
                }
                return string.Empty;
            }
            set
            {
                ViewState["Type"] = value;
            }
        }
        private int Identifier
        {
            get
            {
                if (ViewState["Identifier"] != null)
                {
                    int.TryParse(ViewState["Identifier"].ToString(), out id);
                }
                return id;
            }
            set
            {
                ViewState["Identifier"] = value;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!string.IsNullOrEmpty(Request.QueryString["type"]))
                {
                    Type = Request.QueryString["type"].ToString();
                }
                if (!string.IsNullOrEmpty(Request.QueryString["cid"]))
                {
                    int.TryParse(Request.QueryString["cid"].ToString(), out id);
                    Identifier = id;
                }

                LoadData();
            }
        }

        private void LoadData()
        {
            this.PanelCircuit.Visible = false;
            this.PanelCommunity.Visible = false;
            this.PanelCounty.Visible = false;
            if (Type == "circuit")
            {
                this.ButtonSave.ValidationGroup = "SaveCircuit";
                this.PanelCircuit.Visible = true;
                this.LiteralHeader.Text = "Add Circuit";
                Circuit currentCircuit = POD.Logic.ProgramCourseClassLogic.GetCircuitByID(Identifier);
                if (currentCircuit != null)
                {
                    this.LiteralHeader.Text = string.Format("Edit Circuit {0}", currentCircuit.Name);
                    this.TextboxCircuit.Text = currentCircuit.Name;
                }

            }
            else if (Type == "com")
            {
                this.ButtonSave.ValidationGroup = "SaveCommunity";
                this.PanelCommunity.Visible = true;
                Community com = POD.Logic.ProgramCourseClassLogic.GetCommunityByID(Identifier);
                this.LiteralHeader.Text = "Add Community";
                if (com != null)
                {
                    this.LiteralHeader.Text = string.Format("Edit Community {0}", com.Name);
                    this.TextboxName.Text = com.Name;
                    this.RadEditorDesc.Content = com.Description;
                    this.DataListCommunityCounties.DataSource = POD.Logic.ProgramCourseClassLogic.GetCountiesForCommunityByID(Identifier);
                    this.DataListCommunityCounties.DataBind();
                }
                if (!Security.UserInRole("Administrators"))
                {
                    this.RadEditorDesc.Enabled = false;
                }
            }
            else if(Type == "county")
            {
                this.ButtonSave.ValidationGroup = "SaveCounty";
                this.PanelCounty.Visible = true;
                County ct = POD.Logic.ProgramCourseClassLogic.GetCountyByID(Identifier);
                this.LiteralHeader.Text = "Add County";
                if (ct != null)
                {
                    this.LiteralHeader.Text = string.Format("Edit County {0}", ct.Name);
                    this.TextboxCounty.Text = ct.Name;
                    this.RadComboBoxCircuits.DataBind();
                    RadComboBoxItem item = this.RadComboBoxCircuits.FindItemByValue(ct.CircuitID.ToString());
                    if (item != null)
                    {
                        item.Selected = true;
                    }

                }
            }

        }

        private void Save()
        {
            if (Type == "circuit")
            {
                Identifier = POD.Logic.ProgramCourseClassLogic.AddUpdateCircuit(Identifier, this.TextboxCircuit.Text.Trim());
            }
            if (Type == "com")
            {
                Identifier = POD.Logic.ProgramCourseClassLogic.AddUpdateCommunity(Identifier, this.TextboxName.Text.Trim(), this.RadEditorDesc.Content);
            }
            else if (Type == "county")
            {
                int circId = 0;
                int.TryParse(this.RadComboBoxCircuits.SelectedValue, out circId);
                Identifier = POD.Logic.ProgramCourseClassLogic.AddUpdateCounty(Identifier, this.TextboxCounty.Text.Trim(), circId);

            }
        }

        protected void ButtonAddCounty_Click(object sender, EventArgs e)
        {
            if (Identifier == 0)
            {
                Save();
            }
            int countyId = 0;
            int.TryParse(this.RadComboBoxCounty.SelectedValue, out countyId);
            if (countyId != 0)
            {
                POD.Logic.ProgramCourseClassLogic.AddCountyToCommunity(countyId, Identifier);
            }
            this.RadComboBoxCounty.ClearSelection();
            this.DataListCommunityCounties.DataSource = POD.Logic.ProgramCourseClassLogic.GetCountiesForCommunityByID(Identifier);
            this.DataListCommunityCounties.DataBind();
        }

        protected void DataListCommunityCounties_ItemCommand(object source, DataListCommandEventArgs e)
        {
            int countyid = 0;
            int.TryParse(e.CommandArgument.ToString(), out countyid);
            if (countyid != 0)
            {
                POD.Logic.ProgramCourseClassLogic.DeleteCountyFromCommunity(countyid, Identifier);
            }
            this.DataListCommunityCounties.DataSource = POD.Logic.ProgramCourseClassLogic.GetCountiesForCommunityByID(Identifier);
            this.DataListCommunityCounties.DataBind();
        }

        protected void ButtonSave_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                Save();
               // Response.Redirect("~/Pages/Admin/ManageCommunities/Communities.aspx");
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "CallCommParentFunc", "returnToParent();", true);
            }
        }

        //protected void ButtonCancel_Click(object sender, EventArgs e)
        //{
        //    Response.Redirect("~/Pages/Admin/ManageCommunities/Communities.aspx");
        //}
    }
}