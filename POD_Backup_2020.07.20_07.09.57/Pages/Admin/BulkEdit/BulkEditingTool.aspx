<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master"
    AutoEventWireup="true" CodeBehind="BulkEditingTool.aspx.cs" Inherits="POD.Pages.Admin.BulkEdit.BulkEditingTool" %>

<%@ Register Src="../../../UserControls/BulkDataLinks.ascx" TagName="BulkDataLinks"
    TagPrefix="uc2" %>
<%@ Register Assembly="POD" Namespace="POD.Utillities" TagPrefix="custom" %>
<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
    <uc2:BulkDataLinks ID="BulkDataLinks1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server" EnableAJAX="true">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadcomboBoxFilter">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="ListViewData" LoadingPanelID="RadAjaxLoadingPanel1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="ListViewData">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="ListViewData" LoadingPanelID="RadAjaxLoadingPanel1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server" HorizontalAlign="Center">
        <img src="../../../App_Themes/Prodigy/Common/loading.gif" alt="Loading" style="border: none;
            margin-top: 0px;" />
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
                <h2>
                    Bulk Edit People</h2>
                <p>
                    Below are some filtering options for the data you can edit. To make it easier to
                    release students, we have the release date and agency you can fill in and each checked
                    student will get updated. As you page thru the data or filter or use the update
                    buttons all changes will be saved.
                </p>
                <div class="TopEditToolbar row">
                    <div class="ReleaseInfoWrapper">
                        <label class="mylabel myeditdatepickerlabel">
                            Release Date:</label>
                        <div class="myeditdatepicker">
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
                            Filter:</label>
                        <telerik:RadComboBox ID="RadcomboBoxFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="RadcomboBoxFilter_SelectedIndexChanged"
                            CssClass="mydropdown">
                            <Items>
                                <telerik:RadComboBoxItem Text="All Youth" Value="All" />
                                <telerik:RadComboBoxItem Text="Prevention Youth" Value="Prevention" />
                                <telerik:RadComboBoxItem Text="Intervention Youth" Value="Intervention" />
                                <telerik:RadComboBoxItem Text="Diversion Youth" Value="Diversion" />
                                <telerik:RadComboBoxItem Text="Youth No Attendance Past 90 days" Value="NoAttendance" />
                                <telerik:RadComboBoxItem Text="Youth in Classess With Grant Year Rollover" Value="GrantYearRollover" />
                            </Items>
                        </telerik:RadComboBox>
                        <div class="clear">
                        </div>
                    </div>
                </div>
                <div class="BulkEditContentWrapper">
                    <auth:SecureContent ID="SecureContent2" ToggleVisible="false" ToggleEnabled="true"
                        EventHook="Load" runat="server" Roles="Administrators;">
                        <custom:CustomListView ID="ListViewData" runat="server" OnItemDataBound="ListViewData_ItemDataBound"
                            OnItemUpdating="ListViewData_ItemUpdating" DataKeyNames="PersonID,EnrollmentID,EnrollmentTypeName,AddressID, HomePhoneID, CellPhoneID"
                            EnableViewState="true" OnPagePropertiesChanging="ListViewData_PagePropertiesChanging"
                            OnItemUpdated="ListViewData_ItemUpdated">
                            <LayoutTemplate>
                                <table class="datasheet datatable excel2007 BulkEditTable" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <th>
                                            Release?
                                        </th>
                                        <th>
                                            DJJ ID #
                                        </th>
                                        <th>
                                            First Name
                                        </th>
                                        <th>
                                            Middle
                                        </th>
                                        <th>
                                            Last Name
                                        </th>
                                        <th>
                                            Date of Birth
                                        </th>
                                        <th>
                                            Address
                                        </th>
                                        <th>
                                            City
                                        </th>
                                        <th>
                                            Zip Code
                                        </th>
                                        <th>
                                            County
                                        </th>
                                        <th>
                                            Home Phone
                                        </th>
                                        <th>
                                            Status
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
                                        <asp:TextBox ID="TextBox" runat="server" CssClass="DirtyFlag" Style="display: none;"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="TextBoxDJJID" onBlur="SetDirtyFlag(this);" runat="server" Text='<%# Bind("DJJIDNum") %>'
                                            CssClass="myfield" Width="80px"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtFirstName" runat="server" onBlur="SetDirtyFlag(this);" Text='<%# Bind("FirstName") %>'
                                            CssClass="myfield" Width="100px"></asp:TextBox>
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
                                        <telerik:RadMaskedTextBox ID="TextBoxZip" onBlur="SetDirtyFlag(this);" runat="server"
                                            Width="50px" Mask="#####" CssClass="myfield">
                                        </telerik:RadMaskedTextBox>
                                    </td>
                                    <td>
                                        <telerik:RadComboBox ID="RadComboBoxCounty" runat="server" EnableEmbeddedSkins="false"
                                            DataSourceID="DataSourceCounty" DataTextField="Name" DataValueField="CountyID"
                                            OnClientSelectedIndexChanged="OnClientSelectedIndexChanged" SkinID="Prodigy"
                                            CssClass="mydropdown" Height="100%" Width="142px">
                                            <Items>
                                                <telerik:RadComboBoxItem Text="Select County" Value="" />
                                            </Items>
                                        </telerik:RadComboBox>
                                    </td>
                                    <td>
                                        <telerik:RadMaskedTextBox ID="TextBoxPhone" ClientEvents-OnBlur="OnBlurMasked" runat="server"
                                            CssClass="myfield" Mask="(###) ###-####" PromptChar=" " Width="100px">
                                        </telerik:RadMaskedTextBox>
                                    </td>
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
                                    No Youth found for selected Criteria</p>
                            </EmptyDataTemplate>
                        </custom:CustomListView>
                    </auth:SecureContent>
                </div>
                <div class="BulkEditPager">
                    <asp:DataPager ID="DataPagerStudents" runat="server" PagedControlID="ListViewData"
                        PageSize="20">
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
                <auth:SecureContent ID="SecureContent1" ToggleVisible="true" ToggleEnabled="false"
                    EventHook="Load" runat="server" Roles="Administrators;">
                    <asp:Button ID="ButtonUpdate2" runat="server" Text="Update" OnClick="Update_Click"
                        CssClass="mybutton" /></auth:SecureContent>
            </div>
        </div>
    </div>
    <asp:EntityDataSource ID="DataSourceStatus" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" EnableFlattening="False" EntitySetName="StatusTypes"
        OrderBy="it.[Name]">
    </asp:EntityDataSource>
    <asp:EntityDataSource ID="DataSourceCounty" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" EnableFlattening="False" EntitySetName="Counties"
        OrderBy="it.[Name]">
    </asp:EntityDataSource>
    <asp:EntityDataSource ID="DataSourcePerson" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" EnableFlattening="False" EntitySetName="Persons"
        EnableUpdate="True" OrderBy="it.[LastName]" EntityTypeFilter="Student">
    </asp:EntityDataSource>
</asp:Content>
