DELIMITER $$
CREATE TRIGGER trig_panel_panel_links_insert 
    AFTER INSERT ON panel_panel_links
    FOR EACH ROW 
BEGIN
    INSERT INTO panel_panel_links_dates
    (`link_id`, `date`) VALUES (NEW.id, NOW()); 
END$$
DELIMITER ;


DELIMITER $$
CREATE TRIGGER trig_panel_panel_links_delete
    AFTER DELETE ON panel_panel_links
    FOR EACH ROW 
BEGIN
    DELETE FROM panel_panel_links_dates
    WHERE `link_id` = OLD.id; 
END$$
DELIMITER ;