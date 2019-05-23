CREATE TEMP TABLE friends
(id     INT, friend INT);

CREATE TEMP TABLE recommendations
(id   INT, page INT);

INSERT INTO friends VALUES
                    (1, 2), 
                    (1, 3), 
                    (1, 5), 
                    (1, 7), 
                    (2, 5), 
                    (2, 1), 
                    (3, 1), 
                    (5, 1), 
                    (7, 1), 
                    (5, 2), 
                    (5, 3), 
                    (5, 4), 
                    (3, 5), 
                    (4, 5), 
                    (4, 6), 
                    (6, 4), 
                    (2, 10), 
                    (7, 6), 
                    (6, 7), 
                    (7, 10), 
                    (10, 7), 
                    (6, 5), 
                    (5, 6), 
                    (10, 2);

INSERT INTO recommendations VALUES
                            (1, 1), 
                            (1, 4), 
                            (1, 7), 
                            (1, 2), 
                            (2, 1), 
                            (2, 4), 
                            (3, 10), 
                            (4, 1), 
                            (5, 4), 
                            (5, 3), 
                            (5, 8);

SELECT *
  FROM friends
       INNER JOIN recommendations 
         ON friends.friend = recommendations.id
       LEFT JOIN recommendations r2 
         ON friends.id = r2.id 
           AND recommendations.page = r2.page
 WHERE r2.page IS NULL;
