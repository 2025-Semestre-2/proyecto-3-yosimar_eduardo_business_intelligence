select 
    OS.order_id,
    OS.customer_id,
    OS.order_status,
    OS.order_date,
    OS.required_date,
    OS.shipped_date,
    OS.store_id,
    OS.staff_id,
    OIS.product_id,
    OIS.quantity,
    OIS.list_price,
    OIS.discount,

	-- Calculo de las cosas con descuento.
	--SUM(OIS.quantity) AS CantProducts,
	(OIS.quantity * OIS.list_price) AS GrossAmount,
	(OIS.quantity * OIS.list_price * OIS.discount) AS DiscountAmount,
	--SUM( OIS.quantity * OIS.list_price - OIS.discount + ((OIS.quantity * OIS.list_price - OIS.discount) * 0.13)) AS NetAmount
    ((OIS.quantity * OIS.list_price)- (OIS.quantity * OIS.list_price * OIS.discount)) AS NetAmount
from sales.orders_stage OS
join sales.order_items_stage OIS ON OS.order_id = OIS.order_id;



SELECT 
    SS.staff_id,
    SS.full_name,
    SS.active,
    SS.store_id,
    SST.store_name
FROM sales.staffs_stage SS
join sales.stores_stage SST ON SS.store_id = SST.store_id;


-- Para los Productos.

