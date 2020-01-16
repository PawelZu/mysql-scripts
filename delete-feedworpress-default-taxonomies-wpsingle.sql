DROP PROCEDURE IF EXISTS del_feedwp_tax;
DELIMITER //
CREATE PROCEDURE del_feedwp_tax()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE db VARCHAR(30);
  
  DECLARE cur1 CURSOR FOR SELECT TABLE_SCHEMA FROM information_schema.tables WHERE TABLE_NAME = 'wp_options' AND TABLE_SCHEMA NOT IN ('z11_nieruch','z11_szkoly','z11_topbu','z3_lekari','z11_toppr','z2_pizcom','z2_pizpl','z5_pitcoz','z2_izitpl','z2_esppl','z1_twpit');
  /*DECLARE cur1 CURSOR FOR SELECT TABLE_SCHEMA FROM information_schema.tables WHERE TABLE_NAME = 'wp_options' AND TABLE_SCHEMA IN ('z5_abcinf');*/
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  CREATE TEMPORARY TABLE IF NOT EXISTS mytmptab (ile INT, tbl VARCHAR(30));

  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO db;
    IF done THEN
      LEAVE read_loop;
    END IF;
	
	SET @is_feedwp := 0;
	
	SET @sql_text = CONCAT('SELECT count(*) INTO @is_feedwp FROM ', db,'.wp_options WHERE `option_name` LIKE \'feedwordpress%\' LIMIT 1');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	IF @is_feedwp > 0 THEN
		SET @sql_text = CONCAT('DELETE FROM ', db, '.wp_options WHERE option_name="feedwordpress_syndication_cats"');
		PREPARE stmt FROM @sql_text;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
		
		SET @sql_text = CONCAT('insert into ', db, '.wp_options (option_name, option_value, autoload) values (\'feedwordpress_match_cats\', \'a:1:{i:0;s:1:"0";}\', \'yes\'),(\'feedwordpress_match_filter\', \'a:1:{i:0;s:1:"0";}\', \'yes\'),(\'feedwordpress_match_tags\', \'a:1:{i:0;s:1:"0";}\', \'yes\') ON DUPLICATE KEY UPDATE option_value=\'a:1:{i:0;s:1:"0";}\'');
		PREPARE stmt FROM @sql_text;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
		
		SET @sql_text = CONCAT('insert into ', db, '.wp_options (option_name, option_value, autoload) values (\'feedwordpress_unfamiliar_category\', \'null\', \'yes\'),(\'feedwordpress_unfamiliar_post_tag\', \'null\', \'yes\') ON DUPLICATE KEY UPDATE option_value=\'null\'');
		PREPARE stmt FROM @sql_text;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
		
		SET @sql_text = CONCAT('DELETE FROM ', db, '.wp_term_relationships WHERE term_taxonomy_id=1');
		PREPARE stmt FROM @sql_text;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
		
		SET @sql_text = CONCAT('UPDATE ', db, '.wp_term_taxonomy SET count=0 WHERE term_taxonomy_id=1');
		PREPARE stmt FROM @sql_text;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
		
		SET @sql_text = CONCAT('UPDATE ', db,'.wp_options SET `option_value` =  \'720\'  WHERE option_name=\'feedwordpress_update_window\'');
		PREPARE stmt FROM @sql_text;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
		
		SET @sql_text2 = CONCAT('INSERT INTO mytmptab (ile,tbl) VALUES (',@is_feedwp,', \'',db,'\')');
		PREPARE stmt2 FROM @sql_text2;
		EXECUTE stmt2;
		DEALLOCATE PREPARE stmt2;
	END IF;
	
  END LOOP;

  CLOSE cur1;
  
  select * from mytmptab;
  DROP TEMPORARY TABLE mytmptab;
END //
DELIMITER ;
