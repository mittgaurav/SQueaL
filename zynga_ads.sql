DROP TABLE IF EXISTS ads_details;
CREATE TABLE ads_details(
id          INT PRIMARY KEY,
company     VARCHAR(100),
age_group   VARCHAR(20),
cost        FLOAT,
FOREIGN KEY (age_group) REFERENCES age_group_dim(age_group)
);

INSERT INTO ads_details VALUES
                        (1, 'apple', 'millenial', 1.0),
                        (2, 'samsung', 'college', 1.5), 
                        (3, 'apple', 'gen-x', 1.0), 
                        (4, 'microsoft', 'gen-x', 0.5), 
                        (5, 'microsoft', 'gen-x', 2.5), 
                        (6, 'microsoft', 'baroque', 0.65), 
                        (7, 'microsoft', 'past-prime', 1.5), 
                        (8, 'google', 'teen-under', 3.5), 
                        (9, 'fb', 'millenial', 0.15), 
                        (10, 'fb', 'college', 0.25);

DROP TABLE IF EXISTS ads;
CREATE TABLE ads(
id          INT,
session_id  INT,
time        DATETIME,
user_action VARCHAR(10),
FOREIGN KEY (session_id) REFERENCES sessions(session_id),
FOREIGN KEY (id) REFERENCES ads_details(id)
);

INSERT INTO ads VALUES
                (1, 10001, DATETIME('2019-01-01 08:00:00'), 'ignored'), 
                (3, 10002, DATETIME('2019-01-11 18:00:00'), 'clicked'), 
                (6, 10004, DATETIME('2019-01-21 18:00:00'), 'closed'), 
                (7, 10011, DATETIME('2019-02-11 03:00:00'), 'clicked'), 
                (8, 10011, DATETIME('2019-02-11 18:00:00'), 'closed'), 
                (8, 10011, DATETIME('2019-02-15 08:00:00'), 'closed'), 
                (9, 10012, DATETIME('2019-02-21 08:00:00'), 'ignored'), 
                (10, 10013, DATETIME('2019-02-21 08:00:00'), 'ignored'), 
                (3, 10011, DATETIME('2019-02-21 16:00:00'), 'ignored'), 
                (5, 10010, DATETIME('2019-02-21 18:00:00'), 'ignored'), 
                (6, 10010, DATETIME('2019-02-24 18:00:00'), 'clicked'), 
                (7, 10014, DATETIME('2019-02-25 18:00:00'), 'ignored'), 
                (7, 10015, DATETIME('2019-02-26 18:00:00'), 'ignored'), 
                (7, 10015, DATETIME('2019-02-26 18:01:00'), 'clicked'), 
                (7, 10015, DATETIME('2019-02-26 18:01:00'), 'ignored'),
                (1, 10001, DATETIME('2019-01-01 08:00:00'), 'clicked'), 
                (3, 10002, DATETIME('2019-01-11 18:00:00'), 'clicked'), 
                (6, 10004, DATETIME('2019-01-21 18:00:00'), 'closed'), 
                (7, 10011, DATETIME('2019-02-11 03:00:00'), 'clicked'), 
                (10, 10011, DATETIME('2019-02-11 18:00:00'), 'ignored'), 
                (8, 10011, DATETIME('2019-02-15 08:00:00'), 'closed'), 
                (9, 10012, DATETIME('2019-02-21 08:00:00'), 'clicked'), 
                (10, 10013, DATETIME('2019-02-21 08:00:00'), 'ignored'), 
                (3, 10011, DATETIME('2019-02-21 16:00:00'), 'ignored'), 
                (5, 10010, DATETIME('2019-02-21 18:00:00'), 'ignored'), 
                (6, 10010, DATETIME('2019-02-24 18:00:00'), 'clicked'), 
                (10, 10014, DATETIME('2019-02-25 18:00:00'), 'clicked'), 
                (7, 10015, DATETIME('2019-02-26 18:00:00'), 'ignored'), 
                (9, 10015, DATETIME('2019-02-26 18:01:00'), 'clicked'), 
                (7, 10015, DATETIME('2019-02-26 18:01:00'), 'ignored'), 
                (10, 10011, DATETIME('2019-02-11 18:00:00'), 'ignored'), 
                (8, 10011, DATETIME('2019-02-15 08:00:00'), 'closed'), 
                (9, 10012, DATETIME('2019-02-21 08:00:00'), 'clicked'), 
                (10, 10013, DATETIME('2019-02-21 08:00:00'), 'ignored'), 
                (3, 10011, DATETIME('2019-02-21 16:00:00'), 'clicked'), 
                (5, 10010, DATETIME('2019-02-21 18:00:00'), 'ignored'), 
                (6, 10010, DATETIME('2019-02-24 18:00:00'), 'clicked'), 
                (10, 10014, DATETIME('2019-02-25 18:00:00'), 'clicked'), 
                (9, 10014, DATETIME('2019-02-25 18:00:00'), 'clicked'), 
                (7, 10015, DATETIME('2019-02-26 18:00:00'), 'closed'), 
                (9, 10015, DATETIME('2019-02-26 18:01:00'), 'clicked'), 
                (7, 10015, DATETIME('2019-02-26 18:01:00'), 'ignored'), 
                (6, 10016, DATETIME('2019-02-28 18:00:00'), 'clicked');

DROP TABLE IF EXISTS ads_fact;
CREATE TABLE ads_fact AS
SELECT date(ads.time) as date, ads.id, user_id, platform_name, age_group, user_action
  FROM ads
       LEFT JOIN sessions 
         ON sessions.session_id = ads.session_id
       LEFT JOIN clients
         ON sessions.client_id = clients.client_id
       LEFT JOIN user_details
         ON user_id = user_details.id
       LEFT JOIN age_group_dim
         ON age >= start_age AND age < end_age;

/*
find how much money we made in a week
along with click rate (clicked v rest).
*/
-- EXPLAIN QUERY PLAN
-- EXPLAIN
SELECT date, company, age_group, earning as daily_earning, 
    /*sum(earning) OVER (rows 6 preceding) week_earning,*/
    clicks, ads_shown, clicks*1.0/ads_shown click_rate
  FROM
(SELECT date, company, ads_details.age_group age_group,
    sum(CASE 
            WHEN user_action = 'clicked' THEN cost 
            ELSE NULL 
        END) earning,
    count(CASE 
            WHEN user_action = 'clicked' THEN 1 
            ELSE NULL 
        END) clicks,
    count(ads_fact.id) ads_shown
  FROM ads_fact
      LEFT JOIN ads_details
        ON ads_fact.id = ads_details.id
 GROUP BY date, company, ads_details.age_group);