using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Net.Mail;
using System.Net.Mime;
using SendGrid;
using SendGrid.Helpers.Mail;
using System.Net;

namespace POD.Pages
{
    public partial class TechnicalSupport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void ButtonRequest_Click(object sender, EventArgs e)
        {

            //sending an email 
            try
            {
                if (Page.IsValid)
                {

                    //var apiKey = "REPLACE_WITH_SENDGRID_API_KEY";
                    //var client = new SendGridClient(apiKey);
                    //var from = new EmailAddress("sburke6@gmail.com", "Example User");
                    //var subject = "Sending with SendGrid is Fun";
                    //var to = new EmailAddress("sparkdevlabs@outlook.com", "Example User");
                    //var plainTextContent = "and easy to do anywhere, even with C#";
                    //var htmlContent = "<strong>and easy to do anywhere, even with C#</strong>";
                    //var msg = MailHelper.CreateSingleEmail(from, to, subject, plainTextContent, htmlContent);
                    //var response =  client.SendEmailAsync(msg);


                    MailMessage mailMsg = new MailMessage();

                    // To
                    //mailMsg.To.Add(new MailAddress("afernandez@uacdc.org", "Prodigy Support Staff"));
                    mailMsg.To.Add(new MailAddress("sburke6@gmail.com", "Prodigy Support Staff"));
                    //mailMsg.To.Add(new MailAddress("nsoto@uacdc.org", "Prodigy Support Staff"));



                    // From
                    mailMsg.From = new MailAddress("sburke6@gmail.com", "Prodigy Technical Support ");

                    string result = string.Empty;


                    StringBuilder sb = new StringBuilder();

                    sb.AppendLine(" From POD User : " +  HttpContext.Current.User.Identity.Name);
                    sb.AppendLine("");
                    sb.AppendLine(this.TextBoxSupportComment.Text);
                    // Subject and multipart/alternative Body
                    mailMsg.Subject = "Programs Online Database Technical Support Request - " + this.DropDownListCategory.SelectedItem.Text ;
                    string text = sb.ToString();
                    string html = @"<p>" + sb.ToString()  + "</p>";
                    mailMsg.AlternateViews.Add(AlternateView.CreateAlternateViewFromString(text, null, MediaTypeNames.Text.Plain));
                    mailMsg.AlternateViews.Add(AlternateView.CreateAlternateViewFromString(html, null, MediaTypeNames.Text.Html));

                    // Init SmtpClient and send

                    var smtp = new SmtpClient
                    {
                        Host = "in-v3.mailjet.com",
                        Port = 587,
                        EnableSsl = true,
                        DeliveryMethod = SmtpDeliveryMethod.Network,
                        UseDefaultCredentials = false,
                        Credentials = new System.Net.NetworkCredential("REPLACE_WITH_MAILJET_API_KEY", "REPLACE_WITH_MAILJET_SECRET_KEY")
                    };
                

                 smtp.Send(mailMsg);
                    this.LiteralMessage.Text = "Thank-you for sending your technical support request. Someone will be reaching out to you shortly.";
                }
                
                
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }

        protected void ButtonCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Pages/ControlPanel.aspx");
        }
    }
}