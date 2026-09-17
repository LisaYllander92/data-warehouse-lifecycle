import dlt
import pandas as pd
from pathlib import Path
import os

# used for extracting data from source, in this case a local csv file
# @dlt.resource(..) talar om för dlt att funktionen nedan producerar data som ska laddas till  en destination (te.x snowflake)
# write_disposition="replace" betyder att den existerande tabellen töms och fylls på med ny data varje gång pipelinen körs,
# (jämfört med "append" som lägger till, eller "merge" som uppdaterar baserat på nycklar)
@dlt.resource(write_disposition="replace")
# **kwargs (eller *args) tillåter funktionen att ta emot okänt antal argument
def load_csv_resource(file_path: str, **kwargs):
    df = pd.read_csv(file_path, **kwargs)
    #print(df)
    yield df # gör funktionen till en generator, istället för "return" in dlt 

if __name__ == "__main__":
    working_directory = Path(__file__).parent 
    data_directory = working_directory.parent / "data"

    os.chdir(working_directory)
    csv_path = data_directory / "NetflixOriginals.csv"

    data = load_csv_resource(csv_path, encoding="latin1")
    #print(data)

    # Pipeline object using the dlt libary and a function called pipeline
    # Provide the information to the destination
    # snowflake is enought for it to find
    # dataset_name is the schema that should be used
    # pipeline_name is the name for the pipeline to save the meta data in that specific name
    pipeline = dlt.pipeline(
        pipeline_name="movies",
        destination="snowflake", 
        dataset_name="staging"
        )

    # Run the pipeline
    # You need to provide the data you want to extract and table name that is created in staging schema
    # save information in load_info variable
    # to be able to see the log in the terminal
    load_info = pipeline.run(data, table_name="netflix")

    print(load_info)
