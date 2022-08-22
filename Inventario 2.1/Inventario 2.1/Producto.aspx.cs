using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using System.Xml.Linq;

namespace Inventario_2._1
{
    public partial class Producto : System.Web.UI.Page
    {
        InventarioDataContext dc = new InventarioDataContext();
        byte[] image = null;
        public enum enumEstado : byte { Activo = 1, Inactivo = 2, Borrado = 3 }

        public List<KeyValuePair<byte, string>> Lista(Enum e)
        {

            var value = Enum.GetValues(e.GetType())
                                  .Cast<byte>()
                                  .Select(x => new KeyValuePair<byte, string>(key: x, value: Enum.GetName(e.GetType(), x)))
                                  .ToList();

            return value;
        }
        public List<KeyValuePair<byte, string>> GetItems()
        {
            var listaEstado = Lista(enumEstado.Activo);
            return listaEstado;
        }
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void RadGrid1_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                if (!e.Item.IsInEditMode)
                {

                    if (e.Item.DataItem as INVCategoria != null)
                    {
                        var dataItem = (INVCategoria)e.Item.DataItem;
                        if (dataItem.Estado != 1)
                        {
                            e.Item.BackColor = Color.Coral;
                        }

                    }
                    if (e.Item.DataItem as INVProducto != null)
                    {
                        var dataItem = (INVProducto)e.Item.DataItem;
                        if (dataItem.Estado != 1)
                        {
                            e.Item.BackColor = Color.Coral;
                        }

                    }

                }
                else
                {

                    e.Item.BackColor = Color.White;

                }
            }
        }

        protected void Exportar_Click(object sender, EventArgs e)
        {

            var item = (GridDataItem)(sender as RadButton).NamingContainer;
            var categoria = dc.INVCategoria.Single(r => r.CategoriaID == Convert.ToInt64(item["CategoriaID"].Text));

            XDocument document = new XDocument(new XDeclaration("1.0", "utf-8", null));
            XElement raiz = new XElement("Categoria");
            document.Add(raiz);
            raiz.Add(new XElement("CategoriaID", categoria.CategoriaID));
            raiz.Add(new XElement("Nombre", categoria.Nombre.Trim()));
            raiz.Add(new XElement("Descripcion", categoria.Descripcion.Trim()));
            raiz.Add(new XElement("Estado", categoria.Estado));
            XElement prod = new XElement("Productos");
            raiz.Add(prod);
            var productos = dc.INVProducto.Where(r => r.CategoriaID == categoria.CategoriaID);
            foreach (var producto in productos)
            {
                XElement product = new XElement("Producto");
                prod.Add(product);
                product.Add(new XElement("Codigo", producto.Codigo.Trim()));
                product.Add(new XElement("Nombre", producto.Nombre.Trim()));
                product.Add(new XElement("Abreviatura", producto.Abreviatura.Trim()));
                product.Add(new XElement("UM", producto.UMID));
                product.Add(new XElement("Costo", producto.Costo));
                product.Add(new XElement("Precio", producto.Precio));
                product.Add(new XElement("EsInventariado", producto.EsInventariado));
                product.Add(new XElement("EsParaVenta", producto.EsParaVenta));

            }

            string archivo = Server.MapPath("/xml/Categoria.xml");
            document.Save(archivo);

            Response.ContentType = "text/xml";
            Response.AppendHeader("Content-Disposition", "attachment;filename=" + archivo);
            Response.TransmitFile(archivo);
            Response.Flush();
            Response.End();


        }

        protected void RadGrid1_InsertCommand(object sender, GridCommandEventArgs e)
        {
            var editableItem = ((GridEditableItem)e.Item);
            if (e.Item.OwnerTableView.DataSourceID == "LinqDataSource2")
            {
                RadAsyncUpload radAsyncUpload = editableItem["ImagenProd"].FindControl("AsyncUpload1") as RadAsyncUpload;
                if (radAsyncUpload.UploadedFiles.Count > 0)
                {
                    UploadedFile file = radAsyncUpload.UploadedFiles[0];
                    byte[] fileData = new byte[file.InputStream.Length];
                    file.InputStream.Read(fileData, 0, (int)file.InputStream.Length);
                    image = fileData;

                }
            }

        }

        protected void RadGrid1_UpdateCommand(object sender, GridCommandEventArgs e)
        {
            var editableItem = ((GridEditableItem)e.Item);
            if (e.Item.OwnerTableView.DataSourceID == "LinqDataSource2")
            {
                RadAsyncUpload radAsyncUpload = editableItem["ImagenProd"].FindControl("AsyncUpload1") as RadAsyncUpload;
                if (radAsyncUpload.UploadedFiles.Count > 0)
                {
                    UploadedFile file = radAsyncUpload.UploadedFiles[0];
                    byte[] fileData = new byte[file.InputStream.Length];
                    file.InputStream.Read(fileData, 0, (int)file.InputStream.Length);
                    image = fileData;

                }
            }
        }

        protected void LinqDataSource1_Inserting(object sender, LinqDataSourceInsertEventArgs e)
        {
            INVCategoria invCat = (INVCategoria)e.NewObject;
            invCat.FechaCreacion = DateTime.Now;
            invCat.FechaModificacion = DateTime.Now;

        }

        protected void LinqDataSource1_Updating(object sender, LinqDataSourceUpdateEventArgs e)
        {
            INVCategoria invCat = (INVCategoria)e.NewObject;
            invCat.FechaModificacion = DateTime.Now;
            if (invCat.Estado == 3)
            {
                CambiarEstado(invCat.CategoriaID);
            }

        }
        private void CambiarEstado(int categoriaID)
        {
            var productos = dc.INVProducto.Where(r => r.CategoriaID == categoriaID);
            foreach (var producto in productos)
            {
                producto.Estado = 3;
            }
            dc.SubmitChanges();
        }

        protected void LinqDataSource2_Inserting(object sender, LinqDataSourceInsertEventArgs e)
        {
            INVProducto iNVProducto = (INVProducto)e.NewObject;
            iNVProducto.Codigo = " ";
            iNVProducto.FechaCreacion = DateTime.Now;
            iNVProducto.FechaModificacion = DateTime.Now;
            iNVProducto.Imagen = image;
        }


        protected void LinqDataSource2_Updating(object sender, LinqDataSourceUpdateEventArgs e)
        {
            INVProducto iNVProducto = (INVProducto)e.NewObject;
            iNVProducto.FechaModificacion = DateTime.Now;
            iNVProducto.Imagen = image;
        }


        protected void RadGrid1_ItemInserted(object sender, GridInsertedEventArgs e)
        {
            string item = GetItemName(e.Item.OwnerTableView.Name);
            if (e.Exception != null)
            {
                e.ExceptionHandled = true;
                DisplayMessage(item + " no se insertó. Razón: " + e.Exception.Message);
            }
            else
            {

                RN1.Show(item + " insertado");
            }
        }

        protected void RadGrid1_ItemUpdated(object sender, GridUpdatedEventArgs e)
        {
            string item = GetItemName(e.Item.OwnerTableView.Name);
            string field = GetFieldName(e.Item.OwnerTableView.Name);
            if (e.Exception != null)
            {
                e.KeepInEditMode = true;
                e.ExceptionHandled = true;
                DisplayMessage(item + " no se actualizó. Razón: " + e.Exception.Message);
            }
            else
            {

                RN1.Show(item + " actualizado");
            }
        }

        protected void RadGrid1_ItemDeleted(object sender, GridDeletedEventArgs e)
        {
            string item = GetItemName(e.Item.OwnerTableView.Name);
            string field = GetFieldName(e.Item.OwnerTableView.Name);
            if (e.Exception != null)
            {
                e.ExceptionHandled = true;
                DisplayMessage(item + " no se eliminó. Razón: " + e.Exception.Message);

            }
            else
            {

                RN1.Show(item + " eliminado");
            }
        }

        private String GetItemName(string tableName)
        {
            switch (tableName)
            {
                case ("Categoria"):
                    {
                        return "Categoria";
                    }
                case ("Producto"):
                    {
                        return "Producto";
                    }
                default: return "";
            }
        }

        private String GetFieldName(string tableName)
        {
            switch (tableName)
            {
                case ("Categoria"):
                    {
                        return "Nombre";
                    }
                case ("Producto"):
                    {
                        return "Nombre";
                    }

                default: return "";
            }
        }

        private void DisplayMessage(string text)
        {
            RadGrid1.Controls.Add(new LiteralControl(string.Format("<span style='color:red'>{0}</span>", text)));
        }



        const int MaxTotalBytes = 1048576; // 1 MB
        Int64 totalBytes;

        public bool? IsRadAsyncValid
        {
            get
            {
                if (Session["IsRadAsyncValid"] == null)
                {
                    Session["IsRadAsyncValid"] = true;
                }

                return Convert.ToBoolean(Session["IsRadAsyncValid"].ToString());
            }
            set
            {
                Session["IsRadAsyncValid"] = value;
            }
        }

        protected void AsyncUpload1_FileUploaded(object sender, FileUploadedEventArgs e)
        {
            if ((totalBytes < MaxTotalBytes) && (e.File.ContentLength < MaxTotalBytes))
            {
                e.IsValid = true;
                totalBytes += e.File.ContentLength;
                IsRadAsyncValid = true;
            }
            else
            {
                e.IsValid = false;
                IsRadAsyncValid = false;
            }
        }


    }
}