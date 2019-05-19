/*
get daily, weekly, and monthly 
active users using join with calendar.
Avoid using correlated subqueries
and temporary tables.
*/
-- EXPLAIN QUERY PLAN
-- EXPLAIN
SELECT calendar.date date, 
       count(DISTINCT dau_.user_id) dau, 
       count(DISTINCT wau_.user_id) wau,
       count(DISTINCT mau_.user_id) mau
  FROM calendar
       INNER JOIN play_fact dau_ 
         ON calendar.date = dau_.date
       INNER JOIN play_fact wau_ 
         ON wau_.date BETWEEN date(calendar.date, '-6 days') AND calendar.date
       INNER JOIN play_fact mau_ 
         ON mau_.date BETWEEN date(calendar.date, '-27 days') AND calendar.date
 GROUP BY calendar.date;

/*get dau, wau, and mau
along with retention over
week/month.
*/ 
-- EXPLAIN QUERY PLAN
WITH dau_table AS
(SELECT date, count(DISTINCT user_id)*1.0 dau, sum(sessions)*1.0 sessions, sum(duration)*1.0 duration
  FROM play_fact
 GROUP BY 1),
wau_table as 
(SELECT calendar.date date, count(DISTINCT user_id) wau, sum(sessions) sessions, sum(duration) duration
  FROM calendar
       LEFT JOIN play_fact 
         ON play_fact.date BETWEEN date(calendar.date, '-6 days') AND calendar.date
         AND play_fact.user_id IS NOT NULL
 GROUP BY 1),
mau_table as
(SELECT calendar.date date, count(DISTINCT user_id) mau, sum(sessions) sessions, sum(duration) duration
  FROM calendar
       LEFT JOIN play_fact 
         ON play_fact.date BETWEEN date(calendar.date, '-27 days') AND calendar.date
         AND play_fact.user_id IS NOT NULL
 GROUP BY 1)
SELECT dau_table.date date, dau, wau, mau, 
      (dau/wau) weekly_engmt, (dau/mau) monthly_engmt,
      dau_table.sessions/wau_table.sessions weekly_sess, dau_table.duration/wau_table.duration weekly_dur,
      dau_table.sessions/mau_table.sessions monthly_sess, dau_table.duration/mau_table.duration monthly_dur
  FROM dau_table
      INNER JOIN wau_table
        ON dau_table.date = wau_table.date
      INNER JOIN mau_table
        on dau_table.date = mau_table.date;

/* use wau to get weekly retention,
new clients, resurrected clients,
and churned users*/
-- EXPLAIN QUERY PLAN
-- EXPLAIN
WITH wau_table as 
(SELECT calendar.date date, user_id, sum(sessions) sessions, sum(duration) duration
  FROM calendar
       LEFT JOIN play_fact 
         ON play_fact.date BETWEEN date(calendar.date, '-6 days') AND calendar.date
         AND play_fact.user_id IS NOT NULL
 GROUP BY 1, 2)
SELECT wau_table.date date, 
    count(DISTINCT wau_table.user_id) wau, 
    count(DISTINCT CASE
                        WHEN wau_table_prev.user_id IS NULL THEN NULL
                        ELSE wau_table.user_id -- can be null, i.e. user is churned
                    END) retained,
    count(DISTINCT CASE
                        WHEN user_details.start_date > DATE(wau_table.date, '-6 days') THEN wau_table.user_id
                        ELSE NULL
                    END) new,
    count(DISTINCT CASE
                        WHEN user_details.start_date < DATE(wau_table.date, '-6 days')
                          AND wau_table_prev.user_id is NULL THEN wau_table.user_id
                        ELSE NULL
                    END) resurrected,
    count(DISTINCT CASE
                        WHEN wau_table.user_id IS NULL THEN wau_table_prev.user_id
                        ELSE NULL
                    END) churned -- will work with full outer join instead of left join
  FROM wau_table
       -- OUTER JOIN wau_table wau_table_prev 
       LEFT JOIN wau_table wau_table_prev
         ON wau_table.date = DATE(wau_table_prev.date, '+27 days') 
         AND wau_table.user_id = wau_table_prev.user_id
       LEFT JOIN user_details
         ON wau_table.user_id = user_details.id
 GROUP BY wau_table.date;