DROP PROCEDURE IF EXISTS auto_zaplecza_pass_change;
DROP PROCEDURE IF EXISTS auto_zaplecza_pass_change;
DELIMITER //
CREATE PROCEDURE auto_zaplecza_pass_change()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE dbname VARCHAR(50);
  
  DECLARE cur1 CURSOR FOR select table_schema from information_schema.tables where table_name = 'wp_users' and table_schema in('admin_beztabu','z10_miesz','z10_tvser','z11_brachun','z11_nieruch','z11_szkoly','z11_topbu','z11_toppr','z13_twgie','z13_twsur','z13_twwal','z13_wgosp','z14_pdnia','z14_pprze','z15_zmvat','z1_twpit','z2_esppl','z2_inicom','z2_izitpl','z2_pizcom','z2_pizpl','z3_lekari','z5_abcinf','z5_cozpod','z5_newsr','z5_pitcoz','z5_transn','z8_figosp','z8_infzsw','z8_tipsp','z9_plsejm','z9_podem','z9_rfilm','z9_zdrol','zaplecze12_mdzie');
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO dbname;
    IF done THEN
      LEAVE read_loop;
    END IF;
	
	SET @table_name = CONCAT(dbname, '.wp_users');
	SET @sql_text = CONCAT('update ', @table_name, ' set `user_pass` = MD5(  \'infor20!%\' ) where user_nicename like \'%admin%\'');
	PREPARE stmt FROM @sql_text;
	
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
  END LOOP;

  CLOSE cur1;
END //
DELIMITER ;




