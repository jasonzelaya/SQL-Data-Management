# SQL Data Management

#### -- Project Status: Completed

### Technologies
* SQL
* MySQL Workbench

## Instructions

#### Sakila Database

* 1a. Display the first and last names of all actors from the table `actor`.

* 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.

* 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

* 2b. Find all actors whose last name contain the letters `GEN`:

* 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:

* 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:

* 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB`.

* 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.

* 4a. List the last names of actors, as well as how many actors have that last name.

* 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

* 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.

* 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.

* 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?

* 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member.

* 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005.

* 6c. List each film and the number of actors who are listed for that film using inner join.

* 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?

* 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:

  ![Total amount paid](Images/total_payment.png)

* 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.

* 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.

* 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

* 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.

* 7e. Display the most frequently rented movies in descending order.

* 7f. Write a query to display how much business, in dollars, each store brought in.

* 7g. Write a query to display for each store its store ID, city, and country.

* 7h. List the top five genres in gross revenue in descending order.

* 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view.

* 8b. How would you display the view that you created in 8a?

* 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.

#### Employees Database
1. Find the average salary of the male and female employees in each department.

2. Find the lowest department number encountered in the 'dept_emp' table. Then, find the highest department number.

3. Obtain a table containing the following three fields for all individuals whose employee number is not greater than 10040:
	  - employee number
	  - the lowest department number among the departments where the employee has worked in
	  - assign '110022' as 'manager' to all individuals whose employee number is lower than or equal to 10020, and '110039' to those whose number is between 10021 and 10040 inclusive.

4. Retrieve a list of all employees that have been hired in 2000.

5. Retrieve a list of all employees from the 'titles' table who are engineers. 
	  - Repeat the exercise, this time retrieving a list of all employees from the 'titles' table who are senior engineers.

6. Create a procedure that asks you to insert an employee number and that will obtain an output containing the same number, as well as the number and name of the last department the employee has worked in.
	  - Finally, call the procedure for employee number 10010.

7. How many contracts have been registered in the 'salaries' table with durations of more than one year and with values higher than or equal to $100,000?

8. Create a trigger that checks if the hire date of an employee is higher than the current date. If true, set the hire date equal to the current date. Format the output appropriately (YY-mm-dd).
	  - Extra challenge: You can try to declare a new variable called 'today' which stores today's data, and then use it in your trigger!
	  - After creating the trigger, execute the following code to see if it's working properly.
		
			INSERT employees 
			VALUES ('999904', '1970-01-31', 'John', 'Johnson', 'M', '2025-01-01');  

			SELECT *
			  FROM employees
			 ORDER BY emp_no DESC;

9. Define a function that retrieves the largest contract salary value of an employee. Apply it to employee number 11356.
	  - In addition, what is the lowest contract salary of the same employee?

10. Based on the previous exercise, you can now try to create a third function that also accepts a second parameter. Let this parameter be a character sequence. Evaluate if its value is 'min' or 'max' and based on that retrieve either the lowest or the highest salary, respectively (using the same logic and code structure from Exercise 9). If the inserted value is any string value different from 'min' or 'max', let the function return the difference between the highest and the lowest salary of that employee.

## Appendix 
### List of Tables in the Sakila DB

* A schema is also available as `sakila_schema.svg`. Open it with a browser to view.

```sql
'actor'
'actor_info'
'address'
'category'
'city'
'country'
'customer'
'customer_list'
'film'
'film_actor'
'film_category'
'film_list'
'film_text'
'inventory'
'language'
'nicer_but_slower_film_list'
'payment'
'rental'
'sales_by_film_category'
'sales_by_store'
'staff'
'staff_list'
'store'
```

### List of Tables in the Employees DB

* A schema is also available as `employees.sql` [here](https://github.com/datacharmer/test_db).

```sql
'departments'
'dept_emp'
'dept_manager'
'employees'
'salaries'
'titles'
```README 2
