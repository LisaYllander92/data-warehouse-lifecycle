-- this is an extract of the model

with job_ads as (select * from {{ ref('src_job_ads') }})

select
    {{ dbt_utils.generate_surrogate_key(['occupation_label']) }} as occupation_id,
    {{ dbt_utils.generate_surrogate_key(['id']) }} as job_details_id,
    {{ dbt_utils.generate_surrogate_key(['employer_workplace', 'workplace_address_municipality']) }} as employer_id,
    {{ dbt_utils.generate_surrogate_key(['experience_required', 'driver_license', 'access_to_own_car'])}} as auxilliary_attributes_id,
    vacancies,
    relevance,
    application_deadline
from job_ads