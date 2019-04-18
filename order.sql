CREATE TABLE orders
(OrderID VARCHAR (10),
 Item VARCHAR (10),
 qty INT);

CREATE TABLE products
(Order_Day  [DATETIME],
 ORDER_ID   [NVARCHAR] (50),
 Product_Id [NVARCHAR] (10),
 Quantity   [INT],
 Price      [INT]);

INSERT INTO orders
                   (OrderID, Item, qty)
                   VALUES
                   ('O1', 'A1', 5), 
                   ('O2', 'A2', 1), 
                   ('O3', 'A3', 3);

INSERT INTO products
                     (Order_Day, ORDER_ID, Product_Id, Quantity, Price)
                     VALUES
                     (datetime('2011-07-01 00:00:00.000'), 'O1', 'P1', 5, 5), 
                     (datetime('2011-07-01 00:00:00.000'), 'O2', 'P2', 2, 10), 
                     (datetime('2011-07-01 00:00:00.000'), 'O3', 'P3', 10, 25), 
                     (datetime('2011-07-01 00:00:00.000'), 'O4', 'P1', 20, 5), 
                     (datetime('2011-07-02 00:00:00.000'), 'O5', 'P3', 5, 25), 
                     (datetime('2011-07-02 00:00:00.000'), 'O6', 'P4', 6, 20), 
                     (datetime('2011-07-02 00:00:00.000'), 'O7', 'P1', 2, 5), 
                     (datetime('2011-07-02 00:00:00.000'), 'O8', 'P5', 1, 50), 
                     (datetime('2011-07-02 00:00:00.000'), 'O9', 'P6', 2, 50), 
                     (datetime('2011-07-02 00:00:00.000'), 'O10', 'P2', 4, 10),
                     (datetime('2011-07-02 00:00:00.000'), 'O1', 'P4', 5, 5);
                     
-- select products and total quantities
-- that were sold on two different days 
SELECT Product_Id, sum(Quantity) 
  FROM products
 GROUP BY Product_Id
HAVING count(DISTINCT Order_Day) = 2;

-- select products that were
-- sold on 2nd but not on 1st
SELECT Product_Id, Order_Day
  FROM products
 WHERE Order_Day = datetime('2011-07-02') AND 
       Product_Id NOT IN
       (SELECT Product_Id
          FROM products
         WHERE Order_Day = datetime('2011-07-01'));
 
-- get highest sales for each
-- day; i.e. quantity * price
SELECT X.Order_Day, X.Product_Id, max(X.s) 
  FROM
       (SELECT Order_Day, Product_Id, sum(Quantity * Price) S
          FROM products
         GROUP BY Order_Day, Product_Id)
       X
 GROUP BY x.Order_Day;
 
-- total sales for a product
-- side by side for each day 
SELECT Product_Id, d1, d2
  FROM
       (SELECT Product_Id, sum(Quantity * Price) AS d2
          FROM products
         WHERE Order_Day = datetime('2011-07-02') 
         GROUP BY Product_Id)
       X
       LEFT OUTER JOIN -- FULL OUTER JOIN
       (SELECT Product_Id, sum(Quantity * Price) AS d1
          FROM products
         WHERE Order_Day = datetime('2011-07-01') 
         GROUP BY Product_Id)
       Y ON X.Product_Id = Y.Product_Id;
       
-- show products that were
-- bought > once on a day
SELECT Order_Day, Product_Id
  FROM products
 GROUP BY Order_Day, Product_Id
HAVING count(*) > 1;
