-- ============================================
-- STEP 5: Customer Segmentation Analysis
-- ============================================

-- 1. Default rate by city
SELECT
    c.city,
    COUNT(*) AS accounts,
    ROUND(100.0 * SUM(d.default_flag) / COUNT(*), 2) AS default_rate_pct
FROM customer_master c
JOIN account_master a ON a.customer_id = c.customer_id
JOIN default_model_dataset d ON d.account_id = a.account_id
GROUP BY c.city
ORDER BY default_rate_pct DESC;

-- 2. Default rate by occupation
SELECT
    c.occupation,
    COUNT(*) AS accounts,
    ROUND(100.0 * SUM(d.default_flag) / COUNT(*), 2) AS default_rate_pct
FROM customer_master c
JOIN account_master a ON a.customer_id = c.customer_id
JOIN default_model_dataset d ON d.account_id = a.account_id
GROUP BY c.occupation
ORDER BY default_rate_pct DESC;

-- 3. Default rate by age group (using CASE to bucket ages)
SELECT
    CASE
        WHEN c.age < 25 THEN 'Under 25'
        WHEN c.age BETWEEN 25 AND 34 THEN '25-34'
        WHEN c.age BETWEEN 35 AND 44 THEN '35-44'
        WHEN c.age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS age_group,
    COUNT(*) AS accounts,
    ROUND(100.0 * SUM(d.default_flag) / COUNT(*), 2) AS default_rate_pct
FROM customer_master c
JOIN account_master a ON a.customer_id = c.customer_id
JOIN default_model_dataset d ON d.account_id = a.account_id
GROUP BY age_group
ORDER BY age_group;

-- 4. Income band vs default rate
SELECT
    CASE
        WHEN c.annual_income < 300000 THEN 'Low Income (<3L)'
        WHEN c.annual_income BETWEEN 300000 AND 700000 THEN 'Mid Income (3L-7L)'
        WHEN c.annual_income BETWEEN 700001 AND 1500000 THEN 'High Income (7L-15L)'
        ELSE 'Very High Income (15L+)'
    END AS income_band,
    COUNT(*) AS accounts,
    ROUND(100.0 * SUM(d.default_flag) / COUNT(*), 2) AS default_rate_pct
FROM customer_master c
JOIN account_master a ON a.customer_id = c.customer_id
JOIN default_model_dataset d ON d.account_id = a.account_id
GROUP BY income_band
ORDER BY default_rate_pct DESC;

-- ============================================
-- STEP 6: Fraud Analysis
-- ============================================

-- 5. Most common fraud type
SELECT
    fraud_type,
    COUNT(*) AS num_alerts,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_alerts
FROM fraud_alerts
GROUP BY fraud_type
ORDER BY num_alerts DESC;

-- 6. Fraud alert status breakdown
SELECT
    status,
    COUNT(*) AS num_alerts
FROM fraud_alerts
GROUP BY status
ORDER BY num_alerts DESC;

-- 7. Fraud count vs default rate (does fraud history drive default?)
SELECT
    d.fraud_count,
    COUNT(*) AS accounts,
    ROUND(100.0 * SUM(d.default_flag) / COUNT(*), 2) AS default_rate_pct
FROM default_model_dataset d
GROUP BY d.fraud_count
ORDER BY d.fraud_count;

-- ============================================
-- STEP 7: Collections Analysis
-- ============================================

-- 8. Recovery amount by month (using account_open_date proxy since collections
--    table itself doesn't have a date column per README - join if you add one)
SELECT
    ca.account_id,
    COUNT(*) AS collection_records,
    SUM(ca.call_attempts) AS total_call_attempts,
    SUM(ca.recovery_amount) AS total_recovered
FROM collections_activity ca
GROUP BY ca.account_id
ORDER BY total_recovered DESC
LIMIT 20;

-- 9. Recovery by risk segment (collections effectiveness by risk level)
SELECT
    rs.risk_level,
    COUNT(DISTINCT ca.account_id) AS accounts_in_collections,
    SUM(ca.recovery_amount) AS total_recovered,
    ROUND(AVG(ca.call_attempts), 2) AS avg_call_attempts
FROM collections_activity ca
JOIN account_risk_segment rs ON rs.account_id = ca.account_id
GROUP BY rs.risk_level
ORDER BY total_recovered DESC;

-- 10. Collection effectiveness: recovery amount vs call attempts (does more effort = more recovery?)
SELECT
    call_attempts,
    COUNT(*) AS accounts,
    ROUND(AVG(recovery_amount), 2) AS avg_recovery_amount
FROM collections_activity
GROUP BY call_attempts
ORDER BY call_attempts;
