explain analyze
SELECT cars.manufacturer,
    cars.model,
    cars.country,
    cars.year,
    MAX(engines.horse_power) AS maximum_horse_power
FROM cars
    JOIN engines ON cars.engine_name = engines.name
WHERE cars.year > 2015
    AND cars.country = 'Germany'
GROUP BY cars.manufacturer,
    cars.model,
    cars.country,
    cars.year
HAVING MAX(engines.horse_power) > 200
ORDER BY maximum_horse_power DESC
LIMIT 2