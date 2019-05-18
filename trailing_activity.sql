WITH trailing_activity AS (
    -- for each calendar date, get all user
    -- activity within 28 before that date
    SELECT DISTINCT calendar.date AS date, user_id
    FROM calendar
    LEFT JOIN daily_activity
        ON daily_activity.date BETWEEN calendar.date - 27 AND calendar.date
)
SELECT calendar.date,
    -- active users is simple; choose
    -- non null in trailing activity
    count(CASE
        WHEN curr.user_id IS NOT NULL
        THEN 1 END) AS active_users,
    -- user registration resulted in
    -- trailing activity this month
    count(CASE
        WHEN calendar.date <= registration_dt + 27 AND curr.user_id IS NOT NULL
        THEN 1 END) / nullif(count(CASE
                                WHEN calendar.date <= registration_dt + 27
                                THEN 1 END), 0) AS activation_rate,
    -- user activity this month
    -- and the previous month
    count(CASE
        WHEN prev.user_id IS NOT NULL AND curr.user_id IS NOT NULL
        THEN 1 END) / nullif(count(CASE
                                WHEN prev.user_id IS NOT NULL
                                THEN 1 END), 0) AS retention_rate,
    -- users coming back after
    -- no activity last month
    count(CASE
        WHEN prev.user_id IS NULL AND calendar.date - 28 >= registration_dt AND curr.user_id IS NOT NULL
        THEN 1 END) / nullif(count(CASE
                                WHEN prev.user_id IS NULL AND calendar.date - 28 >= registration_dt
                                THEN 1 END), 0) AS reactivation_rate
FROM calendar
JOIN users
    ON calendar.date >= registration_dt
LEFT JOIN trailing_activity AS prev
    ON calendar.date - 28 = prev.date AND users.user_id = prev.user_id
LEFT JOIN trailing_activity AS curr
    ON calendar.date = curr.date AND users.user_id = curr.user_id
GROUP BY calendar.date
ORDER BY calendar.date