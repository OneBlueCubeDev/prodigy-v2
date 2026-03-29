<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/Admin.Master"
    AutoEventWireup="true" CodeBehind="ClassRegistration.aspx.cs" Inherits="POD.Pages.ManageClasses.ClassRegistration" %>

<%@ Register Src="../../UserControls/ClassesLinks.ascx" TagName="ClassesLinks" TagPrefix="uc2" %>
<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceholderHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
    <uc2:ClassesLinks ID="ClassesLinks1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="DashBoardContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="SidebarContentPlaceholder" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <telerik:RadAjaxManagerProxy ID="RadAjaxManager1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="ButtonAddPerson">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="DataListPeople" LoadingPanelID="RadAjaxLoadingPanel1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="DataListPeople">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="DataListPeople" LoadingPanelID="RadAjaxLoadingPanel1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server" HorizontalAlign="Center">
        <img alt="" src="../App_Themes/Prodigy/Common/loading.gif" style="border: none; margin-top: 150px;" />
    </telerik:RadAjaxLoadingPanel>
    <div class="tabcontainer">
        <div class="tabcontent">
            <auth:SecureContent ID="SecureContent3" ToggleVisible="false" ToggleEnabled="true"
                EventHook="Load" runat="server" Roles="Administrators;Administrators-NA;CentralTeamUsers;SiteTeamUsers;">
                <div class="CourseInfoWrapper ClassRegistrationWrapper">
                    <h2>
                        <asp:Literal ID="LiteralCourseHeader" runat="server"></asp:Literal></h2>
                    <asp:Panel ID="PanelCourseInfoHeader" runat="server">
                        <div class="InputWrapper row">
                            <label class="mylabel">
                                Description:</label>
                            <asp:Literal ID="LiteralDesc" runat="server"></asp:Literal>
                        </div>
                        <div class="InputWrapper row">
                            <label class="mylabel">
                                Dates:</label>
                            <asp:Literal ID="LiteralDates" runat="server"></asp:Literal>
                        </div>
                        <div class="InputWrapper row">
                            <label class="mylabel">
                                Instructor:</label>
                            <asp:Literal ID="LiteralInstructor" runat="server"></asp:Literal>
                        </div>
                        <div class="InputWrapper row">
                            <label class="mylabel">
                                Assistant:</label>
                            <asp:Literal ID="LiteralAssistant" runat="server"></asp:Literal>
                        </div>
                        <div class="InputWrapper row">
                            <label class="mylabel">
                                Site:</label>
                            <asp:Literal ID="LiteralLocation" runat="server"></asp:Literal>
                        </div>
                    </asp:Panel>
                </div>
                <asp:Panel ID="PanelQuickAdd" runat="server" CssClass="AttendanceQuickAdd">
                    <telerik:RadComboBox ID="RadComboBoxPerson" runat="server" EnableLoadOnDemand="true"
                        DataTextField="FullName" DataValueField="PersonID" AppendDataBoundItems="true"
                        EnableEmbeddedSkins="false" SkinID="Prodigy" CssClass="mydropdown myAttendancePerson">
                        <Items>
                            <telerik:RadComboBoxItem Text="Select Youth" Value="" />
                        </Items>
                    </telerik:RadComboBox>
                    <asp:RequiredFieldValidator ID="ReqValYouth" runat="server" SetFocusOnError="True"
                        InitialValue="" ValidationGroup="AddYouth" Display="Dynamic" ControlToValidate="RadComboBoxPerson"
                        CssClass="ErrorMessage" ErrorMessage="Youth Selection Required!" Text="* Required"></asp:RequiredFieldValidator>
                         <auth:SecureContent ID="SecureContent1" ToggleVisible="true" ToggleEnabled="false"
                EventHook="Load" runat="server" Roles="Administrators;Administrators-NA;CentralTeamUsers;SiteTeamUsers;">
                    <asp:Button ID="ButtonAddPerson" runat="server" Text="Add" ValidationGroup="AddYouth"
                        CssClass="mybutton addAttendeebutton" OnClick="ButtonAddPerson_Click" />
                        </auth:SecureContent>
                </asp:Panel>
            </auth:SecureContent>
            <p>
                Please note any missing information on the youth record is indicated with <strong><span
                    class="Red">red</span></strong>. Please go back to the youth record and updated
                the missing information.</p>
            <asp:DataList ID="DataListPeople" DataKeyField="PersonID" runat="server" OnItemCommand="DataListPeople_ItemCommand"
                CssClass="ClassRegistrationTable">
                <ItemTemplate>
                     <span>Name:</span><td class="Name">
                       
                        <%# Eval("FullName") %>&nbsp;&nbsp;
                    </td>
                    <td class="DOBLabel">
                        <span class='<%# Eval("DateOfBirth") == null ? "Red": "" %>'>Date of Birth:</span>
                    </td>
                    <td class="DOB">
                        <%# (Eval("DateOfBirth") != null && Eval("DateOfBirth") is DateTime) ? DateTime.Parse(Eval("DateOfBirth").ToString()).ToString("MM/dd/yyyy"): "N/A" %>
                    </td>
                    <td class="DJJNumLabel">
                        &nbsp;&nbsp;<span class='<%# Eval("DJJIDNum") == "" ? "Red": "" %>'>DJJ #:</span>
                    </td>
                    <td class="DJJNum">
                        <%# Eval("DJJIDNum") != "" ? Eval("DJJIDNum") : "N/A"%>
                    </td>
                    <td class="GenderLabel">
                        <span class='<%# Eval("Gender.Name") == "" ? "Red": "" %>'>Gender:</span>
                    </td>
                    <td class="Gender">
                        <%# Eval("Gender.Name") !=""? Eval("Gender.Name"): "N/A" %>
                    </td>
                    <auth:SecureContent ID="SecureContent3" ToggleVisible="True" ToggleEnabled="False"
                        EventHook="Load" runat="server" Roles="Administrators;Administrators-NA;CentralTeamUsers;SiteTeamUsers;">
                        <td class="RemoveButtonCell">
                            &nbsp;&nbsp;
                            <asp:LinkButton ID="LinkButtonRemove" runat="server" Text="Remove" CommandName="Remove"
                                CssClass="RemoveButton"><img src="../../App_Themes/Prodigy/Grid/Delete.png" alt="Remove" /></asp:LinkButton>
                    </auth:SecureContent>
                </ItemTemplate>
            </asp:DataList>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="EditButtonsPlaceholder" runat="server">
    <asp:Button runat="server" ID="ButtonCancel" Text="Return" CssClass="mybutton mycancel myReturnButton"
        CommandName="Cancel" CausesValidation="false" OnClick="ButtonCancel_Click"></asp:Button>
</asp:Content>
