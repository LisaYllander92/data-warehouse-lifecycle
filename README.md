# Data Warehouse Lifecycle (Snowflake)

Repo för kursen Data Warehouse. Här bygger jag en datapipeline för jobbannonser från Jobtech API, från rådata till dashboard.

## Flöde

```text
Jobtech API → dlt → Snowflake (staging) → dbt (warehouse, marts) → Streamlit-dashboard
                          ↑
               orkestreras med Dagster
```

## Innehåll

| Mapp | Innehåll |
|---|---|
| `05_roles_management/` | Hantering av roller och behörigheter i Snowflake |
| `06_extract_load_csv_dlt/` | Extrahering och laddning av CSV-data med dlt |
| `07_extract_load_api_dlt/` | Extrahering och laddning från API (Jobtech) med dlt |
| `08_dimensional_modeling/` | Grundläggande dimensionsmodellering och design |
| `09_setup_dbt/` | Uppsättning och initiering av dbt-projektet |
| `11_dbt_testing/` | Tester och datakvalitetskontroller i dbt |
| `12_dashboard_streamlit/` | Visualisering och dashboard byggd i Streamlit |
| `13_dbt_documentation/` | Dokumentation och generering av dbt docs |
| `14_orchestation_dagster/` | Orkestrering av hela pipelinen (dlt + dbt) med Dagster |


## Anteckningar

Alla lektionsanteckningar finns samlade i [class_notes.md](class_notes.md).