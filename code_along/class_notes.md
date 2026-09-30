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


# 10 dbt modeling
 
## 1. Skapa ny dbt-mappstruktur
```bash
cd 10_dbt_modeling
dbt init dbt_code
```
`dbt init` initierar ett nytt dbt-projekt i undermappen `dbt_code` och frågar interaktivt efter uppkopplingsuppgifter till Snowflake.
 
>  Svara att den **inte** ska skrivas över, så att du återanvänder samma uppkopplingsuppgifter som i tidigare övningar.
 
Återanvänd samma profil (`dbt_snowflake`) i `profiles.yml` som i tidigare lektioner, istället för att skapa en helt ny.
 
## 2. Städa mappstrukturen
Ta bort mappar/filer som inte används i just detta projekt (t.ex. `README.md`, `.gitignore`, `snapshots` om ni inte snapshot:ar).
 
- **Kom ihåg att kopiera innehållet från dbt:s genererade `.gitignore` till rotmappens `.gitignore`**, så att t.ex. `target/`, `dbt_packages/` och `logs/` ignoreras även på projektnivå (annars riskerar du samma "allt är rött i git"-problem som tidigare).
- I `macros/`-mappen: ta bort `.gitkeep`-filen. Den filen finns bara för att git ska spåra en annars tom mapp – behövs inte längre när mappen innehåller riktiga macro-filer.
## 3. Macros: generate_schema_name och string_utils
 
### generate_schema_name.sql
Skriver över dbt:s standardbeteende, som annars slår ihop profilens schema med modellens `+schema` (t.ex. `staging_warehouse`). Med denna macro används istället bara modellens eget `+schema`-namn rakt av (t.ex. bara `warehouse`), vilket ger renare och mer förutsägbara schemanamn i Snowflake.
 
```sql
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}
        {{ default_schema }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
```
 
### string_utils.sql – capitalize_first_letter
En egen macro som formaterar text till "Stor bokstav först, resten litet" (t.ex. `"MALMÖ"` → `"Malmö"`), återanvändbar i valfri modell istället för att skriva samma `case when`-logik flera gånger.
 
```sql
{% macro capitalize_first_letter(column) %}
    case
        when {{ column }} is null
        then null
        else upper(substr({{ column }}, 1, 1)) || lower(substr({{ column }}, 2))
    end
{% endmacro %}
```
 
## 4. dbt_project.yml – konfigurera mapparna
Lägg till mapparna (`src`, `dim`, `fct`, `mart`) under `models:` och sätt `+schema` och `+materialized` (t.ex. `view` eller `table`) för var och en.
 
### Förklaring
Tänk dig att `dbt_project.yml` är en regellista för mapparna i din `models/`-katalog. Istället för att bestämma i varje SQL-fil hur den ska byggas, säger du det en gång per mapp.
 
**Vad raderna betyder:**
 
| Rad | Betydelse |
|---|---|
| `+materialized: table` | "Bygg allt som en riktig tabell i databasen." |
| `+schema: ...` | "Lägg tabellen i det här schemat i databasen." (Ett schema är som en mapp i databasen.) |
| `+materialized: ephemeral` | "Bygg ingen tabell alls, använd bara koden som en tillfällig mellanrutin (klistras in som en CTE i modeller som refererar till den)." |
 
**Config i klartext:**
 
| Mapp i `models/` | Materialisering | Schema | Vad händer med SQL-filerna där |
|---|---|---|---|
| `src/` | `ephemeral` | `staging` | Blir ingen egen tabell/view i Snowflake; koden klistras in i modeller som gör `ref()` till den. |
| `dim/` | `table` | `warehouse` | Blir tabeller i `warehouse` |
| `fct/` | `table` | `warehouse` | Blir tabeller i `warehouse` |
| `mart/` | `table` | `marts` | Blir tabeller i `marts` |
 
> ⚠️ **Kom ihåg:** i en tidigare lektion användes schemat `mart` (singular) och du fick av misstag två parallella scheman (`mart` och `marts`) med samma tabell, vilket du fick städa bort manuellt. Se till att du är konsekvent med vilket namn (`mart` eller `marts`) du använder i det här projektet, så att du inte återskapar samma dubblett.
 
**Kopplingen till models:** Mappnamnen i YAML-filen (`src`, `dim`, `fct`, `mart`) är samma namn som mapparna i din `models/`-katalog. En SQL-fil som ligger i `models/dim/` får automatiskt reglerna under `dim:`. Ligger en fil i `models/dim/kunder.sql` blir den alltså en tabell i schemat `warehouse`, utan att du skrivit något om det i själva filen.
 
**Plustecknet:** `+` betyder "det här är en inställning". Utan `+` är det ett mappnamn. Därför är `src` en mapp, men `+schema` en inställning.
 
## 5. packages.yml – dbt_utils
 
> Filen ska heta **`packages.yml`** (plural), inte `package.yml`. Ett felstavat filnamn gör att dbt inte hittar den, och `dbt deps` har inget att installera.
 
```yaml
packages:
  - package: dbt-labs/dbt_utils
    version: 1.4.1
```
 
`dbt_utils` är ett tillägg med färdiga, testade SQL-hjälpfunktioner (macros) för vanliga behov i dbt-projekt, så man slipper återuppfinna hjulet. Vi använder den framför allt för `generate_surrogate_key()`, som skapar de unika ID:na (t.ex. `occupation_id`, `employer_id`) i våra dimensionstabeller.
 
Installera beroenden (i dbt-mappen för projektet):
```bash
cd 10_dbt_modeling/dbt_code
dbt deps
```
 
Kör därefter:
```bash
dbt debug
```
för att bekräfta att anslutningen och projektet är korrekt konfigurerat, innan du börjar bygga modeller.
 
## Varför använda src?
 
### sources.yml
```yaml
# Rådatatabellen.
# Berättar för dbt att det finns en tabell skapad av dlt (rådatan),
# som dbt själv inte äger eller bygger.
sources:
  - name: job_ads          # alias att använda i koden
    schema: staging
    tables:
      - name: stg_ads
        identifier: technical_field_job_ads   # det riktiga tabellnamnet i Snowflake
```
 
### t.ex. i src_job_ads
```sql
-- this is an extract of the model
-- funkar tack vare Jinja-templating (dubbla måsvingar {{ }})
-- with <alias> as (select allt från <source_name>.<table_name> enligt sources.yml)
with stg_job_ads as (select * from {{ source('job_ads', 'stg_ads') }})
 
-- gör inga större transformeringar i src-lagret – det är till för att
-- plocka ut och döpa om relevanta kolumner, inte för affärslogik
select
    OCCUPATION__LABEL as occupation_label,
    headline,
    NUMBER_OF_VACANCIES as vacancies,
    RELEVANCE,
    APPLICATION_DEADLINE
from stg_job_ads   -- aliaset som valdes i with-satsen
```
 
**Vad händer här?**
En modell som med `with` skapar ett alias (valfritt namn) för att hämta rådata via `sources.yml`, och sedan plockar ut och döper om de kolumner man vill jobba vidare med. Downstream-modeller (dim/fct) refererar sedan till *src-modellen* via `ref()`, istället för att varje modell behöver känna till hela den råa källtabellen. Det gör koden enklare att läsa och att underhålla, eftersom döpnings- och urvalslogiken bara finns på ett ställe.
 
### Senare, i models/fct/fct_job_ads
```sql
-- with <nytt alias> as (select allt, referera till src-aliaset via ref())
with job_ads as (select * from {{ ref('src_job_ads') }})
 
select
    {{ dbt_utils.generate_surrogate_key(['occupation_label']) }} as occupation_id,
    vacancies,
    relevance,
    application_deadline
from job_ads
```
 
Här skapas surrogatnyckeln `occupation_id` genom att hasha `occupation_label`. Det är **inte** nyckeln i sig som kopplar ihop tabellerna, utan det faktum att `dim_occupation` räknar fram exakt samma hash (samma kolumn, samma värde) för samma yrke. Eftersom båda sidor gör identisk hashning kan de sedan joinas ihop på `occupation_id`. I den här modellen görs ingen aggregering (`max`/`min`), eftersom `fct_job_ads` ska ha en rad per annons – aggregering med `max()`/`min()` används istället i dim-modellerna, där flera rader (annonser) ska slås ihop till en rad per unikt värde (t.ex. per yrke eller arbetsgivare).

