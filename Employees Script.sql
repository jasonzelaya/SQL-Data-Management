/* The numbers in the parentheses at the end of the some comments refer to the questions being answered in the README */

/* Use the employees database */
USE employees;


/* Display the average salary of the male and female employees in each department (1) */
SELECT d1.dept_name,
	   /* Calculate the average salaries */
	   e.gender, AVG(s.salary) AS avg_salary
  FROM departments AS d1
	   /* Combine the tables based on matching values in their related columns */
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
SELECT MAX(dept_no) AS highest_dept_no, 
	   MIN(dept_no) AS lowest_dept_no	   
  FROM dept_emp;



/* Display the employee number, the lowest department number each employee has worked in, and create a 'manager' column which populates values based on employee numbers. 
   The resulting table includes only employees with employee numbers less than 10040 (3) */
SELECT e.emp_no,
	   /* Calculate the lowest department number an employee has worked in */
	   MIN(d.dept_no) AS lowest_dept_no_worked_in,
       /* Determine whether "110022" or "110039" should populate in the manager column based on employee numbers */
       CASE
		    WHEN e.emp_no <= 10020 THEN 110022
            ELSE 110039
            END AS manager
  FROM employees AS e
	   /* Combine the tables based on matching values in their related column */
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



/* Display all employees who are engineers (5) */
SELECT *
  FROM titles
 /* Filter out all records that do not contain "Engineer" in their title */
 WHERE title LIKE '%Engineer%';
 
 /* Display all employees who are senior engineers */
SELECT *
  FROM titles
 /* Filter out all records that do not contain "Senior Engineer" in their title */
 WHERE title LIKE '%Senior Engineer%';



/* Delete this procedure if it exists (6) */
DROP PROCEDURE IF EXISTS emp_last_dept_info;

/* Redefine the delimiter so the procedure can be passed as a compound statement */
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
	 /* Filter out all records whose employee number does not match the argument value */ 
	 WHERE d1.emp_no = p_emp_no
     /* Filter out all records except for the most recent date */ 
       AND d1.from_date = 
		   /* Return the most recent date */
		   (SELECT MAX(from_date)
              FROM dept_emp
			 /* Filter out all records whose employee number does not match the argument value */
			 WHERE emp_no = p_emp_no)
     GROUP BY d1.emp_no;
END//

/* Redefine the delimiter back to the default delimiter since the procedure has passed */
DELIMITER ;

/* Execute the procedure to confirm it works properly */
CALL emp_last_dept_info(10010);



/* Display the number of contracts that lasted for more than one year and included salaries of at least $100,000 (7) */
SELECT COUNT(salary) AS contract_tally
  FROM salaries
 /* Filter out all records that do not have contracts lasting more than one year */
 WHERE DATEDIFF(to_date, from_date) > 365
   /* Filter out all records whose salaries are less than $100,000 */
   AND salary >= 100000;



/* Delete this trigger if it exists (8) */
DROP TRIGGER IF EXISTS t_emp_hire_dates;

/* Redefine the delimiter so the trigger can be passed as a compound statement */
DELIMITER //

/* Create a trigger that checks if the hire date of an employee is higher than the current date and, if true, sets the hire date to the current date */
CREATE TRIGGER t_emp_hire_dates
/* Activate the trigger when new records are inserted into the 'employees' table */
BEFORE INSERT ON employees
/* Execute the trigger body for each row affected by the trigger event */
FOR EACH ROW
BEGIN
	/* 8b. Extra Challenge - this variable could be created and used in the comparison block, but CURDATE() is more efficient 
    DECLARE today DATE;
    SELECT DATE_FORMAT(SYSDATE(), '%Y-%m-%d') INTO today */ 

	/* If the new record's hire date is higher than the current date then set the new record's hire date to the current date */
	IF NEW.hire_date > CURDATE() THEN
		SET NEW.hire_date = CURDATE();
	END IF;
END//

/* Redefine the delimiter back to the default delimiter since the trigger has passed */
DELIMITER ;

/* Insert a new record to test the trigger */		
INSERT employees 
VALUES ('999904', '1970-01-31', 'John', 'Johnson', 'M', '2025-01-01');  

/* Confirm the trigger works */
SELECT *
  FROM employees
 ORDER BY emp_no DESC;



/* Delete this function if it exists (9) */
DROP FUNCTION IF EXISTS f_highest_salary;

/* Redefine delimiter so the function can pass as a compound statement */
DELIMITER //
/* Create a function that returns the highest contract salary of an employee */
CREATE FUNCTION f_highest_salary (p_emp_no INTEGER(11)) RETURNS INTEGER(11)
BEGIN
	/* Create the local variable */
	DECLARE v_salary INTEGER(11);
    
    /* Calculate the highest salary */
    SELECT MAX(salary)
		   /* Insert the highest salary value into the declared variable */
		   INTO v_salary
	  FROM salaries
	 /* Filter out all records whose employee number does not match the argument's value */
	 WHERE emp_no = p_emp_no;
     
     /* Return the local variable's value */
     RETURN v_salary;
END//

/* Redefine the delimiter back to the default delimiter since the function has passed */
DELIMITER ;

/* Execute the function to confirm it works properly */
SELECT f_highest_salary(11356);


/* Drop this function if it exists */
DROP FUNCTION IF EXISTS f_lowest_salary;

/* Redefine the delimiter so the function can be passed as a compound statement */
DELIMITER //
/* Create a function that returns the lowest contract salary of an employee */
CREATE FUNCTION f_lowest_salary (p_emp_no INTEGER(11)) RETURNS INTEGER(11)
BEGIN
	/* Create the local variable */
	DECLARE v_salary INTEGER(11);
    
    /* Calculate the lowest salary */
    SELECT MIN(salary)
		   /* Insert the lowest salary value into the declared local variable */
		   INTO v_salary
	  FROM salaries
	 /* Filter out all records whose employee number does not match the argument's value */
	 WHERE emp_no = p_emp_no;
     
     /* Return the local variable's value */
     RETURN v_salary;
END//

/* Redefine the delimiter back to the default delimiter since the function has passed */ 
DELIMITER ;

/* Execute the function to confirm it works properly */
SELECT f_lowest_salary(11356);



/* Drop this function if it exists (10) */
DROP FUNCTION IF EXISTS f_salary_boundaries;

/* Redefine the delimiter so the function can be passed as a compound statement */
DELIMITER //
/* Create a function that returns the highest salary, lowest salary, or the difference of an employee's highest and lowest salaries based on the input values */
CREATE FUNCTION f_salary_boundaries (p_emp_no INTEGER(11), p_max_or_min VARCHAR(11)) RETURNS INTEGER(11)
BEGIN
	/* Create the local variable */
	DECLARE v_salary_boundary INTEGER(11);
    
    SELECT 
			/* Set the coditions to determine which calculation to run */
		   CASE
			   /* When the second argument is 'MAX' calculate the maximum value */
               WHEN p_max_or_min = 'MAX' THEN MAX(salary)
			   /* When the second argument is 'MIN' calculate the minimum value */
			   WHEN p_max_or_min = 'MIN' THEN MIN(salary)
			   /* When the second argument is anything other than 'MAX' or 'MIN' calculate the difference between the maximum and minimum salaries */               
               ELSE MAX(salary) - MIN(salary)
		   END AS salary_boundary
           /* Insert the calculated value into the declared local variable */
		   INTO v_salary_boundary
	  FROM salaries
	 /* Filter out all records whose employee number does not match the first argument value */
	 WHERE emp_no = p_emp_no
	 GROUP BY emp_no;
     
     /* Return the local variable's value */
     RETURN v_salary_boundary;
END//

/* Redefine the delimiter back to the default delimiter since the function has passed */ 
DELIMITER ;


/* Execute the function to confirm it works properly */
SELECT f_salary_boundaries(11356, 'max') AS max_salary;
SELECT f_salary_boundaries(11356, 'min') AS min_salary;
SELECT f_salary_boundaries(11356, 'maxxx') AS salary_difference;
