update `wp_posts` p
set `comment_count`=(
 select count(*) as ile from wp_comments c
 where c.comment_post_ID=p.ID
 and c.comment_approved=1
 group by c.comment_post_ID
 )

 
 
 
