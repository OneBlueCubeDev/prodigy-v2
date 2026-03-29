<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master"
    AutoEventWireup="true" CodeBehind="ContractPage.aspx.cs" Inherits="POD.Pages.Admin.ManageContracts.ContractPage" %>
<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <div class="tabcontainer widetabcontainer">
        <div class="tabcontent">
            <h2 class="AdminHeader">
                Contract Info</h2>
            <p>
                <asp:Literal ID="LiteralError" runat="server" Visible="False"></asp:Literal>
            </p>
              <auth:SecureContent ID="SecureContent2" ToggleVisible="false" ToggleEnabled="true"
                    EventHook="Load" runat="server" Roles="Administrators;">
            <div class="UserEntryFormWrapper AdminContractForm">
                <div class="InputWrapper row">
                    <div class="FormLabel mylabel">
                        Contract Number</div>
                    <asp:TextBox ID="TextBoxContractNumber" runat="server" Width="350px" class="myfield"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="TextBoxContractNumber"
                        InitialValue="" ErrorMessage="&nbsp;* Required" Display="Dynamic" ValidationGroup="Save"></asp:RequiredFieldValidator>
                </div>
                <br />
                <div class="InputWrapper row">
                    <h3 class="FormLabel widelabel sectionHead">
                        Attach to Program or Site</h3>
                </div>
                <div class="InputWrapper row">
                    <div class="FormLabel mylabel">
                        Program</div>
                    <telerik:RadComboBox ID="RadComboProgram" runat="server" EnableEmbeddedSkins="false"
                        SkinID="Prodigy" CssClass="mydropdown" AppendDataBoundItems="True" DataTextField="Name"
                        DataValueField="ProgramID" DataSourceID="EntityProgramsDataSource" OnClientSelectedIndexChanged="ClearSite">
                        <Items>
                            <telerik:RadComboBoxItem runat="server" Value="" Text="" />
                        </Items>
                    </telerik:RadComboBox>
                    <div class="FormLabel mylabel SiteLabel">
                        Site</div>
                    <telerik:RadComboBox ID="RadComboLocation" runat="server" EnableEmbeddedSkins="false"
                        SkinID="Prodigy" CssClass="mydropdown" AppendDataBoundItems="True" DataTextField="SiteName"
                        DataValueField="LocationID" DataSourceID="EntityLocationsDataSource" OnClientSelectedIndexChanged="ClearProgram">
                        <Items>
                            <telerik:RadComboBoxItem runat="server" Value="" Text="" />
                        </Items>
                    </telerik:RadComboBox>
                </div>
                <div class="InputWrapper row">
                    <div class="FormLabel mylabel">
                        Status</div>
                    <telerik:RadComboBox ID="RadComboStatus" runat="server" EnableEmbeddedSkins="false"
                        SkinID="Prodigy" CssClass="mydropdown" AppendDataBoundItems="True" DataTextField="Name"
                        DataValueField="StatusTypeID" DataSourceID="EntityStatusTypesDataSource">
                    </telerik:RadComboBox>
                </div>
                <div class="InputWrapper row">
                    <div class="FormLabel mylabel">
                        Start Date</div>
                    <telerik:RadDatePicker ID="RadStartDatePicker" runat="server" DateInput-Width="50px"
                        Width="105px" DateInput-DisplayDateFormat="MM/dd/yyyy" Calendar-ShowRowHeaders="False"
                        Calendar-CssClass="myDatePickerPopup myenrollmentdate" CssClass="myDatePickerPopup">
                    </telerik:RadDatePicker>
                </div>
                <div class="InputWrapper row">
                    <div class="FormLabel mylabel">
                        End Date</div>
                    <telerik:RadDatePicker ID="RadEndDatePicker" runat="server" DateInput-Width="50px"
                        Width="105px" DateInput-DisplayDateFormat="MM/dd/yyyy" Calendar-ShowRowHeaders="False"
                        Calendar-CssClass="myDatePickerPopup myenrollmentdate" CssClass="myDatePickerPopup">
                    </telerik:RadDatePicker>
                </div>
            </div>
            </auth:SecureContent>
            <div class="sectionDivider"></div>
            <br />
            <telerik:RadGrid ID="RadGridQuotas" runat="server" AutoGenerateColumns="false" AllowPaging="true"
                PageSize="5" Width="100%" OnNeedDataSource="RadGridQuotas_OnNeedDataSource" EnableEmbeddedSkins="false"
                Skin="Prodigy" HorizontalAlign="Center" OnDeleteCommand="RadGridQuotas_OnDeleteCommand" OnItemDataBound="RadgridQuotas_ItemDataBound"
                OnUpdateCommand="RadGridQuotas_OnUpdateCommand" OnInsertCommand="RadGridQuotas_OnInsertCommand" CssClass="ContractGrid">
                <MasterTableView TableLayout="Auto" DataKeyNames="ContractID,EnrollmentTypeID"
                    CommandItemDisplay="Top">
                    <CommandItemTemplate>
                        <table class="rgCommandTable">
                            <tbody>
                                <tr>
                                    <td align="left">  <auth:SecureContent ID="SecureContent2" ToggleVisible="true" ToggleEnabled="false"
                    EventHook="Load" runat="server" Roles="Administrators;">
                                        <asp:LinkButton ID="LinkButton1" runat="server" CommandArgument="InitInsert" CommandName="InitInsert">
                                            <img src="../../../App_Themes/Prodigy/Grid/Add.gif" alt="Add New Enrollment Quota"/>
                                            Add New Enrollment Quota
                                        </asp:LinkButton> </auth:SecureContent>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </CommandItemTemplate>
                    <Columns>
                        <telerik:GridTemplateColumn UniqueName="EnrollmentTypeColumn" HeaderText="Enrollment Type" DataField="EnrollmentTypeID">
                            <ItemTemplate>
                                <%# Eval("EnrollmentType.Name") %>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:Label ID="EnrollmentLabel" runat="server" Text='<%# Eval("EnrollmentType.Name") %>'></asp:Label>
                            </EditItemTemplate>
                            <InsertItemTemplate>
                                <telerik:RadComboBox ID="EnrollmentType" runat="server" AppendDataBoundItems="True" DataSourceID="EntityEnrollmentTypeDataSource"
                                    DataTextField="Name" DataValueField="EnrollmentTypeID" SelectedValue='<%# Bind("EnrollmentTypeID") %>' CssClass="mydropdown">
                                    <Items>
                                        <telerik:RadComboBoxItem runat="server" />
                                    </Items>
                                </telerik:RadComboBox>
                            </InsertItemTemplate>
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn UniqueName="AmountColumn" DataField="Amount" HeaderText="Amount">
                            <ItemTemplate>
                                <%# Eval("Amount") %>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <telerik:RadTextBox ID="Amount" runat="server" Text='<%# Bind("Amount") %>' CssClass="myfield"></telerik:RadTextBox>
                            </EditItemTemplate>
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn UniqueName="LengthColumn" DataField="ExpectedLengthInDays" HeaderText="Expected Length in Days">
                            <ItemTemplate>
                                <%# Eval("ExpectedLengthInDays") %>
                            </ItemTemplate>                            
                            <EditItemTemplate>
                                <telerik:RadTextBox ID="ExpectedLengthInDays" runat="server" Text='<%# Bind("ExpectedLengthInDays") %>' CssClass="myfield"></telerik:RadTextBox>
                            </EditItemTemplate>
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn UniqueName="HoursColumn" DataField="RequiredProgrammingHours" HeaderText="Required Programming Hours">
                            <ItemTemplate>
                                <%# Eval("RequiredProgrammingHours")%>
                            </ItemTemplate>                                               
                            <EditItemTemplate>
                                <telerik:RadTextBox ID="RequiredProgrammingHours" runat="server" Text='<%# Bind("RequiredProgrammingHours") %>' CssClass="myfield"></telerik:RadTextBox>
                            </EditItemTemplate>                            
                        </telerik:GridTemplateColumn>
                        <telerik:GridButtonColumn ButtonType="ImageButton" ItemStyle-Width="10%" ItemStyle-HorizontalAlign="Center"
                            HeaderStyle-HorizontalAlign="Center" CommandArgument="Edit" CommandName="Edit"
                            ImageUrl="../../../App_Themes/Prodigy/Grid/edit.gif" ShowFilterIcon="False"
                            UniqueName="EditColumn" ButtonCssClass="IconButton EditButton">
                        </telerik:GridButtonColumn>
                        <telerik:GridButtonColumn ButtonType="ImageButton" ItemStyle-Width="10%" ItemStyle-HorizontalAlign="Center"
                            HeaderStyle-HorizontalAlign="Center" CommandArgument="Delete" CommandName="Delete"
                            ImageUrl="../../../App_Themes/Prodigy/Grid/Delete.png" ShowFilterIcon="False"
                            UniqueName="DeleteColumn" ConfirmText="Are you sure you want to delete this contract enrollment quota?"
                            ButtonCssClass="IconButton DeleteButton">
                        </telerik:GridButtonColumn>
                    </Columns>
                    <NoRecordsTemplate>
                        <p>
                            There are no contract enrollment quotas specified at this time!
                        </p>
                    </NoRecordsTemplate>
                </MasterTableView>
            </telerik:RadGrid>
        </div>
    </div>
    <asp:Panel ID="PanelMainContentEditButtons" runat="server">
        <div class="editButtons">
            <asp:Button ID="ButtonCancel" runat="server" CausesValidation="false" PostBackUrl="ContractManagement.aspx"
                Text="Done" class="mybutton mycancel" />
            <asp:Button ID="ButtonSave" runat="server" ValidationGroup="Save" Text="Save" OnClick="ButtonSave_OnClick"
                CssClass="mybutton mysave" />
        </div>
    </asp:Panel>
    <asp:Label ID="LabelFeedback" runat="server" Text="" ForeColor="#FF3300"></asp:Label>
    <asp:EntityDataSource ID="EntityLocationsDataSource" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" EnableFlattening="False" EntitySetName="Locations"
        EntityTypeFilter="Site" Where="it.StatusType.Name == &quot;Active&quot;">
    </asp:EntityDataSource>
    <asp:EntityDataSource ID="EntityProgramsDataSource" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" EnableFlattening="False" EntitySetName="Programs"
        Where="it.StatusType.Name == &quot;Active&quot;">
    </asp:EntityDataSource>
    <asp:EntityDataSource ID="EntityStatusTypesDataSource" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" EnableFlattening="False" EntitySetName="StatusTypes"
        Where="it.IsActive == true && (it.Category == &quot;Common&quot; || it.Category == &quot;Contract&quot;)">
    </asp:EntityDataSource>
    <asp:LinqDataSource ID="EntityEnrollmentTypeDataSource" runat="server" 
        OnSelecting="EntityEnrollmentTypeDataSource_OnSelecting">
    </asp:LinqDataSource>
    <telerik:RadScriptBlock runat="server">
        <script type="text/javascript">
            function ClearProgram(sender, args) {
                var item = args.get_item();
                if (item.get_value() != '') {
                    $find("<%= RadComboProgram.ClientID %>").clearSelection();
                }
            }

            function ClearSite(sender, args) {
                var item = args.get_item();
                if (item.get_value() != '') {
                    $find("<%= RadComboLocation.ClientID %>").clearSelection();
                }
            }
        </script>
    </telerik:RadScriptBlock>
</asp:Content>
