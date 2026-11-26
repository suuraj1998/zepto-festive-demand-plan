

EXPLAIN QUERY PLAN
SELECT * FROM weekly_sales WHERE sku_id = 13;

CREATE INDEX IF NOT EXISTS idx_ws_sku ON weekly_sales(sku_id);


EXPLAIN QUERY PLAN
SELECT * FROM weekly_sales WHERE sku_id = 13;
