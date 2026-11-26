
WITH ranked_skus AS(
  SELECT s.category, s.sku_id, s.sku_name,
  SUM(ws.units_sold) AS festive_units,
  ROW_NUMBER() OVER (PARTITION BY s.category ORDER BY SUM(ws.units_sold) DESC) AS rn
  FROM skus s
  JOIN weekly_sales ws ON s.sku_id = ws.sku_id
  WHERE ws.week_no BETWEEN 37 AND 40
  GROUP BY s.category, s.sku_id, s.sku_name
)
SELECT * FROM ranked_skus
WHERE rn <= 2
ORDER BY category, rn;

WITH weekly_totals AS(
  SELECT ws.week_no, SUM(ws.units_sold) AS units
  FROM weekly_sales ws
  JOIN skus s on ws.sku_id = s.sku_id
  WHERE s.category = 'Sweets & Mithai' AND
        ws.week_no BETWEEN 33 AND 40
  GROUP BY ws.week_no
)
SELECT week_no, units, SUM(units) OVER (ORDER BY week_no) AS running_units
FROM weekly_totals
ORDER BY week_no ASC;
