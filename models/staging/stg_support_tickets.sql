with source as (

    select * from {{ source('raw', 'support_tickets') }}

),
renamed as (

    select
        -- Keys
        cast(ticket_id as varchar) as ticket_id,
        cast(customer_id as integer) as customer_id,

        -- Ticket Attributes
        cast(subject as varchar) as ticket_subject,
        cast(category as varchar) as ticket_category,
        cast(priority as varchar) as ticket_priority,
        cast(status as varchar) as ticket_status,
        cast(agent_name as varchar) as assigned_agent,

        -- Timestamps
        cast(created_at as date) as created_date,
        cast(case when resolved_at = '' then null else resolved_at end as date) as resolved_date,

        -- Calculated Metrics from Ingestion
        cast(case when days_to_resolve = '' then null else days_to_resolve end as integer) as days_to_resolve

    from source

)

select * from renamed