<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master"
    AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="POD.Pages.Admin.Dashboard" %>
        <%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <div class="enrollmentpanel panel adminpanel">
        <div class="enrollmentpanelhead panelhead">
            <h2>
                Manage Staff Roles</h2>
        </div>
        <div class="panelcontent">
            <div class="panelicon">
                <img src="../../Templates/Images/enrollmentIcon.png" alt="Manage Users Icon" /></div>
            <p>
                Manage Staff Member Roles here</p>
            <asp:Button ID="GoEnrollment" runat="server" Text="GO >" CssClass="mybutton mygobutton"
                PostBackUrl="~/Pages/Admin/ManageStaff/RoleManagement.aspx" />
        </div>
    </div>
    <div class="eventspanel panel adminpanel">
        <div class="eventspanelhead panelhead">
            <h2>
                Manage Locations</h2>
        </div>
        <div class="panelcontent">
            <div class="panelicon">
                <img src="../../Templates/Images/locationsIcon.png" alt="Manage Locations Icon" /></div>
            <p>
                Manage Locations and Sites here</p>
            <asp:Button ID="GoLocations" runat="server" Text="GO >" CssClass="mybutton mygobutton"
                PostBackUrl="~/pages/Admin/ManageLocations/Locations.aspx" />
        </div>
    </div>
    <div class="attendancepanel sidepanel typespanel adminsidepanel">
        <div class="typespanelhead sidepanelhead">
            <h2>
                Manage Types</h2>
        </div>
        <div class="panelcontent">
            <div class="panelicon">
                <img src="../../Templates/Images/typesIcon.png" alt="Manage Types Icon" /></div>
            <p>
                Manage Types, Time Periods and Age Groups here. Types include:</p>
            <ul>
                <li><span>Address Type</span></li>
                <li><span>Class Type</span></li>
                <li><span>Course Type</span></li>
                <li><span>Personal Development Type</span></li>
                <li><span>Inventory Type</span></li>
                <li><span>Enrollment Type</span></li>
                <li><span>Event Type</span></li>
                <li><span>Lesson Plan Type</span></li>
                <li><span>Location Type</span></li>
                <li><span>Life Skill Type</span></li>
                <li><span>Person Relationship Type</span></li>
                <li><span>Person Type</span></li>
                <li><span>Phone Number Type</span></li>
                <li><span>Program Type</span></li>
                <li><span>Referral Type</span></li>
                <li><span>Referring Agency Type</span></li>
                <li><span>Status Type</span></li>
                <li><span>Time Period Type</span></li>
                <li><span>Note Contact Type</span></li>
            </ul>
            <auth:securecontent id="SecureContent1" togglevisible="true" toggleenabled="false"
                eventhook="Load" runat="server" roles="Administrators;">
            <asp:Button ID="GoCourses" runat="server" Text="GO >" CssClass="mybutton mygobutton"
                PostBackUrl="~/pages/Admin/ManageTypes/manageTypes.aspx" />
                </auth:securecontent>
        </div>
    </div>
    <div class="coursespanel panel adminpanel">
        <div class="coursespanelhead panelhead">
            <h2>
                Manage Communites</h2>
        </div>
        <div class="panelcontent">
            <div class="panelicon">
                <img src="../../Templates/Images/communitiesIcon.png" alt="Manage Communities Icon" /></div>
            <p>
                Manage Communites, Circuits and Counties here</p>
            <asp:Button ID="GoCommunities" runat="server" Text="GO >" CssClass="mybutton mygobutton"
                PostBackUrl="~/pages/Admin/ManageCommunities/Communities.aspx" />
        </div>
    </div>
    <div class="reportingpanel panel adminpanel">
        <div class="bulkeditpanelhead panelhead">
            <h2>
                Manage Bulk Data</h2>
        </div>
        <div class="panelcontent">
            <div class="panelicon">
                <img src="../../Templates/Images/bulkdataIcon.png" alt="Reporting Icon" /></div>
            <p>
                Manage Bulk Data here</p>
            <asp:Button ID="GoBulkEdit" runat="server" Text="GO >" CssClass="mybutton mygobutton"
                PostBackUrl="~/pages/Admin/BulkEdit/BulkEditingTool.aspx" />
        </div>
    </div>
<%--     <div class="reportingpanel panel adminpanel">
        <div class="bulkeditpanelhead panelhead">
            <h2>
                Manage Bulk Youth Release</h2>
        </div>
        <div class="panelcontent">
            <div class="panelicon">
                <img src="../../Templates/Images/bulkdataIcon.png" alt="Reporting Icon" /></div>
            <p>
                Manage the bulk release of youth for a particular grant year and site</p>
            <asp:Button ID="Button1" runat="server" Text="GO >" CssClass="mybutton mygobutton"
                PostBackUrl="~/pages/Admin/BulkEdit/BulkReleaseTool.aspx" />
        </div>
    </div>--%>
    <div class="reportingpanel panel adminpanel">
        <div class="bulkeditpanelhead panelhead">
            <h2>
                Auto Youth Discharge Tool</h2>
        </div>
        <div class="panelcontent">
            <div class="panelicon">
                <img src="../../Templates/Images/bulkdataIcon.png" alt="Reporting Icon" /></div>
            <p>
                Generate the youth discharge reports for auto released youth.</p>
            <asp:Button ID="Button2" runat="server" Text="GO >" CssClass="mybutton mygobutton"
                PostBackUrl="~/pages/Admin/ManageReleased/YouthDischargeTool.aspx" />
        </div>
    </div>
</asp:Content>
