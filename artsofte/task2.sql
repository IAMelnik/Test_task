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
select COALESCE(department, 'Отдел не определен') as dept, value
from (select department, sum(value) as value
from full_table
group by department) t
order by value desc
