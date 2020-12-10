/* The alphanumeric characters in the parentheses at the end of each comment refer to the questions being answered from the README. */

/* Use sakila database */
USE sakila;

/* Display first and last names of all actors (1a) */
SELECT first_name,
	   last_name
  FROM actor;


/* Display first and last names of each actor in a single column and in uppercase letters (1b) */
SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS 'Actor Name'
  FROM actor;


/* Display Joe's actor ID, first name, and last name (2a) */
SELECT actor_id,
	   first_name, last_name
  FROM actor
 /* Filter out all rows that do not have the value "Joe" in the first_name column */
 WHERE first_name = 'Joe';


/* Display all actors whose last names contain the letters "GEN" (2b) */
SELECT *
  FROM actor
 /* Filter out rows that do not contain "GEN" in the last_name column */
 WHERE last_name LIKE '%GEN%';


/* Display all actors whose last names contain "LI" ordered by their last and first names, respectively (2c) */
SELECT *
  FROM actor
 /* Filter out rows that do not contain "LI" in the last_name column */
 WHERE last_name LIKE '%LI%'
 ORDER BY last_name, first_name;


/* Display the country ID and country names for Afghanistan, Bangladesh, and China (2d) */
SELECT country_id,
	   country
  FROM country
 /* Filter out rows that do not have matching country column values */
 WHERE country IN ('Afghanistan', 'Bangladesh','China');


/* Create a column to store descriptions of each actor as binary data (3a) */
ALTER TABLE actor
ADD COLUMN description BLOB AFTER last_name;


/* Delete "description" column (3b) */
ALTER TABLE actor
DROP COLUMN description;


/* Display the last names of actors and how many actors have that last name (4a) */
SELECT last_name,
		/* Calculate the number of actors with each last name */
	   COUNT(last_name) AS last_name_tally
  FROM actor
 GROUP BY last_name;
  

/* Display the last names of actors and how many actors have that last name for last names shared by at least two actors (4b) */
SELECT last_name,
	   COUNT(last_name) AS last_name_tally
  FROM actor
 GROUP BY last_name
 HAVING COUNT(last_name) >= 2;


/* Fix the record that contains incorrect data by changing 'HARPO WILLIAMS' to 'GROUCHO WILLIAMS' (4c) */
UPDATE actor
   SET first_name = 'HARPO'
 WHERE first_name = 'GROUCHO'
   AND last_name = 'WILLIAMS';


/* Correct the misunderstanding of the query above by changing "HARPO WILLIAMS" back to "GROUCHO WILLIAMS" (4d) */
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO'
  /* Affect only the record the previous query changed */
  AND actor_id = 172;


/* Display the query used to create the address table (5a) */ 
SHOW CREATE TABLE address;


/* Display each staff member's first name, last name, and address (6a) */ 
SELECT s.first_name,
	   s.last_name, a.address
  FROM staff AS s
	   /* Combine the tables based on the matching values in their related column */
	   INNER JOIN address AS a
       ON s.address_id = a.address_id;


/* Display the total amount rung up by each staff member in August of 2005 (6b) */
SELECT s.staff_id,
	   /* Calculate the amount rung up and create a column to specify the time range this applies to */
	   s.first_name, s.last_name, SUM(p.amount) AS amount_rung_up_total, CONCAT(MONTHNAME(p.payment_date), ', ', YEAR(p.payment_date)) AS time_frame 
  FROM staff AS s
	   /* Combine the tables based on the matching values in their related column */
	   INNER JOIN payment AS p
       ON s.staff_id = p.staff_id
 /* Filter out all records that do not have payment dates during August of 2005*/
 WHERE MONTH(p.payment_date) = 08
   AND YEAR(p.payment_date) = 2005
 GROUP BY s.staff_id;


/* List each film and the number of actors who are listed for that film (6c) */
SELECT f1.title,
	   /* Calculate the number of actors listed for each film */
	   COUNT(f2.actor_id) AS film_actors_tally
  FROM film AS f1
	   /* Combine the tables based on the matching values of their related column */
	   INNER JOIN film_actor AS f2
       ON f1.film_id = f2.film_id
 GROUP BY f1.title;


/* Display how many copies of "Hunchback Impossible" are in the inventory system (6d) */
SELECT f.title,
	   /* Calculate the number of film copies */
	   COUNT(i.film_id) AS film_copies_tally
  FROM film AS f
	   /* Combine the tables based on the matching values in their related column */
	   INNER JOIN inventory AS i
       ON f.film_id = i.film_id
 /* Filter out all films except "Hunchback Impossible" */ 
 WHERE f.title = 'Hunchback Impossible';


/* Display total paid by each customer listed alphabetically by last name (6e) */
SELECT c.customer_id,
	   c.first_name, c.last_name, SUM(p.amount) AS amount_paid_total
  FROM customer AS c
	   /* Combine tables based on matching values in their related column */
	   INNER JOIN payment AS p
       ON c.customer_id = p.customer_id
 GROUP BY c.customer_id
 /* List alphabetically by last name */
 ORDER BY c.last_name;


-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

-- 7e. Display the most frequently rented movies in descending order.

-- 7f. Write a query to display how much business, in dollars, each store brought in.

-- 7g. Write a query to display for each store its store ID, city, and country.

-- 7h. List the top five genres in gross revenue in descending order.

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view.

-- 8b. How would you display the view that you created in 8a?

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
