<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Templates/Markup/AdminWide.Master"
    CodeBehind="ImportDJJNum.aspx.cs" Inherits="POD.Pages.Admin.Import.ImportDJJNum" %>
    <%@ Register Src="../../../UserControls/BulkDataLinks.ascx" TagName="BulkDataLinks"
    TagPrefix="uc2" %>

<%@ Register Assembly="POD" Namespace="POD.Utillities" TagPrefix="custom" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        window.onload = function uploadFileChange() {
            var fakeFileUpload = document.createElement('div');
            fakeFileUpload.className = 'myFakeFile';

            var fakeinput = document.createElement('input');
            fakeinput.setAttribute('type', 'text');
            fakeinput.className = 'myfield myBrowsefield';
            fakeFileUpload.appendChild(fakeinput);

            var image = document.createElement('input');
            image.setAttribute('type', 'button');
            image.setAttribute('value', 'Browse');
            image.className = 'mybutton myaddbutton';
            fakeFileUpload.appendChild(image);
            var x = document.getElementsByTagName('input');
            for (var i = 0; i < x.length; i++) {
                if (x[i].type != 'file') continue;
                if (x[i].parentNode.className != 'myFileBrowseContainer') continue;
                x[i].className = 'myFileBrowse';
                var clone = fakeFileUpload.cloneNode(true);
                x[i].parentNode.appendChild(clone);
                x[i].relatedElement = clone.getElementsByTagName('input')[0];
                x[i].onchange = x[i].onmouseout = function () {
                    this.relatedElement.value = this.value;
                }
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
    <uc2:BulkDataLinks ID="BulkDataLinks1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
<div class="tabcontainer widetabcontainer">
    <div class="tabcontent">
        <asp:panel ID="PanelImport" runat="server" cssclass="BulkEditWrapper ImportWrapper">
            <asp:Panel ID="PanelUpload" runat="server">
                <h2>
                    Import DJJ Numbers for Youth</h2>
                <p>Remember to save the spreadsheet as a <i>.csv</i> file before uploading.</p>
                <p>Examples are available for the following: &nbsp;&nbsp;&nbsp;&nbsp;<a href="~/Templates/ImportTemplates/Diversion_File.csv" title="DiversionExample.csv" target="_blank">DiversionExample.csv</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="~/Templates/ImportTemplates/Prevention_File.csv" title="PreventionExample.csv" target="_blank">PreventionExample.csv</a> </p><br />
                <telerik:RadFormDecorator ID="RadFormDecorator9" runat="server" />
                <asp:RadioButtonList ID="RadioButtonListType" runat="server" RepeatLayout="Table" RepeatColumns="2" CssClass="ImportOptions">
                    <asp:ListItem Text="Diversion" Value="Diversion"></asp:ListItem>
                    <asp:ListItem Text="Other" Value="Other"></asp:ListItem>
                </asp:RadioButtonList>
                <asp:RequiredFieldValidator ID="ReqValType" runat="server" ControlToValidate="RadioButtonListType"
                    ErrorMessage="You must specify the type of spreadsheet you are importing" ValidationGroup="Import" Display="Dynamic"
                    InitialValue="">
                </asp:RequiredFieldValidator>
                <div class="myFileBrowseContainer">
                    <asp:FileUpload ID="FileUpload" runat="server" CssClass="myFileBrowse" />
                </div>
                <br />
                <asp:Button ID="ButtonImport" CssClass="mybutton" runat="server" Text="Import Youth"
                    OnClick="ButtonImport_Click" ValidationGroup="Import" />
                <asp:Literal ID="LiteralErrorMessage" runat="server"></asp:Literal>
            </asp:Panel>
            <asp:Panel ID="PanelReview" runat="server" Visible="false">
                <h2>
                    Review and Confirm Matches</h2>
                <p>
                    Please review found matches and mark the youth that you don't want to update at
                    this point because there is a potential mismatch.</p>
            </asp:Panel>
            <asp:Panel ID="PanelResults" runat="server" Visible="false">
                <h2>
                    Import Results</h2>
                <asp:Literal ID="LiteralResults" runat="server"></asp:Literal>
                <asp:Repeater ID="RepeaterResults" runat="server" OnItemDataBound="RepeaterResults_ItemDataBound">
                    <ItemTemplate>
                        <div class="ImportedInfo">
                            <asp:Literal ID="LiteralYouthInfo" runat="server"></asp:Literal>
                        </div>
                        <div class="ResultInfo">
                            <span style="font-weight: bold; color: Red;">
                                <asp:Literal ID="LiteralMessage" runat="server"></asp:Literal>
                            </span>
                            <asp:Literal ID="LiteralPossibleMatches" runat="server"></asp:Literal>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Button ID="ButtonBackToImport" runat="server" OnClick="ButtonBackToImport_Click"
                    Text="Back" CssClass="mybutton mybackbutton" />
            </asp:Panel>
        </asp:panel>
        <asp:Panel runat="server" ID="PanelNoAccess" Visible="False">
            <p>We are sorry but you do not have the permission required to access the Import feature. Please contact UACDC.</p>

        </asp:Panel>
    </div>
</div>
</asp:Content>
