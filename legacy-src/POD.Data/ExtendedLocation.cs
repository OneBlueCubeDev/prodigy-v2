using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using POD.Data.Entities;
using POD.Logging;

namespace POD.Data.Entities
{
    public partial class Location
    {
        public bool IsSite
        {
            get
            {
                bool isSite = false;
                try
                {
                    Site current = this as Site;
                    if (current != null)
                    {
                        isSite = true;
                    }

                }
                catch (Exception ex)
                {
                    ex.Log();
                }
                return isSite;

            }
        }
   }
}
