DROP PROCEDURE IF EXISTS postsDelWPMU;
DELIMITER //
CREATE PROCEDURE `postsDelWPMU`(dateFrom DATE, blogId int)
BEGIN

	SET @sql_text = CONCAT("DELETE FROM wp_", CAST(blogId AS CHAR), "_posts WHERE post_type='post' AND post_date>'", dateFrom, "'");
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @sql_text2 = CONCAT("DELETE FROM wp_", CAST(blogId AS CHAR), "_term_relationships WHERE object_id NOT IN (SELECT ID FROM wp_", CAST(blogId AS CHAR), "_posts UNION SELECT link_id FROM wp_", CAST(blogId AS CHAR), "_links)");
	PREPARE stmt FROM @sql_text2;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @sql_text3 = CONCAT("DELETE FROM wp_", CAST(blogId AS CHAR), "_postmeta WHERE post_id NOT IN (SELECT ID FROM wp_", CAST(blogId AS CHAR), "_posts)");
	PREPARE stmt FROM @sql_text3;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	 
END //
DELIMITER ;


CONCAT("SELECT FROM wp_", CAST(blogId AS CHAR), "_posts WHERE post_type='post' AND post_date>'", dateFrom, "'");
CALL postsDelWPMU(
'2013-10-04', 4
)