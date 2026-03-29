<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master"
    AutoEventWireup="true" CodeBehind="TechnicalSupport.aspx.cs" Inherits="POD.Pages.TechnicalSupport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <div class="tabcontainer widetabcontainer">
        <div class="tabcontent TechnicalSupportContainer">
        <h2>
            Technical Support</h2>
        <asp:Panel ID="PanelSupportRequest" runat="server" CssClass="UserEntryFormWrapper AdminStaffMemberForm">
            <p>
                For Technical Support please use the following methods to contact technical support.
                Please note the most efficient route to contact technical support is to submit a
                form with as much detail as possible.
            </p>
            <p>
                <asp:Literal ID="LiteralMessage" runat="server"></asp:Literal>
            </p>
            <div class="row">
                <asp:Label ID="Label1" runat="server" Text="Phone" class="mylabel"></asp:Label>
                1-800-CCC-TEST
            </div>
            <%--<div class="row">
                <asp:Label ID="Label2" runat="server" Text="Email" class="mylabel"></asp:Label>
                <a href="#" target="_blank">supportemail</a>
            </div>--%>
            <div class="row">
                <h3 class="sectionHead">
                    University Area Community Development, Inc</h3>
            </div>
            <div class="row">
                <asp:Label ID="Label4" runat="server" Text="Category" class="mylabel"></asp:Label>
                <asp:DropDownList ID="DropDownListCategory" runat="server" DataTextField="CategoryName">
                    <asp:ListItem Text="General Question" Value="1"></asp:ListItem>
                    <asp:ListItem Text="Technical Issue" Value="2"></asp:ListItem>
                    <asp:ListItem Text="Request" Value="3"></asp:ListItem>
                    
                </asp:DropDownList>
            </div>
            <%--<div class="row">
                <asp:Label ID="Label3" runat="server" Text="From Email:" class="mylabel mytextarealabel"></asp:Label>
                <asp:TextBox runat="server" ID="fromEmailAddress" Width="150px" CssClass="CommentBox"
                    TextMode="SingleLine" ></asp:TextBox>
                <asp:RequiredFieldValidator ID="fromEmailValidator" runat="server" ControlToValidate="fromEmailAddress"
                    ErrorMessage="Required">
                </asp:RequiredFieldValidator>
            </div>--%>
            <div class="row">
                <asp:Label ID="Label5" runat="server" Text="Comments" class="mylabel mytextarealabel"></asp:Label>
                <asp:TextBox runat="server" ID="TextBoxSupportComment" Width="500px" Height="250px" CssClass="CommentBox"
                    TextMode="MultiLine" Rows="6"></asp:TextBox>
                <asp:RequiredFieldValidator ID="reqValText" runat="server" ControlToValidate="TextBoxSupportComment"
                    ErrorMessage="Required">
                </asp:RequiredFieldValidator>
            </div>


    <div class="editButtons">
                
        <asp:Button ID="ButtonRequest" CssClass="mybutton" Text="Submit" UseSubmitBehavior="true"
            runat="server" OnClick="ButtonRequest_Click" />
        <asp:Button ID="ButtonCancel" CssClass="mybutton" Text="Cancel" UseSubmitBehavior="false"
            CausesValidation="false" runat="server" OnClick="ButtonCancel_Click" />
    </div>

    </asp:Panel>

            </div>
    </div>
</asp:Content>
