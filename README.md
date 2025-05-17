# Data Analytics Assessment

This repository contains SQL solutions for a Data Analyst proficiency assessment. Each task is addressed in its file (`Assessment_Q1.sql`, `Assessment_Q2.sql`, `Assessment_Q3.sql`, and `Assessment_Q4.sql`), with explanations and key assumptions outlined below.

---

## Q1: High-Value Customers with Multiple Products

* **Approach:** Joined `users_customuser`, `savings_savingsaccount`, and `plans_plan` to identify customers with both funded savings and investment plans. Used `COUNT(DISTINCT CASE…)` to count unique plan types and summed deposits.
* **Assumptions:** All deposit amounts are stored in kobo, converted to naira by dividing by 100. Only transactions with `confirmed_amount > 0` are considered “funded.”
* **Key Points:** Results are sorted by total deposits descending; full customer name is concatenated from `first_name` and `last_name`.

## Q2: Transaction Frequency Analysis

* **Approach:** Calculated each customer’s tenure in months using `TIMESTAMPDIFF(DAY, date_joined, CURRENT_DATE) / 30`, then computed average transactions per month. Categorized into High, Medium, and Low frequency buckets and aggregated counts and averages per bucket.
* **Assumptions:** A minimum tenure of one month is enforced (`GREATEST(tenure_months, 1)`) to prevent division by zero. Zero-transaction customers are included and fall into “Low Frequency.”
* **Key Points:** Used CTEs (`customer_stats`, `customer_avg`) for clarity; final output lists category, customer count, and rounded average transactions per month.

## Q3: Account Inactivity Alert

* **Approach:** Aggregated each plan’s last deposit date with `MAX(transaction_date)`, considering active plans only (`is_archived = 0`, `is_deleted = 0`). Flagged plans with no activity in the past 365 days by comparing with `DATE_SUB(CURRENT_DATE, INTERVAL 365 DAY)`.
* **Assumptions:** Plans without any deposits use their `created_on` date to calculate inactivity. Both savings and investment plans are included, labeled via a `CASE` expression.
* **Key Points:** `COALESCE(last_transaction_date, created_on)` ensures zero-deposit plans are captured; results sorted by inactivity duration.

## Q4: Customer Lifetime Value (CLV) Estimation

* **Approach:** For each customer, computed total transactions, sum of deposit values (converted to naira), and approximate tenure in months. Calculated average transaction value, then determined average profit per transaction (0.1% of average value). Applied the CLV formula: `(total_transactions / tenure_months) * 12 * avg_profit_per_transaction`.
* **Assumptions:** Profit per transaction is explicitly derived from the average transaction value (`avg_tx_value * 0.001`). Minimum tenure of one month enforced to avoid division by zero.
* **Key Points:** Used a single CTE (`cust_txn`) for aggregation and metric calculations; final results are rounded to two decimal places and ordered by highest CLV.

---

## Challenges Encountered

* **Dealing with Null Values:** At some point, the null values were treated either by filtering them or by using `COALESCE` 
---
