SELECT * 
FROM {{ ref('fct_job_ads') }}
WHERE relevance > 1