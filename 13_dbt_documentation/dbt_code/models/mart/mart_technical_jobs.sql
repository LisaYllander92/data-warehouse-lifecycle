with 
    fct_job_ads as (select * from {{ ref('fct_job_ads') }}),
    dim_occupation as (select * from {{ ref('dim_occupation') }}),
    dim_employer as (select * from {{ ref('dim_employer') }}),
    dim_job_details as (select * from {{ ref('dim_job_details') }})
select
    o.occupation,
    f.vacancies,
    jd.headline,
    e.employer_name,
    e.workplace_city,
    jd.description,
    jd.description_html_formatted,
    f.relevance,
    o.occupation_group,
    o.occupation_field,
    f.application_deadline
from fct_job_ads f
left join dim_occupation o on f.occupation_id = o.occupation_id
left join dim_employer e on f.employer_id = e.employer_id
left join dim_job_details jd on f.job_details_id = jd.job_details_id
where o.occupation_field = 'Yrken med teknisk inriktning'
