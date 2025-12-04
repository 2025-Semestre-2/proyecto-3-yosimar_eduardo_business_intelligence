/*
--------------------------------------------------------------------
© 2025 Microsoft Corporation. All rights reserved.
--------------------------------------------------------------------
Name   : BikeStores_DW
Version: 1.0
--------------------------------------------------------------------
*/
CREATE DATABASE BikeStores_DW;
go

USE BikeStores_DW;
go

/*
------------------------------------------------------------------------------------------------------------
Creación de tablas de Data Warehouse
------------------------------------------------------------------------------------------------------------
Estas tablas van a estar enfocadas en solo los datos necesesarios para el ETL.
El cual busca satisfacer la necesidad de analizar las ventas de BikeStores, tomando en cuenta lo siguiente:
• Conocer las cantidades de productos vendidos
• Totales de las ventas
• Conocer el total pagado en concepto de descuentos
• Cantidad de facturas emitidas
• Identificar las fechas de emisión de la orden, requerido y de envío
--------------------------------------------------------------------------------------------
Especificamente en este modelo de Data Warehouse se requiere:
• Modelar las dimensiones de tienda, empleados, productos, órdenes, clientes y de inventario 

------------------------------------------------------------------------------------------------------------
*/

CREATE TABLE dbo.DimProducts (
    productKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	product_id INT IDENTITY (1, 1) NOT NULL,
	product_name VARCHAR (255) NOT NULL,
    category_id INT NOT NULL,
    category_name VARCHAR (255) NOT NULL,
    brand_id INT NOT NULL,
    brand_name VARCHAR (255) NOT NULL,
    model_year SMALLINT NOT NULL,
    list_price DECIMAL (10, 2) NOT NULL
)

CREATE TABLE dbo.DimStores (
    storeKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	store_id INT PRIMARY KEY,
	store_name VARCHAR (255) NOT NULL,
	city VARCHAR (255),
	state VARCHAR (10)
)

CREATE TABLE dbo.DimStaffs (
    staffKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	staff_id INT NOT NULL,
    full_name VARCHAR(500) NOT NULL,
	active tinyint NOT NULL,
	store_id INT NOT NULL
)

CREATE TABLE dbo.DimCustomers (
    customerKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	customer_id INT NOT NULL,
    full_name VARCHAR(500) NOT NULL,
	city VARCHAR (50),
	state VARCHAR (25)
)

CREATE TABLE dbo.DimOrders (
    orderKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	order_id INT NOT NULL,
	customer_id INT,
	order_status tinyint NOT NULL,
	order_date DATE NOT NULL,
	required_date DATE NOT NULL,
	shipped_date DATE,
	store_id INT NOT NULL,
	staff_id INT NOT NULL
)

/*
Diseño estrella en FactOrders
*/

CREATE TABLE dbo.FactOrders (
    
)