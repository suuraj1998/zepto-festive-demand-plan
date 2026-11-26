
-- (a) Category totals with INNER JOIN and HAVING
SELECT s.category,
       SUM(ws.units_sold) AS total_units,
       SUM(ws.stockout_days) AS total_stockout_days
FROM weekly_sales ws
INNER JOIN skus s ON ws.sku_id = s.sku_id
GROUP BY s.category
HAVING SUM(ws.units_sold) > 300000
ORDER BY total_units DESC;

-- (b) LEFT JOIN to surface SKU with no sales history
SELECT s.sku_id,
       s.sku_name,
       COUNT(ws.week_no) AS sku_weeks
FROM skus s
LEFT JOIN weekly_sales ws ON s.sku_id = ws.sku_id
GROUP BY s.sku_id, s.sku_name
ORDER BY sku_weeks ASC, s.sku_id ASC;

-- (c) Stock-out incidence by season using two CTEs
WITH total_sku_weeks AS (
    SELECT cw.season AS season,
           COUNT(*) AS total_weeks
    FROM weekly_sales ws
    JOIN calendar_weeks cw ON ws.week_no = cw.week_no
    GROUP BY cw.season
),
affected_sku_weeks AS (
    SELECT cw.season AS season,
           COUNT(*) AS affected_weeks
    FROM weekly_sales ws
    JOIN calendar_weeks cw ON ws.week_no = cw.week_no
    WHERE ws.stockout_days > 0
    GROUP BY cw.season
)
SELECT t.season,
       t.total_weeks,
       a.affected_weeks,
       ROUND(a.affected_weeks * 100.0 / t.total_weeks, 2) AS incidence_pct
FROM total_sku_weeks t
JOIN affected_sku_weeks a ON t.season = a.season;
