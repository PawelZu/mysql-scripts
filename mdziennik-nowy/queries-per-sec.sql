select q.variable_value/1000000 as 'q mln', u.variable_value/3600 as 'up h', q.variable_value/u.variable_value as 'q/s'
from information_schema.global_status q, information_schema.global_status u
where q.variable_name='queries'
and u.variable_name='uptime'