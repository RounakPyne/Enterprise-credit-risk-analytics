-- ============================================
-- DAY 1: Portfolio KPIs & Risk Segmentation
-- ============================================

-- 1. Total accounts & total exposure (credit limit sum)
SELECT
    COUNT(*)                       AS total_accounts,
    SUM(credit_limit)              AS total_exposure,
    ROUND(AVG(credit_limit), 2)    AS avg_credit_limit
FROM account_master;

-- 2. Latest snapshot per account (needed for current-state KPIs)
-- Using DISTINCT ON: fast, idiomatic Postgres way to get "latest row per group"
CREATE OR REPLACE VIEW latest_snapshot AS
SELECT DISTINCT ON (account_id)
    account_id, snapshot_month, utilization_ratio, days_past_due, payment_ratio
FROM monthly_account_snapshot
ORDER BY account_id, snapshot_month DESC;

-- 3. Delinquency rate (accounts with DPD > 0 in latest snapshot)
SELECT
    ROUND(100.0 * SUM(CASE WHEN days_past_due > 0 THEN 1 ELSE 0 END) / COUNT(*), 2) AS delinquency_rate_pct
FROM latest_snapshot;

-- 4. Default rate (from default_model_dataset)
SELECT
    ROUND(100.0 * SUM(default_flag) / COUNT(*), 2) AS default_rate_pct
FROM default_model_dataset;

-- 5. Fraud rate (accounts with at least one fraud alert / total accounts)
SELECT
    ROUND(100.0 * COUNT(DISTINCT fa.account_id) / (SELECT COUNT(*) FROM account_master), 2) AS fraud_rate_pct
FROM fraud_alerts fa;

-- 6. Risk Segmentation
-- Build a simple risk_score = weighted combo of utilization, DPD, fraud_count
-- (Rule from README: Low < 30, Medium 30-60, High > 60 on a 0-100 scale)
CREATE OR REPLACE VIEW account_risk_score AS
SELECT
    d.account_id,
    d.utilization_ratio,
    d.days_past_due,
    d.fraud_count,
    d.payment_ratio,
    -- Normalize each component to 0-100ish and weight them
    ROUND(
        (LEAST(d.utilization_ratio, 1.5) / 1.5 * 40)                     -- utilization: 40% weight
        + (LEAST(d.days_past_due, 180) / 180.0 * 40)                     -- DPD: 40% weight
        + (LEAST(d.fraud_count, 5) / 5.0 * 20)                           -- fraud: 20% weight
    , 2) AS risk_score
FROM default_model_dataset d;

CREATE OR REPLACE VIEW account_risk_segment AS
SELECT
    account_id,
    risk_score,
    CASE
        WHEN risk_score < 30 THEN 'Low'
        WHEN risk_score BETWEEN 30 AND 60 THEN 'Medium'
        ELSE 'High'
    END AS risk_level
FROM account_risk_score;

-- 7. Distribution of accounts by risk level
SELECT risk_level, COUNT(*) AS num_accounts,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_portfolio
FROM account_risk_segment
GROUP BY risk_level
ORDER BY num_accounts DESC;

-- 8. Default rate by risk segment (validates the scoring logic)
SELECT
    rs.risk_level,
    COUNT(*) AS accounts,
    ROUND(100.0 * SUM(d.default_flag) / COUNT(*), 2) AS default_rate_pct
FROM account_risk_segment rs
JOIN default_model_dataset d ON d.account_id = rs.account_id
GROUP BY rs.risk_level
ORDER BY default_rate_pct DESC;
