using System;
using System.Net;
using System.Security.Principal;
using Microsoft.Reporting.WebForms;

namespace POD.Logic.Reporting
{
    [Serializable]
    public class ReportServerCredentials : IReportServerCredentials
    {
        private readonly string _userName;
        private readonly string _password;

        public ReportServerCredentials(string userName, string password)
        {
            _userName = userName;
            _password = password;
        }

        #region IReportServerCredentials Members

        public bool GetFormsCredentials(out Cookie authCookie, out string userName, out string password,
                                        out string authority)
        {
            authCookie = null;
            userName = null;
            password = null;
            authority = null;
            return false;
        }

        public WindowsIdentity ImpersonationUser
        {
            get { return null; }
        }

        public ICredentials NetworkCredentials
        {
            get { return new NetworkCredential(_userName, _password); }
        }

        #endregion
    }
}