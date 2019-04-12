CREATE TABLE employee(
id            INT, 
first_name    VARCHAR (128), 
last_name     VARCHAR (128), 
gender        VARCHAR (1), 
position      VARCHAR (40), 
department_id INT, 
salary        INT);

INSERT INTO employee
                     (id, first_name, last_name, gender, position, department_id, salary)
                     VALUES
                     (2002, 'super', 'man', 'M', 'Tester', 1, 75000), 
                     (2003, 'jes', 'woman', 'F', 'Architect', 1, 60000), 
                     (2004, 'bonie', 'woman', 'F', 'Project Manager', 1, 80000), 
                     (2005, 'james', 'man', 'M', 'Software developer', 1, 55000), 
                     (2006, 'mike', 'green', 'M', 'Sales assistant', 2, 85000), 
                     (2007, 'leslie', 'black', 'F', 'Sales Engineer', 2, 76000), 
                     (2008, 'Max', 'power', 'M', 'Sales rep', 2, 59000), 
                     (2009, 'stacy', 'jacobs', 'F', 'Sales Manager', 2, 730000), 
                     (2010, 'jon', 'haneen', 'M', 'Sales Director', 2, 90000);

CREATE TABLE department(
department_id   INT, 
department_name VARCHAR (40) );

INSERT INTO department VALUES
                       (1, 'IT'), 
                       (2, 'Sales');
                       
-- employee with the n-highest salary
SELECT * FROM employee
 ORDER BY salary DESC
 LIMIT 1;
 
SELECT * FROM employee
 ORDER BY salary DESC
 LIMIT 1,1; -- 1 to 2; i.e. 2nd highest

SELECT * FROM employee
 ORDER BY salary DESC
 LIMIT 2,1; -- 2 to 3; i.e. 3rd highest

SELECT id, first_name, last_name, gender, position, department_id, salary
  FROM
       (SELECT * FROM employee
         ORDER BY salary DESC
         LIMIT 5)
       X
 ORDER BY X.salary
 LIMIT 1;

/* sqlite 3.25.0
SELECT  id, first_name, last_name, gender, position, department_id, salary
  FROM 
       (select *, row_number() over (ORDER BY salary desc) AS rn 
         FROM employee) 
 WHERE rn = 1;
*/

-- cartesian join!
SELECT first_name, last_name, department_name
  FROM employee, department;

-- select employee, max salary for each department
SELECT first_name, last_name, salary, department_name
  FROM employee
       INNER JOIN department ON employee.department_id = department.department_id
 WHERE salary IN
       (SELECT max(salary) 
          FROM employee
         WHERE department_id = employee.department_id
         GROUP BY department_id);

/* sqlite 3.25.0
SELECT * FROM 
    (SELECT first_name, last_name, salary, department_name, 
            row_number() OVER (PARTITION BY employee.department_id ORDER BY salary DESC) AS rn 
        FROM employee, department
     WHERE employee.department_id = department.department_id)
    X
 WHERE x.rn = 1;
*/