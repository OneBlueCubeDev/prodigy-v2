using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using LumenWorks.Framework.IO.Csv;
using System.IO;
using POD.Data;
using System.Configuration;
using POD.Data.Entities;
using POD.Logging;
using POD.Logic;

namespace POD.Pages.Admin.Import
{
    public partial class ImportDJJNum : System.Web.UI.Page
    {
        List<ImportPerson> youthList = null;
        public static string UploadFilePath
        {
            get
            {
                return ConfigurationManager.AppSettings["SiteDirectory"] + ConfigurationManager.AppSettings["UploadFileFolder"];
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!Security.UserInRole("Administrators"))
                {
                    this.PanelImport.Visible = false;
                    this.PanelNoAccess.Visible = true;
                }
            }

        }
        private bool ParsXLS64Bit(string path, string filename, string type)
        {
            bool result = false;
            youthList = new List<ImportPerson>();
            try
            {
                if (type == "Diversion")
                {
                    ReadDiversionFile(path, filename);
                }
                else
                {
                    ReadPreventionFile(path, filename);
                }
                result = true;
            }
            catch (Exception ex)
            {
                LiteralErrorMessage.Text += "Error: " + ex.Message;
                ex.Log();
            }
            return result;
        }

        private void ReadPreventionFile(string path, string fileName)
        {
            using (CsvReader csv = new CsvReader(new StreamReader(path + "\\" + fileName), true, ','))
            {
                int counter = 1;
                int fieldCount = csv.FieldCount;
                foreach (var c in csv)
                {
                    int id = counter;
                    string category = Convert.ToString((object)c[0]).Trim();
                    string djjnum = Convert.ToString((object)c[1]).Trim();
                    string lastname = Convert.ToString((object)c[2]).Trim();
                    string firstname = Convert.ToString((object)c[3]).Trim();
                    string middlename = Convert.ToString((object)c[4]).Trim();
                    string race = Convert.ToString((object)c[5]).Trim();
                    string gender = Convert.ToString((object)c[6]).Trim();
                    string dob = Convert.ToString((object)c[7]).Trim();
                    string startDate = Convert.ToString((object)c[8]).Trim();
                    string endDate = Convert.ToString((object)c[9]).Trim();
                    string siteName = Convert.ToString((object)c[10]).Trim();

                    if (!string.IsNullOrEmpty(firstname) && !string.IsNullOrEmpty(lastname) && !string.IsNullOrEmpty(djjnum)) //these 3 fields is the minimum we need to create find a match
                    {
                        ImportPerson item = new ImportPerson(firstname, lastname, middlename, dob, id, djjnum, siteName, startDate, endDate, race, gender,category);
                        youthList.Add(item);
                    }
                    else //some missing data /possibly bad formatting
                    {
                        ImportPerson item = new ImportPerson(Convert.ToString((object)c[3]), Convert.ToString((object)c[2]), Convert.ToString((object)c[4]), Convert.ToString((object)c[7]), id,
                            Convert.ToString((object)c[1]), string.Empty, Convert.ToString((object)c[8]), Convert.ToString((object)c[9]), Convert.ToString((object)c[0]),
                            Convert.ToString((object)c[6]),Convert.ToString((object)c[5]),Convert.ToString((object)c[10]),string.Empty, "Missing Essential Data");
                        youthList.Add(item);
                    }
                    counter += 1;
                }

            }
        }

        private void ReadDiversionFile(string path, string fileName)
        {
            using (CsvReader csv = new CsvReader(new StreamReader(path + "\\" + fileName), true, ','))
            {
                int counter = 1;
                int fieldCount = csv.FieldCount;
                foreach (var c in csv)
                {
                    int id = counter;
                    string category = Convert.ToString((object)c[0]).Trim();
                    string circuit = Convert.ToString((object)c[1]).Trim();
                    string djjnum = Convert.ToString((object)c[2]).Trim();
                    string lastname = Convert.ToString((object)c[3]).Trim();
                    string firstname = Convert.ToString((object)c[4]).Trim();
                    string middlename = Convert.ToString((object)c[5]).Trim();
                    string suffix = Convert.ToString((object)c[6]).Trim();

                    if (!string.IsNullOrEmpty(firstname) && !string.IsNullOrEmpty(lastname) && !string.IsNullOrEmpty(djjnum)) //these 3 fields is the minimum we need to create a page
                    {
                        ImportPerson item = new ImportPerson(firstname, lastname, middlename, circuit, id, djjnum, suffix, category);
                        youthList.Add(item);

                    }
                    else //some missing data /possibly bad formatting
                    {
                        ImportPerson item = new ImportPerson(Convert.ToString((object) c[4]),
                                                             Convert.ToString((object) c[3]),
                                                             Convert.ToString((object) c[5]),
                                                             string.Empty, id, Convert.ToString((object) c[2]),
                                                             Convert.ToString((object) c[6]), string.Empty, string.Empty,
                                                             Convert.ToString((object) c[0]),
                                                             string.Empty, string.Empty, string.Empty,
                                                             Convert.ToString((object) c[1]), "Missing Essential Data");
                            
                           youthList.Add(item);
                    }
                    counter += 1;
                }

            }
        }

        protected void ButtonImport_Click(object sender, EventArgs e)
        {
            this.LiteralErrorMessage.Text = string.Empty;
            bool result = true;
            string strFileName = "";
            if (Page.IsValid)
            {
                string type = this.RadioButtonListType.SelectedIndex != -1 ? this.RadioButtonListType.SelectedValue : String.Empty;
                if (!string.IsNullOrEmpty(type))
                {
                    //do file upload
                    strFileName = "YouthDJJNumImport_" + DateTime.Now.ToString("MM_dd_yyyy_hh_mm") + ".csv";
                    if (!string.IsNullOrEmpty(strFileName))
                    {
                        try
                        {
                            FileUpload.PostedFile.SaveAs(UploadFilePath + "\\" + strFileName);

                        }
                        catch (Exception ex)
                        {
                            ex.Log();
                            LiteralErrorMessage.Text += "Error saving file:<br/>"
                                + ex.Message + "<br>"
                                + "Please contact the system administrator.<br/>";
                            result = false;
                        }
                    }
                    if (result == true)
                    {
                        if (ParsXLS64Bit(UploadFilePath, strFileName, type))//parse file and load into data object
                        {
                            FindAndProcessMatches();
                        }
                    }
                    else
                    {
                        LiteralErrorMessage.Text += "Error parsing Excel file!<br>Please make sure the provided Excel file follows the established guidelines for column names and data. If you have further problems, contact the system administrator.<br/>";
                    }
                    LiteralErrorMessage.Visible = true;
                }
                else
                {
                    return;
                }
            }
        }

        private void FindAndProcessMatches()
        {
            //get youth with no djj into memory
            List<Person> possibleMatchList = POD.Logic.PeopleLogic.GetPRefilteredDJJNumPossibleMatches();
            #region matching
            // try finding matches for each imported youth
            foreach (ImportPerson ip in youthList.Where(i => i.ErrorMessage == string.Empty))
            {
                DateTime? dop = null;
                if (!string.IsNullOrEmpty(ip.DateOfBirth))
                {
                    dop = Convert.ToDateTime(ip.DateOfBirth);
                }
                string completeLastName = ip.LastName + " " +ip.Suffix;
                List<Person> exactMatches = POD.Logic.PeopleLogic.GetYouthWithNoDJJByNameMatch(possibleMatchList, ip.FirstName, completeLastName.Trim(), ip.MiddleName, dop);
                if (exactMatches.Count > 0)
                {
                    if (exactMatches.Count == 1)//one match found
                    {
                        Person match = exactMatches.First();
                        
                        ip.MatchedFirstName = match.FirstName;
                        ip.MatchedLastName = match.LastName;
                        ip.MatchedMiddleName = match.MiddleName;
                        ip.MatchedDateOfBirth = match.DateOfBirth.HasValue ? match.DateOfBirth.Value.ToShortDateString() : string.Empty;
                        ip.PersonID = match.PersonID;
                    }
                    else //we can't process as more than 1 match was found
                    {
                        ip.PossibleMatchList = exactMatches;
                        ip.ErrorMessage = "Multiple Matches found";
                    }
                }
                else //set message
                {
                    ip.ErrorMessage = "No match found in the database";
                }
            }
            #endregion

            #region processing

            string result = POD.Logic.PeopleLogic.UpdateYouthsDJJNumberandEnrollmentStatus(youthList.Where(i => i.ErrorMessage == string.Empty).ToList());

            #endregion

            #region Results
            if (string.IsNullOrEmpty(result))
            {
                RepeaterResults.DataSource = youthList;
                RepeaterResults.DataBind();

                this.PanelUpload.Visible = false;
                this.PanelResults.Visible = true;
            }
            else
            {
                this.LiteralErrorMessage.Text = "Error occurred on DJJ # import:" + result;
            }
            #endregion

        }

        protected void RepeaterResults_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
            {
                ImportPerson currentPerson = e.Item.DataItem as ImportPerson;
                if (currentPerson != null)
                {
                    Literal info = (Literal)e.Item.FindControl("LiteralYouthInfo");
                    Literal matches = (Literal)e.Item.FindControl("LiteralPossibleMatches");
                    Literal msg = (Literal)e.Item.FindControl("LiteralMessage");

                    info.Text = string.Format("{0}. &nbsp;&nbsp;{1} {2} {3} &nbsp;&nbsp;&nbsp;&nbsp;{4} &nbsp;&nbsp;&nbsp;&nbsp;{5}", currentPerson.ID, currentPerson.FirstName, currentPerson.MiddleName, currentPerson.LastName, currentPerson.DateOfBirth, currentPerson.DJJNumber);
                    msg.Text = !string.IsNullOrEmpty(currentPerson.ErrorMessage) ? currentPerson.ErrorMessage : "Successfully inserted DJJ # in found match";
                    if (currentPerson.PossibleMatchList!=null && currentPerson.PossibleMatchList.Count > 0)
                    {
                        string matchMarkup = "<h3>Found Possible Matches</h3>";
                        matchMarkup += "<table class='ClassRegistrationTable'>";
                        foreach (Person mt in currentPerson.PossibleMatchList)
                        {
                            matchMarkup += "<tr><td class='Name'>" + string.Format("{0} {1} {2} </td><td class='DOB'>{3} </td><td class='DJJNum'>{4}", mt.FirstName, mt.MiddleName, mt.LastName, mt.DateOfBirth.HasValue ? mt.DateOfBirth.Value.ToShortDateString() : string.Empty, mt.Gender != null ? mt.Gender.Name : "Unknown") + "</td></tr>";
                        }
                        matchMarkup += "</table>";
                        matches.Text = matchMarkup;
                    }
                }
            }
        }

        protected void ButtonBackToImport_Click(object sender, EventArgs e)
        {
            this.LiteralErrorMessage.Text = string.Empty;
            this.PanelResults.Visible = false;
            this.PanelUpload.Visible = true;

        }
    }
}