SELECT tr.*, tt.* FROM  `wp_term_relationships` tr
JOIN wp_posts p ON tr.`object_id` = p.ID AND p.post_type =  'post'
JOIN wp_term_taxonomy tt ON tr.`term_taxonomy_id`=tt.`term_taxonomy_id` AND tt.taxonomy = 'post_tag'


DROP PROCEDURE uslugi;
DELIMITER //
CREATE PROCEDURE uslugi()
BEGIN
DECLARE done INT DEFAULT FALSE;
DECLARE taxonomy_id INT;
DECLARE id INT;
DECLARE taxonomy_id_new INT;

DECLARE cur1 CURSOR FOR SELECT tr.term_taxonomy_id, tt.term_id FROM wp_term_relationships_tmp tr JOIN wp_term_taxonomy_tmp tt USING(term_taxonomy_id) GROUP BY tr.term_taxonomy_id;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

OPEN cur1;

read_loop: LOOP
	FETCH cur1 INTO taxonomy_id, id;
	IF done THEN
	  LEAVE read_loop;
	END IF;

	INSERT INTO wp_term_taxonomy_tmp (term_taxonomy_id, term_id, taxonomy, description, parent, count) VALUES(NULL, id, "uslugi", "", 0, 0);
	
	SELECT LAST_INSERT_ID() INTO taxonomy_id_new;

	UPDATE wp_term_relationships_tmp SET term_taxonomy_id = taxonomy_id_new WHERE term_taxonomy_id = taxonomy_id;
END LOOP;

CLOSE cur1;
END //
DELIMITER ;