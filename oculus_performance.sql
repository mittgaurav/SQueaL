CREATE TEMPORARY TABLE performance(
session_id INT, 
content_id INT, 
time       DATETIME, 
fps        INT, 
lag        INT
);

INSERT INTO performance VALUES
                        (1, 1, datetime('2019-01-01 08:00:00.000'), 60, 10), 
                        (1, 1, datetime('2019-01-01 08:00:01.000'), 61, 12), 
                        (1, 1, datetime('2019-01-01 08:00:02.000'), 50, 1), 
                        (1, 1, datetime('2019-01-01 08:00:03.000'), 70, 1), 
                        (1, 2, datetime('2019-01-01 08:00:04.000'), 30, 20), 
                        (1, 1, datetime('2019-01-01 08:00:05.000'), 80, 14), 
                        (1, 2, datetime('2019-01-01 08:00:06.000'), 50, 34), 
                        (1, 2, datetime('2019-01-01 08:00:07.000'), 50, 16), 
                        (1, 2, datetime('2019-01-01 08:00:08.000'), 50, 23), 
                        (1, 2, datetime('2019-01-01 08:00:09.000'), 50, 1), 
                        (1, 1, datetime('2019-01-01 08:00:10.000'), 60, 5), 
                        (1, 1, datetime('2019-01-01 08:00:11.000'), 60, 40), 
                        (1, 1, datetime('2019-01-01 08:00:12.000'), 50, 40), 
                        (1, 1, datetime('2019-01-01 08:00:13.000'), 65, 10), 
                        (2, 1, datetime('2019-01-01 08:00:00.000'), 60, 10), 
                        (2, 1, datetime('2019-01-01 08:00:10.000'), 65, 0), 
                        (2, 1, datetime('2019-01-01 08:00:20.000'), 60, 0), 
                        (2, 1, datetime('2019-01-01 08:00:20.000'), 60, 10), 
                        (2, 1, datetime('2019-01-01 08:00:30.000'), 65, 0), 
                        (2, 2, datetime('2019-01-01 08:00:34.000'), 60, 0), 
                        (2, 2, datetime('2019-01-01 08:00:35.000'), 40, 10), 
                        (2, 2, datetime('2019-01-01 08:00:40.000'), 65, 12), 
                        (2, 1, datetime('2019-01-01 08:00:45.000'), 70, 1), 
                        (2, 1, datetime('2019-01-01 08:00:50.000'), 60, 10), 
                        (2, 1, datetime('2019-01-01 08:00:51.000'), 65, 0), 
                        (2, 1, datetime('2019-01-01 08:00:20.000'), 60, 0), 
                        (3, 2, datetime('2019-01-01 08:00:00.000'), 60, 10), 
                        (3, 2, datetime('2019-01-01 08:00:01.000'), 61, 12), 
                        (3, 2, datetime('2019-01-01 08:00:02.000'), 50, 1), 
                        (3, 2, datetime('2019-01-01 08:00:03.000'), 70, 1), 
                        (3, 2, datetime('2019-01-01 08:00:04.000'), 30, 20), 
                        (3, 1, datetime('2019-01-01 08:00:05.000'), 82, 14), 
                        (3, 2, datetime('2019-01-01 08:00:06.000'), 52, 34), 
                        (3, 2, datetime('2019-01-01 08:00:07.000'), 50, 16), 
                        (3, 2, datetime('2019-01-01 08:00:08.000'), 58, 23), 
                        (3, 2, datetime('2019-01-01 08:00:09.000'), 50, 1), 
                        (3, 2, datetime('2019-01-01 08:00:10.000'), 60, 5), 
                        (3, 2, datetime('2019-01-01 08:00:11.000'), 60, 40), 
                        (3, 2, datetime('2019-01-01 08:00:12.000'), 55, 40), 
                        (3, 2, datetime('2019-01-01 08:00:13.000'), 65, 10), 
                        (3, 2, datetime('2019-01-01 08:00:08.000'), 50, 23), 
                        (3, 2, datetime('2019-01-01 08:00:09.000'), 50, 1), 
                        (3, 1, datetime('2019-01-01 08:00:10.000'), 60, 5), 
                        (3, 1, datetime('2019-01-01 08:00:11.000'), 60, 40), 
                        (3, 1, datetime('2019-01-01 08:00:12.000'), 50, 40), 
                        (3, 1, datetime('2019-01-01 08:00:13.000'), 60, 10), 
                        (3, 1, datetime('2019-01-01 08:00:00.000'), 40, 10), 
                        (3, 1, datetime('2019-01-01 08:00:10.000'), 78, 20), 
                        (3, 1, datetime('2019-01-01 08:00:20.000'), 60, 30), 
                        (3, 1, datetime('2019-01-01 08:00:20.000'), 66, 10), 
                        (3, 1, datetime('2019-01-01 08:00:30.000'), 65, 10), 
                        (3, 2, datetime('2019-01-01 08:00:32.000'), 90, 0), 
                        (3, 2, datetime('2019-01-01 08:00:33.000'), 40, 10), 
                        (3, 2, datetime('2019-01-01 08:00:41.000'), 65, 12), 
                        (3, 1, datetime('2019-01-01 08:00:45.000'), 70, 1), 
                        (4, 1, datetime('2019-01-01 08:00:46.000'), 62, 10), 
                        (4, 1, datetime('2019-01-01 08:00:34.000'), 65, 0), 
                        (4, 1, datetime('2019-01-01 08:00:20.000'), 60, 0), 
                        (4, 2, datetime('2019-01-01 08:00:00.000'), 50, 10), 
                        (4, 2, datetime('2019-01-01 08:00:01.000'), 63, 12), 
                        (4, 2, datetime('2019-01-01 08:00:02.000'), 58, 1), 
                        (4, 2, datetime('2019-01-01 08:00:03.000'), 60, 1);

SELECT strftime('%s', time), content_id, avg(fps), avg(lag)
  FROM performance
 GROUP BY strftime('%s', time), content_id;
