# MCO Airport Dec 2024: Inbound Flight Analysis

**Welcome to the SQL analysis of domestic flights arriving at Orlando International Airport (MCO) in December 2024.** This repository delivers actionable insights to optimize MCO’s holiday operations while showcasing advanced SQL techniques.

---

## **Project Aim**

The **objective** is to analyze **inbound flight patterns** at MCO during the peak holiday season, providing recommendations for resource allocation, operational efficiency, and passenger experience. The project balances **practical insights** for MCO authorities with **skill-building queries** to refine advanced SQL proficiency.

---

## **Data Source**

- **Source**: Bureau of Transportation Statistics (BTS), providing comprehensive data on domestic flights arriving at MCO in December 2024.
- **Database**: Structured into **three relational tables**:
  - **Flights**: Flight details (date, delays, cancellations).
  - **Airports**: Origin city and state information.
  - **Airlines**: Carrier names and codes.

---

## **Analysis Phases**

The SQL code, organized under `MCO Airport Dec 2024/`, is divided into **four phases**, each addressing key operational questions. Queries combine **practical analysis** for MCO with **advanced SQL practice** (e.g., `RANK`, `SUM OVER`, `CASE`).

1. **Stage 1: Exploratory Analysis** (`stage1_exploratory/`)  
   - **Purpose**: Identifies **high-traffic days** and **top origin cities** to guide staffing and planning.  
   - **Key Queries**:  
     - `eda_03_daily_traffic.sql`: Weekday traffic patterns.  
     - `eda_04_top_cities.sql`: City-level flight volumes and delays.  
   - **Note**: Includes queries to practice aggregations and joins, enriching MCO’s holiday insights.

2. **Stage 2: Operational Performance** (`stage2_operational/`)  
   - **Purpose**: Evaluates **airline reliability** for partnership and scheduling decisions.  
   - **Key Query**:  
     - `op_01_on_time.sql`: On-time rates, delays, cancellations by airline.  
   - **Note**: Combines metrics (e.g., Delta’s 85% on-time rate) with conditional logic practice.

3. **Stage 3: Route Analysis** (`stage3_routes/`)  
   - **Purpose**: Analyzes **dominant routes** (e.g., New York, Atlanta) to identify growth opportunities.  
   - **Key Query**:  
     - `route_01_top_routes.sql`: Flight volumes and delays by city and airline.  
   - **Note**: Uses window functions for ranking, with queries to hone partitioning skills.

4. **Stage 4: Trend Analysis** (`stage4_trends/`)  
   - **Purpose**: Detects **peak days** and **cancellation trends** to enhance operational resilience.  
   - **Key Query**:  
     - `trend_01_daily_peaks.sql`: Daily flight volumes, cancellations, percentages.  
   - **Note**: Balances actionable outputs (e.g., 3% cancellation rate on Dec 28) with dynamic SQL exercises.

---

## **Repository Structure**

- **`MCO Airport Dec 2024/`**: Contains all SQL code.  
  - `stage1_exploratory/`: Exploratory queries.  
  - `stage2_operational/`: Operational queries.  
  - `stage3_routes/`: Route queries.  
  - `stage4_trends/`: Trend queries.  

---

## **Additional Notes**

- **Practical vs. Skill-Building**: Most queries deliver **operational insights** (e.g., staffing for Dec 28 peaks), while select scripts practice **advanced SQL** (e.g., window functions, subqueries) to deepen expertise.  
- **Execution**: SQL scripts are compatible with **SQL Server Management Studio (SSMS)** using the MCO flight database.  
- **Visualization**: Query results were visualized in **Tableau** for the accompanying report, enhancing MCO’s strategic planning.

---
