using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using iTextSharp;
using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.text.xml;
using System.IO;

namespace POD.Utillities
{
    public class applicationprinter
    {
        public applicationprinter()
        {

        }

        public string enrollmentId { get; set; }


        private void FillPODForm()
        {
            string pdfTemplate = @"c:\Temp\PDF\pod.pdf";
            string newFile = @"c:\Temp\PDF\completed_pod.pdf";


            PdfReader pdfReader = new PdfReader(pdfTemplate);

            PdfStamper pdfStamper = new PdfStamper(pdfReader, new FileStream(
                        newFile, FileMode.Create));



            AcroFields pdfFormFields = pdfStamper.AcroFields;


            // set form pdfFormFields

            // Section 1

            pdfFormFields.SetField("s1_race_black", "Yes");
            pdfFormFields.SetField("s1_race_white", "Yes");
            pdfFormFields.SetField("s1_gender_f", "Yes");
            pdfFormFields.SetField("s1_gender_m", "Yes");
            pdfFormFields.SetField("s1_fname", "Shane");
            pdfFormFields.SetField("s1_lname", "Burke");
            pdfFormFields.SetField("s1_mname", "Kerry");
            pdfFormFields.SetField("s1_address", "11121 Cypress Ave");
            pdfFormFields.SetField("s1_age", "19");
            pdfFormFields.SetField("s1_dob", "01/01/1975");
            pdfFormFields.SetField("s1_address2", "Suite 20");
            pdfFormFields.SetField("s1_apt", "123");
            pdfFormFields.SetField("s1_state", "FL");
            pdfFormFields.SetField("s1_city", "Tampa");
            pdfFormFields.SetField("s1_language", "English");
            pdfFormFields.SetField("s1_zip", "23123");
            pdfFormFields.SetField("s1_hillsborough", "Yes");
            pdfFormFields.SetField("s1_refer_other", "My Mother");

            pdfFormFields.SetField("s1_grade", "12");
            pdfFormFields.SetField("s1_school_address", "5505 West Cypess Ave");
            pdfFormFields.SetField("s1_school_address2", "Suite 709");
            pdfFormFields.SetField("s1_school_name", "USF");
            pdfFormFields.SetField("s1_school_city", "Tampa");
            pdfFormFields.SetField("s1_school_apt", "");
            pdfFormFields.SetField("s1_school_zip", "33607");
            pdfFormFields.SetField("s1_school_phone", "8137328296");
            pdfFormFields.SetField("s1_school_state", "FL");
            pdfFormFields.SetField("s1_school_yes", "Yes");
            pdfFormFields.SetField("s1_school_no", "Yes");

            pdfFormFields.SetField("s1_lg1_fname", "Matthew");
            pdfFormFields.SetField("s1_lg1_lname", "Burke");
            pdfFormFields.SetField("s1_lg1_mname", "Sean");
            pdfFormFields.SetField("s1_lg1_hphone", "8135555555");
            pdfFormFields.SetField("s1_lg1_wphone", "8135555555");
            pdfFormFields.SetField("s1_lg1_cphone", "8135555555");
            pdfFormFields.SetField("s1_lg1_rel_m", "Yes");
            pdfFormFields.SetField("s1_lg1_rel_f", "Yes");
            pdfFormFields.SetField("s1_lg1_rel_lg", "Yes");
            pdfFormFields.SetField("s1_lg1_rel_o", "Yes");
            pdfFormFields.SetField("s1_lg1_rel_o_desc", "Some Description");
            pdfFormFields.SetField("s1_lg2_fname", "Krista");
            pdfFormFields.SetField("s1_lg2_lname", "Burke");
            pdfFormFields.SetField("s1_lg2_mname", "Patricia");
            pdfFormFields.SetField("s1_lg2_hphone", "8135555555");
            pdfFormFields.SetField("s1_lg2_wphone", "8135555555");
            pdfFormFields.SetField("s1_lg2_cphone", "8135555555");
            pdfFormFields.SetField("s1_lg2_rel_m", "Yes");
            pdfFormFields.SetField("s1_lg2_rel_f", "Yes");
            pdfFormFields.SetField("s1_lg2_rel_lg", "Yes");
            pdfFormFields.SetField("s1_lg2_rel_o", "Yes");
            pdfFormFields.SetField("s1_lg2_rel_o_desc", "Some Description");

            pdfFormFields.SetField("s1_lg1_emergency", "Yes");
            pdfFormFields.SetField("s1_lg2_emergency", "Yes");
            pdfFormFields.SetField("s1_lg1_email", "sburke@nyl.com");
            pdfFormFields.SetField("s1_lg2_email", "sburke@POD.net");




            //Section 2
            pdfFormFields.SetField("s2_lg1_fname", "Mark");
            pdfFormFields.SetField("s2_lg1_lname", "Burke");
            pdfFormFields.SetField("s2_lg1_mname", "Ronald");
            pdfFormFields.SetField("s2_lg1_hphone", "8135555599");
            pdfFormFields.SetField("s2_lg1_wphone", "8135555599");
            pdfFormFields.SetField("s2_lg1_cphone", "8135555599");
            pdfFormFields.SetField("s2_lg1_rel_m", "Yes");
            pdfFormFields.SetField("s2_lg1_rel_f", "Yes");
            pdfFormFields.SetField("s2_lg1_rel_lg", "Yes");
            pdfFormFields.SetField("s2_lg1_rel_o", "Yes");
            pdfFormFields.SetField("s2_lg1_rel_o_desc", "Some Description");
            pdfFormFields.SetField("s2_lg2_fname", "Allyson");
            pdfFormFields.SetField("s2_lg2_lname", "Burke");
            pdfFormFields.SetField("s2_lg2_mname", "Renee");
            pdfFormFields.SetField("s2_lg2_hphone", "8135555599");
            pdfFormFields.SetField("s2_lg2_wphone", "8135555599");
            pdfFormFields.SetField("s2_lg2_cphone", "8135555599");
            pdfFormFields.SetField("s2_lg2_rel_m", "Yes");
            pdfFormFields.SetField("s2_lg2_rel_f", "Yes");
            pdfFormFields.SetField("s2_lg2_rel_lg", "Yes");
            pdfFormFields.SetField("s2_lg2_rel_o", "Yes");
            pdfFormFields.SetField("s2_lg2_rel_o_desc", "Some Description");
            pdfFormFields.SetField("s2_selfsignin", "Yes");
            pdfFormFields.SetField("s2_signinandout", "Yes");
            pdfFormFields.SetField("s2_signin_other", "Yes");
            pdfFormFields.SetField("s2_selfsignin_desc", "Some Description");




            //Section 3
            pdfFormFields.SetField("s3_doc_name", "Craig Gordon");
            pdfFormFields.SetField("s3_doc_address", "55 Tampa Prodigy Center");
            pdfFormFields.SetField("s3_ins_name", "Aetna");
            pdfFormFields.SetField("s3_ins_polnumber", "1234567");
            pdfFormFields.SetField("s3_doc_phone", "7088898990");
            pdfFormFields.SetField("s3_ins_group_no", "987654");
            pdfFormFields.SetField("s3_youthname", "Wesley Burke");
            pdfFormFields.SetField("s3_medications", "N/A");
            pdfFormFields.SetField("s3_med_conditions", "Smart Mouth");
            pdfFormFields.SetField("s3_special_other", "Some Description");

            //Section 4
            pdfFormFields.SetField("s4_sitename", "Tampa Prodigy Center");

            //Section 5
            pdfFormFields.SetField("s5_initials", "SKB");
            //Section 6
            pdfFormFields.SetField("s6_initials", "SKB");

            // flatten the form to remove editting options, set it to false
            // to leave the form open to subsequent manual edits
            pdfStamper.FormFlattening = true;

            // close the pdf
            pdfStamper.Close();
        }

        public static void ShowForm()
        {
            HttpContext.Current.Response.ContentType = "application/pdf";
            HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=PODApplication.pdf");
            HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);

            string sTemplate = @"c:\Temp\PDF\pod.pdf";

            PdfReader pdfReader = new PdfReader(sTemplate);

            //PdfWriter.GetInstance(pdfDoc, HttpContext.Current.Response.OutputStream)

            //pdfDoc.Open()
            //'WRITE PDF <<<<<<

            //stamp the fields 

            //'END WRITE PDF >>>>>
            //pdfDoc.Close()

            //HttpContext.Current.Response.Write(pdfDoc);
            //HttpContext.Current.Response.End();
        }

        public static void GeneratePDFdata(int id)
        {
            MemoryStream ms = new MemoryStream();

            string sTemplate = @"c:\Temp\PDF\pod.pdf";

            PdfReader pdfReader = new PdfReader(sTemplate);

            FileStream fs = new FileStream(@"c:\temp\pdf\testfile.pdf", FileMode.Create, FileAccess.Write, FileShare.None);
            PdfStamper pdfStamper = new PdfStamper(pdfReader, ms);

            PdfContentByte cb = pdfStamper.GetOverContent(1);

            AcroFields pdfFormFields = pdfStamper.AcroFields;


            // set form pdfFormFields

            // Section 1

            pdfFormFields.SetField("s1_race_black", "Yes");
            pdfFormFields.SetField("s1_race_white", "Yes");
            pdfFormFields.SetField("s1_gender_f", "Yes");
            pdfFormFields.SetField("s1_gender_m", "Yes");
            pdfFormFields.SetField("s1_fname", "Shane");
            pdfFormFields.SetField("s1_lname", "Burke");
            pdfFormFields.SetField("s1_mname", "Kerry");
            pdfFormFields.SetField("s1_address", "11121 Cypress Ave");
            pdfFormFields.SetField("s1_age", "19");
            pdfFormFields.SetField("s1_dob", "01/01/1975");
            pdfFormFields.SetField("s1_address2", "Suite 20");
            pdfFormFields.SetField("s1_apt", "123");
            pdfFormFields.SetField("s1_state", "FL");
            pdfFormFields.SetField("s1_city", "Tampa");
            pdfFormFields.SetField("s1_language", "English");
            pdfFormFields.SetField("s1_zip", "23123");
            pdfFormFields.SetField("s1_hillsborough", "Yes");
            pdfFormFields.SetField("s1_refer_other", "My Mother");

            pdfFormFields.SetField("s1_grade", "12");
            pdfFormFields.SetField("s1_school_address", "5505 West Cypess Ave");
            pdfFormFields.SetField("s1_school_address2", "Suite 709");
            pdfFormFields.SetField("s1_school_name", "USF");
            pdfFormFields.SetField("s1_school_city", "Tampa");
            pdfFormFields.SetField("s1_school_apt", "");
            pdfFormFields.SetField("s1_school_zip", "33607");
            pdfFormFields.SetField("s1_school_phone", "8137328296");
            pdfFormFields.SetField("s1_school_state", "FL");
            pdfFormFields.SetField("s1_school_yes", "Yes");
            pdfFormFields.SetField("s1_school_no", "Yes");

            pdfFormFields.SetField("s1_lg1_fname", "Matthew");
            pdfFormFields.SetField("s1_lg1_lname", "Burke");
            pdfFormFields.SetField("s1_lg1_mname", "Sean");
            pdfFormFields.SetField("s1_lg1_hphone", "8135555555");
            pdfFormFields.SetField("s1_lg1_wphone", "8135555555");
            pdfFormFields.SetField("s1_lg1_cphone", "8135555555");
            pdfFormFields.SetField("s1_lg1_rel_m", "Yes");
            pdfFormFields.SetField("s1_lg1_rel_f", "Yes");
            pdfFormFields.SetField("s1_lg1_rel_lg", "Yes");
            pdfFormFields.SetField("s1_lg1_rel_o", "Yes");
            pdfFormFields.SetField("s1_lg1_rel_o_desc", "Some Description");
            pdfFormFields.SetField("s1_lg2_fname", "Krista");
            pdfFormFields.SetField("s1_lg2_lname", "Burke");
            pdfFormFields.SetField("s1_lg2_mname", "Patricia");
            pdfFormFields.SetField("s1_lg2_hphone", "8135555555");
            pdfFormFields.SetField("s1_lg2_wphone", "8135555555");
            pdfFormFields.SetField("s1_lg2_cphone", "8135555555");
            pdfFormFields.SetField("s1_lg2_rel_m", "Yes");
            pdfFormFields.SetField("s1_lg2_rel_f", "Yes");
            pdfFormFields.SetField("s1_lg2_rel_lg", "Yes");
            pdfFormFields.SetField("s1_lg2_rel_o", "Yes");
            pdfFormFields.SetField("s1_lg2_rel_o_desc", "Some Description");

            pdfFormFields.SetField("s1_lg1_emergency", "Yes");
            pdfFormFields.SetField("s1_lg2_emergency", "Yes");
            pdfFormFields.SetField("s1_lg1_email", "sburke@nyl.com");
            pdfFormFields.SetField("s1_lg2_email", "sburke@POD.net");




            //Section 2
            pdfFormFields.SetField("s2_lg1_fname", "Mark");
            pdfFormFields.SetField("s2_lg1_lname", "Burke");
            pdfFormFields.SetField("s2_lg1_mname", "Ronald");
            pdfFormFields.SetField("s2_lg1_hphone", "8135555599");
            pdfFormFields.SetField("s2_lg1_wphone", "8135555599");
            pdfFormFields.SetField("s2_lg1_cphone", "8135555599");
            pdfFormFields.SetField("s2_lg1_rel_m", "Yes");
            pdfFormFields.SetField("s2_lg1_rel_f", "Yes");
            pdfFormFields.SetField("s2_lg1_rel_lg", "Yes");
            pdfFormFields.SetField("s2_lg1_rel_o", "Yes");
            pdfFormFields.SetField("s2_lg1_rel_o_desc", "Some Description");
            pdfFormFields.SetField("s2_lg2_fname", "Allyson");
            pdfFormFields.SetField("s2_lg2_lname", "Burke");
            pdfFormFields.SetField("s2_lg2_mname", "Renee");
            pdfFormFields.SetField("s2_lg2_hphone", "8135555599");
            pdfFormFields.SetField("s2_lg2_wphone", "8135555599");
            pdfFormFields.SetField("s2_lg2_cphone", "8135555599");
            pdfFormFields.SetField("s2_lg2_rel_m", "Yes");
            pdfFormFields.SetField("s2_lg2_rel_f", "Yes");
            pdfFormFields.SetField("s2_lg2_rel_lg", "Yes");
            pdfFormFields.SetField("s2_lg2_rel_o", "Yes");
            pdfFormFields.SetField("s2_lg2_rel_o_desc", "Some Description");
            pdfFormFields.SetField("s2_selfsignin", "Yes");
            pdfFormFields.SetField("s2_signinandout", "Yes");
            pdfFormFields.SetField("s2_signin_other", "Yes");
            pdfFormFields.SetField("s2_selfsignin_desc", "Some Description");




            //Section 3
            pdfFormFields.SetField("s3_doc_name", "Craig Gordon");
            pdfFormFields.SetField("s3_doc_address", "55 Tampa Prodigy Center");
            pdfFormFields.SetField("s3_ins_name", "Aetna");
            pdfFormFields.SetField("s3_ins_polnumber", "1234567");
            pdfFormFields.SetField("s3_doc_phone", "7088898990");
            pdfFormFields.SetField("s3_ins_group_no", "987654");
            pdfFormFields.SetField("s3_youthname", "Wesley Burke");
            pdfFormFields.SetField("s3_medications", "N/A");
            pdfFormFields.SetField("s3_med_conditions", "Smart Mouth");
            pdfFormFields.SetField("s3_special_other", "Some Description");

            //Section 4
            pdfFormFields.SetField("s4_sitename", "Tampa Prodigy Center");

            //Section 5
            pdfFormFields.SetField("s5_initials", "SKB");
            //Section 6
            pdfFormFields.SetField("s6_initials", "SKB");

            // flatten the form to remove editting options, set it to false
            // to leave the form open to subsequent manual edits
            pdfStamper.FormFlattening = true;


            pdfStamper.Close();
            pdfReader.Close();

           
            HttpContext.Current.Response.ContentType = "application/pdf";
            HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=PODApplication.pdf");
            HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);

            HttpContext.Current.Response.BinaryWrite(ms.ToArray());
            HttpContext.Current.Response.End();

            
        }

    }
}