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
WHERE original_language_id IS NOT NULL
  AND language_id = original_language_id;

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
SELECT title
FROM film
WHERE rating = 'PG-13' OR length > 180;

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
SELECT AVG(r.return_date - r.rental_date) AS avg_duration
FROM rental r;

-- 21. Crea una columna con el nombre y apellidos de todos los actores
SELECT 
    actor_id,
    CONCAT(first_name, ' ', last_name) AS full_name
FROM actor
ORDER BY last_name, first_name;

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
SELECT a.actor_id,
       a.first_name, a.last_name,
       COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(fa.film_id) > 40
ORDER BY film_count DESC;

-- 28. Películas + disponibilidad en inventario
SELECT f.title, count(f.film_id) AS inventory
FROM film f
JOIN inventory i ON f.film_id = i.film_id
GROUP BY f.title
ORDER BY f.title ASC;

-- 29. Actores + numero de peliculas
SELECT a.actor_id,
       a.first_name, a.last_name,
       COUNT(fa.film_id) AS film_count
FROM actor a
LEFT JOIN film_actor fa ON fa.actor_id = a.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;

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

-- 32. Todas las películas + todos los alquileres
SELECT f.title, r.rental_date
FROM film f
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
ORDER BY f.title, r.rental_date;

-- 33. Top 5 clientes que mas gastaron
SELECT c.customer_id,
       c.first_name, c.last_name,
       SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON p.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 5;

-- 34. Actores con primer nombre = 'Johnny'
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Johnny'
ORDER BY last_name, first_name;

-- 35. Renombra columnas “first_name” como Nombre y “last_name” como Apellido 
SELECT first_name AS Nombre, last_name AS Appellido
FROM actor;

-- 36. Encuentra el ID del actor más bajo y más alto en la tabla actor
SELECT MIN(actor_id), MAX(actor_id)
FROM actor;

-- 37. Cuenta cuántos actores hay en la tabla actor
SELECT Count(*)
FROM actor;

SELECT COUNT(DISTINCT(CONCAT(first_name,' ', last_name)))
FROM actor

-- puede que haya 200 ID con 1 nombre duplicado ^^

-- 38. Selecciona todos los actores y ordénalos por apellido en orden ascendente
SELECT actor_id, first_name, last_name
FROM actor
ORDER BY last_name ASC, first_name ASC;

-- 39. Selecciona las primeras 5 películas de la tabla film
SELECT title
FROM film
LIMIT 5;

-- 40. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?
SELECT first_name, count(first_name)
FROM actor
GROUP BY first_name
ORDER BY count(first_name) DESC;

-- 41. Encuentra todos los alquileres y los nombres de los clientes que los realizaron
SELECT r.rental_id, r.rental_date, c.first_name, c.last_name
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
ORDER BY r.rental_date;

-- 42. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres
SELECT c.customer_id,
       c.first_name, c.last_name,
       r.rental_id, r.rental_date
FROM customer c
LEFT JOIN rental r ON r.customer_id = c.customer_id
ORDER BY c.customer_id, r.rental_date;

-- 43. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta?
SELECT *
FROM film
CROSS JOIN category

-- no aporta ningún valor este cross join en mi humilde opinion....

-- 44. Encuentra los actores que han participado en películas de la categoría 'Action'
SELECT DISTINCT(CONCAT(a.first_name, ' ', a.last_name))
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action'
ORDER BY CONCAT(a.first_name, ' ', a.last_name);

-- 45. Encuentra todos los actores que no han participado en películas
SELECT DISTINCT(CONCAT(a.first_name, ' ', a.last_name))
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE film_id IS NULL;

-- 46. Selecciona el nombre de los actores y la cantidad de películas en las que han participado
SELECT DISTINCT(CONCAT(a.first_name, ' ', a.last_name)), COUNT (DISTINCT(fa.film_id))
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
GROUP BY DISTINCT(CONCAT(a.first_name, ' ', a.last_name))
ORDER BY COUNT (DISTINCT(fa.film_id)) DESC;

-- 47. Crea una vista llamada actor_num_peliculas que muestre los nombres de los actores y el número de películas en las que han participado
SELECT actor_id,
       first_name, last_name,
       COUNT(film_count) AS film_count
FROM actor_num_peliculas
GROUP BY actor_id, first_name, last_name
ORDER BY film_count DESC, last_name;


-- 48. Calcula el número total de alquileres realizados por cada cliente
SELECT c.customer_id,
       COUNT(r.rental_id) AS rentals_count
FROM customer c
LEFT JOIN rental r ON r.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY rentals_count DESC;

-- 49. Calcula la duración total de las películas en la categoría 'Action'
SELECT sum(f.length) AS total_length
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action';

-- 50 Crea una tabla temporal llamada cliente_rentas_temporal para almacenar el total de alquileres por cliente
DROP TABLE IF EXISTS cliente_rentas_temporal;

CREATE TEMP TABLE cliente_rentas_temporal AS
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       COUNT(r.rental_id) AS rentals_count
FROM customer c
LEFT JOIN rental r ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

SELECT * FROM cliente_rentas_temporal;

-- 51 Crea una tabla temporal llamada peliculas_alquiladas que almacene las películas que han sido alquiladas al menos 10 veces
DROP TABLE IF EXISTS peliculas_alquiladas;

CREATE TEMP TABLE peliculas_alquiladas AS
SELECT f.film_id,
       f.title,
       COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r   ON r.inventory_id = i.inventory_id
GROUP BY f.film_id, f.title
HAVING COUNT(r.rental_id) >= 10;

SELECT * FROM peliculas_alquiladas;

-- 52. Encuentra las películas alquiladas por Tammy Sanders y que aún no se han devuelto
SELECT DISTINCT (f.title)
FROM inventory i
JOIN film f ON f.film_id = i.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
JOIN customer c ON c.customer_id = r.customer_id
WHERE r.return_date IS NULL AND CONCAT(c.first_name,' ',c.last_name) = 'Tammy Sanders'
GROUP BY f.title

-- there are no rentings not returned by this customer --

-- 53. Encuentra actores que han actuado en al menos una película de categoría 'Sci-Fi'
SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
WHERE EXISTS (
  SELECT 1
  FROM film_actor fa
  JOIN film f          ON f.film_id  = fa.film_id
  JOIN film_category fc ON fc.film_id = f.film_id
  JOIN category c       ON c.category_id = fc.category_id
  WHERE fa.actor_id = a.actor_id AND c.name = 'Sci-Fi'
)
ORDER BY a.last_name, a.first_name;

-- 54. Actores en películas alquiladas después de la primera vez que se alquiló Spartacus Cheaper
WITH first_spartacus AS (
  SELECT MIN(r.rental_date) AS first_date
  FROM rental r
  JOIN inventory i ON i.inventory_id = r.inventory_id
  JOIN film f      ON f.film_id      = i.film_id
  WHERE f.title = 'Spartacus Cheaper'
)
SELECT DISTINCT a.actor_id, a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN film f        ON f.film_id   = fa.film_id
JOIN inventory i   ON i.film_id   = f.film_id
JOIN rental r      ON r.inventory_id = i.inventory_id
CROSS JOIN first_spartacus fs
WHERE r.rental_date > fs.first_date
ORDER BY a.last_name, a.first_name;

-- 55. Actores que no han actuado en películas de categoría 'Music'
SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
WHERE NOT EXISTS (
  SELECT 1
  FROM film_actor fa
  JOIN film f          ON f.film_id  = fa.film_id
  JOIN film_category fc ON fc.film_id = f.film_id
  JOIN category c       ON c.category_id = fc.category_id
  WHERE fa.actor_id = a.actor_id AND c.name = 'Music'
)
ORDER BY a.last_name, a.first_name;

-- 56 Películas alquiladas por más de 8 días
SELECT DISTINCT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE (r.return_date - r.rental_date) > INTERVAL '8 days'
ORDER BY f.title;

-- 57. Películas que son de la misma categoría que 'Animation'
SELECT f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
WHERE fc.category_id = (
    SELECT category_id
    FROM category
    WHERE name = 'Animation'
);

-- 58. Películas que tienen la misma duración que Dancing Fever
SELECT title
FROM film
WHERE length = (
    SELECT length
    FROM film
    WHERE title = 'Dancing Fever'
)
ORDER BY title;

-- 59. Clientes que han alquilado al menos 7 películas distintas
SELECT CONCAT(c.first_name,' ',c.last_name), COUNT(DISTINCT(f.film_id))
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
JOIN customer c ON c.customer_id = r.customer_id
GROUP BY CONCAT(c.first_name,' ',c.last_name)
HAVING COUNT(DISTINCT(f.film_id)) >= 7
ORDER BY CONCAT(c.first_name,' ',c.last_name);

-- 60. Cantidad total de películas alquiladas por categoría
SELECT c.name AS category_name, COUNT(r.rental_id) AS total_rentals
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name
ORDER BY total_rentals DESC;

-- 61. Número de películas por categoría estrenadas en 2006
SELECT c.name AS category_name, COUNT(f.title) AS total_films
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE f.release_year = 2006
GROUP BY c.name;

-- 62. Todas las combinaciones de trabajadores con las tiendas
SELECT s.staff_id,
       s.first_name,
       s.last_name,
       st.store_id
FROM staff s
CROSS JOIN store st
ORDER BY s.staff_id, st.store_id;

-- 63. Total de películas alquiladas por cliente (id + nombre + apellido)
SELECT c.customer_id,
       c.first_name, c.last_name,
       COUNT(r.rental_id) AS rentals_count
FROM customer c
LEFT JOIN rental r ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY rentals_count DESC, c.last_name, c.first_name;




