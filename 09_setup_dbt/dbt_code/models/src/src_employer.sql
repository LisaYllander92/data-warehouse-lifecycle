with stg_job_ads as (select * from {{ source('job_ads', 'stg_ads') }})

select
    employer__name as employer_name, 
    employer__workplace as employer_workplace, -- primary key
    employer__organization_number as employer_organization_number,
    workplace_address__street_address as workplace_street_address,
    workplace_address__region as workplace_region,
    workplace_address__postcode as workplace_postcode,
    workplace_address__city as workplace_city,
    workplace_address__country as workplace_country
    workplace_address__municipality as workplace_municipality -- primary key
    employer__url as employer_url,
from stg_job_ads
