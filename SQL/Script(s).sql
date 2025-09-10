SELECT rating
FROM film
GROUP BY rating;

-- 1. Peliculas con Rating R
SELECT title
FROM film
WHERE rating = 'R';

-- 2. Actores con actor id between 30 & 40
SELECT "first_name", "last_name"
FROM actor
WHERE "actor_id" BETWEEN 30 AND 40;

-- 3. Peliculas cuyo idioma coincide con el original
SELECT title
FROM film
WHERE language_id = "original_language_id";

-- 4. Peliculas ordenadas por dúración ascendente
SELECT title, length
FROM film
ORDER BY length ASC;

-- 5. Actores cuyo appellido contiene 'Allen'
SELECT "first_name", "last_name"
FROM actor
WHERE "last_name" LIKE '%Allen%';

-- 6. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento
SELECT count(title), rating
FROM film
GROUP BY rating
ORDER BY count(title) DESC;

-- 7. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film
SELECT title, rating, length
FROM film
WHERE rating = 'PG-13' OR length >= 180;

-- 8. Encuentra la variabilidad de lo que costaría reemplazar las películas
SELECT variance(replacement_cost)
FROM film;

-- 9. Encuentra la mayor y menor duración de una película de nuestra BBDD
SELECT min(length) AS shortest_movie, max(length) AS longest_movie
FROM film;

-- 10. Encuentra lo que costó el antepenúltimo alquiler ordenado por día
SELECT p.amount, r.rental_date
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
ORDER BY r.rental_date DESC
LIMIT 1 OFFSET 2;

-- 11. Encuentra el título de las películas en la tabla film que no sean ni ‘NC-17’ ni ‘G’ en cuanto a su clasificación
SELECT title, rating
FROM film
WHERE rating NOT IN ('NC-17', 'G');

-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración
SELECT rating, AVG(length) AS average_duration
FROM film
GROUP BY rating
ORDER BY average_duration DESC;

-- 13. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos
SELECT title
FROM film
WHERE length > 180;

-- 14. ¿Cuánto dinero ha generado en total la empresa?
SELECT sum(amount)
FROM Payment;

-- 15. Muestra los 10 clientes con mayor valor de id
SELECT customer_id, first_name, last_name
FROM customer
ORDER BY customer_id DESC
LIMIT 10;

-- 16. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON f.film_id = fa.film_id
WHERE f.title = 'Egg Igby';

SELECT COUNT(*) AS actor_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON f.film_id = fa.film_id
WHERE f.title = 'Egg Igby';

-- 17. Selecciona todos los nombres de las películas únicos
SELECT DISTINCT(title)
FROM film
ORDER BY title ASC;

-- 18. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos
SELECT f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Comedy' AND f.length >=180;

-- 19. Encuentra las categorías de películas con promedio de duración > 110
SELECT c.name, avg(f.length)
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
HAVING avg(f.length) > 110
ORDER BY avg(f.length) DESC;

-- 20. ¿Cuál es la media de duración del alquiler de las películas?
SELECT f.title,
       AVG(r.return_date - r.rental_date) AS avg_duration
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY f.title ASC;

-- 21. Crea una columna con el nombre y apellidos de todos los actores
SELECT CONCAT(first_name,' ', last_name) AS Name
FROM actor
ORDER BY CONCAT(first_name,' ', last_name);

-- 22. Números de alquiler por día, ordenados desc
SELECT Count(*), DATE(rental_date)
FROM rental
GROUP BY DATE(rental_date)
ORDER BY count(*) DESC;

-- 23. Encuentra las películas con duración superior al promedio
SELECT title, avg(length)
FROM film
WHERE length > (SELECT
					Avg(length)
					FROM film)
GROUP BY title
ORDER BY avg(length) DESC;

-- 24. Número de alquileres por mes
SELECT DATE_TRUNC('month', rental_date) AS MONTH, count(*) AS total
FROM rental
GROUP BY MONTH;

-- 25. Promedio, desviación estándar y varianza del total pagado
SELECT avg(amount), stddev(amount), VARIANCE(Amount)
FROM payment;

-- 26. ¿Qué películas se alquilan por encima del precio medio?
SELECT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
WHERE p.amount > (SELECT AVG(amount) FROM payment)
GROUP BY f.title
ORDER BY f.title ASC;

-- 27. Actores con más de 40 películas
SELECT CONCAT(first_name,' ', last_name) AS Name, count(f.film_id) AS film
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON f.film_id = fa.film_id
GROUP BY name
HAVING COUNT(f.film_id) > 40
ORDER BY film DESC;

-- 28. Películas + disponibilidad en inventario
SELECT f.title, count(f.film_id) AS inventory
FROM film f
JOIN inventory i ON f.film_id = i.film_id
GROUP BY f.title
ORDER BY f.title ASC;

-- 29. Actores + numero de peliculas
SELECT CONCAT(first_name,' ', last_name) AS Name, count(f.film_id) AS film
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON f.film_id = fa.film_id
GROUP BY name
ORDER BY film DESC;

-- 30. Todas las películas + actores (aunque no tengan actores)
SELECT f.title, CONCAT(a.first_name, ' ', a.last_name) AS actor_name
FROM film f
LEFT JOIN film_actor fa ON f.film_id = fa.film_id
LEFT JOIN actor a ON fa.actor_id = a.actor_id
ORDER BY f.title, actor_name;

-- 31. Todos los actores + películas (aunque no tengan películas)
SELECT CONCAT(a.first_name, ' ', a.last_name) AS actor_name, f.title
FROM actor a
LEFT JOIN film_actor fa ON fa.actor_id = a.actor_id
LEFT JOIN film f ON f.film_id = fa.film_id
ORDER BY actor_name, f.title;






