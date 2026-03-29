using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using POD.Data.Entities;

namespace POD.Pages.Admin.ManageProgramsAndCourses
{
    public partial class Programs : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
               
            }
        }

        protected void RadGridPrograms_Delete(object sender, GridCommandEventArgs e)
        {
            if (e.CommandName == "Delete")
            {
                int progID = 0;
                string progStringID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["ProgramID"].ToString();
                int.TryParse(progStringID, out progID);
                POD.Logic.ProgramCourseClassLogic.DeleteProgram(progID);
            }
        }

        /// <summary>
        /// can add special error handling here
        /// </summary>
        /// <param name="source"></param>
        /// <param name="e"></param>
        protected void RadGridPrograms_ItemUpdated(object source, Telerik.Web.UI.GridUpdatedEventArgs e)
        {
            GridEditableItem item = (GridEditableItem)e.Item;

            if (e.Exception != null)
            {
                e.KeepInEditMode = true;
                e.ExceptionHandled = true;

            }
        }

        /// <summary>
        /// can add special error handling here
        /// </summary>
        /// <param name="source"></param>
        /// <param name="e"></param>
        protected void RadGridPrograms_ItemInserted(object source, Telerik.Web.UI.GridInsertedEventArgs e)
        {
            GridEditableItem item = (GridEditableItem)e.Item;

            if (e.Exception != null)
            {
                e.KeepInInsertMode = true;
                e.ExceptionHandled = true;

            }
        }

        protected void DatasourcePrograms_Inserting(object sender, EntityDataSourceChangingEventArgs e)
        {
            Program prog = (Program)e.Entity;
            prog.rowguid = Guid.NewGuid();
            prog.DateTimeStamp = DateTime.Now;
            prog.LastModifiedBy = POD.Logic.Security.GetCurrentUserProfile().UserName;

        }

        protected void DataSourcePrograms_Updating(object sender, EntityDataSourceChangingEventArgs e)
        {
            Program prog = (Program)e.Entity;
            prog.LastModifiedBy = POD.Logic.Security.GetCurrentUserProfile().UserName;

        }
    }
}