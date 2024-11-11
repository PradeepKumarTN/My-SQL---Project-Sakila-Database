use sakila;

SELECT f.film_id, f.title, f.release_year, f.rental_rate, f.length, f.rating, f.special_features, GROUP_CONCAT(DISTINCT a.first_name, ' ', a.last_name) AS actors,
    c.name AS category, l.name AS language, SUM(p.amount) AS total_revenue,COUNT(r.rental_id) AS total_rentals
FROM 
    film f
JOIN film_category fc 
ON f.film_id = fc.film_id
JOIN category c 
ON fc.category_id = c.category_id
JOIN film_text ft
ON f.film_id = ft.film_id
JOIN language l 
ON f.language_id = l.language_id
LEFT JOIN inventory i 
ON f.film_id = i.film_id
LEFT JOIN rental r 
ON i.inventory_id = r.inventory_id
LEFT JOIN payment p 
ON r.rental_id = p.rental_id
LEFT JOIN film_actor fa 
ON f.film_id = fa.film_id
LEFT JOIN actor a 
ON fa.actor_id = a.actor_id
WHERE f.title IS NOT NULL AND l.name IS NOT NULL AND c.name IS NOT NULL AND p.amount IS NOT NULL
GROUP BY f.film_id, f.title, f.release_year, f.rental_rate, f.length, f.rating, f.special_features, c.name, l.name
ORDER BY total_revenue DESC;

# 1,Customer Activity Analysis
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_rentals, SUM(p.amount) AS total_spent
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.customer_id;

# 2,Top-Rented Movies Analysis
SELECT f.title, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 10;

# 3,Revenue Analysis by Store
SELECT s.store_id, SUM(p.amount) AS total_revenue
FROM store s
JOIN inventory i ON s.store_id = i.store_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY s.store_id;

# 4,Movie Genre Popularity Analysis
SELECT c.name AS genre, COUNT(r.rental_id) AS rental_count
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name
ORDER BY rental_count DESC;

# 5,Customer Demographics Analysis
SELECT ci.city, COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY ci.city
ORDER BY rental_count DESC;

# 6,Inventory Turnover Analysis
SELECT i.inventory_id, f.title, COUNT(r.rental_id) AS total_rentals
FROM inventory i
JOIN film f ON i.film_id = f.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY i.inventory_id
ORDER BY total_rentals DESC;

# 7,Most Profitable Movies
SELECT f.title, SUM(p.amount) AS total_revenue
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.title
ORDER BY total_revenue DESC;

# 8,Rental Duration Analysis
SELECT f.title, AVG(DATEDIFF(r.return_date, r.rental_date)) AS avg_rental_duration
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.return_date IS NOT NULL
GROUP BY f.title
ORDER BY avg_rental_duration DESC;

# 9,Film Length vs Popularity
SELECT f.title, f.length, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id
ORDER BY rental_count DESC;

# 10,Customer Segmentation Analysis
SELECT c.customer_id, c.first_name, c.last_name,
       CASE
         WHEN COUNT(r.rental_id) >= 50 THEN 'Platinum'
         WHEN COUNT(r.rental_id) >= 20 THEN 'Gold'
         ELSE 'Silver'
       END AS customer_segment
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id;

# 11,Film Age vs Rental Frequency
SELECT f.title, f.release_year, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title, f.release_year
ORDER BY rental_count DESC;

# 12,Profitability by Rental Duration
SELECT f.title, DATEDIFF(r.return_date, r.rental_date) AS rental_duration, SUM(p.amount) AS total_revenue
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.title, DATEDIFF(r.return_date, r.rental_date)
ORDER BY total_revenue DESC;

# 13,Geographical Distribution of Rentals
SELECT ci.city, COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY ci.city
ORDER BY rental_count DESC;

# 14,Monthly Revenue Trends
SELECT MONTH(r.rental_date) AS rental_month, SUM(p.amount) AS total_revenue
FROM rental r
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY rental_month
ORDER BY rental_month;

# 15,Top Customers by Spending
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_spent
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 10;

# 16,Film Availability by Category
SELECT c.name AS category, COUNT(i.inventory_id) AS available_films
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN  film f ON fc.film_id = f.film_id
LEFT JOIN  inventory i ON f.film_id = i.film_id
GROUP BY  c.name
ORDER BY available_films DESC;
