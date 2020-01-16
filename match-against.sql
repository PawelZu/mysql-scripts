SELECT
	post_title,
	post_date,
	ROUND ( MATCH (post_title) AGAINST ('Kwaœniewski: Nie wybieram siê do Parlamentu Europejskiego') ) as x
FROM wp_posts
ORDER BY x DESC, post_date DESC
LIMIT 1, 10


--wyszukiwanie podobnych po tagach
SELECT p.ID,p.post_title,COUNT(*) as ile FROM wp_posts p
JOIN wp_term_relationships tr ON p.ID=tr.object_id
JOIN wp_term_taxonomy tt ON tr.term_taxonomy_id=tt.term_taxonomy_id AND tt.taxonomy='post_tag'
JOIN wp_terms t ON tt.term_id=t.term_id
WHERE t.name IN ('Puls Biznesu','Wall Street','Bronis³aw Komorowski	','Unii Europejskiej','MFW','Ministerstwo Finansów	')
GROUP BY p.ID
ORDER BY ile DESC
LIMIT 5