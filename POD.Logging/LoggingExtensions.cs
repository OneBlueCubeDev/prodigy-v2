using System;
using Elmah;

namespace POD.Logging
{
    public static class LoggingExtensions
    {
        public static void Log(this Exception ex)
        {
            ErrorSignal.FromCurrentContext().Raise(ex);
        }
    }
}