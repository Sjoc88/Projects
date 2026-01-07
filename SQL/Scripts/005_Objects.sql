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