using System.ComponentModel.DataAnnotations;

namespace PruebaTecnicaVentas.Models
{
    public class Producto
    {
        [Key]
        public int IdProducto { get; set; }

        public string NombreProducto { get; set; } = string.Empty;
    }
}