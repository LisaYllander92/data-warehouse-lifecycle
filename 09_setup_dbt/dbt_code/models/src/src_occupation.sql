with stg_job_ads as (select * from {{ source('job_ads', 'stg_ads') }})

select
    OCCUPATION_GROUP__CONCEPT_ID  as occupation_group_id,
    OCCUPATION_FIELD__CONCEPT_ID  as occupation_field_id,
    OCCUPATION__LABEL as occupation,
    OCCUPATION_GROUP__LABEL as occupation_group,
    OCCUPATION_FIELD__LABEL as occupation_field
from stg_job_ads