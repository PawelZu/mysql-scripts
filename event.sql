CREATE EVENT publish_mised_schedule
 ON SCHEDULE
  EVERY 10 MINUTE
  STARTS '2013-04-16 17:38:00'
   DO 
		UPDATE wp_posts set post_status='publish'
		WHERE post_status='future'
		AND post_date < NOW() 

		
		
		
		
		
		
		
		
CREATE EVENT publish_mised_schedule
 ON SCHEDULE
  EVERY 10 MINUTE
  STARTS '2014-03-11 17:38:00'
   DO 
		DELETE FROM popular_posts_count WHERE (UNIX_TIMESTAMP() - UNIX_TIMESTAMP( date ) > 2592000)