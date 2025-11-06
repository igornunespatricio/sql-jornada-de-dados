explain analyze
SELECT cars.manufacturer,
    cars.model,
    cars.engine_name,
    engines.horse_power
FROM cars
    JOIN engines ON cars.engine_name = engines.name
LIMIT 2;