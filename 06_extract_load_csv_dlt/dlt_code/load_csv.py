import dlt
import pandas as pd
from pathlib import Path
import os

# used for extracting data from source, in this case a local csv file
@dlt.resource(write_disposition="replace")
def load_csv_resource(file_path: str, **kwargs):
    df = pd.read_csv(file_path, **kwargs)
    #print(df)
    yield df # insted of return in dlt

if __name__ == "__main__":
    working_directory = Path(__file__).parent 
    data_directory = working_directory.parent / "data"

    os.chdir(working_directory)
    csv_path = data_directory / "NetflixOriginals.csv"

    data = load_csv_resource(csv_path, encoding="latin1")
    #print(data)

    pipeline = dlt.pipeline(
        pipeline_name="movies", destination="snowflake", dataset_name="staging"
        )
    load_info = pipeline.run(data, table_name="netflix")

    print(load_info)
