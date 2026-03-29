<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master"
    AutoEventWireup="true" CodeBehind="LocationPage.aspx.cs" Inherits="POD.Pages.Admin.ManageLocations.LocationPage" %>

<%@ Register Src="~/UserControls/AddEditAddress.ascx" TagName="AddEditAddress" TagPrefix="uc1" %>
<%@ Register Src="~/UserControls/AddEditPhoneNumber.ascx" TagName="AddEditPhoneNumber"
    TagPrefix="uc2" %>
<%@ Register Src="~/UserControls/SiteLocationLinks.ascx" TagName="SiteLocationLinks"
    TagPrefix="uc2" %>
<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
    <uc2:SiteLocationLinks ID="SiteLocationLinks1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <telerik:RadCodeBlock runat="server" ID="RadCodeBlock1">
        <script type="text/javascript">

            function CheckForCheckBox(obj, args) {
                var sr = $(".SpecialClass");
                var ddl = $find('<%=RadComboBoxSite.ClientID%>').get_value();
                if (sr.checked ==false && ddl == '') {
                    args.IsValid = false;
                }
                else {
                    args.IsValid = true;
                }
            }
            


        </script>
    </telerik:RadCodeBlock>
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server" EnableAJAX="true">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="ButtonAddPhone">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridPhoneNumbers" LoadingPanelID="RadAjaxLoadingPanel1" />
                    <telerik:AjaxUpdatedControl ControlID="Phone" />
                    <telerik:AjaxUpdatedControl ControlID="AddEditAddress1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="ButtonSaveLocation">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridPhoneNumbers" LoadingPanelID="RadAjaxLoadingPanel1" />
                    <telerik:AjaxUpdatedControl ControlID="Phone" />
                    <telerik:AjaxUpdatedControl ControlID="AddEditAddress1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>
    <div class="tabcontainer widetabcontainer">
        <auth:SecureContent ID="SecureContent1" ToggleVisible="false" ToggleEnabled="true"
            EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;">
            <div class="tabcontent">
                <h2 class="AdminHeader">
                    Location Info</h2>
                <div class="UserEntryFormWrapper AdminLocationForm">
                    <div class="InputWrapper row">
                        <div class="FormLabel mylabel NameLabel">
                            Name</div>
                        <asp:TextBox ID="TextBoxName" runat="server" Width="350px" class="myfield"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="TextBoxName"
                            InitialValue="" ErrorMessage="&nbsp;* Required" Display="Dynamic" ValidationGroup="Save"></asp:RequiredFieldValidator>
                    </div>
                    <div class="InputWrapper row">
                        <div class="FormLabel mylabel TypeLabel">
                            Type</div>
                        <telerik:RadComboBox DataTextField="Name" DataValueField="LocationTypeID" DataSourceID="DataSourceLocationTypes"
                            ID="RadComboLocType" runat="server" EnableEmbeddedSkins="false" SkinID="Prodigy"
                            CssClass="mydropdown">
                        </telerik:RadComboBox>
                    </div>
                    <div class="InputWrapper row">
                        <div class="FormLabel mylabel StatusLabel">
                            Status</div>
                        <telerik:RadComboBox DataTextField="Name" DataValueField="StatusTypeID" DataSourceID="DataSourceStatusTypes"
                            ID="RadComboStatusType" runat="server" EnableEmbeddedSkins="false" SkinID="Prodigy"
                            CssClass="mydropdown">
                        </telerik:RadComboBox>
                    </div>
                    <div class="InputWrapper row">
                        <div class="FormLabel mylabel SiteLabel">
                            Is Site</div>
                        <asp:CheckBox ID="checkBoxSite" CssClass="checkBox SpecialClass" runat="server" />
                    </div>
                    <asp:Panel ID="PanelSiteInfo" runat="server" class="InputWrapper row site">
                        <div class="FormLabel mylabel NameLabel">
                            Site Name</div>
                        <asp:TextBox ID="TextBoxsiteName" runat="server" Width="350px" class="myfield"></asp:TextBox>
                    </asp:Panel>
                    <asp:Panel ID="PanelSiteInfo2" runat="server" class="InputWrapper row site">
                        <div class="FormLabel mylabel NameLabel">
                            Organization Name</div>
                        <asp:TextBox ID="TextBoxOrgName" runat="server" Width="350px" class="myfield"></asp:TextBox>
                    </asp:Panel>
                    <asp:Panel ID="PanelSiteInfo3" runat="server" class="InputWrapper row site">
                        <auth:SecureContent ID="SecureContent3" ToggleVisible="false" ToggleEnabled="true"
                            EventHook="Load" runat="server" Roles="Administrators;">
                            <div class="FormLabel mylabel NameLabel myeditdatepickerlabel">
                                Attendance<br />
                                Locked Date</div>
                            <telerik:RadDatePicker ID="LockDatePicker" runat="server" MinDate="1/1/1900" DateInput-Width="50px"
                                Width="150px" DateInput-DisplayDateFormat="MM/dd/yy" Calendar-ShowRowHeaders="False"
                                Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup myenrollmentdob">
                            </telerik:RadDatePicker>
                            <br />
                        </auth:SecureContent>
                    </asp:Panel>
                    <div class="InputWrapper row">
                        <div class="FormLabel mylabel SiteLabel">
                            Parent Site</div>
                        <telerik:RadComboBox ID="RadComboBoxSite" DataSourceID="DataSourceSites" DataValueField="LocationID"
                            DataTextField="Name" EmptyMessage="Select Site" runat="server" EnableEmbeddedSkins="false"
                            SkinID="Prodigy" CssClass="mydropdown" AppendDataBoundItems="true">
                            <Items>
                                <telerik:RadComboBoxItem Text="Select Site" Value="" />
                            </Items>
                        </telerik:RadComboBox>
                        <asp:CustomValidator ID="CustomValParentSite" ErrorMessage="&nbsp;* Required" Display="Dynamic"
                            ValidationGroup="Save" runat="server" ClientValidationFunction="CheckForCheckBox"></asp:CustomValidator>
                    </div>
                    <uc1:AddEditAddress ID="AddEditAddress1" runat="server" />
                    <div class="InputWrapper row">
                        <div class="FormLabel mylabel NotesLabel">
                            Notes</div>
                        <telerik:RadEditor ID="RadEditoDesc" CssClass="TextEditor" Width="620" Height="225"
                            AutoResizeHeight="false" AllowScripts="false" SkinID="BasicSetOfTools" EnableEmbeddedSkins="false"
                            Skin="Prodigy" runat="server">
                            <Tools>
                                <telerik:EditorToolGroup Tag="MainToolbar">
                                    <telerik:EditorTool Name="AjaxSpellCheck" />
                                    <telerik:EditorTool Name="FindAndReplace" />
                                    <telerik:EditorSeparator Visible="true" />
                                    <telerik:EditorTool Name="Undo" />
                                    <telerik:EditorTool Name="Redo" />
                                    <telerik:EditorSeparator Visible="true" />
                                    <telerik:EditorTool Name="Cut" />
                                    <telerik:EditorTool Name="Copy" />
                                    <telerik:EditorTool Name="Paste" ShortCut="CTRL+!" />
                                </telerik:EditorToolGroup>
                                <telerik:EditorToolGroup Tag="Formatting">
                                    <telerik:EditorTool Name="Bold" />
                                    <telerik:EditorTool Name="Italic" />
                                    <telerik:EditorTool Name="Underline" />
                                    <telerik:EditorSeparator Visible="true" />
                                    <telerik:EditorTool Name="ForeColor" />
                                    <telerik:EditorTool Name="BackColor" />
                                    <telerik:EditorSeparator Visible="true" />
                                    <telerik:EditorTool Name="FontName" />
                                    <telerik:EditorTool Name="RealFontSize" />
                                    <telerik:EditorSeparator Visible="true" />
                                    <telerik:EditorTool Name="InsertOrderedList" />
                                    <telerik:EditorTool Name="InsertUnorderedList" />
                                    <telerik:EditorTool Name="Outdent" />
                                    <telerik:EditorTool Name="Indent" />
                                </telerik:EditorToolGroup>
                            </Tools>
                        </telerik:RadEditor>
                        <br style="clear: both;" />
                    </div>
                    <div class="sectionDivider">
                    </div>
                    <div class="InputWrapper row addphone">
                        <div class="FormLabel">
                        </div>
                        <telerik:RadComboBox DataTextField="Name" DataValueField="PhoneNumberTypeID" DataSourceID="DataSourcePhoneTypes"
                            ID="RadComboBoxPhoneTypes" runat="server" EnableEmbeddedSkins="false" SkinID="Prodigy"
                            CssClass="mydropdown">
                        </telerik:RadComboBox>
                        <uc2:AddEditPhoneNumber ID="Phone" runat="server" />
                        <div class="row">
                            <asp:Button ID="ButtonAddPhone" runat="server" ValidationGroup="Save" OnClick="ButtonAddPhone_Click"
                                Text="Add" CssClass="mybutton myaddbutton" />
                        </div>
                    </div>
                </div>
                <telerik:RadGrid ID="RadGridPhoneNumbers" runat="server" AutoGenerateColumns="false"
                    AllowPaging="true" PageSize="5" Width="100%" OnNeedDataSource="RadGridPhoneNumbers_NeedsDataSource"
                    EnableEmbeddedSkins="false" Skin="Prodigy" HorizontalAlign="Center" OnDeleteCommand="RadGridPhoneNumbers_DeleteCommand">
                    <MasterTableView TableLayout="Auto" DataKeyNames="PhoneNumberID">
                        <Columns>
                            <telerik:GridBoundColumn DataField="Phone" HeaderText="Phone">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="PhoneNumberType.Name" HeaderText="Type">
                            </telerik:GridBoundColumn>
                            <telerik:GridButtonColumn ButtonType="ImageButton" ItemStyle-Width="10%" ItemStyle-HorizontalAlign="Center"
                                HeaderStyle-HorizontalAlign="Center" CommandArgument="Delete" CommandName="Delete"
                                ImageUrl="../../../App_Themes/Prodigy/Grid/Delete.png" ShowFilterIcon="False"
                                UniqueName="DeleteColumn" ConfirmText="Are you sure you want to delete this phone from the location ?"
                                ButtonCssClass="IconButton DeleteButton">
                            </telerik:GridButtonColumn>
                        </Columns>
                        <NoRecordsTemplate>
                            <p>
                                There are no phone numbers specified at this time!
                            </p>
                        </NoRecordsTemplate>
                    </MasterTableView>
                </telerik:RadGrid>
            </div>
        </auth:SecureContent>
    </div>
    <asp:Panel ID="PanelMainContentEditButtons" runat="server">
        <div class="editButtons">
            <auth:SecureContent ID="SecureContent2" ToggleVisible="true" ToggleEnabled="false"
                EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;">
                <asp:Button ID="DeleteButton" runat="server" CausesValidation="false" OnClick="DeleteButton_Click"
                    OnClientClick="return confirm('Are you sure you want to delete this Location/Site record? NOTE: if this is a site you are deleting all the locations associated with it.');"
                    Text="Delete" class="mybutton mydelete" />
                <asp:Button ID="ButtonSaveLocation" runat="server" ValidationGroup="Save" Text="Save"
                    OnClick="ButtonSaveLocation_Click" CssClass="mybutton mysave" /></auth:SecureContent>
        </div>
    </asp:Panel>
    <asp:Label ID="LabelFeedback" runat="server" Text="" ForeColor="#FF3300"></asp:Label>
    <asp:EntityDataSource ID="DataSourceSites" runat="server" ConnectionString="name=PODContext"
        EntityTypeFilter="Site" DefaultContainerName="PODContext" EnableFlattening="False"
        EntitySetName="Locations">
    </asp:EntityDataSource>
    <asp:EntityDataSource ID="DataSourceStatusTypes" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" EnableFlattening="False" EntitySetName="StatusTypes"
        OrderBy="it.[Name]" Where='it.[Category]=="Common"'>
    </asp:EntityDataSource>
    <asp:EntityDataSource ID="DataSourcePhoneTypes" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" EnableFlattening="False" EntitySetName="PhoneNumberTypes"
        OrderBy="it.[Name]">
    </asp:EntityDataSource>
    <asp:EntityDataSource ID="DataSourceLocationTypes" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" EnableFlattening="False" EntitySetName="LocationTypes"
        OrderBy="it.[Name]">
    </asp:EntityDataSource>
</asp:Content>
