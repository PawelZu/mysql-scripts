DROP PROCEDURE IF EXISTS feedWP_munge_permalink_check;
DELIMITER //
CREATE PROCEDURE feedWP_munge_permalink_check()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE site_schema varchar(100);
  
  DECLARE cur1 CURSOR FOR select table_schema from information_schema.tables where table_name = 'wp_options' order by table_schema;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  
  CREATE TEMPORARY TABLE tmp_feedwordpress_munge_permalink(
    site varchar(100),
    permalink varchar(100)
  );

  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO site_schema;
    IF done THEN
      LEAVE read_loop;
    END IF;
	
	SET @table_name = CONCAT(site_schema,'.wp_options');
	SET @sql_text = CONCAT('INSERT INTO tmp_feedwordpress_munge_permalink (site, permalink) VALUES ("',site_schema,'",(
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

