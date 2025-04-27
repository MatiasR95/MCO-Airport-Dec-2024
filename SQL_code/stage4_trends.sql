/*Stage 4: Temporal Trends
Goal: Track flight and delay patterns over time (days, weeks) to optimize schedules and staffing.

1.Daily Flight Peaks
Goal: Summarize flights and delays by day of week, highlighting peaks.*/

SELECT
	DATENAME(WEEKDAY, f.FlightDate) AS DayOfTheWeek,
	COUNT(*) AS TotalFlights,
	RANK() OVER(ORDER BY COUNT(*) DESC) AS RankByTotalFlights,
	AVG(f.DepartureDelayMins) AS AVGDepDelayMins,
	SUM(CASE WHEN f.IsCancelled = 1 THEN 1 ELSE 0 END) AS TotalCancelledFlights,
	ROUND((SUM(CASE WHEN f.IsCancelled = 1 THEN 1 ELSE 0 END) / CAST(COUNT(*) AS FLOAT)) * 100, 2) AS PercentageOfCancelledFlights
FROM Flights f
WHERE f.DestAirportCode = 'MCO' 
GROUP BY DATEPART(WEEKDAY, f.FlightDate), DATENAME(WEEKDAY, f.FlightDate)
ORDER BY TotalFlights DESC;

/*2.Week-to-Week Delay Trends
Goal: Track delay changes week-to-week per airline, ranking improvement.*/
SELECT
	DATEPART(WEEK, f.FlightDate) AS WeekNumber,
	f.airlinecode AS Airline,
	AVG(f.departuredelaymins) AS AverageDepartureDelay,
	LAG(AVG(f.departuredelaymins)) OVER(PARTITION BY f.airlinecode ORDER BY DATEPART(WEEK, f.FlightDate) ASC) AS PreviousWeek
FROM Flights f
WHERE f.DestAirportCode = 'MCO'
GROUP BY DATEPART(WEEK, f.FlightDate), f.airlinecode
ORDER BY Airline ASC, WeekNumber ASC

/*3.Running Flight Totals
Goal: Calculate cumulative flights per airline over weeks.*/

SELECT
	f.AirlineCode AS Airline,
	DATEPART(WEEK, f.FlightDate) AS WeekNumber,
	COUNT(*) AS TotalWeekFlights,
	SUM(COUNT(*)) OVER(PARTITION BY f.AirlineCode ORDER BY DATEPART(WEEK, f.FlightDate) ASC) AS CumulativeFlights
FROM Flights f
WHERE f.DestAirportCode = 'MCO' AND f.IsCancelled = 0
GROUP BY DATEPART(WEEK, f.FlightDate), f.airlinecode
ORDER BY Airline ASC, WeekNumber ASC
