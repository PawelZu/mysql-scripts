update `wp_term_taxonomy` tt
set `count`=(
 select count(*) as ile from wp_term_relationships tr
 where tr.`term_taxonomy_id`=tt.`term_taxonomy_id`
 group by tr.`term_taxonomy_id`
 )

 
 
 
 
 
update `wp_posts` p
set `comment_count`=(
 select count(*) as ile from wp_comments c
 where c.`comment_post_ID`=p.ID
 group by c.`comment_post_ID`
 )

 
 
 
 
 
 
 
 
delete wp_term_taxonomy.*, wp_terms.*
FROM  `wp_term_taxonomy` 
join wp_terms using (`term_id`)
WHERE  `count` =0
AND parent=1489