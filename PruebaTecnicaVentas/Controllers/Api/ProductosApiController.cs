using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PruebaTecnicaVentas.Data;

namespace PruebaTecnicaVentas.Controllers.Api
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductosApiController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ProductosApiController(AppDbContext context)
        {
            _context = context;
        }

        // Obtener el listado completo de productos.
        [HttpGet]
        public async Task<IActionResult> GetProductos()
        {
            var productos = await _context.Productos.ToListAsync();

            return Ok(productos);
        }
    }
}
