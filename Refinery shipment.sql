-- The objective of this analysis is to identify logistics insufficicies, to improve cargo planning and destination location

-- Retrieve dataset
SELECT *
FROM petrol_logistics;

-- Remove irrelevant column
ALTER TABLE petrol_logistics
DROP COLUMN `Destination Arrival Month`;

-- To identify logistics insuufificicies we calculate for weight discrepancy
SELECT 
`Type` , 
Refinery , 
`Origin Net Weight`,
`Destination Net Weight`,  (`Origin Net Weight`- `Destination Net Weight`) AS weight_loss
FROM petrol_logistics;

-- AVERAGE WEIGHT LOSS PER SHIPMENT 
SELECT Refinery, ROUND(AVG(`Origin Net Weight`- `Destination Net Weight`), 2) AS avg_weight_loss
FROM petrol_logistics
GROUP BY Refinery
ORDER BY avg_weight_loss;

-- DELIVERY DELAY 
SELECT 
`Work shift`,
`Origin Departure Date`,
`Destination Arrival Date`,
    DATEDIFF(`Destination Arrival Date`, `Origin Departure Date`) AS delivery_duration
FROM 
    petrol_logistics;
    
-- Avg delivery duration per destination 
SELECT 
     Refinery,
    `Work shift`,
    COUNT(*) AS shipment_count,
    ROUND(AVG(`Origin Departure Date` - `Destination Arrival Date`), 2) AS avg_weight_loss,
	ROUND(AVG( DATEDIFF(`Destination Arrival Date`, `Origin Departure Date`)),2 ) AS delivery_duration
FROM 
    petrol_logistics
GROUP BY 
    Refinery, `Work shift`
ORDER BY 
    avg_weight_loss DESC;

-- pattern analysis by date 
SELECT `Destination Arrival Date`,
COUNT(*) as shipment_volume
FROM petrol_logistics
GROUP BY 1;

-- is there a relationship between TYPE OF product and delivery discrepancies
SELECT `Type`, 
SUM(`Origin Net Weight`- `Destination Net Weight`) AS total_weight_loss,
ROUND(AVG(`Origin Net Weight`- `Destination Net Weight`), 2) AS weight_loss
FROM petrol_logistics
GROUP BY 1
ORDER BY weight_loss;
