-- Active customers
SELECT *
FROM HBP_PRACTICE.RAW.CUSTOMERS
WHERE LOWER(is_active) = 'true';