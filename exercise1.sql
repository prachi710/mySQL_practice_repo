# MySQL
# My MySQL coding - March,22

# Problem 1
/* Create a visualization that provides a breakdown between the male and female employees
working in the company each year, starting from 1990. */

SELECT 
    YEAR(d.from_date) AS calender_year,
    e.gender,
    COUNT(e.emp_no) AS no_of_emp
FROM
    t_employees e
    JOIN
    t_dept_emp d ON e.emp_no = d.emp_no
GROUP BY calender_year, e.gender
HAVING calender_year >= 1990
ORDER BY calender_year;

-- Problem 2 - BI course
/*Compare the number of male managers to the number of female managers from
different departments for each year, starting from 1990.*/

SELECT 
    d.dept_name,
    dm.emp_no,
    e.gender,
    dm.from_date,
    dm.to_date,
    y.calender_year,
    CASE
        WHEN
            YEAR(dm.to_date) >= y.calender_year
                AND YEAR(dm.from_date) <= y.calender_year
		THEN 1
        ELSE 0
    END AS active
FROM
    (SELECT 
        YEAR(from_date) AS calender_year
    FROM
        t_dept_manager
    GROUP BY calender_year) AS y
        CROSS JOIN
    	t_employees e
        JOIN
    	t_dept_manager dm ON dm.emp_no = e.emp_no
        JOIN
    	t_departments d ON d.dept_no = dm.dept_no
HAVING y.calender_year >= 1990
ORDER BY dm.emp_no , y.calender_year;

-- Problem 3 - BI Course
/*Compare the average salary of female versus male employees in the entire company until year 2002,
and add a filter allowing you to see that per each department. */

SELECT d.dept_name, round(avg(s.salary),2) as avg_sal, e.gender, year(s.from_date) as calender_year
FROM
	t_employees e
	JOIN
	t_salaries s on s.emp_no = e.emp_no
	JOIN
	t_dept_emp de on de.emp_no = s.emp_no
	JOIN
	t_departments d ON d.dept_no = de.dept_no
GROUP BY d.dept_no, e.gender, calender_year
HAVING calender_year <= 2002
ORDER BY d.dept_no, calender_year;

-- Problem 4 - BI Course
/*Create an SQL stored procedure that will allow you to obtain the average male and female salary per department
within a certain salary range. Let this range be defined by two values the user can insert when calling the procedure.
Finally, visualize the obtained result-set in Tableau as a double bar chart.*/

DELIMITER $$
CREATE PROCEDURE sal_range(IN p1 float, IN p2 float)
BEGIN
	SELECT  d.dept_name, avg(s.salary) as AVG_SALARY, e.gender  
    FROM t_salaries s
	    JOIN
	    t_employees e ON s.emp_no = e.emp_no
            JOIN
	    t_dept_emp de ON de.emp_no = e.emp_no
            JOIN
            t_departments d ON d.dept_no = de.dept_no
	WHERE s.salary BETWEEN p1 and p2
    GROUP BY d.dept_name, e.gender;
END $$
DELIMITER ;

call sal_range(50000,90000);

-- 4 Course Queries --
