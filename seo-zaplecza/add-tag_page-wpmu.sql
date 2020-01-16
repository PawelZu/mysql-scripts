DROP PROCEDURE IF EXISTS add_tag_page_wpmu;
DELIMITER //
CREATE PROCEDURE add_tag_page_wpmu()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE blogId INT;
  DECLARE blogPath  VARCHAR(100);
  DECLARE blogDomain  VARCHAR(100);
  declare tag_page_id int;
  
  DECLARE cur1 CURSOR FOR SELECT `blog_id`, `path`, `domain` FROM wp_blogs WHERE blog_id>1;
  /*DECLARE cur1 CURSOR FOR SELECT `blog_id`, `path`, `domain` FROM wp_blogs WHERE blog_id=109;*/
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO blogId, blogPath, blogDomain;
    IF done THEN
      LEAVE read_loop;
    END IF;
    
    SET @CheckExists = 0;
	
	IF blogId=1 THEN
		SET @blogNumber = '_';
	ELSE
		SET @blogNumber = CONCAT('_', CAST(blogId AS CHAR), '_');
	END IF;
    set @posts_tab = concat('wp', @blogNumber, 'posts');
    set @postMeta_tab = concat('wp', @blogNumber, 'postmeta');
	
    SET @query = concat("SELECT count(*) INTO @CheckExists from ", @posts_tab, " where (post_name='tag' or post_name='tagi' or post_name LIKE 'tag-%') and post_type = 'page' and post_status = 'publish'");
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
	
    IF (@CheckExists < 1) THEN
		SET @sql_text = CONCAT('INSERT INTO ', @posts_tab, ' (post_author, post_title, post_status, comment_status, ping_status, post_name, post_type) VALUES(1, "Tag" ,"publish", "closed", "closed", "tag", "page")');
		PREPARE stmt FROM @sql_text;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
        
		select LAST_INSERT_ID() into tag_page_id;
        
		SET @sql_text = CONCAT('UPDATE ', @posts_tab, ' SET guid="',blogDomain,blogPath,'?page_id=',tag_page_id,'" WHERE ID=', tag_page_id);
		PREPARE stmt FROM @sql_text;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
        
		SET @sql_text = CONCAT('INSERT INTO ', @postMeta_tab, ' (post_id, meta_key, meta_value) VALUES (', tag_page_id,', "_wp_page_template", "tags.php")');
		PREPARE stmt FROM @sql_text;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
        
        select tag_page_id;
        /*select blogId, blogDomain, blogPath, 'nie ma';*/
    /*else
        select blogPath, 'jest';*/
    end if;
    
	
  END LOOP;

  CLOSE cur1;
END //
DELIMITER ;