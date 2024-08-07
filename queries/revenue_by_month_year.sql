-- TODO: This query will return a table with the revenue by month and year. It
-- will have different columns: month_no, with the month numbers going from 01
-- to 12; month, with the 3 first letters of each month (e.g. Jan, Feb);
-- Year2016, with the revenue per month of 2016 (0.00 if it doesn't exist);
-- Year2017, with the revenue per month of 2017 (0.00 if it doesn't exist) and
-- Year2018, with the revenue per month of 2018 (0.00 if it doesn't exist).

SELECT
    month_no,
    CASE CAST(STRFTIME('%m', order_delivered_customer_date) AS INTEGER)
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
    SUM(CASE WHEN STRFTIME('%Y', order_delivered_customer_date) = '2016' THEN payment_value ELSE 0 END) AS Year2016,
    SUM(CASE WHEN STRFTIME('%Y', order_delivered_customer_date) = '2017' THEN payment_value ELSE 0 END) AS Year2017,
    SUM(CASE WHEN STRFTIME('%Y', order_delivered_customer_date) = '2018' THEN payment_value ELSE 0 END) AS Year2018
FROM
	(SELECT  
	    STRFTIME('%m', order_delivered_customer_date) AS month_no,
	    oop.payment_value AS payment_value,
	    oo.order_delivered_customer_date AS order_delivered_customer_date
    FROM
        olist_orders oo JOIN olist_order_payments oop  ON oo.order_id = oop.order_id 
    WHERE oo.order_status = 'delivered' AND oo.order_delivered_customer_date IS NOT NULL
    GROUP BY
        oo.order_id) AS subquery
GROUP BY
    month_no
ORDER BY
    month_no;