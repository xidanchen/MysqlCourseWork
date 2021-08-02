## Similar to the exercises done in the lecture, 
## obtain a result set containing the employee number, first name, and last name of all employees 
## with a number higher than 109990. 
## Create a fourth column in the query, indicating whether this employee is also a manager, 
## according to the data provided in the dept_manager table, or a regular employee. 

SELECT e.emp_no, e.first_name, e.last_name,
CASE 
WHEN dm.emp_no IS NOT NULL THEN 'Manager'
ELSE 'Employee'
END AS is_manager
FROM employees e
LEFT JOIN dept_manager dm
ON e.emp_no = dm.emp_no
WHERE e.emp_no > 109990;

## Extract a dataset containing the following information 
## about the managers: employee number, first name, and last name. 
## Add two columns at the end – one showing the difference between the maximum and minimum salary of that employee, 
## and another one saying whether this salary raise was higher than $30,000 or NOT.

## If possible, provide more than one solution.

SELECT e.emp_no, e.first_name, e.last_name,
CASE WHEN s.salary IS NOT NULL THEN 
	MAX(s.salary) - MIN(s.salary)
END AS diff_max_min,
CASE  
WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'Yes'
ELSE 'No'
END AS higher_than_30000
FROM employees e
JOIN dept_manager dm
ON e.emp_no = dm.emp_no
JOIN salaries s
ON dm.emp_no = s.emp_no
GROUP BY emp_no
;

-- solution 2

SELECT e.emp_no, e.first_name, e.last_name, 
IF(s.salary IS NOT NULL, MAX(s.salary) - MIN(s.salary), NULL) AS diff_max_min,
IF(MAX(s.salary) - MIN(s.salary) > 30000, 'Yes', 'No') AS higher_than_30000

FROM employees e
JOIN dept_manager dm
ON e.emp_no = dm.emp_no
JOIN salaries s
ON dm.emp_no = s.emp_no
GROUP BY emp_no
;

## Extract the employee number, first name, and last name of the first 100 employees, 
## and add a fourth column, called “current_employee” 
## saying “Is still employed” if the employee is still working in the company, or “Not an employee anymore” if they aren’t.

## Hint: You’ll need to use data from both the ‘employees’ and the ‘dept_emp’ table to solve this exercise. 

SELECT e.emp_no, e.first_name, e.last_name, 
CASE 
WHEN MAX(de.to_date) > DATE_FORMAT(SYSDATE(), '%y-%m-%d') THEN 'Is still employed'
ELSE 'Not an employee anymore'
END AS current_employee
FROM employees e 
JOIN dept_emp de
ON e.emp_no = de.emp_no
GROUP BY e.emp_no
LIMIT 100
;



