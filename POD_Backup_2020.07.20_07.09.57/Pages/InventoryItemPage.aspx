<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/Admin.Master"
    AutoEventWireup="true" CodeBehind="InventoryItemPage.aspx.cs" Inherits="POD.Pages.InventoryItemPage" %>

<%@ Register Src="../UserControls/InventoryLinks.ascx" TagName="InventoryLinks" TagPrefix="uc2" %>
<%@ Register TagPrefix="auth" Namespace="POD.UserControls.Shared" Assembly="POD" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceholderHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
    <uc2:InventoryLinks ID="InventoryLinks1" runat="server" />
    <telerik:RadAjaxManagerProxy ID="RadAjaxManager1" runat="server">
        <AjaxSettings>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="DashBoardContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="SidebarContentPlaceholder" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <div class="tabcontainer">
        <div class="tabcontent">
            <auth:SecureContent ID="SecureContent3" ToggleVisible="false" ToggleEnabled="true"
                EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
                <div class="InventoryItemWrapper">
                    <h2>
                        <asp:Literal ID="LiteralHeader" runat="Server"></asp:Literal></h2>
                    <span class="ErrorMessage">
                        <asp:Literal ID="LiteralError" runat="server"></asp:Literal></span>
                    <div class="row">
                        <asp:Label ID="LabelName" runat="server" Text="Name" CssClass="mylabel"></asp:Label>
                        <asp:TextBox ID="TextBoxName" runat="server" CssClass="myfield"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="CustomValidator1" runat="server" ErrorMessage="Name is required"
                            CssClass="ErrorMessage" Display="Dynamic" ValidationGroup="Save" ControlToValidate="TextBoxName"></asp:RequiredFieldValidator>
                    </div>
                    <div class="row">
                        <asp:Label ID="Label1" runat="server" Text="Description" CssClass="mylabel"></asp:Label>
                        <asp:TextBox ID="TextBoxDesc" runat="server" CssClass="myfield"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Description is required"
                            CssClass="ErrorMessage" Display="Dynamic" ValidationGroup="Save" ControlToValidate="TextBoxDesc"></asp:RequiredFieldValidator>
                    </div>
                    <div class="row">
                        <asp:Label ID="Label2" runat="server" Text="Manufacturer" CssClass="mylabel"></asp:Label>
                        <asp:TextBox ID="TextBoxManufacturer" runat="server" CssClass="myfield"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Manufacturer is required"
                            CssClass="ErrorMessage" Display="Dynamic" ValidationGroup="Save" ControlToValidate="TextBoxManufacturer"></asp:RequiredFieldValidator>
                    </div>
                    <div class="row">
                        <asp:Label ID="Label3" runat="server" Text="Model" CssClass="mylabel"></asp:Label>
                        <asp:TextBox ID="TextBoxModel" runat="server" CssClass="myfield"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="Model is required"
                            CssClass="ErrorMessage" Display="Dynamic" ValidationGroup="Save" ControlToValidate="TextBoxModel"></asp:RequiredFieldValidator>
                    </div>
                    <div class="row">
                        <asp:Label ID="Label4" runat="server" Text="Serial #" CssClass="mylabel"></asp:Label>
                        <asp:TextBox ID="TextBoxSerialNum" runat="server" CssClass="myfield"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="Serial Number is required"
                            CssClass="ErrorMessage" Display="Dynamic" ValidationGroup="Save" ControlToValidate="TextBoxSerialNum"></asp:RequiredFieldValidator>
                    </div>
                    <div class="row">
                        <asp:Label ID="Label5" runat="server" Text="Acquisition Cost" CssClass="mylabel"></asp:Label>
                        <telerik:RadNumericTextBox ID="TextBoxAcquisition" runat="server" Type="Currency"
                            WrapperCssClass="myenrollmentagebox" NumberFormat-DecimalDigits="2" EnableEmbeddedSkins="false"
                            Skin="Prodigy" Width="157px">
                        </telerik:RadNumericTextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="Acquisition Cost is required"
                            CssClass="ErrorMessage" Display="Dynamic" ValidationGroup="Save" ControlToValidate="TextBoxAcquisition"></asp:RequiredFieldValidator>
                    </div>
                    <div class="row myenrollmentdobcontainer">
                        <asp:Label ID="Label6" runat="server" Text="Acquisition Date" CssClass="mylabel"></asp:Label>
                        <telerik:RadDatePicker ID="AcquisitionDatePicker" runat="server" DateInput-Width="50px"
                            Width="42%" DateInput-DisplayDateFormat="MM/dd/yy" Calendar-ShowRowHeaders="False"
                            Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup myenrollmentdob">
                        </telerik:RadDatePicker>
                    </div>
                    <div class="row">
                        <asp:Label ID="Label7" runat="server" Text="Organization" CssClass="mylabel"></asp:Label>
                        <asp:TextBox ID="TextBoxOrganization" runat="server" CssClass="myfield"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ErrorMessage="Organization is required"
                            CssClass="ErrorMessage" Display="Dynamic" ValidationGroup="Save" ControlToValidate="TextBoxOrganization"></asp:RequiredFieldValidator>
                    </div>
                    <div class="row">
                        <asp:Label ID="Label8" runat="server" Text="UACDC Tag" CssClass="mylabel"></asp:Label>
                        <asp:TextBox ID="TextBoxUACDCTagNum" runat="server" CssClass="myfield"></asp:TextBox>
                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ErrorMessage="UACDC Tag # is required"
                            CssClass="ErrorMessage" Display="Dynamic" ValidationGroup="Save" ControlToValidate="TextBoxUACDCTagNum"></asp:RequiredFieldValidator>--%>
                    </div>
                    <div class="row">
                        <asp:Label ID="Label9" runat="server" Text="DJJ Tag" CssClass="mylabel"></asp:Label>
                        <asp:TextBox ID="TextBoxDJJTagNum" runat="server" CssClass="myfield"></asp:TextBox>
                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ErrorMessage="DJJ Tag is required"
                            CssClass="ErrorMessage" Display="Dynamic" ValidationGroup="Save" ControlToValidate="TextBoxDJJTagNum"></asp:RequiredFieldValidator>--%>
                    </div>
                    <div class="row">
                        <asp:Label ID="Label10" runat="server" Text="Condition" CssClass="mylabel"></asp:Label>
                        <telerik:RadComboBox ID="RadComboBoxConditions" EmptyMessage="Select Condtion" runat="server"
                            EnableEmbeddedSkins="false" SkinID="Prodigy" CssClass="mydropdown">
                            <Items>
                                <telerik:RadComboBoxItem Text="(E) Excellent" Value="Excellent" />
                                <telerik:RadComboBoxItem Text="(G) Good" Value="Good" />
                                <telerik:RadComboBoxItem Text="(F) Fair" Value="Fair" />
                                <telerik:RadComboBoxItem Text="(P) Poor" Value="Poor" />
                                <telerik:RadComboBoxItem Text="(S) Scrap" Value="Scrap" />
                            </Items>
                        </telerik:RadComboBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" ErrorMessage="Condition is required"
                            CssClass="ErrorMessage" Display="Dynamic" ValidationGroup="Save" InitialValue=""
                            ControlToValidate="RadComboBoxConditions"></asp:RequiredFieldValidator>
                    </div>
                    <div class="row CommentsWrapper">
                        <asp:Label ID="Label11" runat="server" Text="Comments" CssClass="mylabel"></asp:Label>
                        <asp:TextBox ID="TextBoxComments" runat="server" CssClass="myfield" Height="100px"
                            Width="350px" Rows="100" Columns="300" TextMode="MultiLine"></asp:TextBox>
                    </div>
                    <div class="clear">
                    </div>
                    <div class="row">
                        <asp:Label ID="LabelLocation" runat="server" Text="Location" CssClass="mylabel"></asp:Label>
                        <telerik:RadComboBox ID="RadComboBoxLocation" 
                            DataValueField="LocationID" DataTextField="Name" EmptyMessage="Select Location"
                            runat="server" EnableEmbeddedSkins="false" SkinID="Prodigy" CssClass="mydropdown">
                        </telerik:RadComboBox>
                        <asp:RequiredFieldValidator ID="reqValLoc" runat="server" ControlToValidate="RadComboBoxLocation"
                            InitialValue="" ErrorMessage="Location is required" Display="Dynamic" ValidationGroup="Save"></asp:RequiredFieldValidator>
                    </div>
                    <%--<div class="row">
                        <asp:Label ID="Label12" runat="server" Text="Type" CssClass="mylabel"></asp:Label>
                        <telerik:RadComboBox ID="RadComboBoxTypes" DataSourceID="DataSourceInventoryTypes"
                            DataValueField="InventoryItemTypeID" DataTextField="Name" EmptyMessage="Select Type"
                            runat="server" EnableEmbeddedSkins="false" SkinID="Prodigy" CssClass="mydropdown">
                        </telerik:RadComboBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="RadComboBoxLocation"
                            InitialValue="" ErrorMessage="Location is required" Display="Dynamic" ValidationGroup="Save"></asp:RequiredFieldValidator>
                    </div>--%>
                </div>
            </auth:SecureContent>
        </div>
    </div>
    <%--<asp:EntityDataSource ID="DataSourceLocations" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" EnableFlattening="False" EntitySetName="Locations"
        OrderBy="it.[Name]">
    </asp:EntityDataSource>--%>
    <%--<asp:EntityDataSource ID="DataSourceInventoryTypes" runat="server" ConnectionString="name=PODContext"
        DefaultContainerName="PODContext" EnableFlattening="False" EntitySetName="InventoryItemTypes"
        OrderBy="it.[Name]">
    </asp:EntityDataSource>--%>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="EditButtonsPlaceholder" runat="server">
    <div class="editButtons">
        <auth:SecureContent ID="SecureContent1" ToggleVisible="true" ToggleEnabled="false"
            EventHook="Load" runat="server" Roles="Administrators;CentralTeamUsers;SiteTeamUsers;">
            <asp:Button ID="DeleteButton" runat="server" CausesValidation="false" OnClick="DeleteButton_Click"
                OnClientClick="return confirm('Are you sure you want to delete this inventory item?');"
                Text="Delete" class="mybutton mydelete" />
            <asp:Button ID="SaveButton" runat="server" ValidationGroup="Save" OnClick="SaveButton_Click"
                Text="Save" class="mybutton mysave" /></auth:SecureContent>
    </div>
</asp:Content>
