<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master"
    AutoEventWireup="true" CodeBehind="BulkReleaseTool.aspx.cs" Inherits="POD.Pages.Admin.BulkEdit.BulkReleaseTool" %>


<%@ Register Assembly="POD" Namespace="POD.Utillities" TagPrefix="custom" %>
<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <%-- START RAD GRID EXPERIMENT --%>


    <%-- START RAD GRID EXPERIMENT --%>
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server" EnableAJAX="true">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadcomboBoxFilter">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="ListViewData" LoadingPanelID="RadAjaxLoadingPanel1" />
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanel1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
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
    <telerik:RadCodeBlock runat="server" ID="RadCodeBlock1">
        <script type="text/javascript">

            function SetDirtyFlag(obj) {
                var currentRow = $(obj).closest('tr');
                if (currentRow != null) {
                    var flag = currentRow.find(".DirtyFlag");
                    if (flag != null) {
                        flag.val("Changed");
                    }
                }
            }

            function OnClientSelectedIndexChanged(sender, eventArgs) {
                var item = eventArgs.get_domEvent();
                SetDirtyFlag(item);
            }

            function OnDateSelected(sender, e) {
                var item = eventArgs.get_domEvent();
                SetDirtyFlag(item);
            }

            function OnBlurMasked(sender, e) {
                var item = eventArgs.get_domEvent();
                SetDirtyFlag(item);
            }

            
        </script>
    </telerik:RadCodeBlock>
    <div class="tabcontainer widetabcontainer">
        <div class="tabcontent">
            <div class="BulkEditWrapper">
                <h2>Bulk Youth Release Tool</h2>

                <div class="TopEditToolbar row">
                    <div class="ReleaseInfoWrapper">
                        <label class="mylabel myeditdatepickerlabel">
                            <b>Step 1</b>: Select the criteria to narrow your youth search.</label>
                    </div>
                    <div class="ReleaseInfoWrapper">
                        <%--<div class="myeditdatepicker">
                            <telerik:RadDatePicker ID="ReleaseDatePicker" runat="server" MinDate="1/1/1900" DateInput-Width="50px"
                                Width="52%" DateInput-DisplayDateFormat="MM/dd/yy" Calendar-ShowRowHeaders="False"
                                Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup myenrollmentdob">
                            </telerik:RadDatePicker>
                        </div>
                        <label class="mylabel">
                            Release Agency:</label>
                        <asp:TextBox ID="TextBoxReleaseAgency" runat="server" class="myfield"></asp:TextBox>
                        <label class="mylabel">
                            Release Reason:</label>
                        <asp:TextBox ID="TextBoxReleaseReason" runat="server" class="myfield"></asp:TextBox>
                        <label class="mylabel">
                            Filter:</label>--%>
                        <%--<telerik:RadComboBox ID="RadcomboBoxFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="RadcomboBoxFilter_SelectedIndexChanged"
                            CssClass="mydropdown">
                            <Items>
                                <telerik:RadComboBoxItem Text="All Youth" Value="All" />
                                <telerik:RadComboBoxItem Text="Prevention Youth" Value="Prevention" />
                                <telerik:RadComboBoxItem Text="Intervention Youth" Value="Intervention" />
                                <telerik:RadComboBoxItem Text="Diversion Youth" Value="Diversion" />
                                <telerik:RadComboBoxItem Text="Youth No Attendance Past 90 days" Value="NoAttendance" />
                                <telerik:RadComboBoxItem Text="Youth in Classess With Grant Year Rollover" Value="GrantYearRollover" />
                            </Items>
                        </telerik:RadComboBox>--%>
                        <div class="clear">
                        </div>
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
                        <asp:Label ID="Label12" runat="server" Text="Youth Type" class="sidelabel mylabel"
                            AssociatedControlID="RadcbYouthtype"></asp:Label>
                        <telerik:RadComboBox ID="RadcbYouthtype" AutoPostBack="true" OnSelectedIndexChanged="RadcbYouthtype_SelectedIndexChanged"
                            DataValueField="Key" DataTextField="Value"
                            runat="server" CssClass="mydropdown"
                            Height="100%" Width="142px">
                        </telerik:RadComboBox>

                        <asp:Label ID="Label2" runat="server" Text="Grant Year"
                            AssociatedControlID="RadComboBoxGrantYear"></asp:Label>
                        <telerik:RadComboBox ID="RadComboBoxGrantYear"
                            DataValueField="Key" DataTextField="Value"
                            runat="server" CssClass="mydropdown"
                            Height="100%" Width="142px">
                        </telerik:RadComboBox>
                    </div>

                </div>
                <div>
                    <auth:SecureContent ID="SecureContent3" ToggleVisible="true" ToggleEnabled="false"
                        EventHook="Load" runat="server" Roles="Administrators;">
                        <asp:Button ID="Button1" runat="server" Text="Find Youth" OnClick="Find_Click"
                            CssClass="mybutton" />
                    </auth:SecureContent>
                </div>
                <br />
                <%-- START RAD GRID EXPERIMENT --%>
                <div >
                    <label class="mylabel ">
                        <b>Step 2</b>: Select the youth you wish to release.</label>
                </div>
                <telerik:RadGrid RenderMode="Auto" ID="RadGrid1" OnSelectedIndexChanged="RadGrid1_SelectedIndexChanged" OnItemCreated="RadGrid1_ItemCreated" OnItemDataBound="RadGrid1_ItemDataBound" AutoGenerateColumns="false" AllowMultiRowSelection="true"  Width="100%"
                    runat="server" AllowSorting="false" >
                    <MasterTableView TableLayout="Auto" DataKeyNames="PersonID,EnrollmentID,EnrollmentTypeName,AddressID, HomePhoneID, CellPhoneID">
                        <Columns> 
                            
                            <telerik:GridClientSelectColumn HeaderStyle-Width="45px"  ItemStyle-HorizontalAlign="Center" UniqueName="ClientSelectColumn"></telerik:GridClientSelectColumn>
                            <%--<telerik:GridBoundColumn DataField="DJJIDNum"  ItemStyle-HorizontalAlign="Center" SortExpression="DJJIDNum" 
                                HeaderText="DJJ ID Num" HeaderStyle-Width="45px" FilterControlWidth="85%" AutoPostBackOnFilter="true"
                                ShowFilterIcon="true">
                            </telerik:GridBoundColumn>                            
                            <telerik:GridBoundColumn DataField="FirstName" SortExpression="FirstName" FilterControlWidth="85%"
                                AutoPostBackOnFilter="true" HeaderStyle-Width="105px" ShowFilterIcon="false" HeaderText="First Name">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="MiddleName" SortExpression="MiddleName" FilterControlWidth="85%"
                                AutoPostBackOnFilter="true" HeaderStyle-Width="45px" ShowFilterIcon="false" HeaderText="Middle Name">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="LastName" SortExpression="LastName" FilterControlWidth="85%"
                                AutoPostBackOnFilter="true" HeaderStyle-Width="105px" ShowFilterIcon="false" HeaderText="Last Name">
                            </telerik:GridBoundColumn>                            
                            <telerik:GridBoundColumn DataField="DateOfBirth" SortExpression="DateOfBirth" 
                                HeaderText="Date Of Birth" DataFormatString="{0:M/d/yyyy}"  ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="45px" FilterControlWidth="85%" AutoPostBackOnFilter="true"
                                ShowFilterIcon="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="SiteName" SortExpression="SiteName" 
                                HeaderText="Site Name" HeaderStyle-Width="45px" FilterControlWidth="85%" AutoPostBackOnFilter="true"
                                ShowFilterIcon="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="StatusTypeID" SortExpression="StatusTypeID"   ItemStyle-HorizontalAlign="Center"
                                HeaderText="Status" HeaderStyle-Width="65px" FilterControlWidth="85%" AutoPostBackOnFilter="true"
                                ShowFilterIcon="true">
                            </telerik:GridBoundColumn>
                            --%>

                        </Columns>
                    </MasterTableView>
                    <%--<NoRecordsTemplate>
                        <p>
                            no records found for your search.
                        </p>
                    </NoRecordsTemplate>--%>
                    <ClientSettings EnableRowHoverStyle="true">
                        <Selecting  AllowRowSelect="True"></Selecting>
                        <ClientEvents OnRowMouseOver="demo.RowMouseOver" />
                    </ClientSettings>
                </telerik:RadGrid>

                <%-- CLOSE RAD GRID EXPERIMENT --%>

               <%-- <div class="ReleaseInfoWrapper">
                    <label class="mylabel myeditdatepickerlabel">
                        <b>Step 2</b>: Select the youth you wish to release.</label>
                </div>--%>
                <div class="BulkEditContentWrapper">
                    <auth:SecureContent ID="SecureContent2" ToggleVisible="false" ToggleEnabled="true"
                        EventHook="Load" runat="server" Roles="Administrators;">
                        <custom:CustomListView ID="ListViewData" runat="server" Visible="false"  OnItemDataBound="ListViewData_ItemDataBound"
                            OnItemUpdating="ListViewData_ItemUpdating" DataKeyNames="PersonID,EnrollmentID,EnrollmentTypeName,AddressID, HomePhoneID, CellPhoneID"
                            EnableViewState="true" OnPagePropertiesChanging="ListViewData_PagePropertiesChanging"
                            OnItemUpdated="ListViewData_ItemUpdated">
                            <LayoutTemplate>
                                <table class="datasheet datatable excel2007 BulkEditTable" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <th>Release?
                                        </th>
                                        <th>DJJ ID #
                                        </th>
                                        <th>First Name
                                        </th>
                                        <th>Middle
                                        </th>
                                        <th>Last Name
                                        </th>
                                        <th>Date of Birth
                                        </th>
                                        <th>Address
                                        </th>
                                        <th>City
                                        </th>
                                        <th>Site
                                        </th>
                                        <%--<th>Location
                                        </th>--%>
                                        <%--<th>Home Phone
                                        </th>--%>
                                        <th>Status
                                        </th>
                                    </tr>
                                    <tr runat="server" id="itemPlaceholder">
                                    </tr>
                                </table>
                            </LayoutTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td align="center">
                                        <asp:CheckBox ID="CheckBox" runat="server" />
                                        <asp:TextBox ID="TextBox" runat="server" onBlur="SetDirtyFlag(this);" CssClass="DirtyFlag" Style="display: none;"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="TextBoxDJJID" onBlur="SetDirtyFlag(this);" runat="server" Text='<%# Bind("DJJIDNum") %>'
                                            CssClass="myfield" Width="80px"></asp:TextBox>
                                    </td>
                                    <td>
                                        <%--<asp:TextBox ID="txtFirstName" runat="server" onBlur="SetDirtyFlag(this);" Text='<%# Bind("FirstName") %>'
                                            CssClass="myfield" Width="100px"></asp:TextBox>--%>
                                        <asp:Label ID="txtFirstName" runat="server" Text='<%# Bind("FirstName") %>' class="sidelabel mylabel"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="TextBoxMiddleName" runat="server" onBlur="SetDirtyFlag(this);" Text='<%# Bind("MiddleName") %>'
                                            Width="60px" CssClass="myfield"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtLastName" onBlur="SetDirtyFlag(this);" runat="server" Text='<%# Bind("LastName") %>'
                                            CssClass="myfield" Width="100px"></asp:TextBox>
                                    </td>
                                    <td>
                                        <telerik:RadDatePicker ID="RadDatePickerDOB" runat="server" MinDate="1/1/1900" DateInput-Width="50px"
                                            Width="90px" DateInput-DisplayDateFormat="MM/dd/yy" Calendar-ShowRowHeaders="False"
                                            SelectedDate='<%# Bind("DateOfBirth") %>' Calendar-CssClass="myDatePickerPopup"
                                            CssClass="myDatePickerPopup myenrollmentdob" ClientEvents-OnDateSelected="OnDateSelected">
                                        </telerik:RadDatePicker>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="TextBoxAddress" onBlur="SetDirtyFlag(this);" runat="server" Text='<%# Bind("AddressLine1") %>'
                                            CssClass="myfield"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="TextBoxCity" onBlur="SetDirtyFlag(this);" runat="server" Text='<%# Bind("City") %>'
                                            CssClass="myfield" Width="110px"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label3" runat="server" Text='<%# Bind("SiteName") %>' class="sidelabel mylabel"></asp:Label>
                                    </td>
                                    <%--<td>
                                        <telerik:RadComboBox ID="RadSites" runat="server" EnableEmbeddedSkins="false"
                                            DataSourceID="DataSourceLocations" DataTextField="Name" DataValueField="LocationId"
                                            OnClientSelectedIndexChanged="OnClientSelectedIndexChanged" SkinID="Prodigy"
                                            CssClass="mydropdown" Height="100%" Width="142px">
                                            <Items>
                                                <telerik:RadComboBoxItem Text="Select Site" Value="" />
                                            </Items>
                                        </telerik:RadComboBox>

                                    </td>--%>
                                    <%--<td>
                                        <telerik:RadMaskedTextBox ID="TextBoxPhone" ClientEvents-OnBlur="OnBlurMasked" runat="server"
                                            CssClass="myfield" Mask="(###) ###-####" PromptChar=" " Width="100px">
                                        </telerik:RadMaskedTextBox>
                                    </td>--%>
                                    <td>
                                        <telerik:RadComboBox ID="RadComboBoxStatus" DataValueField="StatusTypeID" DataTextField="Description"
                                            OnClientSelectedIndexChanged="OnClientSelectedIndexChanged" DataSourceID="DataSourceStatus"
                                            runat="server" CssClass="mydropdown" SelectedValue='<%# Bind("StatusTypeID") %>'
                                            Width="97px">
                                        </telerik:RadComboBox>

                                    </td>
                                </tr>
                            </ItemTemplate>
                            <EmptyDataTemplate>
                                <p>
                                    No Youth found for selected Criteria
                                </p>
                            </EmptyDataTemplate>
                        </custom:CustomListView>
                    </auth:SecureContent>
                </div>
                <div class="BulkEditPager">
                    <asp:DataPager ID="DataPagerStudents" runat="server" PagedControlID="ListViewData"
                        PageSize="50">
                        <Fields>
                            <asp:TemplatePagerField>
                                <PagerTemplate>
                                    <table class="rgMasterTable">
                                        <tr class="rgPager">
                                            <td class="rgPagerCell NextPrevAndNumeric">
                                                <div class="rgWrap rgArrPart1">
                                </PagerTemplate>
                            </asp:TemplatePagerField>
                            <asp:NextPreviousPagerField ShowFirstPageButton="True" ButtonCssClass="CustomPagerButton rgPageFirst"
                                ButtonType="Link" FirstPageText="" ShowNextPageButton="False" ShowPreviousPageButton="false" />
                            <asp:NextPreviousPagerField ShowFirstPageButton="False" ButtonCssClass="CustomPagerButton rgPagePrev"
                                ButtonType="Link" PreviousPageText="" ShowNextPageButton="False" ShowPreviousPageButton="True" />
                            <asp:TemplatePagerField>
                                <PagerTemplate>
                                    </div>
                                    <div class="rgWrap rgNumPart">
                                </PagerTemplate>
                            </asp:TemplatePagerField>
                            <asp:NumericPagerField CurrentPageLabelCssClass="rgCurrentPage CustomNumButton" NumericButtonCssClass="CustomNumButton"
                                NextPreviousButtonCssClass="CustomNumButton PageSet" />
                            <asp:TemplatePagerField>
                                <PagerTemplate>
                                    </div>
                                    <div class="rgWrap rgArrPart2">
                                </PagerTemplate>
                            </asp:TemplatePagerField>
                            <asp:NextPreviousPagerField ShowFirstPageButton="False" ButtonCssClass="CustomPagerButton rgPageNext"
                                ButtonType="Link" NextPageText="" ShowNextPageButton="True" ShowPreviousPageButton="False" />
                            <asp:NextPreviousPagerField ShowLastPageButton="True" ButtonCssClass="CustomPagerButton rgPageLast"
                                ButtonType="Link" LastPageText="" ShowNextPageButton="False" ShowPreviousPageButton="False" />
                            <asp:TemplatePagerField>
                                <PagerTemplate>
                                    </div> </td> </tr> </table>
                                </PagerTemplate>
                            </asp:TemplatePagerField>
                        </Fields>
                    </asp:DataPager>
                </div>
                <div class="clear">
                </div>

                <div class="ReleaseInfoWrapper">
                    <label class="mylabel myeditdatepickerlabel">
                        <b>Step 3</b>: Select the youth release details.</label>
                </div>
                <div class="row">


                    <asp:Label ID="LabelReleaseDate" Font-Bold="true" runat="server" Text="Release Date:" CssClass="mylabel" Height="20px"></asp:Label>

                    <%--                <asp:RadioButtonList ID="RadioButtonListRiskAssessmentReferral" runat="server" DataTextField="Name"
                                     RepeatLayout="Table" RepeatDirection="Horizontal"
                                    RepeatColumns="5" onChange="enableReferralOtherValidation()">
                                    <asp:ListItem Value="1">End of grant year</asp:ListItem>
                                   

                                    
                                </asp:RadioButtonList>
            <asp:Label ID="Label1" Font-Bold="true"  runat="server" Text="or" Height="20px"></asp:Label>
                    --%>
                    <telerik:RadDatePicker ID="RadDatePickerReleaseDate" runat="server" DateInput-Width="50px"
                        DateInput-DisplayDateFormat="MM/dd/yy" Calendar-ShowRowHeaders="False"
                        Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup myenrollmentdob">
                    </telerik:RadDatePicker>
                    <asp:RequiredFieldValidator ID="reqValEnrollmentDate" runat="server" SetFocusOnError="true"
                        Display="Dynamic" ControlToValidate="RadDatePickerReleaseDate" ValidationGroup="SaveRelease"
                        CssClass="ErrorMessage" ErrorMessage="Release Date is required" Text="*"></asp:RequiredFieldValidator>

                </div>
                <br />
                <div class="row">

                    <asp:Label ID="LabelRelAgency" Font-Bold="true" runat="server" Text="Release Agency:" CssClass="mylabel" Height="20px"></asp:Label>
                    <asp:RadioButtonList ID="RadioButtonListReleaseAgency" runat="server" CssClass="ReleaseList"
                        RepeatLayout="Table" RepeatDirection="Vertical">
                        <asp:ListItem Value="Self or Family">Self or Family</asp:ListItem>
                        <asp:ListItem Value="School">School</asp:ListItem>
                        <asp:ListItem Value="DJJ">DJJ</asp:ListItem>
                        <asp:ListItem Value="Judiciary or State Attorney">Judiciary or State Attorney</asp:ListItem>
                        <asp:ListItem Value="Other Criminal Justice (not DJJ)">Other Criminal Justice (not DJJ)</asp:ListItem>
                        <asp:ListItem Value="Other Social Services">Other Social Services</asp:ListItem>
                        <asp:ListItem Value="Other">Other</asp:ListItem>
                    </asp:RadioButtonList>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" SetFocusOnError="true"
                        Display="Dynamic" ControlToValidate="RadioButtonListReleaseAgency" ValidationGroup="SaveRelease" InitialValue=""
                        CssClass="ErrorMessage" ErrorMessage="Release Agency is required" Text="*"></asp:RequiredFieldValidator>

                </div>
                <br />
                <div class="row">
                    <div class="">
                        <asp:Label ID="LabelRelReason" runat="server" Font-Bold="true" Text="Release Reason:" CssClass="mylabel" Height="20px"></asp:Label>
                        <asp:RadioButtonList ID="RadioButtonListRelReason" runat="server" CssClass="ReleaseList" RepeatLayout="Table"
                            RepeatDirection="Vertical">
                            <asp:ListItem Value="Completed: No referral made">Completed: No referral made</asp:ListItem>
                            <asp:ListItem Value="Completed: Referral made/Aftercare planned">Completed: Referral made/Aftercare planned</asp:ListItem>
                            <asp:ListItem Value="Completed: Youth removed by Protective Agency">Completed: Youth removed by Protective Agency</asp:ListItem>
                            <asp:ListItem Value="Incomplete: Youth was Expelled by Provider">Incomplete: Youth was Expelled by Provider</asp:ListItem>
                            <asp:ListItem Value="Incomplete: Youth moved">Incomplete: Youth moved</asp:ListItem>
                            <asp:ListItem Value="Incomplete: Youth ran away">Incomplete: Youth ran away</asp:ListItem>
                            <asp:ListItem Value="Incomplete: Youth withdrew from program/family withdrew youth from program">Incomplete: Youth withdrew from program/family withdrew youth from program</asp:ListItem>
                            <asp:ListItem Value="Incomplete: Other">Incomplete: Other</asp:ListItem>
                            <asp:ListItem Value="Youth changed schools-truancy resolution">Youth changed schools-truancy resolution</asp:ListItem>
                        </asp:RadioButtonList>

                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" SetFocusOnError="true"
                            Display="Dynamic" ControlToValidate="RadioButtonListRelReason" ValidationGroup="SaveRelease" InitialValue=""
                            CssClass="ErrorMessage" ErrorMessage="Release Reason is required" Text="*"></asp:RequiredFieldValidator>
                    </div>
                </div>
                <br />
                <auth:SecureContent ID="SecureContent1" ToggleVisible="true" ToggleEnabled="false"
                    EventHook="Load" runat="server" Roles="Administrators;">
                    <asp:Button ID="ButtonUpdate2" runat="server" Text="Update" OnClick="Update_Click"
                        CssClass="mybutton" />
                </auth:SecureContent>
            </div>
        </div>

        <%--<telerik:RadGrid RenderMode="Lightweight" ID="RadGrid1" Da OnNeedDataSource="RadGrid1_NeedDataSource"  AllowMultiRowSelection="true" Width="100%"
            runat="server" AllowSorting="True" GridLines="None" >
            <MasterTableView>
                <Columns>
                    <telerik:GridClientSelectColumn UniqueName="ClientSelectColumn">
                    </telerik:GridClientSelectColumn>
                </Columns>
            </MasterTableView>
            <ClientSettings EnableRowHoverStyle="true">
                <Selecting AllowRowSelect="True"></Selecting>
                <ClientEvents OnRowMouseOver="demo.RowMouseOver" />
            </ClientSettings>
        </telerik:RadGrid>--%>
    </div>
    <asp:EntityDataSource ID="DataSourceStatus" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" EnableFlattening="False" EntitySetName="StatusTypes"
        OrderBy="it.[Name]">
    </asp:EntityDataSource>
    <asp:EntityDataSource ID="DataSourceCounty" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" EnableFlattening="False" EntitySetName="Counties"
        OrderBy="it.[Name]">
    </asp:EntityDataSource>
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
