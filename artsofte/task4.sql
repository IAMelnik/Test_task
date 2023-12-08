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
select period, revenue_by_month , sum(revenue_by_month) over(order by pd) as revenue_cumulative
from (select DATE_TRUNC('month', payment_date) as pd, to_char(DATE_TRUNC('month', payment_date), 'TMMonth YYYY') as period, sum(value) as revenue_by_month 
from full_table
group by period, pd) as t
order by pd 
