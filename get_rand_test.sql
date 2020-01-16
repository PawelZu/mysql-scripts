DROP PROCEDURE IF EXISTS get_rand_test;
DELIMITER //
CREATE PROCEDURE get_rand_test()
BEGIN
  DECLARE random FLOAT;
  DECLARE id_rand int;
  DECLARE id_min int;
  DECLARE id_max int;
	SET random = RAND();
	select min(id), max(id) into id_min, id_max from panel_panel_links_bak;
	
	select l.id into id_rand from panel_panel_links_bak l
	where l.id >= (id_max-id_min) * random + id_min
	order by l.id
	limit 1;
	
  
	SET @sql_text = CONCAT('INSERT INTO rand_test (id,rand) VALUES (',id_rand,',',random,')');
	PREPARE stmt FROM @sql_text;

	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
END //
DELIMITER ;