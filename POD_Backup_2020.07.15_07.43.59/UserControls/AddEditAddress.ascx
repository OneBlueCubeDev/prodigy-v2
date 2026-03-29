<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddEditAddress.ascx.cs"
    Inherits="POD.UserControls.AddEditAddress" %>
<div class="AddressWrapper">
    <div class="row">
        <div class="myenrollmentaddress">
            <asp:Label ID="LabelAddress" runat="server" Text=" Address" CssClass="mylabel"></asp:Label>
            <asp:TextBox ID="TextBoxAddress" runat="server" CssClass="myfield"></asp:TextBox>
            <asp:RequiredFieldValidator ID="reqValStreet" runat="server" SetFocusOnError="true"
                Display="Dynamic" ControlToValidate="TextBoxAddress" CssClass="ErrorMessage"
                ErrorMessage="Address is required" Text="* Required"></asp:RequiredFieldValidator>
        </div>
        <asp:Panel ID="PanelAptNum" runat="server" CssClass="myenrollmentaptnum">
            <asp:Label ID="LabelAptNum" runat="server" Text="Apt #" CssClass="mylabel"></asp:Label>
            <asp:TextBox ID="TextBoxAptNum" runat="server" CssClass="myfield"></asp:TextBox>
        </asp:Panel>
    </div>
    <asp:Panel ID="PanelStreet2" runat="server" CssClass="row">
        <div class="myenrollmentaddress2">
            <asp:Label ID="LabelAddress2" runat="server" Text="Address 2" CssClass="mylabel"></asp:Label>
            <asp:TextBox ID="TextBoxAddress2" runat="server" CssClass="myfield"></asp:TextBox>
        </div>
    </asp:Panel>
    <div class="row">
        <div class="myenrollmentcity myenrollmentphysiciancity">
            <asp:Label ID="LabelCity" runat="server" Text="City" CssClass="mylabel"></asp:Label>
            <asp:TextBox ID="TextBoxCity" runat="server" CssClass="myfield"></asp:TextBox>
            <asp:RequiredFieldValidator ID="reqValCity" runat="server" SetFocusOnError="true"
                Display="Dynamic" ControlToValidate="TextBoxCity" CssClass="ErrorMessage" ErrorMessage="City is required"
                Text="* Required"></asp:RequiredFieldValidator>
        </div>
    </div>
    <div class="row">
        <div class="myenrollmentstate myenrollmentphysicianstate">
            <asp:Label ID="LabelState" runat="server" Text="State" CssClass="mylabel"></asp:Label>
            <telerik:RadComboBox ID="RadComboBoxState" runat="server" EnableEmbeddedSkins="false"
                SkinID="Prodigy" CssClass="mydropdown" Height="100%" Width="142px">
                <Items>
                    <telerik:RadComboBoxItem Text="Florida" Value="FL" />
                </Items>
            </telerik:RadComboBox>
        </div>
    </div>
    <asp:Panel ID="PanelCounty" runat="server" CssClass="row">
        <div class="myenrollmentcounty myenrollmentphysiciancounty">
            <asp:Label ID="LabelCounty" runat="server" Text="County" CssClass="mylabel"></asp:Label>
            <telerik:RadComboBox ID="RadComboBoxCounty" DataTextField="Name" DataValueField="CountyID"
                runat="server" EnableEmbeddedSkins="false" SkinID="Prodigy" CssClass="mydropdown"
                Height="100%" Width="142px">
            </telerik:RadComboBox>
        </div>
    </asp:Panel>
    <div class="row">
        <div class="myenrollmentzip myenrollmentphysicianzip">
            <asp:Label ID="LabelZip" runat="server" Text="Zip Code" CssClass="mylabel"></asp:Label>
            <telerik:RadMaskedTextBox ID="TextBoxZip" runat="server" CssClass="myfield" Mask="#####" PromptChar=""
                Width="60px">
            </telerik:RadMaskedTextBox>
            <asp:RequiredFieldValidator ID="reqValZip" runat="server" SetFocusOnError="true"
                Display="Dynamic" ControlToValidate="TextBoxZip" CssClass="ErrorMessage" ErrorMessage="Zip is required"
                Text="* Required"></asp:RequiredFieldValidator>
        </div>
    </div>
</div>
