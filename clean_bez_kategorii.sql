DROP PROCEDURE IF EXISTS clean_bez_kategorii;
DELIMITER //
CREATE PROCEDURE clean_bez_kategorii()
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
	
	SET @table_name = CONCAT('wp_', CAST(site_id AS CHAR), '_term_relationships');
	SET @sql_text = CONCAT('DELETE FROM ', @table_name, ' WHERE term_taxonomy_id = 1');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	SET @table_name = CONCAT('wp_', CAST(site_id AS CHAR), '_term_taxonomy');
	SET @sql_text = CONCAT('UPDATE ', @table_name, ' SET count = 0 WHERE term_taxonomy_id = 1');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
  END LOOP;

  CLOSE cur1;
END //
DELIMITER ;