-- this is an extract of the model
with stg_job_ads as (select * from {{ source('job_ads', 'stg_ads') }})

select
    OCCUPATION__LABEL,
    NUMBER_OF_VACANCIES as vacancies,
    RELEVANCE,
    APPLICATION_DEADLINE
from stg_job_ads
order by APPLICATION_DEADLINE