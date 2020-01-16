DROP PROCEDURE IF EXISTS change_theme_wpmu;
DELIMITER //
CREATE PROCEDURE change_theme_wpmu(
                                    themeName VARCHAR(50),
                                    themeNameToLower VARCHAR(50),
                                    theme_modsName VARCHAR(50),
                                    theme_modsValue VARCHAR(255)
                                )
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE site_id INT;
  
  DECLARE cur1 CURSOR FOR SELECT blog_id FROM wp_blogs WHERE blog_id > 1;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO site_id;
    IF done THEN
      LEAVE read_loop;
    END IF;
	
	SET @table_name = CONCAT('wp_', CAST(site_id AS CHAR), '_options');

	SET @sql_text = CONCAT('UPDATE ', @table_name, ' SET option_value="', themeName, '" WHERE option_name="current_theme"');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @sql_text = CONCAT('UPDATE ', @table_name, ' SET option_value="', themeNameToLower, '" WHERE option_name="stylesheet"');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @sql_text = CONCAT('UPDATE ', @table_name, ' SET option_value="', themeNameToLower, '" WHERE option_name="template"');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @sql_text = CONCAT('INSERT IGNORE INTO ', @table_name, ' (option_name, option_value, autoload) VALUES("',theme_modsName,'","',theme_modsValue,'","yes")');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
  END LOOP;

  CLOSE cur1; select 'ok';
END //
DELIMITER ;



   
   

call change_theme_wpmu('ChaosTheory','chaostheory','theme_mods_chaostheory','a:1:{i:0;b:0;}')