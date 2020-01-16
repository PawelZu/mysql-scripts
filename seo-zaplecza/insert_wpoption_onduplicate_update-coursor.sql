DROP PROCEDURE IF EXISTS insert_wpoption_onduplicate_update;
DELIMITER //
CREATE PROCEDURE insert_wpoption_onduplicate_update(optionName VARCHAR(50), optionValue VARCHAR(255))
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
	SET @sql_text = CONCAT('INSERT INTO ', @table_name, ' (option_name, option_value) VALUES ("', optionName, '", "', optionValue, '") ON DUPLICATE KEY UPDATE option_value="', optionValue, '"');
	PREPARE stmt FROM @sql_text;
	
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
  END LOOP;

  CLOSE cur1;
END //
DELIMITER ;



   


call insert_wpoption_onduplicate_update('feedwordpress_munge_permalink', 'no')