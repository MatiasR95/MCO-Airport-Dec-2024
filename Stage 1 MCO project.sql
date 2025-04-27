/*Stage 1: Exploratory Analysis
Activity 1: Airline Flight Summary
Goal: Count flights, cancellations, and average delays per airline to see who’s active at MCO.*/
SELECT
	a.Description AS Airline,
	COUNT(*) AS TotalFlights,
	AVG(f.DepartureDelayMins) AS AVGDepDelayMins,
	SUM(CASE WHEN f.iscancelled = 1 THEN 1 ELSE 0 END) AS TotalCancelledFlights
FROM flights f
JOIN Airlines a ON a.Code = f.AirlineCode
WHERE f.DestAirportCode = 'MCO' 
GROUP BY a.Description
ORDER BY TotalFlights DESC;

/*Activity 2: Data Quality Check
Goal: Identify duplicates, NULLs, or odd values in Flights (e.g., negative delays, missing dates).*/
--Checking Duplicates	
	SELECT COUNT(*)
	FROM Flights f
	GROUP BY f.FlightID
	HAVING COUNT(f.flightID) > 1;

--Finding NULLs
SELECT *
FROM Flights f
WHERE f.OriginAirportCode IS NULL OR
		f.AirlineCode IS NULL OR
		f.FlightNumber IS NULL;

--Checking outliers
SELECT 
		f.airlinecode AS Airline,
		MAX(f.DepartureDelayMins) AS MAXDepDelay,
		MIN(f.DepartureDelayMins) AS MINDepDelay,
		AVG(f.departuredelaymins) AS AVGDepDelay
FROM Flights f
WHERE f.DestAirportCode = 'MCO'
GROUP BY f.AirlineCode;

--Activity 3: Daily Traffic Patterns
--Goal: Summarize flights and delays by day to spot peak travel days.
SELECT
	DATENAME(WEEKDAY, f.flightdate) AS WeekDay,
	DATEPART(DAY, f.flightdate) AS DayNumber,
	DATENAME(WEEK, f.flightdate) AS Week,
	COUNT(*) AS TotalFlights,
	AVG(f.DepartureDelayMins) AS AVGDepDelay,
	SUM(CASE WHEN f.iscancelled = 1 THEN 1 ELSE 0 END) AS TotalCancellations
FROM flights f
WHERE f.DestAirportCode = 'MCO'
GROUP BY DATENAME(WEEKDAY, f.FlightDate), DATEPART(WEEKDAY, f.FlightDate), f.FlightDate
ORDER BY TotalFlights DESC

--Activity 4: Top Origin Cities
--Goal: List top 10 cities sending flights to MCO, with flights and delays.
SELECT TOP 10
	ao.CityName AS OriginCity,
	ao.StateName AS OriginState,
	COUNT(*) AS TotalFlights,
	AVG(f.departuredelaymins) AS AVGDepDelay
FROM flights f
JOIN Airports ao ON ao.AirportCode = f.OriginAirportCode
WHERE f.DestAirportCode = 'MCO'
GROUP BY ao.CityName, ao.StateName
ORDER BY TotalFlights DESC;

/*Activity 5: Delay Variability
Goal: Calculate statistical measures (mean, standard deviation) of delays per airline.*/

WITH MedianDelay AS (
    SELECT DISTINCT
        f.AirlineCode AS AirlineCode,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY f.DepartureDelayMins) OVER (PARTITION BY f.AirlineCode) AS Median
    FROM Flights f
    WHERE DestAirportCode = 'MCO' AND DepartureDelayMins IS NOT NULL
)
SELECT
    a.Description AS Airline,
    f.AirlineCode AS AirlineCode,
    COUNT(*) AS TotalFlightsToMCO,
    DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS AirlinesRankByTotalFlights,
    AVG(f.DepartureDelayMins) AS MeanDepartureDelay,
    STDEV(f.DepartureDelayMins) AS STDEVDepDelayMins,
    md.Median AS MedianDepartureDelay
FROM Flights f
JOIN Airlines a ON a.Code = f.AirlineCode
JOIN MedianDelay md ON md.AirlineCode = f.AirlineCode
WHERE f.DestAirportCode = 'MCO' AND f.DepartureDelayMins IS NOT NULL
GROUP BY f.AirlineCode, a.Description, md.Median
ORDER BY TotalFlightsToMCO DESC;

