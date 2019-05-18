DROP TABLE IF EXISTS calendar;

CREATE TABLE calendar(
date  DATE PRIMARY KEY, 
week  INT, 
month INT
);

INSERT INTO calendar VALUES
                     (date("2019-01-01"), 1, 1),
                     (date("2019-01-02"), 1, 1),
                     (date("2019-01-03"), 1, 1),
                     (date("2019-01-04"), 1, 1),
                     (date("2019-01-05"), 1, 1),
                     (date("2019-01-06"), 1, 1),
                     (date("2019-01-07"), 1, 1),
                     (date("2019-01-08"), 2, 1),
                     (date("2019-01-09"), 2, 1),
                     (date("2019-01-10"), 2, 1),
                     (date("2019-01-11"), 2, 1),
                     (date("2019-01-12"), 2, 1),
                     (date("2019-01-13"), 2, 1),
                     (date("2019-01-14"), 2, 1),
                     (date("2019-01-15"), 3, 1),
                     (date("2019-01-16"), 3, 1),
                     (date("2019-01-17"), 3, 1),
                     (date("2019-01-18"), 3, 1),
                     (date("2019-01-19"), 3, 1),
                     (date("2019-01-20"), 3, 1),
                     (date("2019-01-21"), 3, 1),
                     (date("2019-01-22"), 4, 1),
                     (date("2019-01-23"), 4, 1),
                     (date("2019-01-24"), 4, 1),
                     (date("2019-01-25"), 4, 1),
                     (date("2019-01-26"), 4, 1),
                     (date("2019-01-27"), 4, 1),
                     (date("2019-01-28"), 4, 1),
                     (date("2019-01-29"), 5, 1),
                     (date("2019-01-30"), 5, 1),
                     (date("2019-01-31"), 5, 1),
                     (date("2019-02-01"), 5, 2),
                     (date("2019-02-02"), 5, 2),
                     (date("2019-02-03"), 5, 2),
                     (date("2019-02-04"), 5, 2),
                     (date("2019-02-05"), 6, 2),
                     (date("2019-02-06"), 6, 2),
                     (date("2019-02-07"), 6, 2),
                     (date("2019-02-08"), 6, 2),
                     (date("2019-02-09"), 6, 2),
                     (date("2019-02-10"), 6, 2),
                     (date("2019-02-11"), 6, 2),
                     (date("2019-02-12"), 7, 2),
                     (date("2019-02-13"), 7, 2),
                     (date("2019-02-14"), 7, 2),
                     (date("2019-02-15"), 7, 2),
                     (date("2019-02-16"), 7, 2),
                     (date("2019-02-17"), 7, 2),
                     (date("2019-02-18"), 7, 2),
                     (date("2019-02-19"), 8, 2),
                     (date("2019-02-20"), 8, 2),
                     (date("2019-02-21"), 8, 2),
                     (date("2019-02-22"), 8, 2),
                     (date("2019-02-23"), 8, 2),
                     (date("2019-02-24"), 8, 2),
                     (date("2019-02-25"), 8, 2),
                     (date("2019-02-26"), 9, 2),
                     (date("2019-02-27"), 9, 2),
                     (date("2019-02-28"), 9, 2),
                     (date("2019-03-01"), 9, 3),
                     (date("2019-03-02"), 9, 3),
                     (date("2019-03-03"), 9, 3),
                     (date("2019-03-04"), 9, 3),
                     (date("2019-03-05"), 10, 3),
                     (date("2019-03-06"), 10, 3),
                     (date("2019-03-07"), 10, 3),
                     (date("2019-03-08"), 10, 3),
                     (date("2019-03-09"), 10, 3),
                     (date("2019-03-10"), 10, 3),
                     (date("2019-03-11"), 10, 3),
                     (date("2019-03-12"), 11, 3),
                     (date("2019-03-13"), 11, 3),
                     (date("2019-03-14"), 11, 3),
                     (date("2019-03-15"), 11, 3),
                     (date("2019-03-16"), 11, 3),
                     (date("2019-03-17"), 11, 3),
                     (date("2019-03-18"), 11, 3),
                     (date("2019-03-19"), 12, 3),
                     (date("2019-03-20"), 12, 3),
                     (date("2019-03-21"), 12, 3),
                     (date("2019-03-22"), 12, 3),
                     (date("2019-03-23"), 12, 3),
                     (date("2019-03-24"), 12, 3),
                     (date("2019-03-25"), 12, 3),
                     (date("2019-03-26"), 13, 3),
                     (date("2019-03-27"), 13, 3),
                     (date("2019-03-28"), 13, 3),
                     (date("2019-03-29"), 13, 3),
                     (date("2019-03-30"), 13, 3),
                     (date("2019-03-31"), 13, 3);