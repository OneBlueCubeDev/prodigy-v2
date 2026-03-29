using System.Linq;

namespace POD.Data.Entities
{
    public partial class Contract
    {
        public Site Site
        {
            get { return Sites.FirstOrDefault(); }
        }

        public Program Program
        {
            get { return Programs.FirstOrDefault(); }
        }

        public string SiteName
        {
            get
            {
                return Site != null
                           ? Site.SiteName
                           : string.Empty;
            }
        }

        public string ProgramName
        {
            get
            {
                return Program != null
                           ? Program.Name
                           : string.Empty;
            }
        }
    }
}