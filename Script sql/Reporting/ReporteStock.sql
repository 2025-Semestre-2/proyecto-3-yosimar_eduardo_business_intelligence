USE BikeStores;
GO

SELECT 
    c.category_name AS Categoria,
    b.brand_name AS Marca,
    p.product_name AS Producto,
    p.model_year AS Año,
    st.store_name AS Sucursal,
    s.quantity AS CantidadInventario,
    p.list_price AS PrecioLista,
    (s.quantity * p.list_price) AS ValorInventario
FROM production.stocks s
INNER JOIN production.products p ON p.product_id = s.product_id
INNER JOIN production.brands b ON b.brand_id = p.brand_id
INNER JOIN production.categories c ON c.category_id = p.category_id
INNER JOIN sales.stores st ON st.store_id = s.store_id
WHERE 
    (@Sucursal IS NULL OR st.store_name = @Sucursal)
    AND (@Categoria IS NULL OR c.category_name = @Categoria)
    AND (@Marca IS NULL OR b.brand_name = @Marca)
ORDER BY 
    st.store_name,
    c.category_name,
    b.brand_name,
    p.product_name;

-- Para parametros:
SELECT DISTINCT store_name 
FROM BikeStores.sales.stores 
ORDER BY store_name;

SELECT DISTINCT category_name 
FROM BikeStores.production.categories 
ORDER BY category_name;

SELECT DISTINCT brand_name 
FROM BikeStores.production.brands 
ORDER BY brand_name;