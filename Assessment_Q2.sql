-- Assessment Task Q2 --
/* Calculate the average number of transactions per customer per month and categorize them into:
	● High Frequency (≥10 transactions/month)
	● Medium Frequency (3-9 transactions/month)
	● Low Frequency (≤2 transactions/month) */

WITH customer_stats AS (
  SELECT 
    u.id AS customer_id, 
    COUNT(s.id) AS total_transactions,
    TIMESTAMPDIFF(DAY, u.date_joined, CURRENT_DATE) / 30 AS tenure_months -- I use this to calculate the tenure in days.
  FROM users_customuser AS u
  LEFT JOIN savings_savingsaccount AS s
    ON s.owner_id = u.id
  GROUP BY u.id
),

customer_avg AS (
  SELECT
    customer_id,
    total_transactions / GREATEST(tenure_months, 1) AS avg_tx_per_month -- This Prevent division by zero by forcing a minimum tenure of 1 month
  FROM customer_stats
)
  
SELECT
  CASE
    WHEN avg_tx_per_month >= 10 THEN 'High Frequency'
    WHEN avg_tx_per_month >=  3 THEN 'Medium Frequency'
    WHEN avg_tx_per_month <=  2 THEN 'Low Frequency'
  END AS frequency_category,
  COUNT(*) AS customer_count,
  ROUND(AVG(avg_tx_per_month), 1) AS avg_transactions_per_month
FROM customer_avg
WHERE 
  CASE
    WHEN avg_tx_per_month >= 10 THEN 'High Frequency'
    WHEN avg_tx_per_month >=  3 THEN 'Medium Frequency'
    WHEN avg_tx_per_month <=  2 THEN 'Low Frequency'
  END IS NOT NULL -- To filter records with NULL transaction frequency 
GROUP BY frequency_category
ORDER BY
  CASE
    WHEN frequency_category = 'High Frequency' THEN 1
    WHEN frequency_category = 'Medium Frequency' THEN 2
    WHEN frequency_category = 'Low Frequency' THEN 3
  END;
