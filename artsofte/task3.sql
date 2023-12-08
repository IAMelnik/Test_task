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
select id,value, client_id, client_name,payment_date, manager_name, manager_email,
case when first_pay_id=id then 'Новый' else 'Действующий' end as client_state
from (select *, 
FIRST_VALUE(id) over(partition by client_name order by payment_date,  id) as first_pay_id
from full_table) as t
order by client_name, payment_date
