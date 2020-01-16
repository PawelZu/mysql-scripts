DROP PROCEDURE IF EXISTS delete_admin_posts;
DELIMITER //
CREATE PROCEDURE delete_admin_posts()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE site_id INT;
  
  DECLARE cur1 CURSOR FOR SELECT blog_id FROM wp_blogs WHERE blog_id > 1;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO site_id;
    IF done THEN
      LEAVE read_loop;
    END IF;
	
	SET @table_posts = CONCAT('wp_', CAST(site_id AS CHAR), '_posts');
	SET @sql_text = CONCAT('DELETE FROM ', @table_posts, ' WHERE post_author=5 AND post_type="post"');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	SET @table_postmeta = CONCAT('wp_', CAST(site_id AS CHAR), '_postmeta');
	SET @sql_text2 = CONCAT('DELETE FROM ', @table_postmeta, ' WHERE post_id NOT IN (SELECT ID FROM ', @table_posts, ')');
	PREPARE stmt FROM @sql_text2;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	SET @table_term_relationships = CONCAT('wp_', CAST(site_id AS CHAR), '_term_relationships');
	SET @sql_text3 = CONCAT('DELETE FROM ', @table_term_relationships, ' WHERE object_id NOT IN (SELECT ID FROM ', @table_posts, ')');
	PREPARE stmt FROM @sql_text3;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
  END LOOP;

  CLOSE cur1;
END //
DELIMITER ;



   
SHOW CREATE PROCEDURE delete_admin_posts

feedwordpress_formatting_filters

	--UPDATE @table_posts SET option_value=optionValue WHERE option_name=optionName;

DROP PROCEDURE IF EXISTS delete_admin_posts;

call delete_admin_posts