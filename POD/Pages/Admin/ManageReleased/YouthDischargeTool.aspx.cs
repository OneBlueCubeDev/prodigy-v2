using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using POD.Logging;
using Telerik.Web.UI;
using POD.Data.Entities;
using POD.Logic;
using iTextSharp.text.pdf;
using System.IO;
using Ionic.Zip;


namespace POD.Pages.Admin.ManageReleased
{
    public partial class YouthDischargeTool : System.Web.UI.Page
    {
        public List<int> enrollmentIDList = new List<int>();
        private int filter = 0;
        private int startIndex = 0;
        public int CurrentStartingPageIndex
        {
            get
            {
                if (ViewState["CurrentStartingPageIndex"] != null)
                {
                    int.TryParse(ViewState["CurrentStartingPageIndex"].ToString(), out startIndex);
                    return startIndex;
                }
                else return 0;
            }
            set
            {
                ViewState["CurrentStartingPageIndex"] = value;
            }
        }
        public int Filter
        {
            get
            {
                if (ViewState["Filter"] != null)
                {
                    int.TryParse(ViewState["Filter"].ToString(), out filter);
                    return filter;
                }
                else return 0;
            }
            set
            {
                ViewState["Filter"] = value;
            }
        }
        public bool? ClassRelatedFilter
        {
            get
            {
                if (ViewState["ClassRelatedFilter"] != null)
                {
                    return bool.Parse(ViewState["ClassRelatedFilter"].ToString());

                }
                else return null;
            }
            set
            {
                ViewState["ClassRelatedFilter"] = value;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                if (PersonRelatedLogic.IsDateAHoliday() == true)
                {
                    this.ButtonUpdate2.Visible = false;
                }
                else
                {
                    this.ButtonUpdate2.Visible = true;
                }
                
                

                //GetData();
            }
        }

        

        protected void secureFilterSite_OnAuthorizationFailed(object sender, EventArgs e)
        {
            var siteId = Convert.ToInt32(Session["UsersSiteID"]);
            if (Page.IsPostBack == false)
            {
                DropDownSites.Items.Clear();
                Site site = LookUpTypesLogic.GetSiteByID(siteId);
                DropDownSites.DataSource = new[] { site };
                DropDownSites.DataBind();


            }
        }

        protected void secureFilterSite_OnAuthorizationPassed(object sender, EventArgs e)
        {
            if (Page.IsPostBack == false)
            {
                DropDownSites.DataSource = LookUpTypesLogic.GetSites();
                DropDownSites.DataBind();
                if (Security.UserInRole("Administrators") || !Security.UserInRole("CentralTeamUsers"))
                {
                    this.DropDownSites.Items.Insert(0, new RadComboBoxItem("All", ""));
                }
            }
        }

        private void GetData()
        {

           
            int? tempsiteid = DropDownSites.SelectedItem.Value != string.Empty ? Convert.ToInt32(DropDownSites.SelectedItem.Value) : 0;
            DateTime? releaseDate = RadDatePickerReleaseDate.SelectedDate;

            int? siteid = null;

            if (tempsiteid == 0)
            {
                siteid = null;
            }
            else
            {
                siteid = tempsiteid;
            }
            
            
            
            int progID = 0;
            if (Session["ProgramID"] != null)
            {
                int.TryParse(Session["ProgramID"].ToString(), out progID);
            }
            //if (ListViewData.Items.Count != 0) { ListViewData.Items.Clear(); }
            
            //ListViewData.DataSource = POD.Logic.PeopleLogic.GetReleasedYouthByDate(releaseDate, siteid);
            //ListViewData.DataBind();

            RadGrid1.DataSource = POD.Logic.PeopleLogic.GetReleasedYouthByDate(releaseDate, siteid);
            RadGrid1.DataBind();
           
                       

        }

        //protected void ListViewData_ItemUpdating(object sender, ListViewUpdateEventArgs e)
        //{
        //    int itemIndex = CurrentStartingPageIndex != 0 ? e.ItemIndex - CurrentStartingPageIndex : e.ItemIndex;

        //    ListViewItem item = (ListViewItem)ListViewData.Items[itemIndex];

        //    if (item != null)
        //    {

        //        CheckBox releasecheck = (CheckBox)item.FindControl("CheckBox");
        //        if (releasecheck.Checked)
        //        {
        //            int personid = Convert.ToInt32(ListViewData.DataKeys[itemIndex].Values["PersonID"]);
        //            int enrollID = Convert.ToInt32(ListViewData.DataKeys[itemIndex].Values["EnrollmentID"]);
        //            string type = ListViewData.DataKeys[itemIndex].Values["EnrollmentTypeName"].ToString();
        //            int addressid = Convert.ToInt32(ListViewData.DataKeys[itemIndex].Values["AddressID"]);
        //            int phoneid = Convert.ToInt32(ListViewData.DataKeys[itemIndex].Values["HomePhoneID"]);

                   
        //            //int? grantyearid = this.RadioButtonListReleaseAgency.SelectedIndex != -1 ? this.RadioButtonListReleaseAgency.SelectedValue : string.Empty
        //            //int? agencyid = Convert.ToInt32(RadioButtonListReleaseAgency.SelectedItem.Value);
        //            //int? tempsiteid = Convert.ToInt32(DropDownSites.SelectedItem.Value);

        //            enrollmentIDList.Add(POD.Logic.RiskAssessmentLogic.GetEnrollmentIDByEnrollmentIDOrRiskAssessmentID(enrollID, type));

        //            try
        //            {
                        
        //                enrollmentIDList.Clear();
        //            }
        //            catch (Exception ex)
        //            {
        //                ex.Log();
        //            }
        //        }

                
        //    }
        //}

        

        /// <summary>
        /// updates all selected records with release dates
        /// </summary>
        
        

        

        protected void ListViewData_ItemDataBound(object sender, ListViewItemEventArgs e)
        {
            ListViewDataItem lvdi = (ListViewDataItem)e.Item;

            sp_ReleasedYouthByDate_Result dtItem = (sp_ReleasedYouthByDate_Result)lvdi.DataItem;

            RadDatePicker dob = (RadDatePicker)e.Item.FindControl("RadDatePickerDOB");
            RadMaskedTextBox zip = (RadMaskedTextBox)e.Item.FindControl("TextBoxZip");
            RadMaskedTextBox phone = (RadMaskedTextBox)e.Item.FindControl("TextBoxPhone");
            RadComboBox county = (RadComboBox)e.Item.FindControl("RadComboBoxCounty");

            
           
        }

        protected void RadGrid1_ItemDataBound(object sender, Telerik.Web.UI.GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem dataItem = e.Item as GridDataItem;
                if (dataItem.Selected)
                {
                    CheckBox checkBox = (CheckBox)dataItem["ClientSelectColumn"].Controls[0];
                    dataItem.Selected = true;
                }
            }
        }

        protected void Update_Click(object sender, EventArgs e)
        {

            Dictionary<string, MemoryStream> dischargeList = new Dictionary<string, MemoryStream>();
            
            int? tempsiteid = DropDownSites.SelectedItem.Value != string.Empty ? Convert.ToInt32(DropDownSites.SelectedItem.Value) : 0;
            DateTime? releaseDate = RadDatePickerReleaseDate.SelectedDate;

            int? siteid = null;

            if (tempsiteid == 0)
            {
                siteid = null;
            }
            else
            {
                siteid = tempsiteid;
            }

            var result = POD.Logic.PeopleLogic.GetReleasedYouthByDate(releaseDate, siteid);

           
            foreach (var item in result)
            {
                
                var generatedPDF = GeneratePDFdata((int)item.enrollmentId, (DateTime)releaseDate, 0);
                dischargeList.Add(generatedPDF.Item1, generatedPDF.Item2);
            }

            if (dischargeList.Any())
            {
                GenerateDischargeZip(dischargeList, (DateTime)releaseDate);
            }
           
        }

        private static void GenerateDischargeZip1(Dictionary<string, MemoryStream> dischargeForms, DateTime releaseDate)
        {

            string fileName = string.Format("YouthDischargeForms_" + releaseDate.ToString("MMddyyyy") + ".zip");
            HttpContext.Current.Response.BufferOutput = false;  // for large files  
            using (Ionic.Zip.ZipFile zip = new Ionic.Zip.ZipFile())
            {
                
                foreach (var entry in dischargeForms)
                {
                    zip.AddEntry(entry.Key, entry.Value.ToArray());
                }
                zip.CodecBufferSize = 600000 * dischargeForms.Count();
                zip.BufferSize = 600000 * dischargeForms.Count();
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

        //updated
        private static void GenerateDischargeZip(Dictionary<string, MemoryStream> dischargeForms, DateTime releaseDate)
        {
            int maxFileSizeBytes = 25 * 1024 * 1024; // 6MB

            string baseFileName = "YouthDischargeForms_" + releaseDate.ToString("MMddyyyy");
            int fileCount = 1;
            bool singleDischarge = false;

            if(dischargeForms.Count == 1)
            {
                singleDischarge = true;
            }
            

            var formsEnumerator = dischargeForms.GetEnumerator();
            while (formsEnumerator.MoveNext())
            {
                string fileName = baseFileName + "_" + fileCount + ".zip";
                int fileSizeSoFar = 0;

                using (Ionic.Zip.ZipFile zip = new Ionic.Zip.ZipFile())
                {
                    
                    bool addedEntry = false;
                    if (singleDischarge)
                    {
                        var entry = formsEnumerator.Current;

                        byte[] buffer;

                        using (MemoryStream entryStream = entry.Value)
                        {
                            buffer = entryStream.ToArray();
                            int entrySize = buffer.Length;

                            if (fileSizeSoFar + entrySize <= maxFileSizeBytes)
                            {
                                zip.AddEntry(entry.Key, buffer);
                                fileSizeSoFar += entrySize;
                                addedEntry = true;
                            }
                            else
                            {
                                break;
                            }
                        }
                    }
                    else
                    {
                        while (formsEnumerator.MoveNext())
                        {
                            var entry = formsEnumerator.Current;

                            byte[] buffer;

                            using (MemoryStream entryStream = entry.Value)
                            {
                                buffer = entryStream.ToArray();
                                int entrySize = buffer.Length;

                                if (fileSizeSoFar + entrySize <= maxFileSizeBytes)
                                {
                                    zip.AddEntry(entry.Key, buffer);
                                    fileSizeSoFar += entrySize;
                                    addedEntry = true;
                                }
                                else
                                {
                                    break;
                                }
                            }
                        }
                    }
                    

                    if (addedEntry)
                    {
                        using (var outputMemoryStream = new MemoryStream())
                        {
                            zip.Save(outputMemoryStream);
                            HttpContext.Current.Response.ClearHeaders();
                            HttpContext.Current.Response.Clear();
                            HttpContext.Current.Response.Buffer = true;
                            HttpContext.Current.Response.ContentType = "application/zip";
                            HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment;filename=" + fileName);
                            HttpContext.Current.Response.AddHeader("Content-Length", outputMemoryStream.Length.ToString());
                            HttpContext.Current.Response.BinaryWrite(outputMemoryStream.ToArray());
                            HttpContext.Current.Response.Flush();
                        }
                    }
                }

                fileCount++;
            }

            HttpContext.Current.Response.End();
        }


        public static Tuple<string, MemoryStream> GeneratePDFdata(int id, DateTime releasedate, int releasevalue)
        {
            

            try
            {
                int counter = 1;
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

                DateTime now = DateTime.Now;

                string formattedGenTime = now.ToString("mmssff");

                var strName = person.FirstName.Substring(0, 1) + person.LastName + "_DJJID_" + person.DJJIDNum + "_" + releasedate.ToString("MMddyyyy") + "_" + formattedGenTime + ".pdf";
                var encoding = System.Text.Encoding.UTF8;

                return Tuple.Create(strName, ms);


            }
            catch (Exception ex)
            {
                ex.Log();
                throw;
            }



        }

        protected void RadDatePickerReleaseDate_OnLoad(object sender, EventArgs e)
        {
            var dp = (RadMonthYearPicker)sender;
            if (Page.IsPostBack == false)
            {
                dp.SelectedDate = DateTime.Now;
            }
        }

        protected void Find_Click(object sender, EventArgs e)
        {
            GetData();
        }

        //protected void ListViewData_PagePropertiesChanging(object sender, PagePropertiesChangingEventArgs e)
        //{
        //    ListViewData.SaveItems();
        //    DataPagerStudents.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);
        //    GetData();
        //    CurrentStartingPageIndex = e.StartRowIndex;
        //}

        

        protected void RadGrid1_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridHeaderItem headerItem = (GridHeaderItem)RadGrid1.MasterTableView.GetItems(GridItemType.Header)[0];
            if((CheckBox)headerItem["GridClientSelectColumn"].Controls[0] != null) { 
                CheckBox headerChkBox = (CheckBox)headerItem["GridClientSelectColumn"].Controls[0];
                if (headerChkBox.Checked)
                {
                    // header CheckBox is clicked
                }
                else
                {
                    // check box inside Grid row is clicked
                }
            }
        }

        protected void RadGrid1_ItemCreated(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridHeaderItem)
            {
                GridHeaderItem headerItem = (GridHeaderItem)e.Item;
               // CheckBox headerChkBox = (CheckBox)headerItem["GridClientSelectColumn"].Controls[0];
                //headerChkBox.AutoPostBack = true;
                //headerChkBox.CheckedChanged += new EventHandler(headerChkBox_CheckedChanged);
            }
        }

        void headerChkBox_CheckedChanged(object sender, EventArgs e)
        {
            // Here is your code when header clicked
        }
    }
}