-- Analysis of premium and luxury brands used car sales on craiglist. But first, a couple of fun facts.
-- Viewing the whole dataset
SELECT *
FROM Projects.dbo.craiglist_used_cars
----------------------------------------------------------------------------
-- There are  lot of nulls. what is the total null count for every column? 
SELECT
	COUNT(case when region is null then 1 end) null_region,
	COUNT(case when price is null then 1 end) null_price,
	COUNT(case when year is null then 1 end) null_year,
	COUNT(case when manufacturer is null then 1 end) null_manufacturer,
	COUNT(case when model is null then 1 end) null_model,
	COUNT(case when condition is null then 1 end) null_condition,
	COUNT(case when cylinders is null then 1 end) null_cylinders,
	COUNT(case when fuel is null then 1 end) null_fuel,
	COUNT(case when odometer is null then 1 end) null_odometer,
	COUNT(case when title_status is null then 1 end) null_title_status,
	COUNT(case when transmission is null then 1 end) null_transmission,
	COUNT(case when drive is null then 1 end) null_drive,
	COUNT(case when size is null then 1 end) null_size,
	COUNT(case when type is null then 1 end) null_type,
	COUNT(case when paint_color is null then 1 end) null_paint_color,
	COUNT(case when county is null then 1 end) null_county,
	COUNT(case when state is null then 1 end) null_state,
	COUNT(case when posting_date is null then 1 end) null_posting_date
FROM Projects.dbo.craiglist_used_cars
-- County, condition, and size contain a lot of null values. 
-- we will leave county since we have state and region. 
----------------------------------------------------------------
-- During with period was our data collected?
select min(posting_date) starting_date, max(posting_date) ending_date
FROM Projects.dbo.craiglist_used_cars
-- Our data was collected between April and May 2021.
--------------------------------------------------------------------
-- What are the different types of car present in our dataset?
SELECT cylinders, 
	ISNULL(fuel, 'unknown') AS fuel,
    ISNULL(transmission, 'unknown') AS transmission,
    ISNULL(drive, 'unknown') AS drive,
    ISNULL(size, 'unknown') AS size,
    ISNULL(type, 'unknown') AS typefuel,
	count(*) listing_count
FROM Projects.dbo.craiglist_used_cars
WHERE cylinders is not null 
GROUP BY cylinders, manufacturer, fuel, transmission, drive, size, type
--------------------------------------------------------------------------
-- What are the different car makes that were listed during this period?
SELECT manufacturer, fuel, count(*) as listing_counts
FROM Projects.dbo.craiglist_used_cars
WHERE manufacturer is not null
GROUP BY manufacturer, fuel
ORDER BY listing_counts desc
-------------------------------------------------------------------------------------
-- What are the most popular car models sold whithin this period?
SELECT CONCAT(manufacturer, ' ', model) model, count(*) car_count
FROM Projects.dbo.craiglist_used_cars
WHERE manufacturer is not null and model is not null
group by manufacturer, model
order by car_count desc
-- less than 60, 57 models to be precise were listed more than 1000 times
-------------------------------------------------------------------------------------
-- what is the percent different between the popular models and less popular models?
WITH listing_count AS (
    SELECT CONCAT(manufacturer, ' ', model) AS model,
           COUNT(*) AS listing_count 
    FROM Projects.dbo.craiglist_used_cars
    WHERE manufacturer IS NOT NULL AND model IS NOT NULL
    GROUP BY manufacturer, model
)
SELECT
    SUM(CASE WHEN listing_count > 1000 THEN listing_count ELSE 0 END) AS popular_count,
    SUM(CASE WHEN listing_count <= 1000 THEN listing_count ELSE 0 END) AS less_popular_count,
    ROUND(SUM(CASE WHEN listing_count > 1000 THEN listing_count ELSE 0 END) * 100.0 / SUM(listing_count),2) AS popular_percentage,
    ROUND(SUM(CASE WHEN listing_count <= 1000 THEN listing_count ELSE 0 END) * 100.0 / SUM(listing_count),2) AS less_popular_percentage
FROM listing_count;
------------------------------------------------------------------------------------------------------------------------------------------
-- when were the cars made?
SELECT year, count(*) car_counts
FROM Projects.dbo.craiglist_used_cars
WHERE year is not null
GROUP BY year
-------------------------------------------------------------------------------------------------------------------------------------------
-- Let's focus on luxury cars?
SELECT  region, price, year, manufacturer, model, condition, cylinders, fuel, odometer, title_status, transmission,
	drive, size, type, paint_color, state, posting_date
INTO #luxury_cars
FROM Projects.dbo.craiglist_used_cars
WHERE manufacturer IN ('acura', 'alfa-romeo', 'aston-martin', 'audi', 'bmw', 'buick', 'cadillac', 'ferrari', 
	'infiniti', 'jaguar','land rover', 'lexus', 'lincoln', 'mercedes-benz', 'porsche', 'tesla')
ORDER BY manufacturer;

SELECT *
FROM #luxury_cars
--------------------------------------------------------------------------------------------------------------------------------------------
-- what is the breakdown of sales by state and regions for luxury cars?
SELECT state, region, count(*) listings_count
FROM #luxury_cars
GROUP BY state, region
ORDER BY state
--------------------------------------------------------------------------------------------------------------------------------------------
-- what is the overall condition of those cars?
SELECT condition, count(*) listing_count
FROM #luxury_cars
GROUP BY condition
--------------------------------------------------------------------------------------------------------------------------------------------
-- what are the specs of legitimate listings?
SELECT cylinders,
    ISNULL(fuel, 'unknown') AS fuel,
    ISNULL(transmission, 'unknown') AS transmission,
    ISNULL(drive, 'unknown') AS drive,
    ISNULL(size, 'unknown') AS size,
    ISNULL(type, 'unknown') AS type,
    COUNT(*) AS car_count
FROM #luxury_cars
WHERE cylinders is not null
GROUP BY cylinders, fuel, transmission, drive, size, type;
----------------------------------------------------------------------------------------------------------------------------------
-- what are the most popular manufacturers, and models?
SELECT manufacturer, model, count(*) listings_count, max(price) price_max, round(AVG(price),2) price_avg, min(price) price_min
FROM #luxury_cars
WHERE manufacturer is not null and model is not null and price !=0
GROUP BY manufacturer, model
ORDER BY listings_count desc
-----------------------------------------------------------------------------------------------------------------------------------
-- what are the good luxury cars that could be worth buying?
SELECT *
FROM #luxury_cars
WHERE odometer < 60000
	and model is not null
	and cylinders is not null
	and drive is not null
	and size is not null
	and condition is not null 