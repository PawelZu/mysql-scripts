DROP PROCEDURE IF EXISTS truncate_all_links_maps;
DELIMITER //
CREATE PROCEDURE truncate_all_links_maps()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE links_db VARCHAR(20);

    DECLARE cur1 CURSOR FOR SELECT table_schema FROM information_schema.tables where table_name like 'link_links';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur1;

    read_loop: LOOP
        FETCH cur1 INTO links_db;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        SET @sql_text = CONCAT('TRUNCATE  ', links_db, '.link_links');
        PREPARE stmt FROM @sql_text;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        
        SET @sql_text = CONCAT('TRUNCATE  ', links_db, '.link_maps');
        PREPARE stmt FROM @sql_text;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END LOOP;
END //
DELIMITER ;