/*Stage 2: Operational Performance
Goal: Analyze airline efficiency (delays, cancellations) to identify operational strengths and weaknesses during MCO’s holiday rush.

1.On-Time Performance by Airline
Goal: Calculate on-time rate (delays ≤ 15 mins), avg delay, and cancellations per airline.*/
SELECT
	a.Description AS Airline,
	AVG(f.DepartureDelayMins) AS AVGDepDelayMins,
	SUM(CASE WHEN f.IsCancelled = 1 THEN 1 ELSE 0 END) AS TotalCancelled,
	COUNT(*) AS TotalFlights,
	ROUND((SUM(CASE WHEN f.DepartureDelayMins <= 15 THEN 1 ELSE 0 END) /
		CAST(COUNT(f.FlightID) AS float) * 100),2) AS OnTimeRate
FROM Flights f
JOIN Airlines a ON a.Code = f.AirlineCode
WHERE f.DestAirportCode = 'MCO'
GROUP BY a.Description, f.AirlineCode
ORDER BY TotalFlights DESC;

/*2.Delay Distribution
Goal: Bucket delays into categories (e.g., 0-15, 16-30, 31+ mins) per airline.*/
WITH DelayByFlight AS
	(SELECT f.flightid AS Flight,
			f.airlinecode AS Airline,
		CASE 
			WHEN f.DepartureDelayMins IS NULL THEN 'Unknown'
			WHEN f.DepartureDelayMins <= 0 THEN 'Before Scheduled'
			WHEN f.DepartureDelayMins <= 15 THEN 'On Time'
			WHEN f.DepartureDelayMins <= 30 THEN 'Slightly Delayed'
			ELSE 'Severe Delayed' END AS DelayType
	FROM Flights f
	WHERE f.DestAirportCode = 'MCO')
SELECT
	a.Description AS Airline,
	df.DelayType AS DelayType,
	COUNT(*) AS TotalFlights
FROM DelayByFlight df
JOIN Airlines a ON a.Code = df.Airline
GROUP BY a.Description, df.DelayType
ORDER BY TotalFlights DESC;

/*3.Reliability Ranking
Goal: Rank airlines by on-time performance, weighted by flight volume.*/

SELECT
    a.Description AS Airline,
    COUNT(*) AS TotalFlights,
    SUM(CASE WHEN f.DepartureDelayMins <= 15 THEN 1 ELSE 0 END) AS TotalOnTimeFlights,
    ROUND((SUM(CASE WHEN f.DepartureDelayMins <= 15 THEN 1 ELSE 0 END) / 
        CAST(COUNT(*) AS FLOAT)) * 100, 2) AS PercentageOfOnTimeFlights,
    RANK() OVER(ORDER BY 
        ROUND((SUM(CASE WHEN f.DepartureDelayMins <= 15 THEN 1 ELSE 0 END) / 
        CAST(COUNT(*) AS FLOAT)) * 100, 2) DESC,
        COUNT(*) DESC) AS RankingByOnTimePercentage
FROM Flights f
JOIN Airlines a ON f.AirlineCode = a.Code
WHERE f.DestAirportCode = 'MCO' AND f.DepartureDelayMins IS NOT NULL
GROUP BY a.Code, a.Description
ORDER BY PercentageOfOnTimeFlights DESC;
