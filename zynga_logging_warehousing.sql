-- staging table level 1
-- to get denormalized info
-- around certain user id.
DROP TABLE IF EXISTS play_level_1;
CREATE TABLE play_level_1 as
SELECT sessions.session_id, user_id, start_time, end_time, level, platform_name, location_x, location_y
  FROM plays
       INNER JOIN sessions 
         ON sessions.session_id = plays.session_id
       INNER JOIN clients 
         ON sessions.client_id = clients.client_id
 ORDER BY start_time, user_id, sessions.session_id;

-- age group dimension
DROP TABLE IF EXISTS age_group_dim;
CREATE TABLE age_group_dim(
age_group VARCHAR(20),
start_age INT,
end_age   INT
);

INSERT INTO age_group_dim VALUES
                          ('adoloscent', 12, 15), 
                          ('teen-under', 15, 18), 
                          ('teen', 18, 19), 
                          ('college', 19, 22), 
                          ('millenial', 22, 30), 
                          ('gen-x', 30, 40), 
                          ('middle', 40, 50), 
                          ('late-mid', 50, 60), 
                          ('past-prime', 60, 80), 
                          ('baroque', 80, 999);

-- location dimension
DROP TABLE IF EXISTS location_dim;
CREATE TABLE location_dim(
location_id INT PRIMARY KEY,
x           INT,
y           INT,
metro       BOOLEAN,
COUNTRY     VARCHAR(100)
);

INSERT INTO location_dim (location_id, x, y, metro, country) VALUES
                         (1, 1, 1, TRUE, 'INDIA'), 
                         (2, 1, 2, FALSE, 'INDIA'), 
                         (3, 1, 3, FALSE, 'US'), 
                         (4, 2, 1, TRUE, 'PAKISTAN'), 
                         (5, 2, 2, FALSE, 'ENGLAND'), 
                         (6, 2, 3, TRUE, 'INDIA'), 
                         (7, 3, 1, TRUE, 'US'), 
                         (8, 3, 2, TRUE, 'PAKISTAN'), 
                         (9, 3, 3, FALSE, 'INDIA');

-- platform dimension
DROP TABLE IF EXISTS platform_dim;
CREATE TABLE platform_dim(
platformid INT,
name       VARCHAR(100),
mobile     BOOLEAN,
company    VARCHAR(100)
);

INSERT INTO platform_dim VALUES
                         (1, 'iphone', TRUE, 'apple'), 
                         (2, 'android', TRUE, 'google'), 
                         (3, 'web', FALSE, 'microsoft'), 
                         (4, 'mac', FALSE, 'apple');

-- final fact table with daily
-- cummulative nums for sessions
-- and duration by users, levels
-- locations, and platforms. We
-- will run queries on top of it
DROP TABLE IF EXISTS play_fact;
CREATE TABLE play_fact as
SELECT date(play_level_1.start_time) date, user_id, level, platformid, location_id, age_group, 
       count(session_id) sessions, sum(end_time - start_time) duration
  FROM play_level_1
       INNER JOIN location_dim 
         ON x = location_x AND y = location_y
       INNER JOIN platform_dim 
         ON platform_name = platform_dim.name
       INNER JOIN
       (SELECT id, age_group
          FROM user_details
               INNER JOIN age_group_dim 
                 ON age >= start_age AND age < end_age) ages
         ON user_id = ages.id
 GROUP BY date, user_id, level, platformid, location_id, age_group;