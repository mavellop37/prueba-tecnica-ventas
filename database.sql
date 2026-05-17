/*
========================================================
PRUEBA TÉCNICA — SQL SERVER
Proyecto: PruebaTecnicaVentas

Descripción:
Script con las consultas principales utilizadas para:
- normalización básica de productos
- matriz mensual de ventas
- consolidación de ventas
- análisis y validación de datos
========================================================
*/


/*
========================================================
1. CREACIÓN TABLA PRODUCTOS
========================================================

Objetivo:
Separar productos de la tabla Ventas para mejorar
la estructura y normalización de datos.
*/

CREATE TABLE Productos
(
    IdProducto INT PRIMARY KEY,
    NombreProducto VARCHAR(255)
);
GO


/*
========================================================
2. POBLAR TABLA PRODUCTOS
========================================================

Objetivo:
Insertar productos únicos existentes en Ventas.
*/

INSERT INTO Productos (IdProducto, NombreProducto)
SELECT DISTINCT
    IdProducto,
    Producto
FROM Ventas;
GO


/*
========================================================
3. MATRIZ MENSUAL DE VENTAS POR PRODUCTO
========================================================

Objetivo:
Generar combinación completa:
- todos los productos
- todos los períodos existentes

Incluso si no hubo ventas.

*/

SELECT
    Base.NombreProducto AS Producto,
    Base.Periodo,
    ISNULL(SUM(V.Cantidad), 0) AS CantidadVentas,
    ISNULL(SUM(V.Cantidad * V.Precio), 0) AS TotalVentas
FROM (
    SELECT
        P.IdProducto,
        P.NombreProducto,
        Periodos.Periodo
    FROM Productos P
    CROSS JOIN (
        SELECT DISTINCT
            DATEFROMPARTS(YEAR(Fecha), MONTH(Fecha), 1) AS Periodo
        FROM Ventas
    ) Periodos
) Base
LEFT JOIN Ventas V
    ON Base.IdProducto = V.IdProducto
    AND DATEFROMPARTS(YEAR(V.Fecha), MONTH(V.Fecha), 1) = Base.Periodo
GROUP BY
    Base.NombreProducto,
    Base.Periodo
ORDER BY
    Base.NombreProducto,
    Base.Periodo;


/*
========================================================
4. CREACIÓN DE VISTA CONSOLIDADA
========================================================

Objetivo:
Crear vista reutilizable para:
- consultas
- Power BI
- API REST
- reportes

La vista consolida:
- producto
- período
- cantidad vendida
- total vendido
incluyendo períodos sin ventas.
*/

CREATE VIEW vw_ResumenMensualVentas AS

WITH Periodos AS
(
    SELECT DISTINCT
        DATEFROMPARTS(YEAR(Fecha), MONTH(Fecha), 1) AS Periodo
    FROM Ventas
    WHERE Fecha IS NOT NULL
),

Productos AS
(
    SELECT DISTINCT
        IdProducto,
        Producto
    FROM Ventas
)

SELECT
    p.Producto,

    per.Periodo,

    ISNULL(SUM(v.Cantidad), 0) AS CantidadVentas,

    ISNULL(SUM(v.Cantidad * v.Precio), 0) AS TotalVentas

FROM Productos p

CROSS JOIN Periodos per

LEFT JOIN Ventas v
    ON v.IdProducto = p.IdProducto
    AND YEAR(v.Fecha) = YEAR(per.Periodo)
    AND MONTH(v.Fecha) = MONTH(per.Periodo)

GROUP BY
    p.Producto,
    per.Periodo;
GO

/*
========================================================
5. CONSULTA GENERAL RESUMEN MENSUAL
========================================================

Permite visualizar:
- producto
- período
- cantidad vendida
- total vendido
*/

SELECT *
FROM vw_ResumenMensualVentas
ORDER BY Producto, Periodo;
GO

/*
========================================================
6. DETECCIÓN POSIBLES VENTAS DUPLICADAS
========================================================

Objetivo:
Detectar registros potencialmente repetidos.
*/

SELECT
    Producto,
    Fecha,
    Cantidad,
    Precio,
    COUNT(*) AS CantidadDuplicados
FROM Ventas
GROUP BY
    Producto,
    Fecha,
    Cantidad,
    Precio
HAVING COUNT(*) > 1;
GO


/*
========================================================
7. DETECCIÓN CANTIDADES NEGATIVAS
========================================================

Objetivo:
Detectar registros con cantidades inválidas.
*/

SELECT *
FROM Ventas
WHERE Cantidad < 0;
GO


/*
========================================================
8. DETECCIÓN PRECIOS IGUALES A 0
========================================================

Objetivo:
Detectar registros con precios inválidos.
*/

SELECT *
FROM Ventas
WHERE Precio = 0;
GO


/*
========================================================
9. DETECCIÓN FECHAS NULAS
========================================================

Objetivo:
Detectar registros sin fecha válida.
*/

SELECT *
FROM Ventas
WHERE Fecha IS NULL;
GO


/*
========================================================
10. PRODUCTOS SIN VENTAS EN PERÍODOS
========================================================

Objetivo:
Identificar productos sin ventas
en determinados períodos.
*/

SELECT
    Producto,
    Periodo
FROM vw_ResumenMensualVentas
WHERE CantidadVentas = 0
ORDER BY Producto, Periodo;
GO


/*
========================================================
11. TOP PRODUCTOS POR VENTAS
========================================================

Objetivo:
Obtener productos con mayor total vendido.

Utilizado posteriormente en Power BI.
*/

SELECT TOP 10
    Producto,
    SUM(Cantidad * Precio) AS TotalVentas
FROM Ventas
GROUP BY Producto
ORDER BY TotalVentas DESC;
GO


/*
========================================================
12. EVOLUCIÓN MENSUAL DE VENTAS
========================================================

Objetivo:
Obtener evolución mensual de ventas.

Utilizado posteriormente en Power BI.
*/

SELECT
    DATEFROMPARTS(YEAR(Fecha), MONTH(Fecha), 1) AS Periodo,
    SUM(Cantidad * Precio) AS TotalVentas
FROM Ventas
WHERE Fecha IS NOT NULL
GROUP BY
    DATEFROMPARTS(YEAR(Fecha), MONTH(Fecha), 1)
ORDER BY Periodo;
GO
