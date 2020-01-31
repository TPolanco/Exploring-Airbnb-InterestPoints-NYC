/* Query by Tommy Polanco, 
   Email: tp2523@columbia.edu,
   Done on SQL Server,
   Feel free to reach out!

   NOTE: This query file modifies two tables
         that I've named dbo.airbnb and
		 dbo.interest_points,
		 and both correspond to the datasets
		 I've referenced in the Jupyter
		 Notebook. 
*/

-----/ BEGIN airbnb table \-----

-- quick check of the initial table's first 5 rows
SELECT TOP(10) * FROM dbo.airbnb;

-- check total number of rows
SELECT COUNT(*) FROM dbo.airbnb;

-- find data types of each column
SELECT 
	COLUMN_NAME,
	DATA_TYPE
FROM 
	INFORMATION_SCHEMA.COLUMNS
WHERE
	TABLE_NAME = 'airbnb';

-- update NULL values to 0 in reviews_per_month column
UPDATE
	dbo.airbnb
SET
	reviews_per_month = 0 
WHERE 
	reviews_per_month IS NULL;

-- remove columns we won't need
ALTER TABLE 
	dbo.airbnb
DROP COLUMN 
	host_id, 
	host_name;

-- check for duplicates and display rows
WITH cte AS (
	SELECT 
		id, 
		name,
		COUNT(*) AS frequency
	FROM 
		dbo.airbnb
	GROUP BY 
		id, 
		name
	HAVING 
		COUNT(*) > 1
)
SELECT TOP(10)
	*
FROM 
	dbo.airbnb
INNER JOIN cte ON
	cte.id = dbo.airbnb.id 
	AND 
	cte.name = dbo.airbnb.name
ORDER BY
	dbo.airbnb.id,
	dbo.airbnb.name;

-- check for total number of duplicates in the table
WITH cte AS (
	SELECT
		id,
		name,
		COUNT(*) AS frequency
	FROM
		dbo.airbnb
	GROUP BY
		id,
		name
	HAVING
		COUNT(*) > 1
)
SELECT 
	COUNT(*) AS total_duplicate_rows
FROM 
	cte;

-- drop duplicates
WITH cte AS (
	SELECT
		*,
		row_num = ROW_NUMBER() OVER (PARTITION by id, name ORDER BY id, name)
	FROM
		dbo.airbnb
)
DELETE FROM cte WHERE row_num > 1;

-- rename the following columns for more clarity and brevity
EXEC sp_rename 
	'airbnb.neighbourhood_group', 'borough', 'COLUMN';
EXEC sp_rename 
	'airbnb.number_of_reviews', 'review_count', 'COLUMN';
EXEC sp_rename 
	'airbnb.calculated_host_listings_count', 'host_listings_count', 'COLUMN';

SELECT TOP(10) * FROM dbo.airbnb;

-----\ END airbnb table /-----

-----/ BEGIN interest_points table \-----

-- let's take a brief look at the initial table
SELECT TOP(15) * FROM dbo.interest_points;

-- check total number of rows
SELECT COUNT(*) FROM dbo.interest_points;

-- find data types of each column
SELECT 
	COLUMN_NAME,
	DATA_TYPE
FROM 
	INFORMATION_SCHEMA.COLUMNS
WHERE
	TABLE_NAME = 'interest_points';

-- remove columns we won't need
ALTER TABLE 
	dbo.interest_points
DROP COLUMN 
	COMPLEXID, 
	SAFTYPE,
	SEGMENTID,
	SOS,
	PLACEID,
	FACI_DOM,
	BIN,
	CREATED,
	MODIFIED,
	B7SC,
	PRI_ADD;

---- change borough column entries from integers to strings to match airbnb's column
ALTER TABLE
	dbo.interest_points
ALTER COLUMN
	BOROUGH VARCHAR(15);

UPDATE
	dbo.interest_points
SET 
	BOROUGH = (
		CASE 
			WHEN BOROUGH = 1 THEN 'Manhattan'
			WHEN BOROUGH = 2 THEN 'Bronx'
			WHEN BOROUGH = 3 THEN 'Brooklyn'
			WHEN BOROUGH = 4 THEN 'Queens'
			WHEN BOROUGH = 5 THEN 'Staten Island'
		END)
WHERE
	(BOROUGH = 1) 
	OR (BOROUGH = 2)
	OR (BOROUGH = 3)
	OR (BOROUGH = 4)
	OR (BOROUGH = 5);

-- display null values on the borough column, delete rows with them
SELECT TOP(5) 
	* 
FROM 
	dbo.interest_points
WHERE 
	BOROUGH IS NULL;

DELETE FROM 
	dbo.interest_points
WHERE
	BOROUGH IS NULL;

-- change facility type column entries from integers to matching strings
ALTER TABLE
	dbo.interest_points
ALTER COLUMN
	FACILITY_T VARCHAR(25);

UPDATE
	dbo.interest_points
SET 
	FACILITY_T = (
		CASE 
			WHEN FACILITY_T = 1 THEN 'Residential'
			WHEN FACILITY_T = 2 THEN 'Education'
			WHEN FACILITY_T = 3 THEN 'Cultural'
			WHEN FACILITY_T= 4 THEN 'Recreation'
			WHEN FACILITY_T = 5 THEN 'Social Services'
			WHEN FACILITY_T = 6 THEN 'Transportation'
			WHEN FACILITY_T = 7 THEN 'Commercial'
			WHEN FACILITY_T = 8 THEN 'Government'
			WHEN FACILITY_T = 9 THEN 'Religious Institution'
			WHEN FACILITY_T = 10 THEN 'Health Services'
			WHEN FACILITY_T = 11 THEN 'Public Safety'
			WHEN FACILITY_T = 12 THEN 'Water'
			WHEN FACILITY_T = 13 THEN 'Miscellaneous'
		END)
WHERE
	(FACILITY_T = 1) 
	OR (FACILITY_T = 2)
	OR (FACILITY_T = 3)
	OR (FACILITY_T = 4)
	OR (FACILITY_T = 5)
	OR (FACILITY_T = 6)
	OR (FACILITY_T = 7)
	OR (FACILITY_T = 8)
	OR (FACILITY_T = 9)
	OR (FACILITY_T = 10)
	OR (FACILITY_T = 11)
	OR (FACILITY_T = 12)
	OR (FACILITY_T = 13);

SELECT TOP(10) * FROM dbo.interest_points;
-----\ END interest_points table /-----
	