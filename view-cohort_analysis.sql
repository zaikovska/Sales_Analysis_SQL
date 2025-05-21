DROP VIEW  cohort_analysis ; 

CREATE OR REPLACE VIEW public.cohort_analysis as
  WITH customer_revenue AS (
	SELECT
		s.customerkey,
		s.orderdate,
		sum( s.quantity::double PRECISION * s.exchangerate * s.netprice ) AS total_net_revenu,
		count(s.orderkey) AS num_orders,
		c.countryfull,
		c.givenname,
		c.surname
	FROM
		sales s
	LEFT JOIN customer c ON
		c.customerkey = s.customerkey
	GROUP BY
		s.customerkey,
		s.orderdate,
		c.countryfull,
		c.givenname,
		c.surname
)
 SELECT
	customerkey,
	orderdate,
	total_net_revenu,
	num_orders,
	countryfull,
	concat(trim(givenname), ' ', trim(surname)) AS cleaned_name,
	-- trim FOR spaces IN str
	min(orderdate) OVER (
		PARTITION BY customerkey
	) AS first_purchase_date,
	EXTRACT(YEAR FROM min(orderdate) OVER (PARTITION BY customerkey)) AS cohort_year
FROM
	customer_revenue cr;