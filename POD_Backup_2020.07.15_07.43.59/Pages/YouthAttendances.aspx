<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/Admin.Master"
    AutoEventWireup="true" CodeBehind="YouthAttendances.aspx.cs" Inherits="POD.Pages.EventAttendances" %>

<%@ Register Src="../UserControls/EnrollmentLinks.ascx" TagName="EnrollmentLinks" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceholderHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
    <uc2:EnrollmentLinks ID="EnrollmentLinks1" runat="server" />
    <telerik:RadAjaxManagerProxy ID="RadAjaxManager1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGridAttendance">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridAttendance" LoadingPanelID="RadAjaxLoadingPanel1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="DashBoardContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="SidebarContentPlaceholder" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <telerik:RadCodeBlock runat="server" ID="RadCodeBlock1">
        <script type="text/javascript">
        </script>
    </telerik:RadCodeBlock>
    <div class="tabcontainer">
        <div class="tabcontent">
            <div class="EventAttendances">
                <h2>
                    <asp:Literal ID="LiteralHeader" runat="Server"></asp:Literal></h2>
                <p>
                </p>
            </div>
            <telerik:RadGrid ID="RadGriAttendances" runat="server" AutoGenerateColumns="false"
                OnNeedDataSource="RadGriAttendances_NeedDataSource" AllowPaging="True" AllowSorting="true"
                AllowFilteringByColumn="false" GroupingSettings-CaseSensitive="false" PageSize="25"
                Width="100%" EnableEmbeddedSkins="false" Skin="Prodigy" HorizontalAlign="Center">
                <MasterTableView TableLayout="Auto" ClientDataKeyNames="PersonID, RecordID, RecordType"
                    DataKeyNames="PersonID, RecordID, RecordType">
                    <Columns>
                        <telerik:GridBoundColumn DataField="ClassName" FilterControlWidth="85%" SortExpression="ClassName"
                            HeaderText="Class/Event">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="SiteLocationName" HeaderText="Site" SortExpression="SiteLocationName">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="LocationName" HeaderText="Location" SortExpression="LocationName">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="AttendanceDate" FilterControlWidth="85%" AutoPostBackOnFilter="true"
                            ShowFilterIcon="false" SortExpression="AttendanceDate" HeaderText="Attendance Date" DataFormatString="{0:d}">
                        </telerik:GridBoundColumn>
                        <telerik:GridTemplateColumn SortExpression="LeftEarly" HeaderText="Left Early?" HeaderStyle-HorizontalAlign="Center"
                            ItemStyle-HorizontalAlign="Center" ItemStyle-Width="45px" HeaderStyle-Width="45px">
                            <ItemTemplate>
                                <asp:Label ID="LabelLeftearly" runat="server" Text='<%# Eval("LeftEarly")!=null && Eval("LeftEarly").ToString() == "True"? "Yes":"No" %>'></asp:Label>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn SortExpression="Tardy" HeaderText="Tardy?" HeaderStyle-HorizontalAlign="Center"
                            ItemStyle-HorizontalAlign="Center" ItemStyle-Width="45px" HeaderStyle-Width="45px">
                            <ItemTemplate>
                                <asp:Label ID="LabelTardy" runat="server" Text='<%#  Eval("Tardy")!=null && Eval("Tardy").ToString() == "True"? "Yes":"No" %>'></asp:Label>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
                    </Columns>
                    <NoRecordsTemplate>
                        <p>
                            If you filtered please widen your search.
                        </p>
                    </NoRecordsTemplate>
                </MasterTableView>
            </telerik:RadGrid>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="EditButtonsPlaceholder" runat="server">
</asp:Content>
