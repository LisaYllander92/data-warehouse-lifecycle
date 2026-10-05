
# Orginalet ändrat nu när vi använder dagster (se 07... load_job_ads)

import dlt 
import requests
import json 

# cleans up staging dataset created by dagster
dlt.config["load.truncate_staging_dataset"] = True

params = {"limit": 100, "occupation-field": "6Hq3_tK0_V57"}

def _get_ads(url_for_search, params):
    headers = {"accept": "application/json"}
    response = requests.get(url_for_search, headers=headers, params=params)
    response.raise_for_status() # check for http errors
    return json.loads(response.content.decode("utf8"))

@dlt.resource(table_name="job_ads", write_disposition="replace")
def jobads_resource(params):

    url = "https://jobsearch.api.jobtechdev.se"
    url_for_search = f"{url}/search"

    for ad in _get_ads(url_for_search, params)["hits"]:
        yield ad

# dagster works with dlt source not dlt resource
@dlt.source
def jobads_source():
    return jobads_source(params)



# def run_pipeline(table_name):
#     pipeline = dlt.pipeline(
#         pipeline_name="job_search",
#         destination="snowflake",
#         dataset_name="staging",
#     )

#     params = {"limit": 100, "occupation-field": "6Hq3_tK0_V57"}

#     load_info = pipeline.run(jobads_resource(params=params), table_name=table_name)
#     print(load_info)


