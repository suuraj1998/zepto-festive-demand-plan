
-- (a) Plan table (export to sku_plan.csv)
WITH pre_festive AS (
    SELECT sku_id,
           AVG(units_sold) AS pre_avg
    FROM weekly_sales
    WHERE week_no BETWEEN 25 AND 36
      AND stockout_days = 0
    GROUP BY sku_id
),
festive AS (
    SELECT sku_id,
           AVG(units_sold) AS fest_avg
    FROM weekly_sales
    WHERE week_no BETWEEN 37 AND 40
      AND stockout_days = 0
    GROUP BY sku_id
),
sku_uplift AS (
    SELECT p.sku_id,
           f.fest_avg / p.pre_avg AS uplift
    FROM pre_festive p
    INNER JOIN festive f ON p.sku_id = f.sku_id
),
cat_uplift AS (
    SELECT s.category,
           AVG(u.uplift) AS category_uplift
    FROM sku_uplift u
    INNER JOIN skus s ON u.sku_id = s.sku_id
    GROUP BY s.category
),
current_baseline AS (
    SELECT sku_id,
           COUNT(*) AS clean_weeks,
           AVG(units_sold) AS baseline_units
    FROM weekly_sales
    WHERE week_no BETWEEN 77 AND 88
      AND stockout_days = 0
    GROUP BY sku_id
)
SELECT s.sku_id,
       s.sku_name,
       s.category,
       cb.clean_weeks,
       ROUND(cb.baseline_units, 2) AS baseline_units,
       ROUND(cu.category_uplift, 4) AS category_uplift,
       ROUND(cb.baseline_units * cu.category_uplift, 0) AS planned_weekly_units,
       co.committed_weekly_units
FROM current_baseline cb
INNER JOIN skus s ON cb.sku_id = s.sku_id
INNER JOIN cat_uplift cu ON s.category = cu.category
INNER JOIN committed_orders co ON cb.sku_id = co.sku_id
ORDER BY s.sku_id ASC;

-- (b) Clean weeks (77-88) for the 8 Focus-List SKUs (export to focus_weeks.csv)
SELECT ws.week_no,
       ws.sku_id,
       s.sku_name,
       s.category,
       ws.units_sold
FROM weekly_sales ws
INNER JOIN skus s ON ws.sku_id = s.sku_id
WHERE ws.week_no BETWEEN 77 AND 88
  AND ws.stockout_days = 0
  AND ws.sku_id IN (1, 6, 10, 11, 13, 17, 19, 20)
ORDER BY ws.sku_id ASC, ws.week_no ASC;

-- (c) All-weeks category uplift (no stockout_days = 0 filter)
-- Comparison: All-weeks uplifts (2.0073, 2.8552, 1.3723, 2.2939) are lower than
-- clean-week uplifts (2.0771, 3.0651, 1.4270, 2.4028) because stock-outs occur far
-- more often in festive weeks (22.5%) than regular weeks (6.01%), which pulls down
-- recorded festive sales more heavily than pre-festive sales.
WITH pre_festive_all AS (
    SELECT sku_id,
           AVG(units_sold) AS pre_avg
    FROM weekly_sales
    WHERE week_no BETWEEN 25 AND 36
    GROUP BY sku_id
),
festive_all AS (
    SELECT sku_id,
           AVG(units_sold) AS fest_avg
    FROM weekly_sales
    WHERE week_no BETWEEN 37 AND 40
    GROUP BY sku_id
),
sku_uplift_all AS (
    SELECT p.sku_id,
           f.fest_avg / p.pre_avg AS uplift
    FROM pre_festive_all p
    INNER JOIN festive_all f ON p.sku_id = f.sku_id
)
SELECT s.category,
       ROUND(AVG(u.uplift), 4) AS category_uplift_all_weeks
FROM sku_uplift_all u
INNER JOIN skus s ON u.sku_id = s.sku_id
GROUP BY s.category
ORDER BY s.category ASC;
