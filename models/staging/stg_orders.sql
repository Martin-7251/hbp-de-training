WITH source AS (

    SELECT * 
    FROM {{ source('raw', 'fct_orders') }}

),

cleaned AS (

    SELECT
        order_id::INT AS order_id,
        customer_id::INT AS customer_id,
        LOWER(TRIM(product_name)) AS product_name,
        quantity::INT AS quantity,
        unit_price_pence::INT AS unit_price_pence,
        quantity * unit_price_pence AS line_total_pence,
        LOWER(TRIM(status)) AS status,
        ordered_at::DATE AS ordered_at

    FROM source

)

SELECT * FROM cleaned