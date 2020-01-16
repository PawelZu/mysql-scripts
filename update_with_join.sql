UPDATE wp_term_relationships tr
JOIN wp_feed_items i ON i.post_ID=tr.object_id
JOIN wp_term_taxonomy tt ON tr.term_taxonomy_id=tt.term_taxonomy_id AND taxonomy='category'
SET tr.term_taxonomy_id=27242
WHERE service_url LIKE  '%smolensk-rocznica-katastrofy%'