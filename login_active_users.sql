/*
ETL user login logs into login fact table.
Find KPIs related to growth (such as DAU,
MAU) and engagement (duration per session
and duration moving average).
*/

-- user details
DROP TABLE logins;
DROP TABLE user_details;
CREATE TABLE user_details(
id          INT, 
name        VARCHAR (100),
location_id INT, 
start_date  DATE, 
PRIMARY KEY (id)
);

INSERT INTO user_details VALUES
                         (1, 'Gaurav', 23, date('2019-01-01') ), 
                         (2, 'Rahul', 234, date('2019-01-01') ), 
                         (11, 'Abhi', 123, date('2019-01-05') ), 
                         (18, 'Ravi', 123, date('2019-01-23') ), 
                         (32, 'Alok', 123, date('2019-02-01') ), 
                         (3,  'Ajit', 234, date('2019-02-11') );

-- login times and other values
-- transactional facts
CREATE TABLE logins(
session_id  INT      PRIMARY KEY, 
user_id     INT, 
location_id INT, 
login       DATETIME NOT NULL,
logout      DATETIME, 
FOREIGN KEY (user_id) REFERENCES user_details (id) 
);

INSERT INTO logins VALUES
                   (100114, 1, 123,  datetime('2019-01-01 08:00:00.000'), NULL), 
                   (100061, 11, 123, datetime('2019-01-15 08:00:00.000'), NULL),
                   (100011, 11, 123, datetime('2019-01-11 18:00:00.000'), NULL), 
                   (100001, 1, 234,  datetime('2019-01-21 08:00:00.000'), NULL), 
                   (130001, 11, 234, datetime('2019-01-21 08:00:00.000'), NULL), 
                   (135001, 11, 234, datetime('2019-01-21 04:00:00.000'), NULL), 
                   (103001, 11, 23,  datetime('2019-01-21 18:00:00.000'), NULL), 
                   (100401, 18, 23,  datetime('2019-01-21 08:00:00.000'), NULL), 
                   (110001, 18, 234, datetime('2019-01-21 08:00:00.000'), NULL), 
                   (100111, 1, 23,   datetime('2019-01-22 02:00:00.000'), NULL), 
                   (100008, 1, 23,   datetime('2019-01-22 08:00:00.000'), NULL), 
                   (100015, 18, 123, datetime('2019-01-25 08:00:00.000'), NULL), 
                   (100103, 18, 123, datetime('2019-01-30 08:00:00.000'), NULL), 
                   (101111, 1, 23,   datetime('2019-02-02 08:00:00.000'), NULL), 
                   (100112, 18, 123, datetime('2019-02-10 08:00:00.000'), NULL), 
                   (100031, 11, 123, datetime('2019-02-11 03:00:00.000'), NULL), 
                   (100009, 2, 234,  datetime('2019-02-11 18:00:00.000'), NULL), 
                   (111111, 1, 23,   datetime('2019-02-15 08:00:00.000'), NULL),
                   (100002, 3, 234,  datetime('2019-02-21 08:00:00.000'), NULL), 
                   (100003, 3, 234,  datetime('2019-02-21 08:00:00.000'), NULL), 
                   (100004, 3, 234,  datetime('2019-02-21 16:00:00.000'), NULL), 
                   (100005, 1, 23,   datetime('2019-02-21 18:00:00.000'), NULL), 
                   (100006, 1, 23,   datetime('2019-02-24 18:00:00.000'), NULL), 
                   (100007, 1, 23,   datetime('2019-02-25 18:00:00.000'), NULL),
                   (100102, 11, 123, datetime('2019-02-28 18:00:00.000'), NULL);

-- this will require python 
-- layer to track live conn
-- and update these values.
UPDATE logins
   SET logout = datetime(login, '+10 minutes')
 WHERE location_id = 23;
UPDATE logins
   SET logout = datetime(login, '+5 minutes') 
 WHERE location_id = 123;
UPDATE logins
   SET logout = datetime(login, '+1 minutes') 
 WHERE location_id = 234;

-- reduced dimension login facts
DROP TABLE login_fact;
CREATE TABLE login_fact(
date        DATE,
user_id     int,
location_id int,
duration    int
);

INSERT INTO login_fact
SELECT strftime('%Y-%m-%d', login) AS date, user_id, location_id, 
   sum(strftime('%s', logout) - strftime('%s', login)) AS duration
  FROM logins
 GROUP BY date, user_id, location_id;

/*
single table metrics
*/
-- DAU by date
SELECT date, count(DISTINCT user_id) AS DAU
  FROM login_fact
 GROUP BY date;
-- MAU by month
select strftime('%Y-%m', date) as month, count(DISTINCT user_id) AS MAU
  FROM login_fact
 GROUP BY strftime('%Y-%m', date);
-- DAU and total length of sessions
SELECT date, count(DISTINCT user_id) AS dau, sum(duration) duration
  FROM login_fact
 GROUP BY date;
-- average time per day per user (Engagement)
SELECT date, sum(duration) time, count(user_id) users, sum(duration) / count(user_id) average
  FROM login_fact
 GROUP BY date;

/*
-- moving average
SELECT date, avg(duration) over (ORDER BY date ASC rows 9 PRECEDING)
ROM login_fact;
*/

-- with
WITH aggregate AS
(SELECT date, location_id, sum(duration) time, count(user_id) count
   FROM login_fact
  GROUP BY date, location_id)
SELECT date, sum(time) time, sum(count) count, sum(time) / sum(count)  average
  FROM aggregate
 GROUP BY date;
WITH aggregate AS
(SELECT date, location_id, sum(duration) time, count(user_id) count
   FROM login_fact
  GROUP BY date, location_id)
SELECT location_id, sum(time) time, sum(count) count, sum(time) / sum(count) average
  FROM aggregate
 GROUP BY location_id;

/*
join with calendar to get missing dates
as well. Also, gets daily WAU or MAU too
*/
SELECT calendar.date, count(DISTINCT user_id) AS DAU
  FROM calendar
       LEFT JOIN login_fact ON calendar.date = login_fact.date
 GROUP BY calendar.date;
SELECT calendar.month, count(DISTINCT user_id) AS MAU
  FROM calendar
       LEFT JOIN login_fact
       ON calendar.date = login_fact.date
 GROUP BY calendar.month;
-- weekly users
SELECT calendar.date, count(DISTINCT user_id) AS WAU
  FROM calendar
       LEFT JOIN login_fact
       ON login_fact.date BETWEEN DATE(calendar.date, '-7 days') AND calendar.date
 GROUP BY calendar.date;
