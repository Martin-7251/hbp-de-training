-- Total revenue for completed orders
SELECT 
    SUM(
        CAST(quantity AS INTEGER) * 
        CAST(unit_price_pence AS INTEGER)
    ) AS total_revenue
FROM HBP_PRACTICE.RAW.ORDERS
WHERE LOWER(status) = 'completed';