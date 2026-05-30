/* =========================
SECTION 1
DISASTER COUNT BY COUNTRY
========================= */

SELECT
location,
COUNT(*) AS disaster_count
FROM catastrophe.disaster_events
GROUP BY location
ORDER BY disaster_count DESC;


/* =========================
SECTION 2
DISASTER TYPE ANALYSIS
========================= */

SELECT
disaster_type,
COUNT(*) AS total_events,
ROUND(AVG(severity_level),2) AS avg_severity,
ROUND(AVG(estimated_damage),2) AS avg_damage
FROM catastrophe.disaster_events
GROUP BY disaster_type
ORDER BY avg_damage DESC;


/* =========================
SECTION 3
COUNTRY DAMAGE PROFILE
========================= */

SELECT
location,
COUNT(*) AS total_disasters,
SUM(estimated_damage) AS total_damage,
SUM(affected_population) AS total_affected
FROM catastrophe.disaster_events
GROUP BY location
ORDER BY total_damage DESC;


/* =========================
SECTION 4
RISK SUMMARY
========================= */

CREATE OR REPLACE VIEW catastrophe.risk_summary AS

SELECT
location,
COUNT(*) AS disaster_count,
SUM(estimated_damage) AS total_damage,
SUM(affected_population) AS affected_pop,
AVG(severity_level) AS avg_severity,

ROUND(
(
SUM(estimated_damage)/10000000.0
+
SUM(affected_population)/100000.0
)
*
AVG(severity_level)
,2) AS risk_score

FROM catastrophe.disaster_events

GROUP BY location;


/* =========================
SECTION 5
TOP 3 COUNTRIES PER DISASTER
WINDOW FUNCTION
========================= */

WITH ranked_disasters AS (

SELECT
location,
disaster_type,
COUNT(*) AS total_events,

RANK() OVER(
PARTITION BY disaster_type
ORDER BY COUNT(*) DESC
) AS disaster_rank

FROM catastrophe.disaster_events

GROUP BY location, disaster_type

)

SELECT *
FROM ranked_disasters
WHERE disaster_rank <= 3
ORDER BY disaster_type, disaster_rank;


/* =========================
SECTION 6
FINAL OUTPUTS
========================= */

SELECT * FROM catastrophe.risk_summary;