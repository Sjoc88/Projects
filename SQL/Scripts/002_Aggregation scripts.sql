-- 6. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento
SELECT count(title), rating
FROM film
GROUP BY rating
ORDER BY count(title) DESC;

-- 9. Encuentra la mayor y menor duración de una película de nuestra BBDD
SELECT min(length) AS shortest_movie, max(length) AS longest_movie
FROM film;

-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración
SELECT rating, AVG(length) AS average_duration
FROM film
GROUP BY rating
ORDER BY average_duration DESC;

-- 14. ¿Cuánto dinero ha generado en total la empresa?
SELECT sum(amount)
FROM Payment;

-- 20. ¿Cuál es la media de duración del alquiler de las películas?
SELECT AVG(r.return_date - r.rental_date) AS avg_duration
FROM rental r;

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

-- 37. Cuenta cuántos actores hay en la tabla actor
SELECT Count(*)
FROM actor;