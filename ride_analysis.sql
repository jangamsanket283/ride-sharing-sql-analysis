-- Step 1: Overall Business Performance
SELECT 
    COUNT(*) AS total_rides,
    AVG((julianday(completed_at) - julianday(started_at)) * 24) AS avg_duration_hours
FROM trips
WHERE completed_at IS NOT NULL;

-- Step 2: Customer Segmentation
SELECT 
    rider_id,
    COUNT(*) AS total_rides,
    CASE 
        WHEN COUNT(*) > 50 THEN 'High Value'
        WHEN COUNT(*) > 20 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_type
FROM trips
GROUP BY rider_id;

-- Step 3: Top Customers (Ranking)
SELECT rider_id,
       COUNT(*) AS rides,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS rank
FROM trips
GROUP BY rider_id;

-- Step 4: Driver Performance
SELECT driver_id,
       COUNT(*) AS total_trips
FROM trips
GROUP BY driver_id
ORDER BY total_trips DESC;

-- Step 5: Peak Demand Analysis
SELECT strftime('%H', requested_at) AS hour,
       COUNT(*) AS total_rides
FROM trips
GROUP BY hour
ORDER BY total_rides DESC;

-- Step 6: Location-Based Demand
SELECT pickup_location_id,
       COUNT(*) AS total_rides
FROM trips
GROUP BY pickup_location_id
ORDER BY total_rides DESC;

-- Step 7: Above Average Customers (Subquery)
SELECT rider_id, total_rides
FROM (
    SELECT rider_id, COUNT(*) AS total_rides
    FROM trips
    GROUP BY rider_id
)
WHERE total_rides > (
    SELECT AVG(total_rides)
    FROM (
        SELECT COUNT(*) AS total_rides
        FROM trips
        GROUP BY rider_id
    )
);