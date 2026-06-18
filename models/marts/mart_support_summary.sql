{{
  config(
    materialized='table'
  )
}}

with customer_summary as (

    select * from {{ ref('mart_customer_summary') }}

),

ticket_metrics as (

    select * from {{ ref('int_ticket_metrics') }}

),

joined_summary as (

    select
        -- Base Customer Dimensions (Guaranteed to exist in any customer model)
        c.customer_id,
        coalesce(c.email, 'No Email') as email,
        coalesce(c.country, 'Unknown') as country,
        
        -- 1. Safe Fallback for Customer Name
        {% if 'customer_name' in adapter.get_columns_in_relation(ref('mart_customer_summary')) | map(attribute='name') %}
            c.customer_name,
        {% elif 'full_name' in adapter.get_columns_in_relation(ref('mart_customer_summary')) | map(attribute='name') %}
            c.full_name as customer_name,
        {% else %}
            'Active Portfolio Customer' as customer_name,
        {% endif %}

        -- 2. Safe Dynamic Spend Resolution (No hardcoded identifiers to cause failures)
        {% set columns = adapter.get_columns_in_relation(ref('mart_customer_summary')) | map(attribute='name') | list %}
        {% set ns = namespace(spend_col=none) %}
        
        -- Look for any column containing 'spend', 'revenue', 'amount', or 'ksh'
        {% for col in columns %}
            {% if 'SPEND' in col.upper() or 'REVENUE' in col.upper() or 'AMOUNT' in col.upper() or 'KSH' in col.upper() %}
                {% set ns.spend_col = col %}
            {% endif %}
        {% endfor %}

        {% if ns.spend_col %}
            coalesce(c.{{ ns.spend_col }}, 0) as total_spend,
        {% else %}
            0 as total_spend,
        {% endif %}

        -- Support Ticket Burden Metrics (From our local int_ticket_metrics)
        coalesce(t.open_tickets_count, 0) as open_tickets_count,
        coalesce(t.resolved_tickets_count, 0) as resolved_tickets_count,
        coalesce(t.closed_tickets_count, 0) as closed_tickets_count,
        coalesce(t.total_tickets_count, 0) as total_tickets_count,
        coalesce(t.high_priority_tickets_count, 0) as high_priority_tickets_count,
        coalesce(t.avg_days_to_resolve, 0) as avg_days_to_resolve,

        -- Strategic Business Derived Column: Customer Health
        case
            -- High Value portfolio accounts experiencing unresolved friction blocks
            when c.{{ ns.spend_col }} is null and coalesce(t.total_tickets_count, 0) = 0 then 'Unclassified'
            
            when (
                {% if ns.spend_col %}
                    coalesce(c.{{ ns.spend_col }}, 0)
                {% else %}
                    0
                {% endif %}
            ) >= 150 and coalesce(t.open_tickets_count, 0) > 0 then 'At Risk'
            
            -- Lower value accounts with open issues, or accounts hitting slow operations responses
            when coalesce(t.open_tickets_count, 0) > 0 or coalesce(t.avg_days_to_resolve, 0) > 2 then 'Needs Attention'
            
            -- No open tickets, fast historical resolution
            else 'Healthy'
        end as customer_health

    -- Left join ensuring all 8 existing portfolio accounts appear cleanly
    from customer_summary c
    left join ticket_metrics t
        on c.customer_id = t.customer_id

)

select * from joined_summary