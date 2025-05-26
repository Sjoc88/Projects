    ### AIRBNB European dataset 2023

La Descripción completa de todas las estancias Airbnb en Europa con el tipo de estancia, precios y a qué distancia está del metro y del centro de la ciudad y muchos otros detalles para realizar el análisis necesario.

## 1. Objectivo

Creación de un o varios Dashboards interactivos para soportar la visualización de datos y poder quizas proporcionar insights en base a esos datos.

## 2. Estructura del Repo

```bash
|------ Data
    | - Airbnb.csv #datos originales
|------ Excel
```

## 3. Estructura del Excel

El conjunto de datos nos da información sobre destinos claves en Europa cuyos estén registrado en la plataforma de Airbnb. De manera general, son capitales. Los datos nos proporcionan información sobre los precios de dichos alojamientos tal y como detalles sobre el tipo de alojamiento (leisure / business, Private / Shared) pero tambien sus distancias con el centro historico o al metro mas cercano. Adicionalmente, nos comparte informacíon sobre el numero de restaurantes en dichas cuidades. Por fin, nos da notas de satisfacion de los usuarios en cuanto a la limpieza y a la satisfacción general. Son datos muy interesantes a lo hora de interpretar el vinculos (la correlación) entre unos datos y otros.

Antes de irnos a la descripción de las columnas, cabe destacar que el dataset nos da información sobre 41714 alojamientos, los cuales fueron actualizados en 2022.

Los alojamientos por cuidaddes, las cuales son en total 9:

- Amsterdam	    2080
- Athens	    5280
- Barcelona	    2833
- Berlin	    2484
- Budapest	    4022
- Lisbon	    5763
- Paris	        6688
- Rome	        9027
- Vienna	    3537

## 4. Descripción de las columnas

### City: 
La cuidad en la cual está ubicado el alojamiento

### Price:
El precio de una noche en dicho alojamiento

### Day:
Si el alojamiento esta disponible para reservar entre semana, o durante el fin de semana

### Room type:
Si se trata de un alojamiento entero, privado, o compartido

### Superhost:
Si el inquilino tiene el 'estatuto' de Superhost, según criterios definidos por Airbnb, relacionados con la alta nota de satisfacción de los viajeros

### Business:
Si el alojamiento es apto o mas bien adecuado para viajeros professionales

### Cleanliness Rating:
La nota de limpieza adjudicada por los usuarios/viajeros (de 1 a 10, 10 siendo la maxima puntuación)

### Guest Satisfaction:
La puntuación general de los usuarios

### City Center (km):
La distancia del alojamiento al centro cuidad

###	Metro Distance (km):
La distancia del alojamiento al metro mas cercano

### Attraction Index:
La atractividad del alojamiento

###	Normalised Attraction Index:
La atractividad del alojamiento normalizada

###	Restaurant Index:
La cantidad de restaurantes (indexado) alreadedor del alojamiento

###	Normalised Restraunt Index:
La cantidad de restaurantes (indexado) alreadedor del alojamiento normalizada

## 5. Primeros pasos

### DÍA 1

Limpieza:

- Hoy 20 de Mayo, hemos cambiado a 'Number' el formato de nuestros datos numericos

- También hemos decidido deshacernos de la columna 'Multiple rooms', la cual cuando era FALSE, seguiamos teniendo miles de alojamientos con 1 o mas Bedrooms. No tenía mucho sentido, ni impacto a primera vista.

- Nos hemos deshecho de la columna 'Shared room', lo cual nos esta dado por el 'Room type' directamente

Analisis rápida:

- Hemos creado unas tablas de Estasdisticas Descriptivas para tener a mano algunos datos sobre los datos numericos de nuestro df. 

- Una pivot table para tener a mano una breve captura de cuantos alojamientos por cuidades, el precio promedio y el index de atractividad promedio tal y como la satisfacción general de los usuarios promedios por cada cuidad. 

### DÍA 2

Agrupacición y rangos:

- Después de haber insertado una pivot table para destacar las evaluaciones generales, hemos agrupado las puntuaciones (en rango de unidades de 10) para así poder ver dichas puntuaciones en diferentes rangos. Adicionalemente, insertaremos coulumnas al lado de las columnas para las cuales sería relevante tener una etiqueta considerando aquellos rangos (ie. Reseña mala, Reseña buena, Reseña excelente). Esa etapa tambien valdría para la limipìeza (con rango de unidades de 1) pero tambien para los precios y las distancias. Hasta para los indices.

Limpieza:
- Al imponer rangos para los precios, nos dimos cuenta que el formato de los datos brutos incluía un monton de decimales... lo cual complicaba mucho la lisibilidad del grafico (Pivot sheet) una vez activada la agrupacion de los precios. Nos tuvimos que ir al Power Query para rondear los precios y así, ¡mucho mejor!

- Tendremos que hacer el mismo preceso para las distancias al centro, y al metro. Al final de las 2 opciones de agrupar por unidades o por etiquetas, creo que saldría a cuenta lo de las etiquetas... menos faena de limpieza de datos.

Visibilidad:
- Para el grafico de 'Bedrooms' utilizaremos un axis y con escala logaritmica, de otra manera no se podría apreciar bien el recuento de alojamientos con 5 o mas habitaciones

### DÍA 3

Agrupación:
- Hoy agrupamos las distancias al metro y al centro en varios grupos

Cluster:
- Hemos creado 3 graficos de cluster bajo la sheet 'Analysis' para analizar brevemente si existe una correlacioón entre el precio y otros datos, como por ejemplo las distancias al metro/centro, la capacidad de los alojamientos o por ejemplo el tipo de alojamiento. 
Aquí nos encontramos con une problemilla a la hora de hacer un grafico de cluster para el tipo de alojamiento, ya que no es un dato quantitativo...

Dashboard:
- Hoy empezamos a introducir elementos en nustro Dashboard. En prcincipio, el Dashboard nos permite hacer 2 cosas basicas;
   1. Ver el precio promedio por noche en funcion de criterios personalizados con slicers
   2. Ver cuantos apartamentos hay disponibles por cuidades en funcion de criterios personalizados, siempre usando slicers