DROP PROCEDURE IF EXISTS trim_link_links;
DELIMITER //
CREATE PROCEDURE trim_link_links()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE baza VARCHAR(50);
  DECLARE date_substr DATETIME DEFAULT DATE_SUB(now(), interval 3 day);
  
  DECLARE cur1 CURSOR FOR SELECT TABLE_SCHEMA FROM information_schema.tables WHERE TABLE_NAME = 'link_links';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO baza;
    IF done THEN
      LEAVE read_loop;
    END IF;
	
	SET @sql_text = CONCAT('DELETE from ', baza, '.link_links WHERE agentdate < "', date_substr, '"');
	PREPARE stmt FROM @sql_text;
	
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
  END LOOP;

  CLOSE cur1;
END //
DELIMITER ;