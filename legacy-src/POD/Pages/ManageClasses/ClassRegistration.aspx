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
            &nbsp; &nbsp;
                <%-- Print  --%>
            <br />
            <h3 class="sectionHead ClassSchedulesHeader">
                Class Schedules</h3>
            
            <asp:HiddenField ID="HiddenFieldCourseID" runat="server" />
            <%--classes--%>
                <telerik:RadGrid ID="RadGridCourseInstance" CssClass="CourseInstanceGrid CommandItemGrid" 
                runat="server" AutoGenerateColumns="false" OnItemDataBound="RadGridCourseInstance_ItemDatabound"
                AllowPaging="True" AllowSorting="true"
                DataSourceID="DataSourceCourseInstance" AllowAutomaticDeletes="false" AllowFilteringByColumn="false"
                GroupingSettings-CaseSensitive="false" PageSize="5" Width="100%" EnableEmbeddedSkins="false"
                Skin="Prodigy" HorizontalAlign="Center" OnItemCommand="RadGridCourseInstance_ItemCommand">
                <ClientSettings>
                    <ClientEvents OnCommand="RadGridCourseInstance_Command" />
                </ClientSettings>
                <MasterTableView TableLayout="Auto" EnableNoRecordsTemplate="true"
                    NoMasterRecordsText="No Schedules were found" ClientDataKeyNames="CourseInstanceID,CourseID"
                    DataKeyNames="CourseInstanceID, CourseID, LessonPlanSetID" NoDetailRecordsText="No Schedules were found"
                    HierarchyLoadMode="ServerOnDemand" ExpandCollapseColumn-ItemStyle-CssClass="DetailTableExpandedCell">
                  
                    <ItemStyle />
                    <AlternatingItemStyle />
                    <Columns>
                        
                        <telerik:GridBoundColumn DataField="StartDate" DataFormatString="{0:d}" UniqueName="colStartDate"
                            SortExpression="StartDate" FilterControlWidth="85%" AutoPostBackOnFilter="true"
                            ShowFilterIcon="false" HeaderText="Start Date" ItemStyle-Width="10%" HeaderStyle-Width="10%">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="EndDate" DataFormatString="{0:d}" FilterControlWidth="85%"
                            AutoPostBackOnFilter="true" ShowFilterIcon="false" SortExpression="EndDate" UniqueName="colEndDate"
                            HeaderText="End Date" ItemStyle-Width="10%" HeaderStyle-Width="10%">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Site.Name" UniqueName="colLocation" FilterControlWidth="85%"
                            AutoPostBackOnFilter="true" ShowFilterIcon="false" SortExpression="Site.Name"
                            HeaderText="Site">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Instructor.FullName" UniqueName="colInstructor"
                            FilterControlWidth="85%" AutoPostBackOnFilter="true" ShowFilterIcon="false" SortExpression="Instructor.FullName"
                            HeaderText="Instructor">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Assistant.FullName" UniqueName="colAssistant"
                            FilterControlWidth="85%" AutoPostBackOnFilter="true" ShowFilterIcon="false" SortExpression="Assistant.FullName"
                            HeaderText="Assistant">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Notes" FilterControlWidth="85%" AutoPostBackOnFilter="true"
                            ShowFilterIcon="false" SortExpression="Notes" HeaderText="Notes">
                        </telerik:GridBoundColumn>
                       
                    </Columns>
                    <DetailTables>
                        <telerik:GridTableView AllowSorting="true" AllowPaging="true" ShowHeader="true" PageSize="15" 
                            Name="RadGridClassess" ClientDataKeyNames="ClassID, CourseInstanceID" DataKeyNames="ClassID, CourseInstanceID"
                            DataSourceID="DataSourceClassess" Width="100.25%">
                          
                            <ParentTableRelation>
                                <telerik:GridRelationFields DetailKeyField="CourseInstanceID" MasterKeyField="CourseInstanceID" />
                            </ParentTableRelation>
                            <Columns>
                                
                                <telerik:GridBoundColumn DataField="Name" SortExpression="Name" FilterControlWidth="85%"
                                    AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderText="Name" ItemStyle-Width="16%"
                                    HeaderStyle-Width="16%">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="DateStart" SortExpression="DateStart" FilterControlWidth="85%"
                                    AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderText="Start Date" ItemStyle-Width="10%"
                                    HeaderStyle-Width="10%" DataFormatString="{0:MM/dd/yyyy}">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="DateStart" SortExpression="DateStart" FilterControlWidth="85%"
                                    AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderText="Start Time" ItemStyle-Width="10%"
                                    HeaderStyle-Width="10%" DataFormatString="{0:t}">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="DateEnd" FilterControlWidth="85%" AutoPostBackOnFilter="true"
                                    ShowFilterIcon="false" SortExpression="DateEnd" DataFormatString="{0:t}" HeaderText="End Time"
                                    ItemStyle-Width="10%" HeaderStyle-Width="10%">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Location.Name" FilterControlWidth="85%" AutoPostBackOnFilter="true"
                                    ShowFilterIcon="false" SortExpression="Location.Name" HeaderText="Location">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Site.Name" FilterControlWidth="85%" AutoPostBackOnFilter="true"
                                    ShowFilterIcon="false" SortExpression="Site.Name" HeaderText="Site">
                                </telerik:GridBoundColumn>
                              
                                <telerik:GridBoundColumn DataField="Instructor.FullName" FilterControlWidth="85%"
                                    AutoPostBackOnFilter="true" ShowFilterIcon="false" UniqueName="colInstructor"
                                    SortExpression="Instructor.FullName" HeaderText="Instructor">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Assistant.FullName" FilterControlWidth="85%"
                                    UniqueName="colAssistant" AutoPostBackOnFilter="true" ShowFilterIcon="false"
                                    SortExpression="Assistant.FullName" HeaderText="Assistant">
                                </telerik:GridBoundColumn>
                              
                                 <telerik:GridButtonColumn ButtonType="ImageButton" CommandArgument="print" CommandName="print"
                            ImageUrl="../../App_Themes/Prodigy/Grid/print.png" ShowFilterIcon="False" UniqueName="PrintColumn"
                            ButtonCssClass="IconButton PencilButton" ItemStyle-Width="5%" HeaderText="Sign Up Sheet" HeaderStyle-HorizontalAlign="Center"
                            ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="5%">
                        </telerik:GridButtonColumn>
                            </Columns>
                           
                        </telerik:GridTableView>
                    </DetailTables>
                 
                    <NoRecordsTemplate>
                        <p>
                            If you filtered please widen your search.
                        </p>
                    </NoRecordsTemplate>
                </MasterTableView>
            </telerik:RadGrid>
            <asp:EntityDataSource ID="DataSourceCourseInstance" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" 
        EnableFlattening="False" EntitySetName="CourseInstances" Include="Instructor, Assistant, Site, Course"
        OrderBy="it.[StartDate]" Where="it.[CourseID] == @CourseID && it.[ProgramID] == @ProgramID">
        <WhereParameters>
            <asp:SessionParameter Name="ProgramID" SessionField="ProgramID" Type="Int32" />
            <asp:ControlParameter ControlID="HiddenFieldCourseID" Name="CourseID" Type="Int32"
                PropertyName="Value" />
        </WhereParameters>
    </asp:EntityDataSource>
    <asp:EntityDataSource ID="DataSourceClassess" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" 
        EnableFlattening="False" EntitySetName="Classes" Include="Instructor, Assistant, StatusType, ClassType, Location, Site, CourseInstance"
        OrderBy="it.[DateStart]" Where="it.[CourseInstanceID] == @CourseInstanceID">
        <WhereParameters>
            <asp:SessionParameter Name="CourseInstanceID" SessionField="CourseInstanceID" Type="Int32" />
        </WhereParameters>
    </asp:EntityDataSource>

              <%--  <asp:Button runat="server" ID="ButtonPrint" Text="Sign-In Sheet" Width="190px" CssClass="mybutton mycancel"
                    CommandName="Print" CausesValidation="false" OnClick="ButtonPrint_Click"></asp:Button>--%>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="EditButtonsPlaceholder" runat="server">
    <asp:Button runat="server" ID="ButtonCancel" Text="Return" CssClass="mybutton mycancel myReturnButton"
        CommandName="Cancel" CausesValidation="false" OnClick="ButtonCancel_Click"></asp:Button>
    <telerik:RadScriptBlock runat="server">
       <script type="text/javascript"> 
           function RadGridCourseInstance_Command(sender, args) {
               var commandName = args.get_commandName();
               if (commandName == "print") {
                   
                   $find('<%= RadAjaxManager1.ClientID %>').set_enableAJAX(false);
               }
           }
       </script> 
    </telerik:RadScriptBlock>
</asp:Content>
