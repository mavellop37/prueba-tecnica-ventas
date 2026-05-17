# Prueba Técnica — SQL Server, .NET 8 y Power BI

## Descripción

Aplicación desarrollada como solución para prueba técnica orientada a análisis y gestión de ventas utilizando:

- SQL Server
- ASP.NET Core MVC (.NET 8)
- Entity Framework Core
- API REST
- Swagger/OpenAPI

El proyecto permite:
- administración de productos mediante CRUD,
- visualización de resumen mensual de ventas,
- exposición de información mediante endpoints REST.

---

# Tecnologías utilizadas

- ASP.NET Core MVC (.NET 8)
- Entity Framework Core 8
- SQL Server Express
- Swagger / OpenAPI
- Bootstrap
- LINQ
- Chat GPT

---

# Funcionalidades implementadas

## Gestión de Productos
- listado de productos
- creación
- edición
- eliminación
- detalle de registros

---

## Resumen Mensual de Ventas
Visualización consolidada de ventas utilizando la vista SQL:

```sql
vw_ResumenMensualVentas
```

Incluye:
- producto
- período
- cantidad de ventas
- total de ventas

---

## API REST

### Productos
```http
GET /api/productosapi
```

---

### Resumen Mensual
```http
GET /api/resumenmensualventasapi
```

Filtros opcionales:
```http
?producto=asus
&periodo=2024-01-01
```

---

## Swagger

Documentación y prueba de endpoints disponible en:

```http
/swagger
```

---

# Configuración

## Connection String

Configurar en:

```json
appsettings.json
```

Ejemplo:

```json
"ConnectionStrings": {
  "DefaultConnection": "Server=localhost\\SQLEXPRESS;Database=Tecnica;Trusted_Connection=True;TrustServerCertificate=True;"
}
```

---

# Ejecución

1. Restaurar base de datos SQL Server.
2. Configurar cadena de conexión en 'appsettings.json'.
3. Ejecutar aplicación desde Visual Studio 2022.
4. Acceder a:
   - `/Productos`
   - `/ResumenMensualVentas`
   - `/swagger`
5. Abrir el archivo Power BI para visualizar el dashboard.
---

# Autor: Mario Avello

Desarrollado como solución para prueba técnica de desarrollador .NET.
