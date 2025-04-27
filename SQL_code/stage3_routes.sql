/*Stage 3: Route and Market Analysis
Goal: Explore MCO’s key routes and market opportunities (origins, volumes) to guide expansion or marketing.

1.Top Routes by Volume
Goal: List top 10 origin cities to MCO, with flights and delays per airline.*/

WITH TopCities AS (
    SELECT TOP 10
        oa.AirportCode,
        oa.CityName,
        oa.StateName,
        COUNT(*) AS TotalCityFlights
    FROM Flights f
    JOIN Airports oa ON oa.AirportCode = f.OriginAirportCode
    WHERE f.DestAirportCode = 'MCO'
    GROUP BY oa.AirportCode, oa.CityName, oa.StateName
    ORDER BY TotalCityFlights DESC
)
SELECT
    tc.AirportCode AS OriginAirportCode,
    tc.CityName AS OriginCity,
    tc.StateName AS OriginState,
    a.Description AS Airline,
    COUNT(*) AS TotalFlights,
    AVG(f.DepartureDelayMins) AS AVGDepDelayMins,
    RANK() OVER(PARTITION BY tc.airportcode ORDER BY COUNT(*) DESC) AS RankByAirline,
    tc.TotalCityFlights
FROM Flights f
JOIN Airlines a ON f.AirlineCode = a.Code
JOIN TopCities tc ON f.OriginAirportCode = tc.AirportCode
WHERE f.DestAirportCode = 'MCO' AND f.DepartureDelayMins IS NOT NULL
GROUP BY tc.AirportCode, tc.CityName, tc.StateName, a.Code, a.Description, tc.TotalCityFlights
ORDER BY tc.TotalCityFlights DESC, TotalFlights DESC;


/*2.Airline Route Dominance
Goal: Rank airlines by flight share for each top origin city.*/
WITH Top10Cities AS (
    SELECT TOP 10
        oa.CityName AS City,
        COUNT(*) AS TotalFlights
    FROM Flights f
    JOIN Airports oa ON oa.AirportCode = f.OriginAirportCode
    WHERE f.DestAirportCode = 'MCO'
    GROUP BY oa.CityName
    ORDER BY COUNT(*) DESC),
FlightsPerAirline AS (
    SELECT 
        oa.CityName AS City,
        f.AirlineCode AS Airline,
        COUNT(*) AS TotalFlights
    FROM Flights f
    JOIN Airports oa ON oa.AirportCode = f.OriginAirportCode
    WHERE f.DestAirportCode = 'MCO'
    GROUP BY oa.CityName, f.AirlineCode),
AirlineShare AS (
    SELECT
        fa.City,
        fa.Airline,
        fa.TotalFlights,
        tc.TotalFlights AS TotalCityFlights,
        ROUND((CAST(fa.TotalFlights AS FLOAT) / tc.TotalFlights) * 100, 2) AS PercentageOfFlightsByAirline
    FROM FlightsPerAirline fa
    JOIN Top10Cities tc ON tc.City = fa.City)
SELECT 
    City,
    Airline,
    TotalFlights,
    TotalCityFlights,
    PercentageOfFlightsByAirline,
    RANK() OVER (PARTITION BY City ORDER BY PercentageOfFlightsByAirline DESC) AS AirlineRankInCity
FROM AirlineShare
ORDER BY City, AirlineRankInCity;

/*3.Underserved Routes
Goal: Find origin cities with high delays but low flights—expansion potential.*/

SELECT
	oa.CityName AS City,
	COUNT(*) AS TotalFlights,
	AVG(f.departuredelaymins) AS AVGDepartureDelayMins
FROM Flights f
JOIN Airports oa ON oa.AirportCode = f.OriginAirportCode
WHERE f.DestAirportCode = 'MCO' AND f.IsCancelled = 0
GROUP BY oa.CityName
HAVING COUNT(*) < 300 AND AVG(f.departuredelaymins) > 15
ORDER BY TotalFlights ASC, AVGDepartureDelayMins DESC;
