-- Assessment Task Q1 --
/* Write a query to find customers with at least one funded savings plan and one funded investment plan, sorted by total deposits. */

SELECT
  u.id AS owner_id,
  CONCAT(u.first_name, ' ' , u.last_name)  AS name,
  COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,
  COUNT(DISTINCT CASE WHEN p.is_a_fund = 1          THEN p.id END) AS investment_count,
  ROUND((SUM(s.confirmed_amount) / 100.0), 2) AS total_deposits  -- convert kobo to naira as the base currency
FROM users_customuser AS u
JOIN savings_savingsaccount AS s
    ON s.owner_id = u.id
JOIN plans_plan AS p
    ON p.id = s.plan_id
WHERE s.confirmed_amount > 0   -- This is used to filter funded transactions only
GROUP BY u.id, name
HAVING COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) >= 1
      AND COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) >= 1
ORDER BY total_deposits DESC;
