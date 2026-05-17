using Microsoft.EntityFrameworkCore;
using PruebaTecnicaVentas.Models;

namespace PruebaTecnicaVentas.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options)
            : base(options)
        {
        }
        public DbSet<Producto> Productos { get; set; }
        public DbSet<ResumenMensualVenta> ResumenMensualVentas { get; set; }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<ResumenMensualVenta>()
                .HasNoKey()
                .ToView("vw_ResumenMensualVentas");
        }
    }
}