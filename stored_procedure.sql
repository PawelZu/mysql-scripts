DROP PROCEDURE IF EXISTS galeryDel;

DELIMITER //

CREATE PROCEDURE galeryDel()
  BEGIN
	DELETE FROM wp_posts WHERE post_date>'2012-11-09';
		
	DELETE FROM wp_feed_items WHERE post_ID NOT IN (
		SELECT ID FROM wp_posts
	);
	
	DELETE FROM wp_feed_post_photos WHERE post_ID NOT IN (
		SELECT ID FROM wp_posts
	);
	
	DELETE FROM wp_term_relationships WHERE `object_id` NOT IN (
		SELECT ID FROM wp_posts
	);
	
  END //
DELIMITER ;


DROP PROCEDURE IF EXISTS postsDel;

DELIMITER //

CREATE PROCEDURE postsDel(dateFrom DATE)
  BEGIN
	DELETE FROM wp_posts WHERE post_date>dateFrom;
		
	DELETE FROM wp_feed_items WHERE post_ID NOT IN (
		SELECT ID FROM wp_posts
	);
	
	DELETE FROM wp_feed_post_photos WHERE post_ID NOT IN (
		SELECT ID FROM wp_posts
	);
	
	DELETE FROM wp_term_relationships WHERE `object_id` NOT IN (
		SELECT ID FROM wp_posts
	);
	
  END //
DELIMITER ;