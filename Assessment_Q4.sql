-- Assessment Task Q4 --
/* For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
	● Account tenure (months since signup)
	● Total transactions
	● Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
	● Order by estimated CLV from highest to lowest */
    
    
WITH cust_txn AS (
  SELECT
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COUNT(s.id) AS total_transactions, -- This count how many deposit transactions customer has made
    ((SUM(s.confirmed_amount) / 100) / NULLIF(COUNT(s.id), 0)) * 0.001 AS avg_profit_per_transaction, -- Profit per transaction is said to be 0.1% of avg_tx_value
    TIMESTAMPDIFF(DAY, u.date_joined, CURRENT_DATE) / 30 AS tenure_months -- Convert the tenure to months using 30days
  FROM users_customuser AS u
  LEFT JOIN savings_savingsaccount AS s
    ON s.owner_id = u.id
  GROUP BY u.id, name, u.date_joined
)

SELECT
  customer_id,
  name,
  ROUND(tenure_months) AS tenure_months, -- round tenure to a whole month
  total_transactions,
  ROUND((total_transactions / NULLIF(GREATEST(tenure_months, 1), 0)) * 12 * avg_profit_per_transaction , 2) AS estimated_clv -- Calculating the CLV and rounding it up to 1 decima place
FROM cust_txn
ORDER BY estimated_clv DESC;
