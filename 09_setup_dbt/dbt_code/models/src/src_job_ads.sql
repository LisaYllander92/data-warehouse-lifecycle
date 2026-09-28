-- this is an extract of the model
with stg_job_ads as (select * from {{ source('job_ads', 'stg_ads') }})

select
    OCCUPATION__LABEL as occupation_label,
    headline,
    description__text as description,
    employer__name as employer_name,
    employer__organization_number as employer_organization_number,
    workplace_address__street_address as workplace_street_address,
    workplace_address__postcode as workplace_postcode,
    experience_required,
    driving_license_required as driver_license,
    access_to_own_car,    
    NUMBER_OF_VACANCIES as vacancies,
    RELEVANCE,
    APPLICATION_DEADLINE
from stg_job_ads
