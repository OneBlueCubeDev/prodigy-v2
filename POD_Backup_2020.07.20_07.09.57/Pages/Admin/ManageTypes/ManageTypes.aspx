<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master"
    AutoEventWireup="true" CodeBehind="ManageTypes.aspx.cs" Inherits="POD.Admin.ManageTypes.ManageTypes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server" EnableAJAX="true">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGridTimePeriods">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridTimePeriods" LoadingPanelID="RadAjaxLoadingPanel1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadGridAgeGroup">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridAgeGroup" LoadingPanelID="RadAjaxLoadingPanel1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadGridTypes">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridTypes" LoadingPanelID="RadAjaxLoadingPanel1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="ComboBoxType">
                <UpdatedControls>
                   
                    <telerik:AjaxUpdatedControl ControlID="PanelTimePeriods" LoadingPanelID="RadAjaxLoadingPanel1" />
                    <telerik:AjaxUpdatedControl ControlID="PanelTypes" LoadingPanelID="RadAjaxLoadingPanel1" />
                    <telerik:AjaxUpdatedControl ControlID="PanelAgeGroups" LoadingPanelID="RadAjaxLoadingPanel1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>
  
    <!--this is the loading image control, must specify an image -->
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" EnableSkinTransparency="true"
        runat="server">
    </telerik:RadAjaxLoadingPanel>
    <div class="tabcontainer widetabcontainer">
        <div class="tabcontent">
            <div class="ManageTypes">
                <h2 class="AdminHeader">
                    Manage Types
                </h2>
                <div class="SelectTypeClass">
                    <span>Select Type to Manage:</span>&nbsp;
                    <telerik:RadComboBox ID="ComboBoxType" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ComboBoxType_SelectedIndexChanged"
                        EnableEmbeddedSkins="false" SkinID="Prodigy" CssClass="mydropdown">
                    </telerik:RadComboBox>
                    <br />
                    <br />
                </div>
                <asp:Panel ID="PanelTypes" runat="server">
                    <telerik:RadGrid ID="RadGridTypes" runat="server" OnDeleteCommand="RadGridTypes_Delete"
                        AutoGenerateColumns="false" AllowPaging="true" PageSize="15" Skin="Prodigy" EnableEmbeddedSkins="false"
                        OnInsertCommand="RadGridTypes_InsertCommand" OnNeedDataSource="RadGridTypes_NeedDataSource"
                        OnUpdateCommand="RadGridTypes_UpdateCommand" CssClass="CommandItemGrid" OnItemDataBound="RadGridTypes_ItemDataBound">
                        <MasterTableView DataKeyNames="ID" CommandItemDisplay="Top" NoMasterRecordsText="No Types of selected kind were found">
                            <CommandItemSettings ShowAddNewRecordButton="true" AddNewRecordImageUrl="../../../App_Themes/Prodigy/Grid/Add.gif"
                                AddNewRecordText="Add Type" ShowRefreshButton="true" RefreshImageUrl="../../../App_Themes/Prodigy/Grid/Refresh.png"
                                RefreshText="" />
                            <ItemStyle />
                            <EditFormSettings EditColumn-ButtonType="LinkButton">
                                <FormTableButtonRowStyle CssClass="EditButtonRow" />
                            </EditFormSettings>
                            <AlternatingItemStyle />
                            <Columns>
                                <telerik:GridButtonColumn ButtonType="ImageButton" ItemStyle-Width="7%" CommandArgument="Edit"
                                    CommandName="Edit" ImageUrl="../../../App_Themes/Prodigy/Grid/edit.gif" ItemStyle-HorizontalAlign="Center"
                                    ShowFilterIcon="False" UniqueName="EditColumn" ButtonCssClass="IconButton PencilButton"
                                    HeaderStyle-HorizontalAlign="Center">
                                </telerik:GridButtonColumn>
                                <telerik:GridBoundColumn DataField="Name" SortExpression="Name" ItemStyle-Width="23%"
                                    HeaderText="Name" HeaderStyle-Width="100px" />
                                <telerik:GridTemplateColumn SortExpression="IsActive" HeaderText="Status" ItemStyle-Width="10%">
                                    <ItemTemplate>
                                        <asp:Label ID="LabelIsActive" runat="server" Text='<%# Eval("IsActive").ToString() == "True" ? "Active": "Inactive" %>'></asp:Label>
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                                <telerik:GridBoundColumn DataField="Description" SortExpression="Description" MaxLength="250"
                                    HeaderText="Desc" ItemStyle-Width="50%">
                                </telerik:GridBoundColumn>
                                <telerik:GridButtonColumn ButtonType="ImageButton" ItemStyle-Width="10%" HeaderStyle-HorizontalAlign="Center"
                                    ItemStyle-HorizontalAlign="Center" CommandArgument="Delete" CommandName="Delete"
                                    ImageUrl="../../../App_Themes/Prodigy/Grid/Delete.png" ShowFilterIcon="False"
                                    UniqueName="DeleteColumn" ConfirmText="Are you sure you want to delete this type entry?"
                                    ButtonCssClass="IconButton DeleteButton">
                                </telerik:GridButtonColumn>
                            </Columns>
                            <EditFormSettings EditFormType="Template" EditColumn-ButtonType="LinkButton">
                                <FormTemplate>
                                    <asp:Panel ID="PanelContent" class="FormWrapper" runat="server">
                                        <div class="InputWrapper row">
                                            <asp:Label ID="ManageTypesName" runat="server" Text="Name" CssClass="mylabel"></asp:Label>
                                            <asp:TextBox ID="TextBoxName" runat="server" CssClass="myfield"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="ReqValName" runat="server" SetFocusOnError="true"
                                                Display="Dynamic" ControlToValidate="TextBoxName" ValidationGroup="Save" CssClass="ErrorMessage"
                                                ErrorMessage="Name is required" Text="*"></asp:RequiredFieldValidator>
                                        </div>
                                        <div class="InputWrapper row">
                                            <asp:Label ID="ManageTypesStatus" runat="server" Text="Status" CssClass="mylabel"></asp:Label>
                                            <asp:RadioButtonList ID="RadiobuttonList" runat="server" RepeatDirection="Horizontal"
                                                CssClass="myUserActive" RepeatLayout="Table">
                                                <asp:ListItem Text="Active" Value="True"></asp:ListItem>
                                                <asp:ListItem Text="Inactive" Value="False"></asp:ListItem>
                                            </asp:RadioButtonList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" SetFocusOnError="true"
                                                Display="Dynamic" ControlToValidate="RadiobuttonList" ValidationGroup="Save"
                                                InitialValue="" CssClass="ErrorMessage" ErrorMessage="Status is required" Text="*"></asp:RequiredFieldValidator>
                                        </div>
                                        <asp:Panel ID="PanelStatusCategory" Visible="false" runat="server" CssClass="InputWrapper row">
                                            <asp:Label ID="Label1" runat="server" Text="Status Category" CssClass="mylabel"></asp:Label>
                                            <asp:DropDownList ID="DropdownListCategory" runat="server">
                                                <asp:ListItem Text="Select Category" Value=""></asp:ListItem>
                                                <asp:ListItem Text="Lesson Plan Set" Value="LessonPlanSet"></asp:ListItem>
                                                <asp:ListItem Text="Enrollment" Value="Enrollment"></asp:ListItem>
                                                <asp:ListItem Text="Common" Value="Common"></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorStatusCategory" runat="server"
                                                SetFocusOnError="true" Display="Dynamic" ControlToValidate="DropdownListCategory"
                                                Enabled="false" ValidationGroup="Save" InitialValue="" CssClass="ErrorMessage"
                                                ErrorMessage="Status Category is required" Text="*"></asp:RequiredFieldValidator>
                                        </asp:Panel>
                                        <div class="InputWrapper">
                                            <asp:Label ID="ManageTypesDesc" runat="server" Text="Description" CssClass="mylabel"></asp:Label>
                                            <asp:TextBox ID="RadEditoDesc" runat="server" CssClass="myfield" Height="200px" Width="630px"
                                                Rows="300" Columns="500" TextMode="MultiLine"></asp:TextBox>
                                            <br style="clear: both;" />
                                        </div>
                                        <div class="InputWrapper">
                                            <div class="FormLabel">
                                                &nbsp;
                                            </div>
                                            <asp:Button ID="btnUpdate" Text="Update" runat="server" ValidationGroup="Save" CssClass="mybutton"
                                                CommandName="Update" Visible='<%# !(Container.DataItem is Telerik.Web.UI.GridInsertionObject) %>'>
                                            </asp:Button>
                                            <asp:Button ID="btnInsert" Text="Insert" ValidationGroup="Save" runat="server" CommandName="PerformInsert"
                                                CssClass="mybutton " Visible='<%# Container.DataItem is Telerik.Web.UI.GridInsertionObject %>'>
                                            </asp:Button>
                                            &nbsp; &nbsp;
                                            <asp:Button runat="server" ID="ButtonCacnel" Text="Cancel" CssClass="mybutton mycancel"
                                                CommandName="Cancel" CausesValidation="false"></asp:Button>
                                        </div>
                                    </asp:Panel>
                                </FormTemplate>
                            </EditFormSettings>
                        </MasterTableView>
                    </telerik:RadGrid>
                </asp:Panel>
                <asp:Panel ID="PanelAgeGroups" Visible="false" runat="server" class="ManageAgeGroups">
                    <telerik:RadGrid ID="RadGridAgeGroup" runat="server" AutoGenerateColumns="false"
                        AllowPaging="true" PageSize="5" AllowSorting="true" Skin="Prodigy" EnableEmbeddedSkins="false"
                        OnInsertCommand="RadGridAgeGroup_InsertCommand" OnNeedDataSource="RadGridAgeGroup_NeedDataSource"
                        OnUpdateCommand="RadGridAgeGroup_UpdateCommand" OnItemCommand="RadGridAgeGroup_ItemCommand"
                        OnDeleteCommand="RadGridAgeGroup_DeleteCommand" CssClass="CommandItemGrid">
                        <MasterTableView DataKeyNames="AgeGroupID" CommandItemDisplay="Top" NoMasterRecordsText="No Age Group was found">
                            <CommandItemSettings ShowAddNewRecordButton="true" AddNewRecordImageUrl="../../../App_Themes/Prodigy/Grid/Add.gif"
                                AddNewRecordText="Add Age Group" ShowRefreshButton="true" RefreshImageUrl="../../../App_Themes/Prodigy/Grid/Refresh.png"
                                RefreshText="" />
                            <ItemStyle />
                            <EditFormSettings EditColumn-ButtonType="LinkButton">
                                <FormTableButtonRowStyle CssClass="EditButtonRow" />
                            </EditFormSettings>
                            <AlternatingItemStyle />
                            <Columns>
                                <telerik:GridButtonColumn ButtonType="ImageButton" ItemStyle-Width="7%" CommandArgument="Edit"
                                    CommandName="Edit" ImageUrl="../../../App_Themes/Prodigy/Grid/edit.gif" ItemStyle-HorizontalAlign="Center"
                                    ShowFilterIcon="False" UniqueName="EditColumn" ButtonCssClass="IconButton PencilButton"
                                    HeaderStyle-HorizontalAlign="Center">
                                </telerik:GridButtonColumn>
                                <telerik:GridBoundColumn DataField="Name" SortExpression="Name" ItemStyle-Width="63%"
                                    HeaderText="Name" />
                                <telerik:GridBoundColumn DataField="AgeMinimum" SortExpression="AgeMinimum" ItemStyle-Width="10%"
                                    HeaderText="Min Age" HeaderStyle-Width="10%" />
                                <telerik:GridBoundColumn DataField="AgeMaximum" SortExpression="AgeMaximum" ItemStyle-Width="10%"
                                    HeaderText="Max Age" HeaderStyle-Width="10%" />
                                <telerik:GridButtonColumn ButtonType="ImageButton" ItemStyle-Width="10%" HeaderStyle-HorizontalAlign="Center"
                                    CommandArgument="Delete" CommandName="Delete" ItemStyle-HorizontalAlign="Center"
                                    ImageUrl="../../../App_Themes/Prodigy/Grid/Delete.png" ShowFilterIcon="False"
                                    UniqueName="DeleteColumn" 
                                    ButtonCssClass="IconButton DeleteButton">
                                </telerik:GridButtonColumn>
                            </Columns>
                            <EditFormSettings EditFormType="Template" EditColumn-ButtonType="LinkButton">
                                <FormTemplate>
                                    <asp:Panel ID="PanelContent" class="FormWrapper" runat="server">
                                        <div class="InputWrapper row">
                                            <asp:Label ID="ManageAgeGroupsName" runat="server" Text="Name" CssClass="mylabel"></asp:Label>
                                            <asp:TextBox ID="TextBoxName" runat="server" Text='<%# Bind("Name") %>' CssClass="myfield"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="ReqValName" runat="server" SetFocusOnError="true"
                                                Display="Dynamic" ControlToValidate="TextBoxName" ValidationGroup="Save" CssClass="ErrorMessage"
                                                ErrorMessage="Name is required" Text="*"></asp:RequiredFieldValidator>
                                        </div>
                                        <div class="InputWrapper row">
                                            <asp:Label ID="ManageAgeGroupsMinAge" runat="server" Text="Minimum Age" CssClass="mylabel"></asp:Label>
                                            <telerik:RadNumericTextBox ID="TextBoxMinimum" Text='<%# Bind("AgeMinimum") %>' runat="server"
                                                Type="Number" EnableEmbeddedSkins="false" Skin="Prodigy" NumberFormat-DecimalDigits="0"
                                                CssClass="myfield" Width="157px">
                                            </telerik:RadNumericTextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" SetFocusOnError="true"
                                                Display="Dynamic" ControlToValidate="TextBoxMinimum" ValidationGroup="Save" InitialValue=""
                                                CssClass="ErrorMessage" ErrorMessage="Minimum Age is required" Text="*"></asp:RequiredFieldValidator>
                                        </div>
                                        <div class="InputWrapper row">
                                            <asp:Label ID="ManageAgeGroupsMaxAge" runat="server" Text="Maximum Age" CssClass="mylabel"></asp:Label>
                                            <telerik:RadNumericTextBox ID="TextBoxMax" runat="server" Type="Number" EnableEmbeddedSkins="false"
                                                Skin="Prodigy" Text='<%# Bind("AgeMaximum") %>' NumberFormat-DecimalDigits="0"
                                                CssClass="myfield" Width="157px">
                                            </telerik:RadNumericTextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" SetFocusOnError="true"
                                                Display="Dynamic" ControlToValidate="TextBoxMax" ValidationGroup="Save" InitialValue=""
                                                CssClass="ErrorMessage" ErrorMessage="Maximum Age is required" Text="*"></asp:RequiredFieldValidator>
                                        </div>
                                        <div class="InputWrapper">
                                            <div class="FormLabel">
                                                &nbsp;
                                            </div>
                                            <asp:Button ID="btnUpdate" Text="Update" runat="server" ValidationGroup="Save" CssClass="mybutton"
                                                CommandName="Update" Visible='<%# !(Container.DataItem is Telerik.Web.UI.GridInsertionObject) %>'>
                                            </asp:Button>
                                            <asp:Button ID="btnInsert" Text="Insert" ValidationGroup="Save" runat="server" CommandName="PerformInsert"
                                                CssClass="mybutton" Visible='<%# Container.DataItem is Telerik.Web.UI.GridInsertionObject %>'>
                                            </asp:Button>
                                            &nbsp; &nbsp;
                                            <asp:Button runat="server" ID="ButtonCacnel" Text="Cancel" CssClass="mybutton mycancel"
                                                CommandName="Cancel" CausesValidation="false"></asp:Button>
                                        </div>
                                    </asp:Panel>
                                </FormTemplate>
                            </EditFormSettings>
                        </MasterTableView>
                    </telerik:RadGrid>
                </asp:Panel>
                <asp:Panel ID="PanelTimePeriods" Visible="false" runat="server" class="ManageTimePeriods">
                    <telerik:RadGrid ID="RadGridTimePeriods" runat="server" AutoGenerateColumns="false"
                        AllowPaging="true" PageSize="5" AllowSorting="true" Skin="Prodigy" EnableEmbeddedSkins="false"
                        OnInsertCommand="RadGridTimePeriods_InsertCommand" OnNeedDataSource="RadGridTimePeriods_NeedDataSource"
                        OnUpdateCommand="RadGridTimePeriods_UpdateCommand" OnItemCommand="RadGridTimePeriods_ItemCommand"
                        OnDeleteCommand="RadGridTimePeriods_DeleteCommand" OnItemDataBound="RadGridTimePeriods_ItemDataBound"
                        CssClass="CommandItemGrid">
                        <MasterTableView DataKeyNames="TimePeriodID" CommandItemDisplay="Top" NoMasterRecordsText="No Time Period was found">
                            <CommandItemSettings ShowAddNewRecordButton="true" AddNewRecordImageUrl="../../../App_Themes/Prodigy/Grid/Add.gif"
                                AddNewRecordText="Add Time Period" ShowRefreshButton="true" RefreshImageUrl="../../../App_Themes/Prodigy/Grid/Refresh.png"
                                RefreshText="" />
                            <ItemStyle />
                            <EditFormSettings EditColumn-ButtonType="LinkButton">
                                <FormTableButtonRowStyle CssClass="EditButtonRow" />
                            </EditFormSettings>
                            <AlternatingItemStyle />
                            <Columns>
                                <telerik:GridButtonColumn ButtonType="ImageButton" ItemStyle-Width="7%" CommandArgument="Edit"
                                    CommandName="Edit" ImageUrl="../../../App_Themes/Prodigy/Grid/edit.gif" ItemStyle-HorizontalAlign="Center"
                                    ShowFilterIcon="False" UniqueName="EditColumn" ButtonCssClass="IconButton PencilButton"
                                    HeaderStyle-HorizontalAlign="Center">
                                </telerik:GridButtonColumn>
                                <telerik:GridBoundColumn DataField="TimePeriodType.Name" SortExpression="TimePeriodType.Name"
                                    ItemStyle-Width="63%" HeaderText="Type" />
                                <telerik:GridBoundColumn DataField="StartDate" SortExpression="StartDate" ItemStyle-Width="10%"
                                    HeaderText="Start Date" DataFormatString="{0:d}" HeaderStyle-Width="10%" />
                                <telerik:GridBoundColumn DataField="EndDate" SortExpression="EndDate" ItemStyle-Width="10%"
                                    HeaderText="End Date" DataFormatString="{0:d}" HeaderStyle-Width="10%" />
                                <telerik:GridButtonColumn ButtonType="ImageButton" ItemStyle-Width="10%" HeaderStyle-HorizontalAlign="Center"
                                    CommandArgument="Delete" CommandName="Delete" ItemStyle-HorizontalAlign="Center"
                                    ImageUrl="../../../App_Themes/Prodigy/Grid/Delete.png" ShowFilterIcon="False"
                                    UniqueName="DeleteColumn" ConfirmText="Are you sure you want to delete this Time Period?"
                                    ButtonCssClass="IconButton DeleteButton">
                                </telerik:GridButtonColumn>
                            </Columns>
                            <EditFormSettings EditFormType="Template" EditColumn-ButtonType="LinkButton">
                                <FormTemplate>
                                    <asp:Panel ID="PanelContent" class="FormWrapper" runat="server">
                                        <div class="InputWrapper row">
                                            <asp:Label ID="ManageTimePerType" runat="server" Text="Type" CssClass="mylabel"></asp:Label>
                                            <telerik:RadComboBox ID="RadComboBoxTypes" DataValueField="TimePeriodTypeID" DataTextField="Name"
                                                runat="server" CssClass="mydropdown" DataSourceID="DataSourceTimePeriodTypes"
                                                SelectedValue='<%# Bind("TimePeriodTypeID") %>'>
                                            </telerik:RadComboBox>
                                            <asp:RequiredFieldValidator ID="ReqValName" runat="server" SetFocusOnError="true"
                                                Display="Dynamic" ControlToValidate="RadComboBoxTypes" ValidationGroup="Save"
                                                CssClass="ErrorMessage" ErrorMessage="Type is required" Text="*"></asp:RequiredFieldValidator>
                                        </div>
                                        <div class="InputWrapper row">
                                            <asp:Label ID="ManageTimePerStart" runat="server" Text="Start Date" CssClass="mylabel myeditdatepickerlabel"></asp:Label>
                                            <div class="myeditdatepicker">
                                                <telerik:RadDatePicker ID="RadDatePickerStartDate" runat="server" DateInput-Width="50px"
                                                    Width="52%" DateInput-DisplayDateFormat="MM/dd/yy" Calendar-ShowRowHeaders="False"
                                                    Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup myenrollmentdob">
                                                </telerik:RadDatePicker>
                                            </div>
                                        </div>
                                        <div class="InputWrapper row">
                                            <asp:Label ID="ManageTimePerEnd" runat="server" Text="End Date" CssClass="mylabel myeditdatepickerlabel"></asp:Label>
                                            <div class="myeditdatepicker">
                                                <telerik:RadDatePicker ID="RadDatePickerEndDate" runat="server" DateInput-Width="50px"
                                                    Width="52%" DateInput-DisplayDateFormat="MM/dd/yy" Calendar-ShowRowHeaders="False"
                                                    Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup myenrollmentdob">
                                                </telerik:RadDatePicker>
                                            </div>
                                        </div>
                                        <div class="InputWrapper">
                                            <div class="FormLabel">
                                                &nbsp;
                                            </div>
                                            <asp:Button ID="btnUpdate" Text="Update" runat="server" ValidationGroup="Save" CssClass="mybutton"
                                                CommandName="Update" Visible='<%# !(Container.DataItem is Telerik.Web.UI.GridInsertionObject) %>'>
                                            </asp:Button>
                                            <asp:Button ID="btnInsert" Text="Insert" ValidationGroup="Save" runat="server" CommandName="PerformInsert"
                                                CssClass="mybutton" Visible='<%# Container.DataItem is Telerik.Web.UI.GridInsertionObject %>'>
                                            </asp:Button>
                                            &nbsp; &nbsp;
                                            <asp:Button runat="server" ID="ButtonCancel" Text="Cancel" CssClass="mybutton mycancel"
                                                CommandName="Cancel" CausesValidation="false"></asp:Button>
                                        </div>
                                    </asp:Panel>
                                </FormTemplate>
                            </EditFormSettings>
                        </MasterTableView>
                    </telerik:RadGrid>
                </asp:Panel>
            </div>
        </div>
    </div>
    <asp:EntityDataSource ID="DataSourceTimePeriodTypes" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" EnableFlattening="False" EntitySetName="TimePeriodTypes"
        OrderBy="it.[Name]">
    </asp:EntityDataSource>
</asp:Content>
