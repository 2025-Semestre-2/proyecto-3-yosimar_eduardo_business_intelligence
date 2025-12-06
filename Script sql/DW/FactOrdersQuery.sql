USE BikeStores_Stage;
go

SELECT
    oi.order_id,
    oi.item_id,
    oi.product_id,
    oi.quantity,
    oi.list_price,
    oi.discount,
    o.customer_id,
    o.store_id,
    o.staff_id,
    o.order_date,
    o.required_date,
    o.shipped_date
FROM sales.order_items_stage oi
JOIN sales.orders_stage o
  ON o.order_id = oi.order_id;