using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using POD.Logging;
using POD.Logic;
using System.Web.Profile;
using System.Configuration;
using System.IO;
using POD.Data.Entities;

namespace POD
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ChangePasswordForForgot_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                return;
            }

            //Update the ASPNET membership password
            string username = this.UserName.Text.Trim();
            try
            {
                MembershipUserCollection collection = Membership.FindUsersByName(username);
                string oldPassword = collection[username].GetPassword();
                if (!string.IsNullOrEmpty(this.TextBoxEmailForPassword.Text))//must enter email and zip code
                {
                    if (!string.IsNullOrEmpty(collection[username].Email))//if we have email on file
                    {
                        if (collection[username].Email.ToLower() == this.TextBoxEmailForPassword.Text.ToLower()) //compare email
                        {
                            string newPassword = ConfirmNewPassword.Text;

                            Security.UpdatePasswordAndEmail(new Guid(collection[username].ProviderUserKey.ToString()), oldPassword, newPassword, string.Empty);

                            Response.Redirect("default.aspx?action=passwordreset");

                        }
                        else { this.FailureText.Text = "Your email and username do not match, please contact the system administrator"; }
                    }
                    else
                    {
                        this.FailureText.Text = "An error occurred. You can not update your password at this time, please contact the system administrator";
                    }
                }
                else
                {
                    this.FailureText.Text = "Your must enter your zip code and email address";
                }
            }
            catch (Exception ex)
            {
                ex.Log();
                this.FailureText.Text = "An error occurred. You can not update your password at this time, please contact the system administrator";
            }
        }

        /// <summary>
        /// retrieves username by email or zip
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ButtonRetrieveUserName_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                return;
            }

            string email = TextBoxEmailForUserName.Text;
            string zip = TextBoxZipCode.Text;

            string username = Membership.GetUserNameByEmail(email);

            //Bail if we don't find it by the mail address
            if (username == null || username.Length == 0)
            {
                this.LiteralFailureUserNameRetrieval.Text = "No record for that e-mail and zip code was found.";
                return;
            }
            //Otherwise, success
            MembershipUserCollection thisUserCol = Membership.FindUsersByName(username);
            MembershipUser thisUser = thisUserCol[username];
            StaffMember currentStaff = POD.Logic.PeopleLogic.GetStaffByUserID((Guid)thisUserCol[username].ProviderUserKey);

            //only bail if we have addresses to compare to
            if (currentStaff.Addresses != null && currentStaff.Addresses.Count > 0)
            {
                //Bail if we fail on the zip code
                if (!currentStaff.Addresses.Any(Adapter => Adapter.Zip == zip))
                {
                    this.LiteralFailureUserNameRetrieval.Text = "No record for that e-mail and zip code was found.";
                    return;
                }
            }

            SendMailWithUserName(thisUser);

            this.ForgotPasswordInstructionsPanel.Visible = false;
            MultiViewMain.SetActiveView(ViewUserNameSuccessNotification);
        }

        /// <summary>
        /// shows that email was send
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void LinkButtonRetrieveUserName_Click(object sender, EventArgs e)
        {
            //show the user name retrieval panel
            MultiViewMain.SetActiveView(UserNameRecoveryView);
        }

        private void SendMailWithUserName(MembershipUser user)
        {
            //Compose the mail
            string username = user.UserName;

            // Create email     
            string emailTo = user.Email;
            string emailFrom = ConfigurationManager.AppSettings["WebmasterEmail"];
            string subject = "Prodigy Application - Forgot Username Request";
            string templateName = "UserNameReset.htm";
            string mailBody = string.Empty;
            string filePath = ConfigurationManager.AppSettings["SiteDirectory"] + "Templates\\Emails\\";

            if (System.IO.File.Exists(filePath + templateName))
            {
                FileStream f1 = new FileStream(filePath + templateName, FileMode.Open);
                StreamReader sr = new StreamReader(f1);
                mailBody = sr.ReadToEnd();
                mailBody = mailBody.Replace("{username}", username);

                f1.Close();
            }

            POD.Logic.Utilities.SendMail(emailTo, emailFrom, subject, emailFrom, mailBody, null, filePath);
        }

    }
}