DROP PROCEDURE IF EXISTS revisionsDelWPMU;
DELIMITER //
CREATE PROCEDURE `revisionsDelWPMU`()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE blogId INT;
  
  DECLARE cur1 CURSOR FOR SELECT blog_id FROM wp_blogs WHERE blog_id > 1;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO blogId;
    IF done THEN
      LEAVE read_loop;
    END IF;
	
	SET @sql_text = CONCAT("DELETE FROM wp_", CAST(blogId AS CHAR), "_posts WHERE post_type='revision'");
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @sql_text2 = CONCAT("DELETE FROM wp_", CAST(blogId AS CHAR), "_term_relationships WHERE object_id NOT IN (SELECT ID FROM wp_", CAST(blogId AS CHAR), "_posts UNION SELECT link_id FROM wp_", CAST(blogId AS CHAR), "_links)");
	PREPARE stmt FROM @sql_text2;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @sql_text3 = CONCAT("DELETE FROM wp_", CAST(blogId AS CHAR), "_postmeta WHERE post_id NOT IN (SELECT ID FROM wp_", CAST(blogId AS CHAR), "_posts)");
	PREPARE stmt FROM @sql_text3;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	 
	SET @sql_text3 = CONCAT("update `wp_term_taxonomy` tt set `count`=( select count(*) as ile from wp_term_relationships tr where tr.`term_taxonomy_id`=tt.`term_taxonomy_id` group by tr.`term_taxonomy_id` )");
	PREPARE stmt FROM @sql_text3;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	 
   END LOOP;

  CLOSE cur1;
END //
DELIMITER ;