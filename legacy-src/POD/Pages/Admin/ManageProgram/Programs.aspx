<%@ Page Title="" Language="C#" MasterPageFile="~/Templates/Markup/AdminWide.Master"
    AutoEventWireup="true" CodeBehind="Programs.aspx.cs" Inherits="POD.Pages.Admin.ManageProgramsAndCourses.Programs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceholder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentPlaceholder" runat="server">
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server" EnableAJAX="true">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGridPrograms">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridPrograms" LoadingPanelID="RadAjaxLoadingPanel1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>
    <!--this is the loading image control, must specify an image -->
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" EnableSkinTransparency="true"
        runat="server">
    </telerik:RadAjaxLoadingPanel>
    <telerik:RadGrid ID="RadGridPrograms" runat="server" DataSourceID="DataSourcePrograms"
        OnDeleteCommand="RadGridPrograms_Delete" AllowAutomaticInserts="true" AllowAutomaticDeletes="false"
        AutoGenerateColumns="false" OnItemInserted="RadGridPrograms_ItemInserted" AllowAutomaticUpdates="true"
        AllowPaging="true" PageSize="15" OnItemUpdated="RadGridPrograms_ItemUpdated"
        Skin="Prodigy" EnableEmbeddedSkins="false" CssClass="CommandItemGrid ProgramGrid widetabcontainer">
        <MasterTableView DataKeyNames="ProgramID" CommandItemDisplay="Top" NoMasterRecordsText="No Programs were found">
            <CommandItemSettings ShowAddNewRecordButton="true" AddNewRecordText="Add Program" AddNewRecordImageUrl="../../../App_Themes/Prodigy/Grid/Add.gif"
                ShowRefreshButton="true" RefreshImageUrl="../../../App_Themes/Prodigy/Grid/Refresh.png" RefreshText="" />
            <ItemStyle />
            <EditFormSettings EditColumn-ButtonType="LinkButton">
                <FormTableButtonRowStyle CssClass="EditButtonRow" />
            </EditFormSettings>
            <AlternatingItemStyle />
            <Columns>
                <telerik:GridButtonColumn ButtonType="ImageButton" ItemStyle-Width="4%" CommandArgument="Edit"
                    CommandName="Edit" ImageUrl="../../../App_Themes/Prodigy/Grid/edit.gif" ItemStyle-HorizontalAlign="Center"
                    ShowFilterIcon="False" UniqueName="EditColumn" ButtonCssClass="IconButton PencilButton"
                    HeaderStyle-HorizontalAlign="Center">
                </telerik:GridButtonColumn>
                <telerik:GridBoundColumn DataField="Name" SortExpression="Name" ItemStyle-Width="20%"
                    HeaderText="Name" HeaderStyle-Width="100px" />
                <telerik:GridBoundColumn DataField="ProgramType.Name" SortExpression="ProgramType.Name"
                    HeaderText="Type">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="StatusType.Name" SortExpression="StatusType.Name"
                    HeaderText="Status">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="Description" SortExpression="Description" MaxLength="250"
                    HeaderText="Desc">
                </telerik:GridBoundColumn>
                <telerik:GridButtonColumn ButtonType="ImageButton" ItemStyle-Width="5%" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                    CommandArgument="Delete" CommandName="Delete" ImageUrl="../../../App_Themes/Prodigy/Grid/Delete.png"
                    ShowFilterIcon="False" UniqueName="DeleteColumn" ConfirmText="Are you sure you want to delete this Program and all its related data?"
                    ButtonCssClass="IconButton DeleteButton">
                </telerik:GridButtonColumn>
            </Columns>
            <EditFormSettings EditFormType="Template" EditColumn-ButtonType="LinkButton">
                <FormTemplate>
                    <asp:Panel ID="PanelContent" class="FormWrapper" runat="server">
                        <div class="row InputWrapper">
                            <asp:Label ID="LabelName" runat="server" Text="Name" CssClass="mylabel"></asp:Label>

                            <asp:TextBox ID="TextBoxName" runat="server" Text='<%# Bind("Name") %>' CssClass="myfield"></asp:TextBox>
                        </div>
                        <div class="row InputWrapper">
                            <asp:Label ID="LabelType" runat="server" Text="Type" CssClass="mylabel"></asp:Label>
                            <telerik:RadComboBox DataTextField="Name" DataValueField="ProgramTypeID" DataSourceID="DataSourceProgramTypes"
                                ID="RadComboProgramType" runat="server" EnableEmbeddedSkins="false" SkinID="Prodigy" CssClass="mydropdown" SelectedValue='<%# Bind("ProgramTypeID") %>'>
                            </telerik:RadComboBox>
                        </div>
                        <div class="row InputWrapper">
                            <asp:Label ID="LabelStatus" runat="server" Text="Status" CssClass="mylabel"></asp:Label>
                            <telerik:RadComboBox DataTextField="Name" DataValueField="StatusTypeID" DataSourceID="DataSourceStatusTypes"
                                ID="RadComboStatusType" runat="server" EnableEmbeddedSkins="false" SkinID="Prodigy" CssClass="mydropdown" SelectedValue='<%# Bind("StatusTypeID") %>'>
                            </telerik:RadComboBox>
                        </div>
                        <div class="InputWrapper">
                            <asp:Label ID="LabelDescription" runat="server" Text="Description" CssClass="mylabel"></asp:Label>
                            <telerik:RadEditor ID="RadEditoDesc" CssClass="TextEditor" Width="525" Height="225"
                                AutoResizeHeight="false" AllowScripts="false" SkinID="BasicSetOfTools" EnableEmbeddedSkins="false"
                                Skin="Prodigy" EnableResize="False" Content='<%# DataBinder.Eval(Container.DataItem, "Description") %>'
                                runat="server">
                               <Tools>
                        <telerik:EditorToolGroup Tag="MainToolbar">
                            <telerik:EditorTool Name="AjaxSpellCheck" />
                            <telerik:EditorTool Name="FindAndReplace" />
                            <telerik:EditorSeparator Visible="true" />
                            <telerik:EditorTool Name="Undo" />
                            <telerik:EditorTool Name="Redo" />
                            <telerik:EditorSeparator Visible="true" />
                            <telerik:EditorTool Name="Cut" />
                            <telerik:EditorTool Name="Copy" />
                            <telerik:EditorTool Name="Paste" ShortCut="CTRL+!" />
                           
                        </telerik:EditorToolGroup>
                        <telerik:EditorToolGroup Tag="Formatting">
                            <telerik:EditorTool Name="Bold" />
                            <telerik:EditorTool Name="Italic" />
                            <telerik:EditorTool Name="Underline" />
                            <telerik:EditorSeparator Visible="true" />
                            <telerik:EditorTool Name="ForeColor" />
                            <telerik:EditorTool Name="BackColor" />
                            <telerik:EditorSeparator Visible="true" />
                            <telerik:EditorTool Name="FontName" />
                            <telerik:EditorTool Name="RealFontSize" />
                              <telerik:EditorSeparator Visible="true" />
                                           <telerik:EditorTool name="InsertOrderedList" />
                                           <telerik:EditorTool name="InsertUnorderedList" />
                                           <telerik:EditorTool name="Outdent" />
                                           <telerik:EditorTool name="Indent" />
                        </telerik:EditorToolGroup>
                    </Tools>
                            </telerik:RadEditor>
                            <br style="clear: both;" />
                        </div>
                        <div class="ButtonWrapper">
                            <asp:Button ID="btnUpdate" Text="Update" runat="server" CssClass="mybutton" CommandName="Update"
                                Visible='<%# !(Container.DataItem is Telerik.Web.UI.GridInsertionObject) %>'>
                            </asp:Button>
                            <asp:Button ID="btnInsert" Text="Insert" runat="server" CommandName="PerformInsert"
                                CssClass="mybutton" Visible='<%# Container.DataItem is Telerik.Web.UI.GridInsertionObject %>'>
                            </asp:Button>
                            &nbsp; &nbsp;
                            <asp:Button runat="server" ID="ButtonCacnel" Text="Cancel" CssClass="mybutton" CommandName="Cancel"
                                CausesValidation="false"></asp:Button>
                        </div>
                    </asp:Panel>
                </FormTemplate>
            </EditFormSettings>
        </MasterTableView>
    </telerik:RadGrid>
    <asp:EntityDataSource ID="DataSourcePrograms" runat="server" ConnectionString="name=PODContext"
      DefaultContainerName="PODContext"  EnableFlattening="False" EntitySetName="Programs"
        Include="ProgramType, StatusType" EnableInsert="true" EnableUpdate="true" OnInserting="DatasourcePrograms_Inserting"
        OrderBy="it.[Name]" OnUpdating="DataSourcePrograms_Updating">
    </asp:EntityDataSource>
    <asp:EntityDataSource ID="DataSourceStatusTypes" runat="server" ConnectionString="name=PODContext"
      DefaultContainerName="PODContext"  EnableFlattening="False" EntitySetName="StatusTypes"
        OrderBy="it.[Name]" Where='it.[Category]=="Common"'>
    </asp:EntityDataSource>
    <asp:EntityDataSource ID="DataSourceProgramTypes" runat="server" ConnectionString="name=PODContext"
      DefaultContainerName="PODContext"  EnableFlattening="False" EntitySetName="ProgramTypes"
        OrderBy="it.[Name]">
    </asp:EntityDataSource>
</asp:Content>
