# 05 Users och Roles (Snowflake)

## Varför?
- För att samarbeta och hantera säkerhet med users och roles i Snowflake.

## Access control i Snowflake
Snowflake använder två modeller för åtkomstkontroll:

- **DAC (Discretionary Access Control)**
    - Varje objekt har en ägare (owner).
    - Ägaren kan bevilja (grant) privilegier till andra så att de får åtkomst till objektet.
- **RBAC (Role-Based Access Control)**
    - Åtkomsträttigheter (privileges) tilldelas roller, inte direkt till användare.
    - Roller tilldelas i sin tur till users och till andra roller (roller kan ärva från varandra).

**Exempel – Learnpoint (rättighet = privilege):**
- **Elvin – UL-roll**
    - Rättighet att lägga till kurser
    - Rättighet att redigera studentinfo
- **Debbie – Teacher-roll**
    - Rättighet att sätta betyg
    - Rättighet att ladda upp läxor
- **Vi – Student-roll**
    - Rättighet att lämna in uppgifter

### Skillnad mellan Role och User
- **Role** – själva rollen, t.ex. "Teacher".
- **User** – en fysisk person, t.ex. "Debbie".

### Privilegier ärvs
- Roller kan GRANTas (beviljas) till olika users.
- Privilegier ärvs beroende på hur mycket åtkomst en roll eller user ska ha (en roll högre upp i hierarkin ärver rättigheterna från rollerna under sig).

## Systemdefinierade roller (system-defined roles)

Snowflake har ett antal inbyggda roller med olika ansvarsområden:

#### ORGADMIN
- Hanterar operationer på **organisationsnivå** (över flera Snowflake-konton).
- Kan skapa nya konton inom organisationen.
- Ligger utanför den vanliga roll-hierarkin för ett enskilt konto.

#### ACCOUNTADMIN
- Den högsta rollen **inom ett konto**.
- Bör bara tilldelas ett fåtal betrodda användare.
- Kombinerar rättigheterna från SYSADMIN och SECURITYADMIN.

#### SECURITYADMIN
- Hanterar grants (beviljanden av rättigheter) globalt i kontot.
- Kan bevilja/återkalla åtkomst till objekt även om personen själv inte äger objektet.
- Kan alltså hantera *vem som får access*, men får inte nödvändigtvis använda objektet själv.
- Ärver rättigheterna från USERADMIN.

#### SYSADMIN
- Kan skapa warehouses.
- Kan skapa databaser.
- Kan skapa övriga objekt (scheman, tabeller m.m.).
- Rekommenderas som roll för att äga de flesta databasobjekt.

#### USERADMIN
- Hanterar users och roller.
- Används för att skapa nya users och roller.

#### PUBLIC
- En roll som automatiskt tilldelas alla users.
- Objekt som ägs av PUBLIC är tillgängliga för alla.

## Hierarki av roller och ärvda privilegier

Hierarkin ser ut ungefär så här (uppifrån och ned):

```
ACCOUNTADMIN
   ├── SYSADMIN
   └── SECURITYADMIN
            └── USERADMIN
                    └── PUBLIC
```

- **ACCOUNTADMIN** – toppen, ärver från både SYSADMIN och SECURITYADMIN.
- **SYSADMIN** – objektadministratör (databaser, warehouses osv.), egen gren.
- **SECURITYADMIN** – hanterar grants globalt, egen gren.
- **USERADMIN** – skapar users, ligger under SECURITYADMIN.
- **PUBLIC** – längst ned, alla users har den automatiskt.

*Obs: ORGADMIN ingår inte i denna hierarki eftersom den verkar på organisationsnivå, ovanför de enskilda kontona.*

Läs mer: https://docs.snowflake.com/en/user-guide/security-access-control-considerations#example

---

# DLT (Data Load Tool)

## dlthub
- **dlt** (data load tool) är ett Python-bibliotek för att ladda in data (t.ex. från API:er eller filer) till en destination, som en del av staging-lagret i en data-pipeline.

## Setup av dlt (dlthub)

1. Uppgradera `uv`:
```bash
pip install --upgrade uv
```

2. Skapa den virtuella miljön:
```bash
uv init --no-package --python 3.13
```

3. Installera beroenden:
```bash
uv add "dlt[snowflake]" "dlt[parquet]" pandas ipykernel
```

### Varför behöver vi secrets.toml?
- dlt läser inloggningsuppgifter (t.ex. user, password, account) från en `.dlt/secrets.toml`-fil.
- Detta gör att man slipper hårdkoda känsliga uppgifter i koden – de hålls separata och kan enkelt bytas ut eller hållas utanför versionshantering (t.ex. via `.gitignore`).

---

# 09 Setup dbt

1. Installera beroenden:
```bash
uv add dbt-core dbt-snowflake
```
- **dbt-core** – själva open source-verktyget/kommandoradsverktyget som gör transformeringarna. (Detta är *inte* samma sak som dbt Cloud, som är ett separat betalt SaaS-verktyg med bland annat webb-UI och schemaläggning.)
- **dbt-snowflake** – adapter/plugin som gör att dbt-core kan koppla upp sig mot och köra kod i Snowflake (destinationen).

2. Sätt upp mappstrukturen:

Gå in i mappen och initiera dbt med:
```bash
dbt init
```
*(Detta genererar dbt-mapparna och du fyller i uppkopplingsuppgifter till Snowflake – warehouse, database, m.m. – i samband med detta.)*

3. Skapa och öppna `profiles.yml` på Windows (om den inte redan skapades av `dbt init`, eller om du vill sätta upp den manuellt):
```bash
New-Item -ItemType Directory -Force -Path "$HOME\.dbt"
```
```bash
code "$HOME\.dbt\profiles.yml"
```
*Alternativ:*
- Ctrl+P i VS Code och sök på "profiles"
- eller hitta filen manuellt via utforskaren (`.dbt`-mappen i din hemkatalog)

### Mappar i dbt (genereras av `dbt init`)

| Mapp | Beskrivning |
|---|---|
| **models** | Här ligger dina SQL-filer för datatransformering – kärnan i dbt-projektet. |
| **seeds** | CSV-filer med statisk referensdata som dbt laddar in direkt som tabeller i databasen (t.ex. landskoder eller andra sällan-ändrade lookup-tabeller). Körs *inte* genom samma transformeringslogik som models. |
| **snapshots** | Standardmappen där dbt sparar filer som används för att spåra historiska dataförändringar över tid, med hjälp av Type 2 Slowly Changing Dimensions (SCD). |
| **tests** | Innehåller tester som kontrollerar att data i Snowflake ser ut som förväntat (t.ex. unika värden, inga null-värden). |
| **logs** | Sparar loggfiler från dbt-körningar (t.ex. `dbt run`), bra för felsökning. |
| **analyses** | SQL-filer för analys/ad-hoc-frågor som kompileras av dbt men *inte* körs eller materialiseras som models. |
| **macros** | "Funktioner" i dbt, skrivna med Jinja – återanvändbar SQL-logik som kan anropas från flera models. |
| **dbt_project.yml** | Huvudkonfigurationsfilen för hela dbt-projektet (namn, version, sökvägar, materialiseringsinställningar per mapp, m.m.). |
| **profiles.yml** | Innehåller uppkopplingsuppgifter (credentials) till databasen. Man kan ha flera profiler i samma fil om man behöver flera uppsättningar (t.ex. dev/prod) – **var försiktig, om du skriver över filen förlorar du dina sparade credentials.** |

Bra källa: https://medium.com/@likkilaxminarayana/6-dbt-project-structure-explained-a-practical-guide-for-analytics-engineers-5894f6230756

https://docs.getdbt.com/category/project-configs?version=2

### profiles.yml (exempel)
```yaml
dbt_snowflake:
  outputs:
    dev:
      account: ------
      client_session_keep_alive: false
      database: job_ads
      password: -----
      role: job_ads_dbt_role
      schema: staging
      type: snowflake
      user: transformer
      warehouse: dev_wh
  target: dev
```

### dbt_project.yml (exempel, med förklaring)
```yaml
# Namnge ditt projekt! Projektnamn ska bara innehålla gemener och
# understreck. Ett bra namn speglar er organisation eller
# syftet med dessa models.
name: 'dbt_code'
version: '1.4.1'

# Denna inställning styr vilken "profil" (från profiles.yml) dbt
# använder för det här projektet.
profile: 'dbt_snowflake'

# Dessa inställningar anger var dbt ska leta efter olika typer av
# filer. `model-paths` anger t.ex. att models i projektet finns i
# mappen "models/". Behöver oftast inte ändras.
model-paths: ["models"]
analysis-paths: ["analyses"]
test-paths: ["tests"]
seed-paths: ["seeds"]
macro-paths: ["macros"]
snapshot-paths: ["snapshots"]

clean-targets:         # mappar som tas bort av `dbt clean`
  - "target"
  - "dbt_packages"

models:
  dbt_code:
    staging:
      schema: staging
      materialized: table   # skapas som en fysisk tabell i staging-schemat
    refined:
      schema: warehouse
      materialized: table   # skapas som en fysisk tabell i warehouse-schemat
```

**Förklaring:** `models`-blocket i `dbt_project.yml` låter dig sätta standardinställningar per mapp/lager i ditt projekt – t.ex. vilket schema modellerna ska hamna i och hur de ska materialiseras (som `table`, `view`, `incremental` osv.). Här är `staging`-modeller konfigurerade att hamna i schemat `staging`, och `refined`-modeller i schemat `warehouse`, båda materialiserade som tabeller.

*To run:*
```bash
cd /dbt_code 
dbt run
```
Gå till Snowflake katalog och kolla att rätt schema och tabeller ligger där. 

## Vad är dbt?
![](images/what_is_dbt.png)


# 10 dbt modeling - klassanteckningar

1. Skapa nytt dbt mappstruktur:
```bash
cd <10_dbt_modeling>
dbt init dbt_code 
```
Överskriv ej användare (user) i detta fall 
Använd samma profil i profiles.yml

2. Ta bort mappar som vi ej kommer använda (README, .gitignore, snapshot mm)
*kom ihåg att kopiera från dbt .gitignore till rotmappens*
- i macros - ta bort .gitkeep (behövs inte om mappen ej är tom) 

3. I marcos - generate_schema_name.sql:
- skriver över dbt:s standardbeteende, som annars slår ihop profilens schema med modellens +schema (t.ex. staging_warehouse). Med denna macro används istället bara modellens eget +schema-namn rakt av (t.ex. bara warehouse), vilket ger renare och mer förutsägbara schemanamn i Snowflake.
```
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}
        {{ default_schema }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
```

Och string_utils:
```
{% macro capitalize_first_letter(column) %}
    case
        when {{ column }} is null
        then null
        else upper(substr({{ column }}, 1, 1)) || lower(substr({{ column }}, 2))
    end
{% endmacro %}
```
En egen macro som formaterar text till "Stor bokstav först, resten litet" (t.ex. "MALMÖ" → "Malmö"), återanvändbar i valfri modell istället för att skriva samma case when-logik flera gånger.

4. I dbt_project.yml:
- Lägg till mappar (dim, src, fct och mart) i dbt_project.yml under models och välj schema och materialize *(tex. view eller table)*


#### Förklaring

Tänk dig att dbt_project.yml är en regellista för mapparna i din models/-katalog. Istället för att bestämma i varje SQL-fil hur den ska byggas, säger du det en gång per mapp.

## Vad raderna betyder

| Rad                    | Betydelse                                                                               |
| ---------------------- | --------------------------------------------------------------------------------------- |
| `+materialized: table` | "Bygg allt som en riktig tabell i databasen." Standardregeln för alla.                  |
| `+schema: ...`         | "Lägg tabellen i det här schemat i databasen." (Ett schema är som en mapp i databasen.) |
| `ephemeral`            | "Bygg ingen tabell alls, använd bara koden som en tillfällig mellanrutin."              |

## Din config i vanlig text

| Mapp i `models/` | Materialisering | Schema      | Vad händer med SQL-filerna där               |
| ---------------- | --------------- | ----------- | -------------------------------------------- |
| `src/`           | `ephemeral`     | `staging`   | Blir ingen tabell. Planerad plats: `staging` |
| `dim/`           | `table`         | `warehouse` | Blir tabeller i `warehouse`                  |
| `fct/`           | `table`         | `warehouse` | Blir tabeller i `warehouse`                  |
| `mart/`          | `table`         | `marts`     | Blir tabeller i `marts`                      |

#### Kopplingen till models

- Mappnamnen i YAML-filen (src, dim, fct, mart) är samma namn som mapparna i din models/-katalog. En SQL-fil som ligger i models/dim/ får automatiskt reglerna under dim:.

- Ligger en fil i models/dim/kunder.sql så blir den alltså en tabell i schemat warehouse, utan att du skrivit något om det i själva filen.

#### Plustecknet

- betyder "det här är en inställning". Utan + är det ett mappnamn. Därför är src en mapp, men +schema en inställning.



- skapa/lägg til i package.yml och lägg till:
```bash
packages:
  - package: dbt-labs/dbt_utils
    version: 1.4.1
``` 
dbt_utils är ett tillägg med färdiga, testade SQL-hjälpfunktioner (macros) för vanliga behov i dbt-projekt, så man slipper återuppfinna hjulet. Vi använder den framför allt för generate_surrogate_key(), som skapar de unika ID:na (t.ex. occupation_id, employer_id) i våra dimensionstabeller.

- Installera dependencies (i dbt-mappen för projektet)
```bash
cd <10_dbt_modeling/dbt_code>
dbt deps
```
Kom ihåg att köra 
```bash
dbt debug
```
för att se att allt fungerar såhär långt (projektet är setup korrekt)

### Varför använda src?
sources.yml:
```
# Rådata tabellen
# Berättar för dbt att det finns en tabell som skapats av dlt (rådatan)
sources:
  - name: job_ads # alias att använda i koden
    schema: staging
    tables:
      - name: stg_ads
        identifier: technical_field_job_ads # det riktiga tabellnamnet
```
- tex i src_job_ads:
```
-- this is an extract of the model
-- funkar för att vi använder jinja språk
-- with <alias> som (välj allt från <source name> i <tabell_namn> från source.yml 
with stg_job_ads as (select * from {{ source('job_ads', 'stg_ads') }})

select
    OCCUPATION__LABEL as occupation_label,
    headline,
    NUMBER_OF_VACANCIES as vacancies,
    RELEVANCE,
    APPLICATION_DEADLINE
from stg_job_ads --aliaset du valde i with statementet
```

vad händer här? 
- en modell som med with skapar ett alias (som man väljer) att hämta datan från (via sources.yml) och sedan plockar ut det vi vill ha i den tabellen (fct_job_ads) och kan då referera till aliaset vi valde. För att göra det enklare. 

senare i models/fct/fct_job_ads:
```
-- with <nytt alias> select allt från referera till <src-aliaset>
with job_ads as (select * from {{ ref('src_job_ads') }})

select
    {{ dbt_utils.generate_surrogate_key(['occupation_label']) }} as occupation_id,
    vacancies,
    relevance,
    application_deadline
from job_ads
```