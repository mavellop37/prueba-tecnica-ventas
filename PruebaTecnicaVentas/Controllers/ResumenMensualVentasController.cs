using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PruebaTecnicaVentas.Data;

namespace PruebaTecnicaVentas.Controllers
{
    public class ResumenMensualVentasController : Controller
    {
        private readonly AppDbContext _context;

        public ResumenMensualVentasController(AppDbContext context)
        {
            _context = context;
        }
        // Obtiene el consolidado mensual de ventas
        // desde la vista SQL vw_ResumenMensualVentas.
        public async Task<IActionResult> Index()
        {
            var resumen = await _context.ResumenMensualVentas
                .OrderBy(r => r.Producto)
                .ThenBy(r => r.Periodo)
                .ToListAsync();

            return View(resumen);
        }
    }
}
