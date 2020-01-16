DELETE a,b,c FROM wp_posts a 
LEFT JOIN wp_term_relationships b ON (a.ID = b.object_id)
LEFT JOIN wp_postmeta c ON (a.ID = c.post_id)
WHERE a.post_type = 'revision'



DROP PROCEDURE IF EXISTS delete_revisions_wpmu;
DELIMITER //
CREATE PROCEDURE delete_revisions_wpmu()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE blogId INT;
  
  DECLARE cur1 CURSOR FOR SELECT `blog_id` FROM wp_blogs WHERE blog_id > 1;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO blogId;
    IF done THEN
      LEAVE read_loop;
    END IF;
	
    SET @blogNumber = CONCAT('_', CAST(blogId AS CHAR), '_');
	
    SET @sql_text = CONCAT('DELETE a,b,c FROM wp', @blogNumber, 'posts a LEFT JOIN wp', @blogNumber, 'term_relationships b ON (a.ID = b.object_id) LEFT JOIN wp', @blogNumber, 'postmeta c ON (a.ID = c.post_id) WHERE a.post_type = "revision"');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
    
  END LOOP;

  CLOSE cur1;
  
END //
DELIMITER ;