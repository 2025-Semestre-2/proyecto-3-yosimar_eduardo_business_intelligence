/*
--------------------------------------------------------------------
© 2025 Microsoft Corporation. All rights reserved.
--------------------------------------------------------------------
Name   : BikeStores_Stage
Version: 1.0
--------------------------------------------------------------------
*/
CREATE DATABASE BikeStores_Stage;
go

USE BikeStores_Stage;
go

-- Crear schemas de bikestores
CREATE SCHEMA production;
go

CREATE SCHEMA sales;
go

/*
------------------------------------------------------------------------------------------------------------
Creación de tablas de staging
------------------------------------------------------------------------------------------------------------
Estas tablas van a estar enfocadas en solo los datos necesesarios para el ETL.
El cual busca satisfacer la necesidad de analizar las ventas de BikeStores, tomando en cuenta lo siguiente:
• Conocer las cantidades de productos vendidos
• Totales de las ventas
• Conocer el total pagado en concepto de descuentos
• Cantidad de facturas emitidas
• Identificar las fechas de emisión de la orden, requerido y de envío
--------------------------------------------------------------------------------------------
Adicionalmente para el DW se requiere:
• Modelar las dimensiones de tienda, empleados, productos, órdenes, clientes y de inventario 

------------------------------------------------------------------------------------------------------------
*/

CREATE TABLE production.categories_stage (
    category_id INT PRIMARY KEY,
    category_name VARCHAR (255) NOT NULL
);

CREATE TABLE production.brands_stage (
    brand_id INT PRIMARY KEY,
    brand_name VARCHAR (255) NOT NULL
);

CREATE TABLE production.products_stage (
    product_id INT PRIMARY KEY,
    product_name VARCHAR (255) NOT NULL,
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    model_year SMALLINT NOT NULL,
    list_price DECIMAL (10, 2) NOT NULL
);

CREATE TABLE sales.customers_stage (
	customer_id INT PRIMARY KEY,
    full_name VARCHAR(510) NOT NULL,
	city VARCHAR (50),
	state VARCHAR (25)
);

CREATE TABLE sales.stores_stage (
	store_id INT PRIMARY KEY,
	store_name VARCHAR (255) NOT NULL,
	city VARCHAR (255),
	state VARCHAR (10)
);

CREATE TABLE sales.staffs_stage (
	staff_id INT PRIMARY KEY,
    full_name VARCHAR(510) NOT NULL,
	active tinyint NOT NULL,
	store_id INT NOT NULL
);


CREATE TABLE sales.orders_stage (
	order_id INT PRIMARY KEY,
	customer_id INT,
	order_status tinyint NOT NULL,
	order_date DATE NOT NULL,
	required_date DATE NOT NULL,
	shipped_date DATE,
	store_id INT NOT NULL,
	staff_id INT NOT NULL
);

CREATE TABLE sales.order_items_stage (
	order_id INT,
	item_id INT,
	product_id INT NOT NULL,
	quantity INT NOT NULL,
	list_price DECIMAL (10, 2) NOT NULL,
	discount DECIMAL (4, 2) NOT NULL DEFAULT 0
);

CREATE TABLE production.stocks_stage (
	store_id INT,
	product_id INT,
	quantity INT
);