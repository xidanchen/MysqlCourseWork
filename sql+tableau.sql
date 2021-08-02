################################ TASK 1###############################

## create a visualization that provides a breakdown between the male and female employees working in company each year, 
## starting from 1990
USE employees;  
SELECT
YEAR(de.from_date) AS calendar_year,
e.gender AS gender,
COUNT(e.emp_no) AS number_of_employees
From dept_emp de
JOIN employees e
ON e.emp_no = de.emp_no
GROUP BY calendar_year, e.gender
HAVING calendar_year >= '1990'
ORDER BY calendar_year
;


####################################task 2#################################################

## Compare the number of male managers to the number of female managers 
## from different departments for each year, starting from 1990.
SELECT
dm.emp_no AS manager, 
dm.from_date,
dm.to_date,
e.gender AS gender,
d.dept_name AS departments
FROM employees e 
JOIN dept_manager dm
ON e.emp_no = dm.emp_no
LEFT JOIN departments d 
ON d.dept_no = dm.dept_no

;


-- sulution from course

SELECT 
    d.dept_name,
    ee.gender,
    dm.emp_no,
    dm.from_date,
    dm.to_date,
    e.calendar_year,
    CASE
        WHEN YEAR(dm.to_date) >= e.calendar_year AND YEAR(dm.from_date) <= e.calendar_year THEN 1
        ELSE 0
    END AS active
FROM
    (SELECT 
        YEAR(hire_date) AS calendar_year
    FROM
        employees
    GROUP BY calendar_year) e
        CROSS JOIN
    dept_manager dm
        JOIN
    departments d ON dm.dept_no = d.dept_no
        JOIN 
    employees ee ON dm.emp_no = ee.emp_no
ORDER BY dm.emp_no, calendar_year;



###########################################task 3##########################

## Compare the average salary of female versus male employees in the entire company until year 2002, 
## and add a filter allowing you to see that per each department.
SELECT A.calendar_year, A.gender, B.dept_name,
ROUND(AVG(A.salary), 2) AS average_salary
FROM 
(SELECT 
e.emp_no,
YEAR(s.to_date) AS calendar_year,
s.salary,
e.gender
FROM employees e 
JOIN salaries s
ON e.emp_no = s.emp_no
WHERE YEAR(s.to_date) <= '2002') AS A

JOIN
 
(SELECT de.emp_no, d.dept_name
FROM dept_emp de
JOIN departments d
ON de.dept_no = d.dept_no) AS B

ON A.emp_no = B.emp_no
GROUP BY calendar_year, A.gender, B.dept_name
;


SELECT 
    e.gender,
    d.dept_name,
    ROUND(AVG(s.salary), 2) AS salary,
    YEAR(s.from_date) AS calendar_year
FROM
    salaries s
        JOIN
    employees e ON s.emp_no = e.emp_no
        JOIN
    dept_emp de ON de.emp_no = e.emp_no
        JOIN
    departments d ON d.dept_no = de.dept_no
GROUP BY d.dept_no , e.gender , calendar_year
HAVING calendar_year <= 2002
ORDER BY d.dept_no;




###########################################task 4#############################################

## Create an SQL stored procedure that will allow you to obtain the average male and female salary 
## per department within a certain salary range. 
## Let this range be defined by two values the user can insert when calling the procedure.
## Finally, visualize the obtained result-set in Tableau as a double bar chart. 
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE average_salary_cal(in p_min_salary FLOAT, in p_max_salary FLOAT)
BEGIN

SELECT e.gender, d.dept_name, AVG(s.salary) AS average_salary
FROM
salaries s
JOIN employees e ON s.emp_no = e.emp_no
JOIN dept_emp de ON de.emp_no = e.emp_no
JOIN departments d ON d.dept_no = de.dept_no
WHERE s.salary BETWEEN p_min_salary AND p_max_salary
GROUP BY e.gender, d.dept_name
;



END$$

DELIMITER ;

call employees.average_salary_cal(50000, 90000);

