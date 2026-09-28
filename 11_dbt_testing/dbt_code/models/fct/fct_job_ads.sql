-- this is an extract of the model

with job_ads as (select * from {{ ref('src_job_ads') }})

select
    {{ dbt_utils.generate_surrogate_key(['occupation_label']) }} as occupation_id,
    {{ dbt_utils.generate_surrogate_key(['headline', 'description']) }} as job_details_id,
    {{ dbt_utils.generate_surrogate_key(['employer_name', 'employer_organization_number', 'workplace_street_address', 'workplace_postcode']) }} as employer_id,
    {{ dbt_utils.generate_surrogate_key(['experience_required', 'driver_license', 'access_to_own_car'])}} as auxilliary_attributes_id,
    vacancies,
    relevance,
    application_deadline
from job_ads