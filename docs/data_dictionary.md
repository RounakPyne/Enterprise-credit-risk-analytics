# Data Dictionary — Enterprise Credit Risk & Portfolio Analytics

Quick reference: what each column means and why it matters, per table.

---

## customer_master (20,000 rows)
| Column | Meaning | Why It Matters |
|---|---|---|
| customer_id | Unique ID per customer | Primary key, links to account_master |
| age | Customer's age in years | Tested as a risk segmentation factor (found: no significant effect) |
| annual_income | Yearly income (₹) | Tested as a risk segmentation factor (found: no significant effect) |
| occupation | Salaried / Self-Employed / Student / Business / Retired | Tested as a risk segmentation factor (found: flat ~50-53% default rate across all) |
| city | Customer's city (6 metros) | Tested as a risk segmentation factor (found: flat ~51-53% default rate across all) |

## account_master (20,000 rows)
| Column | Meaning | Why It Matters |
|---|---|---|
| account_id | Unique ID per credit account | Primary key, central table linking to almost everything else |
| customer_id | Links account to its owner | Foreign key to customer_master |
| credit_limit | Maximum credit extended (₹) | Used to calculate total portfolio exposure |
| account_open_date | Date the account was opened | Used to calculate account_age_years (engineered feature; found to be a negligible predictor) |

## monthly_account_snapshot (720,000 rows)
| Column | Meaning | Why It Matters |
|---|---|---|
| account_id | Which account this snapshot belongs to | Foreign key to account_master |
| snapshot_month | The month this row represents | Enables time-series/trend analysis |
| utilization_ratio | % of credit limit currently used | 2nd strongest default predictor (correlation 0.29) |
| days_past_due (DPD) | How many days late on payment | Strongest default predictor (correlation 0.39) |
| payment_ratio | Payment made / balance owed | Only protective factor found (correlation -0.12) |

## transactions (1,000,000 rows, 4 files)
| Column | Meaning | Why It Matters |
|---|---|---|
| transaction_id | Unique ID per transaction | Primary key |
| account_id | Which account made this transaction | Foreign key to account_master |
| transaction_date | Date of transaction | Enables spend trend analysis |
| merchant_category | Type of merchant (e.g., retail, dining) | Enables spend-pattern segmentation (not used in current model) |
| amount | Transaction value (₹) | Raw spend data (not used in current model, available for future feature engineering) |

## fraud_alerts (50,000 rows)
| Column | Meaning | Why It Matters |
|---|---|---|
| alert_id | Unique ID per fraud alert | Primary key |
| account_id | Which account triggered the alert | Foreign key to account_master |
| fraud_type | Card Not Present / Suspicious Spend / Identity Theft | Used for fraud pattern analysis (found: near-even 33/33/33 split) |
| status | Open or Closed | Tracks whether the alert is resolved |

## collections_activity (100,000 rows)
| Column | Meaning | Why It Matters |
|---|---|---|
| collection_id | Unique ID per collections record | Primary key |
| account_id | Which account this collections effort targets | Foreign key to account_master |
| call_attempts | Number of collection calls made | Tested against recovery amount (found: no meaningful relationship — key insight) |
| recovery_amount | Amount recovered (₹) | Core metric for collections effectiveness |

## macroeconomic_indicators (36 rows)
| Column | Meaning | Why It Matters |
|---|---|---|
| month | Calendar month | Links to monthly_account_snapshot by date, for macro trend context |
| inflation_rate | Monthly inflation rate (%) | External context variable for forecasting (loaded, not deeply analyzed) |
| unemployment_rate | Monthly unemployment rate (%) | External context variable for forecasting (loaded, not deeply analyzed) |
| repo_rate | Central bank repo rate (%) | External context variable for forecasting (loaded, not deeply analyzed) |

## default_model_dataset (20,000 rows)
| Column | Meaning | Why It Matters |
|---|---|---|
| account_id | Which account this row represents | Primary key, foreign key to account_master |
| utilization_ratio | Same as above, point-in-time value used for modeling | Model feature (2nd strongest) |
| days_past_due | Same as above, point-in-time value used for modeling | Model feature (strongest) |
| fraud_count | Number of fraud alerts on this account | Model feature (3rd strongest) |
| payment_ratio | Same as above, point-in-time value used for modeling | Model feature (protective factor) |
| default_flag | 1 = defaulted, 0 = did not default | **Target variable** — what the Logistic Regression model predicts |

---

*One-line summary for interviews: "Each table represents a different real-world system (CRM, credit system, core banking, fraud monitoring, collections tool, economic data) — mirroring how a bank's actual data warehouse would be structured, joined together through account_id and customer_id."*
