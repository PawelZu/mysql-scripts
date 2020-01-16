DROP PROCEDURE IF EXISTS event_DelOldestLinks;
DELIMITER //
CREATE PROCEDURE event_DelOldestLinks()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE site_schema varchar(50);
  DECLARE start_time datetime DEFAULT '2015-03-18 06:00:00';
  
  DECLARE cur1 CURSOR FOR SELECT table_schema FROM information_schema.tables where table_schema like 'ls_%' and table_name = 'link_links';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  
  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO site_schema;
    IF done THEN
      LEAVE read_loop;
    END IF;
    
    SET @sql_text = CONCAT('
DELIMITER //
CREATE EVENT ', site_schema, '.DelOldestLinks ON SCHEDULE EVERY 1 DAY STARTS "', start_time , '" ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
    DELETE FROM ', site_schema, '.link_links WHERE DATEDIFF( NOW() ,  `datadodania` ) >5;
END //
DELIMITER ;
    ');
	/*PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;*/
    
    select @sql_text;
    
    set start_time = start_time + INTERVAL 10 MINUTE;
    
  END LOOP;

  CLOSE cur1;

END //
DELIMITER ;
