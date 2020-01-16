select @rownum:=@rownum+1 as rowno,
		wp_links.*
from wp_links,
(SELECT @rownum:=0) r
order by link_name;