delete p.*, tr.*
FROM `wp_posts` p
JOIN wp_term_relationships tr ON tr.object_id = p.ID
WHERE tr.term_taxonomy_id =170