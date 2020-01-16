DROP PROCEDURE IF EXISTS clean_wp_posts_proc;
DELIMITER //
CREATE PROCEDURE clean_wp_posts_proc()
BEGIN
	CREATE TEMPORARY TABLE postsTmp (
		SELECT * FROM `wp_posts` WHERE post_type='aktualnosci' group by post_title
	);
	
	DELETE FROM wp_posts WHERE post_type='aktualnosci';
	
	INSERT INTO wp_posts (select * from postsTmp);
	
	DELETE FROM wp_postmeta WHERE post_id NOT IN (SELECT ID FROM wp_posts);
	DELETE FROM wp_term_relationships
		WHERE object_id NOT IN (SELECT ID FROM wp_posts)
		AND object_id NOT IN (SELECT link_id FROM wp_links);
		
	update wp_term_taxonomy tt set count=(
		select count(*) as ile from wp_term_relationships tr
		where tr.term_taxonomy_id=tt.term_taxonomy_id
		group by tr.term_taxonomy_id
	);
	
	OPTIMIZE TABLE wp_postmeta;
	OPTIMIZE TABLE wp_term_relationships;
END //
DELIMITER ;





DROP PROCEDURE IF EXISTS clean_wp_posts_proc;
DELIMITER //
CREATE PROCEDURE clean_wp_posts_proc()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE blogId VARCHAR(50);
  
  DECLARE cur1 CURSOR FOR SELECT blog_id FROM wp_blogs WHERE blog_id>1;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO blogId;
    IF done THEN
      LEAVE read_loop;
    END IF;
	
	SET @sql_text = CONCAT('CREATE TEMPORARY TABLE postsTmp ( SELECT * FROM wp_', blogId, '_posts WHERE post_type="post" group by post_title )');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	SET @sql_text = CONCAT('DELETE FROM wp_', blogId, '_posts WHERE post_type="post" OR post_type="revision"');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	SET @sql_text = CONCAT('INSERT INTO wp_', blogId, '_posts (select * from postsTmp)');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	SET @sql_text = CONCAT('DELETE FROM wp_', blogId, '_postmeta WHERE post_id NOT IN (SELECT ID FROM wp_', blogId, '_posts)');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	SET @sql_text = CONCAT('DELETE FROM wp_', blogId, '_term_relationships WHERE object_id NOT IN (SELECT ID FROM wp_', blogId, '_posts) AND object_id NOT IN (SELECT link_id FROM wp_', blogId, '_links)');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	SET @sql_text = CONCAT('update wp_', blogId, '_term_taxonomy tt set count=( select count(*) as ile from wp_', blogId, '_term_relationships tr where tr.term_taxonomy_id=tt.term_taxonomy_id group by tr.term_taxonomy_id )');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	SET @sql_text = CONCAT('DROP TEMPORARY TABLE postsTmp');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	SET @sql_text = CONCAT('OPTIMIZE TABLE wp_', blogId, '_postmeta');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	SET @sql_text = CONCAT('OPTIMIZE TABLE wp_', blogId, '_term_relationships');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	SET @sql_text = CONCAT('OPTIMIZE TABLE wp_', blogId, '_posts');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
  END LOOP;

  CLOSE cur1;
END //
DELIMITER ;