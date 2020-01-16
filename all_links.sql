DROP PROCEDURE IF EXISTS all_links;
DELIMITER //
CREATE PROCEDURE all_links()
BEGIN
  SELECT table_schema, TABLE_ROWS FROM information_schema.tables where table_name like 'link_links' group by table_schema order by TABLE_ROWS desc;
END //
DELIMITER ;
