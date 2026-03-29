using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;

namespace POD.Utillities
{
    public class CustomListView : System.Web.UI.WebControls.ListView
    {
        protected override void OnItemCommand(ListViewCommandEventArgs e)
        {
            base.OnItemCommand(e);
            SaveItems();
        }

        /// <summary>
        /// Save ListView Items.
        /// </summary>
        public void SaveItems()
        {
            // Update all items on Command (InsertItem is not included in Items collection)
            foreach (ListViewDataItem di in this.Items)
                this.UpdateItem(di.DataItemIndex, false);
        }

    }
}