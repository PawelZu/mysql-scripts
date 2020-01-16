SELECT p.post_title, p.post_excerpt, p.guid, ph.url AS photo_url
FROM wp_posts p
JOIN wp_feed_post_photos pp ON p.ID = pp.post_ID
JOIN wp_feed_photos ph ON pp.photo_id = ph.id
WHERE post_type = 'post'
AND post_status = 'publish'
AND pp.main_photo =1
AND EXISTS (
                                                        SELECT 1 FROM wp_term_relationships tr
                                                        INNER JOIN wp_term_taxonomy tt ON tr.term_taxonomy_id = tt.term_taxonomy_id
                                                        AND tt.taxonomy =  'category'
                                                        INNER JOIN wp_terms t ON t.term_id = tt.term_id
                                                        AND t.slug
                                                        IN (
                                                         'wiadomosci'
                                                        )
                                                        WHERE tr.object_id = p.ID
                                                )
ORDER BY p.post_date DESC
LIMIT 4 