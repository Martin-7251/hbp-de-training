-- =================================================
-- Multi-step CTE: full customer metrics
-- =================================================

USE DATABASE HBP_PRACTICE;
USE SCHEMA RAW;
USE WAREHOUSE PRACTICE_WH;

with order_metrics as (

    select
          customer_id
        , count(order_id)                                                   as total_orders
        , count(case when lower(status) = 'completed' then 1 end)          as completed_orders
        , sum(cast(quantity as integer) * cast(unit_price_pence as integer)) as total_spend

    from orders

    group by customer_id

)

select
      c.customer_id
    , coalesce(o.total_orders, 0)                                          as total_orders
    , coalesce(o.completed_orders, 0)                                      as completed_orders
    , coalesce(o.total_spend, 0)                                           as total_spend
    , case
        when coalesce(o.total_orders, 0) > 0
            then coalesce(o.total_spend, 0) / o.total_orders
        else 0
      end                                                                   as avg_spend

from customers as c
left join order_metrics as o
    on c.customer_id = o.customer_id;
