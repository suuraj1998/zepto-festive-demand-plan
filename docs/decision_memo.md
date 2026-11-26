# Zepto Festive Demand Plan — Decision Memo

## Headline
Five of eight high-volume festive SKUs face stock-out risk under current supplier commitments, requiring about 2,117 additional weekly units to reach full cover.

## Context
Category leads must decide whether to raise weekly supplier commitments before festive weeks 89–92. Measuring committed units against planned weekly units, Sweets & Mithai (9,800 vs. 10,290) and Pooja & Decor (7,030 vs. 7,356) are under-committed, while Dry Fruits & Gifting (6,090 vs. 5,894) and Snacks & Beverages (10,250 vs. 10,116) exceed plan. Historical stock-out incidence was 22.5% in festive weeks versus 6.01% in regular weeks.

## Insight
Three focus SKUs are Covered (SKUs 6, 10, 20; SKU 20 at 0.94 probability), while five need top-ups—most urgently Ghee 1 L (SKU 19, 0.26) and Incense Sticks (SKU 17, 0.47). Hold-back testing (weeks 73–84 baseline vs. weeks 85–88 actuals) showed tight accuracy across categories (-3.37% to +2.12%). No focus SKU triggered the `shape_flag` Review rule (largest gap: SKU 19 at 0.43 × SD), supporting the bell-curve assumption behind `NORM.DIST`.

## Recommendation
* **Increase** weekly orders by ~2,117 units across the five Top-up-needed SKUs, prioritizing SKUs 19 and 17 — *Category Leads, by 2026-11-30*.
* **Hold** current commitments on Covered SKUs (6, 10, 20) — *Category Leads, by 2026-11-30*.
* **Confirm** supplier lead time for new launch Millet Ladoo Gift Box (SKU 21) — *Supply Chain Lead, by 2026-12-02*.

## Limitations
* **Root causes not in data:** The dataset tracks only weekly units sold and stock-out days; why specific SKUs stocked out more often (e.g., supplier delays, warehouse capacity, or local promotions) is **cause unknown**.
* **Single-year festive uplift:** Category uplifts rely on only one prior festive cycle (weeks 37–40); shifts in competitor pricing or consumer demand this year could change actual uplift.
* **Proportional variability assumption:** `planned_sd` assumes demand standard deviation scales linearly with `category_uplift`, which may understate or overstate true festive volatility.
* **New-launch gap:** SKU 21 has no sales history and no confirmed lead time, so it cannot be modeled by this method.
