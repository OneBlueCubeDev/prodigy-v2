<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="BulkDataLinks.ascx.cs"
    Inherits="POD.UserControls.BulkDataLinks" %>
    <%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
<ul>
    <li>
        <auth:securecontent id="SecureContent1" togglevisible="true" toggleenabled="false"
            eventhook="Load" runat="server" roles="Administrators;">
        <a runat="server" href="~/Pages/Admin/Import/ImportDJJNum.aspx" title="Import DJJ #" class="importDJJ"><span>Import DJJ #</span></a>
</auth:securecontent>
    </li>
</ul>
