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
    list_price DECIMAL (10, 2) NOT NULL,
	CONSTRAINT UQ_DimProducts_BK UNIQUE (product_id)
);

CREATE TABLE dbo.DimStores (
    storeKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	store_id INT NOT NULL,
	store_name VARCHAR (255) NOT NULL,
	city VARCHAR (255),
	state VARCHAR (10),
	CONSTRAINT UQ_DimStores_BK UNIQUE (store_id)
);

CREATE TABLE dbo.DimStaffs (
    staffKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	staff_id INT NOT NULL,
    full_name VARCHAR(510) NOT NULL,
	active tinyint NOT NULL,
	store_id INT NOT NULL,
	CONSTRAINT UQ_DimStaffs_BK UNIQUE (staff_id)
);

CREATE TABLE dbo.DimCustomers (
  customerKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	customer_id INT NOT NULL,
  full_name VARCHAR(510) NOT NULL,
	city VARCHAR (50),
	state VARCHAR (25),
	CONSTRAINT UQ_DimCustomers_BK UNIQUE (customer_id)
);

CREATE TABLE dbo.DimOrders (
  OrderKey INT IDENTITY(1,1) PRIMARY KEY,
  order_id INT NOT NULL,
  customer_id INT NULL,
  order_status TINYINT NOT NULL,
  order_date DATE NOT NULL,
  required_date DATE NOT NULL,
  shipped_date DATE NULL,
  store_id INT NOT NULL,
  staff_id INT NOT NULL,
  -- Estos son los nuevos que se tiene que agregar para calcular los montos.
  -- GrossAmount DECIMAL(18,2) NOT NULL, -- Monto Bruto.
  -- DiscountAmount DECIMAL(18,2) NOT NULL, -- Monto con descuento.
  -- NetAmount DECIMAL(18,2) NOT NULL, -- Monto neto.
  CONSTRAINT UQ_DimOrders_BK UNIQUE (order_id)
);

CREATE TABLE dbo.DimStock (
	stockKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	product_id INT NOT NULL,
	store_id INT NOT NULL,
	quantity INT NOT NULL,
	CONSTRAINT UQ_DimStock_BK UNIQUE (product_id, store_id)
);
/*
Diseño estrella en FactOrders
*/

CREATE TABLE dbo.FactOrders (
  SalesKey INT IDENTITY(1,1) PRIMARY KEY,
  ProductKey INT NOT NULL,
  StoreKey INT NOT NULL,
  StaffKey INT NOT NULL,
  CustomerKey INT NOT NULL,
  OrderKey INT NOT NULL,
  OrderDateKey INT NOT NULL,
  RequiredDateKey INT NOT NULL,
  ShippedDateKey INT NULL,
  -- OrderID INT NOT NULL, -- Estos dos no tiene sentido ya que seria una dobre referencia y lo del item ID es espefico de cada producto
                          -- pedido en la orden, y de eso en si al menos en el ejemplo del profe no se usaba.
  -- ItemID INT NOT NULL, -- Ya los datos de este los tomamos al hacer el join en la consulta.
  Quantity INT NOT NULL,
  ListPrice DECIMAL(10,2) NOT NULL,
  Discount DECIMAL(4,2) NOT NULL,
  GrossAmount DECIMAL(18,2) NOT NULL, -- Monto Bruto.
  DiscountAmount DECIMAL(18,2) NOT NULL, -- Monto con descuento.
  NetAmount DECIMAL(18,2) NOT NULL, -- Monto neto.
  OrderCount INT NOT NULL DEFAULT 1,
  --CONSTRAINT UQ_FactOrders_Line UNIQUE (OrderID, ItemID),
  FOREIGN KEY (ProductKey) REFERENCES dbo.DimProducts(ProductKey),
  FOREIGN KEY (StoreKey)   REFERENCES dbo.DimStores(StoreKey),
  FOREIGN KEY (StaffKey)   REFERENCES dbo.DimStaffs(StaffKey),
  FOREIGN KEY (CustomerKey) REFERENCES dbo.DimCustomers(CustomerKey),
  FOREIGN KEY (OrderKey)   REFERENCES dbo.DimOrders(OrderKey),
  FOREIGN KEY (OrderDateKey) REFERENCES dbo.DimDate(DateKey),
  FOREIGN KEY (RequiredDateKey) REFERENCES dbo.DimDate(DateKey),
  FOREIGN KEY (ShippedDateKey) REFERENCES dbo.DimDate(DateKey)
);

-- Tablas para el SCD 2
CREATE TABLE dbo.DimCustomers_Hist (
  customer_id INT NOT NULL,
  full_name VARCHAR(510) NOT NULL,
  city VARCHAR(50) NULL,
  state VARCHAR(25) NULL,
  start_date DATETIME NOT NULL,
  end_date DATETIME NULL
);

CREATE TABLE dbo.DimStaffs_Hist (
  staff_id INT NOT NULL,
  full_name VARCHAR(510) NOT NULL,
  active TINYINT NOT NULL,
  store_id INT NOT NULL,
  start_date DATETIME NOT NULL,
  end_date DATETIME NULL
);