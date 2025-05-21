WITH customer_last_purchase AS (
	SELECT
		customerkey,
		cleaned_name,
		orderdate,
		--gets all orders 
       row_number() OVER (PARTITION BY customerkey ORDER BY orderdate desc) AS rn,
       first_purchase_date,
       cohort_year 

FROM
cohort_analysis ca 
),

churned_customers AS (

SELECT
	customerkey ,
	cleaned_name,
	orderdate AS last_purchase_date,
	cohort_year,
	CASE
		WHEN orderdate < (SELECT max(orderdate)FROM sales)  - INTERVAL '6 months' THEN 'churned'
		ELSE 'active'
	END AS customer_status
	
FROM
	customer_last_purchase
WHERE
	rn = 1
	AND first_purchase_date < (SELECT max(orderdate)FROM sales)  - INTERVAL '6 months' 
	)
	
SELECT
	cohort_year,
	customer_status,
	count(customer_status) AS customers_num,
	sum(count(customer_status)) OVER (PARTITION BY cohort_year) AS total_customers,
	round(count(customer_status) / sum(count(customer_status)) OVER (PARTITION BY cohort_year), 2) AS status_percentage
FROM
	churned_customers
GROUP BY
    cohort_year,
	customer_status
	

