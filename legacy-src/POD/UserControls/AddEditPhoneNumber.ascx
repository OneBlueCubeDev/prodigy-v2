<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddEditPhoneNumber.ascx.cs"
    Inherits="POD.UserControls.AddEditPhoneNumber" %>

    <div class="addphone">
        <asp:Label ID="LabelPhone" runat="server" CssClass="mylabel"></asp:Label>
        <telerik:RadMaskedTextBox ID="TextBoxPhone" runat="server" CssClass="myfield" Mask="(###) ###-####"
            PromptChar=" ">
        </telerik:RadMaskedTextBox>
        <asp:RequiredFieldValidator ID="reqValPhone" runat="server" SetFocusOnError="true"
            Display="Dynamic" ControlToValidate="TextBoxPhone" CssClass="ErrorMessage RegAddFormError" ErrorMessage="Phone is required"
            Text="* Required"></asp:RequiredFieldValidator>
    </div>

