{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema -%}
    
    {# 1. If it is a source table testing or freshness check, keep original schema #}
    {%- if node.resource_type == 'source' -%}
        {{ node.schema | trim | upper }}
        
    {# 2. If no custom schema configuration is found, default to profiles.yml target #}
    {%- elif custom_schema_name is none -%}
        {{ default_schema | trim | upper }}
        
    {# 3. For models containing +schema configurations, output just the custom schema name #}
    {%- else -%}
        {{ custom_schema_name | trim | upper }}
    {%- endif -%}
{%- endmacro %}
