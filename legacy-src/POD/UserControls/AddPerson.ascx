<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddPerson.ascx.cs" Inherits="POD.UserControls.AddPerson" %>
<telerik:RadCodeBlock ID="RadCodeBlock" runat="server">
    <script type="text/javascript" language="javascript">
        function GetRadWindow() {
            var oWindow = null;
            if (window.radWindow)
                oWindow = window.radWindow;
            else if (window.frameElement.radWindow)
                oWindow = window.frameElement.radWindow;
            return oWindow;
        }

        function returnToParent(id) {
            //get parent window
            var oWnd = GetRadWindow();
            //Close the RadWindow and send the argument to the parent page
            oWnd.BrowserWindow.UpdateReturnToSave(id);
            oWnd.close();

        }

    </script>
</telerik:RadCodeBlock>
<div class="PersonWrapper myPopupWrapper">
    <asp:Panel ID="PanelNewPerson" CssClass="AddNewPersonPopupUp" runat="server">
        <div class="row">
            <asp:Label ID="LabelStatusType" runat="server" Text="Status" CssClass="mylabel myyouthtype"></asp:Label>
            <telerik:RadComboBox ID="RadComboBoxStatus" DataValueField="StatusTypeID" DataTextField="Name"
                runat="server" CssClass="mydropdown" EnableEmbeddedSkins="false" SkinID="Prodigy">
            </telerik:RadComboBox>
             <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" SetFocusOnError="true"
                    Display="Dynamic" InitialValue="" ControlToValidate="RadComboBoxStatus" CssClass="ErrorMessage"
                    ErrorMessage="Status is required" Text="*"></asp:RequiredFieldValidator>
        </div>
        <div class="row">
            <div class="myenrollmentlastname">
                <asp:Label ID="EnrollmentLastName" runat="server" Text="Last Name" CssClass="mylabel"></asp:Label>
                <asp:TextBox ID="EnrollmentLastNameTextBox" runat="server" CssClass="myfield"></asp:TextBox>
                <asp:RequiredFieldValidator ID="ReqValFirstNamePart" runat="server" SetFocusOnError="true"
                    Display="Dynamic" ControlToValidate="EnrollmentLastNameTextBox" CssClass="ErrorMessage"
                    ErrorMessage="Last Name is required." Text="*"></asp:RequiredFieldValidator>
            </div>
        </div>
        <div class="row">
            <div class="myenrollmentfirstname">
                <asp:Label ID="EnrollmentFirstName" runat="server" Text="First Name" CssClass="mylabel"></asp:Label>
                <asp:TextBox ID="EnrollmentFirstNameTextBox" runat="server" CssClass="myfield"></asp:TextBox>
                <asp:RequiredFieldValidator ID="ReqValLastNamePart" runat="server" SetFocusOnError="true"
                    ValidationGroup="Save" Display="Dynamic" ControlToValidate="EnrollmentFirstNameTextBox"
                    CssClass="ErrorMessage" ErrorMessage="First Name is required." Text="*"></asp:RequiredFieldValidator>
            </div>
            <div class="myenrollmentMI">
                <asp:Label ID="EnrollmentMI" runat="server" Text="MI" CssClass="mylabel"></asp:Label>
                <asp:TextBox ID="EnrollmentMITextBox" runat="server" CssClass="myfield"></asp:TextBox>
            </div>
        </div>
        <div class="row">
            <div class="myenrollmentdobcontainer">
                <asp:Label ID="EnrollmentDOB" runat="server" Text="DOB" CssClass="mylabel"></asp:Label>
                <telerik:RadDatePicker ID="RadDatePickerDOB" runat="server" DateInput-Width="50px"
                    Width="42%" DateInput-DisplayDateFormat="MM/dd/yy" Calendar-ShowRowHeaders="False"
                    Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup myenrollmentdob">
                </telerik:RadDatePicker>
                <asp:RequiredFieldValidator ID="ReqValDOBPart" runat="server" SetFocusOnError="true"
                    Display="Dynamic" ControlToValidate="RadDatePickerDOB" CssClass="ErrorMessage"
                    ErrorMessage="Participant's Date of Birth is required." Text="*"></asp:RequiredFieldValidator>
            </div>
        </div>
        <div class="row">
            <asp:Label ID="EnrollmentParent1Email" runat="server" Text="Email Address" CssClass="mylabel"></asp:Label>
            <asp:TextBox ID="EmailTextBox" runat="server" CssClass="myfield"></asp:TextBox>
            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="EmailTextBox"
                Display="Dynamic" CssClass="ErrorMessage" ErrorMessage="Email address is not valid"
                ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
        </div>
        <div class="row">
            <asp:Button ID="ButtonAdd" runat="server" Text="Add Person" OnClick="ButtonAdd_Click" class="mybutton"/>
        </div>
    </asp:Panel>
    <asp:Panel ID="PanelMatches" runat="server" Visible="false" CssClass="PossibleMatchesInlineWrapper">
        <div class="row">
        <br />
        <h3>
            Possible Matches of Students in the System</h3>
        <p>
            Please review the following matches of youth in the system. If you are updating
            data for any of the below, please select that youth. Or Select "none of the above"
            to create a new record.
        </p>
        </div>
        <asp:Literal ID="literalCloseWindow" runat="server"></asp:Literal>
        <asp:DataList ID="DataListPersonMatches" DataKeyField="PersonID" runat="server" CssClass="PossibleMatchesTable">
            
            <ItemTemplate>
                <a href="#" class="mybutton mySelectButton" onclick='<%# "returnToParent(" + Eval("PersonID") + ");" %>'>Select</a></td>
                <td><span>Name:</span></td><td class="Name"><%# Eval("FullName") %>&nbsp;&nbsp;</td>
                <td class="DOBLabel"><span>Date of Birth:</span></td><td class="DOB"><%# (Eval("DateOfBirth") != null && Eval("DateOfBirth") is DateTime) ? DateTime.Parse(Eval("DateOfBirth").ToString()).ToString("MM/dd/yyyy"): "N/A" %>&nbsp;&nbsp;</td><td class="GenderLabel"><span>Gender:</span></td><td class="Gender"><%# Eval("Gender.Name") !=""? Eval("Gender.Name"): "N/A" %></td></tr>
                <tr class="LastRow"><td></td><td class="AgeLabel"><span>Age (at enrollment time):</span></td><td class="Age"><%# Eval("Age") != "" ? Eval("Age") : "N/A"%> </td>
                <td class="DJJNumLabel"><span>DJJ#:</span></td><td class="DJJNum"><%# Eval("DJJIDNum") != "" ? Eval("DJJIDNum") : "N/A"%>
                 
            </ItemTemplate>
            <FooterTemplate>
                
                    <asp:LinkButton class="mybutton mySelectButton" ID="ButtonNew" runat="server" Text="Select" OnClick="ButtonNew_Click" /></td><td>
                    <span class="SelectNone">None of the above</span>
                
            </FooterTemplate>
        </asp:DataList>

    </asp:Panel>
</div>
