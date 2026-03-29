<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master"
    AutoEventWireup="true" CodeBehind="YouthDischargeTool.aspx.cs" Inherits="POD.Pages.Admin.ManageReleased.YouthDischargeTool" %>


<%@ Register Assembly="POD" Namespace="POD.Utillities" TagPrefix="custom" %>
<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <%-- START RAD GRID EXPERIMENT --%>


    <%-- START RAD GRID EXPERIMENT --%>
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server" EnableAJAX="true">
        <AjaxSettings>
           
            <telerik:AjaxSetting AjaxControlID="ListViewData">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="ListViewData" LoadingPanelID="RadAjaxLoadingPanel1" />
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanel1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server" HorizontalAlign="Center">
        <img src="../../../App_Themes/Prodigy/Common/loading.gif" alt="Loading" style="border: none; margin-top: 0px;" />
    </telerik:RadAjaxLoadingPanel>
   
    <div class="tabcontainer widetabcontainer">
        <div class="tabcontent">
            <div class="BulkEditWrapper">
                <h2>Automatic Youth Discharge Tool</h2>

                <div class="TopEditToolbar row">
                    <div class="ReleaseInfoWrapper">
                        <label class="mylabel myeditdatepickerlabel">
                            <b>Step 1</b>: Select the release date to narrow your youth search.</label>
                    
                    

                        
                       
                            <asp:Label ID="LabelDropDownSites" AssociatedControlID="DropDownSites" runat="server">Site</asp:Label>
                            <auth:SecureContent ID="secureFilterSite" ToggleVisible="False" ToggleEnabled="True" EventHook="Load" runat="server" Roles="Administrators,Administrators-NA,CentralTeamUsers,CentralTeamUsers-NA"
                                OnAuthorizationFailed="secureFilterSite_OnAuthorizationFailed" OnAuthorizationPassed="secureFilterSite_OnAuthorizationPassed">
                                <telerik:RadComboBox ID="DropDownSites" runat="server" AppendDataBoundItems="True"
                                    EnableEmbeddedSkins="false" SkinID="Prodigy" DataTextField="SiteName" DataValueField="LocationID"
                                    CssClass="mydropdown">
                                    <Items>
                                        <telerik:RadComboBoxItem Text="All Sites" Value="" />
                                    </Items>
                                </telerik:RadComboBox>
                            </auth:SecureContent>





                            <%--<asp:Label ID="LabelReleaseDate" Font-Bold="true" runat="server" Text="Release Date:" CssClass="mylabel" Height="20px"></asp:Label>--%>
                            
<%--                            <telerik:RadDatePicker ID="RadDatePickerReleaseDate" runat="server" DateInput-Width="50px"
                                DateInput-DisplayDateFormat="MM/dd/yy" Calendar-ShowRowHeaders="False"
                                Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup myenrollmentdob">
                            </telerik:RadDatePicker>
                            --%>


                        
                        <asp:Label ID="LabelTargetDate" AssociatedControlID="RadDatePickerReleaseDate" runat="server">Month</asp:Label>
                        <telerik:RadMonthYearPicker ID="RadDatePickerReleaseDate" runat="server" 
                            Calendar-ShowRowHeaders="False" Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup myenrollmentdob"
                            AutoPostBack="True" OnLoad="RadDatePickerReleaseDate_OnLoad">
                        </telerik:RadMonthYearPicker>
                            <asp:RequiredFieldValidator ID="reqValEnrollmentDate" runat="server" SetFocusOnError="true"
                                Display="Dynamic" ControlToValidate="RadDatePickerReleaseDate" ValidationGroup="SaveRelease"
                                CssClass="ErrorMessage" ErrorMessage="Release Date is required" Text="*"></asp:RequiredFieldValidator>
               
                        
                    </div>


                </div>
                <div>
                    <auth:SecureContent ID="SecureContent3" ToggleVisible="true" ToggleEnabled="false"
                        EventHook="Load" runat="server" Roles="Administrators;">
                        <asp:Button ID="Button1" CausesValidation="True" ValidationGroup="SaveRelease" AutoPostBack="True" runat="server" Text="Find Youth" OnClick="Find_Click"
                            CssClass="mybutton" />
                    </auth:SecureContent>
                </div>
                <br />
                <%-- START RAD GRID EXPERIMENT --%>
                <div>
                    <label class="mylabel ">
                        <b>Step 2</b>: Discharged Youth by Release Date.</label>
                </div>
                <telerik:RadGrid RenderMode="Auto" ID="RadGrid1" OnItemCreated="RadGrid1_ItemCreated" OnItemDataBound="RadGrid1_ItemDataBound" AutoGenerateColumns="true" AllowMultiRowSelection="true" Width="100%"
                    runat="server" AllowSorting="false">
                    <MasterTableView TableLayout="Auto" DataKeyNames="PersonID,EnrollmentID,releasedate,firstname, lastname, djjidnum, siteLocationid, iscomplete, Sitename">
                        <Columns>

                            <%--<telerik:GridClientSelectColumn HeaderStyle-Width="45px" ItemStyle-HorizontalAlign="Center" UniqueName="ClientSelectColumn"></telerik:GridClientSelectColumn>--%>


                        </Columns>
                        <NoRecordsTemplate>
                        <p>
                            No records found for your search.
                        </p>
                    </NoRecordsTemplate>
                    </MasterTableView>
                    
                    
                    <ClientSettings EnableRowHoverStyle="true">
                        <Selecting AllowRowSelect="True"></Selecting>
                        
                    </ClientSettings>
                </telerik:RadGrid>

                <%-- CLOSE RAD GRID EXPERIMENT --%>


                <div class="clear">
                </div>

                <br />
                <auth:SecureContent ID="SecureContent1" ToggleVisible="true" ToggleEnabled="false"
                    EventHook="Load" runat="server" Roles="Administrators;">
                    <asp:Button ID="ButtonUpdate2" runat="server" Text="Generate Discharge Forms" OnClick="Update_Click"
                        CssClass="mybutton" Width="290px" />
                </auth:SecureContent>
            </div>
        </div>

    </div>
   
   
    <asp:EntityDataSource ID="DataSourceSites" runat="server" ConnectionString="name=PODContext"
        EntityTypeFilter="Site" DefaultContainerName="PODContext" EnableFlattening="False"
        EntitySetName="Locations">
    </asp:EntityDataSource>
    <asp:EntityDataSource ID="DataSourceLocations" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext"
        EnableFlattening="False" EntitySetName="Locations" OrderBy="it.[Name]">
    </asp:EntityDataSource>
    <asp:EntityDataSource ID="DataSourcePerson" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" EnableFlattening="False" EntitySetName="Persons"
        EnableUpdate="True" OrderBy="it.[LastName]" EntityTypeFilter="Student">
    </asp:EntityDataSource>

</asp:Content>
