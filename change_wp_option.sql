DROP PROCEDURE IF EXISTS change_wp_option;
DELIMITER //
CREATE PROCEDURE change_wp_option()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE db_n VARCHAR(30);
  DECLARE table_n VARCHAR(30);
  
  DECLARE cur1 CURSOR FOR SELECT table_schema, table_name FROM information_schema.tables WHERE table_name LIKE '%_options' AND table_schema NOT IN ('admin_foto','admin_infor','z12_mdzi','z12_mfors','zaplecze3_agger','zaplecze6_willa');
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO db_n, table_n;
    IF done THEN
      LEAVE read_loop;
    END IF;
	
	SET @sql_text = CONCAT('UPDATE ', db_n,'.',table_n, ' SET `option_value` =  \'yes\'  WHERE option_name=\'feedwordpress_update_minimum\'');
	PREPARE stmt FROM @sql_text;
	
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
  END LOOP;

  CLOSE cur1;
END //
DELIMITER ;