using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using POD.Data.Entities;
using POD.Logging;
using WebSupergoo.ABCpdf7;
using POD.Logic;
namespace POD.Pages
{
    public partial class DownLoad : System.Web.UI.Page
    {
        private int personid = 0;
        private int enrollID = 0;
        private int riskID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["pid"]))
            {
                int.TryParse(Request.QueryString["pid"].ToString(), out personid);

            }
            if (!string.IsNullOrEmpty(Request.QueryString["tp"]))//if we have a type
            {
                if (Request.QueryString["tp"].ToString() == "en")//type = Enrollement
                {
                    if (!string.IsNullOrEmpty(Request.QueryString["eid"]))
                    {
                        int.TryParse(Request.QueryString["eid"].ToString(), out enrollID);

                    }
                }
                else //type = Risk Assessment
                {
                    if (!string.IsNullOrEmpty(Request.QueryString["eid"]))
                    {
                        int.TryParse(Request.QueryString["eid"].ToString(), out riskID);
                    }
                }
            }
            bool iseligible = POD.Logic.PeopleLogic.GetStudentEligibleForCertificate(personid, enrollID, riskID);
            if (iseligible)
            {
                SetEnrollmentDateGraduated(enrollID);
                DownLoadCertificate(personid);
                this.PanelCertificate.Visible = true;
                this.PanelNotEligible.Visible = false;
            }
            else
            {
                this.PanelCertificate.Visible = false;
                this.PanelNotEligible.Visible = true;
            }
        }

        private void SetEnrollmentDateGraduated(int enrollmentId)
        {
            POD.Logic.PeopleLogic.SetEnrollmentDateGraduated(enrollmentId, DateTime.Today);
        }

        private void DownLoadCertificate(int personid)
        {
            try
            {
                string addedTime = DateTime.Now.ToString("MM_dd_yy_HH_mm_ss");
                Person currentPerson = POD.Logic.PeopleLogic.GetPersonByID(personid);
                string fullpath = Server.MapPath(@"~\" + ConfigurationManager.AppSettings["CertificatePath"] + currentPerson.FirstName.First() + "_" + currentPerson.LastName + "_" + addedTime + ".pdf");

                this.HyperLink.NavigateUrl = "~/" + ConfigurationManager.AppSettings["CertificatePath"].Replace("\\", "/") + currentPerson.FirstName.First() + "_" + currentPerson.LastName + "_" + addedTime + ".pdf";

                //string fullpath = Server.MapPath(@"~\" + ConfigurationManager.AppSettings["CertificatePath"] + "168_09_07_12_08_08_44.pdf");
                string fileName = currentPerson.FullName.Replace(" ", "") + ".pdf";
                //// Create new PDF Document
                Doc theDoc = new Doc();
                // apply a rotation transform
                double w = theDoc.MediaBox.Width;
                double h = theDoc.MediaBox.Height;
                double l = theDoc.MediaBox.Left;
                double b = theDoc.MediaBox.Bottom;
                theDoc.Transform.Rotate(90, l, b);
                theDoc.Transform.Translate(w, 0);

                // rotate our rectangle
                theDoc.Rect.Width = h;
                theDoc.Rect.Height = w;
                // theDoc.Rect.String = "5 35 607 767";

                //if (!Request.Url.ToString().Contains("staging.") && !Request.Url.ToString().Contains("localhost"))
                //{
                //    //type is needed for encryption method
                //    theDoc.Encryption.Type = 2;
                //    //encryption="128-bit" 
                //    theDoc.Encryption.SetCryptMethods(CryptMethodType.AESV2);
                //    //set all other options to false
                //    theDoc.Encryption.CanAssemble = false;
                //    theDoc.Encryption.CanChange = false;
                //    theDoc.Encryption.CanEdit = false;
                //    theDoc.Encryption.CanExtract = false;
                //    theDoc.Encryption.CanFillForms = false;
                //    //allow print /copy
                //    theDoc.Encryption.CanPrint = true;
                //    theDoc.Encryption.CanCopy = true;
                //}

                // Take snapshot of rendered html
                string url = string.Format("{0}{1}?pid={2}&fn={3}",
                                           Request.Url.GetLeftPart(UriPartial.Authority),
                                           VirtualPathUtility.ToAbsolute("~/Templates/Certificates/PODCompletionCertificate.aspx"),
                                           personid,
                                           Guid.NewGuid().ToString().Replace("-", string.Empty));

                int theID = theDoc.AddImageUrl(url);

                // Loop over length of html page and add pages
                while (true)
                {
                    if (!theDoc.Chainable(theID))
                    {
                        break;
                    }
                    theDoc.Page = theDoc.AddPage();
                    theID = theDoc.AddImageToChain(theID);
                }
                //save landscape
                theDoc.SetInfo(theID, "/Rotate", "90");
                // Save the document
                theDoc.Save(fullpath);
                theDoc.Clear();

            }
            catch (Exception ex)
            {
                ex.Log();
                Response.Write(ex.Message);
            }
        }

        //protected void ButtonDownLoad_Click(object sender, EventArgs e)
        //{
        //    //Response.Clear();
        //    //Response.AddHeader("Content-disposition", "attachment; filename=" + fileName);
        //    //Response.ContentType = "application/pdf";

        //    //Response.TransmitFile(fullpath);
        //    //Response.End();
        //}
    }
}