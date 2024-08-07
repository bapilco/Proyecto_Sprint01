-- TODO: This query will return a table with the differences between the real 
-- and estimated delivery times by month and year. It will have different 
-- columns: month_no, with the month numbers going from 01 to 12; month, with 
-- the 3 first letters of each month (e.g. Jan, Feb); Year2016_real_time, with 
-- the average delivery time per month of 2016 (NaN if it doesn't exist); 
-- Year2017_real_time, with the average delivery time per month of 2017 (NaN if 
-- it doesn't exist); Year2018_real_time, with the average delivery time per 
-- month of 2018 (NaN if it doesn't exist); Year2016_estimated_time, with the 
-- average estimated delivery time per month of 2016 (NaN if it doesn't exist); 
-- Year2017_estimated_time, with the average estimated delivery time per month 
-- of 2017 (NaN if it doesn't exist) and Year2018_estimated_time, with the 
-- average estimated delivery time per month of 2018 (NaN if it doesn't exist).
-- HINTS
-- 1. You can use the julianday function to convert a date to a number.
-- 2. order_status == 'delivered' AND order_delivered_customer_date IS NOT NULL
-- 3. Take distinct order_id.


SELECT
    month_no,
    CASE CAST(STRFTIME('%m', order_purchase_timestamp) AS INTEGER)
        WHEN 1 THEN 'Jan'
        WHEN 2 THEN 'Feb'
        WHEN 3 THEN 'Mar'
        WHEN 4 THEN 'Apr'
        WHEN 5 THEN 'May'
        WHEN 6 THEN 'Jun'
        WHEN 7 THEN 'Jul'
        WHEN 8 THEN 'Aug'
        WHEN 9 THEN 'Sep'
        WHEN 10 THEN 'Oct'
        WHEN 11 THEN 'Nov'
        WHEN 12 THEN 'Dec'
    END AS month,
   COALESCE(AVG(CASE WHEN strftime('%Y', order_purchase_timestamp) = '2016' THEN real_diff  END), null) AS Year2016_real_time,
   COALESCE(AVG(CASE WHEN strftime('%Y', order_purchase_timestamp) = '2017' THEN real_diff  END), null) AS Year2017_real_time,
   COALESCE(AVG(CASE WHEN strftime('%Y', order_purchase_timestamp) = '2018' THEN real_diff  END), null) AS Year2018_real_time,
   COALESCE(AVG(CASE WHEN strftime('%Y', order_purchase_timestamp) = '2016' THEN estimated_diff  END), null) AS Year2016_estimated_time,
   COALESCE(AVG(CASE WHEN strftime('%Y', order_purchase_timestamp) = '2017' THEN estimated_diff  END), null) AS Year2017_estimated_time,
   COALESCE(AVG(CASE WHEN strftime('%Y', order_purchase_timestamp) = '2018' THEN estimated_diff  END), null) AS Year2018_estimated_time
FROM
	(   SELECT  
	    STRFTIME('%m', order_purchase_timestamp) AS month_no,
	    oo.order_purchase_timestamp AS order_purchase_timestamp,
	    julianday(oo.order_delivered_customer_date) - julianday(oo.order_purchase_timestamp) AS real_diff,
	    julianday(oo.order_estimated_delivery_date) - julianday(oo.order_purchase_timestamp) AS estimated_diff
    FROM
        olist_orders oo
    WHERE oo.order_status = 'delivered' AND oo.order_delivered_customer_date IS NOT NULL
    GROUP BY
       oo.order_id
        ) AS subquery
GROUP BY
    month_no
ORDER BY
    month_no;