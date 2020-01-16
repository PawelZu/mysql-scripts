ALTER EVENT `trim_link_links` ON SCHEDULE EVERY 1 DAY STARTS '2014-05-21 21:15:00' ON COMPLETION NOT PRESERVE ENABLE DO CALL trim_link_links




DROP PROCEDURE IF EXISTS trim_link_links;
DELIMITER //
CREATE PROCEDURE trim_link_links()
BEGIN
  DECLARE linkow int;
  DECLARE days int;
	select count(*) into linkow from link_links;
	
	if linkow >= 100000 then
		set days = 1;
	elseif (linkow > 50000 and linkow <= 100000) then
		set days = 2;
	elseif (linkow > 25000 and linkow <= 50000) then
		set days = 3;
	else
		set days = 0;
	END IF;
  
	if days > 0 then
		SET @sql_text = CONCAT('delete from link_links where agentdate < date_sub(now(), interval ', CAST(days AS CHAR),' day)');
		PREPARE stmt FROM @sql_text;

		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
	END IF;
END //
DELIMITER ;