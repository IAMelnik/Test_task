with md as (select email, regexp_replace(department, '\s{2,}', ' ') as department
from artsoft.manager_departments as md),
pay as (select 
id
,value
,client_id
,client_name
,payment_date
,manager_name
,regexp_replace(manager_email, '(n)', 'n.') as manager_email
from artsoft.payments
),
full_table as (select *
from md
left join pay on pay.manager_email=md.email)
select *
from (select client_name, manager_name, value, payment_date,row_number() over(partition by EXTRACT(DAY FROM payment_date) order by value desc) as rn
from full_table
where 1=1
and EXTRACT(MONTH FROM payment_date) = 1
and EXTRACT(YEAR FROM payment_date) = 2023) as t
where rn =1
order by value desc
