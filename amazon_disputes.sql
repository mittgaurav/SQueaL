DROP TABLE IF EXISTS users;
CREATE TEMPORARY TABLE users(
id INT PRIMARY KEY
);

INSERT INTO users VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10);

DROP TABLE IF EXISTS sellers;
CREATE TEMPORARY TABLE sellers(
id INT PRIMARY KEY
);

INSERT INTO sellers VALUES (1), (2), (3), (4), (5), (6);

DROP TABLE IF EXISTS sales;
CREATE TEMPORARY TABLE sales(
id        INT PRIMARY KEY, 
user_id   INT,
seller_id INT,
FOREIGN KEY (user_id) REFERENCES users (id),
FOREIGN KEY (seller_id) REFERENCES sellers (id)
);

INSERT INTO sales VALUES
                  (1, 1, 1), 
                  (2, 1, 1), 
                  (4, 2, 1), 
                  (3, 3, 1), 
                  (5, 3, 2), 
                  (6, 4, 2), 
                  (7, 5, 4), 
                  (8, 6, 3), 
                  (9, 9, 6), 
                  (10, 2, 4), 
                  (11, 1, 1), 
                  (12, 1, 2), 
                  (14, 2, 3), 
                  (13, 3, 3), 
                  (15, 3, 2), 
                  (16, 4, 2), 
                  (17, 5, 4), 
                  (18, 6, 3), 
                  (19, 7, 6), 
                  (20, 3, 4),
                  (21, 1, 6), 
                  (22, 2, 4), 
                  (24, 2, 5), 
                  (23, 2, 2), 
                  (25, 2, 1), 
                  (26, 7, 1), 
                  (27, 5, 1), 
                  (28, 7, 3), 
                  (29, 9, 6);

DROP TABLE IF EXISTS disputes;
CREATE TEMPORARY TABLE disputes(
id            INT PRIMARY KEY, 
sale_id       INT, 
date          DATE, 
response_date DATE, 
FOREIGN KEY (sale_id) REFERENCES sales (id)
);

INSERT INTO disputes VALUES
                     (1, 2, DATE('2019-01-01'), DATE('2019-01-01') ), 
                     (2, 2, DATE('2019-01-02'), DATE('2019-02-08') ), 
                     (3, 5, DATE('2019-01-05'), DATE('2019-01-08') ), 
                     (4, 6, DATE('2019-01-10'), NULL), 
                     (5, 10, DATE('2019-01-11'), DATE('2019-01-11') ), 
                     (6, 10, DATE('2019-01-12'), DATE('2019-01-15') ), 
                     (7, 11, DATE('2019-01-15'), DATE('2019-01-18') ), 
                     (8, 12, DATE('2019-01-28'), DATE('2019-01-28') ), 
                     (9, 10, DATE('2019-01-25'), NULL), 
                     (10, 15, DATE('2019-01-28'), DATE('2019-02-29') ), 
                     (11, 12, DATE('2019-02-01'), DATE('2019-02-01') ), 
                     (12, 12, DATE('2019-02-02'), NULL), 
                     (13, 15, DATE('2019-02-02'), DATE('2019-02-08') ), 
                     (14, 16, DATE('2019-02-10'), NULL), 
                     (15, 20, DATE('2019-02-11'), DATE('2019-02-11') ), 
                     (16, 20, DATE('2019-02-12'), DATE('2019-02-15') ), 
                     (17, 2, DATE('2019-02-15'), NULL), 
                     (18, 22, DATE('2019-02-22'), NULL), 
                     (19, 20, DATE('2019-02-25'), NULL), 
                     (20, 25, DATE('2019-02-28'), DATE('2019-03-29') ), 
                     (21, 12, DATE('2019-03-01'), NULL), 
                     (22, 19, DATE('2019-03-05'), NULL), 
                     (23, 5, DATE('2019-03-05'), NULL), 
                     (24, 15, DATE('2019-03-05'), DATE('2019-03-08') ), 
                     (25, 26, DATE('2019-03-10'), NULL),
                     (26, 29, DATE('2019-03-10'), NULL);

-- open disputes
SELECT julianday(date('2019-03-11') ) - julianday(date) AS days, count(1) count
  FROM disputes
 WHERE response_date IS NULL
 GROUP BY days
 ORDER BY count;

-- avg time to answer
SELECT seller_id, count(DISTINCT
                      CASE
                          WHEN response_date IS NULL THEN NULL
                          ELSE disputes.id
                      END) resolved,
                  avg(CASE 
                          WHEN response_date IS NULL THEN NULL 
                          ELSE julianday(response_date) - julianday(date) 
                      END) avg_resolution_time,
                  count(CASE 
                            WHEN response_date IS NULL THEN 1 
                            ELSE NULL 
                        END) open,
                  avg(CASE 
                            WHEN response_date IS NULL THEN julianday('2019-03-15') - julianday(date)
                            ELSE NULL 
                        END) avg_open_time,
                  count(sale_id) total
  FROM disputes
       INNER JOIN sales ON sale_id = sales.id
 GROUP BY seller_id;

-- dispute rate - dispute per sale
SELECT seller_id, count(DISTINCT sale_id) disputed, count(distinct sales.id) total
  FROM sales
       LEFT JOIN disputes 
         ON sales.id = sale_id
 GROUP BY seller_id;

-- win ratio: resolved disputes
-- without second dispute
WITH wins AS
(SELECT sale_id
   FROM disputes
  GROUP BY sale_id
 HAVING count(1) = 1 and response_date IS NOT NULL)
SELECT *
  FROM wins;

-- status of disputes:
-- * if we haven't heard
-- from users, then it's
-- a win. Otherwise, if
-- we haven't replied in
-- over a week, it's loss.
-- * Then there are cases
-- with multiple disputes
-- i.e. negotiations. And
-- case of no response for
-- a week; assume ongoing.
SELECT sale_id, (CASE 
                     WHEN count(1) = 1 AND response_date IS NOT NULL THEN 'won' 
                     WHEN avg(response_date) IS NOT NULL THEN 'negotiated'
                     WHEN julianday('2019-03-15') - julianday(date) < 7 THEN 'ongoing'
                     ELSE 'lost'
                 END) status
  FROM disputes
 GROUP BY sale_id;
