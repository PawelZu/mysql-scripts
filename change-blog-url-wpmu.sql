DROP PROCEDURE IF EXISTS change_blog_url_wpmu;
DELIMITER //
CREATE PROCEDURE change_blog_url_wpmu(obecnyUrl VARCHAR(50), nowyUrl VARCHAR(255))
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE blogId INT;
  DECLARE blogPath  VARCHAR(100);
  
  DECLARE cur1 CURSOR FOR SELECT `blog_id`, `path` FROM wp_blogs;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO blogId, blogPath;
    IF done THEN
      LEAVE read_loop;
    END IF;
	
	IF blogId=1 THEN
		SET @blogNumber = '_';
	ELSE
		SET @blogNumber = CONCAT('_', CAST(blogId AS CHAR), '_');
	END IF;
	
	SET @sql_text = CONCAT('UPDATE wp', @blogNumber, 'options SET option_value=REPLACE(option_value, "', obecnyUrl,'", "', nowyUrl,'")');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	-- SET @sql_text = CONCAT('UPDATE wp', @blogNumber, 'posts SET guid=concat("http://', nowyUrl, blogPath, '", post_name) where post_type="post"');
	-- PREPARE stmt FROM @sql_text;
	-- EXECUTE stmt;
	-- DEALLOCATE PREPARE stmt;
	SET @sql_text = CONCAT('UPDATE wp', @blogNumber, 'posts SET guid=REPLACE(guid, "', obecnyUrl,'", "', nowyUrl,'")');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	SET @sql_text = CONCAT('UPDATE wp', @blogNumber, 'postmeta SET meta_value=REPLACE(meta_value, "', obecnyUrl,'", "', nowyUrl,'")');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
  END LOOP;

  CLOSE cur1;
END //
DELIMITER ;








change_blog_url_wpmu('izit.pl','przedsiebiorcaonline.pl')