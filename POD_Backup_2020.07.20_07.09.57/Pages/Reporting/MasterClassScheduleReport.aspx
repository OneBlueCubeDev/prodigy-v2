<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master"
    AutoEventWireup="true" CodeBehind="MasterClassScheduleReport.aspx.cs" Inherits="POD.Pages.Reporting.MasterClassScheduleReport" %>

<%@ Register TagPrefix="uc" TagName="ReportViewport" Src="~/UserControls/ReportViewport.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <div class="tabcontainer widetabcontainer">
        <div class="tabcontent">
            <div class="RunReportContainer MasterClassReport">
                <h2>
                    Master Class Schedule Report</h2>

                 <div class="myreporttargetdatecontainer">
                    <asp:Label ID="LabelFromDate" AssociatedControlID="DatePickerStartDate" runat="server">Start Date</asp:Label>
                    <telerik:RadDatePicker ID="DatePickerStartDate" runat="server" DateInput-DisplayDateFormat="MM/dd/yyyy"
                        DateInput-Width="50px" Width="44%" Calendar-ShowRowHeaders="False" Calendar-CssClass="myDatePickerPopup"
                        CssClass="myDatePickerPopup">
                    </telerik:RadDatePicker>
                </div>

                <div class="myreporttargetdatecontainer">
                    <asp:Label ID="LabelToDate" AssociatedControlID="DatePickerEndDate" runat="server">End Date</asp:Label>
                    <telerik:RadDatePicker ID="DatePickerEndDate" runat="server" DateInput-DisplayDateFormat="MM/dd/yyyy"
                        DateInput-Width="50px" Width="44%" Calendar-ShowRowHeaders="False" Calendar-CssClass="myDatePickerPopup"
                        CssClass="myDatePickerPopup">
                    </telerik:RadDatePicker>
                </div>

                <asp:CompareValidator ID="DateRangeCompareValidator" runat="server" ControlToCompare="DatePickerStartDate"
                    ControlToValidate="DatePickerEndDate" Type="Date" Operator="GreaterThanEqual"
                    ErrorMessage="The end date must be greater than the start date to run the report."
                    Display="None" ValidationGroup="ReportParameters">
                </asp:CompareValidator>

                <br /><br />

                <asp:Label ID="LabelDropDownSites" AssociatedControlID="DropDownSite" runat="server">Site</asp:Label>
                <telerik:RadComboBox ID="DropDownSite" runat="server" AppendDataBoundItems="True"
                    EnableEmbeddedSkins="false" SkinID="Prodigy" DataTextField="Value" DataValueField="Key"
                    CssClass="mydropdown">
                    <Items>
                        <telerik:RadComboBoxItem Text="All" Value="" />
                    </Items>
                </telerik:RadComboBox>

                 <%--<asp:Label ID="Label2" AssociatedControlID="DropDownProgrammingLocation" runat="server">Programming Location</asp:Label>
                <telerik:RadComboBox ID="DropDownProgrammingLocation" runat="server" AppendDataBoundItems="True"
                    EnableEmbeddedSkins="false" SkinID="Prodigy" DataTextField="Value" DataValueField="Key"
                    CssClass="mydropdown">
                    <Items>
                        <telerik:RadComboBoxItem Text="" Value="" />
                    </Items>
                </telerik:RadComboBox>--%>

                <br /><br />

                <asp:Label ID="Label3" AssociatedControlID="DropDownClassType" runat="server">Class Type</asp:Label>
                <telerik:RadComboBox ID="DropDownClassType" runat="server" AppendDataBoundItems="True"
                    EnableEmbeddedSkins="false" SkinID="Prodigy" DataTextField="Value" DataValueField="Key"
                    CssClass="mydropdown">
                    <Items>
                        <telerik:RadComboBoxItem Text="" Value="" />
                    </Items>
                </telerik:RadComboBox>

                <asp:Label ID="Label4" AssociatedControlID="DropDownClassName" runat="server">Class Name</asp:Label>
                <telerik:RadComboBox ID="DropDownClassName" runat="server" AppendDataBoundItems="True"
                    EnableEmbeddedSkins="false" SkinID="Prodigy" DataTextField="Value" DataValueField="Key"
                    CssClass="mydropdown">
                    <Items>
                        <telerik:RadComboBoxItem Text="" Value="" />
                    </Items>
                </telerik:RadComboBox>

                <asp:Label ID="Label7" AssociatedControlID="DropDownInstructor" runat="server">Instructor's Name</asp:Label>
                <telerik:RadComboBox ID="DropDownInstructor" runat="server" AppendDataBoundItems="True"
                    EnableEmbeddedSkins="false" SkinID="Prodigy" DataTextField="Value" DataValueField="Key"
                    CssClass="mydropdown">
                    <Items>
                        <telerik:RadComboBoxItem Text="" Value="" />
                    </Items>
                </telerik:RadComboBox>

                <br /><br />

                <asp:Label ID="Label1" AssociatedControlID="DropDownClassDays" runat="server">Class Days</asp:Label>
                <telerik:RadComboBox ID="DropDownClassDays" runat="server" AppendDataBoundItems="True"
                    EnableEmbeddedSkins="false" SkinID="Prodigy" DataTextField="Value" DataValueField="Key"
                    CssClass="mydropdown" CheckBoxes="True">
                    <Items>
                        <telerik:RadComboBoxItem Text="Sunday" Value="1" />
                        <telerik:RadComboBoxItem Text="Monday" Value="2" />
                        <telerik:RadComboBoxItem Text="Tuesday" Value="3" />
                        <telerik:RadComboBoxItem Text="Wednesday" Value="4" />
                        <telerik:RadComboBoxItem Text="Thursday" Value="5" />
                        <telerik:RadComboBoxItem Text="Friday" Value="6" />
                        <telerik:RadComboBoxItem Text="Saturday" Value="7" />
                    </Items>
                </telerik:RadComboBox>
                
                <asp:Label ID="Label6" AssociatedControlID="DropDownTime" runat="server">Time</asp:Label>
                <telerik:RadComboBox ID="DropDownTime" runat="server" AppendDataBoundItems="True"
                    EnableEmbeddedSkins="false" SkinID="Prodigy" DataTextField="Value" DataValueField="Key"
                    CssClass="mydropdown">
                    <Items>
                        <telerik:RadComboBoxItem Text="" Value="" />
                    </Items>
                </telerik:RadComboBox>

                <asp:Label ID="Label5" AssociatedControlID="DropDownAge" runat="server">Age</asp:Label>
                <telerik:RadComboBox ID="DropDownAge" runat="server" AppendDataBoundItems="True"
                    EnableEmbeddedSkins="false" SkinID="Prodigy" DataTextField="Value" DataValueField="Key"
                    CssClass="mydropdown">
                    <Items>
                        <telerik:RadComboBoxItem Text="" Value="" />
                    </Items>
                </telerik:RadComboBox>

                <asp:Button ID="ButtonExecuteReport" runat="server" OnClick="ButtonExecuteReport_OnClick"
                    Text="Run Report" CssClass="mybutton myaddbutton" CausesValidation="True" ValidationGroup="ReportParameters" />
            </div>
            <asp:ValidationSummary ID="ValidationSummary" runat="server" ValidationGroup="ReportParameters"
                DisplayMode="List" />
            <uc:ReportViewport ID="ReportViewport" runat="server" ReportName="MasterClassScheduleReport" />
        </div>
    </div>
</asp:Content>
