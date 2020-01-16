DROP PROCEDURE IF EXISTS create_view;
DELIMITER //
CREATE PROCEDURE create_view()
BEGIN
  DECLARE db_name VARCHAR(100);
  DECLARE done INT DEFAULT FALSE;
  DECLARE table_n VARCHAR(100);
  
  DECLARE cur1 CURSOR FOR
		select TABLE_SCHEMA from information_schema.tables
		where table_name like 'wp_%'
		and TABLE_SCHEMA not in('zaplecze6_willa','admin_foto','admin_infor','admin_mforsal','zaplecze1_twpit','zaplecze1_wpracy','zaplecze2_esppl','zaplecze2_inicpl','zaplecze2_izitpl','zaplecze2_pizpl','zaplecze3_agger')
		group by TABLE_SCHEMA;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO db_name;
    IF done THEN
      LEAVE read_loop;
    END IF;
	
	IF(NOT EXISTS(SELECT TABLE_NAME FROM information_schema.tables WHERE (TABLE_NAME='top500tags' OR TABLE_NAME='top1000tags') AND TABLE_SCHEMA=db_name)) THEN

		SET @sql_text = CONCAT('CREATE VIEW `',db_name,'`.top1000tags AS
									select slug,name,count
									from `',db_name,'`.wp_term_taxonomy
									join `',db_name,'`.wp_terms on wp_term_taxonomy.term_id=wp_terms.term_id
									where taxonomy = "post_tag"
									order by count desc
									limit 1000');

		PREPARE stmt FROM @sql_text;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

	END IF;
  END LOOP;

  CLOSE cur1;
END //
DELIMITER ;




DROP PROCEDURE IF EXISTS create_view_multisite;
DELIMITER //
CREATE PROCEDURE create_view_multisite()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE table_n VARCHAR(100);
  DECLARE db_name VARCHAR(100) DEFAULT 'zaplecze1_twpit';
  
  DECLARE cur1 CURSOR FOR SELECT blog_id FROM zaplecze1_twpit.wp_blogs WHERE blog_id>1;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO table_n;
    IF done THEN
      LEAVE read_loop;
    END IF;

	SET @top1000tags = CONCAT('wp_',table_n,'_top1000tags');
	SET @wp_term_taxonomy = CONCAT('wp_',table_n,'_term_taxonomy');
	SET @wp_terms = CONCAT('wp_',table_n,'_terms');
	
	IF(NOT EXISTS(SELECT TABLE_NAME FROM information_schema.tables
					WHERE TABLE_NAME=@top1000tags
					AND TABLE_SCHEMA=db_name)) THEN
		SET @sql_text = CONCAT('CREATE VIEW `',db_name,'`.',@top1000tags,' AS
										SELECT slug,name,count
										FROM `',db_name,'`.',@wp_term_taxonomy,'
										JOIN `',db_name,'`.',@wp_terms,' ON ',@wp_term_taxonomy,'.term_id=',@wp_terms,'.term_id
										WHERE taxonomy = "post_tag"
										ORDER BY count desc
										LIMIT 1000');
		
		PREPARE stmt FROM @sql_text;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
	END IF;
  END LOOP;

  CLOSE cur1;

END //
DELIMITER ;




DROP PROCEDURE IF EXISTS drop_view;
DELIMITER //
CREATE PROCEDURE drop_view()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE db_name VARCHAR(100);
  
  DECLARE cur1 CURSOR FOR select TABLE_SCHEMA from information_schema.tables WHERE TABLE_SCHEMA like 'zaplecze13_%' and table_name='top1000tags';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO db_name;
    IF done THEN
      LEAVE read_loop;
    END IF;


	IF(EXISTS(SELECT TABLE_NAME FROM information_schema.tables
					WHERE TABLE_NAME='top1000tags'
					AND TABLE_SCHEMA=db_name)) THEN
		SET @sql_text = CONCAT('DROP VIEW ', db_name, '.', 'top1000tags');
		
		PREPARE stmt FROM @sql_text;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
	END IF;
  END LOOP;

  CLOSE cur1;

END //
DELIMITER ;

call drop_view;




DROP PROCEDURE IF EXISTS drop_view_multisite;
DELIMITER //
CREATE PROCEDURE drop_view_multisite()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE table_n VARCHAR(100);
  DECLARE db_name VARCHAR(100) DEFAULT 'zaplecze1_twpit';
  
  DECLARE cur1 CURSOR FOR SELECT blog_id FROM zaplecze1_twpit.wp_blogs WHERE blog_id>1;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO table_n;
    IF done THEN
      LEAVE read_loop;
    END IF;

	SET @top1000tags = CONCAT('wp_',table_n,'_top1000tags');

	IF(EXISTS(SELECT TABLE_NAME FROM information_schema.tables
					WHERE TABLE_NAME=@top1000tags
					AND TABLE_SCHEMA=db_name)) THEN
		SET @sql_text = CONCAT('DROP VIEW ', db_name, '.', @top1000tags);
		
		PREPARE stmt FROM @sql_text;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
	END IF;
  END LOOP;

  CLOSE cur1;

END //
DELIMITER ;

call drop_view_multisite;