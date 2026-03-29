using POD.Data.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;

namespace POD.Pages.ManageClasses
{
	public partial class ClassRegistration : System.Web.UI.Page
	{
		private int courseInstId = 0;
		private int lpsId = 0;

		public int CourseInstanceID
		{
			get
			{
				if (ViewState["CourseInstanceID"] != null)
				{
					int.TryParse(ViewState["CourseInstanceID"].ToString(), out courseInstId);
				}
				return courseInstId;
			}
			set
			{
				ViewState["CourseInstanceID"] = value;
			}
		}
		private int courseId = 0;
		public int CourseID
		{
			get
			{
				if (ViewState["CourseID"] != null)
				{
					int.TryParse(ViewState["CourseID"].ToString(), out courseId);
				}
				return courseId;
			}
			set
			{
				ViewState["CourseID"] = value;
			}
		}
		public int LpsId
		{
			get
			{
				if (ViewState["lpsId"] != null)
				{
					int.TryParse(ViewState["lpsId"].ToString(), out lpsId);
				}
				return lpsId;
			}
			set
			{
				ViewState["lpsId"] = value;
			}
		}
		protected void Page_Load(object sender, EventArgs e)
		{
			if (!IsPostBack)
			{
				POD.MasterPages.Admin mtPage = (POD.MasterPages.Admin)this.Master;
				if (mtPage != null)
				{
					mtPage.SetSearch("Class");
					mtPage.SetNavigation("Class");
				}
				if (!string.IsNullOrEmpty(Request.QueryString["clid"]))
				{
					int.TryParse(Request.QueryString["clid"].ToString(), out courseInstId);
					CourseInstanceID = courseInstId;
				}
				if (!string.IsNullOrEmpty(Request.QueryString["lps"]))
				{
					int.TryParse(Request.QueryString["lps"].ToString(), out lpsId);
					LpsId = lpsId;

				}
				if (!string.IsNullOrEmpty(Request.QueryString["cid"]))
				{
					int.TryParse(Request.QueryString["cid"].ToString(), out courseId);
					CourseID = courseId;
					LoadData();
				}
				

				this.ClassesLinks1.SetVisibility(true,true);
			}

		}

		private void LoadData()
		{
			if (CourseInstanceID != 0)
			{
				CourseInstance instance = POD.Logic.ProgramCourseClassLogic.GetCoursesInstanceByID(CourseInstanceID);
				if (instance != null)
				{
					this.LiteralCourseHeader.Text = String.Format("Manage Youth registered for {0}", instance.Course.Name);
					this.LiteralDates.Text = string.Format("{0} - {1}", instance.StartDate.HasValue ? instance.StartDate.Value.ToShortDateString() : "n/a", instance.EndDate.HasValue ? instance.EndDate.Value.ToShortDateString() : "n/a");
					this.LiteralDesc.Text = instance.Course.Description;
					this.LiteralInstructor.Text = instance.InstructorPersonID.HasValue ? instance.Instructor.FullName : "n/a";
					this.LiteralAssistant.Text = instance.AssistantPersonID.HasValue ? instance.Assistant.FullName : "n/a";
					this.LiteralLocation.Text = instance.Site.Name;

					DateTime registrationStartDate = instance.StartDate.HasValue
						? instance.StartDate.Value
						: DateTime.Now.Date;
					IEnumerable<Student> students = POD.Logic.PersonRelatedLogic.GetStudentsByCourseInstanceID(instance.CourseInstanceID);
					this.DataListPeople.DataSource = students.OrderBy(x => x.LastName).ThenBy(x => x.FirstName);
					this.DataListPeople.DataBind();

					var possibleStudentList = POD.Logic.PersonRelatedLogic.GetStudentsForCourseRegistration(instance.SiteLocationID, registrationStartDate);
					possibleStudentList.RemoveAll(p => students.Contains(p));
					RadComboBoxPerson.DataSource = possibleStudentList.OrderBy(x => x.LastName).ThenBy(x => x.FirstName);
					RadComboBoxPerson.DataBind();
				}
			}
		}

		protected void DataListPeople_ItemCommand(object source, DataListCommandEventArgs e)
		{
			int personid = 0;
			if (e.CommandName == "Remove")
			{
				string key = DataListPeople.DataKeys[e.Item.ItemIndex].ToString();
				int.TryParse(key, out personid);
				POD.Logic.ProgramCourseClassLogic.RemovePersonToCourseInstance(personid, CourseInstanceID);
			}
			LoadData();
		}

		protected void ButtonAddPerson_Click(object sender, EventArgs e)
		{
			int personid = 0;
			int.TryParse(this.RadComboBoxPerson.SelectedValue, out personid);
			if (personid != 0)
			{
				POD.Logic.ProgramCourseClassLogic.AddPersonToCourseInstance(personid, CourseInstanceID);
			}
			LoadData();
		}

		protected void ButtonCancel_Click(object sender, EventArgs e)
		{
			Response.Redirect(LpsId == 1
				? "~/Pages/LessonPlans/LessonPlans.aspx?tp=2"
				: $"~/Pages/ManageClasses/ClassDetailPage.aspx?cid={CourseID}");
		}
	}
}