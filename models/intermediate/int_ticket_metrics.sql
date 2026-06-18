with staging_tickets as (

    select * from {{ ref('stg_support_tickets') }}

),

aggregated_metrics as (

    select
        customer_id,
        
        -- Volume counts by ticket status
        count(case when ticket_status = 'open' then 1 end) as open_tickets_count,
        count(case when ticket_status = 'resolved' then 1 end) as resolved_tickets_count,
        count(case when ticket_status = 'closed' then 1 end) as closed_tickets_count,
        count(ticket_id) as total_tickets_count,

        -- Volume counts by specific priority levels
        count(case when ticket_priority = 'high' then 1 end) as high_priority_tickets_count,
        count(case when ticket_priority = 'medium' then 1 end) as medium_priority_tickets_count,
        count(case when ticket_priority = 'low' then 1 end) as low_priority_tickets_count,

        -- Average days to resolve (only evaluating resolved/closed cycles)
        coalesce(
            avg(case when ticket_status in ('resolved', 'closed') then days_to_resolve end), 
            0
        ) as avg_days_to_resolve

    from staging_tickets
    group by 1

)

select * from aggregated_metrics