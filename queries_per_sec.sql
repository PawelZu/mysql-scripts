SELECT queries.variable_value/uptime.variable_value as `q/s`, (uptime.variable_value/3600)/24 as `up/d`
FROM information_schema.global_status queries, information_schema.global_status uptime
WHERE queries.variable_name='queries'
AND uptime.variable_name ='uptime';