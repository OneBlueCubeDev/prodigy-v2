using System;
using System.Runtime.Serialization;

namespace POD.Logic
{
    [Serializable]
    public class SiteNotFoundException : Exception
    {
        public SiteNotFoundException()
        {
        }

        public SiteNotFoundException(string message) : base(message)
        {
        }

        public SiteNotFoundException(string message, Exception inner) : base(message, inner)
        {
        }

        protected SiteNotFoundException(
            SerializationInfo info,
            StreamingContext context) : base(info, context)
        {
        }
    }
}