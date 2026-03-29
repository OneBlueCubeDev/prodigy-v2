using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace POD.Data.Entities
{
    public partial class CourseInstance
    {
        public int ClassCount
        {
            get
            {
                return this.Classes != null ? this.Classes.Count : 0;
            }
        }
    }
}
