-- DROP TABLE craiglist_used_cars

/*
CREATE TABLE craiglist_used_cars(
    id VARCHAR(MAX),
    region VARCHAR(MAX),
    price VARCHAR(MAX),
    year VARCHAR(MAX),
    manufacturer VARCHAR(MAX),
    model VARCHAR(MAX),
    condition VARCHAR(MAX),
    cylinders VARCHAR(MAX),
    fuel VARCHAR(MAX),
    odometer VARCHAR(MAX),
    title_status VARCHAR(MAX),
    transmission VARCHAR(MAX),
    VIN VARCHAR(MAX),
    drive VARCHAR(MAX),
    size VARCHAR(MAX),
    type VARCHAR(MAX),
    paint_color VARCHAR(MAX),
    county VARCHAR(MAX),
    state VARCHAR(MAX),
    lat VARCHAR(MAX),
    long VARCHAR(MAX),
    posting_date VARCHAR(MAX)
);
*/

SELECT *
FROM craiglist_used_cars

-- Transforming the null into actual Null
UPDATE dbo.craiglist_used_cars
SET id = NULLIF(id, 'NULL'),
    region = NULLIF(region, 'NULL'),
    price = NULLIF(price, 'NULL'),
    year = NULLIF(year, 'NULL'),
    manufacturer = NULLIF(manufacturer, 'NULL'),
    model = NULLIF(model, 'NULL'),
    condition = NULLIF(condition, 'NULL'),
    cylinders = NULLIF(cylinders, 'NULL'),
    fuel = NULLIF(fuel, 'NULL'),
    odometer = NULLIF(odometer, 'NULL'),
    title_status = NULLIF(title_status, 'NULL'),
    transmission = NULLIF(transmission, 'NULL'),
    VIN = NULLIF(VIN, 'NULL'),
    drive = NULLIF(drive, 'NULL'),
    size = NULLIF(size, 'NULL'),
    type = NULLIF(type, 'NULL'),
    paint_color = NULLIF(paint_color, 'NULL'),
    county = NULLIF(county, 'NULL'),
    state = NULLIF(state, 'NULL'),
    lat = NULLIF(lat, 'NULL'),
    long = NULLIF(long, 'NULL'),
    posting_date = NULLIF(posting_date, 'NULL');

-- Our column of interest in price so we will filter where price is not null
SELECT COUNT(*),
FROM dbo.craiglist_used_cars
WHERE price IS NOT NULL
-- Price has no null columns
WITH ModelCounts AS (
    SELECT manufacturer, model
    FROM dbo.craiglist_used_cars
    WHERE manufacturer IS NOT NULL AND model IS NOT NULL
    GROUP BY manufacturer, model
    HAVING COUNT(*) > 10
)
SELECT cars.*
FROM ModelCounts temp
LEFT JOIN dbo.craiglist_used_cars cars
    ON temp.manufacturer = cars.manufacturer AND temp.model = cars.model;

-- SELECT THE DATASET THAT WE WANT
WITH PopularModels AS (
SELECT region, price, year, cars.manufacturer, cars.model, condition, cylinders, fuel, odometer, title_status, 
	transmission, drive, size, type, paint_color, county, state, lat, long, posting_date
FROM (
	SELECT manufacturer, model
    FROM dbo.craiglist_used_cars
    WHERE manufacturer IS NOT NULL AND model IS NOT NULL
    GROUP BY manufacturer, model
    HAVING COUNT(*) > 10) temp
LEFT JOIN dbo.craiglist_used_cars cars
    ON temp.manufacturer = cars.manufacturer AND temp.model = cars.model
)
SELECT * FROM PopularModels;




	
