DROP PROCEDURE IF EXISTS add_index;
DELIMITER //
CREATE PROCEDURE add_index()
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

	SET @table_name = CONCAT('wp_', CAST(site_id AS CHAR), '_posts');
	
	IF((SELECT COUNT(*) AS index_exists FROM information_schema.statistics 
		WHERE TABLE_SCHEMA = DATABASE()
		and table_name = @table_name
		AND index_name = 'status_modifiedgmt') = 0) THEN
			SET @sql_text = CONCAT('ALTER TABLE ', @table_name, ' ADD INDEX status_modifiedgmt (post_status, post_modified_gmt)');
			PREPARE stmt FROM @sql_text;
			
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;
	END IF;
	
  END LOOP;

  CLOSE cur1;
END //
DELIMITER ;