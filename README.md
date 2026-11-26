# Zepto Festive Demand Plan — Stocking-Risk Review

A three-part analytical review of simulated Zepto sales history (88 weeks across 20 active SKUs and 1 new launch) to evaluate supplier commitments ahead of festive weeks 89–92. Built using SQLite, plain Python, and spreadsheet statistical modeling to adjust for historical stock-out distortion and quantify weekly stock-out risk.

*Note: All data in this repository is simulated for an analytical exercise and does not represent real Zepto sales or operations.*

---

## Key Findings

* **Stock-Out Distortion:** Historical stock-out incidence was **22.5%** in festive weeks versus **6.01%** in regular weeks, meaning raw festive sales understate true demand.
* **Category Commitments vs. Plan:** Sweets & Mithai (9,800 vs. 10,290) and Pooja & Decor (7,030 vs. 7,356) are under-committed, while Dry Fruits & Gifting (6,090 vs. 5,894) and Snacks & Beverages (10,250 vs. 10,116) exceed plan.
* **Focus-SKU Risk:** **5 of 8** high-volume focus SKUs require top-ups totaling **~2,117 weekly units** (led by Ghee 1 L at 0.26 cover probability and Incense Sticks at 0.47), while **3 SKUs** (SKUs 6, 10, and 20) are Covered.
* **Method Validation:** Independent Python cross-checks passed 100%, hold-back testing showed category gaps between **-3.37%** and **+2.12%**, and no focus SKU triggered the `shape_flag` Review rule.

---

## Repository Contents

### Part A — SQLite Database, SQL Scripts & CSV Exports
* `generate_data.py` — Deterministic Python script generating `zepto_festive.db` (21 SKUs, 92 calendar weeks, 1,760 weekly sales rows, 20 committed orders).
* `zepto_festive.db` — SQLite database used for all SQL and Python queries.
* `verify.sql` — Table row counts and season split verification.
* `01_foundations.sql` — Foundational filtering, sorting, null-checking, and calculated tax queries.
* `02_aggregation_joins.sql` — Category totals (`INNER JOIN` + `HAVING`), new-launch check (`LEFT JOIN`), and seasonal stock-out incidence (two CTEs).
* `03_ranking_windows.sql` — Top 2 Focus SKUs per category (`ROW_NUMBER()`) and cumulative Sweets & Mithai running total (`SUM() OVER`).
* `04_plan.sql` — Five-CTE clean-week baseline and category uplift plan, Focus-SKU clean weeks export, and all-weeks uplift comparison.
* `05_holdback.sql` — Hold-back accuracy check comparing clean weeks 73–84 against actual weeks 85–88.
* `06_index.sql
