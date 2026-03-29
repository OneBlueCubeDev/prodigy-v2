using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using POD.Data.Entities;
using POD.Logic;

using System.Configuration;
using System.IO;
using iTextSharp.text.pdf;
using POD.Logging;

namespace POD.Pages
{
    public partial class Enrollments : System.Web.UI.Page
    {
        string enrollmentType = string.Empty;
        int statusTypeid = 0;
        int enrollTypeID = 0;
        Dictionary<string, string> searchParm;
        protected void Page_Load(object sender, EventArgs e)
        {
            

            //hide appropriate button and set status
            if (!string.IsNullOrEmpty(Request.QueryString["status"]) && Request.QueryString["status"].ToString() == "0")
            {
                statusTypeid = POD.Logic.ManageTypesLogic.GetStatusTypeIDByName("inactive");
                this.EnrollmentLinks1.ShowButtons(2);
            }
            else if (!string.IsNullOrEmpty(Request.QueryString["status"]) && Request.QueryString["status"].ToString() == "1")
            {
                statusTypeid = POD.Logic.ManageTypesLogic.GetStatusTypeIDByName("enrolled");
                this.EnrollmentLinks1.ShowButtons(3);
            }
            else if (!string.IsNullOrEmpty(Request.QueryString["status"]) && Request.QueryString["status"].ToString() == "2")
            {
                statusTypeid = POD.Logic.ManageTypesLogic.GetStatusTypeIDByName("rollover");
                this.EnrollmentLinks1.ShowButtons(4);
            }
            else if (!string.IsNullOrEmpty(Request.QueryString["erid"]) && Request.QueryString["erid"].ToString().ToLower() == "diversion youth")
            {
                //statusTypeid = POD.Logic.ManageTypesLogic.GetStatusTypeIDByName("enrolled");
                this.EnrollmentLinks1.ShowButtons(5);
            }

            if (!IsPostBack)
            {
                if (!Security.UserInRole("Administrators"))
                {
                    // Find the RadMenuItem by ID
                    RadMenuItem adminItem = RadMenuOptions.FindItemByValue("Delete");
                    adminItem.Visible = false;

                }

                POD.MasterPages.Admin mtPage = (POD.MasterPages.Admin)this.Master;
                if (mtPage != null)
                {
                    mtPage.SetSearch("Enrollment");
                    mtPage.SetNavigation("Youth");
                }

                if (!string.IsNullOrEmpty(Request.QueryString["erid"]))
                {
                    enrollmentType = Request.QueryString["erid"].ToString().ToLower();
                    enrollTypeID = POD.Logic.ManageTypesLogic.GetEnrollmentTypeIDByName(enrollmentType);
                }

                RadMenuItem item = this.RadMenuOptions.Items.FindItemByValue("Release");
                if (item != null || PersonRelatedLogic.IsDateAHoliday() == true)
                {
                    item.Visible = false;
                    //item.Remove();
         
                }

                //only admin and central admins can delete
                if (!Security.UserInRole("Administrators") && !Security.UserInRole("Administrators-NA") &&
                    !Security.UserInRole("CentralTeamUsers") && !Security.UserInRole("SiteTeamUsers") && !Security.UserInRole("SiteTeamUsers-NA"))
                {
                    this.RadMenuOptions.Visible = false;
                    this.RadMenuOptionsInactive.Visible = false;
                }
                else if (!Security.UserInRole("Administrators") && !Security.UserInRole("CentralTeamUsers") && !Security.UserInRole("SiteTeamUsers"))
                {
                    //active menu
                     item = this.RadMenuOptions.Items.FindItemByValue("Transfer");
                    if (item != null)
                    {
                        item.Visible = false;
                    }

                    item = this.RadMenuOptions.Items.FindItemByValue("Release");
                    if (item != null || PersonRelatedLogic.IsDateAHoliday() == true)
                    {
                        item.Visible = false;
                    }
                    item = this.RadMenuOptions.Items.FindItemByValue("CompletionCertificate");
                    if (item != null)
                    {
                        item.Visible = false;
                    }
                    item = this.RadMenuOptions.Items.FindItemByValue("Delete");
                    if (item != null)
                    {
                        item.Visible = false;
                    }
                    item = this.RadMenuOptions.Items.FindItemByValue("Rollover");
                    if (item != null)
                    {
                        item.Visible = false;
                    }

                    //inactive menu
                    item = this.RadMenuOptionsInactive.Items.FindItemByValue("ReEnrollment");
                    if (item != null)
                    {
                        item.Visible = false;
                    }
                    item = this.RadMenuOptionsInactive.Items.FindItemByValue("Rollover");
                    if (item != null)
                    {
                        item.Visible = false;
                    }
                    item = this.RadMenuOptionsInactive.Items.FindItemByValue("Delete");
                    if (item != null)
                    {
                        item.Visible = false;
                    }
                }
            }
        }

       

        /// <summary>
        /// returns data for grid filterd by parameters
        /// </summary>
        /// <param name="searchParm"></param>
        /// <returns></returns>
        private List<sp_GetPersonEnrollments2_Result> GetData()
        {
            if (!string.IsNullOrEmpty(Request.QueryString["sc"]))
            {
                searchParm = POD.Logic.Utilities.GetSearchFilters(Request.QueryString["sc"].ToString(), "Enrollment");
            }
            else
            {
                searchParm = POD.Logic.Utilities.SetDefaultSearchFilters("Enrollment");
            }
            List<sp_GetPersonEnrollments2_Result> list = new List<sp_GetPersonEnrollments2_Result>();
            int? typeid = null;
            int? statusid = null;
            int? grantYearID = null;
            DateTime? startDate = null;
            DateTime? endDate = null;
            string isdjjyouth = null;
            if (searchParm["Type"] != "-1")
            {
                typeid = int.Parse(searchParm["Type"].ToString());
                if (typeid == 3)//diversion
                {
                    this.EnrollmentLinks1.ShowButtons(5);
                }

            }
            else if (enrollTypeID != 0)//check if we have query string 
            {
                typeid = enrollTypeID;
            }
            if (searchParm["Status"] != "-1")
            {
                statusid = int.Parse(searchParm["Status"].ToString());
            }
            else if (statusTypeid != 0)//check if we have query string
            {
                statusid = statusTypeid;
            }
            if (searchParm["Year"] != "-1")
            {
                grantYearID = int.Parse(searchParm["Year"].ToString());
            }
            if (searchParm["RegStartDate"] != "-1")
            {
                startDate = DateTime.Parse(searchParm["RegStartDate"].ToString());
            }
            if (searchParm["RegEndDate"] != "-1")
            {
                endDate = DateTime.Parse(searchParm["RegEndDate"].ToString());
            }
            isdjjyouth = searchParm["youthtype"].ToString();

            int? siteid = null;
            if (!Security.UserInRole("Administrators") && !Security.UserInRole("Administrators-NA") && !Security.UserInRole("CentralTeamUsers"))
            {
                siteid = int.Parse(Session["UsersSiteID"].ToString());
            }
            int programid = 0;
            int.TryParse(Session["ProgramID"].ToString(), out programid);
            list = POD.Logic.PeopleLogic.GetPersonBySearch(programid, siteid, grantYearID, searchParm["Name"] != "-1" ? searchParm["Name"].ToString() : null, searchParm["Guardian"] != "-1" ? searchParm["Guardian"].ToString() : null,
                                                                searchParm["Zip"] != "-1" ? searchParm["Zip"].ToString() : null, searchParm["School"] != "-1" ? searchParm["School"].ToString() : null,
                                                                typeid, statusid, startDate, endDate, searchParm["Race"] != "-1" ? searchParm["Race"].ToString() : string.Empty, searchParm["DJJ"] != "-1" ? searchParm["DJJ"].ToString() : null, searchParm["youthtype"] != "1" ? "0" : "1");



            return list;

        }

        /// <summary>
        /// redirect to action page or delete
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void RadMenu1_ItemClick(object sender, RadMenuEventArgs e)
        {
            int radGridClickedRowIndex;
            POD.MasterPages.Admin mtPage = (POD.MasterPages.Admin)this.Master;
            radGridClickedRowIndex = Convert.ToInt32(Request.Form["radGridClickedRowIndex"]);
            string personID = RadGridEnrollments.MasterTableView.DataKeyValues[radGridClickedRowIndex]["PersonID"].ToString();
            string enrollmentID = RadGridEnrollments.MasterTableView.DataKeyValues[radGridClickedRowIndex]["EnrollmentID"].ToString();
            string enrollmentType = RadGridEnrollments.MasterTableView.DataKeyValues[radGridClickedRowIndex]["EnrollmentTypeName"].ToString();

            string url = string.Empty;
            switch (e.Item.Value)
            {
                case "Rollover":
                    url = string.Format("~/Pages/EnrollmentPage.aspx?id={0}&ro=1&eid={1}", personID, enrollmentID);
                    break;
                case "ReEnrollment":
                    url = string.Format("~/Pages/EnrollmentPage.aspx?id={0}", personID);
                    break;
                case "Enrollment":
                    if (enrollmentType == "Risk Assessment")
                    {
                        url = string.Format("~/Pages/EnrollmentPage.aspx?id={0}&rid={1}", personID, enrollmentID);
                    }
                    else
                    {
                        url = string.Format("~/Pages/EnrollmentPage.aspx?id={0}&eid={1}", personID, enrollmentID);
                    }
                    break;
                case "PAT":
                    url = string.Format("~/Pages/PATForms.aspx?id={0}", personID);
                    break;
                case "RiskAssessment":
                    if (enrollmentType == "Risk Assessment")
                    {
                        url = string.Format("~/Pages/RiskAssessmentPage.aspx?pid={0}&rid={1}", personID, enrollmentID);
                    }
                    else
                    {
                        url = string.Format("~/Pages/RiskAssessmentPage.aspx?pid={0}&eid={1}", personID, enrollmentID);
                    }
                    break;
                case "Attendance":
                    url = string.Format("~/Pages/YouthAttendances.aspx?id={0}", personID);
                    break;
                case "Transfer":
                    break;
                case "Release":
                    break;
                case "Discharge":

                    Dictionary<string, byte[]> dischargeList = new Dictionary<string, byte[]>();

                    var enrollment = POD.Logic.PersonRelatedLogic.GetEnrollmentByID(Convert.ToInt32(enrollmentID));
                    GeneratePDFdata(enrollment.EnrollmentID, (DateTime)enrollment.RelDate, enrollment.RelReasonForLeaving, 0);

                    //var generatedPDF = GeneratePDFdata((int)enrollment.EnrollmentID, (DateTime)enrollment.RelDate, 0);
                    //dischargeList.Add(generatedPDF.Item1, generatedPDF.Item2);

                    //if (dischargeList.Any())
                    //{
                    //    GenerateDischargeZip(dischargeList, (DateTime)enrollment.RelDate);
                    //}

                    break;
                case "CompletionCertificate":
                    break;
                case "Delete":
                    if (enrollmentType == "Risk Assessment")
                    {
                        int eID = 0;
                        int.TryParse(enrollmentID, out eID);
                        string result = POD.Logic.PersonRelatedLogic.DeleteRiskAssessment(eID);
                        if (string.IsNullOrEmpty(result))
                        {
                            RadGridEnrollments.Rebind();
                        }
                    }
                    else if (!string.IsNullOrEmpty(enrollmentID))
                    {
                        int eID = 0;
                        int.TryParse(enrollmentID, out eID);
                        string result = POD.Logic.PersonRelatedLogic.DeleteEnrollment(eID);
                        if (string.IsNullOrEmpty(result))
                        {
                            RadGridEnrollments.Rebind();
                        }
                    }
                    break;
            }
            if (!string.IsNullOrEmpty(url))
            {
                Response.Redirect(url);
            }
        }

        private static void GenerateDischargeZip(Dictionary<string, byte[]> dischargeForms, DateTime releaseDate)
        {

            string fileName = string.Format("YouthDischargeForms_" + releaseDate.ToString("MMddyyyy") + ".zip");
            HttpContext.Current.Response.BufferOutput = false;  // for large files  
            using (Ionic.Zip.ZipFile zip = new Ionic.Zip.ZipFile())
            {

                foreach (var entry in dischargeForms)
                {

                    zip.AddEntry(entry.Key, entry.Value);
                }
                zip.CodecBufferSize = 500000 * dischargeForms.Count();
                zip.BufferSize = 500000 * dischargeForms.Count();
                zip.ParallelDeflateThreshold = -1;

                HttpContext.Current.Response.Clear();
                HttpContext.Current.Response.Buffer = true;
                HttpContext.Current.Response.ContentType = "application/zip";
                HttpContext.Current.Response.AddHeader(name: "Content-Disposition", value: "attachment;filename=" + fileName);
                Int64 fileSizeInBytes = 300000 * dischargeForms.Count();
                HttpContext.Current.Response.AddHeader("Content-Length", fileSizeInBytes.ToString());

                zip.Save(HttpContext.Current.Response.OutputStream);
                //HttpContext.Current.Response.Flush();
            }
        }
        public static Tuple<string, byte[]> GeneratePDFdata(int id, DateTime releasedate, int releasevalue)
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

                var strName = person.FirstName.Substring(0, 1) + person.LastName + "_DJJID_" + person.DJJIDNum + "_" + releasedate.ToString("MMddyyyy") + ".pdf";
                var encoding = System.Text.Encoding.UTF8;

                //ms.Position = 0;

                return Tuple.Create(strName, ms.ToArray());

            }
            catch (Exception ex)
            {
                ex.Log();
                throw;
            }



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

        /// <summary>
        /// binds data
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void RadGridEnrollments_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            RadGridEnrollments.DataSource = GetData();
        }


        protected void RadGridEnrollments_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item.ItemType == GridItemType.Item || e.Item.ItemType == GridItemType.AlternatingItem)
            {
                GridDataItem item = (GridDataItem)e.Item;
                if (item.Cells[10].Text.ToLower() == "released")
                {
                    RadMenuItem dischargeMenuItem = (RadMenuItem)RadMenuOptions.FindItemByValue("Discharge");
                    dischargeMenuItem.Visible = true;
                }

                if (Security.UserInRole("Administrators") && item.Cells[10].Text.ToLower() != "released")
                {
                    RadMenuItem dischargeMenuItem = (RadMenuItem)RadMenuOptions.FindItemByValue("Release");
                    if(PersonRelatedLogic.IsDateAHoliday() == true){
                        dischargeMenuItem.Visible = false;
                    }
                    else
                    {
                        dischargeMenuItem.Visible = true;
                    }
                    
                }


            }
        }
    }
}