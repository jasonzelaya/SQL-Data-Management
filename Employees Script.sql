/* The numbers in the parentheses at the end of each comment refer to the questions being answered from the README. */

/* Use employees database */
USE employees;


/* Display the average salary of the male and female employees in each department (1) */
SELECT d1.dept_name,
	   /* Calculate the average salaries */
	   e.gender, AVG(s.salary) AS avg_salary
  FROM departments AS d1
	   /* Combine all tables based on matching values in their related columns */
	   INNER JOIN dept_emp AS d2
       ON d1.dept_no = d2.dept_no
       INNER JOIN employees AS e
       ON d2.emp_no = e.emp_no
       INNER JOIN salaries AS s
       ON e.emp_no = s.emp_no
 /* Group by department names and split those groups into males and females */
 GROUP BY d1.dept_name, e.gender
 ORDER BY d1.dept_name;
       

/* Display the lowest and highest department numbers in 'dept_emp', respectively (2) */ 
SELECT MIN(dept_no) AS lowest_dept_no,
	   MAX(dept_no) AS highest_dept_no
  FROM dept_emp;


/* Display the employee number, the lowest department number each employee has worked in, and create a 'manager' column which populates values based on employee numbers. 
   Resulting table includes only employees with employee numbers less than 10040 (3) */
SELECT e.emp_no,
	   /* Calculate the lowest department number an employee has worked in */
	   MIN(d.dept_no) AS lowest_dept_no_worked_in,
       /* Determine whether "110022" or "110039" should populate in the manager column based on employee numbers */
       CASE
		    WHEN e.emp_no <= 10020 THEN 110022
            ELSE 110039
            END AS manager
  FROM employees AS e
	   /* Combine tables based on matching values in their related column */
	   INNER JOIN dept_emp AS d
       ON e.emp_no = d.emp_no
 /* Filter out all records whose employee numbers are higher than 10040 */ 
 WHERE e.emp_no <= 10040
 GROUP BY e.emp_no;


/* Display all employees hired in 2000 (4) */
SELECT *
  FROM employees
 /* Filter out all records whose employees were not hired in 2000 */
 WHERE YEAR(hire_date) = 2000;


/* Display all employees who are engineers (5a) */
SELECT *
  FROM titles
 /* Filter out all records that do not contain "Engineer" in their title */
 WHERE title LIKE '%Engineer%';
 
 /* Display all employees who are senior engineers (5b) */
SELECT *
  FROM titles
 /* Filter out all records that do not contain "Senior Engineer" in their title */
 WHERE title LIKE '%Senior Engineer%';


/* Delete this procedure if it exists (6) */
DROP PROCEDURE IF EXISTS emp_last_dept_info;

/* Redefine the delimiter to pass the procedure as a compound statement */
DELIMITER //

/* Create a procedure that takes in an employee number to output the employee number argument along with the number and name of the last department the employee worked in */
CREATE PROCEDURE emp_last_dept_info (p_emp_no INTEGER(11))
BEGIN
	/* Display the employee number, department number, and department name based on the argument value */
	SELECT d1.emp_no,
		   d1.dept_no, d2.dept_name
	  FROM dept_emp AS d1
		   /* Combine the tables based on matching values in their related column */
		   INNER JOIN departments AS d2
           ON d1.dept_no = d2.dept_no
	 /* Filter out all records whose employee number does not match the argument's value */ 
	 WHERE d1.emp_no = p_emp_no
     /* Filter out all records except for the most recent date */ 
       AND d1.from_date = 
		   /* Return the most recent date */
		   (SELECT MAX(from_date)
              FROM dept_emp
			 /* Filter out all records whose employee number does not match the argument's value */
			 WHERE emp_no = p_emp_no)
     GROUP BY d1.emp_no;
END//

/* Redefine the delimiter back to the default delimiter since the procedure has passed */
DELIMITER ;

/* Execute the procedure */
CALL emp_last_dept_info(10010);


-- 7. How many contracts have been registered in the 'salaries' table with durations of more than one year and with values higher than or equal to $100,000?

-- 8. Create a trigger that checks if the hire date of an employee is higher than the current date. If true, set the hire date equal to the current date. Format the output appropriately (YY-mm-dd).
-- 	  - Extra challenge: You can try to declare a new variable called 'today' which stores today's data, and then use it in your trigger!
-- 	  - After creating the trigger, execute the following code to see if it's working properly.
-- 		
-- 			INSERT employees 
-- 			VALUES ('999904', '1970-01-31', 'John', 'Johnson', 'M', '2025-01-01');  

-- 			SELECT *
-- 			  FROM employees
-- 			 ORDER BY emp_no DESC;

-- 9. Define a function that retrieves the largest contract salary value of an employee. Apply it to employee number 11356.
-- 	  - In addition, what is the lowest contract salary of the same employee?

-- 10. Based on the previous exercise, you can now try to create a third function that also accepts a second parameter. Let this parameter be a character sequence. Evaluate if its value is 'min' or 'max' and based on that retrieve either the lowest or the highest salary, respectively (using the same logic and code structure from Exercise 9). If the inserted value is any string value different from 'min' or 'max', let the function return the difference between the highest and the lowest salary of that employee.
