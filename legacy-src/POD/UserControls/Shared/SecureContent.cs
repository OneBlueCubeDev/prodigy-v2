using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using POD.Logic;
using POD.Utillities;

namespace POD.UserControls.Shared
{
    public class SecureContent : PlaceHolder
    {
        public SecureContent()
        {
            Init += InitEventHandler;
        }

        void InitEventHandler(object sender, EventArgs e)
        {
            switch (EventHook)
            {
                case LifeCycleEvent.Init:
                    {
                        AuthorizeEventHandler(sender, e);
                        break;
                    }
                case LifeCycleEvent.PreRender:
                    {
                        PreRender += AuthorizeEventHandler;
                        break;
                    }
                case LifeCycleEvent.Load:
                    {
                        Load += AuthorizeEventHandler;
                        break;
                    }
                default:
                    {
                        goto case LifeCycleEvent.Load;
                    }
            }
        }

        public string Roles { get; set; }

        public bool ToggleVisible { get; set; }

        public bool ToggleEnabled { get; set; }

        public LifeCycleEvent EventHook { get; set; }

        private void AuthorizeEventHandler(object sender, EventArgs e)
        {
            var args = new AuthorizeEventArgs
                           {
                               Roles = Roles
                           };

            if (Authorize != null)
            {
                Authorize(sender, args);
            }

            if (args.Authorized != null || string.IsNullOrEmpty(Roles) == false)
            {
                bool isAuthorized = args.Authorized ?? Security.AuthorizeRoles(Roles);

                if (isAuthorized)
                {
                    if (AuthorizationPassed != null)
                        AuthorizationPassed(sender, e);
                }
                else
                {
                    if (AuthorizationFailed != null)
                        AuthorizationFailed(sender, e);
                }

                if (!isAuthorized && ToggleVisible)
                {
                    Visible = isAuthorized;
                }
                if (!isAuthorized && ToggleEnabled)
                {
                    IEnumerable<WebControl> controls = this.FindControls<WebControl>();
                    foreach (WebControl control in controls)
                    {
                        control.Enabled = isAuthorized;
                    }
                }
            }
        }

        public event EventHandler<AuthorizeEventArgs> Authorize;

        public event EventHandler AuthorizationPassed;

        public event EventHandler AuthorizationFailed;
    }

    public enum LifeCycleEvent
    {
        Init,
        Load,
        PreRender
    }

    public class AuthorizeEventArgs : EventArgs
    {
        public bool? Authorized { get; set; }

        public string Roles { get; set; }
    }
}