
-- skus: 21
-- calendar_weeks: 92
-- weekly_sales: 1760
-- committed_orders: 20
-- seasons: Festive = 8, Regular = 84

SELECT COUNT(*) FROM skus;
SELECT COUNT(*) FROM calendar_weeks;
SELECT COUNT(*) FROM weekly_sales;
SELECT COUNT(*) FROM committed_orders;
SELECT season, COUNT(*) FROM calendar_weeks GROUP BY season;
