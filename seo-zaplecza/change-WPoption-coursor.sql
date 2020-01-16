DROP PROCEDURE IF EXISTS change_wpoption;
DELIMITER //
CREATE PROCEDURE change_wpoption(optionName VARCHAR(100), optionValue VARCHAR(255))
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
	SET @sql_text = CONCAT('INSERT INTO ', @table_name, ' (option_name, option_value, autoload) VALUES("',optionName,'","',optionValue,'","yes") ON DUPLICATE KEY UPDATE option_value="', optionValue, '"');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
  END LOOP;

  CLOSE cur1;
END //
DELIMITER ;



   


call change_wpoption('feedwordpress_update_window','720');
call change_wpoption('feedwordpress_update_minimum','yes');
call change_wpoption('feedwordpress_update_time_limit','60')
call change_wpoption('feedwordpress_fetch_timeout','40')
call change_wpoption('feedwordpress_tombstones','no')
call change_wpoption('feedwordpress_resolve_relative','no')
call change_wpoption('feedwordpress_unfamiliar_author','1')
call change_wpoption('feedwordpress_match_cats','a:1:{i:0;s:1:\\"0\\";}')
call change_wpoption('feedwordpress_match_tags','a:1:{i:0;s:1:\\"0\\";}')
call change_wpoption('feedwordpress_unfamiliar_category','null')
call change_wpoption('feedwordpress_unfamiliar_post_tag','null')
call delete_wpoption_cursor('feedwordpress_syndication_cats')