import streamlit as st
from connect_data_warehouse import query_job_listnings

def layout():
    df = query_job_listnings()

    st.title("Data engineering job ads")
    st.write("This dashboard shows dta engineering job ads from arbetsförmedlingens API")

    st.markdown("## Vacancies")
    cols = st.columns(3)

    with cols[0]:
        st.metric(label="Total", value = df["VACANCIES"].sum())

    with cols[1]:
        st.metric(
            label="Laboratorieingenjörer",
            value=df.query("OCCUPATION_GROUP == 'Laboratorieingenjörer'")["VACANCIES"].sum(),
        )

    with cols[2]:
        st.metric(
            label="Övriga ingenjörer och tekniker",
            value=df.query("OCCUPATION_GROUP == 'Övriga ingenjörer och tekniker'")["VACANCIES"].sum(),
        )

    cols = st.columns(2)

    with cols[0]:
        st.markdown("### Per city")
        st.dataframe(
            query_job_listnings("""
            SELECT 
            SUM(vacancies) as vacancies,
            occupation
            FROM mart_technical_jobs
            GROUP BY occupation
            ORDER BY vacancies DESC;
            """)
        )

    with cols[1]:
        st.markdown("### Per occupation (top 5)")
        st.bar_chart(
            query_job_listnings("""
            SELECT 
            SUM(vacancies) as vacancies,
            occupation
            FROM mart_technical_jobs
            GROUP BY occupation
            ORDER BY vacancies DESC
            LIMIT 5;
            """),
            x = "OCCUPATION",
            y = "VACANCIES",
        )

    st.markdown("## Job listnings data")
    st.dataframe(df)

if __name__ == "__main__":
    layout()