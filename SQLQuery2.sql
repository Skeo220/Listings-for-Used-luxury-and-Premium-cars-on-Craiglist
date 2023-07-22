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
	*/
-------------------------------------
ALTER TABLE Projects.dbo.craiglist_used_cars
ALTER COLUMN price FLOAT

ALTER TABLE Projects.dbo.craiglist_used_cars
ALTER COLUMN posting_date DATE

-- SELECT THE DATASET THAT WE WANT
SELECT region, price, year, cars.manufacturer, cars.model, condition, cylinders, fuel, odometer, title_status, 
    transmission, drive, size, type, paint_color, state, lat, long, posting_date
INTO #popular_models
FROM (
    SELECT manufacturer, model
    FROM Projects.dbo.craiglist_used_cars
    WHERE manufacturer IS NOT NULL AND model IS NOT NULL
    GROUP BY manufacturer, model
    HAVING COUNT(*) > 1000
) temp
LEFT JOIN (
	SELECT *
	FROM Projects.dbo.craiglist_used_cars 
	WHERE region IS NOT NULL
	AND price IS NOT NULL
    AND year IS NOT NULL
    AND manufacturer IS NOT NULL
    AND model IS NOT NULL
    AND condition IS NOT NULL
    AND cylinders IS NOT NULL
    AND fuel IS NOT NULL
    AND odometer IS NOT NULL
    AND title_status IS NOT NULL
    AND transmission IS NOT NULL
    AND drive IS NOT NULL
    AND size IS NOT NULL
    AND type IS NOT NULL
    AND paint_color IS NOT NULL
    AND state IS NOT NULL
    AND lat IS NOT NULL
    AND long IS NOT NULL
    AND posting_date  IS NOT NULL)cars
ON temp.manufacturer = cars.manufacturer AND temp.model = cars.model
WHERE price != 0;

-------------------
SELECT *
FROM #popular_models