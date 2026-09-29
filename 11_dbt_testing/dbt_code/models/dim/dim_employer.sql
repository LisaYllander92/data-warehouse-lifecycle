with src_employer as (select * from {{ ref('src_employer') }})

select
    {{ dbt_utils.generate_surrogate_key(['employer_name', 'employer_organization_number', 'workplace_street_address', 'workplace_postcode']) }} as employer_id,
    employer_name,
    employer_organization_number,
    workplace_street_address,
    workplace_postcode,
    max(employer_workplace) as employer_workplace,
    max(workplace_region) as workplace_region,
    max(workplace_city) as workplace_city,
    max(workplace_country) as workplace_country
from src_employer
group by employer_name, employer_organization_number, workplace_street_address, workplace_postcode