# CREATE INDEX

SELECT 
*
FROM 
employees
WHERE 
hire_date > '2000-01-01';

CREATE INDEX i_hire_date ON employees(hire_date);


### drop index 

ALTER TABLE employees
DROP INDEX i_hire_date;


## create index on the salary

SELECT *
FROM salaries
WHERE salary > 89000;  -- 0.016 sec

CREATE INDEX i_salary ON salaries(salary);



