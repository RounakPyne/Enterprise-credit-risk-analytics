-- Enterprise Credit Risk Analytics - Schema
DROP TABLE IF EXISTS default_model_dataset CASCADE;
DROP TABLE IF EXISTS collections_activity CASCADE;
DROP TABLE IF EXISTS fraud_alerts CASCADE;
DROP TABLE IF EXISTS transactions CASCADE;
DROP TABLE IF EXISTS monthly_account_snapshot CASCADE;
DROP TABLE IF EXISTS macroeconomic_indicators CASCADE;
DROP TABLE IF EXISTS account_master CASCADE;
DROP TABLE IF EXISTS customer_master CASCADE;

CREATE TABLE customer_master (
    customer_id     INT PRIMARY KEY,
    age             INT,
    annual_income   NUMERIC(14,2),
    occupation      VARCHAR(50),
    city            VARCHAR(50)
);

CREATE TABLE account_master (
    account_id        INT PRIMARY KEY,
    customer_id       INT REFERENCES customer_master(customer_id),
    credit_limit      NUMERIC(14,2),
    account_open_date DATE
);

CREATE TABLE monthly_account_snapshot (
    account_id        INT REFERENCES account_master(account_id),
    snapshot_month    DATE,
    utilization_ratio NUMERIC(8,4),
    days_past_due     INT,
    payment_ratio     NUMERIC(8,4),
    PRIMARY KEY (account_id, snapshot_month)
);

CREATE TABLE transactions (
    transaction_id    BIGINT PRIMARY KEY,
    account_id        INT REFERENCES account_master(account_id),
    transaction_date  DATE,
    merchant_category VARCHAR(50),
    amount            NUMERIC(14,2)
);

CREATE TABLE fraud_alerts (
    alert_id     INT PRIMARY KEY,
    account_id   INT REFERENCES account_master(account_id),
    fraud_type   VARCHAR(50),
    status       VARCHAR(30)
);

CREATE TABLE collections_activity (
    collection_id    INT PRIMARY KEY,
    account_id       INT REFERENCES account_master(account_id),
    call_attempts    INT,
    recovery_amount  NUMERIC(14,2)
);

CREATE TABLE macroeconomic_indicators (
    month             DATE PRIMARY KEY,
    inflation_rate    NUMERIC(6,3),
    unemployment_rate NUMERIC(6,3),
    repo_rate         NUMERIC(6,3)
);

CREATE TABLE default_model_dataset (
    account_id         INT PRIMARY KEY REFERENCES account_master(account_id),
    utilization_ratio  NUMERIC(8,4),
    days_past_due      INT,
    fraud_count        INT,
    payment_ratio      NUMERIC(8,4),
    default_flag       INT
);

-- Helpful indexes for join-heavy analytics
CREATE INDEX idx_account_customer ON account_master(customer_id);
CREATE INDEX idx_snapshot_account ON monthly_account_snapshot(account_id);
CREATE INDEX idx_snapshot_month ON monthly_account_snapshot(snapshot_month);
CREATE INDEX idx_txn_account ON transactions(account_id);
CREATE INDEX idx_txn_date ON transactions(transaction_date);
CREATE INDEX idx_fraud_account ON fraud_alerts(account_id);
CREATE INDEX idx_collections_account ON collections_activity(account_id);
