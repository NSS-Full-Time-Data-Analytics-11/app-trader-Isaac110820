
-- 3.b. Develop a Top 10 List of the apps that App Trader should buy based on 
-- profitability/return on investment as the sole priority.

-- CTE that filters for apps with the minimum price and maxium ratings in both tables (these will be the most profitable)
(WITH both_tables AS ((SELECT name, 
					   		  price::money::decimal, 
					   		  rating, 
					   		  review_count::decimal,
					   		  -- Calculate the purchase price
					   		  CASE WHEN price::money::decimal <= 2.5 THEN 25000
						 		   WHEN price::money::decimal > 2.5 THEN (price::decimal*10000)
						 		   END AS purchase_price,
					   		  -- Calculate the apps longevity (round rating to the nearest .25 using "ROUND(rating*4)/4")
					   		  ROUND(1 + (ROUND(rating*4)/4*2) * 12, 2) AS longevity
					FROM app_store_apps
					-- Filter for apps with the minimum price and maximum rating
					WHERE price::money::decimal <= 2.50 
					   	  AND ROUND(rating*4)/4 = 5.0)
					  
					-- Calculate the same columns for the play_store_apps table and combine the results
					UNION ALL
					  
					(SELECT name, 
					 		price::money::decimal, 
					 		rating, 
					 		review_count::decimal,
					 		-- Calculate the purchase price
					   		CASE WHEN price::money::decimal <= 2.5 THEN 25000
						 		 WHEN price::money::decimal > 2.5 THEN (price::decimal*10000)
						 		 END AS purchase_price,
					   		-- Calculate the apps longevity (round rating to the nearest .25 using "ROUND(rating*4)/4")
					   		ROUND(1 + (ROUND(rating*4)/4*2) * 12, 2) AS longevity
					FROM play_store_apps
					WHERE price::money::decimal <= 2.50 
					  	  AND ROUND(rating*4)/4 = 5.0))	

-- Select everything from the CTE and also calculate total revenue and total profit
SELECT name,
 	   purchase_price,
 	   -- Calculate total_revenue (revenue per month * longevity)
       5000 * longevity AS total_revenue,
 	   -- Calculate total_profit (total revenue - purchase price)
 	   (5000 * longevity) - purchase_price AS total_profit
FROM both_tables
-- Filter the CTE with a sub-query that contains the names of the apps that are listed on both platforms
WHERE name IN (SELECT name
			   FROM play_store_apps
			   INTERSECT
			   SELECT name
			   FROM app_store_apps))
			   
			   
-- The previous table gives us a list of the most profitable apps that are listed on both platforms
-- We need to add 2 more apps to this list to get to 10
-- Add two more apps to the bottom of this list using a UNION ALL with a list of the two apps we want to add
UNION ALL


-- We can use the same CTE that contains apps with the minimum price and maxium ratings in both tables (the most profitable apps)
(WITH both_tables AS ((SELECT name, 
					   		  price::money::decimal, 
					   		  rating, 
					   		  review_count::decimal,
					   		  -- Calculate the purchase price
					   		  CASE WHEN price::money::decimal <= 2.5 THEN 25000
						 		   WHEN price::money::decimal > 2.5 THEN (price::decimal*10000)
						 		   END AS purchase_price,
					   		  -- Calculate the apps longevity (round rating to the nearest .25 using "ROUND(rating*4)/4")
					   		  ROUND(1 + (ROUND(rating*4)/4*2) * 12, 2) AS longevity
					FROM app_store_apps
					-- Filter for apps with the minimum price and maximum rating
					WHERE price::money::decimal <= 2.50 
					   	  AND ROUND(rating*4)/4 = 5.0)
					  
					-- Calculate the same columns for the play_store_apps table and combine the results
					UNION ALL
					  
					(SELECT name, 
					 		price::money::decimal, 
					 		rating, 
					 		review_count::decimal,
					 		-- Calculate the purchase price
					   		CASE WHEN price::money::decimal <= 2.5 THEN 25000
						 		 WHEN price::money::decimal > 2.5 THEN (price::decimal*10000)
						 		 END AS purchase_price,
					   		-- Calculate the apps longevity (round rating to the nearest .25 using "ROUND(rating*4)/4")
					   		ROUND(1 + (ROUND(rating*4)/4*2) * 12, 2) AS longevity
					FROM play_store_apps
					WHERE price::money::decimal <= 2.50 
					  	  AND ROUND(rating*4)/4 = 5.0))

-- Of the most profitable apps that are only listed on one platform, we will take the two with the most reviews
-- Select everything from the CTE and also calculate total revenue and total profit
SELECT name,
 	   purchase_price,
 	   -- Calculate total_revenue (revenue per month * longevity)
       5000 * longevity AS total_revenue,
 	   -- Calculate total_profit (total revenue - purchase price)
 	   (5000 * longevity) - purchase_price AS total_profit
FROM both_tables
ORDER BY review_count DESC
LIMIT 2)

















