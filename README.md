# Enterprise Credit Risk & Portfolio Analytics Platform

End-to-end credit risk analytics project simulating a real-world engagement for a financial institution — built across **PostgreSQL, Python, and Power BI** on a 20,000-account, 1,000,000-transaction synthetic portfolio.

## Business Problem

A financial institution is facing rising defaults, growing fraud incidents, and higher collection costs, with limited visibility into future portfolio risk. This project answers five core questions:
1. Which customers are most likely to default?
2. What factors drive default risk?
3. Which customer segments are riskiest?
4. How effective is collections recovery?
5. What will happen to portfolio risk in the next 6 months?

## Tech Stack

`PostgreSQL` `Python (pandas, scikit-learn, statsmodels, seaborn)` `Power BI` `SQL`

## Pipeline

```
CSV Files -> PostgreSQL (data mart) -> SQL Analytics -> Python EDA
-> Feature Engineering -> Logistic Regression -> ARIMA Forecasting -> Power BI Dashboard
```

## Key Findings

- **Days Past Due** and **Utilization Ratio** are the strongest default risk drivers (correlation 0.39 and 0.29 respectively) — consistent across SQL segmentation, EDA, and the model's own feature weights.
- **Fraud history compounds risk sharply**: default rate climbs from 45% (no fraud alerts) to 100% (5+ alerts).
- **Demographics (city, occupation, age, income) show almost no effect** on default rate (~50-53% flat across all groups) — risk in this portfolio is behavioral, not demographic.
- **Collections call volume does not improve recovery** — average recovery stays flat (~₹25.2k) regardless of 1 vs 9 call attempts, suggesting the current collections strategy needs rethinking.
- **Portfolio risk is stable, not worsening** — monthly delinquency held in a narrow 10.6%-11.8% band over 3 years, and the model forecasts this stability continuing for the next 6 months.

## Model Performance

Logistic Regression predicting `default_flag`:

| Metric | Score |
|---|---|
| ROC-AUC | 0.83 |
| Accuracy | 75% |
| Precision (Default) | 76% |
| Recall (Default) | 77% |

Logistic Regression was chosen over more complex models specifically for its interpretability — a standard requirement in regulated credit risk environments, where every prediction needs an explainable reason.

## Power BI Dashboard

7-page interactive dashboard connected live to PostgreSQL:
1. **Executive Summary** — portfolio KPIs, risk segmentation
2. **Risk Monitoring** — DPD buckets, utilization distribution
3. **Customer Analytics** — demographic segmentation
4. **Fraud Dashboard** — fraud patterns and default impact
5. **Collections Dashboard** — recovery performance
6. **Forecast Dashboard** — historical trend + 6-month ARIMA forecast
7. **ML Dashboard** — model metrics, feature importance, confusion matrix

## Repository Structure

```
├── sql/                  # Schema, KPI queries, segmentation, fraud & collections analysis
├── notebooks/            # EDA, feature engineering, model training, forecasting
├── dashboard/            # Power BI file + page screenshots
├── docs/                 # Business recommendations, data quality summary
└── README.md
```

## Business Recommendations

Full write-up in [`docs/business_recommendations.md`](docs/business_recommendations.md) — key highlights:
- Prioritize DPD and utilization thresholds for early-warning alerts
- Treat fraud history as a compounding risk signal shared across teams
- Reward strong payment behavior with proactive limit increases
- Investigate collections channel/timing rather than scaling call volume
- Pilot the model at credit origination, not just for existing-account monitoring

## Author

**Rounak Pyne** — Business Analyst
