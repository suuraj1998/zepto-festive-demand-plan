
SELECT COUNT(*) FROM skus
WHERE category = "Pooja & Decor";

SELECT DISTINCT * FROM skus
WHERE category = "Pooja & Decor";

SELECT COUNT(*) FROM skus
ORDER BY unit_price_inr DESC LIMIT 3;

SELECT COUNT(*) FROM skus
WHERE category IN ("Pooja & Decor", "Sweets & Mithai");

SELECT * FROM skus
WHERE unit_price_inr BETWEEN 100 AND 300;

SELECT * FROM skus
WHERE sku_name LIKE "%Box%";

SELECT * FROM skus
WHERE lead_time_days IS NULL;

SELECT sku_name, unit_price_inr, ROUND(unit_price_inr * 0.18, 2) AS tax_amount
FROM skus;
