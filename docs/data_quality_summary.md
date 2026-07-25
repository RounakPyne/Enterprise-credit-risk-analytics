# Data Quality Summary — Credit Risk Portfolio Dataset

**Prepared for:** Business / Non-Technical Stakeholders
**Dataset:** 20,000 customer accounts, Enterprise Credit Risk & Portfolio Analytics Platform

---

## Bottom Line

**The dataset is clean and reliable.** There are no missing values, no duplicate records, no broken links between tables, and no impossible or corrupted values. We can move forward to analysis and modeling with confidence in the data foundation.

---

## What We Checked, and What We Found

| Check | What It Means | Result |
|---|---|---|
| **Missing data** | Are any fields blank/empty? | None found — every record is complete |
| **Duplicate records** | Is any account counted twice? | None found — each of the 20,000 accounts appears exactly once |
| **Broken links between tables** | Does every account in our risk model actually exist in the master account list? | All accounts match correctly — no orphaned or disconnected records |
| **Impossible values** | Any negative amounts, negative days, or values outside a logical range? | None found — all values fall within expected, logical ranges |
| **Data types** | Are numbers stored as numbers (not text)? | Confirmed — all numeric fields are properly formatted |
| **City/Occupation spelling consistency** | Any typos or inconsistent labels (e.g., "mumbai" vs "Mumbai") that would split one group into two? | Clean — 6 consistent city names, 5 consistent occupation categories |
| **Account open dates** | Any accounts with impossible dates (e.g., opened in the future)? | Clean — all dates fall between 2018 and 2024, none in the future |
| **Class balance** | Is the mix of "defaulted" vs "did not default" accounts reasonably balanced for modeling? | Well balanced — 52% defaulted, 48% did not. This is actually easier to model than a heavily lopsided split |

---

## One Minor Item Worth Noting

A statistical outlier check flagged **261 accounts (about 1.3% of the portfolio)** with a fraud alert count of 4 or 5. Statistically, these sit outside the "typical" range — but this doesn't mean they're data errors. In plain terms: these are simply the small group of customers with an unusually high number of fraud alerts, which is exactly the kind of high-risk account this analysis is designed to catch. No action needed here — we'll treat this group as a meaningful risk signal rather than a data problem.

---

## Why This Matters for the Project

Because the data passed every check, we can trust the charts, risk scores, and predictive model built from it. In other words: any business conclusion we draw later (e.g., "fraud history increases default risk") reflects a real pattern in the data — not a data-entry error or a technical glitch.
