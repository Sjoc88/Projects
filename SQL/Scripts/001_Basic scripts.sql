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

-- 7. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film
SELECT title
FROM film
WHERE rating = 'PG-13' OR length > 180;

-- 8. Encuentra la variabilidad de lo que costaría reemplazar las películas
SELECT variance(replacement_cost)
FROM film;

-- 11. Encuentra el título de las películas en la tabla film que no sean ni ‘NC-17’ ni ‘G’ en cuanto a su clasificación
SELECT title, rating
FROM film
WHERE rating NOT IN ('NC-17', 'G');

-- 13. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos
SELECT title
FROM film
WHERE length > 180;

-- 15. Muestra los 10 clientes con mayor valor de id
SELECT customer_id, first_name, last_name
FROM customer
ORDER BY customer_id DESC
LIMIT 10;

-- 17. Selecciona todos los nombres de las películas únicos
SELECT DISTINCT(title)
FROM film
ORDER BY title ASC;

-- 21. Crea una columna con el nombre y apellidos de todos los actores
SELECT 
    actor_id,
    CONCAT(first_name, ' ', last_name) AS full_name
FROM actor
ORDER BY last_name, first_name;

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

-- puede que haya 200 ID con 1 nombre duplicado ^^

-- 38. Selecciona todos los actores y ordénalos por apellido en orden ascendente
SELECT actor_id, first_name, last_name
FROM actor
ORDER BY last_name ASC, first_name ASC;

-- 39. Selecciona las primeras 5 películas de la tabla film
SELECT title
FROM film
LIMIT 5;

-- 58. Películas que tienen la misma duración que Dancing Fever
SELECT title
FROM film
WHERE length = (
    SELECT length
    FROM film
    WHERE title = 'Dancing Fever'
)
ORDER BY title;