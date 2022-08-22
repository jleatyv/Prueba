<%@ Page Title="" Language="C#" MasterPageFile="~/Inventario.Master" AutoEventWireup="true" CodeBehind="Producto.aspx.cs" Inherits="Inventario_2._1.Producto" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <telerik:RadAjaxManagerProxy ID="AjaxManagerProxy1" runat="server" >
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGrid1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>

             <telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
                <script type="text/javascript">
                    

                    function btnClick(sender, args) {
                        var callBackFunction = function (arg) {
                            if (arg) {
                                //initiate the original postback again
                                sender.click();
                                
                                

                            }
                        };
                                
                        var text = "Desea exportar?";
                        radconfirm(text, callBackFunction, 300, 200, null, "Exportar a XML");
                        //always prevent the original postback so the RadConfirm can work, it will be initiated again with code in the callback function
                        args.set_cancel(true); 
                        

                    }  

                    var uploadedFilesCount = 0;
                    var isEditMode;
                    function validateRadUpload(source, e) {
                        if (isEditMode == null || isEditMode == undefined) {
                            e.IsValid = false;

                            if (uploadedFilesCount > 0) {
                                e.IsValid = true;
                            }
                        }
                        isEditMode = null;
                    }

                    function OnClientFileUploaded(sender, eventArgs) {
                        uploadedFilesCount++;
                    }
                
                </script>

        </telerik:RadCodeBlock>

    <telerik:RadWindowManager ID="RadWindowManager1" runat="server"></telerik:RadWindowManager>





    <telerik:RadGrid ID="RadGrid1" runat="server" AllowAutomaticDeletes="True" AllowAutomaticInserts="True" AllowAutomaticUpdates="True" AllowFilteringByColumn="True" 
        AllowSorting="True" Culture="es-ES" DataSourceID="LinqDataSource1" OnInsertCommand="RadGrid1_InsertCommand" OnUpdateCommand="RadGrid1_UpdateCommand" 
        OnItemDataBound="RadGrid1_ItemDataBound" OnItemInserted="RadGrid1_ItemInserted" OnItemUpdated="RadGrid1_ItemUpdated" OnItemDeleted="RadGrid1_ItemDeleted" AllowPaging="True">
<GroupingSettings CollapseAllTooltip="Collapse all groups"></GroupingSettings>

        <HierarchySettings CollapseTooltip="Colapsar" ExpandTooltip="Expandir" />

<MasterTableView AllowSorting="False" AutoGenerateColumns="False" CommandItemDisplay="Top" DataKeyNames="CategoriaID" DataSourceID="LinqDataSource1" Name="Categoria" EditMode="InPlace" NoDetailRecordsText="No hay productos en esta categoria" NoMasterRecordsText="No hay datos">
    <DetailTables>
        <telerik:GridTableView runat="server" AllowSorting="False" AutoGenerateColumns="False" CommandItemDisplay="Top" DataKeyNames="ProductoID" DataSourceID="LinqDataSource2" Name="Producto" NoDetailRecordsText="No hay productos en esta categoria">
            <ParentTableRelation>
                <telerik:GridRelationFields DetailKeyField="CategoriaID" MasterKeyField="CategoriaID" />
            </ParentTableRelation>
            <CommandItemSettings AddNewRecordText="Adicionar" CancelChangesText="Cancelar" RefreshText="Refrescar" SaveChangesText="Salvar" />
            <RowIndicatorColumn ShowNoSortIcon="False">
            </RowIndicatorColumn>
            <ExpandCollapseColumn ShowNoSortIcon="False">
            </ExpandCollapseColumn>
            <Columns>

                 <telerik:GridEditCommandColumn ShowNoSortIcon="False" UpdateText="Actualizar">
                            <ItemStyle Width="10px" />
                        </telerik:GridEditCommandColumn>
                
                <telerik:GridBoundColumn FilterControlAltText="Filter Codigo column" HeaderText="Codigo" InsertVisiblityMode="AlwaysHidden" ReadOnly="True" ShowNoSortIcon="False" UniqueName="Codigo" DataField="Codigo">
                    <ItemStyle HorizontalAlign="Right" />
                </telerik:GridBoundColumn>

                <telerik:GridBoundColumn DataField="Nombre" MaxLength ="50" FilterControlAltText="Filter Nombre column" HeaderText="Nombre" ShowNoSortIcon="False" SortExpression="Nombre" AutoPostBackOnFilter="true"
                            UniqueName="Nombre" ColumnValidationSettings-EnableRequiredFieldValidation="true"
                            ColumnValidationSettings-RequiredFieldValidator-ErrorMessage=" Campo vacio" ColumnValidationSettings-RequiredFieldValidator-ForeColor="Red">
                            <ColumnValidationSettings EnableRequiredFieldValidation="True">
                                <RequiredFieldValidator ForeColor="Red" ErrorMessage=" Campo vacio"></RequiredFieldValidator>
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="Abreviatura" MaxLength="3" HeaderText="Abreviatura" HeaderButtonType="TextButton" AutoPostBackOnFilter="true"
                            DataField="Abreviatura" UniqueName="Abreviatura" ColumnValidationSettings-EnableRequiredFieldValidation="true"
                            ColumnValidationSettings-RequiredFieldValidator-ErrorMessage=" Campo vacio" ColumnValidationSettings-RequiredFieldValidator-ForeColor="Red">
                            <ColumnValidationSettings EnableRequiredFieldValidation="True">
                                <RequiredFieldValidator ForeColor="Red" ErrorMessage=" Campo vacio"></RequiredFieldValidator>
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>



                        <telerik:GridTemplateColumn HeaderText="UM" FilterControlAltText="Filter UM column" AutoPostBackOnFilter="true"
                            UniqueName="UM" ForceExtractValue="Always" DataField="UMID" >
                            <ItemTemplate>
                               <asp:Label ID="UMLabel" runat="server" Text='<%# Eval("INVUM.Abrev") %>' ></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <telerik:RadDropDownList RenderMode="Lightweight" runat="server" ID="RadDropDownList2" DataTextField="Nombre"
                                    DataValueField="UMID" DataSourceID="LinqDataSource3" SelectedValue='<%#Bind("UMID") %>'>
                                </telerik:RadDropDownList>
                            </EditItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridNumericColumn SortExpression="Costo" ColumnEditorID="Costo" HeaderText="Costo" HeaderButtonType="TextButton" AutoPostBackOnFilter="true"
                            DataField="Costo" UniqueName="Costo" ColumnValidationSettings-EnableRequiredFieldValidation="true"
                            ColumnValidationSettings-RequiredFieldValidator-ErrorMessage=" Campo vacio" ColumnValidationSettings-RequiredFieldValidator-ForeColor="Red" NumericType="Currency" MinValue="0">
                            <ColumnValidationSettings EnableRequiredFieldValidation="True">
                                <RequiredFieldValidator ForeColor="Red" ErrorMessage=" Campo vacio"></RequiredFieldValidator>
                            </ColumnValidationSettings>
                            <ItemStyle HorizontalAlign="Right" />
                        </telerik:GridNumericColumn>
                        <telerik:GridNumericColumn SortExpression="Precio" ColumnEditorID="Precio" HeaderText="Precio" HeaderButtonType="TextButton" AutoPostBackOnFilter="true"
                            DataField="Precio" UniqueName="Precio" ColumnValidationSettings-EnableRequiredFieldValidation="true"
                            ColumnValidationSettings-RequiredFieldValidator-ErrorMessage=" Campo vacio" ColumnValidationSettings-RequiredFieldValidator-ForeColor="Red" MinValue="0" NumericType="Currency">

                            <ColumnValidationSettings EnableRequiredFieldValidation="True">
                                <RequiredFieldValidator ForeColor="Red" ErrorMessage=" Campo vacio"></RequiredFieldValidator>
                            </ColumnValidationSettings>
                            <ItemStyle HorizontalAlign="Right" />
                        </telerik:GridNumericColumn>

                        <telerik:GridCheckBoxColumn DataField="EsInventariado" DataType="System.Boolean" FilterControlAltText="Filter column1 column" HeaderText="Es Inventariado" ShowNoSortIcon="False" UniqueName="EsInventariado">
                        </telerik:GridCheckBoxColumn>

                         <telerik:GridCheckBoxColumn DataField="EsParaVenta" DataType="System.Boolean" FilterControlAltText="Filter column1 column" HeaderText="Es para la Venta" ShowNoSortIcon="False" UniqueName="EsParaVenta">
                        </telerik:GridCheckBoxColumn>
                                
                               
                          <telerik:GridDropDownColumn DataSourceID="ObjectDataSource1" FilterControlAltText="Filter EstadoProducto column" ShowNoSortIcon="False" UniqueName="EstadoProducto" ListTextField="value" ListValueField="key" DataField="Estado" AutoPostBackOnFilter="true" HeaderText="Estado">
                 </telerik:GridDropDownColumn>

                       <telerik:GridTemplateColumn DataField="Imagen" HeaderText="Imagen" UniqueName="ImagenProd" AllowFiltering="False">
                        <ItemTemplate>
                            <telerik:RadBinaryImage runat="server" ID="RadBinaryImage1" DataValue='<%#Eval("Imagen") %>'
                                AutoAdjustImageControlSize="false" Height="80px" Width="80px"  
                                AlternateText="Imagen Producto" ImageUrl="sin foto.jpg" ResizeMode="Fit"></telerik:RadBinaryImage>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <telerik:RadAsyncUpload RenderMode="Lightweight" runat="server" ID="AsyncUpload1" OnClientFileUploaded="OnClientFileUploaded"
                                AllowedFileExtensions="jpg,jpeg,png,gif" MaxFileSize="1048576" OnFileUploaded="AsyncUpload1_FileUploaded" MaxFileInputsCount="1">
                            </telerik:RadAsyncUpload>
                        </EditItemTemplate>
                    </telerik:GridTemplateColumn>
                 <telerik:GridButtonColumn ConfirmText="Desea eliminar?" ConfirmDialogType="RadWindow"
                            ConfirmTitle="Eliminar" ButtonType="FontIconButton" CommandName="Delete" />

            </Columns>
            <EditFormSettings>
                <EditColumn ShowNoSortIcon="False">
                </EditColumn>
            </EditFormSettings>
        </telerik:GridTableView>
    </DetailTables>
    <CommandItemSettings AddNewRecordText="Adicionar" CancelChangesText="Cancelar" RefreshText="Refrescar" SaveChangesText="Salvar" />
<RowIndicatorColumn ShowNoSortIcon="False"></RowIndicatorColumn>

<ExpandCollapseColumn ShowNoSortIcon="False"></ExpandCollapseColumn>

    <Columns>
         <telerik:GridEditCommandColumn ShowNoSortIcon="False" UpdateText="Actualizar">
                            <ItemStyle Width="10px" />
                        </telerik:GridEditCommandColumn>
        <telerik:GridBoundColumn DataField="CategoriaID" DataType="System.Int32" FilterControlAltText="Filter CategoriaID column" HeaderText="CategoriaID" ReadOnly="True" ShowNoSortIcon="False" SortExpression="CategoriaID" UniqueName="CategoriaID">
            <ItemStyle HorizontalAlign="Right" />
        </telerik:GridBoundColumn>
        <telerik:GridBoundColumn DataField="Nombre" FilterControlAltText="Filter Nombre column" HeaderText="Nombre" ShowNoSortIcon="False" SortExpression="Nombre" UniqueName="Nombre" AutoPostBackOnFilter="true" 
                            ColumnValidationSettings-EnableRequiredFieldValidation="true"
                            ColumnValidationSettings-RequiredFieldValidator-ErrorMessage=" Campo vacio" ColumnValidationSettings-RequiredFieldValidator-ForeColor="Red">
                            <ColumnValidationSettings EnableRequiredFieldValidation="True">
                                <RequiredFieldValidator ForeColor="Red" ErrorMessage=" Campo vacio"></RequiredFieldValidator>
                            </ColumnValidationSettings>
        </telerik:GridBoundColumn>
        <telerik:GridBoundColumn DataField="Descripcion" FilterControlAltText="Filter Descripcion column" HeaderText="Descripcion" ShowNoSortIcon="False" SortExpression="Descripcion" UniqueName="Descripcion" AutoPostBackOnFilter="true" 
                            ColumnValidationSettings-EnableRequiredFieldValidation="true"
                            ColumnValidationSettings-RequiredFieldValidator-ErrorMessage=" Campo vacio" ColumnValidationSettings-RequiredFieldValidator-ForeColor="Red">
                            <ColumnValidationSettings EnableRequiredFieldValidation="True">
                                <RequiredFieldValidator ForeColor="Red" ErrorMessage=" Campo vacio"></RequiredFieldValidator>
                            </ColumnValidationSettings>
        </telerik:GridBoundColumn>
       <telerik:GridDropDownColumn DataSourceID="ObjectDataSource1" FilterControlAltText="Filter EstadoCategoria column" ShowNoSortIcon="False" UniqueName="EstadoCategoria" ListTextField="value" ListValueField="key" DataField="Estado" AutoPostBackOnFilter="true" HeaderText="Estado">
                 </telerik:GridDropDownColumn>
        <telerik:GridBinaryImageColumn DataField="Imagen" DefaultImageUrl="/sin foto.jpg" AllowFiltering="False" AllowSorting="False" FilterControlAltText="Filter ImagenCat column" HeaderText="Imagen" ImageHeight="80px" ImageWidth="80px" ShowNoSortIcon="False" UniqueName="ImagenCat" UploadControlType="RadAsyncUpload" ResizeMode="Fit" AutoAdjustImageControlSize="true">
            <ItemStyle HorizontalAlign="Center" />
        </telerik:GridBinaryImageColumn>

        <telerik:GridTemplateColumn UniqueName="Exportar"  AllowFiltering="False">
                            <ItemTemplate>
                                <telerik:RadButton ID="Exportar" runat="server" Text="Exportar XML" OnClientClicking="btnClick"
                                    OnClick="Exportar_Click">
                                </telerik:RadButton>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
         <telerik:GridButtonColumn ConfirmText="Desea eliminar?" ConfirmDialogType="RadWindow"
                            ConfirmTitle="Eliminar" ButtonType="FontIconButton" CommandName="Delete" />
    </Columns>

<EditFormSettings>
<EditColumn ShowNoSortIcon="False"></EditColumn>
</EditFormSettings>
</MasterTableView>
    </telerik:RadGrid>

    <telerik:RadNotification ID="RN1" runat="server" Position ="Center" >
    </telerik:RadNotification>

    <asp:LinqDataSource ID="LinqDataSource1" runat="server" ContextTypeName="Inventario_2._1.InventarioDataContext" EnableDelete="True" EnableInsert="True" EnableUpdate="True" EntityTypeName="" TableName="INVCategoria" OnInserting="LinqDataSource1_Inserting" OnUpdating="LinqDataSource1_Updating">
    </asp:LinqDataSource>
    <asp:LinqDataSource ID="LinqDataSource2" runat="server" ContextTypeName="Inventario_2._1.InventarioDataContext" EnableDelete="True" EnableInsert="True" EnableUpdate="True" EntityTypeName="" TableName="INVProducto" Where="CategoriaID == @CategoriaID" OnInserting="LinqDataSource2_Inserting" OnUpdating="LinqDataSource2_Updating">
        <WhereParameters>
            <asp:Parameter Name="CategoriaID" Type="Int32" />
        </WhereParameters>
    </asp:LinqDataSource>
   
    
    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" SelectMethod="GetItems" TypeName="Inventario_2._1.Producto"></asp:ObjectDataSource>
    <br />





    <asp:LinqDataSource ID="LinqDataSource3" runat="server" ContextTypeName="Inventario_2._1.InventarioDataContext" EntityTypeName="" Select="new (UMID, Nombre, Abrev)" TableName="INVUM">
    </asp:LinqDataSource>





</asp:Content>
