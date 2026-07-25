# Business Recommendations — Enterprise Credit Risk & Portfolio Analytics

*Based on SQL analysis, Python EDA, Logistic Regression modeling, and 6-month forecasting*

---

## 1. Prioritize Days Past Due and Utilization Ratio as Early-Warning Signals

These two factors are the strongest and most consistent predictors of default across every stage of analysis (SQL segmentation, EDA correlation, and the model's own feature weights). **Recommendation:** build automated alerts that flag accounts crossing key DPD thresholds (30/60/90 days) or utilization above ~80%, rather than waiting for a full missed-payment cycle.

## 2. Treat Fraud History as a Compounding Risk Factor, Not a Separate Track

Default rate climbs from 45% (no fraud alerts) to 100% (5+ alerts) in near-perfect progression. **Recommendation:** accounts with any fraud alert should automatically receive elevated risk monitoring — fraud and credit risk teams should share signals rather than operate in silos.

## 3. Demographics Are Not a Useful Segmentation Lever Here

City, occupation, age, and income showed almost no variation in default rate (~50-53% across every group). **Recommendation:** don't build risk policy around demographic profiling — it won't meaningfully separate risky from safe customers in this portfolio. Behavioral data (payment activity, utilization) is the more effective lens.

## 4. Reward Payment Behavior, Not Just Penalize Delinquency

Payment ratio is the only factor that *reduces* default risk. **Recommendation:** consider proactive incentives (credit limit increases, fee waivers) for customers maintaining strong payment ratios — this is a retention and risk-reduction lever, not just a monitoring one.

## 5. Rethink the Collections Call Strategy

Recovery amount stayed flat (~₹25.2k average) regardless of whether an account received 1 call or 9 calls. **Recommendation:** more call volume isn't driving more recovery. Investigate what *is* working (timing, channel, negotiated settlements) before continuing to scale call attempts — the current approach may be inefficient.

## 6. The Predictive Model Is Ready for a Pilot, Not Full Deployment

The Logistic Regression model reached 83% ROC-AUC — strong and above the 75% target — with a highly interpretable, regulator-friendly structure. **Recommendation:** pilot the model on a subset of new accounts to flag default risk at onboarding, while continuing to monitor performance before full-scale rollout. Note that `account_age` was not a meaningful predictor and can be dropped from future iterations.

## 7. No Emergency Action Needed — But Don't Get Complacent

The 6-month forecast shows a stable ~11% monthly delinquency rate, consistent with the past three years. **Recommendation:** maintain current monitoring investment rather than reallocating budget toward crisis response; but continue re-running the forecast regularly, especially if macroeconomic indicators (inflation, unemployment, repo rate) shift.

---

## Overall Takeaway

This portfolio is **stable, not deteriorating**, with clear, well-understood, and actionable risk drivers. The recommended next step is operationalizing the early-warning signals (DPD, utilization, fraud) into daily monitoring, rather than waiting for the current dashboard/model refresh cycle alone.
