WITH source AS (

    SELECT * 
    FROM {{ source('raw', 'dim_products') }}

),

cleaned AS (

    SELECT
        TRIM(product_id) AS product_id,
        LOWER(TRIM(product_name)) AS product_name,
        LOWER(TRIM(category)) AS category,
        unit_price_pence::INT AS unit_price_pence,
        COALESCE(in_stock::BOOLEAN, FALSE) AS in_stock


    FROM source

)

SELECT * FROM cleaned