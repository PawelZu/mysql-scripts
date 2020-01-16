DROP PROCEDURE IF EXISTS linksystemDelOldest;
DELIMITER //
CREATE PROCEDURE linksystemDelOldest()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE site_schema varchar(50);
  
  DECLARE cur1 CURSOR FOR SELECT table_schema FROM information_schema.tables where table_schema like 'ls_%' and table_name = 'link_links';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  
  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO site_schema;
    IF done THEN
      LEAVE read_loop;
    END IF;
    
	SET @sql_text = CONCAT('DELETE FROM ', site_schema, '.link_links WHERE DATEDIFF( NOW() ,  `datadodania` ) >5');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
  END LOOP;

  CLOSE cur1;

END //
DELIMITER ;
