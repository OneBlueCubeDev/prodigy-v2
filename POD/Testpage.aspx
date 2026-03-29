<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/Admin.Master" AutoEventWireup="true" CodeBehind="Testpage.aspx.cs" Inherits="POD.Testpage" %>
<%@ Register src="UserControls/SearchSideBar.ascx" tagname="SearchSideBar" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceholderHead" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
    <asp:Panel ID="PanelEnrollment" runat="server" >
        <ul>
            <li><a href="#" title="New Enrollment" class="newEnroll"><span>New Enrollment</span></a></li>
            <li><a href="#" title="Transfew Client" class="transferClient"><span>Transfer Client</span></a></li>
            <li><a href="#" title="View Client" class="viewClient"><span>View Client</span></a></li>
        </ul>
    </asp:Panel>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="SidebarContentPlaceholder" runat="server">
    <uc1:SearchSidebar ID="SearchSidebar1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <telerik:RadTabStrip ID="RadTabStrip1" runat="server" SelectedIndex="0">
        <Tabs>
            <telerik:RadTab runat="server" Selected="True" Text="Registration Info">
            </telerik:RadTab>
            <telerik:RadTab runat="server" Text="Transportation Release">
            </telerik:RadTab>
            <telerik:RadTab runat="server" Text="Contact Info">
            </telerik:RadTab>
            <telerik:RadTab runat="server" Text="Medical Release">
            </telerik:RadTab>
            <telerik:RadTab runat="server" Text="Prodigy Release">
            </telerik:RadTab>
            <telerik:RadTab runat="server" Text="Youth Grievance Process">
            </telerik:RadTab>
        </Tabs>
    </telerik:RadTabStrip>
    <div class="tabcontainer">
                	<div class="tabcontent">
                    	<div class="entryDetails">
                        	Created: 11/23/10<br />Last Edited: 2/1/12
                        </div>
                        <h3 class="sectionHead">Demographic Information:</h3>
                        <label name="Name" class="mylabel">Name</label>
                        <input type="text" name="Name" class="myfield" />
                        <span class="sectionDivider"></span>
                        <h3 class="sectionHead">Demographic Information:</h3>
                    </div><!--end tabcontent-->                	
                </div><!--end tabcontainer-->
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="EditButtonsPlaceholder" runat="server">
    <asp:Panel ID="PanelMainContentEditButtons" runat="server" >
        <div class="editButtons">
            <asp:Button ID="DeleteButton" runat="server" Text="Delete" class="mybutton mydelete" />
            <asp:Button ID="PrintButton" runat="server" Text="Print" class="mybutton myprint" /> 
            <asp:Button ID="SaveButton" runat="server" Text="Save" class="mybutton mysave" />               
        </div>
    </asp:Panel>
       
</asp:Content>

