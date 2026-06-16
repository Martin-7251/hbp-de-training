WITH source AS (

    SELECT * 
    FROM {{ source('raw', 'dim_customers') }}

),

cleaned AS (

    SELECT
        customer_id::INT AS customer_id,
        LOWER(TRIM(first_name)) AS first_name,
        LOWER(TRIM(last_name)) AS last_name,
        LOWER(TRIM(email)) AS email,
        UPPER(TRIM(country)) AS country,
        created_at::DATE AS created_at,
        is_active::BOOLEAN AS is_active

    FROM source

)

SELECT * FROM cleaned