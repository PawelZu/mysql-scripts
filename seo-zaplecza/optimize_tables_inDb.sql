DROP PROCEDURE IF EXISTS optimize_tables_inDb;
DELIMITER //
CREATE PROCEDURE optimize_tables_inDb(tableSchema varchar(100))
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE tableName varchar(100);
  DECLARE tableCount int DEFAULT 0;
  
  -- declare the cursor for view which is not exist at that time
  DECLARE cur1 CURSOR FOR SELECT * FROM temprorary_view;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  
  -- dynamic query will built the view
	SET @query = CONCAT('CREATE VIEW temprorary_view AS SELECT table_name FROM information_schema.tables WHERE table_schema = "', tableSchema ,'"'); 
	
	PREPARE stmt from @query; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt;

  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO tableName;
    IF done THEN
      LEAVE read_loop;
    END IF;
	
    SET tableCount = tableCount + 1;
	
    SET @sql_text = CONCAT('OPTIMIZE TABLE ', tableSchema, '.', tableName);
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
    
    select tableName, tableCount;
    
  END LOOP;

  CLOSE cur1;
  
  DROP VIEW temprorary_view;
END //
DELIMITER ;



