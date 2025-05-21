SELECT
	cohort_year ,
	sum(total_net_revenu)
	
FROM
	cohort_analysis
GROUP BY
	cohort_year