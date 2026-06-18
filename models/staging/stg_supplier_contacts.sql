WITH source AS (

    SELECT * 
    FROM {{ source('fivetran_supplier', 'supplier_contacts') }}

),

cleaned AS (

    SELECT
        "supplier_id"        AS supplier_id,
        "supplier_name"      AS supplier_name,
        "contact_name"       AS contact_name,
        "contact_email"      AS contact_email,
        "country"            AS country,
        "product_category"   AS product_category,
        "onboarded_at"       AS onboarded_at,
        "is_active"          AS is_active

    FROM source

    WHERE _FIVETRAN_DELETED = FALSE

    

)

SELECT * FROM cleaned
