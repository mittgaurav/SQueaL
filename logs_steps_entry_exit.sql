DROP TABLE IF EXISTS step_entry_exit;
CREATE TABLE step_entry_exit
(Session_ID INT, 
 step INT,
 time DATETIME,
 entry BOOLEAN);

INSERT INTO step_entry_exit VALUES
                            (10, 1, datetime('2011-07-01 08:00:00.000'), True), 
                            (12, 1, datetime('2011-07-01 08:05:00.000'), True), 
                            (10, 1, datetime('2011-07-01 08:05:00.000'), False), 
                            (13, 1, datetime('2011-07-01 08:05:00.000'), True), 
                            (14, 1, datetime('2011-07-01 08:10:00.000'), True), 
                            (10, 2, datetime('2011-07-01 08:10:00.000'), True), 
                            (13, 1, datetime('2011-07-01 08:11:00.000'), False), 
                            (12, 1, datetime('2011-07-01 08:12:00.000'), False), 
                            (15, 1, datetime('2011-07-01 08:12:00.000'), True), 
                            (13, 2, datetime('2011-07-01 08:15:00.000'), True), 
                            (15, 1, datetime('2011-07-01 08:20:00.000'), False), 
                            (10, 2, datetime('2011-07-01 08:30:00.000'), False), 
                            (15, 2, datetime('2011-07-01 08:30:00.000'), True), 
                            (12, 2, datetime('2011-07-01 08:32:00.000'), True), 
                            (12, 2, datetime('2011-07-01 08:32:00.000'), False), 
                            (13, 2, datetime('2011-07-01 08:40:00.000'), False), 
                            (10, 3, datetime('2011-07-01 08:32:00.000'), True), 
                            (10, 3, datetime('2011-07-01 08:33:00.000'), False), 
                            (12, 3, datetime('2011-07-01 08:33:00.000'), True), 
                            (12, 3, datetime('2011-07-01 08:34:00.000'), False), 
                            (13, 3, datetime('2011-07-01 08:34:00.000'), True), 
                            (13, 3, datetime('2011-07-01 08:38:00.000'), False), 
                            (10, 4, datetime('2011-07-01 08:39:00.000'), True), 
                            (15, 2, datetime('2011-07-01 08:45:00.000'), False);


-- gets average time spent in steps
-- and number of completed sessions
-- should be better to use pivoting
SELECT X.step, avg(strftime('%s', y.time) - strftime('%s', x.time)) AS avg_time, count(X.session_id) AS count
  FROM step_entry_exit X
       INNER JOIN step_entry_exit y ON X.session_id = Y.session_id AND 
                                       X.step = Y.step AND 
                                       X.entry = True AND 
                                       Y.entry = False
 GROUP BY X.step;

-- get current unclosed sessions
SELECT x.session_id, x.step, x.time AS entry, y.time AS exit
  FROM
       (SELECT session_id, step, time
          FROM step_entry_exit
         WHERE entry = True)  -- entry points
       X
       LEFT OUTER JOIN -- to get NULL in exit
       (SELECT session_id, step, time
          FROM step_entry_exit
         WHERE entry = False)  -- exit points
       Y 
       ON X.session_id = Y.session_id AND 
            X.step = Y.step
 WHERE exit IS NULL;

-- get table that gives start and end times
DROP table IF EXISTS entry_and_exit;
Create table entry_and_exit AS
    SELECT X.session_id, X.step, X.time AS entry, Y.time AS exit
      FROM
           (SELECT session_id, step, time
              FROM step_entry_exit
             WHERE entry = True)
           X
           LEFT OUTER JOIN
           (SELECT session_id, step, time
              FROM step_entry_exit
             WHERE entry = False)
           Y
           ON X.session_id = Y.session_id AND 
                x.step = y.step;

-- queries on ETLed table
select * from entry_and_exit;

-- total time in each step for each user
SELECT session_id, step, strftime('%s', exit) - strftime('%s', entry) as time
  FROM entry_and_exit;

-- total login time of user
SELECT session_id, sum(strftime('%s', exit) - strftime('%s', entry) ) AS total_time, count( * ) as steps
  FROM entry_and_exit
 GROUP BY session_id;

-- give users in step at time t
SELECT step, count( * ) AS users
  FROM entry_and_exit
 WHERE entry <= datetime('2011-07-01 08:12:00.000') AND 
       exit >= datetime('2011-07-01 08:12:00.000') 
 GROUP BY step;

-- Now, let's look at some activation rate
-- basically, how many steps were completed
/*
SELECT step, sessions, (2*sessions) - sum(sessions) over (ORDER BY step ASC rows 2 PRECEDING) attrition
  FROM
       (SELECT step, count(session_id) sessions
          FROM entry_and_exit
         GROUP BY step);
*/