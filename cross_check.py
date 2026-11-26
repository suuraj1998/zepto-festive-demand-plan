import sqlite3

def fetch_rows(sql):
    conn = sqlite3.connect("zepto_festive.db")
    conn.row_factory = sqlite3.Row
    rows = [dict(r) for r in conn.execute(sql).fetchall()]
    conn.close()
    return rows

# ---- write your code below this line ----

rows = fetch_rows("""
SELECT w.week_no, w.sku_id, s.category, w.units_sold, w.stockout_days, c.season
FROM weekly_sales w
JOIN skus s ON w.sku_id = s.sku_id
JOIN calendar_weeks c ON w.week_no = c.week_no
""")

def clean_values(rows, sku_id, first_week, last_week):
    vals = []
    for r in rows:
        if (r["sku_id"] == sku_id
                and r["stockout_days"] == 0
                and first_week <= r["week_no"] <= last_week):
            vals.append(r["units_sold"])
    return vals

def mean_of(values):
    return sum(values) / len(values)

# Build distinct SKU list and sku_id -> category dictionary
sku_to_cat = {}
for r in rows:
    sku_to_cat[r["sku_id"]] = r["category"]
sku_ids = sorted(sku_to_cat.keys())

failures = 0
lines = []

# 1. Cross-check every baseline (weeks 77-88)
sql_baselines_rows = fetch_rows("""
SELECT sku_id, ROUND(AVG(units_sold), 2) AS b
FROM weekly_sales
WHERE week_no BETWEEN 77 AND 88 AND stockout_days = 0
GROUP BY sku_id
""")
sql_baselines = {r["sku_id"]: r["b"] for r in sql_baselines_rows}

for sid in sku_ids:
    vals = clean_values(rows, sid, 77, 88)
    py_base = round(mean_of(vals), 2)
    sql_base = sql_baselines[sid]
    if py_base == sql_base:
        status = "OK"
    else:
        status = "MISMATCH"
        failures += 1
    lines.append(f"SKU {sid} | clean weeks {len(vals)} | baseline {py_base} | SQL {sql_base} | {status}")

# 2. Cross-check stock-out incidence by season
expected_incidence = {"Festive": 22.5, "Regular": 6.01}
season_total = {}
season_stockout = {}

for r in rows:
    s = r["season"]
    season_total[s] = season_total.get(s, 0) + 1
    if r["stockout_days"] > 0:
        season_stockout[s] = season_stockout.get(s, 0) + 1

for s in sorted(season_total.keys()):
    pct = round(season_stockout.get(s, 0) * 100.0 / season_total[s], 2)
    if pct != expected_incidence[s]:
        failures += 1
    lines.append(f"{s} | stock-out incidence {pct}%")

# 3. Cross-check category uplift
cat_uplifts_list = {}
for sid in sku_ids:
    pre = clean_values(rows, sid, 25, 36)
    fest = clean_values(rows, sid, 37, 40)
    if len(pre) > 0 and len(fest) > 0:
        uplift = mean_of(fest) / mean_of(pre)
        cat = sku_to_cat[sid]
        if cat not in cat_uplifts_list:
            cat_uplifts_list[cat] = []
        cat_uplifts_list[cat].append(uplift)

sql_uplift_rows = fetch_rows("""
WITH bp AS (SELECT sku_id, AVG(units_sold) AS a FROM weekly_sales WHERE week_no BETWEEN 25 AND 36 AND stockout_days = 0 GROUP BY sku_id),
fp AS (SELECT sku_id, AVG(units_sold) AS a FROM weekly_sales WHERE week_no BETWEEN 37 AND 40 AND stockout_days = 0 GROUP BY sku_id)
SELECT s.category, AVG(fp.a / bp.a) AS u
FROM skus s
JOIN bp ON s.sku_id = bp.sku_id
JOIN fp ON s.sku_id = fp.sku_id
GROUP BY s.category
""")
sql_uplifts = {r["category"]: r["u"] for r in sql_uplift_rows}

for cat in sorted(cat_uplifts_list.keys()):
    py_u = mean_of(cat_uplifts_list[cat])
    sql_u = sql_uplifts[cat]
    if abs(py_u - sql_u) < 0.0001:
        status = "OK"
    else:
        status = "MISMATCH"
        failures += 1
    lines.append(f"{cat} | uplift {round(py_u, 4)} | SQL {round(sql_u, 4)} | {status}")

if failures == 0:
    lines.append("ALL CHECKS PASSED")
else:
    lines.append(f"CHECKS FAILED: {failures}")

print("\n".join(lines))
