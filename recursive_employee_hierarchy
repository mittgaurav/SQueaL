DROP TABLE hierarchy;

CREATE TABLE hierarchy
(emp_id  INT PRIMARY KEY, manager INT);

INSERT INTO hierarchy VALUES
                      (1, 2), 
                      (2, 4), 
                      (4, 7), 
                      (3, 4), 
                      (5, 4), 
                      (6, 5), 
                      (9, 5), 
                      (0, 2), 
                      (8, 10);
                      
-- get all managers
WITH RECURSIVE final AS
(SELECT emp_id, manager
   FROM hierarchy
UNION
SELECT final.emp_id, hierarchy.manager
  FROM hierarchy
       INNER JOIN final ON final.manager = hierarchy.emp_id)
SELECT *
  FROM final
 ORDER BY emp_id;


-- get all subordinates
WITH RECURSIVE final AS
(SELECT manager, emp_id, 1 as level
   FROM hierarchy
UNION ALL
SELECT final.manager, hierarchy.emp_id, final.level + 1
  FROM hierarchy
       INNER JOIN final ON final.emp_id = hierarchy.manager)
SELECT *
  FROM final
 ORDER BY manager;
