<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ClassesLinks.ascx.cs"
    Inherits="POD.UserControls.ClassesLinks" %>
<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
<asp:Panel ID="PanelClasses" runat="server">
    <ul>
        <li id="LiSearchClass" runat="server"><a runat="server" href="~/Pages/ManageClasses/Classes.aspx"
            title="Search Classes" class="searchClasses"><span>Search Classes</span></a></li>
        <%--<li id="liNewClass" runat="server">
            <auth:SecureContent ID="SecureContent3" ToggleVisible="True" ToggleEnabled="False" EventHook="Load" runat="server" Roles="Administrators;Administrators-NA;CentralTeamUsers;SiteTeamUsers;">
                <a runat="server" href="~/Pages/ManageClasses/ClassDetailpage.aspx"
                    title="New Class and Schedule" class="newClass"><span>New Class and Schedule</span></a>
            </auth:SecureContent>
        </li>--%>
        <li id="Li2" runat="server"/>
        <li id="Li1" runat="server"/>
       <%-- <li id="LiClassCatalogs" runat="server"><a runat="server" href="~/Pages/ManageClasses/ClassCatalogs.aspx"
            title="View Class Catalogs" class="viewClassCatalogs"><span>View Class Catalogs</span></a></li>--%>
        <li id="LiNewLessonPlan" runat="server">
     <auth:SecureContent ID="SecureContent2" ToggleVisible="True" ToggleEnabled="False" EventHook="Load" runat="server" Roles="Administrators;Administrators-NA;CentralTeamUsers;SiteTeamUsers;SiteTeamUsers-NA">
            <a runat="server" href="~/Pages/LessonPlans/LessonPlanDetailpage.aspx?tp=ls"
            title="New Lesson Plan Set" class="newLessonPlanSet"><span>New Lesson Plan Set</span></a></auth:SecureContent>
        </li>
        <li id="LiActiveLessonPlan" runat="server"><a runat="server" href="~/Pages/LessonPlans/LessonPlans.aspx?tp=1"
            title="Active Lesson Plan Sets" class="inprogressLPSets"><span>Active Lesson Plan Set</span></a></li>
        <li id="LiCompletedLessonPlan" runat="server"><a runat="server" href="~/Pages/LessonPlans/LessonPlans.aspx?tp=2"
            title="Completed Lesson Plan Set" class="completeLPSets"><span>Completed Lesson Plan
                Sets</span></a></li>
        
              
        <li id="LiReviewLessonPlan" runat="server">
              <auth:SecureContent ID="SecureContent1" ToggleVisible="True" ToggleEnabled="False" EventHook="Load" runat="server" Roles="Administrators;">
            <a runat="server" href="~/Pages/Admin/ReviewLessonPlans.aspx"
            title="Review Lesson Plan Sets" class="reviewLessonPlanSets"><span>Review Lesson Plan
                Sets</span></a> </auth:SecureContent>
        </li>
    </ul>
</asp:Panel>
