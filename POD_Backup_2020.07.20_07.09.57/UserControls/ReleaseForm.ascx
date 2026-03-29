<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ReleaseForm.ascx.cs" Inherits="POD.UserControls.ReleaseForm" %>
 
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
            function returnToParent() {

                //get parent window
                var oWnd = GetRadWindow();
                //Close the RadWindow and send the argument to the parent page
                oWnd.close();

            }
        </script>
    </telerik:RadCodeBlock>
    <asp:Literal ID="LiteralErrorMsg" runat="server"></asp:Literal>
    <div class="ReleaseWrapper myPopupWrapper">
        <div class="row">
            <h3>
                Release Info</h3>
            <div class="myenrollmentdobcontainer">
                <asp:Label ID="LabelReleaseDate" runat="server" Text="Release Date" CssClass="mylabel"></asp:Label>
                <telerik:RadDatePicker ID="RadDatePickerReleaseDate" runat="server" DateInput-Width="50px"
                    Width="52%" DateInput-DisplayDateFormat="MM/dd/yy" Calendar-ShowRowHeaders="False"
                    Calendar-CssClass="myDatePickerPopup" CssClass="myDatePickerPopup myenrollmentdob">
                </telerik:RadDatePicker>
                <asp:RequiredFieldValidator ID="reqValEnrollmentDate" runat="server" SetFocusOnError="true"
                    Display="Dynamic" ControlToValidate="RadDatePickerReleaseDate" ValidationGroup="SaveRelease"
                    CssClass="ErrorMessage" ErrorMessage="Release Date is required" Text="*"></asp:RequiredFieldValidator>
            </div>
        </div>
        <div class="row">
            <div class="">
                <asp:Label ID="LabelRelAgency" runat="server" Text="Release Agency" CssClass="mylabel"></asp:Label>
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
        </div>
        <div class="row">
            <div class="">
                <asp:Label ID="LabelRelReason" runat="server" Text="Release Reason" CssClass="mylabel"></asp:Label>
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
        <div class="row">
            <h3>
                Enrollment Status</h3>
            <asp:Label ID="LabelEnrollStatusType" runat="server" Text="Status" CssClass="mylabel myyouthtype"></asp:Label>
            <telerik:RadComboBox ID="RadComboBoxStatus"  DataValueField="StatusTypeID"
                DataTextField="Name" runat="server" CssClass="mydropdown">
            </telerik:RadComboBox>
        </div>
        <asp:Panel ID="PanelMainContentEditButtons" runat="server">
            <div class="editButtons">
                <asp:Button ID="SaveButton" runat="server" ValidationGroup="SaveRelease" OnClick="SaveButton_Click"
                    Text="Save" class="mybutton mysave" />
            </div>
        </asp:Panel>
    </div>
   