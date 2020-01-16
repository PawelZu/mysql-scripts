DROP PROCEDURE IF EXISTS drop_tables;
DELIMITER //
CREATE PROCEDURE drop_tables(tableName VARCHAR(50))
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
	
	SET @table_name = CONCAT('wp_', CAST(site_id AS CHAR), '_', tableName);
	
	SET @sql_text = CONCAT('DROP TABLE IF EXISTS ', @table_name);
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
  END LOOP;

  CLOSE cur1;
END //
DELIMITER ;

