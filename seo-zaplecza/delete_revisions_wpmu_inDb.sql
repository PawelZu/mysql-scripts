DROP PROCEDURE IF EXISTS delete_revisions_wpmu_inDb;
DELIMITER //
CREATE PROCEDURE delete_revisions_wpmu_inDb(dbName varchar(100))
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE blogId INT;
  DECLARE blogCount int DEFAULT 0;

  DECLARE cur1 CURSOR FOR SELECT * FROM temprorary_view;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	
    SET @query = CONCAT('CREATE VIEW temprorary_view AS SELECT blog_id FROM ', dbName, '.wp_blogs WHERE blog_id > 1'); 
	
	PREPARE stmt from @query; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt;
    
  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO blogId;
    IF done THEN
      LEAVE read_loop;
    END IF;
    
    SET blogCount = blogCount + 1;
	
    SET @blogNumber = CONCAT('_', CAST(blogId AS CHAR), '_');
	
    SET @sql_text = CONCAT('DELETE a,b,c FROM ', dbName, '.wp', @blogNumber, 'posts a LEFT JOIN ', dbName, '.wp_term_relationships b ON (a.ID = b.object_id) LEFT JOIN ', dbName, '.wp_postmeta c ON (a.ID = c.post_id) WHERE a.post_type = "revision"');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
    
    select blogCount;
    
  END LOOP;

  CLOSE cur1;
  
  DROP VIEW temprorary_view;
END //
DELIMITER ;


