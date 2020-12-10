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
 /* Filter out all records that do not have the value "Joe" in the first_name column */
 WHERE first_name = 'Joe';


/* Display all actors whose last names contain the letters "GEN" (2b) */
SELECT *
  FROM actor
 /* Filter out records that do not contain "GEN" in the last_name column */
 WHERE last_name LIKE '%GEN%';


/* Display all actors whose last names contain "LI" ordered by their last and first names, respectively (2c) */
SELECT *
  FROM actor
 /* Filter out records that do not contain "LI" in the last_name column */
 WHERE last_name LIKE '%LI%'
 ORDER BY last_name, first_name;


/* Display the country ID and country names for Afghanistan, Bangladesh, and China (2d) */
SELECT country_id,
	   country
  FROM country
 /* Filter out records that do not have matching country column values */
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


/* Display the titles of movies starting with the letters K and Q whose language is English (7a) */
SELECT film_id,
	   title
  FROM film
 /* Filter out records that do not contain "K" or "Q" in their film titles and whose language is not English */
 WHERE (title LIKE 'K%'
    OR title LIKE 'Q%')
   AND language_id = 
	   /* Return the language ID for English */
	   (SELECT language_id
          FROM language
		 /* Filter out all language IDs that are not associated with English */
		 WHERE name = 'English');


/* Display all actors who appear in the film Alone Trip (7b) */
SELECT actor_id,
	   first_name, last_name
  FROM actor
 /* Filter out all actors who do not appear in "Alone Trip" */
 WHERE actor_id IN
	   /* Return all actor IDs associated with "Alone Trip" */
	   (SELECT actor_id
          FROM film_actor
		 /* Filter out all film IDs not associated with "Alone Trip" */
		 WHERE film_id =
			   /* Return the film ID for "Alone Trip" */
			   (SELECT film_id
                  FROM film
				 /* Filter out all films except "Alone Trip" */
				 WHERE title = 'Alone Trip'
				)
		) ;
        

/* Display the names and email addresses of all Canadian customers (7c) */
SELECT c1.customer_id, 
	   c1.first_name, c1.last_name, c1.email, c3.country
  FROM customer AS c1
	   /* Combine the tables based on the matching values of their related columns */
	   INNER JOIN address AS a
       ON c1.address_id = a.address_id
       INNER JOIN city AS c2
       ON a.city_id = c2.city_id
       INNER JOIN country AS c3
       ON c2.country_id = c3.country_id
 /* Filter out all records not associated with Canadians */
 WHERE c3.country = 'Canada';
       

/* Display all movies categorized as family films (7d) */
SELECT f1.film_id,
	   f1.title, c.name AS film_category
  FROM film AS f1
	   /* Combine all tables based on matching values in their related columns */
	   INNER JOIN film_category AS f2
       ON f1.film_id = f2.film_id
       INNER JOIN category AS c
       ON f2.category_id = c.category_id
 /* Filter out all non-family films */
 WHERE name = 'Family';


/* Display the most frequently rented movies in descending order (7e) */
SELECT f.film_id,
	   /* Calculate the number of times each movie was rented */
	   f.title, COUNT(r.inventory_id) AS rental_tally
  FROM film AS f
	   /* Combine all tables based on matching values in their related columns */
	   INNER JOIN inventory AS i
       ON f.film_id = i.film_id
       INNER JOIN rental AS r
       ON i.inventory_id = r.inventory_id
 GROUP BY f.film_id
 /* Order by most frequently rented to least frequently rented */
 ORDER BY rental_tally DESC;
       

/* Display each store's total revenue in USD (7f) */
SELECT s.store_id,
	   SUM(p.amount) AS revenue_total
  FROM store AS s
	   /* Combine all tables based on matching values in their related columns */
	   INNER JOIN inventory AS i
       ON s.store_id = i.store_id
       INNER JOIN rental AS r
       ON i.inventory_id = r.inventory_id
       INNER JOIN payment AS p
       ON r.rental_id = p.rental_id
 GROUP BY s.store_id;


/* Display each store's ID, city, and country (7g) */
SELECT s.store_id,
	   c1.city, c2.country
  FROM store AS s
	   /* Combine all tables based on matching values in their related columns */
	   INNER JOIN address as a
       ON s.address_id = a.address_id
       INNER JOIN city AS c1
       ON a.city_id = c1.city_id
       INNER JOIN country as c2
       ON c1.country_id = c2.country_id;


/* Top five genres by gross revenue in descending order (7h) */
SELECT c.category_id,
	   /* Calculate the revenue for each genre */
	   c.name AS genre, SUM(p.amount) AS gross_rev_total
  FROM category AS c
	   /* Combine all tables based on matching values in their related columns */
	   INNER JOIN film_category AS f
       ON c.category_id = f.category_id
       INNER JOIN inventory AS i
       ON f.film_id = i.film_id
       INNER JOIN rental AS r
       ON i.inventory_id = r.inventory_id
       INNER JOIN payment AS p
       ON r.rental_id = p.rental_id
 GROUP BY c.category_id
 /* Order from highest gross revenue to lowest gross revenue */
 ORDER BY gross_rev_total DESC
 /* Display only the top 5 genres */
 LIMIT 5;


/* Store the query to display the top 5 genres by gross revenue in descending order into a VIEW (8a) */
CREATE OR REPLACE VIEW top_5_genres AS
SELECT c.name AS genre, 
	   /* Calculate the revenue for each genre */
	   SUM(p.amount) AS gross_rev_total
  FROM category AS c
	   /* Combine all tables based on matching values in their related columns */
	   INNER JOIN film_category AS f
       ON c.category_id = f.category_id
       INNER JOIN inventory AS i
       ON f.film_id = i.film_id
       INNER JOIN rental AS r
       ON i.inventory_id = r.inventory_id
       INNER JOIN payment AS p
       ON r.rental_id = p.rental_id
 GROUP BY c.category_id
 /* Order from highest gross revenue to lowest gross revenue */
 ORDER BY gross_rev_total DESC
 /* Display only the top 5 genres */
 LIMIT 5;


/* Display the top_5_genres VIEW (8b) */
SELECT *
  FROM top_5_genres;


/* Delete the top_5_genres VIEW (8c) */
DROP VIEW IF EXISTS top_5_genres;