# AI-Assisted Workflow Log

## 1. Exact Prompt Used (Task / Context / Constraints / Format)

**Task:** Draft the Context, Insight, and Recommendation sections of a one-page decision memo for Zepto category leads using only the verified numbers below. Do not recompute or invent any figures.

**Context:** Planning festive weeks 89–92 across 20 SKUs. Category totals (committed vs. planned weekly units): Dry Fruits & Gifting 6,090 vs. 5,894; Pooja & Decor 7,030 vs. 7,356; Snacks & Beverages 10,250 vs. 10,116; Sweets & Mithai 9,800 vs. 10,290. Stock-out incidence: 22.5% Festive vs. 6.01% Regular. Focus Stats (8 SKUs): 3 Covered (SKUs 6, 10, 20; SKU 20 cover probability 0.94) and 5 Top-up needed totaling ~2,117 units (SKU 19 at 0.26, SKU 17 at 0.47). Hold-back check (weeks 73–84 baseline vs. weeks 85–88 actuals): -3.37%, -2.77%, -1.15%, +2.12%. Shape flag: no SKU marked Review (largest mean-minus-median gap is SKU 19 at 0.43 × SD). SKU 21 is a new launch with no sales history or lead time.

**Constraints:**
* Combined Headline, Context, Insight, and Recommendation must stay under 250 words.
* Name the benchmark for every comparison (e.g., committed vs. planned, festive vs. regular).
* State plainly that no SKU triggered the `shape_flag` Review rule.
* Write "cause unknown" wherever the data does not prove a cause; do not invent supplier or demand explanations.
* No hype words (e.g., "skyrocketing", "massive", "severe crisis").
* Every recommendation must start with a verb and include an owner role and due date.

**Format:** Markdown with labelled sections: Headline, Context, Insight, Recommendation, and a separate Limitations section (at least 3 specific limits).

---

## 2. First-Draft Problems & Prompt Fixes

1. **Problem 1 — Invented Causes & Hype Words:**
   * *What went wrong:* The first draft claimed festive demand was "skyrocketing" and blamed last year's 22.5% festive stock-out rate on "slow vendor replenishment and warehouse bottlenecks." Neither cause is in `zepto_festive.db`.
   * *Prompt fix:* Added explicit constraints: *"Write 'cause unknown' wherever the data does not prove a cause; do not invent supplier or demand explanations; avoid hype words like 'skyrocketing' or 'massive'."*

2. **Problem 2 — Missing Benchmarks & Exceeded Word Limit:**
   * *What went wrong:* The first draft exceeded 290 words across the first four sections and stated "Sweets & Mithai is under-stocked by 490 units" without naming the planned baseline (10,290) or committed figure (9,800).
   * *Prompt fix:* Added constraints enforcing *"under 250 words for Headline, Context, Insight, and Recommendation combined"* and *"name the benchmark for every comparison."*

---

## 3. Validation Note

* **Title:** Zepto Festive Demand Plan — Decision Memo Validation
* **Sources:** `zepto_festive.db`, `02_aggregation_joins.sql`, `04_plan.sql`, `05_holdback.sql`, `sku_plan.csv`, `focus_weeks.csv`, `python_check_output.txt`, `zepto_festive_risk_review.xlsx`.
* **AI Usage:** Used an AI chat assistant solely to draft and tighten prose for `docs/decision_memo.md` from pre-verified SQL, Python, and spreadsheet outputs. No calculations were delegated to the AI.
* **Manual Checks Actually Performed:**
  1. Verified every category total, cover probability, top-up total (~2,117), hold-back percentage, and `shape_flag` result against `zepto_festive_risk_review.xlsx` and `python_check_output.txt`.
  2. Verified word count of Headline + Context + Insight + Recommendation (~215 words, under the 250-word cap).
  3. Confirmed no external links, invented causes, or hype words remained.
* **Changes Made:** Removed invented vendor/warehouse causes, replaced hype language with neutral figures, added explicit benchmarks for every comparison, and inserted `"cause unknown"` in Limitations.
* **Analysis Limits:** Simulated dataset covering 88 weeks with only one prior festive cycle (weeks 37–40); lacks supplier, pricing, and promotion telemetry, and assumes festive demand standard deviation scales proportionally with category uplift.
