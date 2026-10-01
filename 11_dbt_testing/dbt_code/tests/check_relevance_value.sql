SELECT * 
FROM {{ ref('fct_job_ads') }}
WHERE relevance > 1

-- the test should fail with WHERE relevance = 1
-- dbt tänker reversed - alltså kommer relevance == 1 få fail eftersom alla rader har värdet 1 i kolumnen
