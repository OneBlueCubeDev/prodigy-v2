using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Hosting;
using System.Web.Security;
using POD.Logging;

namespace POD.Logic
{
    public enum PasswordStrengthFeedback
    {
        Valid = 2,
        NotLongEnough = 4,
        NotEnoughUppercaseLetters = 8,
        NotEnoughNumbers = 16,
        SameAsLastPassword = 32,
        SameAsUserName = 64
    }

    public static class Security
    {
        public static bool UserAuthenticated()
        {
            bool result = false;

            if (HttpContext.Current.User != null)
            {
                if (HttpContext.Current.User.Identity.IsAuthenticated)
                {
                    result = true;
                }
            }

            return result;
        }

        public static MembershipCreateStatus CreateUser(String username, String password, String email)
        {
            MembershipCreateStatus status = MembershipCreateStatus.Success;

            //if ( !UserAuthenticated() )
            //    return false;
            try
            {
                MembershipUser thisUser = Membership.CreateUser(username, password, email);
            }
            catch (MembershipCreateUserException e)
            {
                e.Log();
                status = e.StatusCode;
            }

            return status;
        }

        public static bool AddRoleToUser(String username, String role)
        {
            Roles.AddUserToRole(username, role);
            return true;
        }

        public static bool UserNameExist(string username)
        {
            bool exist = false;

            exist = Membership.FindUsersByName(username).Count > 0;

            return exist;
        }
        public static bool EmailExist(string email)
        {
            bool exist = false;

            exist = Membership.FindUsersByEmail(email).Count > 0;

            return exist;
        }

        /// <summary>
        /// deletes all roles for user first
        /// then adds the new ons
        /// </summary>
        /// <param name="username"></param>
        /// <param name="roles"></param>
        /// <returns></returns>
        public static bool SetRoleForUser(String username, string[] roles)
        {
            try
            {
                // remove user from all roles and then re-Add Roles
                string[] userRoles = Roles.GetRolesForUser(username);
                if (userRoles != null && userRoles.Count() != 0)
                {
                    Roles.RemoveUserFromRoles(username, userRoles);
                }
                //precaution if user submits twice
                string[] userNewNameRoles = Roles.GetRolesForUser(username);
                if (userNewNameRoles != null && userNewNameRoles.Count() != 0)
                {
                    Roles.RemoveUserFromRoles(username, userNewNameRoles);
                }
                Roles.AddUserToRoles(username, roles);
                return true;
            }
            catch (Exception ex)
            {
                ex.Log();
                return false;
            }

        }

        public static bool SetRoleForUser(String username, String role)
        {
            if (Roles.GetRolesForUser(username).Count() > 0)//check if user is already in any roles
            {
                Roles.RemoveUserFromRoles(username, Roles.GetRolesForUser(username));
            }

            Roles.AddUserToRole(username, role);
            return true;
        }

        public static bool DisableUser(String username)
        {
            MembershipUser thisUser = Membership.GetUser(username);

            if (thisUser == null)
                return false;

            thisUser.IsApproved = false;
            Membership.UpdateUser(thisUser);

            return true;
        }

        public static bool EnableUser(String username)
        {
            MembershipUser thisUser = Membership.GetUser(username);

            if (thisUser == null)
                return false;

            thisUser.IsApproved = true;
            Membership.UpdateUser(thisUser);

            return true;
        }

        public static bool ResetUserPassword(String email)
        {
            String thisUserName = Membership.GetUserNameByEmail(email);

            if (String.IsNullOrEmpty(thisUserName))
            {
                return false;
            }

            MembershipUser thisUser = Membership.GetUser(thisUserName);

            thisUser.ResetPassword();

            return true;
        }

        public static List<String> GetRolesList()
        {
            return Roles.GetAllRoles().ToList();
        }

        public static void AddNewRole(string name)
        {
            if (!Roles.GetAllRoles().Any(r => r == name))
            {
                Roles.CreateRole(name);
            }
        }

        public static List<String> GetRolesForUser(string username)
        {
            return Roles.GetRolesForUser(username).ToList();
        }

        /// <summary>
        /// checks for assigned users first
        /// then attempts to delete
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        public static string DeleteRole(string name)
        {
            string result = string.Empty;
            try
            {
                int ct = Roles.GetUsersInRole(name).Count();
                if (ct == 0)
                {
                    Roles.DeleteRole(name);
                }
                else
                {
                    result = string.Format("You can't delete this role, there are {0} users assigned", ct);
                }


            }
            catch (Exception ex)
            {
                ex.Log();
                result = ex.Message;
            }
            return result;
        }

        public static bool AuthorizeRoles(string roleNames)
        {
            if (string.IsNullOrEmpty(roleNames) == false)
            {
                var roles = roleNames.Split(";,/\\".ToCharArray(), StringSplitOptions.RemoveEmptyEntries)
                    .Select(x => x.Trim());
                return roles.Any(UserInRole);
            }

            return true;
        }

        public static bool UserInRole(string roleName)
        {
            bool result = false;

            if (Roles.IsUserInRole(roleName))
            {
                result = true;
            }

            return result;
        }

        public static bool UserInRole(string roleName, string username)
        {
            bool result = false;

            if (Roles.IsUserInRole(username, roleName))
            {
                result = true;
            }

            return result;
        }

        public static MembershipUser GetCurrentUserProfile()
        {
            return Membership.GetUser(HttpContext.Current.User.Identity.Name);
        }

        public static Guid GetCurrentUserGuid()
        {
            var key = GetCurrentUserProfile().ProviderUserKey;
            if (key != null)
            {
                return new Guid(key.ToString());
            }
            return Guid.Empty;
        }

        public static MembershipUser GetUserByUserID(Guid userid)
        {
            return Membership.GetUser(userid);
        }

        public static MembershipUser GetUserByUserName(string username)
        {
            return Membership.GetUser(username);
        }

        /// <summary>
        /// upadates password
        /// if email is passed in will update emai
        /// </summary>
        /// <param name="userid"></param>
        /// <param name="oldpassword"></param>
        /// <param name="newpassword"></param>
        /// <param name="email"></param>
        public static void UpdatePasswordAndEmail(Guid userid, string oldpassword, string newpassword, string email)
        {
            //  Update the ASPNET membership password
            MembershipUser thisUser = Membership.GetUser(userid);
          
            thisUser.ChangePassword(oldpassword, newpassword);
              if(!string.IsNullOrEmpty(email))
            {
                thisUser.Email = email;
                Membership.UpdateUser(thisUser);
            }
        }
        /// <summary>
        /// abandons session
        /// and also signs user out of forms authentication
        /// </summary>
        public static void Logout()
        {
            HttpContext context = HttpContext.Current;
            //expire cookie

            FormsAuthentication.SignOut();
            context.Session.Abandon();

            context.Response.Redirect("~/default.aspx");
        }
    }
}
