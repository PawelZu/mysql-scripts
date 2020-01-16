SELECT *
FROM panel_panel_links l
JOIN panel_panel_links_dates d ON l.id = d.link_id
WHERE DATEDIFF( NOW( ) , d.date ) >5;

SELECT * FROM panel_panel_links_dates WHERE link_id NOT IN (
  SELECT id FROM panel_panel_links
);



DELETE l.*, d.* FROM panel_panel_links l
JOIN panel_panel_links_dates d ON l.id=d.link_id
WHERE DATEDIFF(NOW(), d.date) > 5;

DELETE FROM panel_panel_links_dates WHERE link_id NOT IN (
  SELECT id FROM panel_panel_links
);



DELIMITER $$
CREATE EVENT DelOldestLinks ON SCHEDULE EVERY 1 DAY STARTS '2017-07-11 18:00:01'
DO BEGIN

DELETE l.*, d.* FROM panel_panel_links l
JOIN panel_panel_links_dates d ON l.id=d.link_id
WHERE DATEDIFF(NOW(), d.date) > 5;

DELETE FROM panel_panel_links_dates WHERE link_id NOT IN (
  SELECT id FROM panel_panel_links
);

END
$$
DELIMITER ;
