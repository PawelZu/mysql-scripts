DROP PROCEDURE IF EXISTS feedWP_local_url_change;
DELIMITER //
CREATE PROCEDURE feedWP_local_url_change()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE site_id INT;
  
  DECLARE cur1 CURSOR FOR SELECT blog_id FROM wp_blogs WHERE blog_id > 1;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  
  CREATE TEMPORARY TABLE tmp_feedwordpress_munge_permalink(
    blog_id int(3),
    permalink varchar(100)
  );

  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO site_id;
    IF done THEN
      LEAVE read_loop;
    END IF;
	
	SET @table_name = CONCAT('wp_', CAST(site_id AS CHAR), '_options');
	SET @sql_text = CONCAT('INSERT INTO tmp_feedwordpress_munge_permalink (blog_id, permalink) VALUES (',site_id,',(
        SELECT option_value FROM ',@table_name,' WHERE option_name = "feedwordpress_munge_permalink"
    ))');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
  END LOOP;

  CLOSE cur1;
  
  SELECT * FROM tmp_feedwordpress_munge_permalink;
  
  drop TEMPORARY TABLE tmp_feedwordpress_munge_permalink;
END //
DELIMITER ;

