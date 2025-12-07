SELECT 
    p.category_name AS Categoria,
    p.product_name AS Producto,
    p.brand_name AS Marca,
    c.full_name AS Cliente,
    SUM(f.Quantity) AS CantidadVendida,
    SUM(f.NetAmount) AS TotalVendido,
    d.Date AS FechaOrden
FROM dbo.FactOrders f
INNER JOIN dbo.DimProducts p ON p.ProductKey = f.ProductKey
INNER JOIN dbo.DimCustomers c ON c.CustomerKey = f.CustomerKey
INNER JOIN dbo.DimDate d ON d.DateKey = f.OrderDateKey
WHERE 
    (@Cliente IS NULL OR c.full_name = @Cliente)
    AND (@Marca IS NULL OR p.brand_name = @Marca)
    AND d.Date >= @FechaInicio
    AND d.Date <= @FechaFin
GROUP BY 
    p.category_name,
    p.product_name,
    p.brand_name,
    c.full_name,
    d.Date
ORDER BY 
    p.category_name,
    p.product_name;

-- Marcas:
SELECT DISTINCT brand_name
FROM dbo.DimProducts
ORDER BY brand_name;
-- Fechas:
SELECT MAX(DO.order_date) AS max_date, MIN(DO.order_date) AS min_date
FROM dbo.DimOrders DO
