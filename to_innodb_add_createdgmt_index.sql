DROP PROCEDURE IF EXISTS to_innodb;
DELIMITER //
CREATE PROCEDURE to_innodb()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE table_n VARCHAR(100);
  
  DECLARE cur1 CURSOR FOR SELECT table_name FROM information_schema.tables WHERE table_schema='admin_linki' AND `ENGINE`='MyISAM';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO table_n;
    IF done THEN
      LEAVE read_loop;
    END IF;
	
	SET @sql_text = CONCAT('ALTER TABLE ', table_n, ' ENGINE = INNODB');
	PREPARE stmt FROM @sql_text;
	
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
  END LOOP;

  CLOSE cur1;
END //
DELIMITER ;



DROP PROCEDURE IF EXISTS to_myisam;
DELIMITER //
CREATE PROCEDURE to_myisam(baza VARCHAR(100))
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE table_n VARCHAR(100);
  
  
  DECLARE cur1 CURSOR FOR SELECT table_name FROM information_schema.tables WHERE table_schema=@baza AND `ENGINE`='INNODB';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO table_n;
    IF done THEN
      LEAVE read_loop;
    END IF;
	
	SET @sql_text = CONCAT('ALTER TABLE ', baza, '.', table_n, ' ENGINE = MyISAM');
	PREPARE stmt FROM @sql_text;
	
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
  END LOOP;

  CLOSE cur1;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS add_index;
DELIMITER //
CREATE PROCEDURE zaplecze2_pizpl.add_index()
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

	SET @table_name = CONCAT('wp_', CAST(site_id AS CHAR), '_posts');
	
	IF((SELECT COUNT(*) AS index_exists FROM information_schema.statistics 
		WHERE TABLE_SCHEMA = DATABASE()
		and table_name = @table_name
		AND index_name = 'status_modifiedgmt') = 0) THEN
			SET @sql_text = CONCAT('ALTER TABLE ', @table_name, ' ADD INDEX  `status_modifiedgmt` (`post_status`, `post_modified_gmt`)');
			PREPARE stmt FROM @sql_text;
			
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;
	END IF;
	
  END LOOP;

  CLOSE cur1;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS drop_index;
DELIMITER //
CREATE PROCEDURE drop_index()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE baza VARCHAR(25);
  DECLARE tabela VARCHAR(25);
  
  DECLARE cur1 CURSOR FOR SELECT TABLE_SCHEMA, TABLE_NAME FROM information_schema.tables where table_name like '%_posts';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO baza, tabela;
    IF done THEN
      LEAVE read_loop;
    END IF;
	
	IF((SELECT COUNT(*) AS index_exists FROM information_schema.statistics 
		WHERE TABLE_SCHEMA = baza
		and table_name = tabela
		AND index_name = 'post_status') > 0) THEN
			SET @sql_text = CONCAT('DROP INDEX post_status ON ', baza, '.', tabela);
			PREPARE stmt FROM @sql_text;
			
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;
	END IF;
	
  END LOOP;

  CLOSE cur1;
END //
DELIMITER ;
