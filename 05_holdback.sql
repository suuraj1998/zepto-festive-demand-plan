
-- Hold-back check: clean baseline (weeks 73-84) vs actual average (weeks 85-88)
WITH baseline_73_84 AS (
    SELECT sku_id,
           AVG(units_sold) AS baseline
    FROM weekly_sales
    WHERE week_no BETWEEN 73 AND 84
      AND stockout_days = 0
    GROUP BY sku_id
),
actual_85_88 AS (
    SELECT sku_id,
           AVG(units_sold) AS actual
    FROM weekly_sales
    WHERE week_no BETWEEN 85 AND 88
    GROUP BY sku_id
)
SELECT s.category,
       COUNT(*) AS sku_count,
       ROUND(AVG((a.actual - b.baseline) * 100.0 / b.baseline), 2) AS avg_gap_pct
FROM baseline_73_84 b
INNER JOIN actual_85_88 a ON b.sku_id = a.sku_id
INNER JOIN skus s ON b.sku_id = s.sku_id
GROUP BY s.category
ORDER BY s.category ASC;
