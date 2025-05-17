-- Assessment Task Q3 --
/* Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days) */

WITH plan_activity AS (
  SELECT
    p.id AS plan_id,
    p.owner_id,
    p.is_regular_savings,
    p.is_a_fund,
    p.created_on,
    MAX(s.transaction_date) AS last_transaction_date -- Using this to find the most recent deposit plan date
  FROM plans_plan AS p
  LEFT JOIN savings_savingsaccount AS s
    ON s.plan_id = p.id
  WHERE p.is_archived = 0 AND p.is_deleted  = 0 -- using this to consider only active plans
  GROUP BY p.id, p.owner_id, p.is_regular_savings, p.is_a_fund, p.created_on
)

SELECT
  plan_id,
  owner_id,
  CASE
    WHEN is_regular_savings = 1 THEN 'Savings'
    WHEN is_a_fund          = 1 THEN 'Investment'
    ELSE 'Other'
  END AS type, -- Categorising the plan as Savings, Investment, and where no record is found, it should return Other.
  last_transaction_date,
  DATEDIFF(CURRENT_DATE, 
    COALESCE(last_transaction_date, created_on)
            ) AS inactivity_days -- Used this to get the days since the last activity (or since creation if never active)
FROM plan_activity
WHERE COALESCE(last_transaction_date, created_on) < DATE_SUB(CURRENT_DATE, INTERVAL 365 DAY) -- To see where no activity in the past 365 days
ORDER BY inactivity_days DESC;
