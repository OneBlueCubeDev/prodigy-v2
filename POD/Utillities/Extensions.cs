using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;

namespace POD.Utillities
{
    public static class Extensions
    {
        public static IEnumerable<T> FindControls<T>(this Control parent)
            where T : Control
        {
            foreach (Control child in parent.Controls)
            {
                if (child is T)
                {
                    yield return (T)child;
                }
                else if (child.Controls.Count > 0)
                {
                    foreach (T grandChild in child.FindControls<T>())
                    {
                        yield return grandChild;
                    }
                }
            }
        }
    }
}