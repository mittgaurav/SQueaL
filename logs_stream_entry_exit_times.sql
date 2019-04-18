CREATE TABLE entry_exit(
 entry INT, 
 exit  INT
);

INSERT INTO entry_exit VALUES
                       (2, 94), 
                       (4, 13), 
                       (6, 48), 
                       (10, 65), 
                       (11, 14), 
                       (16, 73), 
                       (16, 37), 
                       (16, 86), 
                       (18, 19), 
                       (19, 72), 
                       (19, 27), 
                       (20, 53), 
                       (26, 54), 
                       (27, 43), 
                       (29, 69), 
                       (31, 55), 
                       (36, 96), 
                       (36, 44), 
                       (39, 82), 
                       (40, 67), 
                       (44, 78), 
                       (50, 56), 
                       (54, 59), 
                       (56, 85), 
                       (56, 69), 
                       (61, 94), 
                       (61, 61), 
                       (62, 65), 
                       (66, 76), 
                       (67, 94), 
                       (70, 86), 
                       (70, 86), 
                       (71, 83), 
                       (73, 84), 
                       (73, 84), 
                       (75, 83), 
                       (75, 77), 
                       (77, 80), 
                       (77, 94), 
                       (80, 83), 
                       (81, 97), 
                       (82, 83), 
                       (84, 92), 
                       (88, 100), 
                       (89, 89), 
                       (90, 98), 
                       (91, 98), 
                       (93, 100), 
                       (93, 100), 
                       (98, 100);

DROP TABLE any_time;
Create TEMP TABLE any_time (
 time int,
 login int
);

-- DROP TRIGGER any_time_insert_trigger;
CREATE TRIGGER any_time_insert_trigger
         AFTER INSERT
            ON any_time
          WHEN new.time < 100
BEGIN
    INSERT INTO any_time VALUES
                         (new.time + 1, (SELECT count( * ) 
                                           FROM entry_exit
                                          WHERE entry <= new.time AND 
                                                exit >= new.time)
                         );
END;

INSERT INTO any_time VALUES
                     (1, 0);

-- num of users online at any time
SELECT * FROM any_time;
