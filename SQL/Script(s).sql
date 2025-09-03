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