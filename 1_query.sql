prompt "Query duality view"

SELECT * FROM orders_dv;

prompt "Insert via duality view"
INSERT INTO orders_dv VALUES ('{
  "name":"Carol",
  "email":"carol@example.com",
  "orders":[{
             "status":"NEW",
             "items":[{
                       "sku":"SKU-500",
                       "quantity":2,
                       "unitPrice":15.5
                      }]
            }]
}');
COMMIT;

prompt "Query duality view & tables"
select * from orders_dv;
select * from customers;
select * from orders;
select * from order_items;

prompt "Update via duality view"

UPDATE orders_dv dv  SET data = json_transform(DATA, SET '$.orders[0].status' = 'SHIPPED')
WHERE dv.data.name = 'Carol';
COMMIT;

prompt "Query duality view & tables"

select * from orders_dv;
select * from customers;
select * from orders;
select * from order_items;

prompt "Delete via duality view"

DELETE FROM orders_dv dv WHERE dv.DATA.name = 'Carol';

prompt "Query duality view & tables"

select * from orders_dv;
select * from customers;
select * from orders;
select * from order_items;

prompt "Read Only Duality view"

CREATE or replace JSON RELATIONAL DUALITY VIEW orders_dv AS
  customers 
    {
      _id        : customer_id,
      name       : name,
      email      : email,
      phone      : phone,
      created_at : created_at,
      orders : orders 
        {
          _id       : order_id,
          orderDate : order_date,
          status    : status,
          items : order_items  
            {
              _id       : order_item_id,
              sku       : product_sku,
              quantity  : qty,
              unitPrice : unit_price
            }
        }
    };
    
INSERT INTO orders_dv VALUES ('{
  "name":"Carol",
  "email":"carol@example.com",
  "orders":[{
             "status":"NEW",
             "items":[{
                       "sku":"SKU-500",
                       "quantity":2,
                       "unitPrice":15.5
                      }]
            }]
}');
COMMIT;    

prompt "test done."
