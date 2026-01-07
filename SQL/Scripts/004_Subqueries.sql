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