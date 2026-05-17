//using System.ComponentModel.DataAnnotations;

namespace PruebaTecnicaVentas.Models
{
    public class ResumenMensualVenta
    {
    
        public string Producto { get; set; } = string.Empty;

        public DateTime Periodo { get; set; }

        public int CantidadVentas { get; set; }

        public decimal TotalVentas { get; set; }
    }
}