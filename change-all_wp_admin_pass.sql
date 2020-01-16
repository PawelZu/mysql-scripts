DROP PROCEDURE IF EXISTS change_all_wp_admin_pass;
DELIMITER //
CREATE PROCEDURE change_all_wp_admin_pass()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE db_n VARCHAR(30);
  
  DECLARE cur1 CURSOR FOR select table_schema from information_schema.tables where table_schema not in('information_schema','admin_autolinks','admin_foto','admin_infor','admin_linxb','admin_pawel','admin_piwik','admin_piwik2','da_atmail','da_roundcube','movedb','mysql','performance_schema','test','zaplecze3_agger','zaplecze6_willa','zaplecze7_efront','zaplecze7_webtol') and table_name='wp_users' group by table_schema;
  
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO db_n;
    IF done THEN
      LEAVE read_loop;
    END IF;
	
	SET @sql_text = CONCAT('UPDATE ', db_n,'.wp_users SET `user_pass` = MD5(  \'@dmin|nf0r153\' ) WHERE ID=1 or user_login=\'admin\'');
	PREPARE stmt FROM @sql_text;
	
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
  END LOOP;

  CLOSE cur1;
END //
DELIMITER ;




select * from `wp_users` WHERE  `wp_users`.`ID` =1 or user_login='admin';