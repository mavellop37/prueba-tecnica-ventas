using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PruebaTecnicaVentas.Data;

namespace PruebaTecnicaVentas.Controllers.Api
{
    [Route("api/[controller]")]
    [ApiController]
    public class ResumenMensualVentasApiController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ResumenMensualVentasApiController(AppDbContext context)
        {
            _context = context;
        }

        // Obtiene el resumen mensual consolidado de ventas.
        // con filtros opcionales por producto y período.
        [HttpGet]
        public async Task<IActionResult> GetResumenMensual(
        string? producto,
        DateTime? periodo)
        {
           
            var query = _context.ResumenMensualVentas.AsQueryable();

            if (!string.IsNullOrEmpty(producto))
            {
                query = query.Where(r => r.Producto.Contains(producto));
            }

            if (periodo.HasValue)
            {
                query = query.Where(r => r.Periodo == periodo.Value);
            }

            var resumen = await query
                .OrderBy(r => r.Producto)
                .ThenBy(r => r.Periodo)
                .ToListAsync();

            return Ok(resumen);
        }
    }
}
