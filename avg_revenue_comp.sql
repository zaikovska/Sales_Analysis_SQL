
WITH sales_data AS (

SELECT
		customerkey,
		sum(netprice * quantity * exchangerate) AS net_revenue
FROM
		sales
GROUP BY
	customerkey
	)
	
SELECT 
avg(s.net_revenue) AS spending_customers_avg_revenue,
avg(COALESCE (s.net_revenue, 0)) AS all_customers_avg_revenue -- IF the value NULL CHANGE TO 0 
FROM customer c 
LEFT join sales_data s ON s.customerkey = c.customerkey