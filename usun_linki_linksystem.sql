DROP PROCEDURE IF EXISTS usun_linki_linksystem;
DELIMITER //
CREATE PROCEDURE usun_linki_linksystem()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE baza VARCHAR(100);
  
  DECLARE cur1 CURSOR FOR SELECT table_schema FROM information_schema.tables WHERE table_name='link_anchors';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  TRUNCATE TABLE admin_linki.panel_panel_links;  

  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO baza;
    IF done THEN
      LEAVE read_loop;
    END IF;
	
	SET @sql_text = CONCAT('TRUNCATE TABLE ', baza, '.link_anchors');
	PREPARE stmt FROM @sql_text;
	
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	SET @sql_text = CONCAT('TRUNCATE TABLE ', baza, '.link_links');
	PREPARE stmt FROM @sql_text;
	
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
  END LOOP;

  CLOSE cur1;
END //
DELIMITER ;


call usun_linki_linksystem
