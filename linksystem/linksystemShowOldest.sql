DROP PROCEDURE IF EXISTS linksystemShowOldest;
DELIMITER //
CREATE PROCEDURE linksystemShowOldest()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE site_schema varchar(50);
  DECLARE ile INT(9);
  
  DECLARE cur1 CURSOR FOR SELECT table_schema FROM information_schema.tables where table_schema like 'ls_%' and table_name = 'link_links';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  
  DROP TEMPORARY TABLE IF EXISTS oldestLinksTmp;
  CREATE TEMPORARY TABLE oldestLinksTmp (
		table_schema varchar(50),
        oldest_link datetime,
        linkow int(9)
	);

  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO site_schema;
    IF done THEN
      LEAVE read_loop;
    END IF;
    
	SET @sql_text = CONCAT('INSERT INTO oldestLinksTmp (
                                SELECT "',site_schema,'", MIN(datadodania), COUNT(*) FROM ', site_schema, '.link_links
                            )');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
  END LOOP;

  CLOSE cur1;
  
  SELECT SUM(linkow) INTO ile FROM oldestLinksTmp;
  
  /* order by nie działa z rollup 
  SELECT * FROM (
    SELECT table_schema,oldest_link,SUM(linkow) FROM oldestLinksTmp GROUP BY table_schema WITH ROLLUP LIMIT 100
  ) a ORDER BY ISNULL(oldest_link);*/
  
  SELECT * FROM oldestLinksTmp
  UNION
  SELECT 'SUMA', 'X', ile
  ORDER BY 2;
END //
DELIMITER ;
