DROP PROCEDURE IF EXISTS del_przykladowePosty;
DELIMITER //
CREATE PROCEDURE del_przykladowePosty()
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
	
	SET @table_post = CONCAT('wp_', CAST(site_id AS CHAR), '_posts');
	SET @table_postMeta = CONCAT('wp_', CAST(site_id AS CHAR), '_postmeta');
    
	SET @sql_text = CONCAT('DELETE FROM ', @table_post, ' WHERE ID < 3');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
    
	SET @sql_text = CONCAT('DELETE FROM ', @table_postMeta, ' WHERE post_id < 3');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
  END LOOP;

  CLOSE cur1;
END //
DELIMITER ;



   


call del_przykladowePosty