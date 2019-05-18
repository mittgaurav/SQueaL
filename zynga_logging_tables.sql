/*Create logging tables*/

DROP TABLE IF EXISTS user_details;
CREATE TABLE user_details(
id          INT PRIMARY KEY, 
name        VARCHAR (100), 
age         INT, 
language    VARCHAR (100), 
country     VARCHAR (100), 
start_date  DATE
);

DELETE FROM user_details;
INSERT INTO user_details VALUES
                         (1, 'Gaurav', 23, NULL, NULL, '2019-01-01'),
                         (2, 'Rahul',  34, NULL, NULL, '2019-01-01'),
                         (3,  'Ajit',  44, NULL, NULL, '2019-01-11'),
                         (11, 'Abhi',  12, NULL, NULL, '2019-01-05'),
                         (18, 'Ravi',  19, NULL, NULL, '2019-01-23'),
                         (32, 'Alok',  26, NULL, NULL, '2019-02-01'),
                         (35, 'Ajit',  15, NULL, NULL, '2019-02-11');
    
DROP TABLE IF EXISTS clients;
CREATE TABLE clients(
client_id      INT PRIMARY KEY, 
user_id        INT, 
platform_name  VARCHAR (100), 
FOREIGN KEY (user_id) REFERENCES user_details (id) 
);

DELETE FROM clients;
INSERT INTO clients (client_id, user_id, platform_name) VALUES
                    (1, 1,  'iphone'),
                    (2, 2,  'iphone'),
                    (3, 11, 'android'),
                    (4, 1,  'web'),
                    (5, 18, 'android'),
                    (6, 1,  'web'),
                    (7, 2,  'web'),
                    (8, 32, 'android'),
                    (9, 18, 'android'),
                    (10,35, 'web');

DROP TABLE IF EXISTS sessions;
CREATE TABLE sessions(
session_id  INT PRIMARY KEY, 
client_id   INT, 
location_x  INT, 
location_y  INT, 
FOREIGN KEY (client_id) REFERENCES clients (client_id) 
);

DELETE FROM sessions;
INSERT INTO sessions VALUES
                     (10001, 1, 1, 1),
                     (10002, 1, 2, 1),
                     (10003, 2, 1, 2),
                     (10004, 3, 2, 1),
                     (10005, 4, 1, 1),
                     (10006, 5, 2, 2),
                     (10007, 5, 2, 2),
                     (10008, 6, 1, 2),
                     (10009, 7, 1, 2),
                     (10010, 8, 2, 1),
                     (10011, 1, 1, 2),
                     (10012, 9, 2, 2),
                     (10013, 3, 2, 3),
                     (10014, 7, 3, 2),
                     (10015, 1, 3, 2),
                     (10016,10, 3, 3);

DROP TABLE IF EXISTS plays;
CREATE TABLE plays(
session_id  INT, 
level       INT, 
start_time  DATETIME, 
end_time    DATETIME, 
FOREIGN KEY (session_id) REFERENCES sessions (session_id) 
);

DELETE FROM plays;
INSERT INTO plays (session_id, level, start_time, end_time) VALUES
                  (10001, 1, datetime('2019-01-01 08:00:00.000'), NULL), 
                  (10001, 2, datetime('2019-01-15 09:00:00.000'), NULL), 
                  (10002, 1, datetime('2019-01-11 18:00:00.000'), NULL), 
                  (10003, 1, datetime('2019-01-21 08:00:00.000'), NULL), 
                  (10004, 1, datetime('2019-01-21 02:00:00.000'), NULL), 
                  (10004, 1, datetime('2019-01-21 04:00:00.000'), NULL), 
                  (10004, 2, datetime('2019-01-21 18:00:00.000'), NULL), 
                  (10004, 2, datetime('2019-01-21 20:00:00.000'), NULL), 
                  (10005, 1, datetime('2019-01-22 08:00:00.000'), NULL), 
                  (10006, 1, datetime('2019-01-23 02:00:00.000'), NULL), 
                  (10006, 1, datetime('2019-01-23 08:00:00.000'), NULL), 
                  (10007, 1, datetime('2019-01-25 08:00:00.000'), NULL), 
                  (10008, 1, datetime('2019-01-30 08:00:00.000'), NULL), 
                  (10009, 1, datetime('2019-02-02 08:00:00.000'), NULL), 
                  (10010, 1, datetime('2019-02-10 08:00:00.000'), NULL), 
                  (10011, 3, datetime('2019-02-11 03:00:00.000'), NULL), 
                  (10011, 3, datetime('2019-02-11 18:00:00.000'), NULL), 
                  (10011, 4, datetime('2019-02-15 08:00:00.000'), NULL), 
                  (10012, 1, datetime('2019-02-21 08:00:00.000'), NULL), 
                  (10013, 3, datetime('2019-02-21 08:00:00.000'), NULL), 
                  (10011, 4, datetime('2019-02-21 16:00:00.000'), NULL), 
                  (10010, 1, datetime('2019-02-21 18:00:00.000'), NULL), 
                  (10010, 2, datetime('2019-02-24 18:00:00.000'), NULL), 
                  (10014, 1, datetime('2019-02-25 18:00:00.000'), NULL), 
                  (10015, 2, datetime('2019-02-26 18:00:00.000'), NULL), 
                  (10016, 1, datetime('2019-02-28 18:00:00.000'), NULL);

UPDATE plays
   SET end_time = datetime(start_time, '+10 minutes')
 WHERE level = 3;
UPDATE plays
   SET end_time = datetime(start_time, '+15 minutes') 
 WHERE level = 4;
UPDATE plays
   SET end_time = datetime(start_time, '+1 minutes') 
 WHERE level = 1;
UPDATE plays
   SET end_time = datetime(start_time, '+2 minutes') 
 WHERE level = 2;
UPDATE plays
   SET end_time = datetime(end_time, '+1 minutes') 
 WHERE session_id > 10005;
UPDATE plays
   SET end_time = datetime(end_time, '+1 minutes') 
 WHERE session_id > 10008;
UPDATE plays
   SET end_time = datetime(end_time, '-1 minutes') 
 WHERE session_id > 10012;