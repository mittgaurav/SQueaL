-- user details
DROP TABLE user_details;
CREATE TABLE user_details(
id          INT, 
name        VARCHAR (100),
location_id INT, 
start_date  DATE, 
PRIMARY KEY (id)
);

INSERT INTO user_details VALUES
                         (1, 'Gaurav', 23, date('2018-01-01') ), 
                         (2, 'Rahul', 234, date('2019-01-01') ), 
                         (11, 'Abhi', 123, date('2016-07-01') ), 
                         (18, 'Ravi', 123, date('2014-01-01') ), 
                         (32, 'Alok', 123, date('2013-07-01') ), 
                         (3,  'Ajit', 234, date('2015-03-01') );

-- login times and other values
-- transactional facts
DROP TABLE logins;
CREATE TABLE logins(
session_id  INT      PRIMARY KEY, 
user_id     INT, 
location_id INT, 
login       DATETIME NOT NULL,
logout      DATETIME, 
FOREIGN KEY (user_id) REFERENCES user_details (id) 
);

INSERT INTO logins VALUES
                   (100001, 1, 234,  datetime('2019-01-21 08:00:00.000'), NULL), 
                   (130001, 11, 234, datetime('2019-01-21 08:00:00.000'), NULL), 
                   (103001, 11, 23,  datetime('2019-01-21 18:00:00.000'), NULL), 
                   (100401, 18, 23,  datetime('2019-01-21 08:00:00.000'), NULL), 
                   (110001, 1, 234,  datetime('2019-01-21 08:00:00.000'), NULL), 
                   (100002, 1, 234,  datetime('2019-02-21 08:00:00.000'), NULL), 
                   (100003, 1, 234,  datetime('2019-03-21 08:00:00.000'), NULL), 
                   (100004, 1, 234,  datetime('2019-04-21 02:00:00.000'), NULL), 
                   (100005, 1, 23,   datetime('2019-04-21 18:00:00.000'), NULL), 
                   (100006, 1, 23,   datetime('2019-04-29 18:00:00.000'), NULL), 
                   (100007, 1, 23,   datetime('2019-05-02 18:00:00.000'), NULL), 
                   (100008, 1, 23,   datetime('2018-02-22 08:00:00.000'), NULL), 
                   (100009, 2, 234,  datetime('2019-02-11 18:00:00.000'), NULL), 
                   (100011, 11, 123, datetime('2018-04-11 18:00:00.000'), NULL), 
                   (100111, 1, 23,   datetime('2018-12-22 02:00:00.000'), NULL), 
                   (101111, 1, 23,   datetime('2019-02-02 08:00:00.000'), NULL), 
                   (100031, 11, 123, datetime('2018-04-01 03:00:00.000'), NULL), 
                   (100102, 11, 123, datetime('2018-11-01 18:00:00.000'), NULL), 
                   (100103, 18, 123, datetime('2018-04-01 08:00:00.000'), NULL), 
                   (100114, 18, 123, datetime('2016-04-01 08:00:00.000'), NULL), 
                   (100015, 18, 123, datetime('2018-03-01 08:00:00.000'), NULL), 
                   (100112, 18, 123, datetime('2018-04-01 08:00:00.000'), NULL), 
                   (111111, 1, 23,   datetime('2019-05-01 08:00:00.000'), NULL), 
                   (100061, 11, 123, datetime('2017-04-01 08:00:00.000'), NULL);

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
SELECT strftime('%Y-%m-%d', login) AS date, user_id, location_id, sum(strftime('%s', logout) - strftime('%s', login)) AS duration
  FROM logins
 GROUP BY date, user_id, location_id;

-- DAU by date
SELECT date, count(DISTINCT user_id) AS DAU
  FROM login_fact
 GROUP BY date;
-- MAU by month
select strftime('%Y-%m', date) as month, count(DISTINCT user_id) AS MAU
  FROM login_fact
 GROUP BY strftime('%Y-%m', date);