DROP PROCEDURE IF EXISTS del_feedwp_tax;
DELIMITER //
CREATE PROCEDURE del_feedwp_tax()
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
	
	SET @table_name = CONCAT('wp_', CAST(site_id AS CHAR), '_options');
	SET @sql_text = CONCAT('DELETE FROM ', @table_name, ' WHERE option_name="feedwordpress_syndication_cats"');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	SET @sql_text = CONCAT('insert into ', @table_name, ' (option_name, option_value, autoload) values (\'feedwordpress_match_cats\', \'a:1:{i:0;s:1:"0";}\', \'yes\'),(\'feedwordpress_match_filter\', \'a:1:{i:0;s:1:"0";}\', \'yes\'),(\'feedwordpress_match_tags\', \'a:1:{i:0;s:1:"0";}\', \'yes\') ON DUPLICATE KEY UPDATE option_value=\'a:1:{i:0;s:1:"0";}\'');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	SET @sql_text = CONCAT('insert into ', @table_name, ' (option_name, option_value, autoload) values (\'feedwordpress_unfamiliar_category\', \'null\', \'yes\'),(\'feedwordpress_unfamiliar_post_tag\', \'null\', \'yes\') ON DUPLICATE KEY UPDATE option_value=\'null\'');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	SET @table_name = CONCAT('wp_', CAST(site_id AS CHAR), '_term_relationships');
	SET @sql_text = CONCAT('DELETE FROM ', @table_name, ' WHERE term_taxonomy_id=1');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	SET @table_name = CONCAT('wp_', CAST(site_id AS CHAR), '_term_taxonomy');
	SET @sql_text = CONCAT('UPDATE ', @table_name, ' SET count=0 WHERE term_taxonomy_id=1');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
  END LOOP;

  CLOSE cur1;
END //
DELIMITER ;

--feedwordpress_syndication_cats

   
insert into wp_30_options (option_name, option_value, autoload) values ('feedwordpress_match_cats', 'a:1:{i:0;s:1:"0";}', 'yes'),('feedwordpress_match_filter', 'a:1:{i:0;s:1:"0";}', 'yes'),('feedwordpress_match_tags', 'a:1:{i:0;s:1:"0";}', 'yes') ON DUPLICATE KEY UPDATE option_value='a:1:{i:0;s:1:"0";}'

insert into wp_30_options (option_name, option_value, autoload) values ('feedwordpress_unfamiliar_category', 'null', 'yes'),('feedwordpress_unfamiliar_post_tag', 'null', 'yes') ON DUPLICATE KEY UPDATE option_value='null'

