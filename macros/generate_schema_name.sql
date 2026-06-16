{% macro generate_schema_name(custom_schema_name, node) -%}
    {# Always fall back to the main target schema defined in your profiles.yml #}
    {{ target.schema }}
{%- endmacro %}
