# Exercise 0 

## 1. How much does it cost?

For these exercises, look up the credit cost for your snowflake edition, cloud provider and region for your snowflake account.
- Alt 1: I snowflake -> gå in på **ACCOUNTADMIN** (ditt konto) -> Account -> View account Details - här hittar du **Edition** och **Cloud Provider**. *Här finns även sql-kommandon för att se account details i terminalen*
- Alt 2: **Admin** -> **Accounts** - här finns dina olika konton med information om *Region*, *Edition* och *Cloud*
- För att ta reda på credit cost gå till Snowflakes officiella pricing sida: *https://www.snowflake.com/pricing* och fyll i din *platform* och *region* och se **price per credit**  under din *edition*

### Min info: 
- Cloud provider: Azure
- Region: West Europe (Netherlands)
- Edition: Enterprise
- Credit cost: $3.90 / per credit ($USD)

&nbsp; a) You have a simple workload that runs daily in Snowflake. The workload uses 0.5 credits per day. Calculate the total credit usage and cost for a 30-day month.
- Svar: Steg 1 - Antal credits för månaden:
    - Daglig förbrukning × antal dagar = totala credits
0,5 × 30 = **15 credits**
- Steg 2 - Total kostnad:
    - Totala credits × pris per credit = total kostnad
15 × $3,90 = **$58.50**

&nbsp; b) Your workload varies throughout the month. For the first 10 days, you use 2 credits per day. For the next 10 days, you use 1.5 credits per day, and for the last 10 days, you use 1 credit per day. Calculate the total credit usage and cost for a 30-day month.
- Svar: (10 x 2) = 20 + (10 x 1.5) = 15 + (10 x 1) = 10. Totalt (20 + 15 +10) = **45 credits** x 3.90 = **$175.5**

&nbsp; c) You have three different warehouses running workloads simultaneously. Warehouse A is of size XS, Warehouse B is of size S, and Warehouse C is of size M. Warehouse A is used for 10h/day, B is used for 2h/day and C is used for 1h/day. Calculate the total monthly cost assuming each warehouse runs for the full 30-day month.
- Se kostanderna för olika Warehouses: *https://docs.snowflake.com/en/user-guide/warehouses-overview*
- Svar: A (10h/dag x 1) = *10 credits/dag* + B (2h/dag x 2) = *4 credits/dag* + C (1h/dag x 4) = *4 credits/dag*. 10 + 4 + 4 = 18 credits/dag x 30 = **540 credits/månad** x $3.90 = **$2106**

&nbsp; d) Your Snowflake warehouse uses auto-scaling. For the first 10 days, it operates on 2 clusters for 10 hours per day. For the next 10 days, it scales up to 3 clusters for 10 hours per day. For the last 10 days, it scales up to 4 clusters for 10 hours per day. Calculate the total monthly budget. Assume the warehouse consumes 1 credit per hour per cluster.
- Svar: 
    - 10 dagar x (2 cluster x 10h/dag) = 200 klustertimmar (h/10 dagar)
    - 10 dagar x (3 cluster x 10h/dag) = 300 klustertimmar (h/10 dagar)
    - 10 dagar x (4 cluster x 10h/dag) = 400 klustertimmar (h/10 dagar)
    - Totalt för månaden: 900h x 1 credit = **900 credits**
    - Kostnad: 900 x 3.90 = **$3510**

## 2. Theory questions

These study questions are good to get an overview of how snowflake works.

&nbsp; a) What are the main components of Snowflake's architecture?
- Snowflake separerar lagring (Storage Layer), beräkning (Compute Layer) och tjänster (Cloud Services Layer) i tre lager som skalar oberoende av varandra - det ör denna seperation som gör att man kan skala upp/ner compute utan att flytta data, och köra flera warehouses parallellt mot samma data utan konflikter.  

&nbsp; b) Explain the role of the storage layer in Snowflake.
- I lagringslagret lagras alla data, komprimerad och organiserad i Snowflakes egna optimerade kolumnformat. Datan lagras i molnleverantörens objektlagring (t.ex Azure Blob Storage, AWS S3 eller Google Cloud Storage). Detta lager är helt frikopplat från coumput vilket innebör att du betalar för lagringen separat, oavsett hur mycket du kör frågor. 

&nbsp; c) What is the purpose of the compute layer in Snowflake?
- Beräkningslagret består av virtuella warehouses - kluster av compute-resurser (CPU, minne, temporär disk) som används för att köra frågor och ladda data. Varje warehouse jobbar oberoende av andra warehouses, vilket gör att flera team kan köra sina egna workloads samtidigt utan att påverka varandras prestanda (ingen resurskonkurrens). Det är här credits förbrukas. 

&nbsp; d) How does the cloud services layer enhance the functionality of Snowflake?
- Cloud services-lagret fungerar som en central "hjärna" som koordinerar allt mellan lagrings- och beräkningslagret, och det är detta som gör Snowflake enkelt att använda och hantera jämfört med traditionella data warehouses. Det hanterar bland annat:
    - Autentisering och åtkomstkontroll – säkerställer att endast behöriga användare/roller kan komma åt viss data.
    - Metadatahantering – håller reda på vilka tabeller, scheman och databaser som finns, samt statistik om datan (t.ex. för query-optimering).
    - Query-parsing och optimering – analyserar och optimerar SQL-frågor innan de skickas till ett warehouse för exekvering, vilket förbättrar prestanda.
    - Transaktionshantering – säkerställer dataintegritet (ACID-egenskaper) vid samtidiga skriv- och läsoperationer.
    - Infrastrukturhantering – sköter automatiskt saker som skalning och failover utan att användaren behöver hantera det manuellt.

&nbsp; e) What is a virtual warehouse in Snowflake, and how does it differ from a traditional data warehouse?
- En virtual warehouse är en flexibel, isolerad beräkningsresurs som kan skalas oberoende av lagring — vilket skiljer sig markant från traditionella data warehouses där compute och storage är hårt sammankopplade.

&nbsp; f) When are the cases you would want to scale up versus scaling out in terms of virtual warehouses and compute resources.
    - Scale up → snabbare enskilda frågor (vertikal skalning, mer kraft per kluster)
    - Scale out → fler samtidiga frågor utan köbildning (horisontell skalning, fler kluster)\
*En bra tumregel: om frågorna är långsamma → scale up. Om frågorna köar trots att de är snabba var för sig → scale out.*

&nbsp; g) How does Snowflake's pricing model differ from traditional on-premise data warehousing solutions?
- Snowflake byter ut stora, fasta investeringar och statisk kapacitet mot en flexibel, konsumtionsbaserad modell där du bara betalar för den lagring och beräkningskraft du faktiskt använder, vilket eliminerar överkapacitet och gör kostnaden mer direkt kopplad till faktiskt behov.

&nbsp; h) What is the difference between pay-as-you-go and upfront storage, and when you should you choose one over the other?
- Pay-as-you-go (On-Demand) innebär att du betalar en fast, något högre, avgift per TB per månad baserad på din genomsnittliga lagringsanvändning. Du kan när som helst öka eller minska din lagring utan bindningstid.
- Upfront (Capacity/pre-purchase) innebär ist att du binder dig till en viss mängd lagring under en avtalsperiod i utbyte mot ett rabatterat pris per TB. 
     - Man bör välja On-Demand när man befinner sig i en tidig eller experimentell fas, har oförutsägbar eller kraftigt varierande datavolym, eller är en mindre organisation utan långsiktigt åtagande — flexibiliteten väger då tyngre än priset. 
     - Man bör istället välja Upfront/Capacity när man har en stabil, förutsägbar och växande lagringsvolym över tid, exempelvis som ett etablerat företag med långsiktig Snowflake-användning — då blir rabatten en ren besparing eftersom man ändå vet att man kommer att använda lagringen, och risken att betala för outnyttjad kapacitet är låg.

&nbsp; i) Explain the concept of Time Travel and Fail-safe in Snowflake and its use cases
- Time Travel ger dig självbetjänad, tidsbegränsad återställning av data (upp till 90 dagar på Enterprise), medan Fail-safe är ett obligatoriskt, icke-styrbart extra skydd på 7 dagar därefter som endast Snowflake Support kan hjälpa dig med — tillsammans ger de ett lagerbaserat skydd mot både misstag och katastrofala fel.
    - Time Travel: Ångra en oavsiktlig DELETE/UPDATE/DROP, jämföra data mellan tidpunkter, felsöka dataförändringar, ta konsekventa kopior (klonar) för test/utveckling utan att påverka produktionsdata.
    - Fail-safe: Sista skyddsnät vid allvarliga systemfel eller säkerhetsincidenter där Time Travel-fönstret redan har passerat — inte tänkt som ett dagligt verktyg utan en absolut sista utväg

## Snowflake – Glosor och förklaringar

| terminology       | explanation |
| ----------------- | ----------- |
| downstream        | Data eller processer som ligger **efter** en viss punkt i dataflödet — t.ex. rapporter eller dashboards som konsumerar data som redan bearbetats. |
| upstream          | Data eller processer som ligger **före** en viss punkt i dataflödet — t.ex. källsystem eller råata som matas in i warehouse. |
| data warehouse    | Ett centraliserat system för att lagra och analysera stora mängder strukturerad data, ofta från flera källor, optimerat för rapportering och analys. |
| cloud computing   | Att använda IT-resurser (lagring, beräkning, mjukvara) via internet från en molnleverantör istället för egen fysisk hårdvara. |
| OLAP              | Online Analytical Processing — system optimerade för komplexa analytiska frågor och rapportering över stora datamängder (t.ex. Snowflake). |
| OLTP              | Online Transaction Processing — system optimerade för snabba, frekventa transaktioner (t.ex. att lägga en beställning i en webbutik). |
| virtual warehouse | Ett kluster av compute-resurser i Snowflake som används för att köra frågor och bearbeta data, helt frikopplat från lagring. |
| external stage    | En referens till en plats utanför Snowflake (t.ex. Azure Blob Storage, S3) där filer lagras innan/efter de laddas in i eller ut ur Snowflake. |
| data consumer     | En användare, applikation eller organisation som tar emot och använder data, t.ex. via delning från en dataleverantör. |
| scaling out       | Att lägga till fler kluster (multi-cluster) för att hantera fler samtidiga frågor — horisontell skalning. |
| scaling up        | Att öka storleken på en warehouse (t.ex. från Small till Large) för att göra enskilda frågor snabbare — vertikal skalning. |
| snowflake credit  | Snowflakes egen valuta/måttenhet för att mäta förbrukning av compute-resurser (och vissa serverless-tjänster). |
| securable object  | Ett objekt i Snowflake (t.ex. databas, tabell, warehouse) som åtkomst till kan styras via roller och rättigheter. |
| schema            | En logisk gruppering av databasobjekt (tabeller, vyer, etc.) inom en databas, som organiserar data hierarkiskt. |
| permanent table   | Standardtyp av tabell i Snowflake med fullt Time Travel (upp till 90 dagar) och Fail-safe (7 dagar). |
| transient table   | En tabell utan Fail-safe och med max 1 dags Time Travel — billigare att lagra, används för tillfällig eller icke-kritisk data. |
| temporary table   | En tabell som endast existerar under den session den skapades i och försvinner automatiskt när sessionen avslutas. |
| time-travel       | Funktion som låter dig komma åt, fråga eller återställa historisk data upp till en konfigurerad retention-period (max 90 dagar på Enterprise). |
| fail-safe         | Ett icke-konfigurerbart 7-dagars säkerhetsnät efter Time Travel, där data endast kan återställas via Snowflake Support. |
| view              | En sparad, virtuell fråga som presenterar data från en eller flera tabeller utan att fysiskt lagra datan separat. |
| table             | Den grundläggande strukturen för att lagra data i rader och kolumner i en databas. |
| DML               | Data Manipulation Language — SQL-kommandon för att ändra data, t.ex. `INSERT`, `UPDATE`, `DELETE`. |
| DDL               | Data Definition Language — SQL-kommandon för att definiera/ändra strukturer, t.ex. `CREATE`, `ALTER`, `DROP`. |
| DQL               | Data Query Language — SQL-kommandon för att hämta data, i praktiken främst `SELECT`. |
| DCL               | Data Control Language — SQL-kommandon för att styra åtkomst och rättigheter, t.ex. `GRANT`, `REVOKE`. |